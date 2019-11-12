-- 과제 7, 9 풀이

-- commit 을 해주지 않으면 다른 사용자가 사용할 수 없다. 반드시 해줄 것.




SELECT *
FROM dept;

DELETE dept WHERE deptno = 99;
-- 이 구문만 쓰면 위 조건이 확정된 것이 아니다. 트랜잭션을 마무리 지어줘야 함.
COMMIT;

INSERT INTO dept
VALUES (99, 'DDIT', 'daejeon');

ROLLBACK;



-- customer의 경우 고객 번호가 중복될 수 없다.
-- 한 사용자가 추가한 후 commit을 해주지 않으면 다른 사용자가 똑같은 명령을 사용했을 때 트랜잭션이 마무리되기 전에 무한 로딩이 걸림.
INSERT INTO customer
VALUES (99, 'ddit');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INSERT
-- 테이블에 모든 컬럼의 값을 넣을 때는 []를 써주지 않아도 된다.

INSERT INTO dept
VALUES('ddit', 99, 'daejeon');
-- 컬럼의 순서가 같지 않기 때문에 오류가 난다.


DESC emp;

INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);   --VALUES (9999, 'brown', "");
-- 1 행 이(가) 삽입되었습니다.


SELECT *
FROM emp
WHERE empno = 9999;


INSERT INTO emp (ename, job)
VALUES ('brown', null);
-- 필수 값이 없으면 테이블에 삽입되지 않음. (empno) 

ROLLBACK;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP' -- 오라클에서는 객체를 대문자로 관리한다. 찾으려면 문자열 대문자로 찾아야 함
ORDER BY column_id;

1. EMPNO
2. ENAME
3. JOB
4. MGR
5. HIREDATE
6. SAL
7. COMM
8. DEPTNO;
-- 순서에 맞춰서 작성

INSERT INTO emp
VALUES  (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

COMMIT;

SELECT *
FROM emp
WHERE empno = 9999;

--COMMIT;

DELETE emp;
ROLLBACK;       -- 롤백이 커밋하기 전에는 가능하다. 잘 써먹자.

-- SELECT 결과(여러 건)를 INSERT

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
-- UPDATE 테이블 SET 컬럼 = 값, 컬럼 = 값…
-- WHERE condition


desc dept;

-- 쓰는 순서는 상관이 없다. 선생님은 무서워서 where절부터 씀.
UPDATE dept SET dname = '대덕IT', loc='ym'
WHERE deptno = 99;

--UPDATE dept SET dname = '대덕IT', loc='ym';
-- dept 모든 테이블에 대해서 위 조건을 실행하겠다. 실행하면 5개의 행이 바뀌게 됨.


SELECT *
FROM emp;

-- DELETE 테이블 명
-- WHERE condition
-- 사원번호가 9999인 직원을 emp  테이블에서 삭제
DELETE emp
WHERE empno = 9999;

-- 부서테이블을 이용해서 emp 테이블에 입력한 5건(4건)의 데이터를 삭제
-- 10, 20, 30, 40, 99   →   empno < 100, empno BETWEEEN 10 AND 99
DELETE emp
WHERE empno < 100;

--★ 팁. DELETE 를 누르기 전에 SELECT 에 먼저 한 번 써보는 것이 좋다.
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




-- TRUNCATE TABLE :   로그를 남기지 않고 보다 더 빠른 삭제 방법


SELECT *
FROM dept;

-- LV1 → LV3
SET TRANSACTION olation LEVEL SERIALIZABLE;     -- ORACLE 에서는 쉽게 수정 가능하지만, 가능한 사용하지 말 것

-- DML 문장을 통해 트랜잭션 시작
INSERT INTO dept
VALUES (99, 'ddit', 'daejeon');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 해당 테이블 삭제
-- DROP TABLE ranger_new;

-- DDL: AUTO COMMIT,    rollback 이 안 된다.
-- CREATE
CREATE TABLE ranger_new (
    ranger_no NUMBER,       -- 숫자 타입
    ranger_name VARCHAR2(50), -- 문자: [VARCHAR2], CHAR: 남은 수만큼 공백으로 채워지기 때문에 사용하지 않는 것이 좋음.
    reg_dt DATE DEFAULT sysdate     -- DEFAULT  : SYSDATE
);

desc ranger_new;

ROLLBACK;


INSERT INTO ranger_new (ranger_no, ranger_name)     --VALUES (1000, 'brown')만 썼기 때문에 써줘야 함.
VALUES (1000, 'brown');
COMMIT;

SELECT *
FROM ranger_new;



-- 날짜 타입에서 특정 필드 가져오기
-- ex   :   sysdate 에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY') year
FROM dual;

SELECT ranger_no, ranger_name, reg_dt,
            TO_CHAR(reg_dt, 'MM') ch, 
            EXTRACT (YEAR FROM reg_dt) year,
            EXTRACT (MONTH FROM reg_dt) mm,
            EXTRACT (DAY FROM reg_dt) day
FROM ranger_new;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 제약조건
-- DEPT 모방해서 DEPT_TEST 생성
DESC dept_test;
CREATE TABLE dept_test(
        dpetno NUMBER(2) PRIMARY KEY,       -- deptno 컬럼을 식별자로 지정. 식별자로 지정이 되면 값이 중복 될 수 없으며, null일 수도 없다.
        dname VARCHAR2(14),                           
        loc VARCHAR2(13)
);


SELECT *
FROM dept_test;

-- primary key 제약 조건 확인
-- 1. null 이 들어갈 수 없다.
-- 2. deptno 컬럼에 중복된 값이 들어갈 수 없다.
INSERT INTO dept_test   (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test  VALUES   (1, 'ddit', 'daejeon');
INSERT INTO dept_test  VALUES   (1, 'ddit2', 'daejeon');

ROLLBACK;


-- 사용자 지정 제약 조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,       -- 제약조건에 대한 이름
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
        -- deptno 가 동일하더라도 dname이 다르면 다른 값으로 인식을 한다.
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');       -- primary 키를 위처럼 줘서 둘 다 들어간다.

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
-- 유일한 값이어야 되는데 같은 값이 들어간다. 오류가 남.

INSERT INTO dept_test VALUES(2, 'ddit2', 'daejeon');






