----------------------------------------------------------------------------------
--- DS5_MogoDB_SparkSQL_Views.sql
----------------------------------------------------------------------------------

SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/medical/ClinicView');

----------------------------------------------------------------------------------
-- DROP VIEW clinics_view;
CREATE OR REPLACE VIEW clinics_view AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<_id: STRING, clinic_name: STRING, city: STRING, bed_capacity: INT, departments: ARRAY<STRING>>>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/medical/ClinicView')
        as data) json_raw
)
select v._id, v.clinic_name, v.city, v.bed_capacity
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

select * FROM clinics_view;

----------------------------------------------------------------------------------

CREATE OR REPLACE VIEW clinics_departments_view_all AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<_id: STRING, clinic_name: STRING, city: STRING, bed_capacity: INT, departments: ARRAY<STRING>>>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8093/DSA-NoSQL-MongoDBService/rest/medical/ClinicView')
        as data) json_raw
)
select v._id, v.clinic_name, v.city, medical_department
FROM json_view LATERAL VIEW explode(json_view.array) AS v
LATERAL VIEW explode(v.departments) AS medical_department;

select * FROM clinics_departments_view_all;