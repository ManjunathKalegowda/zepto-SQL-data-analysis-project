drop table if exists zepto;

CREATE TABLE zepto(
su_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR (150) NOT NULL,
MRP NUMERIC (8,2),
discountPrecent NUMERIC(5,2),
availableQutantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightinGms INTEGER,
outOfstock BOOLEAN,
quantity INTEGER
)

-- Data Exploration--

-- Count Of rows --
SELECT count(*)
FROM zepto

---Sample data
SELECT *
FROM zepto
LIMIT 10

SELECT *
FROM zepto

SELECT *
FROM zepto
WHERE name = "Gua"



--null Value

SELECT *
FROM zepto
WHERE name IS NULL
OR
MRP IS NULL
OR
discountPercent IS NULL
OR
availableQutantity IS NULL
OR
discountedSellingPrice IS NULL
OR 
weightinGms IS NULL
OR 
outOfstock IS NULL
OR
quantity IS NULL

--different product category
SELECT DISTINCT (category)
FROM zepto
ORDER BY category

---products in stock vs out of stock
SELECT outOfstock,count(outOfstock)
FROM zepto
GROUP BY outOfstock

--product names presents in multiple time
SELECT name,count(su_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(su_id)>1
ORDER BY count(su_id) DESC;

--data clean
SELECT *
FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0

DELETE FROM zepto
WHERE mrp=0;

--Convert paise in to rupees
UPDATE zepto
SET MRP=MRP/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

SELECT MRP,discountedSellingPrice
FROM zepto

--Q1.Find the top 10 best-value products based on the discount percentage
SELECT DISTINCT name , MRP , discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2.What are the products with high MRP but Out of stock
SELECT DISTINCT name , MRP
FROM zepto
WHERE outOfstock =TRUE AND MRP >300
ORDER BY MRP DESC;


--Q3.Calculated Estimated Revenue for each category
SELECT category,
sum(discountedSellingPrice*availableQutantity) AS total_Revenue
FROM zepto
GROUP BY category
ORDER BY total_Revenue

--Q4.Find the products all where MRP is greater than Rs-500 and discount is less than 10%
SELECT DISTINCT name , MRP,discountPercent
FROM zepto
WHERE  MRP >500 AND discountPercent<10
ORDER BY MRP DESC  ,discountPercent DESC

--Q5.Identify the top 5 categories offerings the highest  average discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.Find the price per gram for product above 100g and sort by the value
SELECT DISTINCT name,weightinGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightinGms,2) AS price_per_gram
FROM zepto
WHERE weightinGms>=100
ORDER BY price_per_gram 

--Q7.Group the products into categories like Low,Medium,Bulk
SELECT DISTINCT name ,weightinGms,
CASE WHEN weightinGms<1000 THEN 'Low'
     WHEN weightinGms<5000 THEN 'Medium'
     ELSE 'Bulk'
     END AS weight_category
FROM zepto

--Q8.What is total inventory Weight Per category
SELECT category,
sum(weightinGms*availableQutantity) AS total_Inventory
FROM zepto
GROUP BY category
ORDER BY category