-- 복습 where11
-- job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원정보 조회----------------------------------------------------------
-- 이거나 → OR
-- 1981년 6월 1일 이후 → 1981년 6월 1일을 포함해서
SELECT *
FROM emp
WHERE job = 'SALSEMAN'
        OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ROWNUM을  사용하고  *를 사용할 수 있는 방법
-- 1.
SELECT ROWNUM, emp.*
FROM emp a;

-- 2.
SELECT ROWNUM, e.*
FROM emp e;

-- ROWNUM과 정렬 문제
-- ORDER BY절은 SELECT 절 이후에 동작
-- ROWNUM 가상 컬럼이 적용되고 나서 정렬되기 때문에 우리가 원하는대로 첫 번째 데이터부터 순차적인 번호 부여가 되질 않는다.

SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;


-- ORDER BY절을 포함한 인라인 뷰를 구성
SELECT ROWNUM, a. *
FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename) a;
        
-- ROWNUM: 1번부터 읽어야 된다.
-- WHERE 절에 ROWNUM값을 중간만 읽는 건 불가능
-- ※ 안 되는 케이스
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

-- ※ 되는 케이스
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10
SELECT ROWNUM, a. *
FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename) a;

-- 페이징 처리를 위한 꼼수 ROWNUM에 별칭을 부여, 해당 SQL을 INLINE VIEW로 감싸고 별칭을 통해 페이징 처리
SELECT *
FROM(
            SELECT ROWNUM rn, a. *
            FROM
                        (SELECT e.*
                        FROM emp e
                        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;




-- 문자열 대소문자 관련 함수
-- LOWER, UPPER, INITCAP
-- 함수 사용: 괄호 안에 인자를 넣어줄 것
SELECT LOWER('Hello, World'),  UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';         -- 조건에 맞는 양만큼 데이터가 출력


-- FUNCTION은 WHERE절에서도 사용 가능
SELECT *
FROM emp
--WHERE ename = 'smith';      -- 대소문자를 비교하기 때문에 값이 나오지 않는다.
--WHERE ename = UPPER('smith');      -- 함수를 씌워주면 가능
WHERE LOWER(ename) = 'smith';       -- 이것도 가능하다!

-- 개발자 SQL 철거지악
-- 1. 좌변을 가공하지 말아라
-- 좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function Based Index → FBI

-- CONCAT : 문자열 결합 -  두 개의 문자열을 결합하는 함수
-- SELECT CONCAT('HELLO', ', ' ,'WORLD') CONCAT       : 인자가 3개라 오류가 난다.
-- SELECT CONCAT('HELLO',', WORLD') CONCAT
SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CONCAT
FROM DUAL;


SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CONCAT,
                SUBSTR('HELLO, WORLD', 0, 5) substr,
                SUBSTR('HELLO, WORLD', 1, 5) substr,
                SUBSTR('HELLO, WORLD', 0, 4) substr,
                LENGTH('HELLO, WORLD') length,
                INSTR('HELLO, WORLD','O') instr,
                INSTR('HELLO, WORLD', 'O', 6) instr,
                LPAD('HELLO, WORLD', 15, '*') lpad,
               RPAD('HELLO, WORLD', 15, '*') rpad,
               REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace,
               REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
               TRIM('      HELLO, WORLD    ') trim,
               TRIM('H' FROM 'HELLO, WORLD') trim
FROM DUAL;



-- SUBSTR : 문자열의 부분 문자열 (java : String.substring)
SELECT SUBSTR('HELLO, WORLD', 0, 5) substr,
                SUBSTR('HELLO, WORLD', 1, 5) substr,
                SUBSTR('HELLO, WORLD', 0, 4) substr
FROM DUAL;

-- LENGTH : 문자열의 길이
SELECT LENGTH('HELLO, WORLD') length
FROM DUAL;

-- INSTR : 문자열에 특정 문자열이 등장하는 첫 번째 인덱스
SELECT INSTR('HELLO, WORLD','O') instr,
                -- INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
                INSTR('HELLO, WORLD', 'O', 6) instr
FROM DUAL;

-- LPAD : 문자열에 특정 문자열을 삽입
-- LPAD(문자열, 전체 문자열 길이, 문자열이 전체 문자열 길이에 미치지 못할 경우 좌측에 추가할 문자);
SELECT LPAD('HELLO, WORLD', 15, '*') lpad,
-- SELECT LPAD('HELLO, WORLD', 15) lpad               -- 특정 문자열을 지정하지 않으면 공백이 들어간다. 기본 문자가 공백.
               RPAD('HELLO, WORLD', 15, '*') rpad
FROM DUAL;

-- REPLACE(원본 문자열, 원본 문자열에서 변경하고자 하는 대상 문자열, 변경 문자열)
SELECT  REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace,
             REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace   -- 중첩 가능
FROM DUAL;

--TRIM: 좌우 공백 제거
SELECT TRIM('      HELLO, WORLD    ') trim,
            TRIM('H' FROM 'HELLO, WORLD') trim      -- 앞뒤 특정 문자열 제거
FROM dual;

-- ROUND(대상 숫자, 반올림 결과 자리수)
SELECT ROUND (105.54, 1) round,        -- 소수점 둘째 자리에서 반올림
              ROUND (105.55, 1) round,        -- 소수점 둘째 자리에서 반올림
              ROUND (105.55, 0) round,        -- 소수점 첫째 자리에서 반올림
              ROUND (105.54, -1) round        -- 정수 첫째 자리에서 반올림
FROM dual;



-- 인자 없는 ROUND: ROUND(sal/1000) = ROUND(sal/1000, 0) 이랑 똑같다.
SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) qutient, */MOD (sal,1000) reminder        -- 0 ~ 999
FROM emp;


-- TRUNC(대상 숫자, 절삭 결과 자리수)
SELECT TRUNC (105.54, 1) trunc,        -- 소수점 둘째 자리에서 절삭
        TRUNC (105.55, 1) trunc,        -- 소수점 둘째 자리에서 절삭
        TRUNC (105.55, 0) trunc,        -- 소수점 첫째 자리에서 절삭
        TRUNC (105.54, -1) trunc        -- 정수 첫째 자리에서 절삭
FROM dual;


-- SYSDATE: 오라클이 설치된 서버의 현재 날짜 + 시간 정보를 리턴
-- 별도의 인자가 없는 함수
SELECT SYSDATE
FROM dual;

-- TO_CHAR: DATE 타입을 문자열로 변환
-- 날짜를 문자열로 변환시에 포맷을 지정해줘야 함
-- ex) 5 → 5일, 1/24 → 1시간, (1/24/60) * 30 → 30분
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') 날짜,
              TO_CHAR(SYSDATE + (1/24/60) * 30, 'YYYY/MM/DD HH24:MI:SS') 분추가      -- (+30분)
