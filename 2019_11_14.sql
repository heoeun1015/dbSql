-- �������� Ȱ��ȭ / ��Ȱ��ȭ
-- � ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ���?

-- _pk �� �������� �ְų� �߰��� �ִ� ������ ������ �������ִ� ���� ����.
-- emp fk ���� (dept ���̺��� deptno �÷� ����)
-- FK_EMP_TEST_DEPT ��Ȱ��ȭ
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept;

-- �������ǿ� ����Ǵ� �����Ͱ� �� �� ���� ������?
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 80);


-- FK_EMP_TEST_DEPT Ȱ��ȭ
-- �� ���� ����Ǵ� �����͸� �־����� Ȱ��ȭ���� �ʴ´�.
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept;

DELETE emp_test
WHERE empno = 9999;
COMMIT;

SELECT *
FROM emp;


-- ���� ������ �����ϴ� ���̺� ��� view  :   USER_TABLES
-- ���� ������ �����ϴ� �������� view    :   USER_CONSTRAINTES
-- ���� ������ �����ϴ� ���������� �÷� view    :   USER_CONS_COLUMNS

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'CYCLE';

-- FK_EMP_TEST_DEPT
SELECT *
FROM USER_CONS_COLUMNS
WHERE constraint_name = 'FK_EMP_TEST_DEPT';

SELECT *
FROM USER_CONS_COLUMNS
WHERE constraint_name = 'PK_CYCLE';


-- ���̺� ������ �������� ��ȸ (view ����)
-- ���̺�� / �������Ǹ� / �÷��� / �÷� ������
SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P'
ORDER BY a.table_name, b.position;    -- PRIMARY KEY �� ��ȸ


DESC CUSTOMER;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- emp ���̺�� 8���� �÷� �ּ� �ޱ�
-- EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO

-- ���̺� �ּ� view  :   USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp ���̺� �߼�
COMMENT ON TABLE emp IS '���';

-- emp ���̺��� �÷� �ּ�
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- �ּ��� �� ���� ���� �ϵ��� ����.
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';



-- �� DDL (Table - comments  �ǽ� comment1) -----------------------------------------------------------------------------------------------
-- user_tab_comments, user_col_comments view�� �̿��Ͽ� customer, product, cycle, daily ���̺�� �÷��� �ּ�������
-- ��ȸ�ϴ� ������ �ۼ��϶�.
SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;

SELECT t.table_name, table_type, t.comments tab_comment, column_name, c.comments col_comment
FROM user_tab_comments t JOIN user_col_comments c ON (t.table_name = c.table_name)
WHERE t.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');

SELECT t.table_name, table_type, t.comments tab_comment, column_name, c.comments col_comment
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name
    AND t.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- VIEW ���� (emp ���̺��� sal, comm �� �� �÷��� �����Ѵ�.)
-- ȸ�縶�� �ٸ��� �ѵ� ������ v�� �����Ѵ�. ���̺��� ��� tb.
-- system : GRANT CREATE VIEW TO pc16;
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;


-- INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
             FROM emp );

-- view: �̸��� ���� �༮���� �̸��� �ٿ����.
-- view ( �� �ζ��κ�� �����ϴ�. )
SELECT *
FROM v_emp;


-- ���ε� ���� ����� view �� ���� : v_emp_dept
-- emp, dept    :   �μ���, �����ȣ, �����, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;


-- VIEW ����
DROP VIEW v_emp;


-- VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����.
-- dept 30 - SALES
SELECT *
FROM dept;

SELECT *
FROM v_emp_dept;

-- dept ���̺��� SALES �� MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;
ROLLBACK;

-- view�� ������Ʈ�� ���� �����ϱ� �ѵ� �Ϲ������� ������� �ʴ´�.


-- HR �������� v_emp_dept view ��ȸ ������ �ش�.
GRANT SELECT ON v_emp_dept TO hr;

