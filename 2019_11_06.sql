-- �׷��Լ�
-- multi row funciton   :   ���� ���� ���� �̓����� �ϳ��� ��� ���� ����
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

-- ���� �� ���� ���� �޿� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

-- �μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;

10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON;

SELECT *
FROM emp;

-- �� Function (group function �ǽ� grp3) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- grp2���� �ۼ��� ������ Ȱ���Ͽ� deptno ��� �μ����� ���� �� �ֵ��� �����Ͻÿ�.
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname,       -- �μ��� ������ �� ������ �����ؾ� �ϴ� ������ ����
              MAX(sal) max_sal,
              MIN(sal) min_sal,
              ROUND(AVG(sal), 2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(sal) count_sal,
              COUNT(mgr) count_mgr,
              COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT')
ORDER BY max_sal DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM emp;

-- �� Function (group function �ǽ� grp4) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- ������ �Ի� ������� �� ���� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- SELECT ���� ������ ������ GROUP BY ������ ������ �Ȱ��� ���°� ����.

-- �� Function (group function �ǽ� grp5) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
-- ������ �Ի� �⺰�� �� ���� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT TO_CHAR(hiredate,'YYYY') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');      -- 10���ĺ��ʹ� ���� �� ��. GROUP BY ���� �ִ� �������� ������ �� �ǰ� �ٲ��.
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- �� Function (group function �ǽ� grp6) ------------------------------------------------------------------------------------------------------
-- ȸ�翡 �����ϴ� �μ��� ������ �� ������ ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
SELECT COUNT(deptno) cnt
FROM dept;

SELECT COUNT(*) cnt
FROM dept;

SELECT DISTINCT deptno      -- DISTINCT: �ߺ��� ������ ���� �˰� ���� �� ���
FROM emp;

--SELECT COUNT(*) cnt
--FROM
--            (SELECT COUNT(deptno)
--            FROM emp
--            GROUP BY deptno);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN
-- emp ���̺��� ename �÷��� ����. �� �μ���ȣ(deptno) �ۿ� ����
desc emp;

-- emp ���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));   -- � ���̺��� �����ͼ� �߰��� �ųĸ�,
desc dept;

-- RDBMS�� ���, ��� �࿡ ������ ��ģ��.
SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE deptno = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE deptno = 20;
UPDATE emp SET dname = 'SALES' WHERE deptno = 30;
COMMIT;     -- Ŀ�� �Ϸ�

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

-- RDBMS���� �ߺ��� �����ϴ� ���(JOIN)

ALTER TABLE emp DROP COLUMN DNAME;      -- dname ����

SELECT *
FROM emp;





-- ansi natural join    :   ���̺��� �÷����� ���� �÷��� �������� JOIN�� ���ش�.
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

-- oracle join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc       -- �ʿ��� �÷��� �̷��� ������ �� �ִ�.
--SELECT empno, ename, emp.deptno, dept.dname, dept.loc     --�ε� ��� ����. deptno ����.
FROM emp, dept
WHERE emp.deptno = dept.deptno;


SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;




-- ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);


-- from ���� ���� ��� ���̺� ����
-- where ���� ���� ���� ���
-- ������ ����ϴ� ���� ���൵ ��� ����
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- job�� SALES�� ����� ������� ��ȸ
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.job = 'SALESMAN';
        
        
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
    AND emp.deptno = dept.deptno;
-- ������ �κи� ���� ������ WHERE�� AND�� ������ �ٲ� ����� ����.







-- JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- �Ʒ� oracle ������ ������
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;






-- SELF join : ���� ���̺��� ����
-- emp ���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ� �Ѵ�.
-- a: ���� ����, b: ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b. empno);
-- emp�� �������, a�� ������������ ��ȸ�ϱ� ���� ����.
-- mgr�� null�� ���� �ϳ� ����. �׷��� 13���� ��ȸ�ȴ�.


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b. empno)
WHERE a.empno BETWEEN 7369 AND 7698;
-- �߰� ���� ���

-- oracle
--SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
--FROM emp a, emp b
--WHERE a.mgr = b.empno
--     AND a.empno BETWEEN 7369 AND 7698;

-- RDBMS���� JOIN�� �ʼ�
SELECT b.empno, b.ename, a.empno, a.ename, a.mgr
FROM emp b, emp a
WHERE  b.empno = a.mgr
     AND a.empno BETWEEN 7369 AND 7698;






-- non-equijoing (��� ������ �ƴ� ���)
SELECT *
FROM salgrade;

-- ������ �޿� �����?
-- ������ �ݵ�� equl�� �ʿ�� ����. �ٸ� �ɷ� ���൵ ��.
SELECT  empno, ename, sal
FROM emp;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON( emp.sal BETWEEN salgrade.losal AND salgrade.hisal );






-- non equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
     AND a.empno = 7369;
     
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369;
-- a, b ������ ������ ��� ������ ���´�. (cross join, ������ ����) ������ ���� ���ƶ�.

SELECT *
FROM emp;


-- �� ������ ���� (�ǽ� join 0) --------------------------------------------------------------------------------------------------------------------
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
SELECT a.empno, a.ename, a.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno)
ORDER BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� ������ ���� (�ǽ� join 1) --------------------------------------------------------------------------------------------------------------------
-- emp, dept  ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
-- (�μ���ȣ�� 10, 30�� �����͸� ��ȸ)
SELECT a.empno, a.ename, a.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
      AND a.deptno IN (10, 30);

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE deptno IN (10, 30);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ���� dept 30�� �� ���� ������ emp dept�� ���� ����� 2���� ���´�. �������� ������ ��.



SELECT *
FROM emp NATURAL JOIN dept;



