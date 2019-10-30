-- SELECT:  조회할 컬럼을 명시
--                 - 전체 컬럼 조회: *
--                 - 일부 컬럼: 해당 컬럼명 나열(, 구분)
-- FROM: 조회할 테이블 명시
-- 쿼리를 여러줄에 나누어서 작성해도 상관없다.
-- 단,  keyword는 붙여서 작성

-- 모든 컬럼을 조회
SELECT * FROM prod;
-- 드래그 후 Crtl + Enter, 세미콜론 앞에서 커서를 갖다놓은 상태로 눌러도 된다.

--SELECT *
--FROM prod;
-- 위와 동일한 결과.

-- 특정 컬럼만 조회
SELECT prod_id, prod_name
FROM prod;


-- ■ 실습 select1 ---------------------------------------------------------------------------
-- [1] lprod 테이블의 모든 컬럼 조회
SELECT * FROM prod;

-- [2] buyer 테이블의 buyer_id, buyer_name 컬럼만 조회
SELECT buyer_id, buyer_name
FROM buyer;

-- [3] cart 테이블에서 모든 컬럼 조회
SELECT * FROM cart;

-- [4] member 테이블의 mem_id, mem_pass, mem_name 컬럼만 조회
SELECT mem_id, mem_pass, mem_name
FROM member;

-- [5] remain 테이블의 remain_year, remain_prod, remain_date 컬럼만 조회
-- 해당 테이블이 없어 조회 불가능
------------------------------------------------------------------------------------------------


-- 연산자 / 날짜연산
-- date type + 정수: 일자를 더한다.
-- 오라클은 날짜에 더하면 날짜를 더하게끔 되어 있다. 결과값 날짜 + 5
-- 이름을 바꿔주려면 reg_dt + 5 reg_dt_after5, 으로 써줄 것

-- null을 포함한 연산의 결과는 항상 null 이다.
SELECT  userid, usernm, reg_dt,
                reg_dt + 5 reg_dt_after5,              -- as 명시 x
                reg_dt - 5 as reg_dt_before5        -- as 명시 o
FROM  users;

--COMMIT;
--UPDATE users SET reg_dt = null
--WHERE userid = 'moon';
--
--DELETE USERS                                                                           -- USERS에서 삭제해라
--WHERE userid not in('brown', 'cony', 'sally', 'james', 'moon');     -- 어떤 데이터를 삭제할 거냐면, 저 다섯개를 포함하고 있지 않은 데이터를 다 지우라는 뜻.

--commit;         -- 트랜잭션을 마무리 짓는 단계. 다른 사용자가 조회했을 때 삭제되지 않은 데이터가 조회될 수도 있다.



-- ■ 실습 select2 -----------------------------------------------------------------------------------------------
-- [1] prod 테이블에서 prod_id, prod_name 컬럼만 조회하고 id, name 으로 수정
SELECT prod_id AS id, prod_name AS name
FROM prod;

-- [2] lprod 테이블에서 lprod_id, lprod_name 컬럼만 조회하고 gu, nm 으로 수정
SELECT  lprod_gu gu, lprod_nm nm
FROM lprod;

-- [3] buyer 테이블에서 buyer_id,buyer_name 컬럼만 조회하고 바이어아이디, 이름으로 수정
SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;
----------------------------------------------------------------------------------------------------------------------


-- 문자열 결합
-- java + → sql ||
-- CONCAT(str, str) 함수
-- users 테이블 userid, usernm
-- 실제 데이터에 영향을 주진 않는다. 출력만 설정해주는 것.
SELECT userid, usernm,
                userid || usernm 문자열결합,
                CONCAT(userid, usernm) CONCAT
FROM users;

-- 문자열 상수 (컬럼에 담긴 데이터가 아니라 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디: ' || userid 문자열결합,
                CONCAT('사용자 아이디: ', userid) CONCAT결합
FROM users;


-- ■ 문자열 결합 실습 sel_con1 -------------------------------------------------------
SELECT 'SELECT * FROM ' || table_name || ';' QUERY
FROM user_tables;               -- 해당 사용자가 가지고 있는 테이블을 표시
-----------------------------------------------------------------------------------------------


--해당 테이블에 대한 간략한 정보를 알려준다.
-- 테이블에 정의된 컬럼을 알고 싶을 때
-- 1. desc
-- 2. select * ....
desc emp;

SELECT *
FROM users;


-- WHERE 절, 조건 연산자
SELECT *
FROM users
WHERE userid = 'brown';


-- ■ usernm 이 샐리인 데이터를 조회하는 쿼리를 작성 ------------------
SELECT *
FROM users
WHERE userid = 'sally';
---------------------------------------------------------------------------------------