
-- ■ ADVANCED (WITH) ----------------------------------------------------------------------------------------------------------------------------
-- 전체 직원의 급여평균 2073.21
SELECT ROUND(AVG(sal), 2)
FROM emp;
 
 -- 부서별 직원의 급여 평균 10 XXXX, 20 YYYY, 30  ZZZZ
 
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

-- 비상호 쿼리. 각각 실행 가능
SELECT *
FROM (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
            FROM emp
            GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2)
                                FROM emp);
                                
-- 쿼리 블럭을 WITH절에 선언하여 쿼리를 간단하게 표현한다.

WITH dept_avg_sal AS (
        SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
        FROM emp
        GROUP BY deptno
)
--        , avg_ AS (
--        SELECT ROUND(AVG(sal), 2)
--        FROM emp
--)

SELECT *
FROM dept_avg_sal
WHERE d_avgsal > 2073.21;
 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
-- 달력 만들기
-- STEP1. 해당 년월의 일자 만들기
-- CONNECT BY LEVEL

SELECT a.*, level
FROM dual a
CONNECT BY LEVEL <= 10;     -- 행이 반복된다.

-- 201911
-- DATE + 정수 = 일자 더하기 연산


SELECT  TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1)) day, 
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'iw') iw,
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'ww') ww,
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'd') d
FROM dual a
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');     -- 행이 반복된다.

SELECT /*DECODE(d, 1, a.iw + 1, a.iw) iw,*/a.iw,
            MAX(DECODE(D, 1, dt)) sun, MAX(DECODE(D, 2, dt)) mon, MAX(DECODE(D, 3, dt)) tue, MAX(DECODE(D, 4, dt)) wed,
            MAX(DECODE(D, 5, dt)) thu, MAX(DECODE(D, 6, dt)) fri, MAX(DECODE(D, 7, dt)) sat
FROM  (SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1) dt,
                            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level), 'iw') iw,
                            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'd') d
              FROM dual a
              CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY a.iw
ORDER BY a.iw;
 
 
SELECT a.iw,
            MAX(DECODE(D, 1, dt)) sun, MAX(DECODE(D, 2, dt)) mon, MAX(DECODE(D, 3, dt)) tue, MAX(DECODE(D, 4, dt)) wed,
            MAX(DECODE(D, 5, dt)) thu, MAX(DECODE(D, 6, dt)) fri, MAX(DECODE(D, 7, dt)) sat
FROM  (SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1) dt,
                            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'iw') iw,
                            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'd') d
              FROM dual a
              CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY a.iw
ORDER BY a.iw;
 
 
 -- 10월
 SELECT /*DECODE(d, 1, a.iw + 1, a.iw) iw,*/a.iw,
            MAX(DECODE(D, 1, dt)) sun, MAX(DECODE(D, 2, dt)) mon, MAX(DECODE(D, 3, dt)) tue, MAX(DECODE(D, 4, dt)) wed,
            MAX(DECODE(D, 5, dt)) thu, MAX(DECODE(D, 6, dt)) fri, MAX(DECODE(D, 7, dt)) sat
FROM  (SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level - 3) dt,
                                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 2), 'iw') iw,
                                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'd') d
                FROM dual a
                CONNECT BY LEVEL <= 35) a
GROUP BY a.iw
ORDER BY a.iw;
 
SELECT 
    TO_DATE(20191131, 'IW')
FROM dual;
 
SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level - 3) dt,
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level), 'iw') iw,
                TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'd') d
FROM dual a
CONNECT BY LEVEL <= 35;
--CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');
 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
 create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;
------------------------------------------------------------------------------------------------------------ 
 
 
SELECT *
FROM sales;

SELECT *
FROM sales
CONNECT BY LEVEL 10;

MAX(DECODE(D, 1, dt)) sun, MAX(DECODE(D, 2, dt)) mon, MAX(DECODE(D, 3, dt)) tue, MAX(DECODE(D, 4, dt)) wed,
            MAX(DECODE(D, 5, dt)) thu, MAX(DECODE(D, 6, dt)) fri, MAX(DECODE(D, 7, dt)) sat

SELECT TO_CHAR(dt, 'YYYYMM') yyyymm, SUM(sales) sal_sales;


SELECT 
        NVL(MIN(DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales))), 0) jan,
        NVL(MIN(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))), 0) feb,
        NVL(MIN(DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales))), 0) mar,
        NVL(MIN(DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales))), 0) apr,
        NVL(MIN(DECODE(TO_CHAR(dt, 'MM'), '05', SUM(sales))), 0) may,
        NVL(MIN(DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales))), 0) june
FROM sales
GROUP BY TO_CHAR(dt, 'MM');


-- null 은 group by에서는 계산이 되지 않는다.
-- min을 쓰는게 좋다. 최솟값이 데이터를 절약하기 좋음.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;
------------------------------------------------------------------------------------------------------------




-- 계층 쿼리
-- START WITH : 계층의 시작 부분을 정의
-- CONNECT BY : 계층간 연결 조건을 정의

-- 하향식 계층 쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색)

SELECT *
FROM dept_h;

SELECT dept_h.*, LEVEL, LEVEL * 4, RPAD(' ', (LEVEL - 1) * 4, ' ') || dept_h.deptnm pad
FROM dept_h
START WITH deptcd = 'dept0'        -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;     -- PRIOR 현재 읽은 데이터 (XX 회사)

-- ■ 계층쿼리 (실습 h_3) ---------------------------------------------------------------------------------------------------------------------------
-- 디자인팀에서 시작하는 상향식 계층 쿼리를 작성하세요.
SELECT deptcd, RPAD(' ', (LEVEL - 1) * 7, ' ') || dept_h.deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
-----------------------------------------------------------------------------------------------------------------------------------------------------------










