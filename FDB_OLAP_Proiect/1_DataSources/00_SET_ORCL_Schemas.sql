--------------------------------------------------------------------------------
-- 1. Schema pentru datele de asigurari 
--------------------------------------------------------------------------------
DROP USER insurance CASCADE;

CREATE USER insurance IDENTIFIED BY insurance
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON USERS;

GRANT connect, resource TO insurance;
GRANT CREATE VIEW TO insurance;
GRANT create database link TO insurance;

--------------------------------------------------------------------------------
-- 2. Schema de integrare: FDBO
--------------------------------------------------------------------------------
DROP USER fdbo CASCADE;

CREATE USER fdbo IDENTIFIED BY fdbo
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON USERS;

GRANT connect, resource TO fdbo;
GRANT CREATE VIEW TO fdbo;
GRANT create database link TO fdbo;

GRANT CREATE ANY DIRECTORY TO fdbo;
GRANT execute on utl_http TO fdbo;
GRANT execute on dbms_lob TO fdbo;
GRANT execute on sys.dbms_crypto TO fdbo;

ALTER SESSION SET cursor_sharing = exact;

-- Permisiuni APEX
GRANT CREATE DIMENSION, CREATE JOB, CREATE MATERIALIZED VIEW, CREATE SYNONYM TO fdbo;

--------------------------------------------------------------------------------
-- 3. Permisiuni pentru a invoca REST URLs 
--------------------------------------------------------------------------------
BEGIN
  dbms_network_acl_admin.append_host_ace (
      host       => '*',
      lower_port => NULL,
      upper_port => NULL,
      ace        => xs$ace_type(privilege_list => xs$name_list('http'),
                                principal_name => 'fdbo',
                                principal_type => xs_acl.ptype_db));
  END;
/
COMMIT;