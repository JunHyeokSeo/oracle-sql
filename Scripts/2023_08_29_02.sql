--2023.08.29(화)

-- 저장 프로시저

--[실습]
drop table emp01 purge;
create table emp01 as select * from emp;    --복사본 테이블 생성
select * from emp01;

--1. 저장 프로시저 생성
create or replace procedure del_all
is
begin
    delete from emp01;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
exec del_all;
execute del_all;

--4. 프로시저 실행 확인
select * from emp01;    -- 프로시저에 의해서 데이터가 모두 삭제됨

rollback;
insert into emp01 select * from emp;
-----------------------------------------------------------------
-- 매개변수가 있는 프로시저
-- 매개변수의 MODE가 in으로 되어있는 프로시저
-- in : 매개변수로 값을 받는 역할
--1. 매개변수가 있는 프로시저 생성
create or replace procedure del_ename(vename in emp01.ename%type)
is
begin
    delete from emp01 where ename = vename;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
execute del_ename('SCOTT');
execute del_ename('KING');
execute del_ename('SMITH');

--4. 프로시저 실행확인
select * from emp01;
----------------------------------------------------------
-- 매개변수의 MODE가 in, out 으로 되어있는 프로시저
-- in : 매개변수로 값을 받는 역할
-- out : 매개변수로 값을 돌려주는 역할

--Q. 프로시저의 매개변수에 사원번호를 전달해서, 그 사원의 사원명, 급여, 직책을
--   구하는 프로시저를 생성하고 실행하세요?
--1. 프로시저 생성
create or replace procedure sal_empno(
    vempno in emp.empno%type,       -- 사원번호
    vename out emp.ename%type,      -- 사원명
    vsal out emp.sal%type,          -- 급여
    vjob out emp.job%type)          -- 직책
is
begin
    select ename, sal, job into vename, vsal, vjob from emp
        where empno = vempno;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 바인드 변수 : 프로시저를 실행할때 결과를 돌려받는 변수
variable var_ename varchar2(12);
variable var_sal number;
variable var_job varchar2(10);

--4. 프로시저 실행
execute sal_empno(7788, :var_ename, :var_sal, :var_job); 
execute sal_empno(7839, :var_ename, :var_sal, :var_job);

--5. 바인드 변수로 돌려받은 값 출력
print var_ename;
print var_sal;
print var_job;
----------------------------------------------------------------
-- 자바 프로그램으로 프로시저 실행

--예1. 매개변수가 없는 프로시저
--1. 프로시저 생성
create or replace procedure del_all
is
begin
   delete from emp01; 
end;

--2. emp01 테이블 생성
drop table emp01 purge;
create table emp01 as select * from emp;
select * from emp01;

rollback; -- 자바 프로그램에서 정상적인 종료( con.close())가 되어서, 
          -- 삭제된 데이터를 복구할 수 없다. 

--예2. 매개변수가 있는 프로시저 
-- 서브쿼리로 emp01테이블에 데이터 입력
insert into emp01 select * from emp;
select * from emp01;

--1. 프로시저 생성
create or replace procedure del_ename(vename in emp01.ename%type)
is
begin
    delete from emp01 where ename = vename;
end;

-- 자바 프로그램으로 del_ename 프로시저 실행 해보자?

--2. 프로시저 실행 결과 확인
select * from emp01;


--예3. 매개변수의 MODE가 in, out으로 되어있는 저장 프로시저
--1. 저장 프로시저 생성
create or replace procedure sel_customer(
    vname in customer.name%type,
    vemail out customer.email%type,
    vtel out customer.tel%type)
is
begin
    select email, tel into vemail, vtel from customer
        where name = vname;
end;

--2. 프로시저 목록 확인
select * from user_source;

select * from customer;

--3. 바인드 변수 생성
variable var_email varchar2(20);
variable var_tel varchar2(20);

--4. 프로시저 실행
execute sel_customer('홍길동', :var_email, :var_tel);
execute sel_customer('안화수', :var_email, :var_tel);

--5. 바인드 변수로 받은 결과 출력
print var_email;
print var_tel;

-- 자바 프로그램으로 sel_customer 프로시저 실행 해보자?
---------------------------------------------------------------------
--저장 함수
--: 저장 함수는 저장 프로시저와 유사한 기능을 수행하지만, 실행 결과를 돌려주는
--  역할을 한다.

--Q1. 사원 테이블에서 특정 사원의 급여를 200% 인상한 결과를 돌려주는 저장함수를
--    생성하세요?
--1. 저장 함수
create or replace function cal_bonus(vempno in emp.empno%type)
    return number                   -- 돌려줄 값의 자료형
is
    vsal number(7,2);               -- 로컬변수
begin
    select sal into vsal from emp where empno = vempno;
    return vsal * 2;                -- 급여를 200% 인상한 결과를 돌려준다.
end;
 
--2. 저장함수 목록 확인
select * from user_source;

--3. 바인드 변수 생성
variable var_res number;

--4. 저장 함수 실행
execute :var_res := cal_bonus(7788);
execute :var_res := cal_bonus(7900);

--5. 바인드 변수로 돌려받은 값 출력
print var_res;

-- 저장함수를 SQL문에 포함 시켜서 실행
select ename, sal, cal_bonus(7788) from emp where empno = 7788;
select ename, sal, cal_bonus(7900) from emp where empno = 7900;