FROM dual;


-- Function (date 실습 fn1 -----------------------------------------------------------------------------------------------------------------------
-- Function (date 실습 fn1)
-- 1. 2019년 12월 31일을 date형으로 표현
-- 2. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
-- 3. 현재 날짜
-- 4. 현재 날짜에서 3일 전 값
-- 출력값: 19/12/31
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
              TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 lastday_before5,
              TO_DATE(SYSDATE,  'YYYY/MM/DD') now,
              -- SYSDATE NOW,
              TO_DATE(SYSDATE - 3,  'YYYY/MM/DD') now_boefore3
              -- SYSDATE-3 now_boefore3
FROM dual;

SELECT LASTDAY, LASTDAY - 5  lastday_before5,
              NOW, NOW-3 now_boefore3
FROM
            (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
                            SYSDATE NOW
            FROM dual);
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- date format
-- 년도: YYYY, YY, RR: 2자리일 때랑 4자리일 때가 다르다.
-- RR: 50보다 클 경우 앞자리는 19, 50보다 작을 경우 앞자리는 20
-- YYYY, RRRR은 동일, 가급적이면 명시적으로 표현
-- D: 요일을 숫자로 표기 ( 일요일-1, 월요일-2, 화요일-3 … 토요일-7
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1, 
              TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2, 
              TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
              TO_CHAR(SYSDATE, 'D') d,    -- 오늘은 월요일 -2
              TO_CHAR(SYSDATE, 'IW') iw,     -- 주차 표기
              TO_CHAR(TO_DATE('20191229', 'YYYYMMDD'), 'IW') this_year
FROM dual;  


-- Function (date 실습 fn2 -----------------------------------------------------------------------------------------------------------------------
-- 오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
-- 1. 년-월-일
-- 2. 년-월-일 시간(24) -분 -초
-- 3. 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
              TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_width_time,
              TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- 날짜의 반올림 (ROUND), 절삭(TRUNC)
-- ROUND(DATE, '포맷')    포맷: YYYY, MM, DD
desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
              TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_yyyy,
              TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,       -- 반올림을 하면 한 달이 넘어간다.
              TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_dd,
              TO_CHAR(ROUND(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm
FROM emp
WHERE ename = 'SMITH';



desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
              TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,
              TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm,       -- 반올림을 하면 한 달이 넘어간다.
              TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_dd,
              TO_CHAR(TRUNC(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm
FROM emp
WHERE ename = 'SMITH';


-- 날짜 연산 함수
-- MONTHS_BETWEEN(DATE, DATE): 두 날짜 사이의 개월수 
-- 19801217 ~  20191104 → 20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
              MONTHS_BETWEEN(SYSDATE, hiredate) month_between,
              MONTHS_BETWEEN(TO_DTAE('20191117','YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename = 'SMITH';


-- ADD_MONTHS(DATE, 개월 수): DATE에 개월 수가 지난 날짜
-- 개월 수가 양수일 경우 미래, 음수일 경우 과거
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
            ADD_MONTHS(hiredate, 467) add_months,
            ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename = 'SMITH';


-- NEXT_DAY(DATE, 요일): DATE 이후 첫 번째 요일의 날짜
SELECT SYSDATE,
              NEXT_DAY(SYSDATE, 7) first_sat,     -- 오늘 날짜 이후 첫 토요일 일자
              NEXT_DAY(SYSDATE, '토요일') first_sat     -- 오늘 날짜 이후 첫 토요일 일자
FROM DUAL;


-- LAST_DAY(DATE): 해당 날짜가 속한 월의 마지막 일자
SELECT SYSDATE, LAST_DAY(SYSDATE) last_day,
              LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LAST_DAY_12
FROM DUAL;


-- DATE + 정수 = (DATE에서 정수만큼 이후의 DATE)
-- D1 + 정수 = D2
-- 양변에서 D2 차감
-- D1 + 정수 - D2 = D2 - D2
-- D1 + 정수 - D2 = 0
-- D1 + 정수 = D2
-- 양변에 D1 차감
-- D1 + 정수 - D1 = D2 - D1
-- 정수 = D2 - 1
-- 결론: 날짜에서 날짜를 빼면 일자가 나온다.
SELECT TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') d,
              TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') d,        -- 해당 월의 마지막 날짜를 알아내는 공식
              -- 201908: 2019년 8월의 일수: 31
--              TO_DATE('201908', 'YYYYMM'),       --1일 디폴트로 들어간다.
              ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') d
FROM DUAL;




