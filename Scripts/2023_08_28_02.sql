-- 2023.08.28(월)

-- PL/SQL (Oracle's Procedural Language extention to SQL)

--Q. PL/SQL로 Hello World~!! 출력 해보자?
begin                                   -- 실행부 시작
    dbms_output.put_line('Hello World~!!');
end;                                    -- 실행부 끝                 

--Q. 변수 사용하기 : 스칼라 변수 사용하기
declare                                     -- 선언부 시작                     
    vempno number(4);                       -- 변수선언 : 스칼라 변수
    vename varchar2(10);
begin                                       -- 실행부 시작
    vempno := 7788;               -- 변수명은 대.소문자를 구분하지 않는다.
    vename := 'SCOTT';
    dbms_output.put_line('사번  /  이름');
    dbms_output.put_line('------------');
    dbms_output.put_line(VEMPNO || '/' || VENAME);
end;                                        -- 실행부 끝

--Q. 사번과 이름 검색하기 : 레퍼런스 변수
declare
    vempno emp.empno%type;              -- 변수 선언 : 레퍼런스 변수
    vename emp.ename%type;
begin
    select empno, ename into vempno, vename from emp
        where ename='SCOTT';
        
    dbms_output.put_line('사번  /  이름');
    dbms_output.put_line(vempno || '/' || vename);
end;
-----------------------------------------------------------------
--- 조건문(=선택문)

--1. if  ~ then  ~ end if
--Q1. 사원테이블(EMP)에서 SCOTT 사원의 부서번호를 검색해서, 부서명을 출력하는
--    PL/SQL문을 작성하세요?

declare
    vempno number(4);
    vename varchar2(20);
    vdeptno dept.deptno%type;
    vdname varchar2(20) := null;
begin
    select empno, ename, deptno into vempno, vename, vdeptno from emp where ename='SCOTT';
    if vdeptno = 10 then
        vdname := 'ACCOUNTING';
    end if;    
    if vdeptno = 20 then
        vdname := 'RESEARCH';
    end if;
    if vdeptno = 30 then
        vdname := 'SALES';
    end if;
    if vdeptno = 40 then
        vdname := 'OPERATIONS';
    end if;
    dbms_output.put_line('사번  /  이름  /  부서명');
    dbms_output.put_line(vempno||'/'||vename||'/'||vdname);
end;



