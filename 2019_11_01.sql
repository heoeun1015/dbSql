-- 복습
-- WHERE
-- 연산자
-- 비교: =, !=, <>, >=, >, <=. <
-- BETWEEN start AND end
-- IN (set) 
-- LIKE 'S%'
--  - (%: 다수의 문자열과 매칭)
--  - (_: 정확히 한 글자 매칭)
-- IS NULL( != NULL )
-- AND, OR, NOT


-- ■ emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보 조회 ----------------------------
-- 직원 정보조회 (BETWEEN AND 사용)
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD') AND TO_DATE('1986/12/31', 'YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보 조회 ----------------------------
-- 직원 정보조회 (AND 사용)
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')
      AND  hiredate <= TO_DATE('1986/12/31', 'YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ emp 테이블에서 관리자(mgr)가 있는 직원만 조회 --------------------------------------------------------------------------------------
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- desc(description)
-- empno : 78, 780, 789
desc emp;


-- ■ AND, OR 실습 where13 ----------------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
-- (like 연산자를 사용X)
SELECT *
FROM emp
WHERE job  = 'SALESMAN'
        OR empno BETWEEN 7800 AND 7899; 
        
SELECT *
FROM emp
WHERE job  = 'SALESMAN'
        OR empno BETWEEN 7800 AND 7899
        OR empno BETWEEN 780 AND 789
        OR empno = 78;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ AND, OR 실습 where14 ----------------------------------------------------------------------------------------------------------------------
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를
-- 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
        OR ( empno LIKE '78%' AND  hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') );
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- AND, OR의 우선순위는 AND가 먼저이지만, 가능한 () 를 써주는게 알아보기 쉽다.

-- order by 컬럼명 | 별칭 | 컬럼인덱스 [ ASC | DESX ]
-- order by 구문은 WHERE절 다음에 기술
-- WHERE 절이 없을 경우 FROM 다음에 기술
-- emp 테이블을 ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

-- ASC : default
-- ASC를 안 붙여도 위 쿼리와 동일한 결과를 출력한다.
SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename DESC;

-- ■ job을 기준으로 내림차순으로 정렬, 만약 job이 같을 경우 사번(empno) 으로 오름차순 정렬 -----------------------------------
SELECT *
FROM emp
ORDER BY job DESC, empno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 별칭으로 정렬하기
-- 사원 번호(empno), 사원명(ename), 연봉(sal * 12) as year_sal
-- year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal, sal * 12 as year_sal
FROM emp
ORDER BY year_sal;

-- SELECT절 컬럼 순서 인덱스로 정렬
-- (회사마다 호불호가 갈린다. 대부분은 별칭이나 컬럼 순서로 사용)
SELECT empno, ename, sal, sal * 12 as year_sal
FROM emp
ORDER BY 4;



-- ■ ORDER BY 실습 orderby1 -----------------------------------------------------------------------------------------------------------------
-- dept 테이블의 모든 정보를 부서이름으로 오름차순	 정렬로 조회되도록 쿼리를 작성하세요.
SELECT *
FROM dept
ORDER BY dname;

-- dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요.
SELECT *
FROM dept
ORDER BY loc DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ ORDER BY 실습 orderby2 -----------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여(comm)를 많이 받는 사람이 먼저 조회되도록 하고,
-- 상여가 같을 경우 사번으로 오름차순 정렬하세요.
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ ORDER BY 실습 orderby3 -----------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job) 순으로 오름차순 정렬하고,
-- 직업이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ ORDER BY 실습 orderby4 -----------------------------------------------------------------------------------------------------------------
-- emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회하고
-- 이름으로 내림차순 정렬되도록 쿼리를 작성하세요.
SELECT *
FROM emp
WHERE deptno IN (10, 30)
    AND sal > 1500
ORDER BY ename DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- ROWNUM (오라클에서만 제공하는 인덱스 기능, 가상의 컬럼)
-- WHERE 절에서도 사용 가능
SELECT ROWNUM, empno, ename
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
--WHERE ROWNUM = 2;
--읽지 못한다. 2번째 데이터가 존재하기 위해선 1번이 존재해야 하는데, 그런 조건이 없기 때문에 결과를 불러오지 못함. 전제조건: 1번부터 무조건 불러와야 한다.
-- 오라클에서 페이징 쿼리를 작성할 때 필수적으로 들어감.
 --WHERE ROWNUM <= 10;
 WHERE ROWNUM = 1;


-- emp 테이블에서 사번(empno), 이름(ename) 을 급여 기준으로 오름차순 정렬하고, 정렬한 결과순으로 ROWNUM을 적용

-- (잘못된 예시)
--SELECT ROWNUM, empno, ename, sal   -- LOWNUM을 뒤에 넣어도 된다.
--FROM emp
--ORDER BY sal;

-- SELECT ROWNUM, *         : * 를 사용할 때는 컬럼명을 다 써주거나, *를 적용하기 위해서는 별칭을 하나 줘야 한다. 테이블에 별칭을 주는 것과 동일. 그냥 쓰면 에러가 난다.
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal   -- LOWNUM을 뒤에 넣어도 된다.
FROM emp
ORDER BY sal) a ;
-- () 안을 인라인 듀오.. 라고 한다. 하나의 테이블.
-- 이 테이블에 있는 컬럼을 조회를 해라, 라는 의미와 같다.


