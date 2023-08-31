SELECT object_name FROM dba_objects
WHERE object_type='PACKAGE'
AND object_name LIKE 'DBMS_%'
ORDER BY object_name;
