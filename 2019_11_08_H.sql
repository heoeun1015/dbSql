
2019_11_08_과제

-- ■ 데이터 결합 (실습 join8) ---------------------------------------------------------------------------------------------------------------------
-- 데이터 결합 (실습 join8)
-- erd 다이어그램을 참고하여 countries, regions 테이블을 이용하여 지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를
-- 작성해보세요. (지역은 유럽만 한정)
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT countries.region_id, region_name, country_name
FROM countries JOIN regions ON (countries.region_id = regions.region_id AND region_name = 'Europe');

SELECT countries.region_id, region_name, country_name
FROM countries, regions
WHERE countries.region_id = regions.region_id
      AND region_name = 'Europe';
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join9) ---------------------------------------------------------------------------------------------------------------------
--  테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 겨로가가 나오도록 쿼리를 작성해보세요.
-- (지역은 유럽만 한정)
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM locations;

SELECT countries.region_id, region_name, country_name, city
FROM countries JOIN regions ON (countries.region_id = regions.region_id AND region_name = 'Europe')
            JOIN locations ON (countries.country_id = locations.country_id);

SELECT countries.region_id, region_name, country_name, city
FROM countries, regions, locations
WHERE countries.region_id = regions.region_id
        AND region_name = 'Europe'
        AND countries.country_id = locations.country_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join10) --------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 countries, regions, locations, departments 테이블을 이용하여 지역별 소속 국가, 국가에 소속된
-- 도시 이름 및 도시에 잇는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요. (지역은 유럽만 한정)
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM locations;

SELECT *
FROM departments;

SELECT countries.region_id, region_name, country_name, city, department_name
FROM countries JOIN regions ON (countries.region_id = regions.region_id AND region_name = 'Europe')
           JOIN locations ON (countries.country_id = locations.country_id)
           JOIN departments ON (locations.location_id = departments.location_id);
           
SELECT countries.region_id, region_name, country_name, city, department_name
FROM countries, regions, locations, departments
WHERE countries.region_id = regions.region_id
        AND region_name = 'Europe'
        AND countries.country_id = locations.country_id
        AND locations.location_id = departments.location_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join11) --------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 countries, regions, locations, departments, employees 테이블을 이용하여 지역별 소속 국가,
-- 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원 정보를 다음과 같은 결과가 나오도록 쿼리를
-- 작성해보세요. (지역은 유럽만 한정)
SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM locations;

SELECT *
FROM departments;

SELECT *
FROM employees;

SELECT countries.region_id, region_name, country_name, city, department_name, employees.first_name || employees.last_name name
FROM countries JOIN regions ON (countries.region_id = regions.region_id AND region_name = 'Europe')
           JOIN locations ON (countries.country_id = locations.country_id)
           JOIN departments ON (locations.location_id = departments.location_id)
           JOIN employees ON (departments.department_id = employees.department_id);
           
SELECT countries.region_id, region_name, country_name, city, department_name, employees.first_name || employees.last_name name
FROM countries, regions, locations, departments, employees
WHERE countries.region_id = regions.region_id
        AND region_name = 'Europe'
        AND countries.country_id = locations.country_id
        AND locations.location_id = departments.location_id
        AND departments.department_id = employees.department_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join12) --------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭을 포함하여 다음과 같은 결과가
-- 나오도록 쿼리를 작성해보세요.
SELECT *
FROM employees;

SELECT *
FROM jobs;

SELECT employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
FROM employees JOIN jobs ON (employees.job_id = jobs.job_id);

SELECT employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join13) --------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭, 직원의 매니저 정보를 포함하여
-- 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
SELECT *
FROM employees;

SELECT *
FROM jobs;

SELECT manager_id mng_id, employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
FROM employees JOIN jobs ON (employees.job_id = jobs.job_id);
--
--with mng_table as (
--SELECT manager_id, employees.first_name || employees.last_name name
--FROM employees);
--
--SELECT NVL(employees.manager_id, 100) mng_id, mng_table.name, employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
--FROM employees, jobs, (SELECT manager_id, employees.first_name || employees.last_name name
--                                        FROM employees) mng_table
--WHERE employees.job_id = jobs.job_id
--    AND employees.employee_id = mng_table.manager_id
--    AND employees.manager_id IS NULL;
--    
--SELECT employees.manager_id mng_id, employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
--FROM employees, jobs
--WHERE employees.job_id = jobs.job_id;

SELECT b.manager_id, b.first_name || employees.last_name mgr_name, employees.employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
FROM employees, jobs, employees b
WHERE employees.job_id = jobs.job_id
        AND employees.employee_id = b.manager_id
        AND b.manager_id = 100;
        
SELECT b.manager_id, a.employee_id, a.first_name || a.last_name name, a.job_id, job_title
FROM employees a, jobs, employees b
WHERE a.job_id = jobs.job_id
    AND a.employee_id = b.manager_id
    AND b.manager_id = 100;

SELECT a.manager_id, a.employee_id, a.first_name, b.first_name, a.job_id
FROM employees a, employees b, jobs
WHERE a.employee_id = b.manager_id
    AND a.job_id = jobs.job_id
    AND a.manager_id = 100;
    
SELECT employees.employee_id, employees.first_name || employees.last_name name, employees.job_id, job_title
FROM employees, jobs, employees b
WHERE employees.job_id = jobs.job_id
    AND employees.employee_id = b.manager_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------

