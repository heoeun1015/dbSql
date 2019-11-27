
SELECT *
FROM no_emp;

-- 1. leaf node ã��
SELECT LPAD(' ', (LEVEL - 1) * 8, ' ') || org_cd org_cd, LEVEL, s_emp
FROM (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
             FROM (SELECT org_cd, parent_org_cd, /*no_emp, lv, leaf, rn, gr,*/
                                      SUM(no_emp / org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
                         FROM (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
                                                   COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
                                    FROM (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, CONNECT_BY_ISLEAF leaf
                                                FROM no_emp
                                                START WITH parent_org_cd IS NULL
                                                CONNECT BY PRIOR org_cd = parent_org_cd) a
                                    START WITH leaf = 1
                                    CONNECT BY PRIOR parent_org_cd = org_cd))
            GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- PS / SQL
-- �Ҵ翬�� :=
-- System.out.println(" ") �� dbms_output.put_line(" ");
-- LOG4j
-- set erveroutput on;   -- ��±�� Ȱ��ȭ

-- PL / SQL
-- declare : ����, ��� ����
-- begin : ���� ����
-- exception : ����ó��

DESC dept;

SET SERVEROUTPUT ON;

DECLARE 
        -- ���� ����
        deptno NUMBER(2);
        dname VARCHAR(14);
BEGIN 
        --dbms_output.put_line('test');
        SELECT deptno, dname INTO deptno, dname     -- INTO �����Ͱ� �� ���� �� ���
        FROM dept
        WHERE deptno = 10;
        
        -- SELECT ���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
        dbms_output.put_line('dname: ' || dname || '(' || deptno || ')') ;
END;
/

DECLARE 
        -- ���� ���� ����(���̺� �÷�Ÿ���� ����ŵ� PL / SQL ������ ������ �ʿ䰡 ����.)
        deptno dept.deptno%TYPE;
        dname dept.dname%TYPE;
BEGIN 
        SELECT deptno, dname INTO deptno, dname     -- INTO �����Ͱ� �� ���� �� ���
        FROM dept
        WHERE deptno = 10;
        
        -- SELECT ���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
        dbms_output.put_line('dname: ' || dname || '(' || deptno || ')') ;
END;
/

-- 10�� �μ��� �μ��̸��� LOC ������ ȭ�� ����ϴ� ���ν���
-- ���ν����� : printdept
-- CREATE OR REPLACE VIEW 

-- ���ν��� ��ü �����
CREATE OR REPLACE PROCEDURE printdept
IS
        -- ��������
        dname dept.dname%TYPE;
        loc dept.loc%TYPE;
BEGIN
        SELECT dname, loc 
        INTO dname, loc
        FROM dept
        WHERE deptno = 10;
        
        dbms_output.put_line('dname, loc = ' || dname || ', ' || loc);
END;
/

-- EXEC : ���ν��� ���
EXEC printdept;



CREATE OR REPLACE PROCEDURE printdept_p (p_deptno IN dept.deptno%TYPE)
IS     -- ��������
        dname dept.dname%TYPE;
        loc dept.loc%TYPE;
BEGIN
        SELECT dname, loc 
        INTO dname, loc
        FROM dept
        WHERE deptno = p_deptno;
        
        dbms_output.put_line('dname, loc = ' || dname || ', ' || loc);
END;
/

EXEC printdept_p(30);



-- �� PL / SQL ( procedure ���� �ǽ� pro_1 ) --------------------------------------------------------------------------------------------------
-- printemp procedure ����
-- param : empno
-- logic : empno�� �ش��ϴ� ����� ������ ��ȸ�Ͽ� ����̸�, �μ��̸��� ȭ�鿡 ���
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE printemp_procedure (p_empno IN emp.empno%TYPE)
IS
        var_ename emp.ename%TYPE;
        var_dname dept.dname%TYPE;
BEGIN
        SELECT ename, dname 
        INTO ename, dname
        FROM emp, dept
        WHERE empno = p_empno
                AND emp.deptno = dept.deptno;
        
        dbms_output.put_line('ename, dname = ' || var_ename || ', ' || var_dname);
END;
/

EXEC printemp_procedure(7369);
-----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

COMMIT;

-- �� PL / SQL ( procedure ���� �ǽ� pro_2 ) --------------------------------------------------------------------------------------------------
-- registdept_test procedure ����
-- param : deptno, dname, loc
-- logic : �Է¹��� �μ� ������ dept_test ���̺� �ű� �Է�
-- exec registdept_test ('99', 'ddit', 'daejeon');
-- dept_test ���̺� ���������� �ԷµǾ����� Ȯ��

UPDATE dept_test SET deptno = ' ';
UPDATE dept_test SET dname = ' ';
UPDATE dept_test SET loc = ' ';

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.deptno%TYPE,
                                                                                      p_dname IN dept_test.dname%TYPE,
                                                                                      p_loc IN dept_test.loc%TYPE)
IS

BEGIN
        INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/

EXEC registdept_test('99', 'ddit', 'daejeon');

























