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

# If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
#->

# In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
#->
