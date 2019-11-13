 -- unique table level constraint
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test(
        deptno NUMBER(2)    PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13),
        
        -- CONSTRAINT  제약조건 명 CONSTRAINT TYPE [ (컬럼....) ]
        CONSTRAINT uk_dpet_test_dname_loc UNIQUE (dname, loc)
        -- 데이터를 입력을 했는데, 그 데이터가 중복인지 아닌지 빠르게 찾기 위해 unique를 사용한다.
 );
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 -- 첫 번째 쿼리에 의해 dname, loc 값이 중복되므로 두 번째 쿼리를 실행되지 못한다.
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 
 
 
 -- FOREIGN KEY (참조 제약)
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test (
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13)  
 );
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- emp_test(empno, ename, deptno)
 DESC emp;
 CREATE TABLE emp_test(
        empno NUMBER (4) PRIMARY KEY,
        ename VARCHAR2(10),
        deptno NUMBER(2) REFERENCES dept_test(deptno)
        -- dept_test에 존재하는 부서 번호만 가능하게끔 생성
 );
 -- dept_test 테이블에 1번 부서번호만 존재하고  fk제약을 dept_table.deptno 컬럼을 참조하도록 생성하였기 때문에
 -- 1번 이외의 부서번호는 emp_test 테이블에 입력될 수 없다.
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- emp_test fk 테스트 insert
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 
 -- 2번 부서는 dept_test 테이블에 존재하지 않는 데이터이기 때문에 fk 제약에 의해 INSERT 가 정상적으로 동작하지 못한다.
 INSERT INTO emp_test VALUES (9999, 'sally', 1);
 
 INSERT INTO emp_test VALUES (9998, 'sally', 1);
 
 SELECT *
 FROM  dept_test;
 
 SELECT *
 FROM  emp_test;
 
 -- 무결성 제약에러 발생시 뭘 해야 할까?
 -- 입력하려고 하는 값이 맞는지 확인. (2번이 맞나? 1번은 아닌지?)
 --     . 부모테이블에 값이 왜 입력되지 않았는지 확인 (dept_test 확인)
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- fk 제약 table level constraint
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(3) PRIMARY KEY,
        ename VARCHAR(10),
        deptno  NUMBER(2),
        CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
        (deptno) REFERENCES dept_test (deptno)
 );
 
 
 -- FK제약을 생성하려면 참조하려는 컬럼에 인덱스가 생성되어 있어야 한다.
 DROP TABLE dept_test;      -- 참조하는 값이 있기 때문에 부모부터 지우면 안 된다.
 
 DROP TABLE emp_test;
 DROP TABLE dept_test;
 
 CREATE TABLE dept_test(
        deptno NUMBER(2), /* PRIMARY KEY → UNIQUE 제약 X → 인덱스 생성 X*/ 
        dname VARCHAR2(14),
        loc VARCHAR2(13)
 );

 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        -- dept_test.dept_no 컬럼에 인덱스가 없기 때문에 정상적으로 fk 제약을 생성할 수 없다.
        deptno NUMBER(2) REFERENCES dept_test (deptno)
 );
 
 
 
 -- 테이블 삭제
 DROP TABLE dept_test;
  
 CREATE TABLE dept_test(
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13)
 );

 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2) REFERENCES dept_test (deptno)
 );
 
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 COMMIT;
 
 DELETE dept_test
 WHERE deptno = 1;
 -- 무결성 제약에 의해서 삭제되지 않는다.
 -- dept_test 테이블의 deptno 값을 참조하는 데이터가 있을 경우엔 삭제가 불가능하다.
 -- 즉, 자식 테이블에서 참조하는 데이터가 없어야 부모 테이블의 데이터를 삭제할 수 있다.
 
 DELETE emp_test WHERE empno = 9999;
 DELETE dept_test WHERE deptno = 1;
 -- 삭제를 하려면 위처럼 해야 함.
 
 
 -- FK 제약 (옵션)
 -- default :  데이터 입력 / 삭제시 순차적으로 처리해줘야 fk 제약을 위배하지 않는다.        -- 로직을 잘 제어해야 한다.
 -- ON DELETE CASCADE   :   부모 데이터 삭제시 참조하는 자식 테이블 같이 삭제
 -- ON DELETE NULL  :   부모 데이터 삭제시 참조하는 자식 테이블 값 NULL 설정
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR(10),
        deptno  NUMBER(2),
        CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
        (deptno) REFERENCES dept_test (deptno) ON DELETE CASCADE
 );
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM emp_test;
 
-- INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 COMMIT;
 
 
 -- FK 제약 default 옵션시에는 부모 테이블의 데이터를 삭제하기 전에 자식 테이블에서 참조하는 데이터가 없어야 정상적으로 삭제가 가능했음.
 -- ON DELETE CASCADE의 경우 부모 테이블 삭제시 참조하는 자식 테이블의 데이터를 같이 삭제한다.
 -- 1. 삭제 쿼리가 정상적으로 실행이 되는지?
 -- 2. 자식 테이블에 데이터가 삭제 되었는지?
 DELETE dept_test
 WHERE deptno = 1;
 
 SELECT *
 FROM emp_test;
 
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
-- FK  제약 ON DELETE SET NULL 
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR(10),
        deptno  NUMBER(2),
        CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
        (deptno) REFERENCES dept_test (deptno) ON DELETE SET NULL
 );
 
 SELECT *
 FROM dept_test;
 
 SELECT *
 FROM emp_test;
 
 INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
 INSERT INTO emp_test VALUES (9999, 'brown', 1);
 COMMIT;
 
 
 -- FK 제약 default 옵션시에는 부모 테이블의 데이터를 삭제하기 전에 자식 테이블에서 참조하는 데이터가 없어야 정상적으로 삭제가 가능했음.
 -- ON DELETE SEL NULL의 경우 부모 테이블 삭제시 참조하는 자식 테이블의 데이터의 참조 컬럼을 NULL로 수정한다.
 -- 1. 삭제 쿼리가 정상적으로 실행이 되는지?
 -- 2. 자식 테이블에 데이터가 NULL로 변경이 되었는지?
 DELETE dept_test
 WHERE deptno = 1;
 
 SELECT *
 FROM emp_test;
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 -- FK 제약 조건
 -- CHECK 제약    :   컬럼의 값을 정해진 범위, 혹은 값만 들어오게끔 제약
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        sal NUMBER CHECK (sal >= 0)
 );
 
 -- sal 컬럼은 CHECK 제약 조건에 의해 0이거나, 0보다 큰 값만 입력이 가능하다.
 INSERT INTO emp_test VALUES (9999, 'brown', 10000);
 INSERT INTO emp_test VALUES (9998, 'sally', -10000);
 
 
  DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        -- emp_gb   :   01 - 정직원, 02 - 인턴
        emp_gb VARCHAR2(2) CHECK ( emp_gb IN ('01', '02'))
--        emp_gb VARCHAR2(2) CONSTRAINT sal_check CHECK ( emp_gb IN ('01', '02'))   --제약조건 이름 설정
 );
 
 INSERT INTO emp_test VALUES (9999, 'brwon', '01');
 -- emp_gb 컬럼 체크제약에 의해 01, 02가 아닌 값은 입력될 수 없다.
 INSERT INTO emp_test VALUES (9998, 'sally', '03');
 
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- SELECT 결과를 이용한 TABLE 생성
 -- CREATE TABLE 테이블명 AS
 -- SELECT 쿼리
 -- → CTAS
 
 
 DROP TABLE emp_test;
 DROP TABLE dept_test;
 
 -- CUSTOMER 테이블을 사용하여 CUSTOMER_TEST 테이블로 생성
 -- CUSTOMER 테이블의 데이터도 같이 복제
 CREATE TABLE customer_test AS
 SELECT *
 FROM customer;
 
 SELECT *
 FROM customer_test;
 
 -- SELECT의 결과면 전부 넣을 수 있다.
 CREATE TABLE test AS
 SELECT SYSDATE dt      -- alias 를 꼭 줘야 함.
 FROM dual;
 
 SELECT *
 FROM test;
 
 DROP TABLE test;
 
 
 -- 데이터는 복제하지 않고 특정 테이블의 컬럼 형식만 가져올 순 없을까?
 -- → SELECT의 결과값이 존재하지 않으면 된다. 조건 절에 결과가 나오지 않는 조건을 따로 추가를 해주면 됨.
 DROP TABLE customer_test;
 CREATE TABLE customer_test AS
 SELECT *
 FROM customer
-- WHERE cid = -99;
-- WHERE 1 != 1;  -- 절대 참일 수 없는 조건
WHERE 1 = 2;    

 
 
 
 -- check 조건도 복사되지 않는다. NOT NULL 만 가능
 CREATE TABLE test (
        c1 VARCHAR(2) CHECK (c1 in ('01', '02'))
 );
 
 CREATE TABLE test2 AS
 SELECT *
 FROM test;
 
 
