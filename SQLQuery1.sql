CREATE DATABASE INTEGRATED_CASE_STUDY_MISHALNAGAR 

--From Notes :-  b. Drop the observations(rows) if MCN is null or storeID is null or Cash_Memo_No
DELETE FROM TRANSACTION_DATA
WHERE MCN IS NULL
OR Store_ID IS NULL
OR Cash_Memo_No IS NULL

/*From Notes :-  c. Join both tables considering Transaction
table as base table (Hint: left Join – Key variable is MCN/CustomerID)
and name the table as Final_Data*/
SELECT *
INTO FINAL_DATA
FROM TRANSACTION_DATA AS TD
INNER JOIN
CUST_DATA AS CD
ON TD.MCN  = CD.CustID

SELECT top 5* FROM FINAL_DATA;

--Q1. Count the number of observations having any of the variables having null value/missing values?
select count(*) AS Null_rows
from FINAL_DATA
where ItemCount is null
    or TransactionDate is null
    or TotalAmount is null
    or saleamount is null
    or SalePercent  is null
	or Cash_Memo_No is null
	or Dep1Amount is null
	or Dep2Amount is null
	or Dep3Amount is null
	or Dep4Amount is null
	or Store_ID is null
	or MCN is null
	or Cust_seg is null
	or CustID is null
	or gender is null
	or age is null
	or Sample_flag is null
	or location is null

--Q2. How many customers have shopped? (Hint: Distinct Customers)

select count(distinct custID) as totalcustomers from FINAL_DATA;

select count(distinct MCN ) as totalcustomers from TRANSACTION_DATA;

--Q.3 How many shoppers(customers)visiting more than 1 store?
with totalcust as
(select custID, count(custID) as totalshopping from Final_Data
group by CustID
having count(custID) > 1) 
select count(custid) as totalcustomers from totalcust;

--Q.4 What is the distribution of shoppers by day of the week?how the customer shopping behaviour on each day week?
SELECT 
COUNT(DISTINCT custid) AS number_of_cust,
COUNT(DISTINCT transactiondate) AS number_of_trans,
DATEPART(WEEKDAY,transactiondate) as _weekday,
SUM(saleamount) AS total_sale_amount,
SUM(itemcount) AS total_quantity,
TransactionDate AS TransDate
FROM final_data
GROUP BY TransactionDate
ORDER BY TransDate DESC;

--Q.5 What is the average revenue per customer/average revenue per customer by each location?
select custid, location,
avg(SaleAmount) as avgrevenue 
from Final_Data
where location is not null
group by custid, Location
order by custid , 
avg(SaleAmount),Location;

--Q.6 Average revenue per customer by each store etc?
select custid, store_id, avg(SaleAmount) as avgrevenue from Final_Data
WHERE CustID is not NULL
group by CustID, Store_ID
order by CustID, Store_ID, avg(SaleAmount);

--Q.7 Find the department spend by store wise?
SELECT
STORE_ID, SUM(SaleAmount) AS total_spend
FROM FINAL_DATA
GROUP BY Store_ID
ORDER BY SUM(SaleAmount);

--Q.8 What is the latest transaction date and oldest transaction date?
select 
MIN (TransactionDate) As Oldest_Transaction_Date,
MAX (TransactionDate) AS Latest_Transaction_Date
From Final_Data;

--Q.9 How many months of data provided for the analysis?
select DATENAME(month, transactiondate) as monthname, YEAR(TransactionDate) yearname from final_data
group by DATENAME(month, transactiondate), YEAR(TransactionDate)
order by YEAR(TransactionDate),DATENAME(month, transactiondate)

--Q.10 Find the top 3 locations interms of spend and total contribution of sales out of total sales?
SELECT TOP 3 LOCATION , SUM(SaleAmount) AS total_spend
FROM final_data
GROUP BY location
ORDER BY total_spend desc

--Q.11 Find the customer count and total sales by gender ?
 SELECT gender, COUNT(DISTINCT custid) AS totalcustomers, 
 SUM(saleamount) AS totalsales FROM Final_Data
 GROUP BY Gender;

--Q.12 What is the total discount and percentage of discount given by each loaction ?
 select location, SUM(SaleAmount * SalePercent / 100) AS TotalDiscount,
 avg(salepercent) as avgdiscount from Final_Data
 group by location

--Q.13 Which segment of customers contributing maximum sales?
select Cust_seg, sum(saleamount) as totalsales from final_data
group by Cust_seg 
order by sum(saleamount) desc;

--Q.14 What is the average transaction value by loaction, gender,segmennt?
select location, gender, cust_seg,
avg(saleamount) as avgtransaction from Final_Data
group by location, gender, cust_seg

--Q.15 
/*create table customer_360(
customer_id int primary key,
gender varchar(50),
location varchar(50),
age int,
cust_seg int,
no_of_transactions int,
no_of_items int,
total_sale_amount float,
average_transaction_value float,
totalspend_dep1 float,
totalspend_dep2 float,
totalspend_dep3 float,
totalspend_dep4 float,
no_transactions_dep1 int,
no_transactions_dep2 int,
no_transactions_dep3 int,
no_transactions_dep4 int,
no_transactions_weekdays int,
no_transactions_weekends int,
rank_based_on_spend int,
*/

create table customer_360(
customer_id int primary key,
gender varchar(50),
location varchar(50),
age int,
cust_seg int,
no_of_transactions int,
no_of_items int,
total_sale_amount float,
average_transaction_value float,
totalspend_dep1 float,
totalspend_dep2 float,
totalspend_dep3 float,
totalspend_dep4 float,
no_transactions_dep1 int,
no_transactions_dep2 int,
no_transactions_dep3 int,
no_transactions_dep4 int,
no_transactions_weekdays int,
no_transactions_weekends int,
rank_based_on_spend int,
decile float
)

--D. 
SELECT *, (TotalAmount - SaleAmount) AS Discount
FROM Final_Data;

--D. 
SELECT *
FROM Final_Data
WHERE Sample_flag = 1;