-- 2023.08.23(수)

-- 무결성 제약조건
-- : 테이블에 부적절한 데이터가 입력되는 것을 막기 위해서 테이블을 생성할때
--   각 컬럼에 대해서 정의하는 여러가지 규칙을 의미한다.
--   ex) not null, unique, primary key(기본키), foreign key(외래키)
--       check, default

--1. not null 제약조건
--  null 값을 허용하지 않는다.
--  반드시 값을 입력 해야 한다.

--[실습]
drop table emp02 purge;

create table emp02(
    empno number(4) not null,
    ename varchar2(12) not null,
    job varchar2(12),
    deptno number(2) );

select * from tab;
select * from emp02;

-- 제약조건에 위배되지 않는 데이터 입력
insert into emp02 values(1111,'홍길동','MANAGER',30);

-- 제약조건(NOT NULL)에 위배되기 때문에 데이터 입력이 되지 않는다.
insert into emp02 values(NULL,NULL,'SALESMAN',30);
insert into emp02(job, deptno) values('SALESMAN',30);

--2. unique 제약조건
--   유일한 값만 입력할 수 있다.
--   중복된 값을 입력할 수 없다.
--   null 값은 입력될 수 있다.

drop table emp03 purge;
create table emp03(
    empno number(4) unique,
    ename varchar2(12) not null,
    job varchar2(12),
    deptno number(2));
    
select * from emp03;

-- 정상적인 데이터 입력
insert into emp03 values(1111,'홍길동','개발자',10);
    
-- unique 제약조건에 위배되는 데이터 입력
insert into emp03 values(1111,'홍길동','개발자',20);

-- null값 입력 가능하다.
insert into emp03 values(NULL,'홍길동','개발자',20);
insert into emp03 values(NULL,'안화수','개발자',30);

--3. primary key (기본키) 제약조건
--   primary key = not null + unique
--   : 반드시 중복되지 않은 값을 저장 해야된다.
--  ex)  부서 테이블(DEPT) - deptno(pk)
--       사원 테이블(EMP)  - empno(pk)

--       게시판(board)    - 번호(no)  : pk
--       회원관리(member) - 아이디(id) : pk

-- 부서 테이블(DEPT) - deptno(pk)
select * from dept;
insert into dept values(10,'개발부','서울');  -- unique 제약조건에 위배
insert into dept values(NULL,'개발부','서울');-- not null 제약조건에 위배

-- 사원 테이블(EMP) - empno(pk)
select * from emp;
insert into emp(empno, ename) values(7788,'홍길동');-- unique 제약조건에 위배
insert into emp(empno, ename) values(NULL,'홍길동');-- not null 제약조건에 위배

drop table emp05 purge;
create table emp05(
    empno number(4) primary key, --반드시 중복되지 않은 값을 입력해야된다.
    ename varchar2(12) not null, --반드시 값을 입력해야 된다.
    job varchar2(12),
    deptno number(2));
    
select * from emp05;    
insert into emp05 values(1111,'홍길동','개발자',20);--정상적인 데이터 입력
insert into emp05 values(1111,'홍길동','개발자',20);--unique제약조건 위배
insert into emp05 values(NULL,'홍길동','개발자',20);--not null제약조건 위배

-- 제약조건 이름(constraint name)을 설정해서 테이블 생성
drop table emp04 purge;
create table emp04(
    empno number(4) constraint emp04_empno_uk unique,
    ename varchar2(10) constraint emp04_ename_nn not null,
    job varchar2(10),
    depnot number(2));
    
--4. foreign key (외래키) 제약조건
--  DEPT(부모테이블) - deptno(pk) : 부모키 : 10, 20, 30, 40
--  EMP(자식테이블)  - deptno(fk) : 외래키 : 10, 20, 30

--1) 사원테이블(EMP)의 deptno 컬럼이 foreign key 제약조건이 설정되어 있다.
--2) foreign key 제약조건이 가지고 있는 의미는 부모테이블(DEPT)의 
--   부모키(deptno)의 값만 참조할 수 있다.
--3) 부모키가 되기 위한 조건은 primary key나 unique 제약조건으로 설정되어
--   있어야 한다.
 
--Q. 사원테이블(EMP)에 새로운 신입사원을 등록 해보자?
-- 외래키(deptno)는 부모키(DEPT-deptno)안에 있는값(10,20,30,40)만 참조할수 있다.
insert into emp(empno, deptno) values(1111,50);--foreign key제약조건 위배

--[실습]
drop table emp06 purge;
create table emp06(
    empno number(4) primary key,
    ename varchar2(10) not null,
    job varchar2(10),
    deptno number(2) references dept(deptno) );

