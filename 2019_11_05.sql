-- ��� �Ķ���Ͱ� �־��� �� �ش����� �ϼ��� ���ϴ� ����
-- 2019�� �� 30 / 2019 �� 31

SELECT TO_DATE('201911', 'YYYYMM')
FROM DUAL;

-- �� �� ���� �� ���� ���� ���� = �ϼ�
-- ������ ��¥ ���� �� �� DD�� ����

--SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt      -- ���ε� ����
FROM DUAL;


-- �����ȹ�� �ض�.
explain plan for
SELECT *
FROM emp
WHERE empno = '7369';
--WHERE TO_CHAR(empno) = '7369';

-- �����ȹ
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

----------------------------------------------------------------------------------------------
Plan hash value: 3956160932
 
----------------------------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)  | Time       |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |             |         1 |    37 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP     |         1 |    37 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
----------------------------------------------------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369');
----------------------------------------------------------------------------------------------



SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99') sal_fmt
FROM emp;

select *
 from nls_session_parameters;


-- funciton null
-- NVL(col1, null�� ��� ��ü�� ��) ���߿���.
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,        -- null �̸� 0���� �ٲ��
              sal + comm, 
              sal + nvl(comm, 0)
              , nvl(sal + comm, 0)
FROM emp;


-- NVL2(col1, col1�� null�� �ƴ� ��� ǥ���Ǵ� ��, col1 null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;


-- NULLIF(expr1, expr2)
-- expr1 == expr2 ������ null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;


-- COALESCE(expr1, sxpr2, expr3...)  -- �ڹ��� ������ �μ��� �����
-- �Լ� ���� �� null�� �ƴ� ù ��° ����
SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal
FROM emp;


-- �� Function (null �ǽ� fn4) ----------------------------------------------------------------------------------------------------------------------
-- emp ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�. NULL�� ��� 9999�� ǥ��.
-- (NVL, NVL2, COALESCE ���� ��)
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n,
                                                NVL2(mgr, mgr, 9999) mgr_n,
                                                COALESCE(mgr, 9999) mgr_n
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (null �ǽ� fn5) ----------------------------------------------------------------------------------------------------------------------
-- users ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���. reg_dt�� null�� ��� sysdate�� ����.
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- case when
SELECT empno, ename, job, sal,
              case
                        when job = 'SALESMAN'   then sal * 1.05
                        when job = 'MANAGER'   then sal * 1.10
                        when job = 'PRESIDENT'   then sal * 1.20
                        else sal
              end case_sal
FROM emp;


-- decode(col, search1, return1, search2, return2 �� default)
SELECT  empno, ename, job, sal,
                DECODE(job, 'SALESMAN', sal * 1.05,
                                        'MANAGER', sal * 1.10,
                                        'PRESIDENT', sal * 1.20, sal) decode_sal
FROM emp;


-- �� Function (condition �ǽ� cond1) -----------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ�  deptno�� ���� �μ������� �����ؼ� ������ ���� ��ȸ�Ǵ� ������ �ۼ��ϼ���.
-- 10 �� 'ACCOUNTING', 20 �� 'RESEARCH', 30 �� 'SALES', 40 �� 'OPERATIONS', ��Ÿ �ٸ� �� �� 'DDIT'
SELECT empno, ename,
              DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ���ذ� ¦������, Ȧ�������� �˾ƾ� ��.
-- 1. ���� �⵵ ���ϱ� (DATE �� TO_CHAR(DATE, FORMAT))
-- 2. ���� �⵵�� ¦������ ���
--     � ���� 2�� ������ �������� �׻� 2���� �۴�.
--     2�� ���� ��� �������� 0, 1
-- MOD(���, ���� ��)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) this_year
FROM DUAL;

-- emp ���̺��� �Ի����ڰ� Ȧ�������� ¦�������� Ȯ��
SELECT empno, ename, hiredate,
                case
                   when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2)
                       then '�ǰ����� ���'
                       else '�ǰ����� ����'
                   end contact_to_doctor
FROM emp;


-- �� Function (condition �ǽ� cond2) -----------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�.)
SELECT empno, ename, hiredate,
              DECODE(MOD(SUBSTR(hiredate, 0, 2), 2), 1, '�ǰ����� �����', 0, '�ǰ����� ������') contact_to_doctor
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (condition �ǽ� cond3) -----------------------------------------------------------------------------------------------------------
-- users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�.)
SELECT userid, usernm, alias, reg_dt,
                case
                   when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(reg_dt, 'YYYY'), 2)
                       then '�ǰ����� ���'
                       else '�ǰ����� ����'
                   end contact_to_doctor
