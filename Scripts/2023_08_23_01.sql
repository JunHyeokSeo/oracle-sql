-- 2023.08.23(수)

--과제.
--      
--       Q1. SMITH와 동일한 직급을 가진 사원의 이름과 직급을 출력하는 
--           SQL문을 작성 하세요?
--
--       Q2. 직급이 'SALESMAN'인 사원이 받는 급여들의 최대 급여보다
-- 	         많이 받는 사원들의 이름과 급여를 출력하되 부서번호가 
--	         20번인 사원은 제외한다.(ALL연산자 이용)
--
--       Q3. 직급이 'SALESMAN'인 사원이 받는 급여들의 최소 급여보다 
-- 	         많이 받는 사원들의 이름과 급여를 출력하되 부서번호가 
--	         20번이 사원은 제외한다.(ANY연산자 이용)

Ans 1.
        SQL> select ename, job from emp where  
	         job = (select job from emp where ename='SMITH') --CLERK
                 and  ename != 'SMITH';	     

Ans 2. // 단일행 서브쿼리
        SQL> select ename, sal, deptno from emp where sal > 
	     (select max(sal)  from emp where job='SALESMAN') --1600
	     and deptno != 20;

         // 다중행 서브쿼리
        SQL> select ename, sal from emp where sal > all
	     (select sal from emp where job='SALESMAN') 
	     and deptno != 20;

Ans 3. // 단일행 서브쿼리
        SQL> select ename, sal from emp where sal > 
	     (select min(sal)  from emp where job='SALESMAN')--1250
	     and deptno != 20;

         // 다중행 서브쿼리
        SQL> select ename, sal from emp where sal > any
	     (select sal from emp where job='SALESMAN') 
	     and deptno != 20;
-------------------------------------------------------------------
-- 트랜잭션(Transaction)
--1. 논리적인 작업단위 
--2. 트랜잭션은 DML(insert,update,delete)SQL문으로 시작된다.
--3. 데이터의 일관성을 유지하면서, 데이터를 안정적으로 복구하기 위해서 사용이된다.
--4. 트랜잭션은 All-or-Nothing 방식으로 처리된다.

-- TCL(Transaction Control Language)
-- commit : 트랜잭션을 종료
-- rollback : 트랜잭션을 취소
-- savepoint : 복구할 시점(저장점)을 지정하는 역할

--[실습]
drop table dept01 purge;
create table dept01 as select * from dept;  --복사본 테이블 생성
select * from  dept01;

--1.rollback : 트랜잭션을 취소
 -- 새로운 트랜잭션이 시작되고, 메모리상에서만 delete가 실행된다.
delete from dept01;   

-- 트랜잭션을 취소하기 때문에, 메모리상에서 delete된 데이터가 복구된다.
rollback;

select * from  dept01;  -- 삭제된 데이터가 복구되어 있다.

--2. commit : 트랜잭션을 종료
--  : 메모리 상에서 처리된 DML SQL문을 데이터베이스에 영구적으로 반영하게 된다.
delete from dept01 where deptno=20; --메모리상에서 20번 데이터 삭제
commit; -- 트랜잭션 종료(메모리 상에서 삭제된 데이터를 DB에 반영해서 삭제한다.)
rollback;-- 트랜잭션이 종료 되었기 때문에 삭제된 20번 데이터는 복구할 수 없다.

-- 자동 커밋 : 자동으로 커밋이 수행되는 것.
-- 1) 정상적인 종료 : quit, exit, con.close()
-- 2) DDL(create, alter, rename, drop, truncate), DCL(grant, revoke)
--    명령이 수행될때

-- 예1. DDL 명령이 실행(create)
select * from dept01;   -- 10, 30, 40
delete from dept01 where deptno=40; --새로운 거래 시작 : 40번 데이터 삭제

create table dept03 as select * from dept;  --자동 커밋 수행(DDL)
rollback;     -- 삭제된 40번 데이터를 복구하지 못한다. 

-- 예2. DDL 명령이 실행(truncate)
-- delete(DML) : 데이터 복구 가능함
-- truncate(DDL) : 자동 커밋이 수행되기 때문에 데이터를 복구할 수 없다.
select * from dept01;   -- 10, 30

delete from dept01 where deptno=30;  -- 30번 부서 삭제
rollback;                            -- 삭제된 30번 데이터가 복구됨

select * from dept01;   -- 10, 30
truncate table dept01;        -- DDL(truncate) : 자동커밋 수행
rollback;                     -- 삭제된 dept01의 데이터를 복구할 수 없다.

-- 자동 롤백 : 자동으로 롤백이 수행되는 것.
-- : 비정상적인 종료 - 강제로 창을 닫는 경우, 컴퓨터가 다운되는 경우

-- savepoint : 임시 저장점을 지정할때 사용되는 명령

--[실습]
drop table dept01 purge;

--1. dept01 테이블 생성
create table dept01 as select * from dept;
select * from dept01;

--2. 40번 부서 삭제
delete from dept01 where deptno=40;

--3. commit 수행 : 트랜잭션 종료
commit;

--4. 30번 부서 삭제
delete from dept01 where deptno=30;

--5. c1 저장점 생성
savepoint c1;

--6. 20번 부서 삭제
delete from dept01 where deptno=20;

--7. c2 저장점 생성
savepoint c2;

--8. 10번 부서 삭제
delete from dept01 where deptno=10;

--9. c2 저장점까지 복구
rollback to c2;         -- 10번 부서 복구
select * from dept01;

--10. c1 저장점까지 복구
rollback to c1;         -- 10, 20번 부서 복구
select * from dept01;

--11. 이전 트랙잭션 종료 이후를 복구
rollback;               -- 10, 20, 30번 부서 복구
select * from  dept01;


