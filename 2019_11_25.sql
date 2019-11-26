-- member 테이블을 이용하여 member2 테이블을 생성
-- member2 테이블에서 김은대 회원 (mem_id = 'a001') 의 직업 (mem_job)을 '군인'으로 변경후 commit 하고 조회

CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job = '군인'
WHERE mem_id = 'a001';
COMMIT;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';





-- 제품별 제품 구매 수량(BUY_QTY) 합계, 제품 구매 금액(BUY_COST) 합계
-- 제품명, 제품코드, 수량합계, 금액합계
SELECT *
FROM buyprod;

SELECT *
FROM prod;

SELECT SUM(buy_qty), SUM(buy_cost)
FROM buyprod;

SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod;


-- VW_PROD_BUY (view 생성)

CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT a.buy_prod, prod_name, a.sum_qty, a.sum_cost
FROM (SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
            FROM buyprod
            GROUP BY buy_prod) a, prod
WHERE a.buy_prod = prod.prod_id;

SELECT *
FROM USER_VIEWS;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM emp;

SELECT deptno, ROWNUM
FROM(
SELECT deptno
FROM emp
WHERE deptno = (SELECT deptno, COUNT(deptno)
                            FROM emp
                            GROUP BY deptno)
ORDER BY deptno, sal DESC);


SELECT deptno
FROM dept;


SELECT *
FROM (SELECT deptno, COUNT(deptno)
            FROM emp
            GROUP BY deptno), emp;





-- 부서별 랭킹
-- 부서별 건수가 아무리 많아지더라도 emp 테이블의 전체 건수보다 높아질 순 없다.


SELECT a.ename, a.sal, a.deptno, b.rn
FROM  (SELECT a.eanme, a.sal, a.deptno, ROWNUM j_rn
            FROM (SELECT ename, sal, deptno
                        FROM emp
                        ORDER BY deptno, sal DESC) a) a,
                        
            (SELECT b.rn, ROWNUM j_rn
            FROM (SELECT a.deptno, b.rn
                        FROM(SELECT deptno, COUNT(*) cnt 
                                    FROM emp
                                    GROUP BY deptno) a,
                        (SELECT ROWNUM rn
                        FROM emp) b
                        WHERE a.cnt >= b.rn
                        ORDER BY a.deptno, b.rn) b) b
WHERE a.j_rn = b.j_rn;

SELECT a.ename, a.sal, a.deptno, b.rn
FROM (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
             FROM  (SELECT ename, sal, deptno
                             FROM emp
                             ORDER BY deptno, sal DESC) a ) a, 
                             
            (SELECT b.rn, ROWNUM j_rn
            FROM (SELECT a.deptno, b.rn 
                         FROM (SELECT deptno, COUNT(*) cnt --3, 5, 6
                                     FROM emp
                                     GROUP BY deptno )a,
                        (SELECT ROWNUM rn --1~14
                         FROM emp) b
        WHERE  a.cnt >= b.rn
        ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;



SELECT deptno, COUNT(*) cnt --3, 5, 6
FROM emp
GROUP BY deptno;

SELECT ROWNUM rn --1~14
FROM emp;

SELECT a.deptno, b.rn 
 FROM (SELECT deptno, COUNT(*) cnt --3, 5, 6
             FROM emp
             GROUP BY deptno )a,
(SELECT ROWNUM rn --1~14
 FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn



SELECT ename, sal, deptno,
            ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;


