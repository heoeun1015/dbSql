-- ���� 7, 9 Ǯ��

-- commit �� ������ ������ �ٸ� ����ڰ� ����� �� ����. �ݵ�� ���� ��.




SELECT *
FROM dept;

DELETE dept WHERE deptno = 99;
-- �� ������ ���� �� ������ Ȯ���� ���� �ƴϴ�. Ʈ������� ������ ������� ��.
COMMIT;

INSERT INTO dept
VALUES (99, 'DDIT', 'daejeon');

ROLLBACK;



-- customer�� ��� �� ��ȣ�� �ߺ��� �� ����.
-- �� ����ڰ� �߰��� �� commit�� ������ ������ �ٸ� ����ڰ� �Ȱ��� ����� ������� �� Ʈ������� �������Ǳ� ���� ���� �ε��� �ɸ�.
INSERT INTO customer
VALUES (99, 'ddit');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INSERT
-- ���̺� ��� �÷��� ���� ���� ���� []�� ������ �ʾƵ� �ȴ�.

INSERT INTO dept
VALUES('ddit', 99, 'daejeon');
-- �÷��� ������ ���� �ʱ� ������ ������ ����.


DESC emp;

INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);   --VALUES (9999, 'brown', "");
-- 1 �� ��(��) ���ԵǾ����ϴ�.


SELECT *
FROM emp
WHERE empno = 9999;


INSERT INTO emp (ename, job)
VALUES ('brown', null);
-- �ʼ� ���� ������ ���̺� ���Ե��� ����. (empno) 

ROLLBACK;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP' -- ����Ŭ������ ��ü�� �빮�ڷ� �����Ѵ�. ã������ ���ڿ� �빮�ڷ� ã�ƾ� ��
ORDER BY column_id;

1. EMPNO
2. ENAME
3. JOB
4. MGR
5. HIREDATE
6. SAL
7. COMM
8. DEPTNO;
-- ������ ���缭 �ۼ�

INSERT INTO emp
VALUES  (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

COMMIT;

SELECT *
FROM emp
WHERE empno = 9999;

--COMMIT;

DELETE emp;
ROLLBACK;       -- �ѹ��� Ŀ���ϱ� ������ �����ϴ�. �� �����.

-- SELECT ���(���� ��)�� INSERT

DESC emp;

SELECT *
FROM dept;

INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;

SELECT *
FROM dept;

COMMIT;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- UPDATE
-- UPDATE ���̺� SET �÷� = ��, �÷� = ����
-- WHERE condition


desc dept;

-- ���� ������ ����� ����. �������� �������� where������ ��.
UPDATE dept SET dname = '���IT', loc='ym'
WHERE deptno = 99;

--UPDATE dept SET dname = '���IT', loc='ym';
-- dept ��� ���̺� ���ؼ� �� ������ �����ϰڴ�. �����ϸ� 5���� ���� �ٲ�� ��.


SELECT *
FROM emp;

-- DELETE ���̺� ��
-- WHERE condition
-- �����ȣ�� 9999�� ������ emp  ���̺��� ����
DELETE emp
WHERE empno = 9999;

-- �μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5��(4��)�� �����͸� ����
-- 10, 20, 30, 40, 99   ��   empno < 100, empno BETWEEEN 10 AND 99
DELETE emp
WHERE empno < 100;

--�� ��. DELETE �� ������ ���� SELECT �� ���� �� �� �Ẹ�� ���� ����.
--SELECT *
--FROM emp
--WHERE empno < 100;

SELECT *
FROM emp;

ROLLBACK;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

--SELECT *
--FROM emp
--WHERE empno BETWEEN 10 AND 99;


DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

--SELECT *
--FROM emp
--WHERE empno IN (SELECT deptno FROM dept);

DELETE emp WHERE empno = 9999;
COMMIT;




-- TRUNCATE TABLE :   �α׸� ������ �ʰ� ���� �� ���� ���� ���


SELECT *
FROM dept;

-- LV1 �� LV3
SET TRANSACTION olation LEVEL SERIALIZABLE;     -- ORACLE ������ ���� ���� ����������, ������ ������� �� ��

-- DML ������ ���� Ʈ����� ����
INSERT INTO dept
VALUES (99, 'ddit', 'daejeon');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- �ش� ���̺� ����
-- DROP TABLE ranger_new;

-- DDL: AUTO COMMIT,    rollback �� �� �ȴ�.
-- CREATE
CREATE TABLE ranger_new (
    ranger_no NUMBER,       -- ���� Ÿ��
    ranger_name VARCHAR2(50), -- ����: [VARCHAR2], CHAR: ���� ����ŭ �������� ä������ ������ ������� �ʴ� ���� ����.
    reg_dt DATE DEFAULT sysdate     -- DEFAULT  : SYSDATE
);

desc ranger_new;

ROLLBACK;


INSERT INTO ranger_new (ranger_no, ranger_name)     --VALUES (1000, 'brown')�� ��� ������ ����� ��.
VALUES (1000, 'brown');
COMMIT;

SELECT *
FROM ranger_new;



-- ��¥ Ÿ�Կ��� Ư�� �ʵ� ��������
-- ex   :   sysdate ���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY') year
FROM dual;

SELECT ranger_no, ranger_name, reg_dt,
            TO_CHAR(reg_dt, 'MM') ch, 
            EXTRACT (YEAR FROM reg_dt) year,
            EXTRACT (MONTH FROM reg_dt) mm,
            EXTRACT (DAY FROM reg_dt) day
FROM ranger_new;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- ��������
-- DEPT ����ؼ� DEPT_TEST ����
DESC dept_test;
CREATE TABLE dept_test(
        dpetno NUMBER(2) PRIMARY KEY,       -- deptno �÷��� �ĺ��ڷ� ����. �ĺ��ڷ� ������ �Ǹ� ���� �ߺ� �� �� ������, null�� ���� ����.
        dname VARCHAR2(14),                           
        loc VARCHAR2(13)
);


SELECT *
FROM dept_test;

-- primary key ���� ���� Ȯ��
-- 1. null �� �� �� ����.
-- 2. deptno �÷��� �ߺ��� ���� �� �� ����.
INSERT INTO dept_test   (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test  VALUES   (1, 'ddit', 'daejeon');
INSERT INTO dept_test  VALUES   (1, 'ddit2', 'daejeon');

ROLLBACK;


-- ����� ���� ���� ���Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,       -- �������ǿ� ���� �̸�
        dname VARCHAR2(14),
        loc VARCHAR2(13)
);


-- TABLE CONSTRAINT
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2),
        dname VARCHAR2(14),
        loc VARCHAR2(13),
        
        CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
        -- deptno �� �����ϴ��� dname�� �ٸ��� �ٸ� ������ �ν��� �Ѵ�.
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');       -- primary Ű�� ��ó�� �༭ �� �� ����.

SELECT *
FROM dept_test;

ROLLBACK;


-- NOT NULL
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14) NOT NULL,
        loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');




-- UNIQUE
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14) UNIQUE,
        loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
--INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon');
-- ������ ���̾�� �Ǵµ� ���� ���� ����. ������ ��.

INSERT INTO dept_test VALUES(2, 'ddit2', 'daejeon');






