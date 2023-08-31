-- 2023.08.30(수)

-- 과제.
--    Q1. 전산실에 새로 입사한 사원에게 새로운 계정을 생성해 주려고 
--        합니다.아래의 요구 사항을 만족하는 SQL문을 각각 작성 하세요 ? 
   
--    [요구1] USER명 : woman, 패스워드 : tiger 
--    [요구2] CREATE SESSION 이라는 시스템 권한을 부여해 줍니다. 
-- 	  (단, 또 다른 유저에게도 권한을 줄 수 있도록 
-- 	      WITH ADMIN OPTION을 부여합니다). 
--    [요구3] woman유저에게 connect, resource, dba 권한을 부여합니다.

--    Q2. user01 계정을 생성 하세요? (비밀번호: tiger)

--    Q3. user01 계정에게 오라클 데이터 베이스에 접속해서, 테이블을 생성
-- 	  할 수 있는 권한을 부여하시오.


-- Ans 1. SQL> create user woman identified by tiger;
--        SQL> grant create session to woman with admin option;
--        SQL> grant connect, resource, dba to woman;
-- Ans 2. SQL> create user user01 identified by tiger;
-- Ans 3. SQL> grant create session, create table to user01;
------------------------------------------------------------------
--과제.
--사원 테이블에서 사원명을 검색하여 사원의 직급을 구해오는 저장 프로시저를 
--만들어서 실행하세요?

--1. 저장 프로시저 생성
create or replace procedure ename_job(
        vename in emp.ename%type,
        vjob out emp.job%type)
is
begin
    select job into vjob from emp where ename = vename;
end;

--2. 프로시저 목록 확인
select * from  user_source;

--3. 바인드 변수 생성
variable var_job varchar2(10);

--4. 프로시저 실행
execute ename_job('SCOTT', :var_job); 
execute ename_job('KING', :var_job); 
execute ename_job('SMITH', :var_job); 

--5. 바인드 변수로 받은 값 출력
print var_job;

--6. dbeaver 프로시저 실행
DECLARE
	var_job varchar2(10);
BEGIN
	ename_job('KING', var_job);
	dbms_output.put_line(var_job);
END;
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

--Q2. 사원 테이블에서 사원명을 저장함수의 매개변수로 전달하여 해당 사원의 
--    직급(job)을 구해오는 저장함수를 생성하고, 실행하세요?
--1. 저장 함수 생성
create or replace function job_emp(vename in emp.ename%type)
    return varchar2           -- 돌려줄 값의 자료형
is
    vjob emp.job%type;        -- 로컬변수(사원명으로 검색한 사원의 job저장)
begin
    select job into vjob from emp where ename = vename;
    return vjob;
end;

--2. 저장 함수 목록 확인
select * from user_source;

--3. 바인드 변수 생성
variable var_job varchar2(10);

--4. 저장함수 실행
execute :var_job := job_emp('SCOTT');
execute :var_job := job_emp('KING');

--5. 바인드 변수에 저장된 결과 출력
print var_job;

-- 저장함수를 SQL문에 포함해서 실행
select ename, job_emp('SCOTT') from emp where ename = 'SCOTT';
select ename, job_emp('KING') from emp where ename = 'KING';

--dbeaver 함수 실행
DECLARE
	var_job varchar2(10);
BEGIN
	var_job := job_emp('KING');
	dbms_output.put_line(var_job);
END;
------------------------------------------------------------------
-- 커서(cursor)
-- : 2개 이상의 데이터를 처리할때 커서를 사용한다.

--Q1. 부서 테이블의 모든 데이터를 출력하기 위한 PL/SQL문 작성?
--1. 저장 프로시저 생성
create or replace procedure cursor_sample01
is
    vdept dept%rowtype;         -- 로컬변수
    cursor c1                   -- 커서 선언
    is
    select * from dept;
begin
    dbms_output.put_line('사원번호  /  부서명  /  지역명');
    dbms_output.put_line('--------------------------------');
    
    open c1;                    -- 커서 열기(첫번째 데이터를 가져온다.)
        loop
            fetch c1 into vdept.deptno, vdept.dname, vdept.loc;--인출
            exit when c1%notfound;--커서가 가져올 데이터가 없을때 true
			dbms_output.put_line(vdept.deptno||'/'||vdept.dname||'/'||vdept.loc);
        end loop;
    close c1;                   -- 커서 닫기    
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
execute cursor_sample01;
CALL CURSOR_SAMPLE01(); 

--Q2. 부서 테이블의 모든 데이터를 출력하는 PL/SQL문 작성?
--    For Loop문으로 처리
--    1. open ~ fetch ~ close 없이 처리할 수 없다.
--    2. for loop문을 사용하게 되면 각 반복문마다, cursor를 열고, 
--       각 행을 인출(fetch)하고, cursor를 닫는 작업을 자동으로 처리해 준다.

--1. 저장 프로시저 생성
create or replace procedure cursor_sample02
is
    vdept dept%rowtype;         -- 로컬변수
    
    cursor c1                   -- 커서 선언
    is
    select * from dept;
begin
    dbms_output.put_line('부서번호  /  부서명  /  지역명');
    dbms_output.put_line('---------------------------');
    
    for vdept in c1 loop
        exit when c1%notfound; --커서가 가져올 데이터가 없을때 true리턴
		dbms_output.put_line(vdept.deptno||'/'||vdept.dname||'/'||vdept.loc);
    end loop;
end;

--2. 저장 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
execute cursor_sample02;
CALL CURSOR_SAMPLE02(); 


--Q3. 사원테이블에서 부서번호를 전달하여 해당 부서에 소속된 사원의 정보를 
--    출력하는 프로시저를 커서를 이용해서 처리하세요?
--1. 저장 프로시저 생성
create or replace procedure info_emp(vdeptno in emp.deptno%type)
is
    vemp emp%rowtype;           -- 로컬변수
    
    cursor c1
    is
    select * from emp where deptno = vdeptno;
begin
      dbms_output.put_line('부서번호 / 사원번호 / 사원명 / 직급 / 급여');  
      dbms_output.put_line('--------------------------------------');
      
      for vemp in c1 loop
        exit when c1%notfound;
		dbms_output.put_line(vemp.deptno||'/'||vemp.empno||'/'||vemp.ename||'/'||vemp.job||'/'||vemp.sal);
      end loop;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
exec info_emp(10);
execute info_emp(20);
execute info_emp(30);
execute info_emp(40);

--4. DBeaver 실행
CALL INFO_EMP(10); 
CALL INFO_EMP(20); 
CALL INFO_EMP(30); 
CALL INFO_EMP(40); 

