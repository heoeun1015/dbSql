
SELECT job, NVL(deptno, 0) deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


-- GROUPING (cube, rollup 절의 사용된 컬럼)
-- 해당 컬럼이 소계 게산에 사용된 경우 1
-- 사용되지 않은 경우 0

-- job 컬럼
-- case1. GROUPING (job) = 1 AND GROUPING(depno) = 1
--              job → '총계'
-- case else
--              job → 'job'
SELECT CASE WHEN GROUPING(job) = 1 AND
                                    GROUPING(deptno) = 1 THEN '총계'
                         ELSE  job
               END job, deptno,
               
        -- GROUPING (job), GROUPING(deptno)
        --SELECT job, deptno,
            GROUPING (job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
-- 사용이 됐으면 1, 사용되지 않았으면 0



SELECT job, deptno,
            GROUPING (job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- ■ GROUP_AD 2 -----------------------------------------------------------------------------------------------------------------------------------
SELECT CASE WHEN GROUPING(job) = 1 AND
                                    GROUPING(deptno) = 1 THEN '총계'
                         ELSE  job
               END job,
               CASE WHEN GROUPING(job) = 0 AND
                                     GROUPING(deptno) = 1 THEN job || ' 소계'
                         WHEN GROUPING(job) = 1 AND
                                     GROUPING(deptno) = 1 THEN NULL
                         ELSE  TO_CHAR(deptno)
                  END deptno,
GROUPING (job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ GROUP_AD 3 -----------------------------------------------------------------------------------------------------------------------------------

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



-- CUBE (col, col2 …)
-- CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브그룹으로 생성
-- CUBE에 나열된 컬럼에 대해 방향성은 없다. (rollup과의 차이)

-- GROUP BY CUBE(job, deptno)
-- 00 : GROUP BU job, deptno
-- 0X : GROUP BY job
-- X0 : GROUP BY deptno
-- XX : GROUP BY -- 모든 데이터에 대해서

-- GROUP BY CUBE(job)
-- GROUP BY CUBE(job, deptno)
-- GROUP BY CUBE(job, deptno, mgr)      
        -- 컬럼이 조금만 많아져도 조건이 기하급수적으로 늘기 때문에 원하는 형태의 GROUP BY 를 넘어가버린다. 잘 쓰이지 않음.

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);



SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY deptno, job
ORDER BY deptno ;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- subquery 를 통한 업데이트
DROP TABLE emp_test;

-- emp 테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test 테이블로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- emp_test 테이블의 dept 테이블에서 관리되고 있는 dname(VARCHAR2(14)) 컬럼을 추가
DESC dept;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;


-- emp_test 테이블의 dname 컬럼을 dept테이블의 dname 컬럼 값으로 업데이트하는 쿼리를 작성
UPDATE emp_test SET dname = ( SELECT dname
                                                       FROM dept
                                                       WHERE dept.deptno = emp_test.deptno);
                                                       -- emp_test의 데이터를 먼저 읽고 그 후 dept 테이블을 읽어 해당 쿼리를 조회함.
WHERE empno IN (7369, 7499);    -- 만약 emp_test에 대한 조건을 줄 거면 여기에 주자.

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
                                                    
-- ※ 없는 부서일 경우에 0으로 들어가는 건 GROUP BY 절의 특징.
-- 0으로 나온 것과 아예 나오지 않은 건 차이가 있다. 0은 계산을 한 거고, NULL 은 값이 아예 없는 것.



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

-- ■ GROUP_AD 3 -----------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM emp_test;

UPDATE emp_test SET sal + 200;


SELECT *
FROM emp_test a
WHERE deptno = 10
AND sal < (SELECT ROUND(AVG(sal), 0)
                    FROM emp_test b
                    WHERE b.deptno = a.deptno);
-- 여기서 부서조건을 제거

UPDATE emp_test a SET sal = sal + 200
WHERE sal < (SELECT ROUND(AVG(sal), 0)
                        FROM emp_test b
                        WHERE b.deptno = a.deptno);

-- emp, emp_test empno 컬럼으로 같은 값끼리 조회
-- 1. emp.empno, emp.ename, emp.sal / emp_test.sal
-- 2. emp.empno, emp.ename, emp.sal / emp_test.sal
-- 해당사원(emp 테이블 기준)이 속한 부서의 급여평균

SELECT a.empno, a.ename, a.sal, b.sal, a.deptno, ROUND(c.emp_sal, 2) sal_avg
FROM emp a, emp_test b, (SELECT deptno, AVG(sal) emp_sal
                                            FROM emp
                                            GROUP BY deptno) c
WHERE a.empno = b.empno
      AND a.deptno = c.deptno
ORDER BY deptno DESC;











