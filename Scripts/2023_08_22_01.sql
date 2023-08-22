-- 2023.08.22(화)

--과제.
--       Q1. 직급이 MANAGER인 사원의 이름, 부서명을 출력하는 SQL문을
--           작성 하세요? (JOIN을 사용하여 처리)   
--       Q2. 매니저가 KING 인 사원들의 이름과 직급을 출력하는 SQL문 작성?
--       Q3. SCOTT과 동일한 근무지에서 근무하는 사원의 이름을 출력하는 SQL문 작성?

Ans 1. 
       SQL> select ename, dname, job from emp, dept 
                  where emp.deptno=dept.deptno  and  job='MANAGER'; 

       SQL> select ename, dname from emp inner join dept 
                   on emp.deptno=dept.deptno  where  job='MANAGER'; 

       SQL> select ename, dname from emp inner join dept 
                     using(deptno)  where  job='MANAGER'; 

       SQL> select ename, dname from emp natural join dept 
                     where job='MANAGER'; 

Ans 2.
        SQL>  select employee.ename, employee.job 
                   from emp employee, emp manager
                   where employee.mgr=manager.empno and manager.ename='KING';

        SQL> select ename, job from emp where mgr = 
                 (select empno from emp where ename='KING');--7839

Ans 3.
        SQL> select deptno, ename from emp where deptno = 
              (select deptno from emp where ename = 'SCOTT');
-----------------------------------------------------------------
-- DDL(Data Definition Language) : 데이터 정의어
 -- create : 테이블 생성
 -- alter : 테이블 구조 변경
 -- rename : 테이블 이름 변경
 -- drop : 테이블 삭제
 -- truncate : 데이터 삭제
 
 -- 테이블 목록
 select * from tab;
 select * from user_tables;
 
 --1. create
 --  : 데이터베이스 생성, 테이블 생성
 
 -- 형식 : create table 테이블명 ( 컬럼명1   데이터타입1,
 --                              컬럼명2   데이터타입2,
 --                              컬럼명N   데이터타입N);
 
-- * 테이블명,컬럼명 명명 규칙
-- 
--1. 반드시 문자로 시작 해야함.
--2. 1~30자 까지 가능함.
--3. A~Z까지의 대소문자와 0~9까지의 숫자, 
--   특수기호는 (_, $, #)만 포함할 수 있음.
--4. 오라클에서 사용되는 예약어나 다른 객체명과 중복불가
--5. 공백허용 안됨. 
 
 -- 오라클의 데이터 타입
 --1) 숫자 데이터
 --   number(n) : 정수 n자리 까지 저장
 --   number(n1, n2) : n1:전체 자리수, n2:소숫점 이하에 할당된 자리수
 
 --2) 문자 데이터
 --   char() : 고정길이 문자형
 --            최대 2000byte 까지 저장 가능   
 --   varchar2() : 가변길이 문자형
 --                최대 4000byte 까지 저장 가능   
 --   long : 2GB 까지 저장 가능
 --          long 형으로 설정된 컬럼은 검색 기능을 지원하지 않는다.
 
 --3) 날짜 데이터
 --   date : 연/월/일  정보 저장
 --   timestamp : 연/월/일 시:분:초  정보 저장
 
-- 테이블 생성
--1) 직접 테이블 생성
create table emp01 ( empno number(4),
                     ename varchar2(20),
                     sal number(7,2));

select * from tab;      -- 테이블 목록 확인

--2) 서브쿼리로 테이블 생성
--   복사본 테이블이 생성된다.
--   단, 제약조건은 복사가 되지 않는다.

-- 복사본 테이블 생성
create table emp02 as select * from emp;

select * from tab;      -- 테이블 목록 확인
select * from emp02;

-- 원하는 컬럼으로 구성된 복사본 테이블 생성
create table emp03 as select empno, ename from emp;
select * from emp03;

-- 원하는 행(row, 데이터)으로 구성된 복사본 테이블 생성
create table emp04 as select * from emp where deptno=10;
select * from emp04;

-- 테이블 구조만 복사
create table emp05 as select * from emp where 1=0;
select * from emp05;

--2. alter
--  : 테이블 구조 변경 (컬럼추가, 컬럼수정, 컬럼삭제)

--1) 컬럼추가 : emp01 테이블에 job컬럼 추가
alter table emp01 add(job varchar2(10));
desc emp01;        -- 테이블 구조 확인

--2) 컬럼수정
--   i) 수정할 컬럼에 데이터가 없는 경우
--      컬럼의 데이터 타입을 변경할 수 있다.
--      컬럼의 크기를 변경할 수 있다.
--   ii) 수정할 컬럼에 데이터가 있는 경우
--       컬럼의 데이터 타입을 변경할 수 없다.
--       컬럼의 크기는 늘릴수는 있지만, 현재 저장된 데이터 크기보다 작은 크기로
--         변경할 수는 없다.

-- emp01 테이블의 job컬럼의 크기를 10에서 30으로 수정
alter table emp01 modify(job varchar2(30));
desc emp01;

--3) 컬럼삭제
alter table emp01 drop column job;
alter table emp01 drop(job);
desc emp01;

--3. rename
--   : 테이블 이름 변경
-- 형식 :  rename old_name to new_name;

--Q. emp01 테이블을 test 테이블명으로 이름을 변경 해보자?
rename emp01 to test;
select * from tab;

--4. truncate
--   : 테이블의 모든 데이터를 삭제
-- 형식 : truncate  table  table_name;
truncate table emp02;
select * from emp02;

--5. drop
--  : 테이블 삭제
-- 형식 : drop table table_name; (Oracle 10g 부터는 임시 테이블로 교체)
--       drop table table_name  purge; (완전하게 삭제)

--Q. test 테이블 삭제 해보자?
drop table test;
select * from tab;

-- 임시 테이블 삭제
purge recyclebin;
--------------------------------------------------------------------
* 오라클의 객체
  테이블, 뷰, 시퀀스, 인덱스, 동의어, 프로시저, 트리거


* 데이터 딕셔너리와 데이터 딕셔너리 뷰
  데이터 딕셔너리를 통해서 접근가능함

  - 데이터 딕셔너리 뷰 : user_xxxx
     (가상 테이블)      all_xxxx
                      dba_xxxx

  - 데이터 딕셔너리(시스템 테이블) : 

-- scott 계정 소유의 테이블 객체에 대한 정보를 검색
  select * from tab;
  select * from user_tables; (테이블)

  select * from user_views; (뷰)

  select * from seq;
  select * from user_sequences; (시퀀스)

  select * from user_indexes; (인덱스)

  select * from user_synonyms; (동의어)

  select * from user_source; (프로시저)

  select * from user_triggers; (트리거)

-- 자기 계정 소유 또는 권한을 부여 받은 객체에 대한 정보 검색
  select table_name from all_tables;

-- 데이터베이스 관리자(DBA)만 접근할 수 있는 객체에 대한 정보 검색
  select table_name from dba_tables; (DBA 계정만 사용가능)
 
-- 오라클 시스템의 모든 계정 정보 검색
  select username from dba_users; (DBA 계정만 사용가능)









