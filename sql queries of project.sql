USE capstone;
-- 2.)
SELECT customerid, surname, estimatedsalary
FROM customerinfo
WHERE EXTRACT(QUARTER FROM BankDOJ) = 4
ORDER BY estimatedsalary DESC
LIMIT 5;


-- 3.)
SELECT AVG(NumOfProducts) AS avg_products_with_credit_card
FROM bank_churn
WHERE HasCrCard = 1; 

-- 5.)
SELECT Exited,
       AVG(CreditScore) AS avg_credit_score
FROM bank_churn
GROUP BY Exited;

-- 6.)
WITH ActiveAccounts AS (
    SELECT CustomerId,COUNT(*) AS ActiveAccounts
    FROM Bank_Churn
    WHERE IsActiveMember = 1
    GROUP BY customerId
)
SELECT CASE WHEN c.GenderID = 1 THEN 'Male' ELSE 'Female' END AS Gender,
    COUNT(aa.CustomerId) AS ActiveAccounts, AVG(c.EstimatedSalary) AS AvgSalary
FROM CustomerInfo c
LEFT JOIN ActiveAccounts aa ON c.CustomerId = aa.CustomerId
GROUP BY Gender
ORDER BY AvgSalary DESC;

-- 7.)
WITH credit_score_segments AS (
  SELECT
    customerid, isactivemember,
   CASE
      WHEN creditscore between 800 and 850 THEN 'Excellent'
      WHEN creditscore between 740 and 799 THEN 'Very Good'
      WHEN creditscore between 670 and 739 THEN 'Good'
      WHEN creditscore between 580 and 669 THEN 'Fair'
      ELSE 'Poor'
    END AS credit_score_segment
  FROM bank_churn
)
SELECT
  credit_score_segment,
  AVG(CASE WHEN isactivemember = 0 THEN 0 ELSE 1 END) AS exit_rate
FROM credit_score_segments
GROUP BY credit_score_segment
ORDER BY exit_rate DESC
LIMIT 1;

-- 8.)
SELECT 
    g.geographylocation, COUNT(b.customerId) AS active_customers
FROM
    geography g
        JOIN
    customerinfo c ON g.GeographyID = c.GeographyID
        JOIN
    bank_churn b ON c.CustomerId = b.CustomerId
WHERE
    b.tenure > 5
GROUP BY g.GeographyLocation
ORDER BY active_customers DESC
LIMIT 1;

-- 14.) activecustomer , creditcard , customerinfo , gender , geography

-- 15.)
WITH geographic_avg_salary AS (
SELECT g.geographylocation,
    CASE
        WHEN c.genderid = 1 THEN 'Male'
        ELSE 'Female'
    END AS gender,
    AVG(c.estimatedsalary) AS avg_salary
FROM
    customerinfo c
JOIN geography g ON c.GeographyID = g.GeographyID
GROUP BY g.Geographylocation,c.GenderID
ORDER BY g.GeographyLocation)

SELECT *, RANK() OVER(PARTITION BY geographylocation ORDER BY avg_salary DESC) AS `rank`
FROM geographic_avg_salary;

-- 16.)
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 30 THEN 'Adult'
        WHEN age BETWEEN 31 AND 50 THEN 'Middle-Aged'
        ELSE 'Old-Aged'
    END AS age_brackets,
    AVG(tenure) AS avg_tenure
FROM
    customerinfo c
        JOIN
    bank_churn b ON c.CustomerId = b.CustomerId
WHERE
    b.exited = 1
GROUP BY age_brackets
ORDER BY age_brackets;

-- 20.)
WITH info AS (
SELECT 
    CASE
        WHEN c.Age BETWEEN 18 AND 30 THEN 'Adult'
        WHEN c.Age BETWEEN 31 AND 50 THEN 'Middle-Aged'
        ELSE 'Old-Aged'
    END AS age_brackets,
    count(c.CustomerId) AS HasCreditCard
FROM customerinfo c JOIN bank_churn b ON c.CustomerId=b.CustomerId
WHERE HasCrCard = 1
GROUP BY age_brackets)
SELECT *
FROM info
WHERE HasCreditCard < (SELECT AVG(HasCreditCard) FROM info);

-- 21.)
SELECT g.GeographyLocation, COUNT(b.CustomerId) AS num_exited_people, AVG(b.CustomerId) AS avg_balance
FROM bank_churn b
JOIN customerinfo c ON b.CustomerId = c.CustomerId
JOIN geography g ON c.GeographyID = g.GeographyID
WHERE b.Exited = 1
GROUP BY g.GeographyLocation
ORDER BY Count(b.CustomerId)desc;

-- 23.)
SELECT CustomerId,CreditScore,Tenure,Balance,NumOfProducts,HasCrCard,IsActiveMember,
    CASE
        WHEN Exited = 0 THEN 'Retain'
        ELSE 'Exit'
    END AS ExitCategory
FROM
    bank_churn;

-- 25.)
SELECT 
    c.customerid,
    c.surname,
    CASE
        WHEN b.isactivemember = 1 THEN 'Active'
        ELSE 'InActive'
    END AS activity_status
FROM
    customerinfo c
        JOIN
    bank_churn b ON c.customerid = b.customerid
WHERE
    c.surname REGEXP 'on$'
ORDER BY c.surname;



									-- SA.


-- 9.)
SELECT 
    g.GeographyLocation,
    CASE
        WHEN EstimatedSalary < 50000 THEN 'Low'
        WHEN EstimatedSalary < 100000 THEN 'Medium'
        ELSE 'High'
    END AS income_segment,
    CASE
        WHEN c.genderid = 1 THEN 'Male'
        ELSE 'Female'
    END AS gender, age,
    COUNT(c.CustomerId) AS number_of_customers
FROM customerinfo c
        JOIN
    geography g ON c.geographyid = c.geographyid
GROUP BY income_segment , g.geographylocation , gender,age
ORDER BY g.GeographyLocation,age;

-- 14.)
ALTER TABLE bank_churn
RENAME COLUMN HasCrCard TO Has_creditcard;





