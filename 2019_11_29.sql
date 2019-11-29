
SET SERVEROUTPUT ON;

-- CURSOR�� ��������� �������� �ʰ� LOOP���� inline ���·� CURSOR ���

-- �͸� ���
DECLARE
        -- cursor ���� �� LOOP���� inline ����
BEGIN
        --FOR ���ڵ� IN ����� Ŀ�� LOOP
        -- ���� for�� for (String str : list)
        FOR rec IN (SELECT deptno, dname FROM dept) LOOP
                dbms_output.put_line(rec.deptno || ', ' || rec.dname);
        END LOOP;
END;
/

-- �� PL / SQL ( cursor, �������� �ǽ� PRO_3 ) --------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE avgdt
IS
        -- �����
        prev_dt DATE;
        ind NUMBER := 0;
        diff NUMBER := 0;
BEGIN
        -- dt ���̺� ��� ������ ��ȸ
        FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
                -- rec : dt �÷�
                -- ���� ���� ������(dt) - ���� ������(dt) : 
                IF ind = 0 THEN     -- LOOP�� ù ����
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
-- 1�� ���� 100�� ��ǰ�� �����ϳ� �� ���� �Դ´�.

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



-- ���1 -----------------------------------------------------------------
-- �߰� �������� Ȯ���ϴ� �ܰ�
CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        -- �޷��� �� ������ ������ RECORD TYPE
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
                
        -- �޷� ������ ������ table type
        -- cal_row�� ������ ������ �� �ִ� Ÿ���̴�.
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



-- ���2 -----------------------------------------------------------------
-- �߰� �������� ����
CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        -- �޷��� �� ������ ������ RECORD TYPE
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
                
        -- �޷� ������ ������ table type
        -- cal_row�� ������ ������ �� �ִ� Ÿ���̴�.
        TYPE calendar IS TABLE OF cal_row;
        cal calendar;
        
        -- �����ֱ� cursor
        CURSOR cycle_cursor IS
                SELECT *
                FROM cycle;
        
BEGIN        
        
        SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                      TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                      BULK COLLECT INTO cal
        FROM dual
        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));
        
        -- �����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
        DELETE daily
        WHERE dt LIKE p_yyyymm || '%';
        
        -- �����ֱ� loop
        FOR rec IN cycle_cursor LOOP
                FOR i IN 1..cal.COUNT LOOP
                        -- �����ֱ��� �����̶� ������ �����̶� ���� ��
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






