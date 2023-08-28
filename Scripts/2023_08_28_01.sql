-- 2023.08.28(월)

-- 사용자 정의 롤 생성 : 롤에 객체권한을 부여
--1. 롤 생성
conn system/oracle
create role mrole02;

--2. 생성된 롤에 객체 권한을 부여한다.
conn scott/tiger
grant select on emp to mrole02;

--3. user05 계정에게 mrole02를 부여한다.
conn system/oracle
grant mrole02 to user05;

--4. user05 계정으로 접속 후에 검색을 해보자?
conn user05/tiger
select * from scott.emp;
------------------------------------------------
-- 디폴트 롤을 생성해서 여러 사용자에게 롤 부여하기
-- 디폴트 롤 =  시스템 권한 + 객체 권한

--1. 디폴트 롤 생성
conn system/oracle
create role def_role;

--2. 생성된 롤(def_role)에 시스템 권한을 추가
conn system/oracle
grant create session, create table to def_role;

--3. 생성된 롤(def_role)에 객체 권한을 추가
conn scott/tiger
grant select on emp to def_role;
grant update on emp to def_role;
grant delete on emp to def_role;

--4. 롤을 적용하기 위한 일반 계정 생성
conn system/oracle
create user usera1 identified by tiger;
create user usera2 identified by tiger;
create user usera3 identified by tiger;

--5. def_role을 생성된 계정에게 부여하기
conn system/oracle
grant def_role to usera1;
grant def_role to usera2;
grant def_role to usera3;

--6. usera1 계정으로 접속후에 검색을 해보자?
conn usera1/tiger
conn usera2/tiger
conn usera3/tiger

select * from scott.emp;    -- 검색 가능함
----------------------------------------------
-- 동의어(synonym) : 같은 의미를 가진 단어.
--1. 비공개 동의어
--   : 객체에 대한 접근 권한을 부여받은 사용자가 정의한 동의어로써 
--     동의어를 만든 사용자만 사용할 수 있다.

--2. 공개 동의어
--  : DBA 권한을 가진 사용자만 생성할 수 있으며, 누구나 사용할 수 있다.

-- 공개 동의어의 예
-- sys.tab   --->  tab       select * from tab;
-- sys.seq   --->  seq       select * from seq;
-- sys.dual  --->  dual      select 10+20 from dual;
---------------------------------------------------------------
-- 비공개 동의어 예
--1. system 계정으로 접속후 테이블 생성
conn system/oracle
create table systbl(ename varchar2(20));

--2. 생성된 테이블에 데이터 추가
conn system/oracle
insert into systbl values('홍길동');
insert into systbl values('안화수');

select * from systbl;

--3. scott 계정에게 systbl 테이블에 대한 select 객체 권한 부여한다.
conn system/oracle
grant select on systbl to scott;

--4. scott 계정으로 접속후에 검색을 해보자?
conn scott/tiger
select * from systble;          -- 오류발생
select * from system.systbl;    -- 정상적인 검색 가능함.

--5. scott 계정에게 동의어를 생성할 수 있는 권한을 부여한다.
conn system/oracle
grant create synonym to scott;

--6. scott 계정으로 접속후에 비공개 동의어 생성 
--   system.systbl ---> systbl : 비공개 동의어
conn scott/tiger
create synonym systbl  for  system.systbl;

--7. 동의어 목록
conn scott/tiger
select * from user_synonyms;

--8. 동의어를 이용해서 검색을 해보자?
conn scott/tiger
select * from system.systbl;
select * from systbl;           -- 비공개 동의어로 검색함.

--9. 비공개 동의어 삭제
-- 형식 : drop synonym  synonym_name;
conn scott/tiger
drop synonym systbl;

-- 공개 동의어
--1. DBA 계정으로 접속해서 공개 동의어를 생성할 수 있다.
--2. 공개 동의어를 만들때는 public을 붙여서 생성할 수 있다.

--공개 동의어 생성
conn system/oracle
create public synonym pubdept for scott.dept;

--공개 동의어 목록 
select * from dba_synonyms;

--공개 동의어 삭제
conn system/oracle
drop public synonym pubdept;







