# Walmart Sales Data Analysis

## About
This project aims to explore the Walmart Sales data to understand top-performing branches and products, sales trends of different products, and customer behavior. The goal is to study how sales strategies can be improved and optimized. The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

"In this recruiting competition, job-seekers are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains many departments, and participants must project the sales for each department in each store. To add to the challenge, selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and the extent of the impact." [Source](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

## Purpose Of The Project
The major aim of this project is to gain insight into the sales data of Walmart to understand the different factors that affect sales at the different branches.

## About Data
The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition. This dataset contains sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon, and Naypyitaw. The data contains 17 columns and 1000 rows:

| Column                   | Description                                  | Data Type          |
|--------------------------|----------------------------------------------|--------------------|
| `invoice_id`             | Invoice of the sales made                    | `VARCHAR(30)`      |
| `branch`                 | Branch at which sales were made              | `VARCHAR(5)`       |
| `city`                   | The location of the branch                   | `VARCHAR(30)`      |
| `customer_type`          | The type of the customer                     | `VARCHAR(30)`      |
| `gender`                 | Gender of the customer making purchase       | `VARCHAR(10)`      |
| `product_line`           | Product line of the product sold             | `VARCHAR(100)`     |
| `unit_price`             | The price of each product                    | `DECIMAL(10, 2)`   |
| `quantity`               | The amount of the product sold               | `INT`              |
| `VAT`                    | The amount of tax on the purchase            | `FLOAT(6, 4)`      |
| `total`                  | The total cost of the purchase               | `DECIMAL(10, 2)`   |
| `date`                   | The date on which the purchase was made      | `DATE`             |
| `time`                   | The time at which the purchase was made      | `TIMESTAMP`        |
| `payment_method`         | The payment method used                      | `VARCHAR(30)`      |
| `cogs`                   | Cost Of Goods Sold                           | `DECIMAL(10, 2)`   |
| `gross_margin_percentage`| Gross margin percentage                      | `FLOAT(11, 9)`     |
| `gross_income`           | Gross Income                                 | `DECIMAL(10, 2)`   |
| `rating`                 | Rating                                       | `FLOAT(2, 1)`      |

## Analysis List

### Product Analysis
Conduct analysis on the data to understand the different product lines, the product lines performing best, and the product lines that need improvement.

### Sales Analysis
This analysis aims to answer the question of the sales trends of products. The result of this can help measure the effectiveness of each sales strategy the business applies and what modifications are needed to gain more sales.

### Customer Analysis
This analysis aims to uncover the different customer segments, purchase trends, and the profitability of each customer segment.

## Approach Used

1. **Data Wrangling:** This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace missing or NULL values.
   - Build a database
   - Create table and insert the data.
   - Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT NULL for each field, hence null values are filtered out.

2. **Feature Engineering:** This will help us generate some new columns from existing ones.
   - Add a new column named `time_of_day` to give insight into sales in the Morning, Afternoon, and Evening. This will help answer the question of which part of the day most sales are made.
   - Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thu, Fri). This will help answer the question of which day of the week each branch is busiest.
   - Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). This will help determine which month of the year has the most sales and profit.

3. **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

## Conclusion

### Business Questions To Answer

#### Generic Questions
- How many unique cities does the data have?
- In which city is each branch?

#### Product
- How many unique product lines does the data have?
- What is the most common payment method?
- What is the most selling product line?
- What is the total revenue by month?
- What month had the largest COGS?
- What product line had the largest revenue?
- What is the city with the largest revenue?
- What product line had the largest VAT?
- Fetch each product line and add a column to those product lines showing "Good" or "Bad". Good if its greater than average sales.
- Which branch sold more products than average products sold?
- What is the most common product line by gender?
- What is the average rating of each product line?

#### Sales
- Number of sales made in each time of the day per weekday.
- Which of the customer types brings the most revenue?
- Which city has the largest tax percent/ VAT (Value Added Tax)?
- Which customer type pays the most in VAT?

#### Customer
- How many unique customer types does the data have?
- How many unique payment methods does the data have?
- What is the most common customer type?
- Which customer type buys the most?
- What is the gender of most of the customers?
- What is the gender distribution per branch?
- Which time of the day do customers give most ratings?
- Which time of the day do customers give most ratings per branch?
- Which day of the week has the best average ratings?
- Which day of the week has the best average ratings per branch?

## Revenue And Profit Calculations

### Formulas
- \( \text{COGS} = \text{unitPrice} \times \text{quantity} \)
- \( \text{VAT} = 5\% \times \text{COGS} \)
- \( \text{total(gross\_sales)} = \text{VAT} + \text{COGS} \)
- \( \text{grossProfit(grossIncome)} = \text{total(gross\_sales)} - \text{COGS} \)
- \( \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} \)

### Example Calculation
#### Data given:
- **Unit Price** = 45.79
- **Quantity** = 7

#### Step-by-Step Calculation:
1. **COGS**: 
   \[
   \text{COGS} = 45.79 \times 7 = 320.53
   \]

2. **VAT**: 
   \[
   \text{VAT} = 5\% \times \text{COGS} = 0.05 \times 320.53 = 16.0265
   \]

3. **Total (Gross Sales)**: 
   \[
   \text{Total} = \text{VAT} + \text{COGS} = 16.0265 + 320.53 = 336.5565
   \]

4. **Gross Profit**: 
   \[
   \text{Gross Profit} = \text{Total} - \text{COGS} = 336.5565 - 320.53 = 16.0265
   \]

5. **Gross Margin Percentage**: 
   \[
   \text{Gross Margin Percentage} = \frac{\text{Gross Profit}}{\text{Total Revenue}} = \frac{16.0265}{336.5565} \approx 0.0476 \approx 4.76\%
   \]

