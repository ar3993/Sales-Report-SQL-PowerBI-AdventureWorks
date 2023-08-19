
-- Data Cleaning for the Date table--
-- Selecting only the required columns for the analysis--

SELECT 
	[DateKey],
	[FullDateAlternateKey] AS Date,
	[EnglishDayNameOfWeek] AS Day,
	[WeekNumberOfYear] AS WeekNr,
	[EnglishMonthName] AS Month,

-- Useful to have a short month name for front end navigation and front end graphs--

	Left([EnglishMonthName], 3) AS MonthShort,  
	[MonthNumberOfYear] AS MonthNo,
	[CalendarQuarter] AS Quarter,
	[CalendarYear] AS Year 
	FROM
	[dbo].[DimDate]
	WHERE
	CalendarYear >= 2020

-- Cleaning the Customers table--
-- Selecting the relevant columns and renaming them--

SELECT 
  c.customerkey AS CustomerKey, 
  c.firstname AS [First Name], 
  c.lastname AS [Last Name], 

-- Concatenating two fields and combining them as Full Name --

  c.firstname + ' ' + lastname AS [Full Name], 

-- Using a Case statement to rename the values--

  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
  c.datefirstpurchase AS DateFirstPurchase, 

-- Joining Customer City from Geography Table--
  g.city AS [Customer City] 
FROM 
  [AdventureWorksDW2022].[dbo].[DimCustomer] AS c
  LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey 

-- Ordering List by CustomerKey--
ORDER BY 
  CustomerKey ASC 

-- Cleaning the Products Table--

SELECT 
  p.ProductKey,
  p.ProductAlternateKey AS ProductItemCode,
  p.EnglishProductName AS [Product Name],

  -- Joined in from Subcategory Table--
  ps.EnglishProductSubcategoryName AS [Sub Category],

  -- Joined in from Product Category Table--
  pc.EnglishProductCategoryName AS [Product Category],
  p.Color AS [Product Color],
  p.Size AS [Product Size],
  p.ProductLine AS [Product Line],
  p.ModelName AS [Product Model Name],
  p.EnglishDescription AS [Product Description],

--Filtering on Product Status--  
  ISNULL (p.Status, 'Oudated') AS [Product Status]
FROM
  [AdventureWorksDW2022].[dbo].[DimProduct] AS p

--Joining the Product Subcategory table on the Product SubCategory Key
  LEFT JOIN dbo.DimProductSubCategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey

--Joining the Product Category table on the Product Category Key
  LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY
  p.ProductKey ASC

--Cleaning Internet Sales table--

SELECT 
  [ProductKey],
  [OrderDateKey],
  [DueDateKey],
  [ShipDateKey],
  [CustomerKey],
  [SalesOrderNumber] AS [Sales Order Number],
  [SalesAmount] AS [Sales Amount]
FROM
  [dbo].[FactInternetSales]

-- Ensuring we only get 3 years of dates from extraction by selecting the first 4 values of the OrderDateKey and comparing them with the present date--
WHERE
  LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -3
ORDER BY
  OrderDateKey ASC