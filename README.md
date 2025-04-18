# Grocery-Sales_SQL
## Introduction
      This project explores a structured sales database consisting of seven interconnected tables, offering a robust foundation 
      for data analysis.The dataset provides insights into product categories, customer demographics, employee details,
      geographic distribution, and sales transactions.It enables aspiring data scientists to refine their SQL skills by 
      working with real-world business scenarios.
## Dataset Overview: 
      The dataset consists of seven interconnected tables.
    1. categories.csv : Defines the categories of the products.
    2. cities.csv     : Contains city-level geographic data.
    3. countries.csv  : Stores country-related metadata.
    4. customers.csv  : Contains information about the customers who make purchases.
    5. employees.csv  : Stores details of employees handling sales transactions.
    6. products.csv   : Stores details about the products being sold.
    7. sales.csv      : Contains transactional data for each sale.
## Table Descriptions:
 1. categories:
    
| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- |   
|  PK | CategoryID |  INT | Unique identifier for each product category. |    	  	        
|     | CategoryName |  VARCHAR(45) |	 Name of the product category. |

2. cities
   
| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- |   
|  PK | CityID |  INT | Unique identifier for each city. |    	  	        
|     | CityName |  VARCHAR(45) | Name of the city. |
|     | Zipcode |  DECIMAL(5,0) | Population of the city. |
| FK | CountryID |  INT | Reference to the corresponding country. |

3. countries

| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- |   
|  PK | CountryID |  INT | Unique identifier for each country. |    	  	        
|     | CountryName |  VARCHAR(45) | Name of the country. |
|     | CountryCode |  VARCHAR(2) | Two-letter country code. |
		
4. customers

| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- | 
|  PK | CustomerID |  INT | Unique identifier for each customer. |    	  	        
|     | FirstName |  VARCHAR(1) | First name of the customer. |
|     | MiddleName |  VARCHAR(1) |Middle initial of the customer. |
|     | LastName |  VARCHAR(45) | Last name of the customer. |
| FK | cityID |  INT | Reference to the corresponding country. |
|     | Address |  VARCHAR(90) | Residential address of the customer. |  

5. employees

| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- | 
|  PK  |  EmployeeID  |  INT  |  Unique identifier for each employee.  |
|      |  FirstName  |  VARCHAR(45)  |  First name of the employee.  |
|      |  MiddleInitial  |  VARCHAR(1)  |  Middle initial of the employee.  |
|      |  LastName  |  VARCHAR(45)  |  Last name of the employee.  |
|      |  BirthDate  |	DATE  |	 Date of birth of the employee.  |
|      |  Gender  |  VARCHAR(10)  |  Gender of the employee.  |
|  FK  |  CityID  |  INT  |  unique identifier for city  |
|      |  HireDate  |	DATE  |  Date when the employee was hired.  |

6. products
   
| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- | 
|  PK  |  ProductID  |	INT  |	Unique identifier for each product.  |
|      |  ProductName  |  VARCHAR(45)  |  Name of the product.  |
|      |  Price  |  DECIMAL(4,0)  |  Price per unit of the product.  |
|      |  CategoryID  |  INT  |	 unique category identifier  |
|      |  Class  |  VARCHAR(15)  |  Classification of the product.  |
|      |  ModifyDate  |  DATE  |  Last modified date.  |
|      |  Resistant  |  VARCHAR(15)  |	Product resistance category.  |
|      |  IsAllergic  |	 VARCHAR  |  indicates whether the item is an allergen  |
|      |  VitalityDays  |  DECIMAL(3,0)  |  Product vital type classification.  |

7. sales
   
| Key | ColumnName | DataType | Description |
| ------- | ------- | ------- | ------- | 
|  PK  |  SalesID  |  INT  |  Unique identifier for each sale.  |
|  FK  |  SalesPersonID	 |  INT	 |  Employee responsible for the sale.  |
|  FK  |  CustomerID  |	INT  |  Customer making the purchase.  |
|  FK  |  ProductID  |  INT  |	Product being sold.  |
|      |  Quantity  |   INT  |	Number of units sold.  |
|      |   Discount  |	DECIMAL(10,2)  |  Discount applied to the sale.  |
|      |  TotalPrice  |  DECIMAL(10,2)	|  Final sale price after discounts.  |
|      |  SalesDate  |	DATETIME  |  Date and time of the sale.  |
|      |  TransactionNumber  |	VARCHAR(25)  |	Unique identifier for the transaction  |

