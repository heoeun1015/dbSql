-- emp Å×ÀÌºí¿¡ empno ÄÃ·³À» ±âÁØÀ¸·Î PRIMARY KEY¸¦ »ý¼º
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ¡æ ÇØ´ç ÄÃ·³À¸·Î UNIQUE INDEX¸¦ ÀÚµ¿À¸·Î »ý¼º

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
-- PRIMARY KEY ¸¦ »ç¿ëÇÏ¸é¼­ ¸¸µé¾îÁø ÀÎµ¦½º¸¦ ÀÚµ¿ÀûÀ¸·Î »ç¿ëÇÑ °æ¿ì

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    37 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    37 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)  -- ÀÎµ¦½º¿¡ Á¢±ÙÇÒ ¶§ »ç¿ëµÇ´Â Á¶°Ç
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬



-- empno ÄÃ·³À¸·Î ÀÎµ¦½º°¡ Á¸ÀçÇÏ´Â »óÈ²¿¡¼­ ´Ù¸¥ ÄÃ·³ °ªÀ¸·Î µ¥ÀÌÅÍ¸¦ Á¶È¸ÇÏ´Â °æ¿ì
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   111 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   111 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬


-- ÀÎµ¦½º ±¸¼º ÄÃ·³¸¸ SELECT Àý¿¡ ±â¼úÇÑ °æ¿ì
-- Å×ÀÌºí Á¢±ÙÀÌ ÇÊ¿ä¾ø´Ù

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
-- ÀÎµ¦½º ÄÃ·³¸¸ ÀÐ¾îµµ ¿øÇÏ´Â ÀÎµ¦½º°¡ ´Ù ÀÖ´Ù.
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬


-- ÄÃ·³¿¡ Áßº¹ÀÌ °¡´ÉÇÑ non-unique ÀÎµ¦½º »ý¼º ÈÄ
-- unique index¿ÍÀÇ ½ÇÇà°èÈ¹ ºñ±³
-- PRIMARY KEY Á¦¾àÁ¶°Ç »èÁ¦ (unique ÀÎµ¦½º »èÁ¦)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬


-- emp Å×ÀÌºí¿¡ job ÄÃ·³À¸·Î µÎ ¹øÂ° ÀÎµ¦½º »ý¼º (non-unique index)
-- job ÄÃ·³Àº ´Ù¸¥ ·Î¿ìÀÇ job ÄÃ·³°ú Áßº¹ÀÌ °¡´ÉÇÑ ÄÃ·³ÀÌ´Ù.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);


--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   111 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   111 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')        -- ÀÎµ¦½º È®ÀÎ ºÒ°¡. Å×ÀÌºí¿¡ Á¢±ÙÀ» ÇØ¾ßÁö¸¸ ¾Ë ¼ö ÀÖ´Â °ª.
   2 - access("JOB"='MANAGER')
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬



-- emp Å×ÀÌºí¿¡ job, ename ÄÃ·³À» ±âÁØÀ¸·Î non-unique ÀÎµ¦½º »ý¼º
CREATE INDEX IDX_emp_03 ON emp (job, ename);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);


--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')        -- access¶û filter¶û µ¿½Ã¿¡ µÆ´Ù.
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬


-- emp Å×ÀÌºí¿¡ ename, job ÄÃ·³À¸·Î non-unique ÀÎµ¦½º »ý¼º
CREATE INDEX IDX_emp_04 ON emp (ename, job);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';
-- ÀÌ·± °æ¿ì´Â ÀÎµ¦½º¸¦ »ç¿ëÇÏ±â ÁÁÁö ¾ÊÀº ¿¹. »ç¿ëÇÒÁö ¾È ÇÒÁöµµ ¾Ë ¼ö ¾ø´Ù.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename LIKE '%C'
    AND job = 'MANAGER';
-- WHERE ÀÇ Á¶°Ç ¼ø¼­°¡ ¹Ù²ï´Ù°í ÇØ¼­ °á°ú°¡ ´Þ¶óÁö´Â ÀÏÀº ¾ø´Ù. SQLÀº SetÀÇ °³³äÀÌ±â ¶§¹®.

SELECT *
FROM TABLE(dbms_xplan.display);


--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬
Plan hash value: 4060516099
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
    -- ¼±ÇàÀÌ ÀÖÀ» °Å¶ó°í »ý°¢ÇÏ°í enameºÎÅÍ Âß ½ºÄµÀ» ÇÑ´Ù.
    -- ÀÎµ¦½º ÄÃ·³ ¼ø¼­¿¡ µû¶ó¼­µµ °á°ú°¡ ¹Ù²ï´Ù.
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
--¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬


