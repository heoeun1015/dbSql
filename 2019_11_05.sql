-- 년월 파라미터가 주어을 때 해당년월의 일수를 구하는 문제
-- 2019년 → 30 / 2019 → 31

SELECT TO_DATE('201911', 'YYYYMM')
FROM DUAL;

-- 한 달 더한 후 원래 값을 빼면 = 일수
-- 마지막 날짜 구한 후 → DD만 추출

--SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt      -- 바인딩 쿼리
FROM DUAL;


-- 실행계획을 해라.
explain plan for
SELECT *
FROM emp
WHERE empno = '7369';
--WHERE TO_CHAR(empno) = '7369';

-- 실행계획
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

----------------------------------------------------------------------------------------------
Plan hash value: 3956160932
 
----------------------------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)  | Time       |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |             |         1 |    37 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP     |         1 |    37 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
----------------------------------------------------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369');
----------------------------------------------------------------------------------------------



SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99') sal_fmt
FROM emp;

select *
 from nls_session_parameters;


-- funciton null
-- NVL(col1, null일 경우 대체할 값) ★중요함.
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,        -- null 이면 0으로 바꿔라
              sal + comm, 
              sal + nvl(comm, 0)
              , nvl(sal + comm, 0)
FROM emp;


-- NVL2(col1, col1이 null이 아닐 경우 표현되는 값, col1 null일 경우 표현되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;


-- NULLIF(expr1, expr2)
-- expr1 == expr2 같으면 null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;


-- COALESCE(expr1, sxpr2, expr3...)  -- 자바의 가변형 인수와 비슷함
-- 함수 인자 중 null이 아닌 첫 번째 인자
SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal
FROM emp;


-- ■ Function (null 실습 fn4) ----------------------------------------------------------------------------------------------------------------------
-- emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오. NULL일 경우 9999로 표시.
-- (NVL, NVL2, COALESCE 전부 다)
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n,
                                                NVL2(mgr, mgr, 9999) mgr_n,
                                                COALESCE(mgr, 9999) mgr_n
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ Function (null 실습 fn5) ----------------------------------------------------------------------------------------------------------------------
-- users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요. reg_dt가 null일 경우 sysdate를 적용.
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- case when
SELECT empno, ename, job, sal,
              case
                        when job = 'SALESMAN'   then sal * 1.05
                        when job = 'MANAGER'   then sal * 1.10
                        when job = 'PRESIDENT'   then sal * 1.20
                        else sal
              end case_sal
FROM emp;


-- decode(col, search1, return1, search2, return2 … default)
SELECT  empno, ename, job, sal,
                DECODE(job, 'SALESMAN', sal * 1.05,
                                        'MANAGER', sal * 1.10,
                                        'PRESIDENT', sal * 1.20, sal) decode_sal
FROM emp;


-- ■ Function (condition 실습 cond1) -----------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여  deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요.
-- 10 → 'ACCOUNTING', 20 → 'RESEARCH', 30 → 'SALES', 40 → 'OPERATIONS', 기타 다른 값 → 'DDIT'
SELECT empno, ename,
              DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 올해가 짝수인지, 홀수인지를 알아야 함.
-- 1. 올해 년도 구하기 (DATE → TO_CHAR(DATE, FORMAT))
-- 2. 올해 년도가 짝수인지 계산
--     어떤 수를 2로 나누면 나머지는 항상 2보다 작다.
--     2로 나눌 경우 나머지는 0, 1
-- MOD(대상, 나눌 값)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) this_year
FROM DUAL;

-- emp 테이블에서 입사일자가 홀수년인지 짝수년인지 확인
SELECT empno, ename, hiredate,
                case
                   when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2)
                       then '건강검진 대상'
                       else '건강검진 비대상'
                   end contact_to_doctor
FROM emp;


-- ■ Function (condition 실습 cond2) -----------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
-- (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다.)
SELECT empno, ename, hiredate,
              DECODE(MOD(SUBSTR(hiredate, 0, 2), 2), 1, '건강검진 대상자', 0, '건강검진 비대상자') contact_to_doctor
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ Function (condition 실습 cond3) -----------------------------------------------------------------------------------------------------------
-- users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
-- (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다.)
SELECT userid, usernm, alias, reg_dt,
                case
                   when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(reg_dt, 'YYYY'), 2)
                       then '건강검진 대상'
                       else '건강검진 비대상'
                   end contact_to_doctor
