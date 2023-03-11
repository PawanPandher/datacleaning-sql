
CREATE SCHEMA IF NOT EXISTS VivaKHR;
USE VivaKHR;
SET FOREIGN_KEY_CHECKS=0;

# ---------------------------------------------------
#
# Task 2
#
# ---------------------------------------------------
-- Create a Schema based on VivaK_Data_Model and call it VivaKHR. 
-- You must include all the statements in your SQL file and only the important statements/ outputs in your presentation.
-- 1. All salary-related columns must be double. Data must be recorded in 2 decimals.
-- 2. All ID columns and their related foreign keys must be Integer.
-- 3. The employee table MUST contain the report_to column to record the ID of the employee’s manager.
-- 4. The data type of All the date columns MUST be DATE.
-- 5. Include a column called experience_at_VivaK in the appropriate table to include the number of months
--     that each employee has worked at VivaK.
-- 6. Include a column called last_performance_rating in the appropriate table to include the performance
--     rating (0-10) of each employee after the annual performance appraisal.
-- 7. Include a column called salary_after_increment in the appropriate table to record the salary anticipated
--     after the annual performance appraisal.
-- 8. Include a column called annual_dependent_benefit in the appropriate table to record the dependent
--     bonus that each employee receives per dependent.

CREATE TABLE IF NOT EXISTS regions (
	region_id INT AUTO_INCREMENT PRIMARY KEY,
	region_name VARCHAR(25) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS countries (
	country_id CHAR (2) PRIMARY KEY,
	country_name VARCHAR (40) DEFAULT NULL,
	region_id INT NOT NULL,
	FOREIGN KEY (region_id)
		REFERENCES regions (region_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS locations (
	location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_code INT,
	street_address VARCHAR (100) DEFAULT NULL,
	postal_code VARCHAR (12) DEFAULT NULL,
	city VARCHAR (30) NOT NULL,
	state_province VARCHAR (25) DEFAULT NULL,
	country_id CHAR (2) NOT NULL,
	FOREIGN KEY (country_id)
		REFERENCES countries (country_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS orgStructures (
	job_id INT AUTO_INCREMENT PRIMARY KEY,
	job_title VARCHAR(100) NOT NULL,
    min_salary DOUBLE CHECK(min_salary > 0),
    max_salary DOUBLE CHECK(max_salary > 0),
    department_name VARCHAR(50) NOT NULL,
    reports_to INT DEFAULT NULL -- President doesn't report to anybody, that is Null be default.
	-- We updated department_id with foreign key constraint after chainging the name from department_name.
);

CREATE TABLE IF NOT EXISTS departments (
	department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS employees (
	employee_id INT PRIMARY KEY,
    first_name VARCHAR (40) DEFAULT NULL,
    last_name VARCHAR (40) DEFAULT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    job_id INT,
    salary DOUBLE CHECK(salary > 0),
    manager_id INT DEFAULT NULL,
    hire_date DATE,
    department_id INT, -- it will be changed to location_id.
    experience_at_VivaK INT DEFAULT NULL, -- the number of months that each employee has worked at VivaK. (current_date - hire_date)
    last_performance_rating DOUBLE, -- the performance rating (0-10) of each employee after the annual performance appraisal. 
    salary_after_increment DOUBLE, -- the salary anticipated after the annual performance appraisa
    FOREIGN KEY (job_id)
		REFERENCES orgStructures (job_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
	-- We updated location_id with foreign key constraint after importing the data.
);

CREATE TABLE IF NOT EXISTS dependents(
	dependent_id INT AUTO_INCREMENT PRIMARY KEY, -- dependent_id has duplicate values. when we import the data, we made it auto-increment to hundle the duplicates (all ID will be unique).
    first_name VARCHAR (40) DEFAULT NULL,
    last_name VARCHAR (40) DEFAULT NULL,
    relationship VARCHAR (40) DEFAULT NULL,
    employee_id INT,
	annual_dependent_benefit DOUBLE -- the dependent bonus that each employee receives per dependent.
    -- We updated employee_id with foreign key constraint after importing the data.
);


# ---------------------------------------------------
#
# Task 3
#
# ---------------------------------------------------
-- Import and clean the data. 
-- Import the sample data to test the integrity and efficiency of your OLAP schema. 
-- You must include all the statements / outputs in your SQL file and only the important statements in your presentation. 
-- Consider the following:

/*Data for the table regions */
INSERT INTO regions(region_id,region_name) VALUES (1,'Europe');
INSERT INTO regions(region_id,region_name) VALUES (2,'Americas');
INSERT INTO regions(region_id,region_name) VALUES (3,'Asia');
INSERT INTO regions(region_id,region_name) VALUES (4,'Middle East and Africa');

/*Data for the table countries */
INSERT INTO countries(country_id,country_name,region_id) VALUES ('AR','Argentina',2);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('AU','Australia',3);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('BE','Belgium',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('BR','Brazil',2);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('CA','Canada',2);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('CH','Switzerland',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('CN','China',3);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('DE','Germany',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('DK','Denmark',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('EG','Egypt',4);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('FR','France',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('HK','HongKong',3);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('IL','Israel',4);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('IN','India',3);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('IT','Italy',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('JP','Japan',3);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('KW','Kuwait',4);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('MX','Mexico',2);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('NG','Nigeria',4);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('NL','Netherlands',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('SG','Singapore',3);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('UK','United Kingdom',1);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('US','United States of America',2);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('ZM','Zambia',4);
INSERT INTO countries(country_id,country_name,region_id) VALUES ('ZW','Zimbabwe',4);

/*Data for the table locations */
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (1700,'2004 Charade Rd','98199','Seattle','Washington','US');
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA');
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (2400,'8204 Arthur St',NULL,'London',NULL,'UK');
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO locations(location_code,street_address,postal_code,city,state_province,country_id) VALUES (2700,'Schwanthalerstr. 7031','80925','Munich','Bavaria','DE');

/*Import Data for the table pf orgStructures, employees, departments and dependents */
-- 1. Select a table from left menu
-- 2. Select "Table Data Import Wizard"
-- 3. Input the file path and Click "Next"
-- 4. Select "Use existing table"

-- Notices:
--  manager_id is empty on employees table. Please skip the column.
/*
	 Dependent data in excel is having duplicacy with dependent id only and in our database dependent id is not 
     related to any other table. To handle this duplicacy while creating dependent table we selected dependent_id a s Primary Key & amde it Auto increment and
     during importing data from csv file we just didnot import the dependent id column & it got auto incremented values with no duplicacy.
     Please refer the attached screenshot for clarity on import part.
*/

SELECT * FROM departments;
SELECT * FROM locations;
SELECT * FROM orgStructures;
SELECT * FROM employees;
SELECT * FROM dependents;

-- Changing the name of department_id to location_id in department table
ALTER TABLE employees
	CHANGE department_id location_id INT,
	ADD CONSTRAINT location_fk FOREIGN KEY (location_id)
		REFERENCES locations (location_id)
		ON UPDATE CASCADE ON DELETE RESTRICT;

-- Normalizing tables to reduce redundancy adding department_id to orgstructure
ALTER TABLE orgStructures
	ADD COLUMN department_id INT,
    ADD CONSTRAINT department_fk FOREIGN KEY (department_id)
		REFERENCES departments (department_id)
		ON UPDATE CASCADE ON DELETE RESTRICT;

-- Updating the department_id column 
UPDATE orgStructures AS os
SET department_id = (
	SELECT department_id
	FROM departments AS d
	WHERE d.department_name = os.department_name);

-- Deleting department_name from orgstruture
ALTER TABLE orgStructures
	DROP department_name;

-- Updating the constraint of the foreign key of employee_id
ALTER TABLE dependents
	ADD CONSTRAINT employee_fk FOREIGN KEY (employee_id)
		REFERENCES employees (employee_id)
		ON UPDATE CASCADE ON DELETE RESTRICT;


-- 1. Handle Duplicates: All tables must be in the full-normalized form, meaning that there should not be any data redundancy. 
--    Check for duplicates in each table using qualifying candidate keys.
-- checking for duplicates in orgStructures as job_id is primary key. No dupicates found
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER( -- ROW_NUMBER() gives the index to each row for the duplicates, it will give index 2 and so on.
			PARTITION BY job_id -- That is what we want to see the column for checking duplicates.
			ORDER BY job_id
		) AS row_num
	FROM orgStructures)

SELECT *
FROM cte 
WHERE row_num > 1; -- if row_num has greater than 1, it gives us duplicates.

-- checking for duplicates in location as location_id is primary key. No duplicates Found
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY location_id
			ORDER BY location_id
		) AS row_num
	FROM locations)

SELECT *
FROM cte 
WHERE row_num > 1;

-- checking for duplicates in countries as country_id is primary key. No duplicates Found
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY country_id
			ORDER BY country_id
		) AS row_num
	FROM countries)
              
SELECT *
FROM cte 
WHERE row_num > 1;                  
               
-- checking for duplicates in department as department_id is primary key. No duplicates Found
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY department_id
			ORDER BY department_id
		) AS row_num
	FROM departments)
              
SELECT *
FROM cte 
WHERE row_num > 1;  
 
 -- checking for duplicates in employees as employee_id is primary key. No duplicates Found
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY employee_id
			ORDER BY employee_id
		) AS row_num
	FROM employees)
              
SELECT *
FROM cte 
WHERE row_num > 1;  

 -- checking for duplicates in regions as region_id is primary key. No duplicates Found
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY region_id
			ORDER BY region_id
		) AS row_num
	FROM regions)
              
SELECT *
FROM cte 
WHERE row_num > 1;  

-- checking for duplicates in dependent (when we import the data we handle the duplicates by using the auto-increment)
WITH cte AS (
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY dependent_id
			ORDER BY dependent_id
		) AS row_num
	FROM dependents)

SELECT *
FROM cte 
WHERE row_num > 1;

-- 2. Format the data according to the designated data types.
-- a. Ensure the floating-point data is represented as double

-- salary column in employees is floating-point data is converted into DOUBLE
UPDATE employees
SET salary = cast(salary as DOUBLE);

-- min_salary column in orgstructures is floating-point data data is converted into DOUBLE
UPDATE orgstructures
SET min_salary = cast(min_salary as DOUBLE);

-- max_salary column in orgstructures is floating-point data data is converted into DOUBLE
UPDATE orgstructures
SET max_salary = cast(max_salary as DOUBLE);


-- b. Ensure that the phone numbers are all recorded in the format: ‘+000-000-000-0000’, where the
-- first four characters refer to the country code.

UPDATE employees
SET phone = REPLACE(phone,'.','-');

ALTER TABLE countries
	ADD country_code CHAR(4);

UPDATE countries
SET country_code = 54
WHERE country_id = 'AR';

UPDATE countries
SET country_code = 61
WHERE country_id = 'AU';

UPDATE countries
SET country_code = 32
WHERE country_id = 'BE';

UPDATE countries
SET country_code = 55
WHERE country_id = 'BR';

UPDATE countries
SET country_code = 1
WHERE country_id = 'CA';

UPDATE countries
SET country_code = 41
WHERE country_id = 'CH';

UPDATE countries
SET country_code = 86
WHERE country_id = 'CN';

UPDATE countries
SET country_code = 49
WHERE country_id = 'DE';

UPDATE countries
SET country_code = 45
WHERE country_id = 'DK';

UPDATE countries
SET country_code = 20
WHERE country_id = 'EG';

UPDATE countries
SET country_code = 33
WHERE country_id = 'FR';

UPDATE countries
SET country_code = 852
WHERE country_id = 'HK';

UPDATE countries
SET country_code = 972
WHERE country_id = 'IL';

UPDATE countries
SET country_code = 91
WHERE country_id = 'IN';

UPDATE countries
SET country_code = 39
WHERE country_id = 'IT';

UPDATE countries
SET country_code = 81
WHERE country_id = 'JP';

UPDATE countries
SET country_code = 965
WHERE country_id = 'KW';

UPDATE countries
SET country_code =  52
WHERE country_id = 'MX';

UPDATE countries
SET country_code = 234
WHERE country_id = 'NG';

UPDATE countries
SET country_code = 31
WHERE country_id = 'NL';

UPDATE countries
SET country_code = 65
WHERE country_id = 'SG';

UPDATE countries
SET country_code = 44
WHERE country_id = 'UK';

UPDATE countries
SET country_code = 1
WHERE country_id = 'US';

UPDATE countries
SET country_code = 260
WHERE country_id = 'ZM';

UPDATE countries
SET country_code = 263
WHERE country_id = 'ZW';
        
WITH cte as (
	SELECT concat('+',c.country_code,'-',e.phone) as phone, e.employee_id
	FROM employees AS e
		JOIN locations AS l USING(location_id)
		JOIN countries AS c USING(country_id))

UPDATE employees AS emp
SET phone = (
	SELECT phone
	FROM cte
	WHERE cte.employee_id = emp.employee_id)
WHERE phone <> ''; -- if phone number is null, the country code is not added.

-- c. Ensure the dates are recorded in the format: ‘yyyy-mm-dd’.
UPDATE employees
SET hire_date = date_format(hire_date, '%Y-%m-%d');

-- 3. Treat Missing Values:
-- a. Fill up the report_to column by analyzing the available data.

-- updating the manager_id column by joining it with a with clause
-- which creates a TEMPORARY result without storing it anywhere in the database.
-- when  Reports_to is equal to 1, the employee is the president with the employee_id 100.

select employee_id 
from employees
where job_id = ( select job_id 
                 from orgstructures
                 where job_title = 'President');

-- joining orgstructure with employees on job_id and location_id
WITH cte AS (SELECT e.employee_id, CASE WHEN o.Reports_to = 1 THEN 100 ELSE e1.employee_id END AS manager_id 
					FROM employees e
					LEFT JOIN orgstructures o
					ON e.job_id = o.job_id
					LEFT JOIN employees e1
					ON e1.job_id = o.reports_to  AND e1.location_id = e.location_id)

UPDATE employees emp
SET manager_id = ( SELECT cte.manager_id
                   FROM cte
                   WHERE emp.employee_id = cte.employee_id);

-- b. Devise a strategy to fill in the missing entries in the salary column. 
--    Justify your answers and state your assumptions.

-- creating a new column avg_salary which is average of min salary and max salary 
-- for each particular job id. It is taken to fill the 0 in salary column in employees table.
-- As each job_id can have salary only in this range. 

-- So filling the salary column with the mean of min and max salary
ALTER TABLE orgstructures
ADD avg_salary INT AS ((min_salary + max_salary)/2) ;

UPDATE employees AS emp
SET salary = (
	SELECT avg_salary
	FROM orgstructures AS o
	WHERE emp.job_id = o.job_id)
WHERE salary like 0;       

-- Locations table has missining values based on locations.
-- postal code: EC4R 9AT
--state province: London

UPDATE locations
SET 
	postal_code = "EC4R 9AT",
    state_province = "London"
WHERE location_id = 5;

-- There is Null phone numbers in employees table. But the number should be unique and it is provied. 
-- So we can't fill the missing values.

# ---------------------------------------------------
#
# Task 4
#
# ---------------------------------------------------

/*
	1. (4 Marks) experience_at_VivaK: calculate the time difference (in months) between the hire date and the
current date for each employee and update the column. 
*/

UPDATE employees
SET experience_at_VivaK = PERIOD_DIFF( -- PERIOD_DIFF() can calculate the month difference  
	EXTRACT(YEAR_MONTH FROM NOW()), 
    EXTRACT(YEAR_MONTH FROM hire_date));

/*
2. (4 Marks) last_performance_rating: to test the system, generate a random performance rating figure (a
decimal number with two decimal points between 0 and 10) for each employee and update the column. 
*/

UPDATE employees
SET last_performance_rating = ROUND(RAND()*10, 2);

/*
3. (6 Marks) salary_after_increment: calculate the salary after the performance appraisal 
   and update the column by using the following formulas:
   salary_after_increment = salary * increment
   increment = 1 + (0.01 * experience_at_VivaK) + rating_increment
*/

UPDATE employees AS e
	INNER JOIN (
		SELECT
			employee_id,
            (CASE
				WHEN last_performance_rating >= 0.9 THEN 0.15
				WHEN last_performance_rating >= 0.8 THEN 0.12
                WHEN last_performance_rating >= 0.7 THEN 0.10
				WHEN last_performance_rating >= 0.6 THEN 0.08
                WHEN last_performance_rating >= 0.5 THEN 0.05
				ELSE 0.02
			END) AS rating_increment
		FROM employees) AS attachedInfo USING(employee_id)
SET salary_after_increment = ROUND(e.salary * (1 + (0.01 * e.experience_at_VivaK) + attachedInfo.rating_increment), 2);
-- All salary-related columns must be double. Data must be recorded in 2 decimals.

/*
4. (6 Marks) annual_dependent_benefit: Calculate the annual dependent benefit per dependent (in USD) 
   and update the column as per the table below:
*/
UPDATE dependents
	INNER JOIN (SELECT 
		d.dependent_id,
        e.salary AS salary,
		(CASE 
			WHEN dp.department_name = "Executive" THEN 0.2 -- There is no Executive in job_title, but department_name has it.
			WHEN os.job_title LIKE "%Manager%" THEN 0.15 -- job_title contains Manager keyword.
			ELSE 0.05
		END) AS benefit_ratio
	FROM dependents AS d
		LEFT JOIN employees AS e
			LEFT JOIN orgStructures AS os 
				INNER JOIN departments AS dp USING(department_id)
            USING(job_id)
		USING(employee_id)) AS attachInfo USING(dependent_id)
SET annual_dependent_benefit = ROUND(attachInfo.benefit_ratio * attachInfo.salary, 2); 
-- All salary-related columns must be double. Data must be recorded in 2 decimals.

/*
5. (5 Marks) email: Until recently, the employees were using their private email addresses, and the
company has recently bought the domain VivaK.com. Replace employee email addressed to
‘<emailID>@vivaK.com’. emailID is the part of the current employee email before the @ sign. 
*/

UPDATE employees
SET email = REPLACE(email, 
	SUBSTRING_INDEX(email, '@', -1), 'vivaK.com'); -- we devide the string by '@' and use the first value (that means email before the @ sign).
