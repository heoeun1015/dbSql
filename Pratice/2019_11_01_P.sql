

-- ■ emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보 조회 ----------------------------
-- 직원 정보조회 (BETWEEN AND 사용)


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보 조회 ----------------------------
-- 직원 정보조회 (AND 사용)


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ emp 테이블에서 관리자(mgr)가 있는 직원만 조회 --------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where13 ----------------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
-- (like 연산자를 사용X)


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where14 ----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를
-- 다음과 같이 조회하세요.


----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ job을 기준으로 내림차순으로 정렬, 만약 job이 같을 경우 사번(empno) 으로 오름차순 정렬 -----------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ ORDER BY 실습 orderby1 -----------------------------------------------------------------------------------------------------------------
-- dept 테이블의 모든 정보를 부서이름으로 오름차순	 정렬로 조회되도록 쿼리를 작성하세요.


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ ORDER BY 실습 orderby2 -----------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여(comm)를 많이 받는 사람이 먼저 조회되도록 하고,
-- 상여가 같을 경우 사번으로 오름차순 정렬하세요.


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ ORDER BY 실습 orderby3 -----------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job) 순으로 오름차순 정렬하고,
-- 직업이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.


---------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ ORDER BY 실습 orderby4 -----------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회하고
-- 이름으로 내림차순 정렬되도록 쿼리를 작성하세요.


---------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 가상컬럼 ROWNUM 실습 row_1 ----------------------------------------------------------------------------------------------------------
-- emp 테이블에서 ROWNUM 값이 1 ~ 10인 값만 조회하는 쿼리를 작성해보세요.


---------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 가상컬럼 ROWNUM 실습 row_2 ----------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------
