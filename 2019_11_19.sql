-- 대전지역 한정
-- 버거킹, 맥도날드, kfc 개수
SELECT gb, sido, sigungu
FROM fastfood
WHERE sido = '대전광역시'
    AND gb IN ('버거킹', '맥도날드', 'KFC')
ORDER BY  sido, sigungu, gb;

SELECT gb, sido, sigungu
FROM fastfood
WHERE sido = '대전광역시'
    AND gb IN ('롯데리아')
ORDER BY  sido, sigungu, gb;

SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE sido = '대전광역시'
    AND gb IN ('롯데리아')
GROUP BY sido, sigungu;

ORDER BY  sido, sigungu, gb


-- 140 건
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('맥도날드', '버거킹', 'KFC')
GROUP BY sido, sigungu;

-- 188 건
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('롯데리아')
GROUP BY sido, sigungu;



SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt, ROUND(a.cnt / b.cnt, 2) point
FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('맥도날드', '버거킹', 'KFC') GROUP BY sido, sigungu) a,
            (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('롯데리아') GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
ORDER BY point DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM tax;

SELECT sido, sigungu, sal, ROUND(sal / people, 2) point
FROM tax
ORDER BY sal DESC;

SELECT sido, sigungu, sal
FROM tax
ORDER BY sal DESC;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 시도, 시군구, 버거지수 / 시도, 시군구, 연말정산 납입액

SELECT buger.sido_ b_sido, buger.sigungu_ b_sigungu, buger.point b_point,
              tax_.sido t_sido, tax_.sigungu t_sigungu, tax_.sal t_sal
FROM (SELECT ROWNUM No, a.*
            FROM (SELECT sido, sigungu, sal FROM tax ORDER BY sal DESC) a) tax_, 
            (SELECT ROWNUM No, b.*
            FROM (SELECT a.sido sido_, a.sigungu sigungu_, ROUND(a.cnt / b.cnt, 2) point 
                        FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('맥도날드', '버거킹', 'KFC') GROUP BY sido, sigungu) a,
                                    (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('롯데리아') GROUP BY sido, sigungu) b
                        WHERE a.sido = b.sido
                        AND a.sigungu = b.sigungu
                        ORDER BY point DESC) b) buger
WHERE tax_.No = buger.No(+);
    
    

------------------------------------------------------------------------------------------------------------------------------------------------------------------------



SELECT *
FROM emp_test;

-- emp 테이블 삭제
DROP TABLE emp_test;


-- multiple insert를 위한 테스트 테이블 생성
-- empno, ename 두 개의 컬럼을 갖는 emp_test, emp_test2 테이블을 emp 테이블로부터 생성한다. (CTAS)
-- ( 데이터는 복제하지 않는다. )

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;


-- INSERT ALL
-- 하나의 INSERT SQL 문장으로 여러 테이블에 데이터를 입력
INSERT ALL
        INTO emp_test
        INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;


-- INSERT ALL 컬럼 정의
ROLLBACK;

INSERT ALL
        INTO emp_test (empno) VALUES (empno)
        INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ROLLBACK;


-- multiple insert (conditional insert)

INSERT ALL
        WHEN empno < 10 THEN
                INTO emp_test (empno) VALUES (empno)
        ELSE        -- 조건을 통과하지 못할 때만 실행
                INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ROLLBACK;

-- INSERT FIRST
INSERT FIRST
        WHEN empno > 10 THEN
                INTO emp_test (empno) VALUES (empno)
        WHEN empno > 5 THEN       -- 조건을 통과하지 못할 때만 실행
                INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

 UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ROLLBACK;
-- MERGE    :   조건에 만족하는 데이터가 있으면 UPDATE
--                      조건에 만족하는 데이터가 없으면 INSERT

SELECT *
FROM emp_test;

-- empno가 7369인 데이터를 emp_test 테이블로부터 복사 (insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;


-- emp 테이블의 데이터 emp_test 테이블의 empno와 같은 값을 갖는 데이터가 있을 경우
-- emp_test.ename = ename || '_merge' 값으로 update
-- 데이터가 없을 경우에는 emp_test 테이블에 insert

ALTER TABLE emp_test MODIFY ( ename VARCHAR2(20) );

-- 14개의 행 업데이트
MERGE INTO emp_test
USING emp
    ON ( emp.empno = emp_test.empno )
WHEN MATCHED THEN
        UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
        INSERT VALUES ( emp.empno, emp.ename );


-- 2개의 행만 업데이트
MERGE INTO emp_test        
USING (SELECT empno, ename
             FROM emp
             WHERE emp.empno IN (7369, 7499)) emp
    ON ( emp.empno = emp_test.empno 
            AND emp.empno IN (7369, 7499))
WHEN MATCHED THEN
        UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
        INSERT VALUES ( emp.empno, emp.ename );

SELECT *
FROM emp_test;


-- 다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로 merge 하는 경우
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno가 같은 값이 있으면 ename을 'brown'으로 업데이트
-- empno가 같은 값이 없으면 신규 insert



-- 많이 사용하게 될 쿼리
MERGE INTO emp_test
USING dual
     ON ( emp_test.empno = 1 )
WHEN MATCHED THEN
        UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
        INSERT VALUES ( 1, 'brown' );

SELECT *
FROM emp_test;


-- 만약 merge를 사용하지 않을 경우 ----------
SELECT *
FROM emp_test
WHERE empno = 1;

UPDATE emp_test SET = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');
-------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GROUP



--SELECT deptno, SUM(sal), 1 num
--FROM emp
--GROUP BY deptno
--ORDER BY deptno
--
--UNION ALL
--
--SELECT SUM(sal_)
--FROM 
--(SELECT deptno, SUM(sal) sal_, 1 num
--FROM emp
--GROUP BY deptno
--ORDER BY deptno) a
--GROUP BY a.num;


-- ■ GROUP_AD 1 -----------------------------------------------------------------------------------------------------------------------------------
-- 그룹결 합계, 전체 합계를 다음과 같이 구하려면?
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT null as deptno, SUM(sal) sal
FROM emp;
-----------------------------------------------------------------------------------------------------------------------------------------------------------



-- rollip
-- group by의 서브 그룹을 생성
-- GROUP BY ROLLUP ( {col,} )
-- 컬럼을 오른쪽에서부터 제거해가면서 나온 서브그룹을 GROUP BY 하여 UNION 한 것과 동일
-- ex) GROUP BY ROLLUP (job, deptno)
--       GROUO  BY job, deptno
--       UNION
--       GROUO  BY job
--       UNION
--       GROUP BY → 총계 (모든 행에 대해 그룹함수 적용)


SELECT job, NVL(deptno, 0) deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);




-- 아래 쿼리를 ROLLUP 형태로 변경
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno UNION ALL
SELECT null as deptno, SUM(sal) sal
FROM emp;


SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno); 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- GROUPING SETS (col1, col2 …)
-- GROUPING SETS의 나열된 항목이 하나의 서브그룹으로 GROUP BY 절에 이용된다.

    -- 위 구문은 아래와 동일함
-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2



-- emp 테이블을 이용하여 부서별 급여 합과, 담당업무(job)별 급여합을 구하시오.

-- 부서번호, job, 급여 합계
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno UNION ALL   --
        SELECT null, job, SUM(sal)
        FROM emp
        GROUP BY job;   --
-- 서브 그룹 2개.

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));

