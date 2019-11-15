-- emp ���̺� empno �÷��� �������� PRIMARY KEY�� ����
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE �� �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
-- PRIMARY KEY �� ����ϸ鼭 ������� �ε����� �ڵ������� ����� ���

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

--��������������������������������������������������������������������������
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    37 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    37 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)  -- �ε����� ������ �� ���Ǵ� ����
--��������������������������������������������������������������������������



-- empno �÷����� �ε����� �����ϴ� ��Ȳ���� �ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--��������������������������������������������������������������������������
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   111 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   111 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
--��������������������������������������������������������������������������


-- �ε��� ���� �÷��� SELECT ���� ����� ���
-- ���̺� ������ �ʿ����

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--��������������������������������������������������������������������������
Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
-- �ε��� �÷��� �о ���ϴ� �ε����� �� �ִ�.
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
--��������������������������������������������������������������������������


-- �÷��� �ߺ��� ������ non-unique �ε��� ���� ��
-- unique index���� �����ȹ ��
-- PRIMARY KEY �������� ���� (unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--��������������������������������������������������������������������������
Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
--��������������������������������������������������������������������������


-- emp ���̺� job �÷����� �� ��° �ε��� ���� (non-unique index)
-- job �÷��� �ٸ� �ο��� job �÷��� �ߺ��� ������ �÷��̴�.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);


--��������������������������������������������������������������������������
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   111 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   111 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
--��������������������������������������������������������������������������


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--��������������������������������������������������������������������������
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')        -- �ε��� Ȯ�� �Ұ�. ���̺� ������ �ؾ����� �� �� �ִ� ��.
   2 - access("JOB"='MANAGER')
--��������������������������������������������������������������������������



-- emp ���̺� job, ename �÷��� �������� non-unique �ε��� ����
CREATE INDEX IDX_emp_03 ON emp (job, ename);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);


--��������������������������������������������������������������������������
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')        -- access�� filter�� ���ÿ� �ƴ�.
--��������������������������������������������������������������������������


-- emp ���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX IDX_emp_04 ON emp (ename, job);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';
-- �̷� ���� �ε����� ����ϱ� ���� ���� ��. ������� �� ������ �� �� ����.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename LIKE '%C'
    AND job = 'MANAGER';
-- WHERE �� ���� ������ �ٲ�ٰ� �ؼ� ����� �޶����� ���� ����. SQL�� Set�� �����̱� ����.

SELECT *
FROM TABLE(dbms_xplan.display);


--��������������������������������������������������������������������������
Plan hash value: 4060516099
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
    -- ������ ���� �Ŷ�� �����ϰ� ename���� �� ��ĵ�� �Ѵ�.
    -- �ε��� �÷� ������ ���󼭵� ����� �ٲ��.
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
--��������������������������������������������������������������������������


-- HINT�� ����� �����ȹ ����
    -- RDBS�� �⺻ ����� ����ڰ� ������ ���� ����� �� �ִ�. hint�� ����ϸ� �׷� ������ ������ ���Ѵٰ� �Ⱦ��ϴ� ����鵵 ����.
    -- WHERE �� �ǵ������ �� �غôµ� �׷��� �� �ȴٰ� ���� �� �������� ����ϴ� ������...

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_01) */ *      -- ����Ŭ���� �������� ����� ��� �ּ� ó�� �κ�(HINT)
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';
-- �̷� ���� �ε����� ����ϱ� ���� ���� ��. ������� �� ������ �� �� ����.

SELECT *
FROM TABLE(dbms_xplan.display);


        -- CTAS


-- �� DDL (index �ǽ� idx1) -----------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 �������� DEPT_TEST ���̺� ���� �� ����
-- ���ǿ� �´� �ε����� �����ϼ���.

CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1;

SELECT *
FROM dept_test;

-- 1. deptno �÷��� �������� unique �ε��� ����
ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);

-- 2. dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx_emp_test ON dept_test (dname);

-- 3. deptno, dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx2_emp_test ON dept_test (deptno, dname);
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- �� DDL (index �ǽ� idx2) -----------------------------------------------------------------------------------------------------------------------
-- �ǽ� idx1���� ������ �ε����� �����ϴ� DDL ���� �ۼ��ϼ���.
ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
DROP INDEX idx_emp_test;
DROP INDEX idx2_emp_test;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� DDL (index �ǽ� idx3) -----------------------------------------------------------------------------------------------------------------------
-- �ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp ���̺� �ʿ��ϴٰ� �����Ǵ� �ε����� ���� ��ũ��Ʈ��
-- ��������.
SELECT *
FROM emp
WHERE empno = 7298;

SELECT *
FROM emp
WHERE ename = 'SCOTT';

SELECT *
FROM emp
WHERE sal BETWEEN 500 AND 7000
    AND deptno = 20;
    
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno = 10
    AND emp.empno LIKE '78%';
    
SELECT B.*
FROM emp A, emp B
WHERE A.mgr = B.empno
    AND A.deptno = 30;

ALTER TABLE emp ADD CONSTRAINT pk_emp_idxtest1 PRIMARY KEY (empno);

CREATE INDEX idx_emp_test_1 ON emp (ename);
CREATE INDEX idx_emp_test_2 ON emp (deptno);
CREATE INDEX idx_emp_test_3 ON emp (deptno, mgr);
-- CREATE INDEX idx_dept_test_1 ON dept (deptno); -- �̹� PRAIMARY KEY �� ����.
----------------------------------------------------------------------------------------------------------------------------------------------------------

