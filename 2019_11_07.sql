-- emp ���̺��� �μ���ȣ(deptno) �� ����
-- emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
-- dept ���̺�� ������ ���� �μ��� ��ȸ

-- ���� ����: 
-- ANSI : ���̺� JOIN ���̺�2 ON (���̺�.COL = ���̺�2.COL)
--           emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE   :   FROM ���̺�, ���̺�2 WHERE ���̺�.COL = ���̺�2.COL
--                      FROM emp, dept WEHRE emp.deptno = dept.deptno

-- �����ȣ, �����, �μ���ȣ, �μ��� ----------------------------------------------------------------------------------------------------------
SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING(deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM emp;

-- �� ������ ���� (�ǽ� join 0_2) -----------------------------------------------------------------------------------------------------------------
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�޿��� 2500 �ʰ�)
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


-- �� ������ ���� (�ǽ� join 0_3) -----------------------------------------------------------------------------------------------------------------
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�޿��� 2500 �ʰ�, ����� 7600 ���� ū ����)
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

-- �÷����� ���� ���� ��� ���̺��� �÷����� ��Ȯ�� ǥ�ø� ����� ��.

-- �� ������ ���� (�ǽ� join 0_4) -----------------------------------------------------------------------------------------------------------------
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�޿��� 2500 �ʰ�, ����� 7600 ���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����)
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

-- �� ������ ���� (base_table.sql, �ǽ� join1) -------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� prod ���̺�� lprod ���̺��� �����Ͽ� ������ ���� ����� ������ ������ �ۼ��غ�����.
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

-- �� ������ ���� (base_table.sql, �ǽ� join2) -------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� buyer, prod ���̺��� �����Ͽ� buyer�� ����ϴ� ��ǰ ������ ������ ���� ����� ��������
-- ������ �ۼ��غ�����.
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

-- �� ������ ���� (�ǽ� join3) -------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� member, cart, prod ���̺��� �����Ͽ� ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������ ������ ����
-- ����� �������� ������ �ۼ��غ�����.
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

-- �� ������ ���� (�ǽ� join4) ---------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ������ ������ ���� �����
-- �������� ������ �ۼ��غ�����. (������ brown, sally�� ���� ��ȸ)
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

-- �� ������ ���� (�ǽ� join5) ---------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ����, ��ǰ���� 
-- ������ ���� ����� �������� ������ �ۼ��غ�����. (������ brown, sally�� ���� ��ȸ)
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

-- �� ������ ���� (�ǽ� join6) ---------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� �������ϰ� ������� ���� ���� ��ǰ��,
-- ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����.

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

-- �� ������ ���� (�ǽ� join7) ---------------------------------------------------------------------------------------------------------------------
-- erd ���̾�׷��� �����Ͽ� cycle, product ���̺��� �̿��Ͽ� ��ǰ��, ������ �հ�, ��ǰ���� ������ ���� �����
-- �������� ������ �ۼ��غ�����.
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT cycle.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;
----------------------------------------------------------------------------------------------------------------------------------------------------------


