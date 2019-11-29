
SELECT *
FROM dept_test;

-- �� PL / SQL ( procedure ���� �ǽ� pro_3 ) --------------------------------------------------------------------------------------------------
-- UPDATEdept_test procedure ����
-- param : deptno, dname, loc
-- logic : �Է¹��� �μ� ������ dept_test ���̺� ���� ����
-- exec UPDATEdept_test ('99', 'ddit_m', 'daejeon');
-- dept_test ���̺� ���������� �ԷµǾ����� Ȯ��
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE,
                                                                                            p_dname IN dept_test.dname%TYPE,
                                                                                            p_loc IN dept_test.loc%TYPE)
IS
BEGIN
        UPDATE dept_test SET dname = p_dname, loc = p_loc WHERE deptno = p_deptno;
END;
/

EXEC UPDATEdept_test('99', 'ddit_m', 'daejeon2');
-----------------------------------------------------------------------------------------------------------------------------------------------------------



-- ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��

SET SERVEROUTPUT ON;

DECLARE
        dept_row dept%ROWTYPE;
        
BEGIN
        SELECT *
        INTO dept_row
        FROM dept
        WHERE deptno = 10;
        
        dbms_output.put_line (dept_row.deptno || ', ' || dept_row.dname || ', ' || dept_row.loc );
END;
/


-- ���պ��� : record
DECLARE
        -- VALUE ��ü�� Ŭ������ ����ٰ� �����ϸ� �ȴ�.
        -- UserVO userVO;               �� �� �����
        -- RECORD �� ���� �÷� ���ֱ�
        TYPE dept_row IS RECORD (   
                deptno NUMBER(2),
                dname dept.dname%TYPE );
                -- �� ���� ���� ������ �� �ִ� Ÿ��. Ŭ�������� ����.
        v_dname dept.dname%TYPE;
        v_row dept_row;
        -- ���� v_dname dept.dname%TYPE�̶� ����
BEGIN
        SELECT deptno, dname
        INTO v_row
        FROM dept
        WHERE deptno = 10;
        
        dbms_output.put_line( v_row.deptno || ', ' || v_row.dname);
END;
/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- tabletype
DECLARE
        -- dept_tab : Ŭ�������̶� �����
        TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
        
        -- java : Ÿ�� ������;
        -- pl / sql : ������ Ÿ��;
        v_dept dept_tab;
        
        bi BINARY_INTEGER;
        
BEGIN
        bi := 100;
        SELECT *
        BULK COLLECT INTO v_dept
        FROM dept;
        
        -- index�� ��ȣ�� 1������ �����Ѵ�.
--        dbms_output.put_line (v_dept(0).dname);
        dbms_output.put_line (v_dept(1).dname);
        dbms_output.put_line (v_dept(2).dname);
        dbms_output.put_line (v_dept(3).dname);
        dbms_output.put_line (v_dept(4).dname);
        
        dbms_output.put_line (bi);
        
END;
/

SELECT *
FROM dept;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- IF
-- ELSE IF �� ELSIF
-- END IF;

DECLARE
        ind BINARY_INTEGER;
BEGIN
        ind := 2;
        
        IF ind = 1 THEN 
            dbms_output.put_line(ind);
        ELSIF ind = 2 THEN 
            dbms_output.put_line('ELSIF: ' || ind);
        ELSE
            dbms_output.put_line('ELSE');
        END IF;
END;
/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FOR LOOF : 
-- FOR  �ε��� ���� IN ���۰� .. ���ᰪ LOOP
-- END LOOP;

DECLARE

BEGIN
        FOR i IN 0 .. 5 LOOP
                dbms_output.put_line ('i : ' || i );
        END LOOP;
END;
/



-- Ȱ��
DECLARE
        TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
        v_dept dept_tab;
        bi BINARY_INTEGER;
BEGIN
        bi := 100;
        SELECT *
        BULK COLLECT INTO v_dept
        FROM dept;

        -- v_dept.COUNT :  list.get(i) �� �����.
        FOR i IN 1 .. v_dept.COUNT LOOP
                dbms_output.put_line (v_dept(i).dname);
        END LOOP;

END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- LOOP : ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
-- java : while(true)

DECLARE
        i NUMBER;
BEGIN
        i := 0;
        
        LOOP
                dbms_output.put_line ( i );
                i := i + 1;
                -- loop ��� ���࿩�� �Ǵ�
                EXIT WHEN i >= 5;
        END LOOP;
END;
/


