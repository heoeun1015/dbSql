-- ���� ����
-- ���� �� ??
-- RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
-- EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ� ������
-- �μ���ȣ�� ���� �ְ�, �μ� ��ȣ�� ���ؼ� dept ���̺�� ������ ���� �ش� �μ��� ������ ������ �� �ִ�.

-- ���� ��ȣ, ���� �̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �μ���ȣ, �μ���, �ش�μ��� �ο���
-- count (col) : col ���� �����ϸ� 1, null : 0
SELECT emp.deptno, dname, COUNT(empno) cnt
-- SELECT emp.deptno, dname, COUNT(*) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

SELECT *
FROM emp;

SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;
-- null �� ������ ������ count �ȴ�.

SELECT *
FROM dept;


-- ������ �������� ���ص� ������ outer join



-- OUTER JOIN   :   ���ο� �����ص� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ ����� �������� �ϴ� ���� ����
-- LEFT OUTER JOIN  :   JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
-- RIGHT OUTER JOIN  :   JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
-- FULL OUTER JOIN  :   LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

-- ���� ������, �ش� ������ ������ ���� OUTER JOIN
-- ���� ��ȣ, ���� �̸�, ������ ��ȣ, ������ �̸�

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);


-- ORACLE OUTER JOIN (LEFT, RIGHT �� ����, FULL OUTER�� �������� ����)

-- �Ϲ� JOIN
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno;

-- �����Ͱ� ���� �ʿ� ��ȣ ���� + ��ȣ ���ֱ� (NULL�� ��Ÿ�� ���̺�)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);



-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno)
WHERE b.deptno = 10;        -- WHERE �� ON ���� ��ȣ �������� ���͹����� 

-- ORACLE
-- ORACLE ���������� OUTER ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� OUTER JOIN �� ���������� �����Ѵ�.
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


-- �� ������ ���� (outer join �ǽ� outerjoin1) --------------------------------------------------------------------------------------------------
-- buyprod ���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ�� �ۿ� ����.
-- ��� ǰ���� ���� �� �ֵ��� ������ �ۼ��غ�����.
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

-- �� ������ ���� (outer join �ǽ� outerjoin2) --------------------------------------------------------------------------------------------------
-- ounterjoin1���� �۾��� �����ϼ���. buy_date �÷��� null�� �׸��� �� �������� ����ó�� �����Ͱ� ä��������
-- ������ �ۼ��ϼ���.
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

-- �� ������ ���� (outer join �ǽ� outerjoin3) --------------------------------------------------------------------------------------------------
-- outerjoin2���� �۾��� �����ϼ���. buy_qty �÷��� null�� ��� 0���� ���̵��� ������ �����ϼ���.
SELECT TO_DATE('2005/01/25','YYYY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, NVL(a.buy_qty, 0) buy_qty
FROM buyprod a RIGHT OUTER JOIN prod b ON
(a.buy_prod = b.prod_id AND a.buy_date = TO_DATE('2005/01/25','YYYY/MM/DD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� ������ ���� (outer join �ǽ� outerjoin4) --------------------------------------------------------------------------------------------------
-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�ǵ���
-- ������ �ۼ��ϼ���. (����cid = 1�� ���� �������� ����, null ó��)
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


-- �� ������ ���� (outer join �ǽ� outerjoin5) --------------------------------------------------------------------------------------------------
-- cycle, product, customer ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ������ ���� 
-- ��ȸ�Ǹ� ���̸��� �����Ͽ� ������ �ۼ��ϼ���.  (brown�� )����cid = 1�� ���� �������� ����, null ó��)
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

-- �� ������ ���� (outer join �ǽ� outerjoin6) --------------------------------------------------------------------------------------------------
-- customer, product ���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ�� ������ �����Ͽ� ������ ���� ��ȸ�ǵ��� ������
-- �ۼ��ϼ���.
SELECT * 
FROM customer c, product p;
----------------------------------------------------------------------------------------------------------------------------------------------------------




-- subquery :   main ������ ���ϴ� �κ� ����
-- ���Ǵ� ��ġ  :
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �������� �Ѵ�.)
-- FROM - inline view
-- WHERE    - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now     -- ���� ��¥
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now     -- ���� ��¥
FROM emp;

--SELECT empno, ename, (SELECT SYSDATE, 1 FROM dual) now     -- �� ���� ���� �� �� ����.
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


-- �� �������� (�ǽ� sub1) ------------------------------------------------------------------------------------------------------------------------
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���.
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                        FROM emp);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �������� (�ǽ� sub2) ------------------------------------------------------------------------------------------------------------------------
-- ��� �޿����� ���� �޿��� �޴� ������ ������ ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                        FROM emp);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �������� (�ǽ� sub3) ------------------------------------------------------------------------------------------------------------------------
-- SMITH�� WARD ����� ���� �μ��� ��� ��� ������ ��ȸ�ϴ� ������ ������ ���� �ۼ��ϼ���.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                            FROM emp
                            WHERE ename IN ('SMITH', 'WARD'));
----------------------------------------------------------------------------------------------------------------------------------------------------------

select ename, round(avg(sal),2) as avg from emp
where as > sal
group by ename;








