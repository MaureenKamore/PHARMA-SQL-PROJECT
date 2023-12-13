
--Retrieve all columns for all records in the dataset.
SELECT *
FROM Pharma_data_analysis

--How many unique countries are represented in the dataset?
SELECT DISTINCT Country
FROM Pharma_data_analysis

--Select the names of all the customers on the 'Retail' channel.
SELECT DISTINCT Customer_Name 
FROM Pharma_data_analysis
WHERE Sub_channel ='Retail'
ORDER BY Customer_Name

--Find the total quantity sold for the ' Antibiotics' product class.
SELECT SUM(Quantity) AS Total_Quantity_Sold_Antibiotics
FROM Pharma_data_analysis
WHERE Product_Class = 'Antibiotics'

--List all the distinct months present in the dataset
SELECT DISTINCT Month
FROM Pharma_data_analysis
ORDER BY Month

--Calculate the total sales for each year.
SELECT Year, SUM(Sales) AS Total_Sales
FROM Pharma_data_analysis
GROUP BY Year
ORDER BY Total_Sales DESC

--Find the customer with the highest sales value.
SELECT Customer_Name, SUM (Sales) AS Total_Sales
FROM Pharma_data_analysis
GROUP BY Customer_Name
ORDER BY Total_Sales DESC

SELECT *
FROM Pharma_data_analysis
WHERE Sales = (SELECT(MAX(Sales)) FROM Pharma_data_analysis)

--Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.
SELECT DISTINCT(Name_of_sales_Rep)
FROM Pharma_data_analysis
WHERE Manager = 'James Goodwill'

--Retrieve the top 5 cities with the highest sales.
SELECT TOP 5 City, SUM(Sales) AS Total_Sales
FROM Pharma_data_analysis
GROUP BY City
ORDER BY Total_Sales DESC

--Calculate the average price of products in each sub-channel.
SELECT DISTINCT Sub_channel, AVG(Price) AS Avg_price
FROM Pharma_data_analysis
GROUP BY Sub_channel

--Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.
SELECT Sales
FROM Pharma_data_analysis
WHERE City = 'Rendsburg' AND Year = '2018'
ORDER BY Sales DESC

--Calculate the total sales for each product class, for each month, and order the results by year, month, and product class.
SELECT DISTINCT Product_Class, Year, Month, SUM(Sales) AS Total_Sales
FROM Pharma_data_analysis
GROUP BY Month, Year, Product_Class
ORDER BY Year, Month, Product_Class

--Find the top 3 sales reps with the highest sales in 2019.
SELECT TOP 3 Name_of_Sales_Rep, Sales
FROM Pharma_data_analysis
WHERE Year = '2019'
ORDER BY Sales DESC

--Calculate the monthly total sales for each sub-channel, and then calculate the average monthly sales for each sub-channel over the years
WITH Monthly_Total_Sales AS (
  SELECT Sub_channel, SUM(Sales) AS Monthly_sales
  FROM Pharma_data_analysis
  GROUP BY Sub_channel, Year, Month
)
SELECT Sub_channel, AVG(Sales) AS Average_monthly_sales
FROM Pharma_data_analysis
GROUP BY Sub_channel
ORDER BY Sub_channel


SELECT Sub_channel, SUM(Sales) AS Monthly_sales
FROM Pharma_data_analysis
GROUP BY Sub_channel
ORDER BY Monthly_sales DESC

SELECT Sub_channel, AVG(Sales) AS Average_monthly_sales
FROM Pharma_data_analysis
GROUP BY Sub_channel
ORDER BY Average_monthly_sales DESC

--Create a summary report that includes the total sales, average price, and total quantity sold for each product class.
SELECT Product_Class, SUM(Sales) AS Total_sales, AVG(Price) AS Average_price, SUM(Quantity) AS Total_Quantity
FROM Pharma_data_analysis
GROUP BY Product_Class
ORDER BY Product_Class DESC

--Find the top 5 customers with the highest sales for each year.
SELECT  TOP 5 Customer_name, Sales, Year AS Order_Year
FROM Pharma_data_analysis
ORDER BY Customer_Name DESC, Sales DESC, Order_Year

--Calculate the year-over-year growth in sales for each country.
WITH Yearly_Sales AS(
   SELECT Country, Year AS Order_Year, SUM(Sales) AS Total_Sales
   FROM Pharma_data_analysis
   GROUP BY Country, Year),
Year_Over_Year_Growth AS (
   SELECT Country, Order_Year, Total_Sales, LAG(Total_Sales) OVER (PARTITION BY Country ORDER BY Order_Year) AS Prev_Year_Sales
   FROM Yearly_Sales
)
SELECT Y1.Country, Y1.Order_Year, Y1.Total_Sales, COALESCE ((Y1.Total_Sales - Y2.Prev_Year-Sales) / NULLIF (Y2.Prev_Year_Sales, 0), 0) AS YoYGrowth
FROM Year_Over_Year_Growth Y1
LEFT JOIN
   Year_Over_Year_Growth Y2 ON Y1.Country = Y2.Country
   AND Y1.Order_Year = Y2.Order_Year + 1 ;

--List the months with the lowest sales for each year
SELECT Year, Month, MIN(Sales) AS Lowest_Sales
FROM Pharma_data_analysis
GROUP BY Year, Month
ORDER BY Year, Lowest_Sales


WITH Monthly_Sales AS (
   SELECT Year, Month, MIN(Sales) AS Lowest_Sales
   FROM Pharma_data_analysis
   GROUP BY Year, Month
)
SELECT Year, Month, Lowest_Sales
FROM Monthly_Sales
ORDER BY Year, Lowest_Sales


--Calculate the total sales for each sub-channel in each country, and then find the country with the highest total sales for each sub-channel
SELECT Sub_channel, Country, SUM(Sales) AS Total_Sales
FROM Pharma_data_analysis
GROUP BY Sub_channel, Country
ORDER BY Country