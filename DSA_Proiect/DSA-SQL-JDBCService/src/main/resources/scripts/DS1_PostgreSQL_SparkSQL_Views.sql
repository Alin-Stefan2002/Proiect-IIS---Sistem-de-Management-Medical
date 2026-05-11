--------------------------------------------------------------------------------
--- DS1_PostgreSQL_SparkSQL_Views.sql
--------------------------------------------------------------------------------
-- 1. Get Data Source JSON Schema
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/PatientView');


-- 2. Create Remote View for Patients
-- Folosim STRUCT pentru a defini coloanele (patient_id, name, gender, birth_date)
CREATE OR REPLACE VIEW view_patients AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<patient_id: BIGINT, name: STRING, gender: STRING, birth_date: STRING>>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/PatientView')
        as data) json_raw
)
select v.*
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

-- 3. Test Remote View
SELECT * FROM view_patients;

----------------------------------------------------------------------------------

-- 1. Get Data Source JSON Schema for Appointments
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/MedicalAppointmentsView');

-- 2. Create Remote View for Appointments
-- Definim coloanele conform clasei MedicalAppointmentsView
CREATE OR REPLACE VIEW view_medical_appointments AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<appointment_id: BIGINT, patient_id: BIGINT, scheduled_day: STRING, appointment_day: STRING, sms_received: BIGINT, no_show: STRING>>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8090/DSA-SQL-JDBCService/rest/medical/MedicalAppointmentsView')
        as data) json_raw
)
select v.*
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

-- 3. Test Remote View
SELECT * FROM view_medical_appointments;

