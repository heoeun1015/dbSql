-- ���� where11
-- job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ �������� ��ȸ----------------------------------------------------------
-- �̰ų� �� OR
-- 1981�� 6�� 1�� ���� �� 1981�� 6�� 1���� �����ؼ�
SELECT *
FROM emp
WHERE job = 'SALSEMAN'
        OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ROWNUM��  ����ϰ�  *�� ����� �� �ִ� ���
-- 1.
SELECT ROWNUM, emp.*
FROM emp a;

-- 2.
SELECT ROWNUM, e.*
FROM emp e;

-- ROWNUM�� ���� ����
-- ORDER BY���� SELECT �� ���Ŀ� ����
-- ROWNUM ���� �÷��� ����ǰ� ���� ���ĵǱ� ������ �츮�� ���ϴ´�� ù ��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.

SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;


-- ORDER BY���� ������ �ζ��� �並 ����
SELECT ROWNUM, a. *
FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename) a;
        
-- ROWNUM: 1������ �о�� �ȴ�.
-- WHERE ���� ROWNUM���� �߰��� �д� �� �Ұ���
-- �� �� �Ǵ� ���̽�
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

-- �� �Ǵ� ���̽�
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10
SELECT ROWNUM, a. *
FROM
            (SELECT e.*
            FROM emp e
            ORDER BY ename) a;

-- ����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW�� ���ΰ� ��Ī�� ���� ����¡ ó��
SELECT *
FROM(
            SELECT ROWNUM rn, a. *
            FROM
                        (SELECT e.*
                        FROM emp e
                        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;




-- ���ڿ� ��ҹ��� ���� �Լ�
-- LOWER, UPPER, INITCAP
-- �Լ� ���: ��ȣ �ȿ� ���ڸ� �־��� ��
SELECT LOWER('Hello, World'),  UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';         -- ���ǿ� �´� �縸ŭ �����Ͱ� ���


-- FUNCTION�� WHERE�������� ��� ����
SELECT *
FROM emp
--WHERE ename = 'smith';      -- ��ҹ��ڸ� ���ϱ� ������ ���� ������ �ʴ´�.
--WHERE ename = UPPER('smith');      -- �Լ��� �����ָ� ����
WHERE LOWER(ename) = 'smith';       -- �̰͵� �����ϴ�!

-- ������ SQL ö������
-- 1. �º��� �������� ���ƶ�
-- �º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
-- Function Based Index �� FBI

-- CONCAT : ���ڿ� ���� -  �� ���� ���ڿ��� �����ϴ� �Լ�
-- SELECT CONCAT('HELLO', ', ' ,'WORLD') CONCAT       : ���ڰ� 3���� ������ ����.
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



-- SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
SELECT SUBSTR('HELLO, WORLD', 0, 5) substr,
                SUBSTR('HELLO, WORLD', 1, 5) substr,
                SUBSTR('HELLO, WORLD', 0, 4) substr
FROM DUAL;

-- LENGTH : ���ڿ��� ����
SELECT LENGTH('HELLO, WORLD') length
FROM DUAL;

-- INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù ��° �ε���
SELECT INSTR('HELLO, WORLD','O') instr,
                -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
                INSTR('HELLO, WORLD', 'O', 6) instr
FROM DUAL;

-- LPAD : ���ڿ��� Ư�� ���ڿ��� ����
-- LPAD(���ڿ�, ��ü ���ڿ� ����, ���ڿ��� ��ü ���ڿ� ���̿� ��ġ�� ���� ��� ������ �߰��� ����);
SELECT LPAD('HELLO, WORLD', 15, '*') lpad,
-- SELECT LPAD('HELLO, WORLD', 15) lpad               -- Ư�� ���ڿ��� �������� ������ ������ ����. �⺻ ���ڰ� ����.
               RPAD('HELLO, WORLD', 15, '*') rpad
FROM DUAL;

-- REPLACE(���� ���ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���� ���ڿ�)
SELECT  REPLACE('HELLO, WORLD', 'HELLO', 'hello') replace,
             REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace   -- ��ø ����
FROM DUAL;

--TRIM: �¿� ���� ����
SELECT TRIM('      HELLO, WORLD    ') trim,
            TRIM('H' FROM 'HELLO, WORLD') trim      -- �յ� Ư�� ���ڿ� ����
FROM dual;

-- ROUND(��� ����, �ݿø� ��� �ڸ���)
SELECT ROUND (105.54, 1) round,        -- �Ҽ��� ��° �ڸ����� �ݿø�
              ROUND (105.55, 1) round,        -- �Ҽ��� ��° �ڸ����� �ݿø�
              ROUND (105.55, 0) round,        -- �Ҽ��� ù° �ڸ����� �ݿø�
              ROUND (105.54, -1) round        -- ���� ù° �ڸ����� �ݿø�
FROM dual;



-- ���� ���� ROUND: ROUND(sal/1000) = ROUND(sal/1000, 0) �̶� �Ȱ���.
SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) qutient, */MOD (sal,1000) reminder        -- 0 ~ 999
FROM emp;


-- TRUNC(��� ����, ���� ��� �ڸ���)
SELECT TRUNC (105.54, 1) trunc,        -- �Ҽ��� ��° �ڸ����� ����
        TRUNC (105.55, 1) trunc,        -- �Ҽ��� ��° �ڸ����� ����
        TRUNC (105.55, 0) trunc,        -- �Ҽ��� ù° �ڸ����� ����
        TRUNC (105.54, -1) trunc        -- ���� ù° �ڸ����� ����
FROM dual;


-- SYSDATE: ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð� ������ ����
-- ������ ���ڰ� ���� �Լ�
SELECT SYSDATE
FROM dual;

-- TO_CHAR: DATE Ÿ���� ���ڿ��� ��ȯ
-- ��¥�� ���ڿ��� ��ȯ�ÿ� ������ ��������� ��
-- ex) 5 �� 5��, 1/24 �� 1�ð�, (1/24/60) * 30 �� 30��
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') ��¥,
              TO_CHAR(SYSDATE + (1/24/60) * 30, 'YYYY/MM/DD HH24:MI:SS') ���߰�      -- (+30��)
