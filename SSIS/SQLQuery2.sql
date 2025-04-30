USE [financial_data_warehouse]
GO

/****** Object:  Table [dbo].[financial_transactions]    Script Date: 30-04-2025 10:05:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[financial_transactions](
	[transaction_id] [int] NOT NULL,
	[customer_id] [int] NULL,
	[supplier_name] [varchar](50) NULL,
	[transaction_date] [date] NULL,
	[amount] [decimal](10, 2) NULL,
	[currency] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


select * from financial_transactions;
select * from exchange_rates;


alter table financial_transactions
add [customer_name] [varchar](50) NULL,
	[customer_email] [varchar](100) NULL,
	[customer_phone] [varchar](20) NULL

truncate table financial_transactions;

create table exchange_rates
(
from_currency varchar(10),
to_currency varchar(10),
exchange_rate float(29),
effective_date date
)

create table suppliers
(
supplier_id varchar(19),
supplier_name varchar (100),
contact_name varchar(108),
phone varchar(19)
)