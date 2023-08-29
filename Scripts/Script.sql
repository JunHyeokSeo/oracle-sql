-- 1-1.
CREATE USER woman IDENTIFIED BY tiger;
GRANT CREATE SESSION TO woman WITH admin OPTION;
GRANT CONNECT, resource, dba TO woman;
-- 1-2.
CREATE USER user01 IDENTIFIED BY tiger;
GRANT CREATE SESSION, CREATE TABLE TO user01;

-- 2.
CREATE OR REPLACE PROCEDURE get_job(vename IN emp.ename%TYPE, vjob OUT emp.job%TYPE)
IS 
BEGIN 
	SELECT job INTO vjob FROM emp WHERE ename=vename;
END;