FROM users;
----------------------------------------------------------------------------------------------------------------------------------------------------------



-- 그룹함수 (AVG, MAX, MIIN, SUM, COUNT)
-- 그룹함수는 NULL값을 계산대상에서 제외한다.
-- SUM(comm), COUNT(*), COUNT(mgr)

-- 직원 중 가장 높은 급여를 받는 사람
-- 직원 중 가장 낮은 급여를 받는 사람
-- 직원의 급여 평균 (소수점 둘째자리 까지만 나오게 → 소수점 셋째자리에서 반올림)
-- 직언의 급여 전체 합
-- 직원의 숫자
SELECT MAX (sal) max_sal, MIN(sal) min_sal,
              ROUND(AVG(sal),  2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(*) emp_cnt,      --  보통은 행 전체, *로 출력한다.
              COUNT(sal) sal_cnt,
              COUNT(mgr) mgr_cnt,        -- NULL값은 계산에 포함이 되지 않는다.
              SUM(comm) sum_somm        -- 실제 값이 있는 데이터만 더해진다.
FROM emp;


-- ename만 넣으면 안 된다. deptno로 그룹핑을 했기 때문에 이 외에는 SELECT에 있으면 안 된다. deptno는 있어도 되고 없어도 됨.
-- 부서별 가장 높은 급여를 받는 사람의 급여
-- GROUP BY 절에 기술되지 않은컬럼이 SELECT 절에 기술될 경우 에러
SELECT deptno, MIN(ename), MAX(sal) max_sal     
FROM emp
GROUP BY deptno;
-- 부서번호로 묶어줬으니 의미 없는 문자열/상수를 제외하고는 다른 이름이 들어갈 수 없다.


SELECT deptno, MAX (sal) max_sal, MIN(sal) min_sal,
              ROUND(AVG(sal),  2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(*) emp_cnt,      --  보통은 행 전체, *로 출력한다.
              COUNT(sal) sal_cnt,
              COUNT(mgr) mgr_cnt,        -- NULL값은 계산에 포함이 되지 않는다.
              SUM(comm) sum_somm        -- 실제 값이 있는 데이터만 더해진다.
FROM emp
GROUP BY deptno;

SELECT empno, ename, sal
FROM emp
ORDER BY sal;


-- 부서별 최대 급여
SELECT deptno, MAX(sal) mas_sal
FROM emp
--WHERE MAX(sal) >= 3000        -- 에러. WHERE 
GROUP BY deptno
having MAX(sal) >= 3000;


-- ■ Function (group function 실습 grp1) ------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여 다음을 구하시오.
    -- 직원중 가장 높은 급여
    -- 직원중 가장 낮은 급여
    -- 직원의 급여 평균(소수점 2자리까지)
    -- 직원의 급여 합
    -- 직원 중 급여가 있는 직원의 수 (NULL 제외)
    -- 직원 중 상급자가 있는 직원의 수 (NULL 제외)
    -- 전체 직원의 수
SELECT MAX(sal) max_sal,
              MIN(sal) min_sal,
              ROUND(AVG(sal), 2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(sal) count_sal,
              COUNT(mgr) count_mgr,
              COUNT(*) count_all
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ Function (group function 실습 grp2) ------------------------------------------------------------------------------------------------------
-- emp 테이블을 이용하여 다음을 구하시오.
    -- 부서기준 직원 중 가장 높은 급여
    -- 부서기준 직원 중 가장 낮은 급여
    -- 부서기준 직원의 급여 평균(소수점 2자리까지)
    -- 부서기준 직원의 급여 합
    -- 부서의 직원 중 급여가 있는 직원의 수 (NULL 제외)
    -- 부서의 직원 중 상급자가 있는 직원의 수 (NULL 제외)
    -- 전체 직원의 수)
SELECT deptno, MAX(sal) max_sal,
              MIN(sal) min_sal,
              ROUND(AVG(sal), 2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(sal) count_sal,
              COUNT(mgr) count_mgr,
              COUNT(*) count_all
FROM emp
GROUP BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

