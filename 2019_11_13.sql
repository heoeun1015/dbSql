 -- unique table level constraint
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test(
        deptno NUMBER(2)    PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13),
        
        -- CONSTRAINT  �������� �� CONSTRAINT TYPE [ (�÷�....) ]
        CONSTRAINT uk_dpet_test_dname_loc UNIQUE (dname, loc)
        -- �����͸� �Է��� �ߴµ�, �� �����Ͱ� �ߺ����� �ƴ��� ������ ã�� ���� unique�� ����Ѵ�.
 );
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 -- ù ��° ������ ���� dname, loc ���� �ߺ��ǹǷ� �� ��° ������ ������� ���Ѵ�.
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 
 
 
 -- FOREIGN KEY (���� ����)
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test (
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13)  
 );
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- emp_test(empno, ename, deptno)
 DESC emp;
 CREATE TABLE emp_test(
        empno NUMBER (4) PRIMARY KEY,
        ename VARCHAR2(10),
        deptno NUMBER(2) REFERENCES dept_test(deptno)
        -- dept_test�� �����ϴ� �μ� ��ȣ�� �����ϰԲ� ����
 );
 -- dept_test ���̺� 1�� �μ���ȣ�� �����ϰ�  fk������ dept_table.deptno �÷��� �����ϵ��� �����Ͽ��� ������
 -- 1�� �̿��� �μ���ȣ�� emp_test ���̺� �Էµ� �� ����.
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- emp_test fk �׽�Ʈ insert
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 
 -- 2�� �μ��� dept_test ���̺� �������� �ʴ� �������̱� ������ fk ���࿡ ���� INSERT �� ���������� �������� ���Ѵ�.
 INSERT INTO emp_test VALUES (9999, 'sally', 1);
 
 INSERT INTO emp_test VALUES (9998, 'sally', 1);
 
 SELECT *
 FROM  dept_test;
 
 SELECT *
 FROM  emp_test;
 
 -- ���Ἲ ���࿡�� �߻��� �� �ؾ� �ұ�?
 -- �Է��Ϸ��� �ϴ� ���� �´��� Ȯ��. (2���� �³�? 1���� �ƴ���?)
 --     . �θ����̺� ���� �� �Էµ��� �ʾҴ��� Ȯ�� (dept_test Ȯ��)
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- fk ���� table level constraint
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(3) PRIMARY KEY,
        ename VARCHAR(10),
        deptno  NUMBER(2),
        CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
        (deptno) REFERENCES dept_test (deptno)
 );
 
 
 -- FK������ �����Ϸ��� �����Ϸ��� �÷��� �ε����� �����Ǿ� �־�� �Ѵ�.
 DROP TABLE dept_test;      -- �����ϴ� ���� �ֱ� ������ �θ���� ����� �� �ȴ�.
 
 DROP TABLE emp_test;
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test(
        deptno NUMBER(2), /* PRIMARY KEY �� UNIQUE ���� X �� �ε��� ���� X*/ 
        dname VARCHAR2(14),
        loc VARCHAR2(13)
 );

 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        -- dept_test.dept_no �÷��� �ε����� ���� ������ ���������� fk ������ ������ �� ����.
        deptno NUMBER(2) REFERENCES dept_test (deptno)
 );
 
 
 
 -- ���̺� ����
 DROP TABLE dept_test;
  
 CREATE TABLE dept_test(
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13)
 );

 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2) REFERENCES dept_test (deptno)
 );
 
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 COMMIT;
 
 DELETE dept_test
 WHERE deptno = 1;
 -- ���Ἲ ���࿡ ���ؼ� �������� �ʴ´�.
 -- dept_test ���̺��� deptno ���� �����ϴ� �����Ͱ� ���� ��쿣 ������ �Ұ����ϴ�.
 -- ��, �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� �θ� ���̺��� �����͸� ������ �� �ִ�.
 
 DELETE emp_test WHERE empno = 9999;
 DELETE dept_test WHERE deptno = 1;
 -- ������ �Ϸ��� ��ó�� �ؾ� ��.
 
 
 -- FK ���� (�ɼ�)
 -- default :  ������ �Է� / ������ ���������� ó������� fk ������ �������� �ʴ´�.        -- ������ �� �����ؾ� �Ѵ�.
 -- ON DELETE CASCADE   :   �θ� ������ ������ �����ϴ� �ڽ� ���̺� ���� ����
 -- ON DELETE NULL  :   �θ� ������ ������ �����ϴ� �ڽ� ���̺� �� NULL ����
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR(10),
        deptno  NUMBER(2),
        CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
        (deptno) REFERENCES dept_test (deptno) ON DELETE CASCADE
 );
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM emp_test;
 
-- INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 COMMIT;
 
 
 -- FK ���� default �ɼǽÿ��� �θ� ���̺��� �����͸� �����ϱ� ���� �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� ���������� ������ ��������.
 -- ON DELETE CASCADE�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �����͸� ���� �����Ѵ�.
 -- 1. ���� ������ ���������� ������ �Ǵ���?
 -- 2. �ڽ� ���̺� �����Ͱ� ���� �Ǿ�����?
 DELETE dept_test
 WHERE deptno = 1;
 
 SELECT *
 FROM emp_test;
 
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
-- FK  ���� ON DELETE SET NULL 
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR(10),
        deptno  NUMBER(2),
        CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
        (deptno) REFERENCES dept_test (deptno) ON DELETE SET NULL
 );
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM emp_test;
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 COMMIT;
 
 
 -- FK ���� default �ɼǽÿ��� �θ� ���̺��� �����͸� �����ϱ� ���� �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� ���������� ������ ��������.
 -- ON DELETE SEL NULL�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �������� ���� �÷��� NULL�� �����Ѵ�.
 -- 1. ���� ������ ���������� ������ �Ǵ���?
 -- 2. �ڽ� ���̺� �����Ͱ� NULL�� ������ �Ǿ�����?
 DELETE dept_test
 WHERE deptno = 1;
 
 SELECT *
 FROM emp_test;
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 -- FK ���� ����
 -- CHECK ����    :   �÷��� ���� ������ ����, Ȥ�� ���� �����Բ� ����
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        sal NUMBER CHECK (sal >= 0)
 );
 
 -- sal �÷��� CHECK ���� ���ǿ� ���� 0�̰ų�, 0���� ū ���� �Է��� �����ϴ�.
 INSERT INTO emp_test VALUES (9999, 'brown', 10000);
 INSERT INTO emp_test VALUES (9998, 'sally', -10000);
 
 
  DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        -- emp_gb   :   01 - ������, 02 - ����
        emp_gb VARCHAR2(2) CHECK ( emp_gb IN ('01', '02'))
--        emp_gb VARCHAR2(2) CONSTRAINT sal_check CHECK ( emp_gb IN ('01', '02'))   --�������� �̸� ����
 );
 
 INSERT INTO emp_test VALUES (9999, 'brwon', '01');
 -- emp_gb �÷� üũ���࿡ ���� 01, 02�� �ƴ� ���� �Էµ� �� ����.
 INSERT INTO emp_test VALUES (9998, 'sally', '03');
 
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- SELECT ����� �̿��� TABLE ����
 -- CREATE TABLE ���̺�� AS
 -- SELECT ����
 -- �� CTAS
 
 
 DROP TABLE emp_test;
 DROP TABLE dept_test;
 
 -- CUSTOMER ���̺��� ����Ͽ� CUSTOMER_TEST ���̺�� ����
 -- CUSTOMER ���̺��� �����͵� ���� ����
 CREATE TABLE customer_test AS
 SELECT *
 FROM customer;
 
 SELECT *
 FROM customer_test;
 
 -- SELECT�� ����� ���� ���� �� �ִ�.
 CREATE TABLE test AS
 SELECT SYSDATE dt      -- alias �� �� ��� ��.
 FROM dual;
 
 SELECT *
 FROM test;
 
 DROP TABLE test;
 
 
 -- �����ʹ� �������� �ʰ� Ư�� ���̺��� �÷� ���ĸ� ������ �� ������?
 -- �� SELECT�� ������� �������� ������ �ȴ�. ���� ���� ����� ������ �ʴ� ������ ���� �߰��� ���ָ� ��.
 DROP TABLE customer_test;
 CREATE TABLE customer_test AS
 SELECT *
 FROM customer
-- WHERE cid = -99;
-- WHERE 1 != 1;  -- ���� ���� �� ���� ����
WHERE 1 = 2;    

 
 
 
 -- check ���ǵ� ������� �ʴ´�. NOT NULL �� ����
 CREATE TABLE test (
        c1 VARCHAR(2) CHECK (c1 in ('01', '02'))
 );
 
 CREATE TABLE test2 AS
 SELECT *
 FROM test;
 
 
