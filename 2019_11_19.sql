-- �������� ����
-- ����ŷ, �Ƶ�����, kfc ����
SELECT gb, sido, sigungu
FROM fastfood
WHERE sido = '����������'
    AND gb IN ('����ŷ', '�Ƶ�����', 'KFC')
ORDER BY  sido, sigungu, gb;

SELECT gb, sido, sigungu
FROM fastfood
WHERE sido = '����������'
    AND gb IN ('�Ե�����')
ORDER BY  sido, sigungu, gb;

SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '����������'
    AND gb IN ('�Ե�����')
GROUP BY sido, sigungu;

ORDER BY  sido, sigungu, gb


-- 140 ��
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('�Ƶ�����', '����ŷ', 'KFC')
GROUP BY sido, sigungu;

-- 188 ��
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('�Ե�����')
GROUP BY sido, sigungu;



SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt, ROUND(a.cnt / b.cnt, 2) point
FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('�Ƶ�����', '����ŷ', 'KFC') GROUP BY sido, sigungu) a,
            (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('�Ե�����') GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
ORDER BY point DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM tax;

SELECT sido, sigungu, sal, ROUND(sal / people, 2) point
FROM tax
ORDER BY sal DESC;

SELECT sido, sigungu, sal
FROM tax
ORDER BY sal DESC;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- �õ�, �ñ���, �������� / �õ�, �ñ���, �������� ���Ծ�

SELECT buger.sido_ b_sido, buger.sigungu_ b_sigungu, buger.point b_point,
              tax_.sido t_sido, tax_.sigungu t_sigungu, tax_.sal t_sal
FROM (SELECT ROWNUM No, a.*
            FROM (SELECT sido, sigungu, sal FROM tax ORDER BY sal DESC) a) tax_, 
            (SELECT ROWNUM No, b.*
            FROM (SELECT a.sido sido_, a.sigungu sigungu_, ROUND(a.cnt / b.cnt, 2) point 
                        FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('�Ƶ�����', '����ŷ', 'KFC') GROUP BY sido, sigungu) a,
                                    (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('�Ե�����') GROUP BY sido, sigungu) b
                        WHERE a.sido = b.sido
                        AND a.sigungu = b.sigungu
                        ORDER BY point DESC) b) buger
WHERE tax_.No = buger.No(+);
    
    

------------------------------------------------------------------------------------------------------------------------------------------------------------------------



SELECT *
FROM emp_test;

-- emp ���̺� ����
DROP TABLE emp_test;


-- multiple insert�� ���� �׽�Ʈ ���̺� ����
-- empno, ename �� ���� �÷��� ���� emp_test, emp_test2 ���̺��� emp ���̺�κ��� �����Ѵ�. (CTAS)
-- ( �����ʹ� �������� �ʴ´�. )

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;


-- INSERT ALL
-- �ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
        INTO emp_test
        INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;


-- INSERT ALL �÷� ����
ROLLBACK;

INSERT ALL
        INTO emp_test (empno) VALUES (empno)
        INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ROLLBACK;


-- multiple insert (conditional insert)

INSERT ALL
        WHEN empno < 10 THEN
                INTO emp_test (empno) VALUES (empno)
        ELSE        -- ������ ������� ���� ���� ����
                INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ROLLBACK;

-- INSERT FIRST
INSERT FIRST
        WHEN empno > 10 THEN
                INTO emp_test (empno) VALUES (empno)
        WHEN empno > 5 THEN       -- ������ ������� ���� ���� ����
                INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

 UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ROLLBACK;
-- MERGE    :   ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--                      ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

SELECT *
FROM emp_test;

-- empno�� 7369�� �����͸� emp_test ���̺�κ��� ���� (insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;


-- emp ���̺��� ������ emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ���
-- emp_test.ename = ename || '_merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test ���̺� insert

ALTER TABLE emp_test MODIFY ( ename VARCHAR2(20) );

-- 14���� �� ������Ʈ
MERGE INTO emp_test
USING emp
    ON ( emp.empno = emp_test.empno )
WHEN MATCHED THEN
        UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
        INSERT VALUES ( emp.empno, emp.ename );


-- 2���� �ุ ������Ʈ
MERGE INTO emp_test        
USING (SELECT empno, ename
             FROM emp
             WHERE emp.empno IN (7369, 7499)) emp
    ON ( emp.empno = emp_test.empno 
            AND emp.empno IN (7369, 7499))
WHEN MATCHED THEN
        UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
        INSERT VALUES ( emp.empno, emp.ename );

SELECT *
FROM emp_test;


-- �ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������ merge �ϴ� ���
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� ������Ʈ
-- empno�� ���� ���� ������ �ű� insert



-- ���� ����ϰ� �� ����
MERGE INTO emp_test
USING dual
     ON ( emp_test.empno = 1 )
WHEN MATCHED THEN
        UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
        INSERT VALUES ( 1, 'brown' );

SELECT *
FROM emp_test;


-- ���� merge�� ������� ���� ��� ----------
SELECT *
FROM emp_test
WHERE empno = 1;

UPDATE emp_test SET = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');
-------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GROUP



--SELECT deptno, SUM(sal), 1 num
--FROM emp
--GROUP BY deptno
--ORDER BY deptno
--
--UNION ALL
--
--SELECT SUM(sal_)
--FROM 
--(SELECT deptno, SUM(sal) sal_, 1 num
--FROM emp
--GROUP BY deptno
--ORDER BY deptno) a
--GROUP BY a.num;


-- �� GROUP_AD 1 -----------------------------------------------------------------------------------------------------------------------------------
-- �׷�� �հ�, ��ü �հ踦 ������ ���� ���Ϸ���?
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT null as deptno, SUM(sal) sal
FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------



-- rollip
-- group by�� ���� �׷��� ����
-- GROUP BY ROLLUP ( {col,} )
-- �÷��� �����ʿ������� �����ذ��鼭 ���� ����׷��� GROUP BY �Ͽ� UNION �� �Ͱ� ����
-- ex) GROUP BY ROLLUP (job, deptno)
--       GROUO  BY job, deptno
--       UNION
--       GROUO  BY job
--       UNION
--       GROUP BY �� �Ѱ� (��� �࿡ ���� �׷��Լ� ����)


SELECT job, NVL(deptno, 0) deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);




-- �Ʒ� ������ ROLLUP ���·� ����
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno UNION ALL
SELECT null as deptno, SUM(sal) sal
FROM emp;


SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno); 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- GROUPING SETS (col1, col2 ��)
-- GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�.

    -- �� ������ �Ʒ��� ������
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2



-- emp ���̺��� �̿��Ͽ� �μ��� �޿� �հ�, ������(job)�� �޿����� ���Ͻÿ�.

-- �μ���ȣ, job, �޿� �հ�
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno UNION ALL   --
        SELECT null, job, SUM(sal)
        FROM emp
        GROUP BY job;   --
-- ���� �׷� 2��.

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));

