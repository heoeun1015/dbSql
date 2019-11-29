
SET SERVEROUTPUT ON;

-- CURSOR를 명시적으로 선언하지 않고 LOOP에서 inline 형태로 CURSOR 사용

-- 익명 블록
DECLARE
        -- cursor 선언 → LOOP에서 inline 선언
BEGIN
        --FOR 레코드 IN 선언된 커서 LOOP
        -- 향상된 for문 for (String str : list)
        FOR rec IN (SELECT deptno, dname FROM dept) LOOP
                dbms_output.put_line(rec.deptno || ', ' || rec.dname);
        END LOOP;
END;
/

-- ■ PL / SQL ( cursor, 로직제어 실습 PRO_3 ) --------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE avgdt
IS
        -- 선언부
        prev_dt DATE;
        ind NUMBER := 0;
        diff NUMBER := 0;
BEGIN
        -- dt 테이블 모든 데이터 조회
        FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
                -- rec : dt 컬럼
                -- 먼저 읽은 데이터(dt) - 다음 데이터(dt) : 
                IF ind = 0 THEN     -- LOOP의 첫 시작
                        prev_dt := rec.dt;
                ELSE 
                        diff := diff + prev_dt - rec.dt;
                        prev_dt := rec.dt;
                END IF;
                ind := ind + 1;
        END LOOP;
        dbms_output.put_line('diff : ' || diff / (ind - 1));
END;
/
EXEC avgdt;
-------------------------------------------------------------------------------------------------------------------------------------------------------------



SELECT *
FROM CYCLE;

-- 1 100 2 1
-- 1번 고객은 100번 제품을 월요일날 한 개를 먹는다.

--  CYCLE
-- 1 100 2 1

--  DAILY
--1 100 20191104 1
--1 100 20191111 1
--1 100 20191118 1
--1 100 20191125 1

CREATE TABLE daily (
                cid NUMBER NOT NULL,
                dname NUMBER NOT NULL,
                dit VARCHAR(8) NOT NULL,
                cnt NUMBER NOT NULL
        );

--CREATE OR REPLACE PROCEDURE c_daily(p_day IN VARCHAR2)
--IS
----DECLARE
--        
--BEGIN
--               
--        FOR rec IN (SELECT  TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level - 1), 'd') day
--                            FROM dual a
--                            CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') LOOP
--        
--        IF 
--        
--        UPDATE daily
--        
--        END LOOP;
--END;
--/



-- 방법1 -----------------------------------------------------------------
-- 중간 과정까지 확인하는 단계
CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        -- 달력의 행 정보를 저장할 RECORD TYPE
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
                
        -- 달력 정보를 저장할 table type
        -- cal_row를 여러건 저장할 수 있는 타입이다.
        TYPE calendar IS TABLE OF cal_row;
        cal calendar;
        
BEGIN        
        
        SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                      TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                      BULK COLLECT INTO cal
        FROM dual
        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));
        
        FOR i IN 1..cal.COUNT LOOP
                dbms_output.put_line(cal(i).dt || ', ' || cal(i).d);
        END LOOP;
        
END;
/
EXEC create_daily_sales('201911');
-----------------------------------------------------------------



-- 방법2 -----------------------------------------------------------------
-- 중간 과정까지 이후
CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        -- 달력의 행 정보를 저장할 RECORD TYPE
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
                
        -- 달력 정보를 저장할 table type
        -- cal_row를 여러건 저장할 수 있는 타입이다.
        TYPE calendar IS TABLE OF cal_row;
        cal calendar;
        
        -- 애음주기 cursor
        CURSOR cycle_cursor IS
                SELECT *
                FROM cycle;
        
BEGIN        
        
        SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                      TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                      BULK COLLECT INTO cal
        FROM dual
        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));
        
        -- 생성하려고 하는 년월의 실적 데이터를 삭제한다.
        DELETE daily
        WHERE dt LIKE p_yyyymm || '%';
        
        -- 애음주기 loop
        FOR rec IN cycle_cursor LOOP
                FOR i IN 1..cal.COUNT LOOP
                        -- 애음주기의 요일이랑 일자의 요일이랑 같은 비교
                        IF rec.day = cal(i).d THEN
                                INSERT INTO daily VALUES (rec.cid, rec.pid, cal(i).dt, rec.cnt);
                        END IF;
                END LOOP;
                COMMIT;
        END LOOP;
        
END;
/
EXEC create_daily_sales('201911');
-----------------------------------------------------------------

SELECT *
FROM daily;

SELECT *
FROM cycle;


--SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD')) day
--FROM dual;
--
--SELECT TO_CHAR(TO_DATE('201911', 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
--              TO_CHAR(TO_DATE('201911', 'YYYYMM') + ( LEVEL - 1 ), 'd') d
--FROM dual
--CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));







CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
   
        TYPE calendar IS TABLE OF cal_row;
        cal calendar;
        
        CURSOR cycle_cursor IS
                SELECT *
                FROM cycle;
        
BEGIN        
        
        SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                      TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                      BULK COLLECT INTO cal
        FROM dual
        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));
        
        DELETE daily
        WHERE dt LIKE p_yyyymm || '%';
        
        FOR rec IN cycle_cursor LOOP
                FOR i IN 1..cal.COUNT LOOP
                        IF rec.day = cal(i).d THEN
                                INSERT INTO daily VALUES (rec.cid, rec.pid, cal(i).dt, rec.cnt);
                        END IF;
                END LOOP;
                COMMIT;
        END LOOP;
        
END;
/
EXEC create_daily_sales('201911');


DELETE daily
WHERE dt LIKE '201911%';

INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM  cycle, (SELECT TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                                      TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                        FROM dual
                        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:p_yyyymm, 'YYYYMM')), 'DD'))) cal
WHERE cycle.day = cal.d;






