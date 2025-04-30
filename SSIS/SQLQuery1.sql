--Create database
CREATE DATABASE financial_transactions_db;
USE financial_transactions_db;

--Create Table
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount DECIMAL(10, 2),
    currency VARCHAR(10)
);

--Insert sample Data
INSERT INTO financial_transactions (transaction_id, customer_id, supplier_name, transaction_date, amount, currency)
VALUES
    (1, 101, 'ABC Corp', '2024-01-15', 1000.00, 'USD'),
    (2, 102, 'XYZ Ltd', '2024-01-20', 1500.50, 'EUR'),
    (3, 103, 'Global Inc', '2024-02-05', 2000.00, 'GBP'),
    (4, 104, 'ABC Corp', '2024-02-10', 500.25, 'USD');

select * from financial_transactions;

--Create Customer Detail Table
CREATE TABLE customer_details (
	customer_id INT PRIMARY KEY,
	customer_name VARCHAR(50),
	email VARCHAR(100),
	phone VARCHAR(20)
);
select * from customer_details;

--Insert some data into the new table
INSERT INTO customer_details (customer_id, customer_name, email, phone)
VALUES
    (101, 'John Doe', 'john.doe@example.com', '123-456-7890'),
    (102, 'Jane Smith', 'jane.smith@example.com', '234-567-8901'),
    (103, 'Mike Johnson', 'mike.johnson@example.com', '345-678-9012'),
    (104, 'Emily Davis', 'emily.davis@example.com', '456-789-0123');

--Create Data Warehouse Database
CREATE DATABASE financial_data_warehouse;

USE financial_data_warehouse;

--Create Financial Analysis Table
CREATE TABLE financial_analysis (
    transaction_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount_usd DECIMAL(10, 2),
    supplier_phone VARCHAR(20)
);

select * from financial_analysis;
select * from financial_transactions;
select * from customer_details;

select
f.*, c.customer_name, c.email, c.phone
from customer_details c
inner join
	financial_transactions f
ON
	c.customer_id = f.customer_id;
	