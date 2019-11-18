SELECT *
FROM user_views;

SELECT *
FROM all_views
WHERE owner = 'PC16';

-- �ٸ� ����ڷκ��� ������ �޾Ƽ� ���� �� �� �ִ� ��
SELECT *
FROM pc16.V_EMP_DEPT;


-- pc16 �������� ��ȸ ������ ���� V_EMP_DEPT view �� hr �������� ��ȸ�ϱ�
-- ���ؼ��� ������.view �̸� �������� ����� �ؾ� �Ѵ�.
-- �Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM V_EMP_DEPT FOR pc16.V_EMP_DEPT;

-- pc16.V_EMP_DEPT �� V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- SYNONYM �����ϱ�
DROP SYNONYM V_EMP_DEPT;

-- hr ���� ��й�ȣ: java
-- hr ���� ��й�ȣ ����: hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc16 IDENTIFIED BY java;  -- ���� ������ �ƴ϶� ����


------------------------ ( �� ���� hr ���� ) ---------------------------------------------


-- dictionary
-- ���ξ�  :   USER    :   ����� ���� ��ü
--                  ALL     : ����ڰ� ��� ������ ��ü
--                  DBA     : ������ ������ ��ü ��ü (�Ϲ� ����ڴ� ��� �Ұ�)
--                  V$     : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE owner IN ('PC16', 'HR');




-- ����Ŭ���� ������  SQL�̶�?
-- ���ڰ� �ϳ��� Ʋ���� �� ��.
-- ���� sql���� ���� ����� ������ ���� DBMS������ ���� �ٸ� SQL�� �νĵȴ�.
SELECT /*bind test*/ * FROM emp;
Select /*bind test*/ * FROM emp;
Select /*bind test*/ *  FROM emp;

Select /*bind test*/ *  FROM emp WHERE empno = 7369;
Select /*bind test*/ *  FROM emp WHERE empno = 7499;
Select /*bind test*/ *  FROM emp WHERE empno = 7521;

Select /*bind test*/ *  FROM emp WHERE empno = :empno;
-- �� �� ������ ���� �ٸ� SQL �� �ν��� �Ѵ�.

-- system �������� ������.
SELECT *
FROM v$SQL
WHERE sql_text LIKE '%bind test%';

-- Select /*bind test*/ *  FROM emp WHERE empno = 7369 ������ ���ִ°� ����Ŭ ���忡���� �� ��Ȯ�� �����ȹ�� © �� �ֱ�� �ϴ�.
-- �׷��� index�� Ż ���� �ְ� ���̺��� ���� �� ���� �ִµ�, �����Ͱ� ���� ��쿣 �޸𸮰� ���� �� �ִ�.