FROM users;
----------------------------------------------------------------------------------------------------------------------------------------------------------



-- �׷��Լ� (AVG, MAX, MIIN, SUM, COUNT)
-- �׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
-- SUM(comm), COUNT(*), COUNT(mgr)

-- ���� �� ���� ���� �޿��� �޴� ���
-- ���� �� ���� ���� �޿��� �޴� ���
-- ������ �޿� ��� (�Ҽ��� ��°�ڸ� ������ ������ �� �Ҽ��� ��°�ڸ����� �ݿø�)
-- ������ �޿� ��ü ��
-- ������ ����
SELECT MAX (sal) max_sal, MIN(sal) min_sal,
              ROUND(AVG(sal),  2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(*) emp_cnt,      --  ������ �� ��ü, *�� ����Ѵ�.
              COUNT(sal) sal_cnt,
              COUNT(mgr) mgr_cnt,        -- NULL���� ��꿡 ������ ���� �ʴ´�.
              SUM(comm) sum_somm        -- ���� ���� �ִ� �����͸� ��������.
FROM emp;


-- ename�� ������ �� �ȴ�. deptno�� �׷����� �߱� ������ �� �ܿ��� SELECT�� ������ �� �ȴ�. deptno�� �־ �ǰ� ��� ��.
-- �μ��� ���� ���� �޿��� �޴� ����� �޿�
-- GROUP BY ���� ������� �����÷��� SELECT ���� ����� ��� ����
SELECT deptno, MIN(ename), MAX(sal) max_sal     
FROM emp
GROUP BY deptno;
-- �μ���ȣ�� ���������� �ǹ� ���� ���ڿ�/����� �����ϰ�� �ٸ� �̸��� �� �� ����.


SELECT deptno, MAX (sal) max_sal, MIN(sal) min_sal,
              ROUND(AVG(sal),  2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(*) emp_cnt,      --  ������ �� ��ü, *�� ����Ѵ�.
              COUNT(sal) sal_cnt,
              COUNT(mgr) mgr_cnt,        -- NULL���� ��꿡 ������ ���� �ʴ´�.
              SUM(comm) sum_somm        -- ���� ���� �ִ� �����͸� ��������.
FROM emp
GROUP BY deptno;

SELECT empno, ename, sal
FROM emp
ORDER BY sal;


-- �μ��� �ִ� �޿�
SELECT deptno, MAX(sal) mas_sal
FROM emp
--WHERE MAX(sal) >= 3000        -- ����. WHERE 
GROUP BY deptno
having MAX(sal) >= 3000;


-- �� Function (group function �ǽ� grp1) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    -- ������ ���� ���� �޿�
    -- ������ ���� ���� �޿�
    -- ������ �޿� ���(�Ҽ��� 2�ڸ�����)
    -- ������ �޿� ��
    -- ���� �� �޿��� �ִ� ������ �� (NULL ����)
    -- ���� �� ����ڰ� �ִ� ������ �� (NULL ����)
    -- ��ü ������ ��
SELECT MAX(sal) max_sal,
              MIN(sal) min_sal,
              ROUND(AVG(sal), 2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(sal) count_sal,
              COUNT(mgr) count_mgr,
              COUNT(*) count_all
FROM emp;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (group function �ǽ� grp2) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    -- �μ����� ���� �� ���� ���� �޿�
    -- �μ����� ���� �� ���� ���� �޿�
    -- �μ����� ������ �޿� ���(�Ҽ��� 2�ڸ�����)
    -- �μ����� ������ �޿� ��
    -- �μ��� ���� �� �޿��� �ִ� ������ �� (NULL ����)
    -- �μ��� ���� �� ����ڰ� �ִ� ������ �� (NULL ����)
    -- ��ü ������ ��)
SELECT deptno, MAX(sal) max_sal,
              MIN(sal) min_sal,
              ROUND(AVG(sal), 2) avg_sal,
              SUM(sal) sum_sal,
              COUNT(sal) count_sal,
              COUNT(mgr) count_mgr,
              COUNT(*) count_all
FROM emp
GROUP BY deptno;
----------------------------------------------------------------------------------------------------------------------------------------------------------