FROM dual;


-- Function (date �ǽ� fn1 -----------------------------------------------------------------------------------------------------------------------
-- Function (date �ǽ� fn1)
-- 1. 2019�� 12�� 31���� date������ ǥ��
-- 2. 2019�� 12�� 31���� date������ ǥ���ϰ� 5�� ���� ��¥
-- 3. ���� ��¥
-- 4. ���� ��¥���� 3�� �� ��
-- ��°�: 19/12/31
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
-- �⵵: YYYY, YY, RR: 2�ڸ��� ���� 4�ڸ��� ���� �ٸ���.
-- RR: 50���� Ŭ ��� ���ڸ��� 19, 50���� ���� ��� ���ڸ��� 20
-- YYYY, RRRR�� ����, �������̸� ��������� ǥ��
-- D: ������ ���ڷ� ǥ�� ( �Ͽ���-1, ������-2, ȭ����-3 �� �����-7
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1, 
              TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2, 
              TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
              TO_CHAR(SYSDATE, 'D') d,    -- ������ ������ -2
              TO_CHAR(SYSDATE, 'IW') iw,     -- ���� ǥ��
              TO_CHAR(TO_DATE('20191229', 'YYYYMMDD'), 'IW') this_year
FROM dual;  


-- Function (date �ǽ� fn2 -----------------------------------------------------------------------------------------------------------------------
-- ���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
-- 1. ��-��-��
-- 2. ��-��-�� �ð�(24) -�� -��
-- 3. ��-��-��
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
              TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_width_time,
              TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;
---------------------------------------------------------------------------------------------------------------------------------------------------------


-- ��¥�� �ݿø� (ROUND), ����(TRUNC)
-- ROUND(DATE, '����')    ����: YYYY, MM, DD
desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
              TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_yyyy,
              TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,       -- �ݿø��� �ϸ� �� ���� �Ѿ��.
              TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_dd,
              TO_CHAR(ROUND(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm
FROM emp
WHERE ename = 'SMITH';



desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
              TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,
              TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm,       -- �ݿø��� �ϸ� �� ���� �Ѿ��.
              TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_dd,
              TO_CHAR(TRUNC(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm
FROM emp
WHERE ename = 'SMITH';


-- ��¥ ���� �Լ�
-- MONTHS_BETWEEN(DATE, DATE): �� ��¥ ������ ������ 
-- 19801217 ~  20191104 �� 20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
              MONTHS_BETWEEN(SYSDATE, hiredate) month_between,
              MONTHS_BETWEEN(TO_DTAE('20191117','YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename = 'SMITH';


-- ADD_MONTHS(DATE, ���� ��): DATE�� ���� ���� ���� ��¥
-- ���� ���� ����� ��� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
            ADD_MONTHS(hiredate, 467) add_months,
            ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename = 'SMITH';


-- NEXT_DAY(DATE, ����): DATE ���� ù ��° ������ ��¥
SELECT SYSDATE,
              NEXT_DAY(SYSDATE, 7) first_sat,     -- ���� ��¥ ���� ù ����� ����
              NEXT_DAY(SYSDATE, '�����') first_sat     -- ���� ��¥ ���� ù ����� ����
FROM DUAL;


-- LAST_DAY(DATE): �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) last_day,
              LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LAST_DAY_12
FROM DUAL;


-- DATE + ���� = (DATE���� ������ŭ ������ DATE)
-- D1 + ���� = D2
-- �纯���� D2 ����
-- D1 + ���� - D2 = D2 - D2
-- D1 + ���� - D2 = 0
-- D1 + ���� = D2
-- �纯�� D1 ����
-- D1 + ���� - D1 = D2 - D1
-- ���� = D2 - 1
-- ���: ��¥���� ��¥�� ���� ���ڰ� ���´�.
SELECT TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') d,
              TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') d,        -- �ش� ���� ������ ��¥�� �˾Ƴ��� ����
              -- 201908: 2019�� 8���� �ϼ�: 31
--              TO_DATE('201908', 'YYYYMM'),       --1�� ����Ʈ�� ����.
              ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') d
FROM DUAL;




