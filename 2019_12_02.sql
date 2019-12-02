
-- �͸� ���
SET SERVEROUTPUT ON;

DECLARE
        -- ����̸��� ������ ��Į�� ���� (1���� ��)
        v_ename emp.ename%TYPE;
BEGIN
        SELECT ename
        INTO v_ename
        FROM emp;
        -- ��ȸ����� �������ε� ��Į�� ������ ���� �����Ϸ��� �Ѵ�. �� ����
        
        -- �߻� ����, �߻� ���ܸ� Ư�� ���� ���� �� �� OTHERS ( java : EXCEPTION )
        EXCEPTION 
                WHEN OTHER THEN
                        dbms_output.put_line('Exception others');
                
END;
/



-- ����� ���� ����
DECLARE
        -- emp ���̺� ��ȸ�� ����� ���� ��� �߻���ų ����� ���� ����
        -- ���ܸ� EXCEPTION;       -- ������ ����Ÿ��
        NO_EMP EXCEPTION;
        v_ename emp.ename%TYPE;
BEGIN
        
        BEGIN

        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 9999;
        
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                        dbms_output.put_line('������ ������');
                        -- ����ڰ� ������ ����� ���� ���ܸ� ����
                        RAISE NO_EMP;
                        -- �ڹٴ� throw, ����Ŭ�� raise
        END;
        
        EXCEPTION
                WHEN NO_EMP THEN
                        dbms_output.put_line('no_emp exception');
END;
/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- function
-- ���ϰ��� ��������� �ݵ�� �־�� ��


-- �̸��� �ִ� ���ε� �� �߿� �Լ��� ��
-- ��� ��ȣ�� ����, �ش� �����ȣ�� �ش��ϴ� ����̸��� �����ϴ� �Լ� (function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
-- Ÿ�Ը� ����ϸ� ��
RETURN VARCHAR2
IS
        -- �����
        ret_ename emp.ename%TYPE;
        -- ����� ���� �� �ִ� ����
BEGIN
        -- ����
        SELECT ename
        INTO ret_ename
        FROM emp
        WHERE empno = p_empno;
        
        RETURN ret_ename;
END;
/


SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;


-- �� PL / SQL ( function �ǽ� function1 ) --------------------------------------------------------------------------------------------------
-- �μ���ȣ�� �Ķ���ͷ� �Է¹ް� �ش� �μ��� �̸��� �����ϴ� �Լ� getDeptName�� �ۼ��غ�����.
CREATE OR REPLACE FUNCTION getDeptName(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2
IS
        ret_dname dept.dname%TYPE;
BEGIN
        SELECT dname
        INTO ret_dname
        FROM dept
        WHERE deptno = p_deptno;
        
        RETURN ret_dname;
END;
/

SELECT getDeptName(10)
FROM dual;

SELECT deptno, dname, getDeptName(deptno)
FROM dept;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- �̷��Ե� ����� ���� �ִµ� ���� ����� �ƴϴ�. �̷� �� ������ �ϴ°� ����.
SELECT empno, ename, deptno,getDeptName(deptno) dname
FROM emp;

-- ��Į�� ���� ���� ��� (�Լ� �ۼ� X)
SELECT empno, ename, deptno,
              (SELECT dname FROM dept WHERE emp.deptno = deptno) dname
FROM emp;

-- ��Į�� ���� ������ �Ʒ�ó�� ¥�� ���� �ʴ�. ���� ó���� �ؾ� ��.
SELECT empno, ename, deptno,
              (SELECT dname FROM dept WHERE emp.deptno = deptno) dname,
              (SELECT loc FROM dept WHERE emp.deptno = deptno) loc
FROM emp;



-- �� PL / SQL ( function �ǽ� function2 ) --------------------------------------------------------------------------------------------------

SELECT deptcd, LEVEL, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, indent(LEVEL, deptnm) deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;


CREATE OR REPLACE FUNCTION indent(p_deptnm dept_h.deptnm%TYPE,
                                                                    p_level number)
RETURN VARCHAR2
IS
        ret_deptnm dept_h.deptnm%TYPE;

BEGIN
        SELECT LPAD(' ', (p_level - 1) * 4, ' ')
        INTO ret_deptnm
        FROM dept_h
        
        RETURN 
END;
/



CREATE OR REPLACE FUNCTION indent(p_level NUMBER, p_deptnm dept_h.deptnm%TYPE)
RETURN VARCHAR2
IS
        ret_text VARCHAR2(50);
BEGIN
        SELECT LPAD(' ', p_level - 1), ' ') || p_dname
        INTO ret_text
        FORM DUAL;
        
        RETURN ret_text;
END;
/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- pakage


dbms_output.put_line;

SELECT *
FROM TABLE(dbms_xplan.display);



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- trigger
-- DDL_EVENT : �ý��� ���̶� ���� ���� �ʴ´�.

DESC users;
CREATE TABLE user_history(
        userid VARCHAR2(20),
        pass VARCHAR2(100),
        mod_dt DATE
);

-- users ���̺��� pass �÷��� ����� ��� users_history�� ������ pass�� �̷����� ����� Ʈ����
CREATE OR REPLACE TRIGGER make_history
        BEFORE UPDATE ON users -- users ���̺��� ������Ʈ ����
        FOR EACH ROW        -- �� ������ ������ ��
        
        BEGIN
                -- :NEW.�÷��� : UPDATE ������ �ۼ��� ��
                -- :OLD.�÷��� : ���� ���̺� ��
                IF :NEW.pass != :OLD.pass THEN -- ������ ���ο� ���� �ٸ� ���� �� ������ �����ϰڴ�.
                        INSERT INTO user_history
                        VALUES (:OLD.userid, :OLD.pass, SYSDATE);
                END IF;
        END;
/

SELECT *
FROM users;

UPDATE users SET pass = 'brownpass'
WHERE userid = 'brown';

-- WHERE ���� ���� �ϸ� 5���� �����Ͱ� history�� ����.
UPDATE users SET pass = 'brownpass';

SELECT *
FROM user_history;

ROLLBACK;




 ibatis(2.X) --> mybatis(3.X)
-- ����

��Ŀ, ����Ʈ������? ��������



