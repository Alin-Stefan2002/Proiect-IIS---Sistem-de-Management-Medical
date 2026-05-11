----------------------------------------------------------------------------------
--- DSA_CVS_SparkSQL_Views.sql
----------------------------------------------------------------------------------
-- 1. Testarea conexiunii
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8097/DSA-DOC-CSVService/rest/medical/MedicalSamplesView');

----------------------------------------------------------------------------------
-- 2. Crearea Vederii (Transformă JSON-ul brut în tabel SQL)
CREATE OR REPLACE VIEW view_medical_samples AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<description: STRING, medicalSpecialty: STRING, sampleName: STRING, transcription: STRING, keywords: STRING>>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8097/DSA-DOC-CSVService/rest/medical/MedicalSamplesView')
        as data) json_raw
)
select v.*
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 3. Testarea Vederii Finale
SELECT * FROM view_medical_samples;