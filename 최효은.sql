
2019_11_08_����

-- �� ������ ���� (�ǽ� join8) ---------------------------------------------------------------------------------------------------------------------
-- ������ ���� (�ǽ� join8)
-- erd ���̾�׷��� �����Ͽ� countries, regions ���̺��� �̿��Ͽ� ������ �Ҽ� ������ ������ ���� ����� �������� ������
-- �ۼ��غ�����. (������ ������ ����)
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

-- �� ������ ���� (�ǽ� join9) ---------------------------------------------------------------------------------------------------------------------
--  ���̺��� �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸��� ������ ���� �ܷΰ��� �������� ������ �ۼ��غ�����.
-- (������ ������ ����)
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

-- �� ������ ���� (�ǽ� join10) --------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� countries, regions, locations, departments ���̺��� �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ�
-- ���� �̸� �� ���ÿ� �մ� �μ��� ������ ���� ����� �������� ������ �ۼ��غ�����. (������ ������ ����)
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

-- �� ������ ���� (�ǽ� join11) --------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� countries, regions, locations, departments, employees ���̺��� �̿��Ͽ� ������ �Ҽ� ����,
-- ������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ� �μ�, �μ��� �Ҽӵ� ���� ������ ������ ���� ����� �������� ������
-- �ۼ��غ�����. (������ ������ ����)
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

-- �� ������ ���� (�ǽ� join12) --------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������ ������ ��Ī�� �����Ͽ� ������ ���� �����
-- �������� ������ �ۼ��غ�����.
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

-- �� ������ ���� (�ǽ� join13) --------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������ ������ ��Ī, ������ �Ŵ��� ������ �����Ͽ�
-- ������ ���� ����� �������� ������ �ۼ��غ�����.
SELECT *
FROM employees;

SELECT *
FROM jobs;

SELECT b.employee_id mng_id, b.first_name || b.last_name mgr_name, a.employee_id, a.first_name || a.last_name name, a.job_id, job_title
FROM employees a JOIN employees b ON (a.manager_id = b.employee_id) JOIN jobs ON (a.job_id = jobs.job_id);
    
SELECT b.employee_id mng_id, b.first_name || b.last_name mgr_name, a.employee_id, a.first_name || a.last_name name, a.job_id, job_title
FROM employees a, employees b, jobs
WHERE a.job_id = jobs.job_id
    AND a.manager_id = b.employee_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------

