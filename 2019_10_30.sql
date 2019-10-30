-- SELECT:  ��ȸ�� �÷��� ���
--                 - ��ü �÷� ��ȸ: *
--                 - �Ϻ� �÷�: �ش� �÷��� ����(, ����)
-- FROM: ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� �������.
-- ��,  keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * FROM prod;
-- �巡�� �� Crtl + Enter, �����ݷ� �տ��� Ŀ���� ���ٳ��� ���·� ������ �ȴ�.

--SELECT *
--FROM prod;
-- ���� ������ ���.

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;


-- �� �ǽ� select1 ---------------------------------------------------------------------------
-- [1] lprod ���̺��� ��� �÷� ��ȸ
SELECT * FROM prod;

-- [2] buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ
SELECT buyer_id, buyer_name
FROM buyer;

-- [3] cart ���̺��� ��� �÷� ��ȸ
SELECT * FROM cart;

-- [4] member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ
SELECT mem_id, mem_pass, mem_name
FROM member;

-- [5] remain ���̺��� remain_year, remain_prod, remain_date �÷��� ��ȸ
-- �ش� ���̺��� ���� ��ȸ �Ұ���
------------------------------------------------------------------------------------------------


-- ������ / ��¥����
-- date type + ����: ���ڸ� ���Ѵ�.
-- ����Ŭ�� ��¥�� ���ϸ� ��¥�� ���ϰԲ� �Ǿ� �ִ�. ����� ��¥ + 5
-- �̸��� �ٲ��ַ��� reg_dt + 5 reg_dt_after5, ���� ���� ��

-- null�� ������ ������ ����� �׻� null �̴�.
SELECT  userid, usernm, reg_dt,
                reg_dt + 5 reg_dt_after5,              -- as ��� x
                reg_dt - 5 as reg_dt_before5        -- as ��� o
FROM  users;

--COMMIT;
--UPDATE users SET reg_dt = null
--WHERE userid = 'moon';
--
--DELETE USERS                                                                           -- USERS���� �����ض�
--WHERE userid not in('brown', 'cony', 'sally', 'james', 'moon');     -- � �����͸� ������ �ųĸ�, �� �ټ����� �����ϰ� ���� ���� �����͸� �� ������ ��.

--commit;         -- Ʈ������� ������ ���� �ܰ�. �ٸ� ����ڰ� ��ȸ���� �� �������� ���� �����Ͱ� ��ȸ�� ���� �ִ�.



-- �� �ǽ� select2 -----------------------------------------------------------------------------------------------
-- [1] prod ���̺��� prod_id, prod_name �÷��� ��ȸ�ϰ� id, name ���� ����
SELECT prod_id AS id, prod_name AS name
FROM prod;

-- [2] lprod ���̺��� lprod_id, lprod_name �÷��� ��ȸ�ϰ� gu, nm ���� ����
SELECT  lprod_gu gu, lprod_nm nm
FROM lprod;

-- [3] buyer ���̺��� buyer_id,buyer_name �÷��� ��ȸ�ϰ� ���̾���̵�, �̸����� ����
SELECT buyer_id AS ���̾���̵�, buyer_name AS �̸�
FROM buyer;
----------------------------------------------------------------------------------------------------------------------


-- ���ڿ� ����
-- java + �� sql ||
-- CONCAT(str, str) �Լ�
-- users ���̺� userid, usernm
-- ���� �����Ϳ� ������ ���� �ʴ´�. ��¸� �������ִ� ��.
SELECT userid, usernm,
                userid || usernm ���ڿ�����,
                CONCAT(userid, usernm) CONCAT
FROM users;

-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵�: ' || userid ���ڿ�����,
                CONCAT('����� ���̵�: ', userid) CONCAT����
FROM users;


-- �� ���ڿ� ���� �ǽ� sel_con1 -------------------------------------------------------
SELECT 'SELECT * FROM ' || table_name || ';' QUERY
FROM user_tables;               -- �ش� ����ڰ� ������ �ִ� ���̺��� ǥ��
-----------------------------------------------------------------------------------------------


--�ش� ���̺� ���� ������ ������ �˷��ش�.
-- ���̺� ���ǵ� �÷��� �˰� ���� ��
-- 1. desc
-- 2. select * ....
desc emp;

SELECT *
FROM users;


-- WHERE ��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';


-- �� usernm �� ������ �����͸� ��ȸ�ϴ� ������ �ۼ� ------------------
SELECT *
FROM users
WHERE userid = 'sally';
---------------------------------------------------------------------------------------