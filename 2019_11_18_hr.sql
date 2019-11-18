SELECT *
FROM user_views;

SELECT *
FROM all_views
WHERE owner = 'PC16';

-- 다른 사용자로부터 권한을 받아서 내가 볼 수 있는 뷰
SELECT *
FROM pc16.V_EMP_DEPT;


-- pc16 계정에서 조회 권한을 받은 V_EMP_DEPT view 를 hr 계정에서 조회하기
-- 위해서는 계정명.view 이름 형식으로 기술을 해야 한다.
-- 매번 계정명을 기술하기 귀찮으므로 시노님을 통해 다른 별칭을 생성

CREATE SYNONYM V_EMP_DEPT FOR pc16.V_EMP_DEPT;

-- pc16.V_EMP_DEPT → V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- SYNONYM 삭제하기
DROP SYNONYM V_EMP_DEPT;

-- hr 계정 비밀번호: java
-- hr 계정 비밀번호 변경: hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc16 IDENTIFIED BY java;  -- 본인 계정이 아니라 에러


------------------------ ( 이 위는 hr 계정 ) ---------------------------------------------


-- dictionary
-- 접두어  :   USER    :   사용자 소유 객체
--                  ALL     : 사용자가 사용 가능한 객체
--                  DBA     : 관리자 관점의 전체 객체 (일반 사용자는 사용 불가)
--                  V$     : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE owner IN ('PC16', 'HR');




-- 오라클에서 동일한  SQL이란?
-- 문자가 하나라도 틀리면 안 됨.
-- 다음 sql들은 같은 결과를 만들어낼지 몰라도 DBMS에서는 서로 다른 SQL로 인식된다.
SELECT /*bind test*/ * FROM emp;
Select /*bind test*/ * FROM emp;
Select /*bind test*/ *  FROM emp;

Select /*bind test*/ *  FROM emp WHERE empno = 7369;
Select /*bind test*/ *  FROM emp WHERE empno = 7499;
Select /*bind test*/ *  FROM emp WHERE empno = 7521;

Select /*bind test*/ *  FROM emp WHERE empno = :empno;
-- 위 세 쿼리를 서로 다른 SQL 로 인식을 한다.

-- system 계정으로 봐야함.
SELECT *
FROM v$SQL
WHERE sql_text LIKE '%bind test%';

-- Select /*bind test*/ *  FROM emp WHERE empno = 7369 식으로 써주는게 오라클 입장에서는 더 정확한 실행계획을 짤 수 있기는 하다.
-- 그래야 index를 탈 수도 있고 테이블을 전부 볼 수도 있는데, 데이터가 많을 경우엔 메모리가 쌓일 수 있다.











