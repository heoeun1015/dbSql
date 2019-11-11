-- 조인 복습
-- 조인 왜 ??
-- RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
-- EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서 정보는
-- 부서번호만 갖고 있고, 부서 번호를 통해서 dept 테이블과 조인을 통해 해당 부서의 정보를 가져올 수 있다.

-- 직원 번호, 직원 이름, 직원의 소속 부서번호, 부서이름
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 부서번호, 부서명, 해당부서의 인원수
-- count (col) : col 값이 조재하면 1, null : 0
SELECT emp.deptno, dname, COUNT(empno) cnt
-- SELECT emp.deptno, dname, COUNT(*) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

SELECT *
FROM emp;

SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;
-- null 을 제외한 값들이 count 된다.

SELECT *
FROM dept;


-- 조인을 만족하지 못해도 나오는 outer join



-- OUTER JOIN   :   조인에 실패해도 기준이 되는 테이블의 데이터는 조회 결과가 나오도록 하는 조인 형태
-- LEFT OUTER JOIN  :   JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
-- RIGHT OUTER JOIN  :   JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
-- FULL OUTER JOIN  :   LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

-- 직원 정보와, 해당 직원의 관리자 정보 OUTER JOIN
-- 직원 번호, 직원 이름, 관리자 번호, 관리자 이름

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);


-- ORACLE OUTER JOIN (LEFT, RIGHT 만 존재, FULL OUTER는 지원하지 않음)

-- 일반 JOIN
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno;

-- 데이터가 없는 쪽에 괄호 열고 + 기호 써주기 (NULL을 나타낼 테이블)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);



-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno)
WHERE b.deptno = 10;        -- WHERE 가 ON 다음 괄호 조건절을 나와버리면 

-- ORACLE
-- ORACLE 문법에서는 OUTER 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 OUTER JOIN 이 정상적으로 동작한다.
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
        AND b.deptno(+) = 10;
        
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
        AND b.deptno = 10;



-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

-- ORACLE RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr(+) = b.empno;


-- ■ 데이터 결합 (outer join 실습 outerjoin1) --------------------------------------------------------------------------------------------------
-- buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
-- 모든 품목이 나올 수 있도록 쿼리를 작성해보세요.
SELECT *
FROM buyprod;

SELECT *
FROM prod;

desc buyprod;

SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a RIGHT OUTER JOIN prod b ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));

SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM prod b LEFT OUTER JOIN buyprod a ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));

SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
    AND a.buy_date(+) = TO_DATE('2005/01/25','YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (outer join 실습 outerjoin2) --------------------------------------------------------------------------------------------------
-- ounterjoin1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 안 나오도록 다음처럼 데이터가 채워지도록
-- 쿼리를 작성하세요.
SELECT NVL(buy_date, TO_DATE('2005/01/25','YYYY/MM/DD')) buy_date, c.buy_prod, c.prod_id, c.prod_name, c.buy_qty
FROM
(SELECT a.buy_date buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a RIGHT OUTER JOIN prod b ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'))) c;

SELECT NVL(a.buy_date, TO_DATE('2005/01/25','YYYY/MM/DD')) buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a RIGHT OUTER JOIN prod b ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));

SELECT TO_DATE('2005/01/25','YYYY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a RIGHT OUTER JOIN prod b ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (outer join 실습 outerjoin3) --------------------------------------------------------------------------------------------------
-- outerjoin2에서 작업을 시작하세요. buy_qty 컬럼이 null일 경우 0으로 보이도록 쿼리를 수정하세요.
SELECT TO_DATE('2005/01/25','YYYY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, NVL(a.buy_qty, 0) buy_qty
FROM buyprod a RIGHT OUTER JOIN prod b ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (outer join 실습 outerjoin4) --------------------------------------------------------------------------------------------------
-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 조회되도록
-- 쿼리를 작성하세요. (고객은cid = 1인 고객만 나오도록 제한, null 처리)
SELECT  *
FROM cycle;

SELECT  *
FROM product;

SELECT a.pid, a.pnm, b.cid, b.day, b.cnt
FROM product a LEFT OUTER JOIN cycle b ON (a.pid = b.pid AND b.cid = 1);

SELECT b.pid, b.pnm, 1 cid, nvl (a.day, 0) day, nvl(a.cnt, 0) cnt
FROM cycle a, product b
WHERE a.pid (+) = b.pid
AND a.cid (+) = 1;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ 데이터 결합 (outer join 실습 outerjoin5) --------------------------------------------------------------------------------------------------
-- cycle, product, customer 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 
-- 조회되며 고객이름을 포함하여 쿼리를 작성하세요.  (brown만 )고객은cid = 1인 고객만 나오도록 제한, null 처리)
SELECT  *
FROM cycle;

SELECT  *
FROM product;

SELECT  *
FROM customer;

SELECT a.pid, a.pnm, a.cid, b.cnm, a.day, a.cnt
FROM(
SELECT b.pid, b.pnm, 1 cid, nvl (a.day, 0) day, nvl(a.cnt, 0) cnt
FROM cycle a, product b
WHERE a.pid (+) = b.pid
AND a.cid (+) = 1) a, customer b
WHERE a.cid = b.cid;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (outer join 실습 outerjoin6) --------------------------------------------------------------------------------------------------
-- customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를
-- 작성하세요.
SELECT * 
FROM customer c, product p;
----------------------------------------------------------------------------------------------------------------------------------------------------------




-- subquery :   main 쿼리에 속하는 부분 쿼리
-- 사용되는 위치  :
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리여야 한다.)
-- FROM - inline view
-- WHERE    - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now     -- 현재 날짜
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now     -- 현재 날짜
FROM emp;

--SELECT empno, ename, (SELECT SYSDATE, 1 FROM dual) now     -- 두 개의 행은 올 수 없다.
--FROM emp;

SELECT deptno       -- 20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;      -- 20


SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                              FROM emp
                              WHERE ename = 'SMITH');


-- ■ 서브쿼리 (실습 sub1) ------------------------------------------------------------------------------------------------------------------------
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                        FROM emp);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 서브쿼리 (실습 sub2) ------------------------------------------------------------------------------------------------------------------------
-- 평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요.
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                        FROM emp);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 서브쿼리 (실습 sub3) ------------------------------------------------------------------------------------------------------------------------
-- SMITH와 WARD 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                            FROM emp
                            WHERE ename IN ('SMITH', 'WARD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

select ename, round(avg(sal),2) as avg from emp
where as > sal
group by ename;








