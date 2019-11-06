-- 그룹함수
-- multi row funciton   :   여러 개의 행을 이볅으로 하나의 결과 행을 생성
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

-- 직원 중 가장 높은 급여 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

-- 부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;

10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON;

SELECT *
FROM emp;

-- ■ Function (group function 실습 grp3) ------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여 다음을 구하시오.
-- grp2에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올 수 있도록 수정하시오.
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname,       -- 부서가 개편이 될 때마다 수정해야 하는 문제가 있음
              MAX(sal) max_sal,
              MIN(sal) min_sal,
              ROUND(AVG(sal), 2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(sal) count_sal,
              COUNT(mgr) count_mgr,
              COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT')
ORDER BY max_sal DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM emp;

-- ■ Function (group function 실습 grp4) ------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여 다음을 구하시오.
-- 직원의 입사 년월별로 몇 명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.
SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- SELECT 절에 나오는 조건은 GROUP BY 절에도 가능한 똑같이 오는게 좋다.

-- ■ Function (group function 실습 grp5) ------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여 다음을 구하시오.
-- 직원의 입사 년별로 몇 명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.
SELECT TO_CHAR(hiredate,'YYYY') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');      -- 10이후부터는 고정 안 함. GROUP BY 절에 있는 구문으로 조건이 안 되게 바꿨다.
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ Function (group function 실습 grp6) ------------------------------------------------------------------------------------------------------
-- 회사에 존재하는 부서의 개수는 몇 개인지 조회하는 쿼리를 작성하시오.
SELECT COUNT(deptno) cnt
FROM dept;

SELECT COUNT(*) cnt
FROM dept;

SELECT DISTINCT deptno      -- DISTINCT: 중복을 제거한 값을 알고 싶을 때 사용
FROM emp;

--SELECT COUNT(*) cnt
--FROM
--            (SELECT COUNT(deptno)
--            FROM emp
--            GROUP BY deptno);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN
-- emp 테이블에는 ename 컬럼이 없다. → 부서번호(deptno) 밖에 없음
desc emp;

-- emp 테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));   -- 어떤 테이블을 가져와서 추가할 거냐면,
desc dept;

-- RDBMS의 경우, 모든 행에 영향을 끼친다.
SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE deptno = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE deptno = 20;
UPDATE emp SET dname = 'SALES' WHERE deptno = 30;
COMMIT;     -- 커밋 완료

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

-- RDBMS에서 중복을 제거하는 방법(JOIN)

ALTER TABLE emp DROP COLUMN DNAME;      -- dname 제거

SELECT *
FROM emp;





-- ansi natural join    :   테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN을 해준다.
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

-- oracle join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc       -- 필요한 컬럼명만 이렇게 가져올 수 있다.
--SELECT empno, ename, emp.deptno, dept.dname, dept.loc     --로도 사용 가능. deptno 빼고.
FROM emp, dept
WHERE emp.deptno = dept.deptno;


SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;




-- ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);


-- from 절에 조인 대상 테이블 나열
-- where 절에 조인 조건 기술
-- 기존에 사용하던 조건 제약도 기술 가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- job이 SALES인 사람만 대상으로 조회
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.job = 'SALESMAN';
        
        
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
    AND emp.deptno = dept.deptno;
-- 논리적인 부분만 보기 때문에 WHERE와 AND의 순서가 바뀌어도 상관이 없다.







-- JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- 아래 oracle 문법과 동일함
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;






-- SELF join : 같은 테이블끼리 조인
-- emp 테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야 한다.
-- a: 직원 정보, b: 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b. empno);
-- emp의 사원정보, a의 관리자정보를 조회하기 위해 써줌.
-- mgr가 null인 값이 하나 있음. 그래서 13행이 조회된다.


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b. empno)
WHERE a.empno BETWEEN 7369 AND 7698;
-- 추가 조건 기술

-- oracle
--SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
--FROM emp a, emp b
--WHERE a.mgr = b.empno
--     AND a.empno BETWEEN 7369 AND 7698;

-- RDBMS에서 JOIN은 필수
SELECT b.empno, b.ename, a.empno, a.ename, a.mgr
FROM emp b, emp a
WHERE  b.empno = a.mgr
     AND a.empno BETWEEN 7369 AND 7698;






-- non-equijoing (등식 조인이 아닌 경우)
SELECT *
FROM salgrade;

-- 직원의 급여 등급은?
-- 조건이 반드시 equl일 필요는 없다. 다른 걸로 해줘도 됨.
SELECT  empno, ename, sal
FROM emp;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON( emp.sal BETWEEN salgrade.losal AND salgrade.hisal );






-- non equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
     AND a.empno = 7369;
     
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369;
-- a, b 사이의 가능한 모든 조합이 나온다. (cross join, 묻지마 조인) 이유를 묻지 말아라.

SELECT *
FROM emp;


-- ■ 데이터 결합 (실습 join 0) --------------------------------------------------------------------------------------------------------------------
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
SELECT a.empno, a.ename, a.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno)
ORDER BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join 1) --------------------------------------------------------------------------------------------------------------------
-- emp, dept  테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (부서번호가 10, 30인 데이터만 조회)
SELECT a.empno, a.ename, a.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
      AND a.deptno IN (10, 30);

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE deptno IN (10, 30);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 만약 dept 30이 두 개가 있으면 emp dept에 대한 결과는 2개가 나온다. 논리적으로 생각할 것.



SELECT *
FROM emp NATURAL JOIN dept;



