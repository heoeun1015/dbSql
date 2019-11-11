-- SMITH,  WARD �� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
        OR deptno = 30;
        
        
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                                FROM emp
--                              WHERE ename IN ('SMITH', 'WARD'));
                                WHERE ename IN (:name1, :name2));
                                
-- ANY  :   set(800, 1250) �߿� �����ϴ� �� �ϳ��� ������ ������ (ũ��� �� �� ���� ���)
-- SMITH, WARD  �� ����� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT ename, sal
FROM emp
ORDER BY sal;

-- SMITH�� WARD���� �޿��� ���� ���� ��ȸ
-- SMITH���ٵ� �޿��� ���� WARD���ٵ��޿��� ���� ��� (AND)
SELECT *
FROM emp
WHERE sal < any (SELECT sal     -- 800, 1250      �� 1250���� ���� �޿��� �޴� ���
                                FROM emp
                                WHERE ename IN ('SMITH', 'WARD'));
                                
SELECT *
FROM emp
WHERE sal > all (SELECT sal     -- 800, 1250      �� 1250���� ���� �޿��� �޴� ���
                                FROM emp
                                WHERE ename IN ('SMITH', 'WARD'));


-- NOT IN

-- ������ ���� ���� ��ȸ
-- 1. �������� ����� ��ȸ
--      . mgr �÷��� ���� ������ ����

-- DISTINCT :   �ߺ� ����

SELECT DISTINCT mgr
FROM emp
ORDER BY mgr;

-- � ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7566, 7698, 7782, 7788, 7839, 7902);
-- KING -   JONES   - SCOTT

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                                FROM emp);

-- ������ ������ ���� �ʴ� �� ��� ���� ��ȸ
-- ��, NOT IN ������ ���� SET �� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
-- NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���

-- WHERE��
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                                        FROM emp
                                        WHERE mgr IS NOT NULL);
-- NVL                     
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                                        FROM emp);


-- pair wise
-- ��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
-- 7698     30
-- 7839     10
-- ���� �߿� �����ڿ� �μ���ȣ�� (7698, 30)�̰ų�, (7839,  10)�� ���
-- mgr, deptno  �÷��� [����]�� ������Ű�� ���� ���� ��ȸ
SELECT mgr, deptno
FROM emp
ORDER BY mgr, deptno;

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                                            FROM emp
                                            WHERE empno IN (7499, 7782));

-- non pair wise. ����� 7782�̸鼭 30�� �����͵� ����Ѵ�.
-- 7698     30
-- 7839     10
-- �� �� ������ ������ ��� ����� ���� ���´�. �̷��� ���Ϸ��� pair wise�� ��� ��.
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                            FROM emp
                            WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
                            FROM emp
                            WHERE empno IN (7499, 7782));
-- ���ȣ�����̱� ������ ���� ������ �����ϴ�.
                            


-- SCALAR SUBQUERY  :   SELECT ���� �����ϴ� ���� ����(�� ���� �ϳ��� ��, �ϳ��� �÷�)
-- ������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, '�μ���' dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;
-- ����� ���� �ϳ��� ��� ����. �׷����� ��� ������ ���� �μ����̱� ������ 20�� �������� ����� ���� ����.


SELECT empno, ename, deptno, (SELECT dname
                                                        FROM dept
                                                        WHERE deptno = emp.deptno)  -- emp�� �ִ� deptno�� �����ض�.
FROM emp;
-- SCALAR �� ���� ������ ����, �̰� JOIN ��ü�� ����ϴ� ���� ���� ���� �ƴϴ�.
-- WHERE deptno = emp.deptno. Main �������� ������ ���̱� ������ ���������� ������ �� ����. (��ȣ����)
-- �� emp���̺��� ���� �о�� �ϴµ�, main �������� ���� ������ �ҷ��� �� ����.



SELECT *
FROM dept;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

-- �� �������� (�ǽ� sub4) ------------------------------------------------------------------------------------------------------------------------
-- dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ����. ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��غ�����.
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                                        FROM emp);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �������� (�ǽ� sub5) ------------------------------------------------------------------------------------------------------------------------
-- cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                                  FROM cycle
                                  WHERE cid = 1);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �������� (�ǽ� sub6) ------------------------------------------------------------------------------------------------------------------------
