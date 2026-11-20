-- Section A
-- Question 1
USE adventureworks;
SELECT * FROM sales_customer;
SELECT * FROM person_person;

SELECT c.CustomerID, p.FirstName, p.LastName, c.AccountNumber, c.StoreID
FROM sales_customer AS c
INNER JOIN person_person AS p
    ON c.PersonID = p.BusinessEntityID;

-- Question 2
SELECT * FROM humanresources_employee;
SELECT e.BusinessEntityID, p.FirstName, p.LastName, e.JobTitle, e.HireDate, e.CurrentFlag
FROM humanresources_employee AS e
INNER JOIN person_person AS p
	ON e.BusinessEntityID = p.BusinessEntityID;

-- Question 3
SELECT * FROM production_product;
SELECT * FROM production_productsubcategory;
SELECT p.ProductID, p.Name AS ProductName, p.ProductNumber, ps.Name AS SubcategoryName
FROM production_product AS p
INNER JOIN production_productsubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID;

-- Question 4
SELECT
    p.ProductID,
    p.Name AS ProductName,
    ps.Name AS SubcategoryName,
    pc.Name AS CategoryName
FROM production_product AS p
LEFT JOIN production_productsubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN production_productcategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID;
    
-- Question 5
SELECT * FROM sales_salesorderheader;
SELECT * FROM sales_customer;
SELECT * FROM person_person;
SELECT soh.SalesOrderID, soh.OrderDate, c.CustomerID,
p.FirstName, p.LastName,
    CONCAT(p.FirstName, ' ', p.LastName) AS Customer_Name
FROM sales_salesorderheader AS soh
INNER JOIN sales_customer AS c
    ON soh.CustomerID = c.CustomerID
INNER JOIN person_person AS p
    ON c.PersonID = p.BusinessEntityID;

-- Question 6
SELECT * FROM sales_salesorderdetail;
SELECT sod.SalesOrderID, p.ProductID, p.Name AS ProductName,
sod.OrderQty, sod.UnitPrice
FROM sales_salesorderdetail AS sod
INNER JOIN production_product AS p
    ON sod.ProductID = p.ProductID
ORDER BY sod.SalesOrderID;

-- Question 7
SELECT * FROM sales_salesperson;
SELECT * FROM person_person;
SELECT * FROM sales_salesterritory;
SELECT sp.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalespersonName,
    sp.SalesQuota, sp.SalesYTD, st.Name AS TerritoryName
FROM sales_salesperson AS sp
INNER JOIN person_person AS p
    ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN sales_salesterritory AS st
    ON sp.TerritoryID = st.TerritoryID;
    
-- Question 8
SELECT * FROM humanresources_employee;
SELECT * FROM person_person;
SELECT * FROM humanresources_employeedepartmenthistory;
SELECT * FROM humanresources_department;
SELECT
    e.BusinessEntityID,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    e.JobTitle, d.Name AS DepartmentName,
    edh.StartDate AS DepartmentStartDate
FROM humanresources_employee AS e
INNER JOIN person_person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN humanresources_employeedepartmenthistory AS edh
    ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN humanresources_department AS d
    ON edh.DepartmentID = d.DepartmentID
ORDER BY EmployeeName;

-- Question 9
SELECT * FROM purchasing_vendor;
SELECT * FROM purchasing_productvendor;
SELECT * FROM production_product;
SELECT v.BusinessEntityID AS VendorID, v.Name AS VendorName,
p.ProductID, p.Name AS ProductName, pv.AverageLeadTime
FROM purchasing_vendor AS v
INNER JOIN purchasing_productvendor AS pv
    ON v.BusinessEntityID = pv.BusinessEntityID
INNER JOIN production_product AS p
    ON pv.ProductID = p.ProductID
ORDER BY v.Name, p.Name;

-- Question 10
SELECT p.ProductID, p.Name AS ProductName, p.ProductNumber,
p.ProductSubcategoryID, ps.Name AS SubcategoryName
FROM production_product AS p
LEFT JOIN production_productsubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
ORDER BY p.Name;

-- SECTION B
-- Question 11
SELECT ProductID, Name AS ProductName,
ProductNumber, ListPrice
FROM production_product
WHERE ListPrice > (SELECT AVG(ListPrice)
    FROM production_product)
ORDER BY ListPrice DESC;

-- Question 12
SELECT c.CustomerID, c.AccountNumber
FROM sales_customer AS c
WHERE c.CustomerID IN (SELECT soh.CustomerID
    FROM sales_salesorderheader AS soh)
ORDER BY c.CustomerID;

-- Question 13
SELECT p.ProductID, p.Name AS ProductName,
p.ProductNumber, p.ListPrice
FROM production_product AS p
WHERE p.ProductID NOT IN (SELECT sod.ProductID
    FROM sales_salesorderdetail AS sod)
ORDER BY p.Name;

-- Question 14
SELECT e.BusinessEntityID AS EmployeeID,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    e.JobTitle, eph.Rate AS HourlyPayRate
FROM humanresources_employee AS e
INNER JOIN person_person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN humanresources_employeepayhistory AS eph
    ON e.BusinessEntityID = eph.BusinessEntityID
WHERE eph.Rate > (SELECT AVG(Rate)
    FROM humanresources_employeepayhistory)
ORDER BY eph.Rate DESC;

-- Question 15
SELECT c.CustomerID, c.AccountNumber,
    SUM(soh.TotalDue) AS TotalOrderValue
FROM sales_customer AS c
INNER JOIN sales_salesorderheader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, c.AccountNumber
HAVING SUM(soh.TotalDue) > (SELECT AVG(CustomerTotal)
    FROM (SELECT CustomerID, SUM(TotalDue) AS CustomerTotal
        FROM sales_salesorderheader
        GROUP BY CustomerID) AS CustomerTotals)
ORDER BY TotalOrderValue DESC;