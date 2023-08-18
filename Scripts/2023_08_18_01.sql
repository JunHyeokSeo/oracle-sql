-- 2023.08.18(금)

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
select * from emp where hiredate>='87/01/01' and hiredate<='87/12/31';
select * from emp where hiredate between '87/01/01' and '87/12/31';

--Q3. 사원 테이블에서 사원명이 E로 끝나는 사원을 검색하는 SQL문 작성?(2가지 방법)
select * from emp where ename like '%E';
select * from emp where substr(ename, -1, 1) = 'E';

-- instr() : 특정 문자의 위치를 구해주는 함수
-- instr( 대상, 찾을문자 ) : 가장 먼저 나오는 문자의 위치를 찾아준다.
-- instr( 대상, 찾을문자, 시작위치, 몇번째 발견)
--Q1. 가장 먼저 나오는 'O'의 위치를 찾아준다.
select instr('Welcome to oracle', 'o') from dual;   -- 5

--Q2.6번 이후에 2번째 발견된 'o'의 위치를 찾아준다.
select instr('Welcome to oracle','o',6,2) from dual; -- 12

--Q3. 사원 테이블에서 사원명의 3번째 자리가 R로 되어있는 사원을 검색하는 SQL문 작성?
-- 3가지 방법 : like연산자, substr(), instr()
select * from emp where ename like '__R%';
select * from emp where substr(ename,3,1) = 'R';
select * from emp where instr(ename,'R') = 3;
select * from emp where instr(ename,'R',3,1) = 3;

-- lpad() / rpad() : 특정 기호를 채워주는 역할
select lpad('Oracle',20,'#') from dual; -- ##############Oracle
select rpad('Oracle',20,'#') from dual; -- Oracle##############

-- ltrim() : 왼쪽 공백을 삭제 해주는 함수
-- rtrim() : 오른쪽 공백을 삭제 해주는 함수
select '  Oracle   ', ltrim('   Oracle   ') from dual;
select '  Oracle   ', rtrim('   Oracle   ') from dual;

-- trim() : 문자열 좌.우측의 공백을 삭제 해주는 함수
--          특정 문자를 잘라내는 함수
select '  Oracle  ', trim('   Oracle   ') from dual;
select trim('a'  from 'aaaaaOracleaaaaa') from dual;
--------------------------------------------------------------------
--3.날짜 처리 함수

-- sysdate : 시스템의 날짜를 구해오는 함수
select sysdate from dual;   -- 23/08/18

select sysdate-1 어제, sysdate 오늘, sysdate+1 내일 from dual;

--Q. 사원 테이블에서 각 사원들의 현재까지 근무한 근무일수를 구하는 SQL문 작성?
select ename, sysdate - hiredate from emp;
select ename, round(sysdate - hiredate) from emp;--소수 첫째자리에서 반올림
select ename, trunc(sysdate - hiredate) from emp;--소숫점 자리를 버림

-- months_between() : 두 날짜 사이의 경과된 개월 수를 구해주는 함수
-- 형식 : months_between( date1, date2 )
--Q. 사원 테이블에서 각 사원들의 근무한 개월수를 구하는 SQL문 작성?
select months_between(sysdate, hiredate) from emp; --양수 개월수 출력
select months_between(hiredate,sysdate) from emp;  --음수 개월수 출력

select round(months_between(sysdate, hiredate)) from emp;
select trunc(months_between(sysdate, hiredate)) from emp;

-- add_months() : 특정 날짜에 경과된 날짜를 구해주는 함수
-- 형식 : add_months( date, 개월수 )
--Q1. 사원 테이블에서 각 사원들의 입사한 날짜에 6개월이 경과된 일자를 구하는
--    SQL문 작성?
select ename, hiredate, add_months(hiredate, 6) from emp;

--Q2. 우리과정 입과후에 6개월이 경과된 일자를 구하는 SQL문 작성?
--    2023.07.11 입과
select add_months('23/07/11', 6) from dual;

-- next_day() : 해당 요일의 가장 가까운 날짜를 구해주는 함수
-- 형식 : next_day( date, 요일 )
--Q. 오늘을 기준으로 가장 가까중 토요일이 언제인지를 구하는 SQL문 작성?
select sysdate, next_day(sysdate, '토요일') from dual;
select sysdate, next_day(sysdate, '월요일') from dual;

-- last_day() : 해당 달의 마지막 날짜를 구해주는 함수
--Q1. 각 사원들이 입사한 달의 마지막 날짜를 구하는 SQL문 작성?
select hiredate, last_day(hiredate) from emp;

--Q2. 이번달의 가장 마지막 날짜를 구하는 SQL문 작성?
select sysdate, last_day(sysdate) from dual;

--Q3. 2023년 2월달의 마지막 날짜를 구하는 SQL문 작성?
select last_day('23/02/01') from dual;   -- 23/02/28
select last_day('20/02/01') from dual;   -- 20/02/29
-------------------------------------------------------------------
--4.형변환 함수 
--  to_char() , to_date(), to_number()

--1. to_char() : 날짜형, 숫자형 데이터를 문자형으로 변환 해주는 함수

-- 1) 날짜형 데이터를 문자형으로 변환
--    형식 : to_char( 날짜 데이터, '출력형식' )
--Q1. 현재 시스템의 날짜를 연,월,일,시,분,초,요일로 출력
select sysdate from dual;       -- 23/08/18

select sysdate, to_char(sysdate,'YYYY/MM/DD am hh:mi:ss dy') from dual;
select sysdate, to_char(sysdate,'yyyy/mm/dd hh24:mi:ss day') from dual;

