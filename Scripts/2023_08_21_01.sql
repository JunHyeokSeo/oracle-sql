-- 2023.08.21(월)

-- 조인(join)
-- : 2개 이상의 테이블을 결합해서 정보를 구해오는 것.

-- 조인의 필요성
--Q. SCOTT 사원이 소속된 부서명을 출력하는 SQL문 작성?
--1) 사원테이블(EMP)에서 SCOTT 사원의 부서번호를 구한다.
select deptno from emp where ename = 'SCOTT';   -- 20
--2) 부서테이블(DEPT)에서 20번 부서의 부서명을 구한다.
select dname from dept where deptno=20;         -- RESEARCH

-- CROSS JOIN
select * from dept, emp;       -- 4 * 14 = 56개의 데이터 검색
select * from emp, dept;       -- 14 * 4 = 56개의 데이터 검색

-- CROSS JOIN의 종류
--1. 등가조인(Equi Join)
--2. 비등가 조인(Non-Equi Join)
--3. 자체조인(Self Join)
--4. 외부조인(Outer Join)

--1. 등가 조인(Equi Join)
--   두개의 테이블에 동일한 컬럼을 기준으로 조인 하는 것.
select * from dept, emp where dept.deptno = emp.deptno;--14개 데이터 검색

--Q. SCOTT 사원이 소속된 부서명을 출력하는 SQL문 작성? (join사용)
select ename, dname from dept, emp 
    where dept.deptno = emp.deptno and ename = 'SCOTT';

--Q. SCOTT 사원이 소속된 부서번호, 부서명을 출력하는 SQL문 작성?
select deptno, ename, dname from dept, emp 
    where dept.deptno = emp.deptno and ename = 'SCOTT'; --오류발생
    
-- 공통컬럼(deptno)은 테이블.공통컬럼명 형식으로 출력해야 된다.
-- 공통컬럼이 아닌 컬럼들은 앞에 테이블명을 생략 할 수 있다.
select dept.deptno, ename, dname from dept, emp 
    where dept.deptno = emp.deptno and ename = 'SCOTT'; --정상적인 처리    

select emp.deptno, ename, dname from dept, emp 
    where dept.deptno = emp.deptno and ename = 'SCOTT'; --정상적인 처리

select dept.deptno, emp.ename, dept.dname from dept, emp 
    where dept.deptno = emp.deptno and emp.ename = 'SCOTT'; --정상적인 처리
    
-- 테이블에 별칭 부여하기
--1)테이블에 대한 별칭이 부여된 다음 부터는 테이블명을 사용할 수 없고,
--  별칭명만 사용해야 한다.
--2)별칭명은 대.소문자를 구분하지 않는다.
--3)공통컬럼(deptno)은 별칭명.공통컬럼명 형식으로 사용해야 한다.
--  ex) d.deptno, e.deptno
--4)공통컬럼이 아닌 컬럼들은 앞에 별칭명을 생략할 수 있다.

-- 테이블명에 별칭 부여
select d.deptno, e.ename, d.dname from dept d, emp e
    where d.deptno=e.deptno and e.ename = 'SCOTT';  -- 정상적인 처리

-- 오류발생 : 별칭명이 부여된 다음 부터는 더이상 테이블명을 사용할 수 없다.
select dept.deptno, e.ename, d.dname from dept d, emp e
    where d.deptno=e.deptno and e.ename = 'SCOTT';    

-- 별칭명은 대.소문자를 구분하지 않는다.
select d.deptno, e.ename, d.dname from dept D, emp E
    where d.deptno=e.deptno and e.ename = 'SCOTT';    
    
-- 일반 컬럼은 컬럼명 앞에 별칭명을 생략할 수 있다.    
select d.deptno, ename, dname from dept d, emp e
    where d.deptno=e.deptno and ename = 'SCOTT';  
    
--2. 비등가 조인(Non-Equi Join)
--   두개의 테이블에 동일한 컬럼없이 다른 조건을 이용해서 조인 하는것.

--Q. 사원 테이블에 있는 각 사원들의 급여가 몇 등급인지를 출력하는 SQL문 작성?
--   EMP(sal)  -  SALGRADE(grade)

select sal from emp;
select * from salgrade;
--1	 700	1200
--2	1201	1400
--3	1401	2000
--4	2001	3000
--5	3001	9999

