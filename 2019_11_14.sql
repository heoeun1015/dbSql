-- 제약조건 활성화 / 비활성화
-- 어떤 제약조건을 활성화(비활성화) 시킬 대상?

-- _pk 를 마지막에 주거나 중간에 주는 식으로 형식을 지정해주는 것이 좋다.
-- emp fk 제약 (dept 테이블의 deptno 컬럼 참조)
-- FK_EMP_TEST_DEPT 비활성화
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept;

-- 제약조건에 위배되는 데이터가 들어갈 수 있지 않을까?
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', 80);


-- FK_EMP_TEST_DEPT 활성화
-- 그 사이 위배되는 데이터를 넣었으면 활성화되지 않는다.
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept;

DELETE emp_test
WHERE empno = 9999;
COMMIT;

SELECT *
FROM emp;


-- 현재 계정에 존재하는 테이블 목록 view  :   USER_TABLES
-- 현재 계정에 존재하는 제약조건 view    :   USER_CONSTRAINTES
-- 현재 계정에 존재하는 제약조건의 컬럼 view    :   USER_CONS_COLUMNS

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


-- 테이블에 설정된 제약조건 조회 (view 조인)
-- 테이블명 / 제약조건명 / 컬럼명 / 컬럼 포지션
SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P'
ORDER BY a.table_name, b.position;    -- PRIMARY KEY 만 조회


DESC CUSTOMER;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- emp 테이블과 8가지 컬럼 주석 달기
-- EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO

-- 테이블 주석 view  :   USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp 테이블 추석
COMMENT ON TABLE emp IS '사원';

-- emp 테이블의 컬럼 주석
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- 주석은 꼭 잊지 말고 하도록 하자.
COMMENT ON COLUMN emp.empno IS '사원번호';
COMMENT ON COLUMN emp.ename IS '이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '관리자 사번';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '상여';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';



-- ■ DDL (Table - comments  실습 comment1) -----------------------------------------------------------------------------------------------
-- user_tab_comments, user_col_comments view를 이용하여 customer, product, cycle, daily 테이블과 컬럼의 주석정보를
-- 조회하는 쿼리를 작성하라.
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


-- VIEW 생성 (emp 테이블에서 sal, comm 두 개 컬럼은 제외한다.)
-- 회사마다 다르긴 한데 보통은 v로 시작한다. 테이블의 경우 tb.
-- system : GRANT CREATE VIEW TO pc16;
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;


-- INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
             FROM emp );

-- view: 이름이 없는 녀석에게 이름을 붙여줬다.
-- view ( 위 인라인뷰와 동일하다. )
SELECT *
FROM v_emp;


-- 조인된 쿼리 결과를 view 로 생성 : v_emp_dept
-- emp, dept    :   부서명, 사원번호, 사원명, 담당업무, 입사일자
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;


-- VIEW 제거
DROP VIEW v_emp;


-- VIEW를 구성하는 테이블의 데이터를 변경하면 VIEW에도 영향이 간다.
-- dept 30 - SALES
SELECT *
FROM dept;

SELECT *
FROM v_emp_dept;

-- dept 테이블의 SALES → MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;
ROLLBACK;

-- view는 업데이트가 따로 가능하긴 한데 일반적으로 사용하진 않는다.


-- HR 계정에게 v_emp_dept view 조회 권한을 준다.
GRANT SELECT ON v_emp_dept TO hr;

-- hr
-- SELECT *
-- FROM pc16.v_emp_dept;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SEQUENCE 생성 ( 게시글 번호 부여용 시퀀스)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

SELECT seq_post.nextval, seq_post.currval
FROM dual;

-- 방금 시퀀스로 읽은 값이 얼마냐 : currval
SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
        AND title = '하하하'
        AND reg_dt = TO_DATE('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');
        -- WHERE 절을 쓰는 수고가 굉장히 많으므로 가짜주어로 대체해준다.
        
SELECT *
FROM post
WHERE post_id = 1;
-- 시퀀스는 이렇게 가짜 주어로 활용할 수 있다.

-- 게시글의 경우 시퀀스, 첨부파일처럼 참조하는 테이블의 경우에는 currval를 써주면 된다.
-- 게시글
SELECT seq_post.nextval
FROM dual;

-- 게시글 첨부파일
SELECT seq_post.currval
FROM dual;


-- 시퀀스 복습
-- 시퀀스: 중복되지 않는 정수 값을 리턴해주는 객체
-- 1, 2, 3, …

DESC emp_test;
DROP TABLE emp_test;

CREATE TABLE emp_test(
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR2(15)
);

CREATE SEQUENCE seq_emp_test;

--INSERT INTO emp_test VALUES ( 중복되지 않는 값, 'brown');
INSERT INTO emp_test VALUES ( seq_emp_test.nextval, 'brown');

SELECT seq_emp_test.nextval
FROM dual;

SELECT *
FROM emp_test;

ROLLBACK;   -- 해도 시퀀스는 롤백되지 않는다.




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- index ( 색인 )
-- rowid    :   테이블 행의 물리적 주소, 해당 주소를 알면 빠르게 테이블에 접근하는 것이 가능하다.
SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFTnAAFAAAAFNAAA';

-- table    :   pid, pnm
-- pk_product   :   pid
SELECT pid
FROM product
WHERE ROWID = 'AAAFTnAAFAAAAFNAAA';
-- 인덱스가 있으면 굳이 테이블에 접근하지 않아도 된다. 위 쿼리같은 경우를 말함.
-- 한 번 찾으면 더 이상 찾을 필요가 없다. 찾거나 없거나 둘 중 하나.
-- + 원 스킨. 찾고자 하는 데이터에서 하나를 더 읽는다. 같은 인덱스여도 정렬이 되어 있기 때문에 같은 데이터가 나오는 곳까지만 읽으면 된다.

-- access predicate :   조건이 좀 다르다. 전은 인덱스, 후는 인덱스에 대한 조건식
-- SELECT empno FROM emp WHERE job = 'MANAGER' AND ename LIKE 'C%';


-- 실행계획을 통한 데이터 인덱스 사용여부 확인;
-- emp 테이블에 empno 컬럼을 기준으로 인덱스가 없을 때
ALTER TABLE emp DROP CONSTRAINT pk_emp;

-- 인덱스가 있어도 오라클 자체의 판단으로 데이터의 수가 적어 테이블 전체를 읽는게 더 빠를 경우 인덱스를 읽지 않고 바로 테이블을 조회할 수도 있다.
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

-- 인덱스가 없기 때문에 empno = 7369 데이터를 찾기 위헤 emp 테이블을 전체를 찾아봐야 한다. → TABLE FULL SCAN


-- 방금 실행한 SQL 실행계획이 나온다.
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
 
Predicate Information (identified by operation id):     -- id에 의해서 식별이 된다.
------------------------------------------------------------------------------------------------------------------------------
 
   2 - access("EMPNO"=7369)
--=============================================================================

-- ※ SELECT 다음에 오면, 0번 오퍼레이션의 자식이다. 자식이 있으면 자식부터 읽는다. 읽기 순서 ) 1번 → 0번
-- ※ Predicate Information (identified by operation id):     -- id에 의해서 식별이 된다.