select * from emp06;
insert into emp06 values(1111,'홍길동','개발자',10);
insert into emp06 values(1112,'홍길동','개발자',20);
insert into emp06 values(1113,'홍길동','개발자',30);
insert into emp06 values(1114,'홍길동','개발자',40);    
-- 50번 부서는 부모키에서 참조할 수 없는 값이기 때문에, 외래키 제약조건에 위배
-- 되어서 사용할 수 없다.
insert into emp06 values(1115,'홍길동','개발자',50);--foreign key제약조건 위배    

--5. check 제약조건
-- : 데이터가 입력될때 특정 조건을 만족하는 데이터만 입력되도록 만들어 주는
--   제약조건 이다.

-- 급여(SAL) : 500 ~ 5000
-- 성별(gender) : M or F
create table emp07(
    empno number(4) primary key,
    ename varchar2(10) not null,
    sal number(7,2) check(sal between 500 and 5000),
    gender varchar2(1) check(gender in('M','F')) );

select * from emp07;
insert into emp07 values(1111,'홍길동',3000,'M');--정상적인 데이터 입력
insert into emp07 values(1112,'홍길동',8000,'M');--check제약조건 위배
insert into emp07 values(1113,'홍길동',5000,'m');--check제약조건 위배

--6. default 제약조건
-- : default 제약조건이 설정된 컬럼에 값이 입력되지 않으면, default로 설정된
--    값이 자동으로 입력된다.

drop table dept01 purge;
create table dept01(
    deptno number(2) primary key,
    dname varchar2(14),
    loc varchar2(13) default 'SEOUL' );
    
select * from dept01;    
insert into dept01 values(10,'ACCOUNTING','NEW YORK');
insert into dept01(deptno, dname) values(20,'RESEARCH');
-----------------------------------------------------------
-- 제약 조건 설정 방식
--1. 컬럼레벨 방식으로 제약조건 설정
--2. 테이블레벨 방식으로 제약조건 설정

--1. 컬럼레벨 방식으로 제약조건 설정
drop table emp01 purge;

create table emp01(
    empno number(4) primary key,
    ename varchar2(15) not null,
    job varchar2(10) unique,
    deptno number(4) references dept(deptno) );

--2. 테이블레벨 방식으로 제약조건 설정
drop table emp02 purge;

create table emp02(
    empno number(4),
    ename varchar2(15) not null,--not null제약조건은 컬럼레벨 방식만 가능함
    job varchar2(10),
    deptno number(4),
    primary key(empno),
    unique(job),
    foreign key(deptno) references dept(deptno) );
    
-- 제약 조건을 설정할때 테이블 레벨 방식만 가능한 경우
--1. 기본키를 복합키로 사용하는 경우(기본키 제약조건을 2개 이상 생성하는 것)
--2. alter table 명령으로 제약조건을 추가할 경우

--1. 2개 이상의 컬럼을 기본키로 설정
drop table member01 purge;

--1) 컬럼레벨 방식으로 2개의 컬럼을 primary key로 설정
create table member01(
    id varchar2(20) primary key,
    passwd varchar2(20) primary key );  -- 오류발생
    
-- ORA-02260: table can have only one primary key

--2) 테이블레벨 방식으로 2개의 컬럼을 primary key로 설정
create table member01(
    id varchar2(20),
    passwd varchar2(20),
    primary key(id, passwd) );
    
--2. alter table 명령으로 제약조건을 추가하는 경우
drop table emp01 purge;

-- 제약조건이 없는 테이블 생성
create table emp01(
    empno number(4),        -- primary key
    ename varchar2(15),     -- not null
    job varchar2(10),       -- unique
    deptno number(2));      -- foreign key
    
-- primary key 제약조건 추가 : empno
alter table emp01 add primary key(empno);

-- not null 제약조건 추가 : ename
alter table emp01 modify ename not null;

-- unique 제약조건 추가 : job
alter table emp01 add unique(job);

-- foreign key 제약조건 추가 : deptno
alter table emp01 add foreign key(deptno) references dept(deptno);


-- 제약조건 제거
-- 형식 : alter table 테이블명 drop constraint constraint_name;

-- primary key 제약조건 제거
alter table emp01 drop  constraint SYS_C008393; 
alter table emp01 drop primary key;

-- not null 제약조건 제거
alter table emp01 drop constraint SYS_C008394;

-- unique 제약조건 제거
alter table emp01 drop constraint SYS_C008395;
alter table emp01 drop unique(job);

-- foreign key 제약조건 제거
alter table emp01 drop constraint SYS_C008396;


