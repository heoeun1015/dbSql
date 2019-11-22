

-- h_1 정보시스템부 하위의 조직 하위계층 조직 조회 (dept0_02)

SELECT level lv, deptcd, LPAD(' ', 4  * (LEVEL - 1), ' ') || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- 상향식 계층 쿼리
-- 특정 노드로부터 자신의 부모노드를 탐색 (트리 전체 탐색이 아니다)
-- 디자인팀을 시작으로 상위 부서를 조회
-- 디자인팀 dept0_00_0
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd ;
-- PRIOR: 이미 읽은 데이터를 지칭
--CONNECT BY p_deptcd = PRIOR depccd 써도 가능하다.



-- ■ 계층쿼리 (실습 h_4) ---------------------------------------------------------------------------------------------------------------------------
-- 계층형 쿼리 복습.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하시오.
-- s_id : 노드 아이디
-- ps_id : 부모 노드 아이디
-- value : 노드 값
SELECT *
FROM h_sum;

SELECT LPAD(' ', (LEVEL - 1) * 8, ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- ■ 계층쿼리 (실습 h_5) ---------------------------------------------------------------------------------------------------------------------------
-- 계층형쿼리 스크립트.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하시오.
-- org_cd : 부서코드
-- parent_org_cd : 부모 부서코드
-- no_emp : 부서 인원수
SELECT *
FROM no_emp;

SELECT LPAD(' ', 10 * (LEVEL - 1), ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;
-----------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- pruning barnch (가지치기)
-- 계층 쿼리에서 [WHERE] 절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

-- dept_h 테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, deptnm, LPAD(' ', 8 * (LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 계층쿼리가 완성된 이후 WHERE 절이 적용된다.
SELECT deptcd, deptnm, LPAD(' ', 8 * (LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;     -- 기획팀이 디자인부 아래인 것처럼 나온다.

SELECT deptcd, deptnm, LPAD(' ', 8 * (LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
                            AND deptnm != '정보기획부';


-- CONNECT_BY_ROOT(col) : col의 최상위 노드 컬럼 값
-- SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이어서 보여주는 경로
                                                                  -- LTIRM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
-- CONNECT_BY_ISLEAF :  해당 row가 leaf node인지 판별 ( 1:  0, 0 : X)
SELECT LPAD(' ', 8 * (LEVEL - 1), ' ' ) || org_cd org_cd,
             CONNECT_BY_ROOT(org_cd) root_org_cd,        -- 가장 최상의 코드가 뭔지 가져온다. 많이 사용하진 않는데 가끔 필요할 때가 있음.
             LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path,           -- 어떤 계층을 통해서 왔는지 컬럼을 이어서 보여줌.
             CONNECT_BY_ISLEAF isleaf                              -- 해당 컬럼이 마지막 노드이냐, 아니냐
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;



-- ■ 계층쿼리 (게시글 계층형쿼리 샘플 자료.SQL, 실습 h6 ---------------------------------------------------------------------------------
-- 게시글을 저장하는 board_test 테이블을 이용하여 계층 쿼리를 작성하시오.
SELECT *
FROM board_test;

--SELECT seq, LPAD(' ', 8 * (LEVEL - 1), ' ') || title title
--FROM board_test
--START WITH seq IN ('1', '2', '4')
--CONNECT BY PRIOR seq = parent_seq;

SELECT seq, LPAD(' ', 8 * (LEVEL - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq;
-----------------------------------------------------------------------------------------------------------------------------------------------------------



-- ORDER SIBLINGS BY : 계층 쿼리를 유지하면서 정렬을 해라.
SELECT seq, LPAD(' ', 8 * (LEVEL - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

-- 정답
SELECT *
FROM(SELECT seq, LPAD(' ', 8 * (LEVEL - 1), ' ') || title title,
                          CONNECT_BY_ROOT(seq) r_seq
            FROM board_test
            START WITH parent_seq IS NULL 
            CONNECT BY PRIOR seq = parent_seq
            ORDER SIBLINGS BY seq DESC) a
ORDER BY r_seq DESC, seq;
--ORDER SIBLINGS BY CONNECT_BY_ROOT(seq) DESC; -- 막힌다.


--SELECT seq, LPAD(' ', 8 * (LEVEL - 1), ' ') || title title,
--             CASE WHEN parent_seq IN NULL THEN seq ELSE 0 END o1,
--             CASE WHEN parent_seq IN NOT NULL THEN seq ELSE 0 END o2
--FROM board_test
--START WITH parent_seq IS NULL 
--CONNECT BY PRIOR seq = parent_seq
--ORDER SIBLINGS BY CASE WHEN parent_seq IN NULL THEN seq ELSE 0 END DESC;


SELECT *
FROM board_test;

-- 글 그룹번호 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', 8 * (LEVEL - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;



-- 자신보다 바로 아래 등급의 급여가 나올 수 있게끔
SELECT a.ename, a.sal, b.sal l_sal
FROM
(SELECT ename, sal, ROWNUM rn
FROM(SELECT ename, sal FROM emp ORDER BY sal DESC)) a,
            (SELECT ename, sal, ROWNUM rn FROM(SELECT ename, sal FROM emp ORDER BY sal DESC)) b
WHERE a.rn = b.rn(+) - 1;
            


