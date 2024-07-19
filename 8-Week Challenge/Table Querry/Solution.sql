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

SELECT
	S.CUSTOMER_ID AS CUSTOMER,
    M.PRODUCT_NAME AS FOOD_ITEM
FROM
	SALES AS S
JOIN
	MENU AS M
ON
	S.PRODUCT_ID = M.PRODUCT_ID
WHERE 
	RANK = 1;
    
# What is the most purchased item on the menu and how many times was it purchased by all customers?
#->

SELECT
	M.PRODUCT_NAME AS ITEM_NAME
FROM
	MENU AS M
JOIN
	SALES AS S
ON
	S.PRODUCT_ID = M.PRODUCT_ID
WHERE
	S.ORDER_DATE = 

# Which item was the most popular for each customer?
#->

# Which item was purchased first by the customer after they became a member?
#->

# Which item was purchased just before the customer became a member?
#->

# What is the total items and amount spent for each member before they became a member?
#->

# If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
#->

# In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
#->