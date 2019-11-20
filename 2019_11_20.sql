
SELECT job, NVL(deptno, 0) deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� �Ի꿡 ���� ��� 1
-- ������ ���� ��� 0

-- job �÷�
-- case1. GROUPING (job) = 1 AND GROUPING(depno) = 1
--              job �� '�Ѱ�'
-- case else
--              job �� 'job'
SELECT CASE WHEN GROUPING(job) = 1 AND
                                    GROUPING(deptno) = 1 THEN '�Ѱ�'
                         ELSE  job
               END job, deptno,
               
        -- GROUPING (job), GROUPING(deptno)
        --SELECT job, deptno,
            GROUPING (job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
-- ����� ������ 1, ������ �ʾ����� 0



SELECT job, deptno,
            GROUPING (job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- �� GROUP_AD 2 -----------------------------------------------------------------------------------------------------------------------------------
SELECT CASE WHEN GROUPING(job) = 1 AND
                                    GROUPING(deptno) = 1 THEN '�Ѱ�'
                         ELSE  job
               END job,
               CASE WHEN GROUPING(job) = 0 AND
                                     GROUPING(deptno) = 1 THEN job || ' �Ұ�'
                         WHEN GROUPING(job) = 1 AND
                                     GROUPING(deptno) = 1 THEN NULL
                         ELSE  TO_CHAR(deptno)
                  END deptno,
GROUPING (job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� GROUP_AD 3 -----------------------------------------------------------------------------------------------------------------------------------

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--SELECT deptno, job, SUM(sal)
--FROM emp
--GROUP BY ROLLUP(job, deptno)
--ORDER BY deptno;
--
--SELECT *
--FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------



-- CUBE (col, col2 ��)
-- CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ����׷����� ����
-- CUBE�� ������ �÷��� ���� ���⼺�� ����. (rollup���� ����)

-- GROUP BY CUBE(job, deptno)
-- 00 : GROUP BU job, deptno
-- 0X : GROUP BY job
-- X0 : GROUP BY deptno
-- XX : GROUP BY -- ��� �����Ϳ� ���ؼ�

-- GROUP BY CUBE(job)
-- GROUP BY CUBE(job, deptno)
-- GROUP BY CUBE(job, deptno, mgr)      
        -- �÷��� ���ݸ� �������� ������ ���ϱ޼������� �ñ� ������ ���ϴ� ������ GROUP BY �� �Ѿ������. �� ������ ����.

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);



SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY deptno, job
ORDER BY deptno ;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- subquery �� ���� ������Ʈ
DROP TABLE emp_test;

-- emp ���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test ���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- emp_test ���̺��� dept ���̺��� �����ǰ� �ִ� dname(VARCHAR2(14)) �÷��� �߰�
DESC dept;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;


-- emp_test ���̺��� dname �÷��� dept���̺��� dname �÷� ������ ������Ʈ�ϴ� ������ �ۼ�
UPDATE emp_test SET dname = ( SELECT dname
                                                       FROM dept
                                                       WHERE dept.deptno = emp_test.deptno);
                                                       -- emp_test�� �����͸� ���� �а� �� �� dept ���̺��� �о� �ش� ������ ��ȸ��.
WHERE empno IN (7369, 7499);    -- ���� emp_test�� ���� ������ �� �Ÿ� ���⿡ ����.

COMMIT;

------------------------------------------

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT *
FROM dept_test;

SELECT *
FROM emp_test;

ALTER TABLE dept_test ADD (empcnt NUMBER);
                                                    
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                                    FROM emp_test
                                                    WHERE dept_test.deptno = deptno);
                                                    
-- �� ���� �μ��� ��쿡 0���� ���� �� GROUP BY ���� Ư¡.
-- 0���� ���� �Ͱ� �ƿ� ������ ���� �� ���̰� �ִ�. 0�� ����� �� �Ű�, NULL �� ���� �ƿ� ���� ��.



-- 
DESC dept_test;


INSERT INTO dept_test VALUES (98, 'it1', 'daejeon', 0);
INSERT INTO dept_test VALUES (99, 'it2', 'daejeon', 0);

DROP TABLE dept_test WHERE empcnt = (SELECT *
                                                                    FROM dept_test b
                                                                    WHERE dept_test.empcnt = b.empcnt);
                                                                    
SELECT *
FROM dept_test;

ROLLBACK;

DELETE dept_test
WHERE NOT EXISTS (SELECT  COUNT(*)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY deptno);

--DELETE dept_test
--WHERE empcnt = (SELECT  COUNT(*)
--                                FROM emp
--                                WHERE emp.deptno = dept_test.deptno
--                                GROUP BY deptno);

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                                        FROM emp);
                                        
                                        
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                                    FROM emp_test
                                                    WHERE dept_test.deptno = deptno);

-- �� GROUP_AD 3 -----------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM emp_test;

UPDATE emp_test SET sal + 200;


SELECT *
FROM emp_test a
WHERE deptno = 10
AND sal < (SELECT ROUND(AVG(sal), 0)
                    FROM emp_test b
                    WHERE b.deptno = a.deptno);
-- ���⼭ �μ������� ����

UPDATE emp_test a SET sal = sal + 200
WHERE sal < (SELECT ROUND(AVG(sal), 0)
                        FROM emp_test b
                        WHERE b.deptno = a.deptno);

-- emp, emp_test empno �÷����� ���� ������ ��ȸ
-- 1. emp.empno, emp.ename, emp.sal / emp_test.sal
-- 2. emp.empno, emp.ename, emp.sal / emp_test.sal
-- �ش���(emp ���̺� ����)�� ���� �μ��� �޿����

SELECT a.empno, a.ename, a.sal, b.sal, a.deptno, ROUND(c.emp_sal, 2) sal_avg
FROM emp a, emp_test b, (SELECT deptno, AVG(sal) emp_sal
                                            FROM emp
                                            GROUP BY deptno) c
WHERE a.empno = b.empno
      AND a.deptno = c.deptno
ORDER BY deptno DESC;











