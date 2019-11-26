
-- WINDOW �Լ�
-- RANK �Լ� : ���� ���ϱ�. ���� ���� ���ؼ��� ���� ������ �ο��Ѵ�.
-- DENSE_RANK : ���� ���ϱ�. ���� ���� ���ؼ��� ���� ������ �ο��Ѵ�.
-- ROW_NUMBER : ���� ����. ���� ���̶� ������ ������ �ο� (�ߺ��� ����.)
SELECT ename, sal, deptno,
              RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
              DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
              ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

-- �� �м��Լ� / window �Լ� (�ǽ� ana1) -------------------------------------------------------------------------------------------------------
-- ����� ��ü �޿� ������ rank, dense_rank, row_number�� �̿��Ͽ� ���ϼ���.
-- ��, �޿��� ������ ��� ����� ���� ����� ���� ������ �ǵ��� �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
              RANK() OVER (ORDER BY sal DESC, empno) rank,
              DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
              ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown     -- ��ø�� ���� �ʱ� ������ �� �Լ��� ���� �����ϴ�.
FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �м��Լ� / window �Լ� (�ǽ� no_ana2) ---------------------------------------------------------------------------------------------------
-- ������ ��� ������ Ȱ���Ͽ�, ��� ����� ���� �����ȣ, ����̸�, �ش� ����� ���� �μ��� ��� ���� ��ȸ�ϴ� ������
-- �ۼ��Ͻÿ�. ( �� �Ʒ����� �м��Լ��� ����Ͽ� �ۼ��Ͻÿ�. )
SELECT *
FROM emp;

SELECT empno, ename, emp.deptno, a.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
                     FROM emp
                     GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY emp.deptno;

-- 
SELECT ename, empno, deptno,
             COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------


-- �м��Լ��� ���� �μ��� ������ (COUNT)
SELECT ename, empno, deptno,
             COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- �μ��� ����� �޿� �հ�
-- SUM �м��Լ�
SELECT ename, empno, deptno, sal,
             SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;


-- �� �м��Լ� / window �Լ� (�ǽ� ana2) ---------------------------------------------------------------------------------------------------
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�, �μ���ȣ�� �ش� ����� ���� �μ���
-- �޿� ����� ��ȸ�ϴ� ������ �ۼ��ϼ���. (�޿� ����� �Ҽ��� ��° �ڸ����� ���Ѵ�.)
SELECT *
FROM emp;

SELECT empno, ename, sal, deptno,
              ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �м��Լ� / window �Լ� (�ǽ� ana3) ---------------------------------------------------------------------------------------------------
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�, �μ���ȣ�� �ش� ����� ���� �μ���
-- ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
              MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �м��Լ� / window �Լ� (�ǽ� ana4) ---------------------------------------------------------------------------------------------------
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, ���α޿�, �μ���ȣ�� �ش� ����� ���� �μ���
-- ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
              MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------


-- FIRST_VALUE, LAST_VALUE : ������ ����.
-- �μ��� �����ȣ�� ���� ���� ���
-- �μ��� �����ȣ�� ���� ���� ���
SELECT *
FROM emp
WHERE deptno = 20;

-- �ڱ� �ڽ��� ����?
-- ��Ȯ�� �ʿ�
SELECT empno, ename, deptno,
              FIRST_VALUE (empno) OVER (PARTITION BY deptno) f_emp,
              LAST_VALUE (empno) OVER (PARTITION BY deptno) l_emp
FROM emp;


-- LAG (���� ��)
-- ���� ��
-- LEAD (���� ��)
-- �޿��� ���� ������ �������� �� �ڱ⺸�� �� �ܰ� �޿��� ���� ����� �޿�, ���� ����� �޿�

SELECT empno, ename, sal,
              LAG(sal) OVER (ORDER BY sal) lag_sal,
              LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;


-- �� �м��Լ� / window �Լ� (�ǽ� ana5) ---------------------------------------------------------------------------------------------------
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����, �޿�, ��ü ����� �޿� ������ 1�ܰ�
-- ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���. (�޿��� ���� ��� �Ի����� ���� ����� ���� ����)
SELECT empno, ename, hiredate, sal,
              LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
--              LAG(sal) OVER (ORDER BY sal, hiredate) lead_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� �м��Լ� / window �Լ� (�ǽ� ana6) ---------------------------------------------------------------------------------------------------
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����, ����(job), �޿� ������ ������(JOB)��
-- �޿� ������ 1�ܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���. (�޿��� ���� ��� �Ի����� ���� ����� ���� ����)
SELECT empno, ename, hiredate, job, sal,
            LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) rag_sal
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM emp
ORDER BY sal;

SELECT empno, ename, sal
FROM emp
ORDER BY sal;


-- WINDOWING
-- UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
-- CURRENT ROW : ���� ��
-- UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
-- N (����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
-- N (����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
              SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
              SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
              SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;


-- �� �м��Լ� / window �Լ� (�ǽ� ana7) ---------------------------------------------------------------------------------------------------
-- �����ȣ, ����̸�, �μ���ȣ, �޿� ������ �μ����� �޿�, �����ȣ ������������ �������� ��, �ڽ��� �޿���
-- �����ϴ� ������� �޿� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���. (window �Լ� ���)
SELECT empno, ename, deptno, sal,
              SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-------------------------------------------------------------------------------------------------------------------------------------------------------



-- BETWEEN �� ���� �ʴ��� �ڱ� ����� ������ �ȴ�. (�⺻��)
-- �������� ����� ������ �� �� ��ȣ�Ͻ�.
SELECT empno, ename, deptno, sal,
              SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
              SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
              SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
              SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;
-- range�� ��� ������ ���� ���� ���� ���� ���� ���´�. ���� ���� �ϳ��� ������ ������.




