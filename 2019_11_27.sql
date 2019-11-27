
SELECT *
FROM no_emp;

-- 1. leaf node 찾기
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
-- 할당연산 :=
-- System.out.println(" ") → dbms_output.put_line(" ");
-- LOG4j
-- set erveroutput on;   -- 출력기능 활성화

-- PL / SQL
-- declare : 변수, 상수 선언
-- begin : 로직 실행
-- exception : 예외처리

DESC dept;

SET SERVEROUTPUT ON;

DECLARE 
        -- 변수 선언
        deptno NUMBER(2);
        dname VARCHAR(14);
BEGIN 
        --dbms_output.put_line('test');
        SELECT deptno, dname INTO deptno, dname     -- INTO 데이터가 한 건일 때 사용
        FROM dept
        WHERE deptno = 10;
        
        -- SELECT 절의 결과를 변수에 잘 할당했는지 확인
        dbms_output.put_line('dname: ' || dname || '(' || deptno || ')') ;
END;
/

DECLARE 
        -- 참조 변수 선언(테이블 컬럼타입이 변경돼도 PL / SQL 구문을 수정할 필요가 없다.)
        deptno dept.deptno%TYPE;
        dname dept.dname%TYPE;
BEGIN 
        SELECT deptno, dname INTO deptno, dname     -- INTO 데이터가 한 건일 때 사용
        FROM dept
        WHERE deptno = 10;
        
        -- SELECT 절의 결과를 변수에 잘 할당했는지 확인
        dbms_output.put_line('dname: ' || dname || '(' || deptno || ')') ;
END;
/

-- 10번 부서의 부서이름과 LOC 정보를 화면 출력하는 프로시저
-- 프로시저명 : printdept
-- CREATE OR REPLACE VIEW 

-- 프로시저 객체 만들기
CREATE OR REPLACE PROCEDURE printdept
IS
        -- 변수선언
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

-- EXEC : 프로시저 출력
EXEC printdept;



CREATE OR REPLACE PROCEDURE printdept_p (p_deptno IN dept.deptno%TYPE)
IS     -- 변수선언
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



-- ■ PL / SQL ( procedure 생성 실습 pro_1 ) --------------------------------------------------------------------------------------------------
-- printemp procedure 생성
-- param : empno
-- logic : empno에 해당하는 사원의 정보를 조회하여 사원이름, 부서이름을 화면에 출력
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

-- ■ PL / SQL ( procedure 생성 실습 pro_2 ) --------------------------------------------------------------------------------------------------
-- registdept_test procedure 생성
-- param : deptno, dname, loc
-- logic : 입력받은 부서 정보를 dept_test 테이블에 신규 입력
-- exec registdept_test ('99', 'ddit', 'daejeon');
-- dept_test 테이블에 정상적으로 입력되었는지 확인

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

