select ename, sal, grade from emp, salgrade
    where sal >= losal and sal <= hisal;
    
select ename, sal, grade from emp, salgrade
    where sal between losal and hisal;
    
select e.ename, e.sal, s.grade from emp e, salgrade s  --별칭부여
    where e.sal between s.losal and s.hisal;  
    
--3. 자체조인(Self Join)
--   한개의 테이블 내에서 컬럼과 컬럼 사이의 관계를 이용해서 조인하는것.

--Q. 자체조인(Self Join)을 이용해서 사원 테이블의 각 사원들의 사원명과
--   매니저(직속상사)를 출력하는 SQL문 작성?
--   EMP(empno)  -  EMP(mgr)
 
select employee.ename || '의 상사는 ' || manager.ename
 from emp employee, emp manager where employee.mgr=manager.empno;
 
--4. 외부조인(Outer Join)
--   조인 조건을 만족하지 않는 데이터를 출력해주는 조인.
--1) 테이블을 조인할때 어느 한쪽의 테이블에는 데이터가 존재하지만, 다른 테이블에는
--   데이터가 존재하지 않는 경우에, 그 데이터가 출력되지 않는 문제를 해결하기
--   위해서 사용되는 조인 방법이다.
--2) 정보가 부족한 곳에 (+)를 추가한다.

--Q1. 위의 자체조인(Self Join)의 결과, KING 사원은 직속상사가 없기 때문에
--    출력되지 않았는데, KING 사원도 외부조인을 이용해서 출력 해보세요?

select employee.ename || '의 상사는 ' || manager.ename
 from emp employee, emp manager where employee.mgr=manager.empno(+);

--Q2. 부서테이블(DEPT)과 사원테이블(EMP)을 등가조인을 하면 40번 부서가 나타나지
--    않기 때문에, 외부조인을 이용해서 40번 부서도 나타나도록 처리하세요?

--1) DEPT - EMP 테이블을 등가조인 : 40번 부서가 출력안됨
select d.deptno, ename, dname from dept d, emp e
    where d.deptno=e.deptno order by deptno asc;
--2) 외부조인 : 출력되지 않는 40번 부서를 출력해주는 조인
select d.deptno, ename, dname from dept d, emp e
    where d.deptno=e.deptno(+) order by deptno asc;
    
---------------------------------------------------------------------
-- ANSI JOIN
-- ANSI(미국 표준협회) 표준안에 따라서 만들어진 join방법

-- ANSI CROSS JOIN
select * from dept cross join emp;  -- 4 * 14 = 56개 데이터 검색
select * from emp cross join dept;  -- 14 * 4 = 56개 데이터 검색

-- ANSI INNER JOIN : 등가조인과 같은 의미를 가지고 있는 조인방법
--Q. SCOTT 사원이 소속된 부서명을 출력하는 SQL문을 ANSI INNER JOIN으로 
--   작성 하세요?
select ename, dname from dept inner join emp
    on dept.deptno = emp.deptno where ename = 'SCOTT';

-- using을 이용해서 조인
select ename, dname from dept inner join emp
    using(deptno) where ename = 'SCOTT';

-- ANSI NATURAL JOIN
-- DEPT와 EMP 테이블 사이의 공통 컬럼이 같다는 의미를 가지고 있다.
select ename, dname from dept natural join emp where ename = 'SCOTT';
-------------------------------------------------------------------------
-- ANSI OUTER JOIN
-- 형식 : select * from table1 [left | right | full] outer join table2;

--1. dept01 테이블 생성
create table dept01( deptno number(2), dname varchar2(14) );
insert into dept01 values(10, 'ACCOUNTING');
insert into dept01 values(20, 'RESEARCH');
select * from dept01;

--2. dept02 테이블 생성
create table dept02( deptno number(2), dname varchar2(14) );
insert into dept02 values(10, 'ACCOUNTING');  
insert into dept02 values(30, 'SALES');
select * from dept02;

--3. left outer join : dept01 테이블 정보만 출력됨
select * from dept01 left outer join dept02 using(deptno);

--4. right outer join  : dept02 테이블 정보만 출력됨
select * from dept01 right outer join dept02 using(deptno);

--5. full outer join : dept01, dept02 테이블의 모든 정보가 출력됨
select * from dept01 full outer join dept02 using(deptno);