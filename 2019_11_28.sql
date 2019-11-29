
SELECT *
FROM dept_test;

-- ■ PL / SQL ( procedure 생성 실습 pro_3 ) --------------------------------------------------------------------------------------------------
-- UPDATEdept_test procedure 생성
-- param : deptno, dname, loc
-- logic : 입력받은 부서 정보를 dept_test 테이블에 정보 수정
-- exec UPDATEdept_test ('99', 'ddit_m', 'daejeon');
-- dept_test 테이블에 정상적으로 입력되었는지 확인
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



-- ROWTYPE : 테이블의 핸 행의 데이터를 담을 수 있는 참조 타입

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


-- 복합변수 : record
DECLARE
        -- VALUE 객체의 클래스를 만든다고 생각하면 된다.
        -- UserVO userVO;               ← 랑 비슷함
        -- RECORD 후 구성 컬럼 써주기
        TYPE dept_row IS RECORD (   
                deptno NUMBER(2),
                dname dept.dname%TYPE );
                -- 두 개의 값을 저장할 수 있는 타입. 클래스같은 개념.
        v_dname dept.dname%TYPE;
        v_row dept_row;
        -- 위가 v_dname dept.dname%TYPE이랑 같음
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
        -- dept_tab : 클래스명이랑 비슷함
        TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
        
        -- java : 타입 변수명;
        -- pl / sql : 변수명 타입;
        v_dept dept_tab;
        
        bi BINARY_INTEGER;
        
BEGIN
        bi := 100;
        SELECT *
        BULK COLLECT INTO v_dept
        FROM dept;
        
        -- index의 번호는 1번부터 시작한다.
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
-- ELSE IF → ELSIF
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
-- FOR  인덱스 변수 IN 시작값 .. 종료값 LOOP
-- END LOOP;

DECLARE

BEGIN
        FOR i IN 0 .. 5 LOOP
                dbms_output.put_line ('i : ' || i );
        END LOOP;
END;
/



-- 활용
DECLARE
        TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
        v_dept dept_tab;
        bi BINARY_INTEGER;
BEGIN
        bi := 100;
        SELECT *
        BULK COLLECT INTO v_dept
        FROM dept;

        -- v_dept.COUNT :  list.get(i) 와 비슷함.
        FOR i IN 1 .. v_dept.COUNT LOOP
                dbms_output.put_line (v_dept(i).dname);
        END LOOP;

END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- LOOP : 계속 실행 판단 로직을 LOOP 안에서 제어
-- java : while(true)

DECLARE
        i NUMBER;
BEGIN
        i := 0;
        
        LOOP
                dbms_output.put_line ( i );
                i := i + 1;
                -- loop 계속 진행여부 판단
                EXIT WHEN i >= 5;
        END LOOP;
END;
/


-- dt테이블의 해당 날짜들의 간격 합계를  평균을 구하는 문제
-- 출력 예시 ex) 간격 평균 : 5 일
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
        dbms_output.put_line ('간격 평균 : ' || sum_dt);
END;
/


-- 선생님 답안
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
        dbms_output.put_line ('간격평균: ' || (diff_sum / (d_tab.COUNT - 1)));
END;
/




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- lead, lag 현재행의 이전, 이후 데이터를 가져올 수 있다.
SELECT AVG(diff)
FROM (SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) dt_lead, dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
             FROM dt
             ORDER BY dt);

-- 분석함수를 사용하지 못하는 환경에서 사용할 때
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


-- HALL OF HONOR (동규씨 명예의 전당)
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*) - 1) dt_avg
FROM dt;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CURSOR
-- 여러 데이터가 있는데 루프를 돌면서 무언가를 하고 싶을 때
DECLARE
        -- 커서 선언
        CURSOR dept_cursor IS SELECT deptno, dname FROM dept;
        v_deptno dept.deptno%TYPE;
        v_dname dept.dname%TYPE;
BEGIN
        -- 커서 열기
        OPEN dept_cursor;
        LOOP 
                FETCH dept_cursor INTO v_deptno, v_dname;
                dbms_output.put_line (v_deptno || ', ' || v_dname);
                EXIT WHEN dept_cursor%NOTFOUND;     -- 더이상 읽을 데이터가 없을 때 종료
        END LOOP;
END;
/



-- FOR LOOP CURSOR 결합
-- 자바로 치면 향상된 FOR문
DECLARE
        CURSOR dept_cursor IS SELECT deptno, dname FROM dept;       -- 서브쿼리 자체를 커서로 만들었다.
        v_deptno dept.deptno%TYPE;
        v_dname dept.dname%TYPE;
BEGIN
        FOR rec IN dept_cursor LOOP
                dbms_output.put_line(rec.deptno || ', ' || rec.dname);
        END LOOP;
END;
/


-- 파라미터가 있는 명시적 커서
DECLARE
        CURSOR emp_cursor (p_job emp.job%TYPE) IS
                SELECT empno, ename, job FROM emp WHERE job  = p_job;
--        v_empno emp.empno%TYPE;       -- 쓰긴 했는데 필요 없을듯
--        v_ename emp.ename%TYPE;
--        v_job emp.job%TYPE;
BEGIN
        FOR emp IN emp_cursor ('SALESMAN') LOOP
                dbms_output.put_line (emp.empno || ', ' || emp.ename || ', ' || emp.job);
        END LOOP;
END;
/







