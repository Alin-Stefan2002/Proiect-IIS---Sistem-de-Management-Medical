----------------------------------------------------------------------------------
--- DS5_MogoDB_SparkSQL_Views.sql
----------------------------------------------------------------------------------

SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'CLINICS_JSON_VIEW',
               'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/medical/ClinicView');

SELECT * FROM CLINICS_JSON_VIEW;

----------------------------------------------------------------------------------

-- DROP VIEW clinics_view;
CREATE OR REPLACE VIEW clinics_view AS
select v._id, v.clinic_name, v.city, v.bed_capacity
FROM CLINICS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

-- 3. Test Remote View 1
select * FROM clinics_view;

----------------------------------------------------------------------------------

-- (Acesta este echivalentul "departaments_cities_view" din vechiul script)
-- DROP VIEW clinics_departments_view;
CREATE OR REPLACE VIEW clinics_departments_view AS
select v._id, explode(v.departments) as medical_department
FROM CLINICS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

select * FROM clinics_departments_view;

----------------------------------------------------------------------------------

-- DROP VIEW clinics_departments_view_all;
CREATE OR REPLACE VIEW clinics_departments_view_all AS
select v._id, v.clinic_name, v.city, v.bed_capacity, explode(v.departments) as medical_department
FROM CLINICS_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

select * FROM clinics_departments_view_all;