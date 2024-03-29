-- emp 纔檜綰縑 empno 鏽歲擊 晦遽戲煎 PRIMARY KEY蒂 儅撩
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ⊥ п渡 鏽歲戲煎 UNIQUE INDEX蒂 濠翕戲煎 儅撩

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
-- PRIMARY KEY 蒂 餌辨ж賊憮 虜菟橫霞 檣策蝶蒂 濠翕瞳戲煎 餌辨и 唳辦

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
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
 
   2 - access("EMPNO"=7369)  -- 檣策蝶縑 蕾斬й 陽 餌辨腎朝 褻勒
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收



-- empno 鏽歲戲煎 檣策蝶陛 襄營ж朝 鼻�窒□� 棻艇 鏽歲 高戲煎 等檜攪蒂 褻�裔炴� 唳辦
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
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
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收


-- 檣策蝶 掘撩 鏽歲虜 SELECT 瞰縑 晦獎и 唳辦
-- 纔檜綰 蕾斬檜 в蹂橈棻

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
-- 檣策蝶 鏽歲虜 檗橫紫 錳ж朝 檣策蝶陛 棻 氈棻.
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收


-- 鏽歲縑 醞犒檜 陛棟и non-unique 檣策蝶 儅撩 ��
-- unique index諦曖 褒ч啗�� 綠掖
-- PRIMARY KEY 薯擒褻勒 餉薯 (unique 檣策蝶 餉薯)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
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
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收


-- emp 纔檜綰縑 job 鏽歲戲煎 舒 廓簞 檣策蝶 儅撩 (non-unique index)
-- job 鏽歲擎 棻艇 煎辦曖 job 鏽歲婁 醞犒檜 陛棟и 鏽歲檜棻.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);


--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
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
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
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
 
   1 - filter("ENAME" LIKE 'C%')        -- 檣策蝶 �挫� 碳陛. 纔檜綰縑 蕾斬擊 п撿雖虜 憲 熱 氈朝 高.
   2 - access("JOB"='MANAGER')
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收



-- emp 纔檜綰縑 job, ename 鏽歲擊 晦遽戲煎 non-unique 檣策蝶 儅撩
CREATE INDEX IDX_emp_03 ON emp (job, ename);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);


--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
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
       filter("ENAME" LIKE 'C%')        -- access嫌 filter嫌 翕衛縑 腑棻.
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收


-- emp 纔檜綰縑 ename, job 鏽歲戲煎 non-unique 檣策蝶 儅撩
CREATE INDEX IDX_emp_04 ON emp (ename, job);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';
-- 檜楛 唳辦朝 檣策蝶蒂 餌辨ж晦 謠雖 彊擎 蕨. 餌辨й雖 寰 й雖紫 憲 熱 橈棻.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename LIKE '%C'
    AND job = 'MANAGER';
-- WHERE 曖 褻勒 牖憮陛 夥莎棻堅 п憮 唸婁陛 殖塭雖朝 橾擎 橈棻. SQL擎 Set曖 偃喃檜晦 陽僥.

SELECT *
FROM TABLE(dbms_xplan.display);


--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收
Plan hash value: 4060516099
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
    -- 摹ч檜 氈擊 剪塭堅 儅陝ж堅 ename睡攪 軀 蝶警擊 и棻.
    -- 檣策蝶 鏽歲 牖憮縑 評塭憮紫 唸婁陛 夥莎棻.
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
--收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收收


-- HINT蒂 餌辨и 褒ч啗�� 薯橫
    -- RDBS曖 晦獄 餌鼻擎 餌辨濠陛 煎霜擊 路塭憮 餌辨й 熱 氈棻. hint蒂 餌辨ж賊 斜楛 檜薄擊 援葬雖 跤и棻堅 褓橫ж朝 餌塋菟紫 氈擠.
    -- WHERE 紫 勒萄溥爾堅 棻 п疑朝等 斜楚紫 寰 脹棻堅 ц擊 陽 葆雖虞縑 餌辨ж朝 衝戲煎...

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_01) */ *      -- 螃塭贗縑憮 偃嫦濠曖 貲滄擊 菔朝 輿戮 籀葬 睡碟(HINT)
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';
-- 檜楛 唳辦朝 檣策蝶蒂 餌辨ж晦 謠雖 彊擎 蕨. 餌辨й雖 寰 й雖紫 憲 熱 橈棻.

SELECT *
FROM TABLE(dbms_xplan.display);


        -- CTAS


-- ﹥ DDL (index 褒蝗 idx1) -----------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 掘僥戲煎 DEPT_TEST 纔檜綰 儅撩 �� 棻擠
-- 褻勒縑 蜃朝 檣策蝶蒂 儅撩ж撮蹂.

CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1;

SELECT *
FROM dept_test;

-- 1. deptno 鏽歲擊 晦遽戲煎 unique 檣策蝶 儅撩
ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);

-- 2. dname 鏽歲擊 晦遽戲煎 non-unique 檣策蝶 儅撩
CREATE INDEX idx_emp_test ON dept_test (dname);

-- 3. deptno, dname 鏽歲擊 晦遽戲煎 non-unique 檣策蝶 儅撩
CREATE INDEX idx2_emp_test ON dept_test (deptno, dname);
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- ﹥ DDL (index 褒蝗 idx2) -----------------------------------------------------------------------------------------------------------------------
-- 褒蝗 idx1縑憮 儅撩и 檣策蝶蒂 餉薯ж朝 DDL 僥擊 濛撩ж撮蹂.
ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
DROP INDEX idx_emp_test;
DROP INDEX idx2_emp_test;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ﹥ DDL (index 褒蝗 idx3) -----------------------------------------------------------------------------------------------------------------------
-- 衛蝶蠱縑憮 餌辨ж朝 蘭葬陛 棻擠婁 偽棻堅 й 陽 瞳瞰и emp 纔檜綰縑 в蹂ж棻堅 儅陝腎朝 檣策蝶曖 儅撩 蝶觼董お蒂
-- 虜菟橫爾撮蹂.

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

SELECT *
FROM TABLE(dbms_xplan.display);

ALTER TABLE emp ADD CONSTRAINT pk_emp_idxtest1 PRIMARY KEY (empno);

CREATE INDEX idx_emp_test_1 ON emp (ename);
CREATE INDEX idx_emp_test_2 ON emp (deptno);
CREATE INDEX idx_emp_test_3 ON emp (deptno, mgr);
-- CREATE INDEX idx_dept_test_1 ON dept (deptno); -- 檜嘐 PRAIMARY KEY 陛 氈擠.
----------------------------------------------------------------------------------------------------------------------------------------------------------


