
-- 익명 블록
SET SERVEROUTPUT ON;

DECLARE
        -- 사원이름을 저장할 스칼라 변수 (1개의 값)
        v_ename emp.ename%TYPE;
BEGIN
        SELECT ename
        INTO v_ename
        FROM emp;
        -- 조회결과는 여러개인데 스칼라 변수에 값을 저장하려고 한다. → 에러
        
        -- 발생 예외, 발생 예외를 특정 짓기 힘들 때 → OTHERS ( java : EXCEPTION )
        EXCEPTION 
                WHEN OTHER THEN
                        dbms_output.put_line('Exception others');
                
END;
/



-- 사용자 정의 예외
DECLARE
        -- emp 테이블 조회시 결과가 없을 경우 발생시킬 사용자 정의 예외
        -- 예외명 EXCEPTION;       -- 변수명 변수타입
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
                        dbms_output.put_line('데이터 미존재');
                        -- 사용자가 생성한 사용자 정의 예외를 생성
                        RAISE NO_EMP;
                        -- 자바는 throw, 오라클은 raise
        END;
        
        EXCEPTION
                WHEN NO_EMP THEN
                        dbms_output.put_line('no_emp exception');
END;
/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- function
-- 리턴값이 명시적으로 반드시 있어야 함


-- 이름이 있는 블럭인데 그 중에 함수인 것
-- 사원 번호를 인자, 해당 사원번호에 해당하는 사원이름을 리턴하는 함수 (function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
-- 타입만 명시하면 됨
RETURN VARCHAR2
IS
        -- 선언부
        ret_ename emp.ename%TYPE;
        -- 결과를 담을 수 있는 변수
BEGIN
        -- 로직
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


-- ■ PL / SQL ( function 실습 function1 ) --------------------------------------------------------------------------------------------------
-- 부서번호를 파라미터로 입력받고 해당 부서의 이름을 리턴하는 함수 getDeptName을 작성해보세요.
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

-- 이렇게도 사용할 수는 있는데 좋은 방법은 아니다. 이럴 땐 조인을 하는게 맞음.
SELECT empno, ename, deptno,getDeptName(deptno) dname
FROM emp;

-- 스칼라 서브 쿼리 방법 (함수 작성 X)
SELECT empno, ename, deptno,
              (SELECT dname FROM dept WHERE emp.deptno = deptno) dname
FROM emp;

-- 스칼라 서브 쿼리를 아래처럼 짜면 좋지 않다. 조인 처리를 해야 함.
SELECT empno, ename, deptno,
              (SELECT dname FROM dept WHERE emp.deptno = deptno) dname,
              (SELECT loc FROM dept WHERE emp.deptno = deptno) loc
FROM emp;



-- ■ PL / SQL ( function 실습 function2 ) --------------------------------------------------------------------------------------------------

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
-- DDL_EVENT : 시스템 적이라 거의 쓰지 않는다.

DESC users;
CREATE TABLE user_history(
        userid VARCHAR2(20),
        pass VARCHAR2(100),
        mod_dt DATE
);

-- users 테이블의 pass 컬럼이 변경될 경우 users_history에 변경전 pass를 이력으로 남기는 트리거
CREATE OR REPLACE TRIGGER make_history
        BEFORE UPDATE ON users -- users 테이블을 업데이트 전에
        FOR EACH ROW        -- 행 단위로 적용할 것
        
        BEGIN
                -- :NEW.컬럼명 : UPDATE 쿼리시 작성한 값
                -- :OLD.컬럼명 : 현재 테이블 값
                IF :NEW.pass != :OLD.pass THEN -- 기존과 새로운 값이 다를 때만 이 구문을 실행하겠다.
                        INSERT INTO user_history
                        VALUES (:OLD.userid, :OLD.pass, SYSDATE);
                END IF;
        END;
/

SELECT *
FROM users;

UPDATE users SET pass = 'brownpass'
WHERE userid = 'brown';

-- WHERE 절을 빼고 하면 5건의 데이터가 history로 들어간다.
UPDATE users SET pass = 'brownpass';

SELECT *
FROM user_history;

ROLLBACK;




 ibatis(2.X) --> mybatis(3.X)
-- 설계

바커, 아이트리프리? 프로토콜