DROP TABLE test;
DROP TABLE test2;
 
 
 
 
 -- 회사 가면... 이런 형식을 많이 보게 될 것. 테스트 형식의 데이터를 꼭 남겨두도록 하자.
 CREATE TABLE customer_191113 AS
 SELECT *
 FROM customer;
 
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 -- 테이블 변경
 -- 새로운 컬럼 추가
 
 DROP TABLE emp_test;
 CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10)
 );
 
 -- 신규 컬럼 추가
 ALTER TABLE emp_test ADD ( deptno NUMBER(2) );
 DESC emp_test;
 
 
 -- 기존 컬럼 변경
 ALTER TABLE emp_test MODIFY (  ename VARCHAR2(200) );
 DESC emp_test;
 
 
 -- 기존 컬럼 타입 변경(테이블에 데이터가 없는 상황)
 ALTER TABLE emp_test MODIFY (  ename NUMBER );
 DESC emp_test;
 
 
 -- 기존 컬럼 타입 변경. 제한적이다.
 INSERT INTO emp_test VALUES (9999, 1000, 10);
 COMMIT;
 -- 데이터 타입을 변경하기 위해서는 컬럼 값이 비어 있어야 한다.
 ALTER TABLE emp_test MODIFY (  ename VARCHAR2(10) );
 
 
 -- DEFAULT 설정
 DESC emp_test;
 ALTER TABLE emp_test MODIFY (  deptno DEFAULT 10 );
 
 
 -- 컬럼명 변경
 ALTER TABLE emp_test RENAME COLUMN deptno TO dno;
 DESC emp_test;
 
 
 -- 컬럼 제거 (DROP)
 ALTER TABLE emp_test DROP COLUMN dno;
 ALTER TABLE emp_test DROP (dno) ;      -- 이렇게 써도 삭제가 된다.
 DESC emp_test;
 
 
 
 -- 테이블 변경 :  제약 조건 추가
 -- PRIMARY KEY
 ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY ( empno );
 
 -- 제약 조건 삭제
 ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
 
 
 
 
 -- UNIQUE  제약  -   empno
 ALTER TABLE emp_test ADD CONSTRAINT uk_emp_test UNIQUE  (empno);
 
 
 -- UNIQUE 제약 삭제 : uk_emp_test
 ALTER TABLE emp_test DROP CONSTRAINT uk_emp_test;
 
 

-- FOREIGN KEY 추가
DESC dept_test;

-- 실습
-- 1. DEPT 테이블의 DEPTNO 컬럼으로 PRIMARY KEY 제약을 테이블 변경
-- DDL을 통해 생성
ALTER TABLE dept ADD CONSTRAINT uk_dept_test PRIMARY KEY (deptno);


-- 2. EMP 테이블의 EMPNO 컬럼으로 PRIMARY KEY 제약을 테이블 변경
-- DDL을 통해 생성
ALTER TABLE emp ADD CONSTRAINT uk_emp_test PRIMARY KEY (empno);
 
 
-- 3. EMP 테이블의 DEPTNO 컬럼으로 DEPT 테이블의 DEPTNO 컬럼을 참조하는 FK 제약을 테이블 변경 DDL을 통해 생성
 -- emp → dept (deptno) 
 SELECT *
 FROM emp;
 
 ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY ( deptno )
 REFERENCES dept ( deptno );        -- 참조하는 다른 테이블도 같이 들어가야 함.
 
 
 
 -- emp_test → dept.deptno  fk 제약 생성    (ALTER TABLE)
 DROP TABLE emp_test;
 
  CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2)
);
 
 DESC emp_test;
 
 ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno)
 REFERENCES dept ( deptno ); 
-- ALTER TABLE emp_test DROP CONSTRAINT fk_emp_dept;
 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- CHECK 제약 추가 (ename 길이 체크, 길이가 3글자 이상)
 ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK (LENGTH(ename) > 3);
 
 SELECT *
 FROM emp_test;
 
 INSERT INTO emp_test VALUES (9999, 'brown', 10);
 INSERT INTO emp_test VALUES (9999, 'br', 10);
 ROLLBACK;
 
 
 -- CHECK 제약 제거
 ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;
 
 
 
 -- NOT NULL 제약 추가
 -- ALTER TABLE emp_test MODIFY ( ename NOT NULL );
 
 -- NOT NULL 제약 제거 (NULL 허용?)
 -- ALTER TABLE emp_test MODIFY ( ename NULL );
 
 
 
 
 
 
 