-- cycle ���̺��� �̿��Ͽ� cid = 2�� ���� �����ϴ� ��ǰ �� cid = 1�� ����  �����ϴ� ��ǰ�� ���� ������ ��ȸ�ϴ�
-- ������ �ۼ��ϼ���.
SELECT *
FROM cycle
WHERE pid IN ( SELECT pid
                           FROM cycle
                           WHERE cid = 2)
    AND cid = 1;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �������� (�ǽ� sub7) (����) ----------------------------------------------------------------------------------------------------------------
-- cycle ���̺��� �̿��Ͽ� cid = 2���� �����ϴ� ��ǰ �� cid = 1�� ���� �����ϴ� ��ǰ�� ��ǰ ������ ��ȸ�ϰ�
-- ����� ��ǰ����� �����ϴ� ������ �ۼ��ϼ���.
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt 
FROM cycle, product, customer
WHERE cycle.pid IN ( SELECT pid
                                   FROM cycle
                                   WHERE cid = 2)
    AND cycle.cid = 1
    AND cycle.pid = product.pid
    AND cycle.cid = customer.cid;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- EXISTS MAIN ������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
-- �����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

-- MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'x'
                            FROM emp
                            WHERE empno = a.mgr);
-- ���ʸ��̶� ��Ī�� �� ��
-- SELECT ������ ���� ��Ī�� �ƹ��ų� �͵� �� ex) 'x'


-- MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'x'
                                    FROM emp
                                    WHERE empno = a.mgr);


-- �� �������� (EXISTS ������ - �ǽ� sub8) ---------------------------------------------------------------------------------------------------
-- �Ʒ� ������ subquery�� ������� �ʰ� �ۼ��ϼ���.
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ (EXISTS)
SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

SELECT *
FROM dept
WHERE EXISTS (SELECT 'a'
                            FROM  emp
                            WHERE deptno = dept.deptno);
-- IN
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                                FROM  emp);
                                
                                
-- �� �������� (�ǽ� sub9) (����) ----------------------------------------------------------------------------------------------------------------
-- cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ� ��ǰ�� ��ȸ�ϴ� ������ EXISTS �����ڸ�
-- �̿��Ͽ� �ۼ��ϼ���.
SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'a'
                                    FROM cycle
                                    WHERE cid = 1
                                    AND pid = product.pid );
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ���տ���
-- UNION    :   ������, �ߺ��� ����
--                    DBMS������ �ߺ��� �����ϱ� ���ؼ� �����͸� ����.     -- �����̾� �� ���� ���� ������ �� ������ �Ѿ ���� �������� ����.
--                    (�뷮�� �����͸� ���Ľ� ���ϰ� �ɸ�)
-- UNION ALL    :   UNION�� ���� ����
--                    (�ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���ո� �Ѵ�. �� �ߺ��� ���� �� ����.
--                    �� �Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ� UNION �����ں��� ���� �鿡�� ����)
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;

-- ����� 7369, 7499�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;


-- UNION
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
    UNION
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
    UNION
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
-- �������� ��, �� ���� ������ ������� ������ �ߺ� ����

-- UNION ALL
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
    UNION ALL
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;



-- INTERSECT (������   :   �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7369 )
    INTERSECT
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7499 );



-- MINUS (������   :   �� ���տ��� �Ʒ� ������ ���� )
-- ������ ���� (���� �Ʒ��� �����͸� �ٲٸ� ����� �޶��� �� �ִ�.)
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7369 )
    MINUS
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7499 ); -- 7369


SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7499 )
    MINUS
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7369 ); -- 7499


SELECT 1 n, 'x' m
FROM dual
    MINUS
SELECT 2, 'y'
FROM dual
ORDER BY n;
-- ������ Ʋ���� Ÿ���� �޶����� ������ �� �ȴ�. �� ������ ��.
-- ������ ���� �������� ���� ��




SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC16'
AND TABLE_NAME IN ( 'PROD', 'LPROD' )
AND CONSTRAINT_TYPE IN ( 'P', 'R' );

