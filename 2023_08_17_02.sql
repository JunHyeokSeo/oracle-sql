-- 2023.08.17(목)

select 10+20 from dept;     -- 4개 출력
select 10+20 from emp;      -- 14개 출력

-- dual 테이블
--1. dual 테이블은 sys 계정 소유의 테이블이고, 공개 동의어로 설정 되어 있다.
--2. dual 테이블은 공개가 되어 있기 때문에 누구나 사용할 수 있다.
--3. dual 테이블은 데이터가 1개 밖에 없기 때문에, 연산결과를 1번만 출력한다.

select 10+20 from dual;     -- 1개 출력 : dual 공개 동의어
select 10+20 from sys.dual;

desc dual;                  -- dummy 컬럼 1개 있음.
--DUMMY    VARCHAR2(1) 

select * from dual;         -- X 데이터 1개 있음.

select * from sys.tab;
select * from tab;          -- tab : 공개 동의어

--1.숫자 처리 함수
-- abs() : 절대값을 구해주는 함수
--         함수명은 대,소문자를 구분하지 않는다.
select -10, abs(-10), ABS(-10) from dual;

-- floor() : 소숫점 이하를 버리는 역할
select 34.5678, floor(34.5678) from dual;

-- round() : 특정 자리에서 반올림을 해주는 함수
-- round( 대상값, 자리수 )
select 34.5678, round(34.5678) from dual; -- 35 : 소수 첫째자리에서 반올림
select 34.5678, round(34.5678,2) from dual;-- 34.57 : 소수 셋째자리에서 반올림
select 34.5678, round(34.5678,-1) from dual;--30
select 34.5678, round(35.5678,-1) from dual;--40

-- trunc() : 특정 자리에서 잘라내는(버리는) 역할
-- trunc( 대상값, 자리수 )
select trunc(34.5678), trunc(34.5678,2), trunc(34.5678,-1) from dual;
--           34	             34.56	            30

-- mod() : 나머지를 구해주는 함수
select mod(27, 2), mod(27, 5), mod(27, 7) from dual;
--          1	        2	         6

--Q. 사원 테이블에서 사원번호가 홀수인 사원들을 출력하는 SQL문 작성?
select ename, empno from emp where mod(empno, 2) = 1;
-------------------------------------------------------------------
--2.문자 처리 함수

-- upper() : 대문자로 변환해주는 함수
select 'Welcome to Oralce', upper('Welcome to Oralce') from dual;

-- lower() : 소문자로 변환해주는 함수
select 'Welcome to Oralce', lower('Welcome to Oralce') from dual;

-- initcap() : 각 단어의 첫글자만 대문자로 변환해주는 함수
select 'Welcome to Oralce', initcap('welcome to oralce') from dual;

--Q. 사원 테이블에서 job이 manager 인 사원을 검색하는 SQL문 작성?
select * from emp where job = 'manager';      -- 검색안됨
select * from emp where lower(job) = 'manager';
select * from emp where job = upper('manager');

-- length() : 문자열의 길이를 구해주는 함수(글자수)
select length('oracle'), length('오라클') from dual;
--               6	           3

-- lengthb() : 문자열의 길이를 바이트로 구해주는 함수
-- 영문 1글자 : 1Byte, 한글 1글자 : 3Byte
select lengthb('oracle'), lengthb('오라클') from dual;
--            6              	9

-- substr() : 문자열의 일부를 추출할때 사용되는 함수
-- 형식 : substr( 대상문자열, 시작위치, 추출할 문자갯수 )
--       추출할 시작번호는 왼쪽부터 1번부터 시작한다.

select substr('Welcome to Oracle', 4, 3) from dual; --com 출력
select substr('Welcome to Oracle', -4, 3) from dual;--acl 출력
select substr('Welcome to Oracle', -6, 3) from dual;--Ora 출력

--Q1. 사원테이블에서 입사일(hiredate)을 년, 월, 일을 추출하는 SQL문 작성?
select substr(hiredate, 1, 2) as "년",
       substr(hiredate, 4, 2) as "월",
       substr(hiredate, 7, 2) as "일" from  emp;
       
--Q2. 사원 테이블에서 87년도에 입사한 사원을 검색하는 SLQ문 작성?
select * from emp where substr(hiredate,1,2) = '87';

--Q3. 사원 테이블에서 사원명이 E로 끝나는 사원을 검색하는 SQL문 작성?(2가지 방법)
select * from emp where ename like '%E';
select * from emp where substr(ename, -1, 1) = 'E';

select to_char(hiredate, 'YYYY/MM/DD') as HIREDATE from emp;
select nvl(to_char(mgr), 'CEO') as MGR from emp where mgr is null;
