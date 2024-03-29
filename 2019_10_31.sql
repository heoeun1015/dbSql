-- 테이블에서 데이터 조회
/*
    SELECT 컬럼 | express (문자열 상수) [as] 별칭
    FROM 데이터를 조회할 테이블 (VIEW)
    WHERE 조건 (condition)
*/

DESC user_tables;

SELECT 'TEST'
FROM emp;

SELECT table_name
FROM user_tables
WHERE TABLE_NAME != 'EMP';
-- 전체 건수 -1



-- 숫자비교 연산
-- 부서 번호가 30번보다 크거나 같은 부서에 속한 직원
SELECT *
FROM emp
--desc emp; -- 더 자세히 보려면 적어줄 것
WHERE deptno >= 30;

SELECT *
FROM dept;

-- ■ 부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;



-- 날짜 쿼리를 작성할 때는 어디서든 돌아가는 형식을 사용하는게 좋다.

-- 입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
WHERE hiredat < '82/01/01';        -- 문자열인데 왜 날짜로 인식을 했냐면 각 프로그램 차이.. 옵션에 설정되어 있다. YY/MM/DD
--WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY');             --11명
--WHERE hiredate < TO_DATE('19820101', 'YYYYMMDD');             --11명
--WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');            -- 3명
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

-- col BETWEEN X AND Y 연산
-- 컬럼의 값이 x보다 크거나 같고, y보다 작거나 같은 데이터
-- 급여가(sal)가 1000보다 크거나 같고, 2000 보다 작거나 같은 데이터를 조회 (포함의 개념)
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- 위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다.
SELECT *
FROM emp
WHERE sal >= 1000
      and sal <= 2000
      and deptno = 30;


-- ■ BEETWEEN … AND …  실습 where1-- --------------------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 입사 일자가 1982년 1월 1일부터 1983년 1월 1일 이전인 사원이 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오.
--  (BETWEEN 사용)
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') and TO_DATE('1983/01/01','YYYY/MM/DD');
--WHERE hiredate BETWEEN '82/01/01' and '83/01/01';
--WHERE hiredate BETWEEN '1982/01/01' and '1983/01/01';
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ >=, >, <=, < 실습 where2 -------------------------------------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 입사 일자가 1982년 1월 1일부터 1983년 1월 1일 이전인 사원이 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오.
--  (비교연산자 사용)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD')
      and hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- IN  연산자
-- COL IN (values…)
-- 부서번호가 10 혹은 20인 직원 조회

SELECT *
FROM emp
WHERE deptno in (10, 20);

-- IN 연산자는 OR 연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10
        OR deptno = 20;
        
        
-- ■ IN 실습 where 3 ----------------------------------------------------------------------------------
-- users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오.
-- (IN 연산자 사용) 아이디 / 이름 / 별명
SELECT userid 아이디, usernm 이름
FROM users
WHERE userid in ('brown', 'cony', 'sally');
------------------------------------------------------------------------------------------------------------

-- COL LIKE 'S%'
-- COL의 값이 대문자 S로 시작하는 모든 값
-- COL LIKE 'S____'
-- COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

-- emp 테이블에서 직원 이름이 s로 시작하는 모든 직원 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';    --값은 대소문자를 가린다.

SELECT *
FROM emp
WHERE ename LIKE 'S____'; 

-- ■ LIKE, %, _ 실습 where4 -----------------------------------------------------------------------------------------------
-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';
-----------------------------------------------------------------------------------------------------------------------------------


-- ■ LIKE, %, _ 실습 where5 ------------------------------------------------------------------------------------------------------------------------
-- member 테이블에서 회원의 이름에 글자 [이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- NULL 비교
-- col IS NULL
-- EMP 테이블에서 MGR 정보가 없는 사람(NULL) 조회
SELECT *
FROM emp
WHERE MGR IS NULL;
-- WHERE MGR != NULL;           -- null 비교가 실패한다.

-- 소속 부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';

-- =, !=
-- is null, is not null


-- ■ IS NULL 실습 where6 ------------------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오.
SELECT *
FROM emp
WHERE comm IS NOT NULL;
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- AND
-- 관리자(mgr) 사번이 7698이고 급여가 1000 이상인 직원 조회
SELECT *
FROM emp
WHERE mgr = 7698
       and sal >= 1000;

-- OR
-- 관리자(mgr) 사번이 7698이거나 급여가 1000 이상인 직원 조회        
SELECT *
FROM emp
WHERE mgr = 7698
        OR sal >= 1000;


-- emp 테이블에서 관리자(mgr) 사번이 7698이 아니고, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);      -- IN → OR

-- 위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr != 7698
     AND mgr != 7839;


-- IN, NOT IN 연산자의 NULL 처리
-- emp 테이블에서 관리자(mgr) 사번이 7698, 7839 또는 NULL이 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL); --NULL 값이 있으면 무시해버린다. 주의할 것.
            
-- IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다.
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
    AND mgr IS NOT NULL;

-- 문자열은 ''를 반드시 붙일 것!
    
-- ■ AND, OR 실습 where7 -----------------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
      AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where8 -----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
--(IN, NOT IN 연산자 사용금지)
SELECT *
FROM emp
WHERE deptno != 10
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where9 -----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
--(NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN(10)
      AND hiredate >= (TO_DATE('1981/06/01', 'YYYY/MM/DD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where10 ----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
--(부서는 10, 20, 30만 있다고 가정하고 IN 연산자를 사용)
SELECT *
FROM emp
WHERE deptno IN(20, 30)
      AND hiredate >= (TO_DATE('1981/06/01', 'YYYY/MM/DD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where11 ----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'      -- job in ('SALESMAN')
        OR  hiredate >= (TO_DATE('1981/06/01', 'YYYY/MM/DD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where12 ----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job  = 'SALESMAN'
        OR empno LIKE '78%';
----------------------------------------------------------------------------------------------------------------------------------------------------------

