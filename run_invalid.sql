SQL> select
  2     'ALTER ' || OBJECT_TYPE || ' ' ||
  3     OWNER || '.' || OBJECT_NAME || ' COMPILE;'
  4  from
  5     dba_objects
  6  where
  7     status = 'INVALID'
  8  and
  9     object_type in ('PACKAGE','FUNCTION','PROCEDURE')
 10  ;

ALTER FUNCTION SYSTEM.F_CHECKUSER COMPILE;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
SQL> spool off;
