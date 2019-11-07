-- emp 테이블에는 부서번호(deptno) 만 존재
-- emp 테이블에서 부서명을 조회하기 위해서는
-- dept 테이블과 조인을 통해 부서명 조회

-- 조인 문법: 
-- ANSI : 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL)
--           emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE   :   FROM 테이블, 테이블2 WHERE 테이블.COL = 테이블2.COL
--                      FROM emp, dept WEHRE emp.deptno = dept.deptno

-- 사원번호, 사원명, 부서번호, 부서명 ----------------------------------------------------------------------------------------------------------
SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING(deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM emp;

-- ■ 데이터 결합 (실습 join 0_2) -----------------------------------------------------------------------------------------------------------------
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (급여가 2500 초과)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND sal > 2500
ORDER BY deptno;

SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
ORDER BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ■ 데이터 결합 (실습 join 0_3) -----------------------------------------------------------------------------------------------------------------
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (급여가 2500 초과, 사번이 7600 보다 큰 직원)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.sal > 2500
    AND empno > 7600
ORDER BY deptno;

SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
    AND empno > 7600
ORDER BY deptno;

SELECT empno, ename, sal, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE sal > 2500
    AND empno > 7600
ORDER BY deptno;

SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal > 2500
    AND empno > 7600
ORDER BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 컬럼명이 같을 때는 어느 테이블의 컬럼인지 명확히 표시를 해줘야 함.

-- ■ 데이터 결합 (실습 join 0_4) -----------------------------------------------------------------------------------------------------------------
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
-- (급여가 2500 초과, 사번이 7600 보다 크고 부서명이 RESEARCH인 부서에 속한 직원)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND sal > 2500
    AND empno > 7600
    AND dept.dname = 'RESEARCH'
ORDER BY deptno;

SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
    AND empno > 7600
    AND dname = 'RESEARCH'
ORDER BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (base_table.sql, 실습 join1) -------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여 다음과 같은 결과가 나오는 쿼리를 작성해보세요.
-- (FR_PROD_LGU)
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod p JOIN lprod l ON (p.prod_lgu = l.lprod_gu);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (base_table.sql, 실습 join2) -------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록
-- 쿼리를 작성해보세요.
SELECT *
FROM buyer;

SELECT *
FROM prod;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON(buyer.buyer_id = prod.prod_buyer);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join3) -------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은 제품 정보를 다음과 같은
-- 결과가 나오도록 쿼리를 작성해보세요.
SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
    AND cart.cart_prod = prod.prod_id;
    
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON(member.mem_id = cart.cart_member)
    JOIN prod ON (cart.cart_prod = prod.prod_id);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join4) ---------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가
-- 나오도록 쿼리를 작성해보세요. (고객명이 brown, sally인 고객만 조회)
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND cnm IN ('brown', 'sally');
    
SELECT customer.cid, cnm, pid, day, cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)
WHERE cnm IN ('brown', 'sally');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join5) ---------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수, 제품명을 
-- 다음과 같은 결과가 나오도록 쿼리를 작성해보세요. (고객명이 brown, sally인 고객만 조회)
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND cnm IN ('brown', 'sally');
    
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)
            JOIN product ON(cycle.pid = product.pid)
WHERE cnm IN ('brown', 'sally');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join6) ---------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 애음요일과 관계없이 고객별 애음 제품별,
-- 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

with cycle_groupby as (
        SELECT cid, pid, sum(cnt) cnt
        FROM cycle
        GROUP BY cid, pid )

SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT customer.cid cc, cnm, a.pid, pnm, cnt
FROM customer, product,
(SELECT cid, pid, sum(cnt) cnt
FROM cycle
GROUP BY cid, pid) a
WHERE a.cid = customer.cid
    AND a.pid = product.pid;
    
SELECT customer.cid, cnm, cycle.pid, pnm, SUM(cnt) cnt
FROM customer, product, cycle
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm;

SELECT customer.cid, cnm, cycle.pid, pnm, cnt
FROM customer, product, cycle
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid;
GROUP BY customer.cid, cnm, cycle.pid, pnm;
    
--SELECT customer.cid cc, cnm, a.pid, pnm, cnt
--FROM customer JOIN a ON (a.cid = customer.cid)
--            JOIN product ON (a.pid = product.pid),
--(SELECT cid, pid, sum(cnt) cnt
--FROM cycle
--GROUP BY cid, pid) a;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 데이터 결합 (실습 join7) ---------------------------------------------------------------------------------------------------------------------
-- erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별, 개수의 합과, 제품명을 다음과 같은 결과가
-- 나오도록 쿼리를 작성해보세요.
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT cycle.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;
----------------------------------------------------------------------------------------------------------------------------------------------------------


