-- 2023.08.18(금)

-- 그룹함수 
-- : 하나 이상의 데이터를 그룹으로 묶어서 연산을 수행하고, 하나의 결과로 처리
--   해주는 함수

-- sum() : 합을 구해주는 함수
select sum(sal) from emp;       -- 급여의 합
select sum(comm) from emp;      -- comm의 합, NULL값은 제외
select sum(ename) from emp;     -- 오류발생

-- 그룹 함수들끼리는 같이 사용할 수 있다.
select sum(sal), sum(comm) from emp;

-- 그룹 함수와 일반컬럼은 같이 사용할 수 없다.
select sal, sum(sal), sum(comm) from emp;  --오류발생

select sum(sal) from emp where deptno=10;   --8750
select sum(sal) from emp where deptno=20;   --10875
select sum(sal) from emp where deptno=30;   --9400
select sum(sal) from emp where deptno=40;   --null

-- avg(): 평균값을 구해주는 함수
select avg(sal) from emp;
select avg(sal), avg(comm) from emp;
select avg(sal), avg(comm) from emp where deptno = 10;
select avg(sal), avg(comm) from emp where deptno = 20;
select avg(sal), avg(comm) from emp where deptno = 30;

-- max() : 최대값을 구해주는 함수
--Q1.사원 테이블에서 최대 급여 금액을 구해보자?
select max(sal) from emp;   -- 5000

select max(sal) from emp where deptno = 10;  -- 5000
select max(sal) from emp where deptno = 20;  -- 3000
select max(sal) from emp where deptno = 30;  -- 2850

--Q2.사원 테이블에서 최대급여와 최대급여를 받는 사원명을 출력하는 SQL문 작성?
select ename, max(sal) from emp;    -- 오류발생

--Q3.사원 테이블에서 가장 최근에 입사한 일사일을 출력하는 SQL문 작성?
select max(hiredate) from emp;      -- 87/07/13
select hiredate from emp order by hiredate desc;--내림차순 정렬(최근날짜순 정렬)

--Q4.사원 테이블에서 사원명이 알파벳으로 가장 나중에 나오는 사원명을 구하는 
--   SQL문 작성?
select max(ename) from emp;     --WARD
select ename from emp order by ename desc;--내림차순 정렬(사전역순 정렬)

-- min() : 최소값을 구해주는 함수
--Q1. 사원 테이블에서 최소 급여 금액을 구해보자?
select min(sal) from emp;   -- 800

select min(sal) from emp where deptno = 10; -- 1300
select min(sal) from emp where deptno = 20; -- 800
select min(sal) from emp where deptno = 30; -- 950 

--Q2. 사원 테이블에서 가장 먼저 입사한 입사일을 구하는 SQL문 작성?
select min(hiredate) from emp;  -- 80/12/17
select hiredate from emp order by hiredate asc;--오름차순정렬(이른날짜순 정렬)

--Q3. 사원 테이블에서 사원명이 알파벳으로 가장 먼저 나오는 사원명을 구하는 
--    SQL문 작성?
select min(ename) from emp;     -- ADAMS
select ename from emp order by ename asc;--오름차순 정렬(사전순 정렬)

-- 그룹 함수들은 같이 사용할 수 있다.
select sum(sal),avg(sal),max(sal),min(sal) from emp;
select sum(sal),avg(sal),max(sal),min(sal) from emp where deptno=10;
select sum(sal),avg(sal),max(sal),min(sal) from emp where deptno=20;
select sum(sal),avg(sal),max(sal),min(sal) from emp where deptno=30;

-- count() : 총 데이터 갯수를 구해주는 함수
-- 형식 : count(컬럼명)
select count(sal) from emp;  -- 14
select count(mgr) from emp;  -- 13 : null값은 counting을 하지 않는다.
select count(comm) from emp; -- 4 : null값은 counting을 하지 않는다.
select count(deptno) from dept;-- 4 : deptno컬럼은 기본키 제약조건이 설정되어 있다.
select count(empno) from emp;-- 14 : empno컬럼은 기본키 제약조건이 설정되어 있다.
select count(*) from emp;    -- 14 : 모든 데이터 갯수를 구해준다.