-- HINT¸¦ »ç¿ëÇÑ ½ÇÇà°èÈ¹ Á¦¾î
    -- RDBSÀÇ ±âº» »ç»óÀº »ç¿ëÀÚ°¡ ·ÎÁ÷À» ¸ô¶ó¼­ »ç¿ëÇÒ ¼ö ÀÖ´Ù. hint¸¦ »ç¿ëÇÏ¸é ±×·± ÀÌÁ¡À» ´©¸®Áö ¸øÇÑ´Ù°í ½È¾îÇÏ´Â »ç¶÷µéµµ ÀÖÀ½.
    -- WHERE µµ °Çµå·Áº¸°í ´Ù ÇØºÃ´Âµ¥ ±×·¡µµ ¾È µÈ´Ù°í ÇßÀ» ¶§ ¸¶Áö¸·¿¡ »ç¿ëÇÏ´Â ½ÄÀ¸·Î...

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_01) */ *      -- ¿À¶óÅ¬¿¡¼­ °³¹ßÀÚÀÇ ¸í·ÉÀ» µè´Â ÁÖ¼® Ã³¸® ºÎºÐ(HINT)
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';
-- ÀÌ·± °æ¿ì´Â ÀÎµ¦½º¸¦ »ç¿ëÇÏ±â ÁÁÁö ¾ÊÀº ¿¹. »ç¿ëÇÒÁö ¾È ÇÒÁöµµ ¾Ë ¼ö ¾ø´Ù.

SELECT *
FROM TABLE(dbms_xplan.display);


        -- CTAS


-- ¡á DDL (index ½Ç½À idx1) -----------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 ±¸¹®À¸·Î DEPT_TEST Å×ÀÌºí »ý¼º ÈÄ ´ÙÀ½
-- Á¶°Ç¿¡ ¸Â´Â ÀÎµ¦½º¸¦ »ý¼ºÇÏ¼¼¿ä.

CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1;

SELECT *
FROM dept_test;

-- 1. deptno ÄÃ·³À» ±âÁØÀ¸·Î unique ÀÎµ¦½º »ý¼º
ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);

-- 2. dname ÄÃ·³À» ±âÁØÀ¸·Î non-unique ÀÎµ¦½º »ý¼º
CREATE INDEX idx_emp_test ON dept_test (dname);

-- 3. deptno, dname ÄÃ·³À» ±âÁØÀ¸·Î non-unique ÀÎµ¦½º »ý¼º
CREATE INDEX idx2_emp_test ON dept_test (deptno, dname);
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ¡á DDL (index ½Ç½À idx2) -----------------------------------------------------------------------------------------------------------------------
-- ½Ç½À idx1¿¡¼­ »ý¼ºÇÑ ÀÎµ¦½º¸¦ »èÁ¦ÇÏ´Â DDL ¹®À» ÀÛ¼ºÇÏ¼¼¿ä.
ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
DROP INDEX idx_emp_test;
DROP INDEX idx2_emp_test;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ¡á DDL (index ½Ç½À idx3) -----------------------------------------------------------------------------------------------------------------------
-- ½Ã½ºÅÛ¿¡¼­ »ç¿ëÇÏ´Â Äõ¸®°¡ ´ÙÀ½°ú °°´Ù°í ÇÒ ¶§ ÀûÀýÇÑ emp Å×ÀÌºí¿¡ ÇÊ¿äÇÏ´Ù°í »ý°¢µÇ´Â ÀÎµ¦½ºÀÇ »ý¼º ½ºÅ©¸³Æ®¸¦
-- ¸¸µé¾îº¸¼¼¿ä.
SELECT *
FROM emp
WHERE empno = 7298;

SELECT *
FROM emp
WHERE ename = 'SCOTT';

SELECT *
FROM emp
WHERE sal BETWEEN 500 AND 7000
    AND deptno = 20;
    
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno = 10
    AND emp.empno LIKE '78%';
    
SELECT B.*
FROM emp A, emp B
WHERE A.mgr = B.empno
    AND A.deptno = 30;

ALTER TABLE emp ADD CONSTRAINT pk_emp_idxtest1 PRIMARY KEY (empno);

CREATE INDEX idx_emp_test_1 ON emp (ename);
CREATE INDEX idx_emp_test_2 ON emp (deptno);
CREATE INDEX idx_emp_test_3 ON emp (deptno, mgr);
-- CREATE INDEX idx_dept_test_1 ON dept (deptno); -- ÀÌ¹Ì PRAIMARY KEY °¡ ÀÖÀ½.
----------------------------------------------------------------------------------------------------------------------------------------------------------

