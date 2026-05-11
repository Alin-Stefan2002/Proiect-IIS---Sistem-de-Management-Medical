----------------------------------------------------------------------------------
--- DSA_XLSX_SparkSQL_Views.sql
----------------------------------------------------------------------------------

-- 0. Testarea conexiunii
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8097/DSA-DOC-CSVService/rest/medical/MedicalSamplesView');

----------------------------------------------------------------------------------
-- 1. Crearea Vederii JSON
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'MTSAMPLES_JSON_VIEW',
               'http://localhost:8097/DSA-DOC-CSVService/rest/medical/MedicalSamplesView');

SELECT * FROM MTSAMPLES_JSON_VIEW;

----------------------------------------------------------------------------------
-- 2. Crearea Vederii SQL Finale (Spargerea JSON-ului pe coloane)
-- DROP VIEW view_medical_samples;
CREATE OR REPLACE VIEW view_medical_samples AS
select v.*
FROM MTSAMPLES_JSON_VIEW as json_view LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 3. Testarea Vederii Finale
select * FROM view_medical_samples;