-- hr
-- SELECT *
-- FROM pc16.v_emp_dept;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SEQUENCE ���� ( �Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

SELECT seq_post.nextval, seq_post.currval
FROM dual;

-- ��� �������� ���� ���� �󸶳� : currval
SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
        AND title = '������'
        AND reg_dt = TO_DATE('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');
        -- WHERE ���� ���� ���� ������ �����Ƿ� ��¥�־�� ��ü���ش�.
        
SELECT *
FROM post
WHERE post_id = 1;
-- �������� �̷��� ��¥ �־�� Ȱ���� �� �ִ�.

-- �Խñ��� ��� ������, ÷������ó�� �����ϴ� ���̺��� ��쿡�� currval�� ���ָ� �ȴ�.
-- �Խñ�
SELECT seq_post.nextval
FROM dual;

-- �Խñ� ÷������
SELECT seq_post.currval
FROM dual;


-- ������ ����
-- ������: �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
-- 1, 2, 3, ��

DESC emp_test;
DROP TABLE emp_test;

CREATE TABLE emp_test(
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR2(15)
);

CREATE SEQUENCE seq_emp_test;

--INSERT INTO emp_test VALUES ( �ߺ����� �ʴ� ��, 'brown');
INSERT INTO emp_test VALUES ( seq_emp_test.nextval, 'brown');

SELECT seq_emp_test.nextval
FROM dual;

SELECT *
FROM emp_test;

ROLLBACK;   -- �ص� �������� �ѹ���� �ʴ´�.




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- index ( ���� )
-- rowid    :   ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺� �����ϴ� ���� �����ϴ�.
SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFTnAAFAAAAFNAAA';

-- table    :   pid, pnm
-- pk_product   :   pid
SELECT pid
FROM product
WHERE ROWID = 'AAAFTnAAFAAAAFNAAA';
-- �ε����� ������ ���� ���̺� �������� �ʾƵ� �ȴ�. �� �������� ��츦 ����.
-- �� �� ã���� �� �̻� ã�� �ʿ䰡 ����. ã�ų� ���ų� �� �� �ϳ�.
-- + �� ��Ų. ã���� �ϴ� �����Ϳ��� �ϳ��� �� �д´�. ���� �ε������� ������ �Ǿ� �ֱ� ������ ���� �����Ͱ� ������ �������� ������ �ȴ�.

-- access predicate :   ������ �� �ٸ���. ���� �ε���, �Ĵ� �ε����� ���� ���ǽ�
-- SELECT empno FROM emp WHERE job = 'MANAGER' AND ename LIKE 'C%';


-- �����ȹ�� ���� ������ �ε��� ��뿩�� Ȯ��;
-- emp ���̺� empno �÷��� �������� �ε����� ���� ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;

-- �ε����� �־ ����Ŭ ��ü�� �Ǵ����� �������� ���� ���� ���̺� ��ü�� �д°� �� ���� ��� �ε����� ���� �ʰ� �ٷ� ���̺��� ��ȸ�� ���� �ִ�.
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

-- �ε����� ���� ������ empno = 7369 �����͸� ã�� ���� emp ���̺��� ��ü�� ã�ƺ��� �Ѵ�. �� TABLE FULL SCAN


-- ��� ������ SQL �����ȹ�� ���´�.
SELECT *
FROM TABLE (dbms_xplan.display);

--=============================================================================
Plan hash value: 2518139176
 
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                                | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                             |             |         1 |    37 |                  1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID       | EMP         |     1 |    37 |                 1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN                          | UK_EMP_TEST |     1 |          |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):     -- id�� ���ؼ� �ĺ��� �ȴ�.
------------------------------------------------------------------------------------------------------------------------------
 
   2 - access("EMPNO"=7369)
--=============================================================================

-- �� SELECT ������ ����, 0�� ���۷��̼��� �ڽ��̴�. �ڽ��� ������ �ڽĺ��� �д´�. �б� ���� ) 1�� �� 0��
-- �� Predicate Information (identified by operation id):     -- id�� ���ؼ� �ĺ��� �ȴ�.