## Use Cases

Despite being a four-month snapshot and existing independently of external data sources, this dataset offers a rich environment for aspiring data scientists to practice and enhance their SQL skills. Here are some approachable and practical use cases:
1. Monthly Sales Performance
- Objective: Analyze sales performance within the four months to identify trends and patterns.
- Tasks:
  - Calculate total sales for each month.
  - Compare sales performance across different product categories each month.
2. Top Products Identification
- Objective: Determine which products are the best and worst performers within the dataset timeframe.
- Tasks:
  - Rank products based on total sales revenue.
  - Analyze sales quantity and revenue to identify high-demand products.
  - Examine the impact of product classifications on sales performance.
3. Customer Purchase Behavior
- Objective: Understand how customers interact with products during the four-month period.
- Tasks:
  - Segment customers based on their purchase frequency and total spend.
  - Identify repeat customers versus one-time buyers.
  - Analyze average order value and basket size.
4. Salesperson Effectiveness
- Objective: Evaluate the performance of sales personnel in driving sales.
- Tasks:
  - Calculate total sales attributed to each salesperson.
  - Identify top-performing and underperforming sales staff.
  - Analyze sales trends based on individual salesperson contributions over time.
5. Geographical Sales Insights
- Objective: Explore how sales are distributed across different cities and countries within the dataset.
- Tasks:
  - Map sales data to specific cities and countries to identify high-performing regions.
  - Compare sales volumes between various geographical areas.
  - Assess the effectiveness of regional sales strategies.

## Database Schema:

![](https://github.com/BhavanaBalasa/Grocery-Sales_SQL/blob/main/ERDiagram.png)
 
## Data Relationships
- Sales: Each sale is linked to a Product, Customer, and Employee through their respective IDs. Each sale is linked to a location via the customer.
- Customers: Associated with a City and a Country to provide geographic context.
- Employees: Manage sales and are uniquely identified by EmployeeID.
- Products: Categorized under specific Categories to organize the inventory.
- Geography: Cities belong to Countries, offering higher-level geographic segmentation.

## Insights:
1. Sales Analysis:
- The highest sales occurred in Month 3 (March?) with 32.21 M, closely followed by Month 1 (32.12 M).
- There is a significant drop in Month 5, with sales falling to 9.14 M, which is almost 71% lower than the previous month (Month 4).
- Months 1 to 4 show relatively stable and strong sales, ranging from 29.00 M to 32.21 M.
- Confections and Meat lead in total sales across months. Target these for marketing or promotions.

2. Products Analysis:
- Products like passion fruit purée, pork, and wasabi are leading in unit-level sales — great for premium pricing, upsells, or featuring in highlights.
- Highest Quantity Sold products are Pork - Hock And Feet Attached.
- Beef - Inside Round and Puree - Passion Fruit have strong unit price and decent volume.
- Confections and Meat are your power categories, making up 22.47% of all sales.
- Snails, Produce, Beverages, and Dairy are close in sales (all around 11 M), showing balanced consumer interest.
- Shell fish is at the bottom but still contributes meaningfully at 6.43% .
  
3. Customer Purchase Behaviour:
- Kirk Mccarty and Janette Lucero are the most frequent purchasers — possibly VIP customers.
- Customers are tied at 12 purchases — strong retention group.
- The top 5 customers all spent 13K+, indicating a solid base of high-value customers.
- Repeat customers make up ~71% of your customer base (61,352 out of 86,776).
- One-time buyers are still a large group — potential for retargeting campaigns or welcome-back offers.

4. Salesperson Analysis:
- The difference between the top and bottom is relatively tight (~5.9M vs. ~5.6M), so underperformers are not far behind. 
- Darnell and Daphne are nearly tied at the top — great performance.Seth and 
- Sonya could benefit from coaching, improved lead assignment, or product mix optimization.

5. Geographical Sales Insights:
- Tucson leads by a small margin, but the rest of the cities are very close, indicating a consistent performance across regions .
- Tucson tops the list with the highest sales volume at 30,478.


## Conclusion:
      This project provides a valuable learning experience in handling relational databases, executing complex SQL queries, 
      and deriving meaningful business insights. By leveraging the dataset, data professionals can practice optimizing queries, 
      performing aggregations, and crafting visualizations that drive data-driven decision-making.