--Q2. 사원 테이블에서 각 사원들의 입사일을 연,월,일,시,분,초,요일로 출력하는
--    SQL문 작성?
select hiredate, to_char(hiredate,'yyyy/mm/dd hh24:mi:ss day') from emp;

-- 2) 숫자형 데이터를 문자형으로 변환
--  형식 : to_char( 숫자 데이터, '구분기호' )
--Q1. 숫자 1230000을 3자리씩 컴마로 구분해서 출력
select 1230000 from dual;

-- 0으로 자리수를 지정하면, 데이터의 길이가 9자리가 되지 않으면 0으로 채운다.
select 1230000, to_char(1230000, '000,000,000') from dual;--001,230,000 

-- 9로 자리수를 지정하면, 데이터의 길이가 9자리가 되지 않아도 채우지 않는다.
select 1230000, to_char(1230000, '999,999,999') from dual;--1,230,000

--Q2. 사원 테이블에서 각 사원들의 급여를 3자리씩 컴마(,)로 구분해서 출력하는
--    SQL문 작성?
select ename, sal, to_char(sal, '9,999') from emp;
select ename, sal, to_char(sal, 'L9,999') from emp;
select ename, sal, to_char(sal, '9,999L') from emp;


--2. to_date() : 문자형 데이터를 날짜형으로 변환 해주는 함수
--  형식 : to_date( '문자데이터', '날짜 format' )
--Q1. 2023년 1월 1일 부터 현재까지 경과된 일수를 구하는 SQL문 작성?
select sysdate - '2023/01/01' from dual;     -- 오류발생

select sysdate - to_date('2023/01/01', 'yyyy/mm/dd') from dual;
select round(sysdate - to_date('2023/01/01', 'yyyy/mm/dd')) from dual;
select trunc(sysdate - to_date('2023/01/01', 'yyyy/mm/dd')) from dual;

--Q2. 2023년 12월 25일 크리스마스까지 남은 일수를 구하는 SQL문 작성? 
select to_date('2023/12/25', 'yyyy/mm/dd') - sysdate from dual; 
select round(to_date('2023/12/25', 'yyyy/mm/dd') - sysdate) from dual;
select trunc(to_date('2023/12/25', 'yyyy/mm/dd') - sysdate) from dual;

--Q3. 우리과정 교육기간(2023.07.11 ~ 2024.01.19)의 교육일수를 구해보자?
select to_date('2024/01/19','yyyy/mm/dd')
     - to_date('2023/07/11','yyyy/mm/dd') from dual;
     
     
--3. to_number() : 문자형 데이터를 숫자형으로 변환 해주는 함수
--   형식 : to_number( '문자 데이터', '구분기호' )
select  '20,000' - '10,000' from dual;    -- 오류발생
select to_number('20,000','99,999')
                - to_number('10,000','99,999') from dual;
                
--과제.
--      Q1. 사원테이블(EMP)에서 입사일(HIREDATE)을 4자리 연도로 출력                                
--          되도록 SQL문을 작성하세요? (ex. 1980/01/01)
--
--     Q2. 사원테이블(EMP)에서 MGR컬럼의  값이  null 인 데이터의 MGR                              
--          컬럼의 값을  CEO 로  출력하는 SQL문을 작성 하세요? 

     Ans1. SQL> select  to_char(hiredate,'YYYY/MM/DD') from emp;

     Ans2. SQL> select ename, nvl(to_char(mgr,'9999'), 'CEO')  	         	                               
                    as	 MANAGER  from emp where mgr  is  null;
                
select * from emp where mgr is null;               
select nvl(mgr,0) from emp where mgr is null;               
select nvl(mgr,'CEO') from emp where mgr is null;    -- 오류발생               
select nvl(to_char(mgr),'CEO') from emp where mgr is null;     
select nvl(to_char(mgr,'9999'),'CEO') as MANAGER from emp 
    where mgr is null;      
    
-- NVL() : NULL값을 다른값으로 변환해주는 함수
--1.NULL값은 정해지지 않은 값을 의미
--2.NULL값은 산술연산(+,-,*,/)이 되지 않는다.

--Q. 사원 테이블에서 각 사원들의 연봉을 계산하는 SQL문 작성?
-- 연봉 = 급여(SAL) * 12 + 커미션(COMM)
-- NVL(COMM, 0) : COMM 컬럼값이 NULL인 데이터를 0으로 치환

select ename, sal*12 + nvl(comm, 0) as "연봉" from emp;
-------------------------------------------------------------
-- decode() : switch ~ case 구문과 유사
-- 형식 : decode ( 컬럼명, 값1, 결과1,
--                        값2, 결과2,
--                        값3, 결과3,
--                        값N, 결과N)
--Q.사원 테이블에서 부서번호(deptno)를 부서명으로 바꿔서 출력하는 SQL문 작성?
select ename, deptno, decode( deptno, 10, 'ACCOUNTING',
                                      20, 'RESEARCH',
                                      30, 'SALES',
                                      40, 'OPERATIONS') as dname from emp;
---------------------------------------------------------------------------                                 
-- case 함수 : if ~ else if 구문과 유사
-- 형식 : case  when  조건1  then  결과1  
--             when  조건2  then  결과2       
--             else  결과3
--        end

--Q. 사원 테이블에서 부서번호(deptno)를 부서명으로 바꿔서 출력하는 SQL문 작성?
select ename, deptno, case  when  deptno=10 then 'ACCOUNTING'
                            when  deptno=20 then 'RESEARCH'
                            when  deptno=30 then 'SALES'
                            when  deptno=40 then 'OPERATIONS'
                       end as dname from emp; 
    
    
