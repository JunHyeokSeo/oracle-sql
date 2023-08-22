-- 2023.08.22(화)

--DML(Data Manipulation Language, 데이터 조작어)
-- insert , update, delete

--1. insert : 데이터 입력
-- 1) 형식
--     insert into 테이블(컬럼1, 컬럼2,...) values(데이터1, 데이터2,...);
--     insert into 테이블 values(데이터1, 데이터2, ...);

--[실습]
drop table dept01 purge;

-- 비어있는 dept01 복사본 테이블 생성 - 테이블 구조만 복사
create table dept01 as select * from dept where 1=0;

select * from dept01;

insert into dept01(deptno, dname, loc) values(10,'ACCOUNTING','NEW YORK');
insert into dept01 values(20,'RESEARCH','DALLAS');
insert into dept01 values(30,'영업부','서울');

-- NULL 값 입력
insert into dept01(deptno, dname) values(40, '개발부');--loc컬럼 NULL
insert into dept01 values(50,'기획부',NULL);--loc컬럼 NULL
select * from dept01;

--2) 서브쿼리로 데이터 입력
drop table dept02 purge;

-- dept02 테이블 생성 : 테이블 구조만 복사
create table dept02 as select * from dept where 1=0;
select * from dept02;

-- 서브쿼리로 데이터 입력
insert into dept02 select * from dept;
insert into dept02 select * from dept02;

select count(*) from dept02;  -- 데이터 갯수 구하기

--3) insert all 명령문으로 다중 테이블에 데이터 입력
-- 2개의 테이블 생성
create table emp_hir as select empno, ename, hiredate from emp where 1=0;
create table emp_mgr as select empno, ename, mgr from emp where 1=0;

-- insert all 명령문으로 다중 테이블에 데이터 입력
insert all
        into emp_hir values(empno, ename, hiredate)
        into emp_mgr values(empno, ename, mgr)
        select empno, ename, hiredate, mgr from emp where deptno=20;

select * from emp_hir;
select * from emp_mgr;

--2. update : 데이터 수정
-- 형식 : update  테이블  set 컬럼1=수정할 값1,
--                           컬럼2=수정할 값2
--        where 조건절;

--[실습]
drop table emp01 purge;

--복사본 테이블 생성
create table emp01 as select * from emp;
select * from emp01;

--1) 모든 데이터 수정 : where 조건절을 사용하지 않음
--Q1. 모든 사원들의 부서번호를 30번 수정?
update emp01 set deptno = 30;

--Q2. 모든 사원들의 급여를 10% 인상?
update emp01 set sal = sal * 1.1;

--Q3. 모든 사원들의 입사일을 오늘 날짜로 수정?
update emp01 set hiredate = sysdate;

--2) 특정 데이터 수정 : where 조건절을 사용
drop table emp02 purge;

-- 복사본 테이블 생성
create table emp02 as select * from emp;
select * from emp02;

--Q1. 급여가 3000 이상인 사원만 급여를 10% 인상?
update emp02 set sal = sal * 1.1 where sal >= 3000;

--Q2.1987년도에 입사한 사원만 입사일을 오늘 날짜로 수정?
update emp02 set hiredate = sysdate where substr(hiredate,1,2)='87';
update emp02 set hiredate = sysdate 
    where hiredate >= '87/01/01' and hiredate <= '87/12/31';
update emp02 set hiredate = sysdate
    where hiredate between '87/01/01' and '87/12/31';

--Q3. SCOTT 사원의 입사일을 오늘 날짜로 수정하고, 급여를 50으로, 
--    커미션을 4000으로 수정?
update emp02 set hiredate=sysdate, sal=50, comm=4000 where ename='SCOTT';

--3) 서브쿼리를 이용한 데이터 수정
--Q. 20번 부서의 지역명(DALLAS)을 40번 부서의 지역명(BOSTON)으로 수정?
select * from dept;
--10	ACCOUNTING	NEW YORK
--20	RESEARCH	DALLAS
--30	SALES	    CHICAGO
--40	OPERATIONS	BOSTON

drop table dept01 purge;   
create table dept01 as select * from dept;  -- 복사본 테이블 생성    
select * from dept01;   

update dept01 set loc = (select loc from dept01 where deptno=40)
    where deptno = 20;    
  
       
--3. delete : 데이터 삭제
-- 형식 : delete from 테이블  where 조건절;

--1) 모든 데이터 삭제 : where 조건절을 사용하지 않는다.
select * from dept01;
delete from dept01;
rollback;           -- 트랜잭션 취소

--2) 조건절을 만족하는 데이터 삭제 : where 조건절을 사용 
--Q. dept01 테이블의 30번 부서만 삭제?
delete from dept01 where deptno = 30;
select * from dept01;

--3) 서브쿼리를 이용한 데이터 삭제
--Q. 사원테이블(emp02)에서 부서명이 SALES 부서의 사원을 삭제?
drop table emp02 purge;
create table emp02 as select * from emp;    -- 복사본 테이블 생성
select * from emp02;

delete from emp02 where deptno = 
    (select deptno from dept where dname = 'SALES');    -- 30
------------------------------------------------------------------
* 테이블 구조가 동일한 두 테이블의 MERGE 연습

  MERGE : 구조가 같은 2개의 테이블을 하나의 테이블로 합치는 기능.
  MERGE명령을 수행할때 기존에 존재하는 행(ROW)이 있으면 새로운     
  값으로 UPDATE되고, 존재하지 않으면 새로운 행(ROW)으로 추가된다.

drop table emp01 purge;
drop table emp02 purge;
select * from emp01;    -- 14개 데이터
select * from emp02;    --  3개 데이터

create table emp01 as select * from emp;

create table emp02 as select * from emp where job='MANAGER';

update emp02 set job='Test';

insert into emp02 values(8000, 'ahn', 'top', 7566, '2023/08/22',1200, 10, 20);

select * from emp02;

merge into emp01
	using emp02
	on(emp01.empno = emp02.empno)
	when matched then
	     update set emp01.ename = emp02.ename,
			emp01.job = emp02.job,
			emp01.mgr = emp02.mgr,
			emp01.hiredate = emp02.hiredate,
			emp01.sal = emp02.sal,
			emp01.comm = emp02.comm,
			emp01.deptno = emp02.deptno
	when not matched then
	     insert values(emp02.empno, emp02.ename, emp02.job, 		         	         
		          emp02.mgr,emp02.hiredate, 
		         emp02.sal, emp02.comm,emp02.deptno);

select * from emp01; (합병된 결과 확인)

DROP TABLE dept01 purge;
CREATE TABLE dept01 AS SELECT * FROM dept;
SELECT * FROM dept01;

DELETE FROM dept01;
ROLLBACK;
COMMIT;
DELETE FROM dept01 WHERE deptno=20;




-- 1.
SELECT ENAME, JOB FROM EMP WHERE JOB = (
	SELECT JOB FROM EMP WHERE ENAME = 'SMITH'
);
-- 2.
SELECT ENAME, SAL FROM EMP WHERE SAL > ALL (
	SELECT SAL  FROM EMP WHERE JOB = 'SALESMAN'
) AND DEPTNO != 20;
-- 3.
SELECT ENAME, SAL FROM EMP WHERE SAL > ANY (
	SELECT SAL  FROM EMP WHERE JOB = 'SALESMAN'
) AND DEPTNO != 20;