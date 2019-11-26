-- member ���̺��� �̿��Ͽ� member2 ���̺��� ����
-- member2 ���̺��� ������ ȸ�� (mem_id = 'a001') �� ���� (mem_job)�� '����'���� ������ commit �ϰ� ��ȸ

CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job = '����'
WHERE mem_id = 'a001';
COMMIT;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';





-- ��ǰ�� ��ǰ ���� ����(BUY_QTY) �հ�, ��ǰ ���� �ݾ�(BUY_COST) �հ�
-- ��ǰ��, ��ǰ�ڵ�, �����հ�, �ݾ��հ�
SELECT *
FROM buyprod;

SELECT *
FROM prod;

SELECT SUM(buy_qty), SUM(buy_cost)
FROM buyprod;

SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod;


-- VW_PROD_BUY (view ����)

CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT a.buy_prod, prod_name, a.sum_qty, a.sum_cost
FROM (SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
            FROM buyprod
            GROUP BY buy_prod) a, prod
WHERE a.buy_prod = prod.prod_id;

SELECT *
FROM USER_VIEWS;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM emp;

SELECT deptno, ROWNUM
FROM(
SELECT deptno
FROM emp
WHERE deptno = (SELECT deptno, COUNT(deptno)
                            FROM emp
                            GROUP BY deptno)
ORDER BY deptno, sal DESC);


SELECT deptno
FROM dept;


SELECT *
FROM (SELECT deptno, COUNT(deptno)
            FROM emp
            GROUP BY deptno), emp;





-- �μ��� ��ŷ
-- �μ��� �Ǽ��� �ƹ��� ���������� emp ���̺��� ��ü �Ǽ����� ������ �� ����.


SELECT a.ename, a.sal, a.deptno, b.rn
FROM  (SELECT a.eanme, a.sal, a.deptno, ROWNUM j_rn
            FROM (SELECT ename, sal, deptno
                        FROM emp
                        ORDER BY deptno, sal DESC) a) a,
                        
            (SELECT b.rn, ROWNUM j_rn
            FROM (SELECT a.deptno, b.rn
                        FROM(SELECT deptno, COUNT(*) cnt 
                                    FROM emp
                                    GROUP BY deptno) a,
                        (SELECT ROWNUM rn
                        FROM emp) b
                        WHERE a.cnt >= b.rn
                        ORDER BY a.deptno, b.rn) b) b
WHERE a.j_rn = b.j_rn;

SELECT a.ename, a.sal, a.deptno, b.rn
FROM (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
             FROM  (SELECT ename, sal, deptno
                             FROM emp
                             ORDER BY deptno, sal DESC) a ) a, 
                             
            (SELECT b.rn, ROWNUM j_rn
            FROM (SELECT a.deptno, b.rn 
                         FROM (SELECT deptno, COUNT(*) cnt --3, 5, 6
                                     FROM emp
                                     GROUP BY deptno )a,
                        (SELECT ROWNUM rn --1~14
                         FROM emp) b
        WHERE  a.cnt >= b.rn
        ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;



SELECT deptno, COUNT(*) cnt --3, 5, 6
FROM emp
GROUP BY deptno;

SELECT ROWNUM rn --1~14
FROM emp;

SELECT a.deptno, b.rn 
 FROM (SELECT deptno, COUNT(*) cnt --3, 5, 6
             FROM emp
             GROUP BY deptno )a,
(SELECT ROWNUM rn --1~14
 FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn



SELECT ename, sal, deptno,
            ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;


