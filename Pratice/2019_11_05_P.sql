
-- �� Function (null �ǽ� fn4) ----------------------------------------------------------------------------------------------------------------------
-- emp ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�. NULL�� ��� 9999 ǥ��.
-- (NVL, NVL2, COALESCE ���� ��)

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (null �ǽ� fn5) ----------------------------------------------------------------------------------------------------------------------
-- users ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���. reg_dt�� null�� ��� sysdate�� ����.

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (condition �ǽ� cond1) -----------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ�  deptno�� ���� �μ������� �����ؼ� ������ ���� ��ȸ�Ǵ� ������ �ۼ��ϼ���.
-- 10 �� 'ACCOUNTING', 20 �� 'RESEARCH', 30 �� 'SALES', 40 �� 'OPERATIONS', ��Ÿ �ٸ� �� �� 'DDIT'

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (condition �ǽ� cond2) -----------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ��������� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�.)

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (group function �ǽ� grp1) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    -- ������ ���� ���� �޿�
    -- ������ ���� ���� �޿�
    -- ������ �޿� ���(�Ҽ��� 2�ڸ�����)
    -- ������ �޿� ��
    -- ���� �� �޿��� �ִ� ������ �� (NULL ����)
    -- ���� �� ����ڰ� �ִ� ������ �� (NULL ����)
    -- ��ü ������ ��

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- �� Function (group function �ǽ� grp2) ------------------------------------------------------------------------------------------------------
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�.
    -- �μ����� ���� �� ���� ���� �޿�
    -- �μ����� ���� �� ���� ���� �޿�
    -- �μ����� ������ �޿� ���(�Ҽ��� 2�ڸ�����)
    -- �μ����� ������ �޿� ��
    -- �μ��� ���� �� �޿��� �ִ� ������ �� (NULL ����)
    -- �μ��� ���� �� ����ڰ� �ִ� ������ �� (NULL ����)
    -- ��ü�� ������ ��)

----------------------------------------------------------------------------------------------------------------------------------------------------------