--------------------------------------------------------------------------------
--- DS1_PostgreSQL_SparkSQL_Views_from_REST.sql (ADAPTAT MEDICAL)
--------------------------------------------------------------------------------

-- Testare acces documente REST
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/PatientView');

SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/MedicalAppointmentsView');

--------------------------------------------------------------------------------
--- JDBC Data Source Access Model ----------------------------------------------

-- 1. CREARE VIEW PACIENTI
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'PATIENTS_JSON_VIEW',
               'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/PatientView');

SELECT * FROM PATIENTS_JSON_VIEW;

CREATE OR REPLACE VIEW view_patients AS
select v.*
FROM PATIENTS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

SELECT * FROM view_patients;

--------------------------------------------------------------------------------

-- 2. CREARE VIEW PROGRAMARI
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'APPOINTMENTS_JSON_VIEW',
               'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/MedicalAppointmentsView');

select * FROM APPOINTMENTS_JSON_VIEW;

CREATE OR REPLACE VIEW view_medical_appointments AS
select v.*
FROM APPOINTMENTS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

SELECT * FROM view_medical_appointments;