-- ■ 가상컬럼 ROWNUM 실습 row_1 ----------------------------------------------------------------------------------------------------------
-- emp 테이블에서 ROWNUM 값이 1 ~ 10인 값만 조회하는 쿼리를 작성해보세요.
SELECT ROWNUM RN,  a.*
FROM
(SELECT empno, ename   -- LOWNUM을 뒤에 넣어도 된다.
FROM emp
ORDER BY sal) a
WHERE ROWNUM BETWEEN 1 AND 10;

--SELECT ROWNUM RN, empno, ename
--FROM emp
--WHERE ROWNUM <= 10;
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ 가상컬럼 ROWNUM 실습 row_2 ----------------------------------------------------------------------------------------------------------
SELECT RN, empno, ename
FROM
--    (SELECT RN, empno, ename, sal
--    FROM emp
        (SELECT ROWNUM RN, empno, ename, sal
        FROM emp
        WHERE ROWNUM BETWEEN 1 AND 20
        ORDER BY sal)
WHERE RN > 10
ORDER BY sal;

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) a) 
WHERE rn BETWEEN 11 AND 14;

---------------------------------------------------------------------------------------------------------------------------------------------------------


-- FUNCTION
-- DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD' as msg
FROM emp;
-- 데이터로 실험을 해야 하는데, 꼭 굳이 해당 테이블만큼 실행시킬 수 없으므로 그때 DUAKL을 이용한다.


-- 문자열 대소문자 관련 함수
-- LOWER, UPPER, INITCAP
-- 함수 사용: 괄호 안에 인자를 넣어줄 것
SELECT LOWER('Hello, World'),  UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';         -- 조건에 맞는 양만큼 데이터가 출력


-- FUNCTION은 WHERE절에서도 사용 가능
SELECT *
FROM emp
--WHERE ename = 'smith';      -- 대소문자를 비교하기 때문에 값이 나오지 않는다.
--WHERE ename = UPPER('smith');      -- 함수를 씌워주면 가능
WHERE LOWER(ename) = 'smith';       -- 이것도 가능하다!

-- 개발자 SQL 철거지악
-- 1. 좌변을 가공하지 말아라
-- 좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function Based Index → FBI

-- CONCAT : 문자열 결합 -  두 개의 문자열을 결합하는 함수
-- SELECT CONCAT('HELLO', ', ' ,'WORLD') CONCAT       : 인자가 3개라 오류가 난다.
-- SELECT CONCAT('HELLO',', WORLD') CONCAT
SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CONCAT
FROM DUAL;

-- SUBSTR : 문자열의 부분 문자열 (java : String.substring)
SELECT SUBSTR('HELLO, WORLD', 0, 5) substr,
                SUBSTR('HELLO, WORLD', 1, 5) substr,
                SUBSTR('HELLO, WORLD', 0, 4) substr
FROM DUAL;

-- LENGTH : 문자열의 길이
SELECT LENGTH('HELLO, WORLD') length
FROM DUAL;

-- INSTR : 문자열에 특정 문자열이 등장하는 첫 번째 인덱스
SELECT INSTR('HELLO, WORLD','O') instr,
                -- INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
                INSTR('HELLO, WORLD', 'O', 6) instr
FROM DUAL;

-- LPAD : 문자열에 특정 문자열을 삽입
-- LPAD(문자열, 전체 문자열 길이, 문자열이 전체 문자열 길이에 미치지 못할 경우 좌측에 추가할 문자);
SELECT LPAD('HELLO, WORLD', 15, '*') lpad,
-- SELECT LPAD('HELLO, WORLD', 15) lpad               -- 특정 문자열을 지정하지 않으면 공백이 들어간다. 기본 문자가 공백.
               RPAD('HELLO, WORLD', 15, '*') rpad
FROM DUAL;
