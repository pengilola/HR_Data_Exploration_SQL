-- 1.) Retrieve a combined dataset of employees by joining the three tables
SELECT * 
FROM table1 t1
JOIN table2 t2 ON t1.emp_no = t2.emp_no
JOIN table3 t3 ON t1.emp_no = t3.emp_no;
-- 1. ANS) The outcome is that all three tables are joined and there are noo null fileds

-- 2.) Identify the top 5 highest-paid employees

SELECT emp_no, monthly_income
FROM table2
ORDER BY monthly_income DESC
LIMIT 5;
-- 2. ANS)

-- 2b.)
SELECT t2.emp_no, t2.monthly_income, t1.department
FROM table2 t2
JOIN table1 t1 ON t2.emp_no = t1.emp_no
ORDER BY monthly_income DESC
LIMIT 5;
-- 2b. ANS) Staff who earn the highest are in the R&D department


-- 3.) Find the average monthly income per department
SELECT department, AVG(monthly_income) AS avg_monthly_income
FROM table1 t1
JOIN table2 t2 ON t1.emp_no = t2.emp_no
GROUP BY department;
-- 3. ANS) The average monthly income per dept are HR = 6654k, Sales = 6959k, and 6281k for R&D with Sales being the highest


-- 4.) Determine the correlation between job satisfaction and attrition
SELECT job_satisfaction, attrition, COUNT(*) AS emp_count
FROM table1 t1
JOIN table2 t2 ON t1.emp_no = t2.emp_no
GROUP BY job_satisfaction, attrition
ORDER BY emp_count;


-- 5.) List employees who have worked at multiple companies
SELECT emp_no, num_companies_worked
FROM table3
Where num_companies_worked > 1
ORDER BY num_companies_worked DESC;

-- 6a.) Find the department with the highest attrition rate
SELECT Department, 
       COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100 / COUNT(*) AS Rate
FROM Table1 
GROUP BY Department
ORDER BY Rate DESC LIMIT 3;
-- 6a. ANS)


-- 6b.) Find the department with the highest attrition count
SELECT department, COUNT(*) AS attrition_count
FROM table1 
WHERE attrition = 'YES' 
GROUP BY department
ORDER BY attrition_count DESC
LIMIT 3;
-- 6b. ANS)


-- 7.) Analyze the impact of training on employee performance
SELECT Training_Times_Last_Year, AVG(Performance_Rating) AS Avg_Performance
FROM Table2 T2
JOIN Table3 T3 ON T2.emp_no = T3.emp_no
GROUP BY Training_Times_Last_Year
ORDER BY Training_Times_Last_Year;
-- 7. ANS.) There isn't much impact of tr


-- 8.) Identify employees who received a salary hike but still left the company.
SELECT t3.emp_no, percent_salary_hike, attrition
FROM table3 t3
JOIN table1 t1 ON t3.emp_no = t1.emp_no
WHERE attrition = 'Yes'; 

-- OR

SELECT T1.emp_no, T1.employee_number, T1.department, T3.percent_salary_hike, T1.attrition  
FROM Table1 T1  
JOIN Table3 T3 ON T1.emp_no = T3.emp_no  
WHERE T1.attrition = 'Yes' AND T3.percent_salary_hike > 0
ORDER BY T3.percent_salary_hike DESC;
--8. ANS) 


-- 9.) Determine the average work-life balance score of employees by job role.
SELECT Job_Role, AVG(Work_Life_Balance) AS Avg_Work_Life_Balance
FROM Table1 T1
JOIN Table3 T3 ON T1.emp_no = T3.emp_no
GROUP BY Job_Role
ORDER BY Avg_Work_Life_Balance DESC;
-- 9. ANS) The average work balance of employees across booard is smilar 2.6 to 2.9% with HR being the hignest. If it is rounded up, all department have a work life balance 3 - this 
  -- mean that all department have a 3 out of 4 score of work life balance


-- 10.) Calculate the percentage of employees who work overtime in each department.
SELECT department,
	SUM(CASE WHEN over_time = 'Yes' THEN 1 ELSE 0 END) *100.0 / COUNT(*) AS overtime_percentage
FROM table1 
GROUP BY department
ORDER BY overtime_percentage DESC;
-- 10. ANS)


-- 11.) Categorize Employees Based on Their Attrition Risk.
SELECT t1.emp_no,
    CASE
        WHEN job_satisfaction < 3 AND work_Life_balance < 3 AND years_at_company < 2 THEN 'High Risk'
        WHEN Job_satisfaction < 3 OR work_Life_balance < 3 OR years_at_company < 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS attrition_risk_category
FROM table1 t1
JOIN table2 t2 ON t1.emp_no = t2.emp_no
JOIN table3 t3 ON t2.emp_no = t3.emp_no;

-- Code2
SELECT COUNT(t1.emp_no),
    CASE
        WHEN job_satisfaction < 3 AND work_Life_balance < 3 AND years_at_company < 2 THEN 'High Risk'
        WHEN Job_satisfaction < 3 OR work_Life_balance < 3 OR years_at_company < 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS attrition_risk_category
FROM table1 t1
JOIN table2 t2 ON t1.emp_no = t2.emp_no
JOIN table3 t3 ON t2.emp_no = t3.emp_no
GROUP BY attrition_risk_category;

-- 11. ANS)


-- 12.) Replace Missing Last Promotion Years with DefaultValue.
SELECT emp_no, years_since_last_promotion
FROM table3
WHERE years_since_last_promotion IS NULL OR years_since_last_promotion = 0;

SELECT AVG(years_since_last_promotion)
FROM table3;

UPDATE table3
SET years_since_last_promotion = (
	SELECT AVG(years_since_last_promotion)
	FROM table3
)
WHERE years_since_last_promotion = 0;

SELECT emp_no, years_since_last_promotion
FROM table3
--12. ANS) I have updated missing values with the average years since promotion

-- 13A .) Find the Most Common Year When Employees Left
SELECT DATE_PART('year', date) AS attrition_year, COUNT(*) AS attrition_count
FROM table1 t1
JOIN table3 t3 ON t1.emp_no = t3.emp_no
WHERE attrition = 'Yes'
GROUP BY attrition_Year
ORDER BY attrition_Count DESC;
-- 13A. ANS) Employees left the most in 2021

-- 13B .) Find the most common year when employees leave
SELECT DATE_PART('year', date) AS Attrition_Year, COUNT(*) AS Attrition_Count
FROM Table1 T1
JOIN Table3 T3 ON T1.emp_no = T3.emp_no
WHERE Attrition = 'Yes'
GROUP BY Attrition_Year
ORDER BY Attrition_Count DESC;

SELECT years_at_company, COUNT(attrition) AS employees_left
FROM table3 t3
JOIN table1 t1 ON t1.emp_no = t3.emp_no
WHERE attrition = 'Yes'
GROUP BY years_at_company
ORDER BY employees_left DESC;


-- 13B. ANS) Employees left the most in 2021