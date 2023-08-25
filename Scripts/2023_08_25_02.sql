-- 2023.08.25(금)

-- 객체 권한
-- 오라클의 객체 : 테이블, 뷰, 시퀀스, 인덱스, 동의어, 프로시저, 트리거

--1. 새로 생성된 user01 계정에게 scott 계정 소유의 EMP 테이블 객체에 대한
--   SELECT 객체 권한을 부여해보자?
conn scott/tiger
grant select on emp to user01;

--2. user01 계정으로 접속후 EMP 테이블 객체에 대해서 select를 실행 해보자?
conn user01/tiger
select * from emp;          -- 오류발생
select * from scott.emp;    -- 검색 가능함

--3. 객체 권한 취소
revoke select on emp from user01;

-- 객체 권한이 취소 되었기 때문에 오류발생
conn user01/tiger
select * from scott.emp;    --오류 발생
 
-- with grant option
--: user02 계정에게 scott 계정 소유의 EMP 테이블 객체에 대해서 SELECT 객체
--  권한을 부여할때 with grant option을 붙여서 권한이 부여되면, user02계정은
--  자기가 부여받은 권한을 제 3의 계정(user01)에게 재부여할 수 있다.
--1. user02 계정에게 scott 계정 소유의 EMP 테이블 객체에 대한 select객체권한을
--   부여해보자?
conn scott/tiger
grant select on emp to user02 with grant option;

--2. user02 계정으로 접속후, user01 계정에게 자기가 부여받은 객체권한을 
--   재부여 해보자?
conn user02/tiger
select * from scott.emp;        -- 검색 가능함

grant select on scott.emp to user01;

--3. user01 계정으로 접속후 검색을 해보자?
conn user01/tiger
select * from scott.emp;        -- 검색 가능함.