DROP TABLE test;
DROP TABLE test2;
 
 
 
 
 -- ȸ�� ����... �̷� ������ ���� ���� �� ��. �׽�Ʈ ������ �����͸� �� ���ܵε��� ����.
 CREATE TABLE customer_191113 AS
 SELECT *
 FROM customer;
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- ���̺� ����
 -- ���ο� �÷� �߰�
 
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10)
 );
 
 -- �ű� �÷� �߰�
 ALTER TABLE emp_test ADD ( deptno NUMBER(2) );
 DESC emp_test;
 
 
 -- ���� �÷� ����
 ALTER TABLE emp_test MODIFY (  ename VARCHAR2(200) );
 DESC emp_test;
 
 
 -- ���� �÷� Ÿ�� ����(���̺� �����Ͱ� ���� ��Ȳ)
 ALTER TABLE emp_test MODIFY (  ename NUMBER );
 DESC emp_test;
 
 
 -- ���� �÷� Ÿ�� ����. �������̴�.
 INSERT INTO emp_test VALUES (9999, 1000, 10);
 COMMIT;
 -- ������ Ÿ���� �����ϱ� ���ؼ��� �÷� ���� ��� �־�� �Ѵ�.
 ALTER TABLE emp_test MODIFY (  ename VARCHAR2(10) );
 
 
 -- DEFAULT ����
 DESC emp_test;
 ALTER TABLE emp_test MODIFY (  deptno DEFAULT 10 );
 
 
 -- �÷��� ����
 ALTER TABLE emp_test RENAME COLUMN deptno TO dno;
 DESC emp_test;
 
 
 -- �÷� ���� (DROP)
 ALTER TABLE emp_test DROP COLUMN dno;
 ALTER TABLE emp_test DROP (dno) ;      -- �̷��� �ᵵ ������ �ȴ�.
 DESC emp_test;
 
 
 
 -- ���̺� ���� :  ���� ���� �߰�
 -- PRIMARY KEY
 ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY ( empno );
 
 -- ���� ���� ����
 ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
 
 
 
 
 -- UNIQUE  ����  -   empno
 ALTER TABLE emp_test ADD CONSTRAINT uk_emp_test UNIQUE  (empno);
 
 
 -- UNIQUE ���� ���� : uk_emp_test
 ALTER TABLE emp_test DROP CONSTRAINT uk_emp_test;
 
 

-- FOREIGN KEY �߰�
DESC dept_test;

-- �ǽ�
-- 1. DEPT ���̺��� DEPTNO �÷����� PRIMARY KEY ������ ���̺� ����
-- DDL�� ���� ����
ALTER TABLE dept ADD CONSTRAINT uk_dept_test PRIMARY KEY (deptno);


-- 2. EMP ���̺��� EMPNO �÷����� PRIMARY KEY ������ ���̺� ����
-- DDL�� ���� ����
ALTER TABLE emp ADD CONSTRAINT uk_emp_test PRIMARY KEY (empno);
 
 
-- 3. EMP ���̺��� DEPTNO �÷����� DEPT ���̺��� DEPTNO �÷��� �����ϴ� FK ������ ���̺� ���� DDL�� ���� ����
 -- emp �� dept (deptno) 
 SELECT *
 FROM emp;
 
 ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY ( deptno )
 REFERENCES dept ( deptno );        -- �����ϴ� �ٸ� ���̺� ���� ���� ��.
 
 
 
 -- emp_test �� dept.deptno  fk ���� ����    (ALTER TABLE)
 DROP TABLE emp_test;
 
  CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2)
);
 
 DESC emp_test;
 
 ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno)
 REFERENCES dept ( deptno ); 
-- ALTER TABLE emp_test DROP CONSTRAINT fk_emp_dept;
 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- CHECK ���� �߰� (ename ���� üũ, ���̰� 3���� �̻�)
 ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK (LENGTH(ename) > 3);
 
 SELECT *
 FROM emp_test;
 
 INSERT INTO emp_test VALUES (9999, 'brown', 10);
 INSERT INTO emp_test VALUES (9999, 'br', 10);
 ROLLBACK;
 
 
 -- CHECK ���� ����
 ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;
 
 
 
 -- NOT NULL ���� �߰�
 -- ALTER TABLE emp_test MODIFY ( ename NOT NULL );
 
 -- NOT NULL ���� ���� (NULL ���?)
 -- ALTER TABLE emp_test MODIFY ( ename NULL );
 
 
 
 
 
 
 