--Q1. 사원 테이블에서 중복행을 제거한 JOB의 갯수를 구하는 SQL문 작성?
--1) job의 갯수 구하기?
select count(job) from emp;    -- 14 : 중복 데이터도 counting을 한다.
select job from emp;
select distinct job from emp;  -- 중복행을 제거한 job출력 : 5가지 job출력
--2) 중복행을 제거한 job의 갯수 구하기?
select count(distinct job) from emp; -- 5

--Q2. 30번 부서 소속 사원 중에서 커미션을 받는 사원수를 구하는 SQL문 작성?
select count(comm) from emp where deptno = 30;  -- 4
----------------------------------------------------------------------
-- group by : 특정 컬럼을 기준으로 테이블에 존재하는 데이터를 그룹으로 구분하여
--            처리해주는 역할을 한다.

--Q.각 부서(10,20,30)의 급여합, 평균급여, 최대급여, 최소급여를 구하는 SLQ문 작성?
select sum(sal),avg(sal),max(sal),min(sal) from emp where deptno=10;
select sum(sal),avg(sal),max(sal),min(sal) from emp where deptno=20;
select sum(sal),avg(sal),max(sal),min(sal) from emp where deptno=30;

-- 그룹함수와 일반컬럼은 같이 사용할 수 없지만, 예외적으로 group by절에 사용되는
-- 컬럼은 그룹합수와 같이 사용할 수 있다.
select deptno, sum(sal),avg(sal),max(sal),min(sal) from emp
    group by deptno order by deptno asc;
    
--Q1.job컬럼을 기준으로 급여의 합, 평균급여, 최대급여, 최소급여를 구하는
--   SQL문 작성?
select job, sum(sal), avg(sal), max(sal), min(sal) from emp
    group by job;

--Q2. 각 부서별(10,20,30) 사원수와 커미션을 받는 사원수를 구하는 SQL문 작성?
select deptno, count(*) 사원수, count(comm) 커미션 from emp
    group by deptno order by deptno asc;

-- having 조건절
-- : group by절이 사용되는 경우에 데이터 제한을 가하기 위해서 where 조건절
--   대신에 having 조건절을 사용해야 한다.

--Q1. 각 부서별(10,20,30) 평균급여 금액이 2000 이상인 부서만 출력하는 SQL문 작성?

-- 1)각 부서별 평균급여 금액 출력
select deptno, avg(sal) from emp group by deptno; 
--30	1566.666666666666666666666666666666666667
--20	2175
--10	2916.666666666666666666666666666666666667

--2) 평균급여 금액이 2000 이상인 부서만 출력
select deptno, avg(sal) from emp group by deptno
    where avg(sal) >= 2000;     -- 오류발생
 
 -- group by절이 사용되는 경우에는 having 조건절을 사용해야 한다.   
select deptno, avg(sal) from emp group by deptno
    having avg(sal) >= 2000;
    
--Q2. 각 부서별(10,20,3) 최대급여 금액이 2900 이상인 부서만 출력하는 SQL문 작성?
--1) 각 부서별 최대급여 금액 출력
select deptno, max(sal) from emp group by deptno;
--30	2850
--20	3000
--10	5000

--2) 최대급여 금액이 2900 이상인 부서만 출력
select deptno, max(sal) from emp group by deptno
    where max(sal) >= 2900;    -- 오류발생

 -- group by절이 사용되는 경우에는 having 조건절을 사용해야 한다. 
select deptno, max(sal) from emp group by deptno
    having max(sal) >= 2900;

-- 230818 과제
-- 1.
SELECT ENAME
FROM EMP
WHERE HIREDATE = (
	SELECT MAX(HIREDATE)
	FROM EMP
);

-- 2.
SELECT ENAME, SAL 
FROM EMP
WHERE SAL = (
	SELECT MAX(SAL)
	FROM EMP
)