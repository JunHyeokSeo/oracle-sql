--2023.08.16
--테이블 목록
select * from tab;

--DEPT : 부서 테이블
--EMP : 사원 테이블
--BONUS : 상여금
--SALGRADE : 급여등급

--dept 테이블 구조 확인
describe dept;
desc dept;

--dept 데이터 검색 : SQL문은 대소문자를 구분하지 않음
select * from dept;
SELECT * from dept;

--EMP 테이블 구조 확인
desc emp;

--EMP 테이블 검색
select * from emp;

--select SQL
select * from dept;

select loc, dname, deptno from dept;

select * from emp;

select empno, ename, sal from emp;

-- 산술 연산
select sal + comm from emp;

select sal + 100 from emp;
select sal - 100 from emp;
select sal * 100 from emp;
select sal / 100 from emp;

-- 연봉계산
select sal * 12 + nvl(comm, 0) from emp;
select ename, job, sal, comm, sal * 12 + comm, sal * 12 + nvl(comm, 0) from emp;

--별칭부여
select ename, sal*12+nvl(comm, 0) as "Annsal" from emp;
select ename, sal*12+nvl(comm, 0) "Annsal" from emp;
select ename, sal*12+nvl(comm, 0) Annsal from emp;

--한글별칭
select ename, sal*12+nvl(comm, 0) as "연봉" from emp;
select ename, sal*12+nvl(comm, 0) "연봉" from emp;
select ename, sal*12+nvl(comm, 0) 연봉 from emp;

--띄어쓰기
select ename, sal*12+nvl(comm, 0) "연 봉" from emp; --띄어쓰기 가능
--select ename, sal*12+nvl(comm, 0) 연 봉 from emp; --따옴표 미사용 시, 오류 발생

--Concatenation 연산자 : ||
select ename || ' is a ' || job from emp;

--distinct : 중복제거
select distinct deptno from emp;

--EMP 테이블에서 각 사원들의 job을 한번씩만 출력
select distinct job from emp;

--EMP 테이블에서 중복을 제거한 job의 개수를 구함
select count(distinct job) cnt from emp;

--where 조건절 : 비교 연산자
--1. 숫자
select * from emp where sal >= 3000;
select * from emp where sal = 3000;
select * from emp where sal != 3000;
select empno, ename, sal from emp where sal <= 1500;

--2. 문자 (대소문자 구분, 외따옴표 사용)
--select * from emp where ename='ford';
--select * from emp where ename=FORD;
--select * from emp where ename="FORD";
select * from emp where ename='FORD';

select empno, ename, sal from emp where ename='SCOTT';

--3. 날짜 (숫자처럼 대소비교 가능, 단 외따옴표 필요)
--select * from emp where hiredate >= 82/01/01; --오류발생
select * from emp where hiredate >= '82/01/01';
select * from emp where hiredate >= '1982/01/01';

select * from emp where hiredate >= '82/01/01' order by hiredate asc;
