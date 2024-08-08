# WHAT IS THE TOTAL AMOUNT EACH CUSTOMER SPENT AT THE RESTAURANT?
#-->

SELECT 
	S.CUSTOMER_ID AS CUSTOMER,
	M.PRICE AS TOTAL_AMOUNT
FROM 
	SALES AS S
JOIN 
	MENU AS M
ON
	S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 
	S.CUSTOMER_ID;
    
# How many days has each customer visited the restaurant?
#->

SELECT
	CUSTOMER_ID AS CUSTOMER,
    COUNT(ORDER_DATE) AS DAYS
FROM
	SALES
GROUP BY
	CUSTOMER;

# What was the first item from the menu purchased by each customer?
#->

SELECT * FROM
(
	SELECT
	S.CUSTOMER_ID, M.PRODUCT_NAME,
	ROW_NUMBER() OVER(PARTITION BY S.CUSTOMER_ID) AS SERIAL
	FROM
	SALES S
	JOIN
	MENU M
	ON
	S.PRODUCT_ID = M.PRODUCT_ID
) X
WHERE X.SERIAL < 2;


# What is the most purchased item on the menu and how many times was it purchased by all customers?
#->

SELECT
	S.CUSTOMER_ID, M.PRODUCT_NAME AS ITEM_NAME,
    ROW_NUMBER() OVER(PARTITION BY M.PRODUCT_NAME) AS NUMBERING
FROM
	MENU AS M
JOIN
	SALES AS S
ON
	S.PRODUCT_ID = M.PRODUCT_ID
ORDER BY
NUMBERING DESC;

# Which item was the most popular for each customer?
#->
SELECT CUSTOMER_ID AS CUSTOMER, ITEM_NAME AS POPULAR_ITEM FROM
(
SELECT
	S.CUSTOMER_ID, M.PRODUCT_NAME AS ITEM_NAME, COUNT(M.PRODUCT_ID) AS ORDER_COUNT,
    DENSE_RANK() OVER(PARTITION BY S.CUSTOMER_ID ORDER BY COUNT(S.CUSTOMER_ID) DESC) AS NUMBERING
FROM
	MENU AS M
JOIN
	SALES AS S
ON
	S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY
S.CUSTOMER_ID, M.PRODUCT_ID
) X
WHERE NUMBERING = 1;

# Which item was purchased first by the customer after they became a member?
#->

SELECT X.CUSTOMER_ID, U.PRODUCT_NAME FROM
(
SELECT S.CUSTOMER_ID, S.PRODUCT_ID,
ROW_NUMBER() OVER(PARTITION BY S.PRODUCT_ID) AS FIRST_ORDER
FROM SALES S
JOIN MEMBERS M
ON S.CUSTOMER_ID = M.CUSTOMER_ID
WHERE S.ORDER_DATE > M.JOIN_DATE
) X
JOIN MENU U
ON U.PRODUCT_ID = X.PRODUCT_ID
WHERE X.FIRST_ORDER = 1;

# Which item was purchased just before the customer became a member?
#->

SELECT * FROM
(
SELECT *,
RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS ORDERED_BEFORE
FROM
(
SELECT S.CUSTOMER_ID, S.ORDER_DATE, S.PRODUCT_ID
FROM SALES S
JOIN MEMBERS M
ON S.CUSTOMER_ID = M.CUSTOMER_ID
WHERE S.ORDER_DATE < M.JOIN_DATE
) X
) Y
WHERE ORDERED_BEFORE = 1;

# What is the total items and amount spent for each member before they became a member?
#->
SELECT 
  sales.customer_id, 
  COUNT(sales.product_id) AS total_items, 
  SUM(menu.price) AS total_sales
FROM dannys_dinner.sales
INNER JOIN dannys_dinner.members
  ON sales.customer_id = members.customer_id
  AND sales.order_date < members.join_date
INNER JOIN dannys_dinner.menu
  ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id;

# If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
#->
WITH points_cte AS (
  SELECT 
    menu.product_id, 
    CASE
      WHEN product_id = 1 THEN price * 20
      ELSE price * 10 END AS points
  FROM dannys_dinner.menu
)

SELECT 
  sales.customer_id, 
  SUM(points_cte.points) AS total_points
FROM dannys_dinner.sales
INNER JOIN points_cte
  ON sales.product_id = points_cte.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id;

# In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
#->
WITH dates_cte AS (
  SELECT 
    customer_id, 
      join_date, 
      join_date + 6 AS valid_date, 
      DATE_TRUNC(
        'month', DATE'2021-01-31')
        + interval '1 month' 
        - interval '1 day' AS last_date
  FROM dannys_dinner.members
)

SELECT 
  sales.customer_id, 
  SUM(CASE
    WHEN menu.product_name = 'sushi' THEN 2 * 10 * menu.price
    WHEN sales.order_date BETWEEN dates.join_date AND dates.valid_date THEN 2 * 10 * menu.price
    ELSE 10 * menu.price END) AS points
FROM dannys_dinner.sales
INNER JOIN dates_cte AS dates
  ON sales.customer_id = dates.customer_id
  AND dates.join_date <= sales.order_date
  AND sales.order_date <= dates.last_date
INNER JOIN dannys_dinner.menu
  ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;
