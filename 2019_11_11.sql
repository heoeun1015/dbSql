-- SMITH,  WARD 가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
        OR deptno = 30;
        
        
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                                FROM emp
--                              WHERE ename IN ('SMITH', 'WARD'));
                                WHERE ename IN (:name1, :name2));
                                
-- ANY  :   set(800, 1250) 중에 만족하는 게 하나라도 있으면 참으로 (크기비교 할 때 많이 사용)
-- SMITH, WARD  두 사람의 급여보다 적은 급여를 받는 직원 정보 조회
SELECT ename, sal
FROM emp
ORDER BY sal;

-- SMITH와 WARD보다 급여가 높은 직원 조회
-- SMITH보다도 급여가 높고 WARD보다도급여가 높은 사람 (AND)
SELECT *
FROM emp
WHERE sal < any (SELECT sal     -- 800, 1250      → 1250보다 작은 급여를 받는 사람
                                FROM emp
                                WHERE ename IN ('SMITH', 'WARD'));
                                
SELECT *
FROM emp
WHERE sal > all (SELECT sal     -- 800, 1250      → 1250보다 높은 급여를 받는 사람
                                FROM emp
                                WHERE ename IN ('SMITH', 'WARD'));


-- NOT IN

-- 관리자 직원 정보 조회
-- 1. 관리자인 사람만 조회
--      . mgr 컬럼에 값이 나오는 직원

-- DISTINCT :   중복 제거

SELECT DISTINCT mgr
FROM emp
ORDER BY mgr;

-- 어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7566, 7698, 7782, 7788, 7839, 7902);
-- KING -   JONES   - SCOTT

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                                FROM emp);

-- 관리자 역할을 하지 않는 평 사원 정보 조회
-- 단, NOT IN 연산자 사용시 SET 에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
-- NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용

-- WHERE절
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                                        FROM emp
                                        WHERE mgr IS NOT NULL);
-- NVL                     
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                                        FROM emp);


-- pair wise
-- 사번 7499, 7782인 직원의 관리자, 부서번호 조회
-- 7698     30
-- 7839     10
-- 직원 중에 관리자와 부서번호가 (7698, 30)이거나, (7839,  10)인 사람
-- mgr, deptno  컬럼을 [동시]에 만족시키는 직원 정보 조회
SELECT mgr, deptno
FROM emp
ORDER BY mgr, deptno;

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                                            FROM emp
                                            WHERE empno IN (7499, 7782));

-- non pair wise. 결과가 7782이면서 30인 데이터도 출력한다.
-- 7698     30
-- 7839     10
-- 위 두 조합이 가능한 모든 경우의 수가 나온다. 이렇게 안하려면 pair wise를 써야 함.
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                            FROM emp
                            WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
                            FROM emp
                            WHERE empno IN (7499, 7782));
-- 비상호연관이기 때문에 따로 실행이 가능하다.
                            


-- SCALAR SUBQUERY  :   SELECT 절에 등장하는 서브 쿼리(단 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, '부서명' dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;
-- 결과가 행이 하나라 사용 가능. 그렇지만 모든 직원에 대한 부서명이기 때문에 20의 고정값을 사용할 수는 없다.


SELECT empno, ename, deptno, (SELECT dname
                                                        FROM dept
                                                        WHERE deptno = emp.deptno)  -- emp에 있는 deptno를 참조해라.
FROM emp;
-- SCALAR 에 대한 예시인 거지, 이게 JOIN 대체로 사용하는 것이 좋은 것은 아니다.
-- WHERE deptno = emp.deptno. Main 쿼리에서 가져온 것이기 때문에 독단적으로 시행할 수 없다. (상호연관)
-- ※ emp테이블을 먼저 읽어야 하는데, main 쿼리에서 읽지 않으면 불러올 수 없음.



SELECT *
FROM dept;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

-- ■ 서브쿼리 (실습 sub4) ------------------------------------------------------------------------------------------------------------------------
-- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없다. 직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요.
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                                        FROM emp);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 서브쿼리 (실습 sub5) ------------------------------------------------------------------------------------------------------------------------
-- cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회하는 쿼리를 작성하세요.
SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                                  FROM cycle
                                  WHERE cid = 1);
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 서브쿼리 (실습 sub6) ------------------------------------------------------------------------------------------------------------------------
-- cycle 테이블을 이용하여 cid = 2인 고객이 애음하는 제품 중 cid = 1인 고객도  애음하는 제품의 애음 정보를 조회하는
-- 쿼리를 작성하세요.
SELECT *
FROM cycle
WHERE pid IN ( SELECT pid
                           FROM cycle
                           WHERE cid = 2)
    AND cid = 1;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 서브쿼리 (실습 sub7) (과제) ----------------------------------------------------------------------------------------------------------------
