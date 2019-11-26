
-- WINDOW 함수
-- RANK 함수 : 순위 구하기. 동일 값에 대해서는 동일 순위를 부여한다.
-- DENSE_RANK : 순위 구하기. 동일 값에 대해서는 동일 순위를 부여한다.
-- ROW_NUMBER : 순위 구학. 동일 값이라도 별도의 순위를 부여 (중복이 없다.)
SELECT ename, sal, deptno,
              RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
              DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
              ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

-- ■ 분석함수 / window 함수 (실습 ana1) -------------------------------------------------------------------------------------------------------
-- 사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요.
-- 단, 급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 작성하세요.
SELECT empno, ename, sal, deptno,
              RANK() OVER (ORDER BY sal DESC, empno) rank,
              DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
              ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown     -- 중첩이 되지 않기 때문에 세 함수의 값은 동일하다.
FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 분석함수 / window 함수 (실습 no_ana2) ---------------------------------------------------------------------------------------------------
-- 기존의 배운 내용을 활용하여, 모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리를
-- 작성하시오. ( 그 아래에는 분석함수를 사용하여 작성하시오. )
SELECT *
FROM emp;

SELECT empno, ename, emp.deptno, a.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
                     FROM emp
                     GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY emp.deptno;

-- 
SELECT ename, empno, deptno,
             COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------


-- 분석함수를 통한 부서별 직원수 (COUNT)
SELECT ename, empno, deptno,
             COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- 부서별 사원의 급여 합계
-- SUM 분석함수
SELECT ename, empno, deptno, sal,
             SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;


-- ■ 분석함수 / window 함수 (실습 ana2) ---------------------------------------------------------------------------------------------------
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당 사원이 속한 부서의
-- 급여 평균을 조회하는 쿼리를 작성하세요. (급여 평균은 소수점 둘째 자리까지 구한다.)
SELECT *
FROM emp;

SELECT empno, ename, sal, deptno,
              ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 분석함수 / window 함수 (실습 ana3) ---------------------------------------------------------------------------------------------------
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당 사원이 속한 부서의
-- 가장 높은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno,
              MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 분석함수 / window 함수 (실습 ana4) ---------------------------------------------------------------------------------------------------
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당 사원이 속한 부서의
-- 가장 낮은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno,
              MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------


-- FIRST_VALUE, LAST_VALUE : 순서가 있음.
-- 부서별 사원번호가 가장 빠른 사람
-- 부서별 사원번호가 가장 느린 사람
SELECT *
FROM emp
WHERE deptno = 20;

-- 자기 자신을 기준?
-- 재확인 필요
SELECT empno, ename, deptno,
              FIRST_VALUE (empno) OVER (PARTITION BY deptno) f_emp,
              LAST_VALUE (empno) OVER (PARTITION BY deptno) l_emp
FROM emp;


-- LAG (이전 행)
-- 현재 행
-- LEAD (다음 행)
-- 급여가 높은 순으로 정렬했을 때 자기보다 한 단계 급여가 낮은 사람의 급여, 높은 사람의 급여

SELECT empno, ename, sal,
              LAG(sal) OVER (ORDER BY sal) lag_sal,
              LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;


-- ■ 분석함수 / window 함수 (실습 ana5) ---------------------------------------------------------------------------------------------------
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원중 급여 순위가 1단계
-- 낮은 사람의 급여를 조회하는 쿼리를 작성하세요. (급여가 같은 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate, sal,
              LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
--              LAG(sal) OVER (ORDER BY sal, hiredate) lead_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 분석함수 / window 함수 (실습 ana6) ---------------------------------------------------------------------------------------------------
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job), 급여 정보와 담당업무(JOB)별
-- 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요. (급여가 같은 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate, job, sal,
            LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) rag_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM emp
ORDER BY sal;

SELECT empno, ename, sal
FROM emp
ORDER BY sal;


-- WINDOWING
-- UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
-- CURRENT ROW : 현재 행
-- UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
-- N (정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
-- N (정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
              SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
              SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
              SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;


-- ■ 분석함수 / window 함수 (실습 ana7) ---------------------------------------------------------------------------------------------------
-- 사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을 때, 자신의 급여와
-- 선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요. (window 함수 사용)
SELECT empno, ename, deptno, sal,
              SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------



-- BETWEEN 을 쓰지 않더라도 자기 행까지 기준이 된다. (기본값)
-- 선생님은 길더라도 위쪽을 좀 더 선호하심.
SELECT empno, ename, deptno, sal,
              SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
              SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
              SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
              SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;
-- range의 경우 동일한 값은 전부 합한 값이 먼저 나온다. 같은 값은 하나의 행으로 생각함.