-- dt���̺��� �ش� ��¥���� ���� �հ踦  ����� ���ϴ� ����
-- ��� ���� ex) ���� ��� : 5 ��
SELECT *
FROM dt;

DECLARE
        TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
        v_dt dt_tab;
        ind NUMBER;
        sum_dt NUMBER;
        i NUMBER;
        
BEGIN
        SELECT *
        BULK COLLECT INTO v_dt
        FROM dt
        ORDER BY dt DESC;

        i := v_dt.COUNT;
        sum_dt := 0;
        
        LOOP
               
                ind := v_dt(i - 1).dt - v_dt(i).dt;
--                    dbms_output.put_line (v_dt(i-1).dt);
--                    dbms_output.put_line (v_dt(i).dt);
                sum_dt := sum_dt + ind;
--                    dbms_output.put_line (sum_dt);
                i := i - 1;
                
                EXIT WHEN i <= 1;
        END LOOP;
        sum_dt := sum_dt / (v_dt.COUNT - 1);
        dbms_output.put_line ('���� ��� : ' || sum_dt);
END;
/


-- ������ ���
DECLARE
        TYPE d_row IS RECORD(
                    dt DATE);
        TYPE d_table IS NULL OF d_row INDEX BY BINARY_INTEGER;
        d_tab d_table;
        diff_sum NUMBER;
                    
BEGIN
        SELECT *
        BULK COLLECT INTO d_tab
        FROM dt
        ORDER BY dt;
        
        FOR i IN 1..d_tab.COUNT LOOP
                IF i != 1 THEN
                        dbms_output.put_line ( (d_tab(i).dt - d_tab(i - 1).dt));
                        diff_sum := diff_sum + (d_tab(i).dt  - d_tab(i - 1).dt);
                END IF;
        END LOOP;

        dbms_output.put_line ('diff_sum: ' || diff_sum);
        dbms_output.put_line ('�������: ' || (diff_sum / (d_tab.COUNT - 1)));
END;
/




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- lead, lag �������� ����, ���� �����͸� ������ �� �ִ�.
SELECT AVG(diff)
FROM (SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) dt_lead, dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
             FROM dt
             ORDER BY dt);

-- �м��Լ��� ������� ���ϴ� ȯ�濡�� ����� ��
SELECT AVG(a.dt - b.dt) dt_avg
FROM (SELECT ROWNUM rn, dt
            FROM  (SELECT dt
                         FROM dt
                         ORDER BY dt DESC)) a,
            (SELECT ROWNUM rn, dt
            FROM  (SELECT dt
                         FROM dt
                         ORDER BY dt DESC)) b
WHERE a.rn = b.rn(+) - 1;


-- HALL OF HONOR (���Ծ� ���� ����)
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*) - 1) dt_avg
FROM dt;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CURSOR
-- ���� �����Ͱ� �ִµ� ������ ���鼭 ���𰡸� �ϰ� ���� ��
DECLARE
        -- Ŀ�� ����
        CURSOR dept_cursor IS SELECT deptno, dname FROM dept;
        v_deptno dept.deptno%TYPE;
        v_dname dept.dname%TYPE;
BEGIN
        -- Ŀ�� ����
        OPEN dept_cursor;
        LOOP 
                FETCH dept_cursor INTO v_deptno, v_dname;
                dbms_output.put_line (v_deptno || ', ' || v_dname);
                EXIT WHEN dept_cursor%NOTFOUND;     -- ���̻� ���� �����Ͱ� ���� �� ����
        END LOOP;
END;
/



-- FOR LOOP CURSOR ����
-- �ڹٷ� ġ�� ���� FOR��
DECLARE
        CURSOR dept_cursor IS SELECT deptno, dname FROM dept;       -- �������� ��ü�� Ŀ���� �������.
        v_deptno dept.deptno%TYPE;
        v_dname dept.dname%TYPE;
BEGIN
        FOR rec IN dept_cursor LOOP
                dbms_output.put_line(rec.deptno || ', ' || rec.dname);
        END LOOP;
END;
/


-- �Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
        CURSOR emp_cursor (p_job emp.job%TYPE) IS
                SELECT empno, ename, job FROM emp WHERE job  = p_job;
--        v_empno emp.empno%TYPE;       -- ���� �ߴµ� �ʿ� ������
--        v_ename emp.ename%TYPE;
--        v_job emp.job%TYPE;
BEGIN
        FOR emp IN emp_cursor ('SALESMAN') LOOP
                dbms_output.put_line (emp.empno || ', ' || emp.ename || ', ' || emp.job);
        END LOOP;
END;
/