-- cycle 테이블을 이용하여 cid = 2고객이 애음하는 제품 중 cid = 1인 고객도 애음하는 제품의 제품 정보를 조회하고
-- 고객명과 제품명까지 포함하는 쿼리를 작성하세요.
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt 
FROM cycle, product, customer
WHERE cycle.pid IN ( SELECT pid
                                   FROM cycle
                                   WHERE cid = 2)
    AND cycle.cid = 1
    AND cycle.pid = product.pid
    AND cycle.cid = customer.cid;
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- EXISTS MAIN 쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
-- 만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

-- MGR이 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'x'
                            FROM emp
                            WHERE empno = a.mgr);
-- 한쪽만이라도 별칭을 줄 것
-- SELECT 다음에 오는 명칭은 아무거나 와도 됨 ex) 'x'


-- MGR이 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'x'
                                    FROM emp
                                    WHERE empno = a.mgr);


-- ■ 서브쿼리 (EXISTS 연산자 - 실습 sub8) ---------------------------------------------------------------------------------------------------
-- 아래 쿼리를 subquery를 사용하지 않고 작성하세요.
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 부서에 소속된 직원이 있는 부서 정보 조회 (EXISTS)
SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

SELECT *
FROM dept
WHERE EXISTS (SELECT 'a'
                            FROM  emp
                            WHERE deptno = dept.deptno);
-- IN
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                                FROM  emp);
                                
                                
-- ■ 서브쿼리 (실습 sub9) (과제) ----------------------------------------------------------------------------------------------------------------
-- cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회하는 쿼리를 EXISTS 연산자를
-- 이용하여 작성하세요.
SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'a'
                                    FROM cycle
                                    WHERE cid = 1
                                    AND pid = product.pid );
----------------------------------------------------------------------------------------------------------------------------------------------------------


-- 집합연산
-- UNION    :   합집합, 중복을 제거
--                    DBMS에서는 중복을 제거하기 위해서 데이터를 정렬.     -- 지금이야 건 수가 별로 없지만 몇 만건을 넘어갈 때는 무시하지 못함.
--                    (대량의 데이터를 정렬시 부하가 걸림)
-- UNION ALL    :   UNION과 같은 개념
--                    (중복을 제거하지 않고, 위 아래 집합을 결합만 한다. → 중복이 있을 수 있음.
--                    위 아래 집합에 중복되는 데이터가 없다는 것을 확신하면 UNION 연산자보다 성능 면에서 유리)
-- 사번이 7566 또는 7698인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;

-- 사번이 7369, 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;


-- UNION
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
    UNION
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
    UNION
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
-- 합집합일 때, 두 개의 쿼리가 결과값이 같으면 중복 제거

-- UNION ALL
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698
    UNION ALL
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;



-- INTERSECT (교집합   :   위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7369 )
    INTERSECT
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7499 );



-- MINUS (차집합   :   위 집합에서 아래 집합을 제거 )
-- 순서가 존재 (위와 아래의 데이터를 바꾸면 결과가 달라질 수 있다.)
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7369 )
    MINUS
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7499 ); -- 7369


SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7499 )
    MINUS
SELECT empno, ename
FROM emp
WHERE empno in( 7566, 7698, 7369 ); -- 7499


SELECT 1 n, 'x' m
FROM dual
    MINUS
SELECT 2, 'y'
FROM dual
ORDER BY n;
-- 순서가 틀리면 타입이 달라져서 연산이 안 된다. 꼭 지켜줄 것.
-- 정렬은 가장 마지막에 써줄 것




SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC16'
AND TABLE_NAME IN ( 'PROD', 'LPROD' )
AND CONSTRAINT_TYPE IN ( 'P', 'R' );

