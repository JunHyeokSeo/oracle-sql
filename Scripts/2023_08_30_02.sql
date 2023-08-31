-- 2023.08.30(수)

-- 패키지(package) = 저장 프로시저와 저장 함수를 묶어 놓은것.
-- 패키지 = 패키지 헤드 + 패키지 바디

--패키지 생성 
--1. 패키지 헤드 생성 
CREATE OR REPLACE PACKAGE exam_pack
IS 
	FUNCTION cal_bonus(vempno IN emp.EMPNO%TYPE) RETURN NUMBER; -- 저장함수
	PROCEDURE CURSOR_SAMPLE02;									-- 저장 프로시저
END;

--2. 패키지 바디 생성 
CREATE OR REPLACE PACKAGE BODY exam_pack
IS 
	-- 저장함수 : cal_bonus
	function cal_bonus(vempno in emp.empno%type) return number                   -- 돌려줄 값의 자료형
	is
    	vsal number(7,2);               -- 로컬변수
	begin
    	select sal into vsal from emp where empno = vempno;
    	return vsal * 2;                -- 급여를 200% 인상한 결과를 돌려준다.
	end;

	-- 저장 프로시저 : cursor_sample02
	procedure cursor_sample02
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
END;

--3. 저장 프로시저 실행 : cursor_sample02
CALL exam_pack.cursor_sample02();

--4. 저장 함수 실행 : cal_bonus();
DECLARE
	vsal NUMBER;
BEGIN
	vsal := exam_pack.cal_bonus(7788);
	dbms_output.put_line(vsal);
END;

-- SQL문으로 저장함수 실행
select ename, exam_pack.cal_bonus(7788) from emp where empno = 7788; 
select ename, exam_pack.cal_bonus(7900) from emp where empno = 7900; 

----------------------------------------------------------------------
-- 트리거(trigger)
--1. 트리거의 사전적인 의미는 방아쇠 라는 의미를 가지고 있다.
--2. 트리거는 이벤트를 발생 시켜서, 연쇄적으로 다른 작업을 자동으로 수행할때 
--   사용한다.
--3. 이벤트는 DML SQL문을 이용해서 이벤트를 발생시키고, 이때 연쇄적으로 
--   실행부(begin ~ end)안의 내용을 자동으로 실행한다.

--Q1. 사원테이블에 사원이 등록되면, "신입 사원이 입사 했습니다." 라는 메세지를
--    출력하는 트리거를 생성 하세요?

--1. 사원 테이블 생성
purge recyclebin;                  -- 임시 테이블 삭제
drop table emp01 purge;
create table emp01(
    empno number(4) primary key,   -- 기본키 제약조건
    ename varchar2(20),
    job varchar2(20) );

select * from tab;

--2. 트리거 생성
create or replace trigger trg_01
    after insert on emp01          -- 이벤트 발생
begin
    dbms_output.put_line('신입사원이 입사 했습니다.');
end;

--3. 트리거 목록 확인
select * from user_triggers;

--4. 이벤트 발생 : EMP01 테이블에 회원가입(데이터 입력)
set SERVEROUTPUT on
insert into emp01 values(1111,'홍길동','개발자');
insert into emp01 values(1112,'홍길동','개발자');
insert into emp01 values(1113,'홍길동','개발자');
insert into emp01 values(1114,'홍길동','개발자');

select * from emp01;
delete from emp01;

--Q2. 사원테이블(EMP01)에 신입 사원이 등록되면, 급여 테이블(SAL01)에 
--    급여 정보를 자동으로 추가 해주는 트리거를 생성 하세요?

--1. 사원 테이블 : EMP01
delete from emp01;
commit;

--2. 급여 테이블 생성 : SAL01
create table sal01(
    salno number(4) primary key,               --기본키(primary key)
    sal number(7,2),
    empno number(4) references emp01(empno) ); --외래키(foreign key) 

select * from tab;

--3. 시퀀스 생성
create sequence sal01_salno_seq;   -- 1부터 1씩 증가되는 시퀀스 생성

select * from seq;

--4. 트리거 생성
-- :new.컬럼명 : insert, update문을 이용해서 이벤트가 발생한 경우
-- :old.컬럼명 : delete문을 이용해서 이벤트가 발생한 경우
create or replace trigger trg_02
    after insert on emp01           -- 이벤트 발생
    for each row                    -- 행레벨 트리거
begin
    insert into sal01 values(sal01_salno_seq.nextval,300, :new.empno);
end;

--5. 트리거 목록 확인
select * from user_triggers;

--6. 이벤트 발생 : EMP01 테이블에 사원등록
insert into emp01 values(1111,'홍길동','개발자');
insert into emp01 values(1112,'홍길동','개발자');
insert into emp01 values(1113,'홍길동','개발자');

--7. 데이터 확인
select * from emp01;
select * from sal01;    -- 트리거에 의해서 자동으로 등록된다.


--Q3. 사원 테이블(EMP01)에서 사원정보가 삭제되면, 급여(SAL01) 정보를 자동으로 
--    삭제하는 트리거를 생성하세요?

-- 참조하는 외래키가 있기 때문에 부모 테이블의 데이터를 삭제할 수 없다.
delete from emp01 where empno = 1111;  -- 삭제 안됨

--1. 트리거 생성
-- :new.컬럼명 : insert, update문을 이용해서 이벤트가 발생한 경우
-- :old.컬럼명 : delete문을 이용해서 이벤트가 발생한 경우
create or replace trigger trg_03
    after delete on emp01           -- 이벤트 발생
    for each row                    -- 행레벨 트리거 
begin
    delete from sal01 where empno = :old.empno;
end;

--2. 트리거 목록 확인
select * from user_triggers;

--3. 이벤트 발생
-- : 사원 테이블(EMP01)의 사원번호 1111번 사원을 삭제(탈퇴)하면, 연쇄적으로
--   급여 테이블(SAL01)의 급여 정보도 같이 삭제된다.
delete from emp01 where empno = 1111;
delete from emp01 where empno = 1112;
delete from emp01 where empno = 1113;

--4. 결과 확인
select * from emp01;
select * from sal01;