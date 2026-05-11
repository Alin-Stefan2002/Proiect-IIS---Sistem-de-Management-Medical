------------------------------------------------------------------------------------------------------------------------
--- 1. Dimensions (Dimensiuni)
------------------------------------------------------------------------------------------------------------------------

-- D1: Dimensiunea Pacienți (Folosim direct coloanele age și hipertension din Postgres)
CREATE OR REPLACE VIEW OLAP_DIM_PATIENTS AS
SELECT
    patient_id,
    gender,
    age,
    CASE WHEN hipertension = 1 THEN 'With Hypertension' ELSE 'Normal' END AS bp_status,
    CASE
        WHEN age < 30 THEN 'Young Adults (18-29)'
        WHEN age BETWEEN 30 AND 50 THEN 'Adults (30-50)'
        ELSE 'Seniors (50+)'
        END AS age_cohort
FROM view_patients;

SELECT * FROM OLAP_DIM_PATIENTS;

-- D2: Dimensiunea Clinici (Locații din MongoDB)
CREATE OR REPLACE VIEW OLAP_DIM_CLINICS AS
SELECT
    CAST(ROW_NUMBER() OVER(ORDER BY clinic_name) AS STRING) AS clinic_id,
    clinic_name,
    city,
    bed_capacity
FROM clinics_view;

SELECT * FROM OLAP_DIM_CLINICS;

-- D3: Dimensiunea Specialități
CREATE OR REPLACE VIEW OLAP_DIM_SPECIALTIES AS
SELECT
    CAST(ROW_NUMBER() OVER(ORDER BY sampleName) AS STRING) AS id_sample,
    medicalSpecialty AS medical_specialty
FROM view_medical_samples;

SELECT * FROM OLAP_DIM_SPECIALTIES;

--------------------------------------------------------------------------------
--- 2. Facts
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW OLAP_FACTS_APPOINTMENTS AS
SELECT
    p.patient_id,
    -- Distribuim aleatoriu pacienții la cele 10 clinici din baza ta de date
    CAST((ABS(p.patient_id) % 10) + 1 AS STRING) AS clinic_id,
    -- Distribuim aleatoriu pacienții la primele 50 de specialități
    CAST((ABS(p.patient_id) % 50) + 1 AS STRING) AS id_sample,
    a.appointment_id,
    a.sms_received,
    CASE WHEN a.no_show = 'Yes' THEN 1 ELSE 0 END AS is_no_show
FROM view_patients p
         INNER JOIN view_medical_appointments a ON p.patient_id = a.patient_id;

SELECT * FROM OLAP_FACTS_APPOINTMENTS LIMIT 10;

--------------------------------------------------------------------------------
--- 3. Analytical Views: OLAP Views (CUBE, ROLLUP)
--------------------------------------------------------------------------------

-- VIEW 1: Analiza Rata de "No-Show" (Neprezentare) pe Orașe și Gen
CREATE OR REPLACE VIEW OLAP_VIEW_NOSHOW_CITY_GEN
            TBLPROPERTIES ('AUTOREST' = 'olap/view/noshow_city_gen')
AS
SELECT
    CASE WHEN GROUPING(C.city) = 1 THEN '{Grand Total}' ELSE C.city END AS city,
    CASE WHEN GROUPING(P.gender) = 1 THEN '{All Genders}' ELSE P.gender END AS gender,
    COUNT(F.appointment_id) AS total_appointments,
    SUM(F.is_no_show) AS total_no_shows,
    ROUND((SUM(F.is_no_show) / COUNT(F.appointment_id)) * 100, 2) AS no_show_rate_percent
FROM OLAP_DIM_CLINICS C
         INNER JOIN OLAP_FACTS_APPOINTMENTS F ON C.clinic_id = F.clinic_id
         INNER JOIN OLAP_DIM_PATIENTS P ON P.patient_id = F.patient_id
GROUP BY CUBE(C.city, P.gender)
ORDER BY total_appointments DESC;

SELECT * FROM OLAP_VIEW_NOSHOW_CITY_GEN;

-- VIEW 2: Analiza pe Categorii de Vârstă și Impactul SMS-urilor
CREATE OR REPLACE VIEW OLAP_VIEW_AGE_SMS_IMPACT
            TBLPROPERTIES ('AUTOREST' = 'olap/view/age_sms_impact')
AS
SELECT
    CASE WHEN GROUPING(P.age_cohort) = 1 THEN '{Grand Total}' ELSE P.age_cohort END AS age_cohort,
    CASE WHEN GROUPING(F.sms_received) = 1 THEN '{All}' ELSE CAST(F.sms_received AS STRING) END AS sms_received,
    COUNT(F.appointment_id) AS total_appointments,
    ROUND((SUM(F.is_no_show) / COUNT(F.appointment_id)) * 100, 2) AS no_show_rate_percent
FROM OLAP_DIM_PATIENTS P
         INNER JOIN OLAP_FACTS_APPOINTMENTS F ON P.patient_id = F.patient_id
GROUP BY ROLLUP(P.age_cohort, F.sms_received)
ORDER BY age_cohort;

SELECT * FROM OLAP_VIEW_AGE_SMS_IMPACT;

-- VIEW 3: Ierarhia Geografică și Specialități
CREATE OR REPLACE VIEW OLAP_VIEW_GEO_HIERARCHY
            TBLPROPERTIES ('AUTOREST' = 'olap/view/geo_hierarchy')
AS
SELECT
    CASE WHEN GROUPING(C.city) = 1 THEN '{Grand Total}' ELSE C.city END AS city,
    CASE WHEN GROUPING(C.city) = 1 THEN ' ' WHEN GROUPING(C.clinic_name) = 1 THEN CONCAT('City Subtotal ', C.city) ELSE C.clinic_name END AS clinic,
    CASE WHEN GROUPING(C.city) = 1 THEN ' ' WHEN GROUPING(C.clinic_name) = 1 THEN ' ' WHEN GROUPING(S.medical_specialty) = 1 THEN CONCAT('Clinic Subtotal ', C.clinic_name) ELSE S.medical_specialty END AS specialty,
    COUNT(F.appointment_id) AS total_appointments,
    SUM(F.is_no_show) AS missed_appointments
FROM OLAP_DIM_CLINICS C
         INNER JOIN OLAP_FACTS_APPOINTMENTS F ON C.clinic_id = F.clinic_id
         INNER JOIN OLAP_DIM_SPECIALTIES S ON S.id_sample = F.id_sample
GROUP BY ROLLUP(C.city, C.clinic_name, S.medical_specialty)
ORDER BY city, clinic, specialty;

SELECT * FROM OLAP_VIEW_GEO_HIERARCHY;

-- VIEW 4: Ierarhia capacității și utilizării spitalelor (Cu ROLLUP)

CREATE OR REPLACE VIEW OLAP_VIEW_CAPACITY_HIERARCHY
            TBLPROPERTIES ('AUTOREST' = 'olap/view/capacity_hierarchy')
AS
SELECT
    CASE WHEN GROUPING(C.city) = 1 THEN '{Grand Total}' ELSE C.city END AS city,
    CASE WHEN GROUPING(C.city) = 1 THEN ' ' WHEN GROUPING(C.clinic_name) = 1 THEN CONCAT('City Subtotal ', C.city) ELSE C.clinic_name END AS clinic_name,
    SUM(C.bed_capacity) AS total_bed_capacity,
    COUNT(P.patient_id) AS total_patients,
    ROUND((COUNT(P.patient_id) / NULLIF(SUM(C.bed_capacity), 0)) * 100, 2) AS occupancy_rate_percent
FROM OLAP_DIM_CLINICS C
         LEFT JOIN OLAP_DIM_PATIENTS P ON CAST((ABS(P.patient_id) % 10) + 1 AS STRING) = C.clinic_id
GROUP BY ROLLUP (C.city, C.clinic_name)
ORDER BY city, clinic_name;

SELECT * FROM OLAP_VIEW_CAPACITY_HIERARCHY;

-- VIEW 5: Categorii de vârstă precalculate din dimensiuni (Cu ROLLUP)

CREATE OR REPLACE VIEW OLAP_VIEW_AGE_COHORTS
            TBLPROPERTIES ('AUTOREST' = 'olap/view/age_cohorts')
AS
SELECT
    CASE WHEN GROUPING(P.age_cohort) = 1 THEN '{Grand Total}' ELSE P.age_cohort END AS age_cohort,
    CASE WHEN GROUPING(P.gender) = 1 THEN '{All Genders}' ELSE P.gender END AS gender,
    COUNT(F.appointment_id) AS total_appointments,
    SUM(F.is_no_show) AS missed_appointments,
    ROUND((SUM(F.is_no_show) / COUNT(F.appointment_id)) * 100, 2) AS no_show_rate_percent
FROM OLAP_DIM_PATIENTS P
         INNER JOIN OLAP_FACTS_APPOINTMENTS F ON P.patient_id = F.patient_id
GROUP BY ROLLUP(P.age_cohort, P.gender)
ORDER BY age_cohort;

SELECT * FROM OLAP_VIEW_AGE_COHORTS;

-- VIEW 6: Discrepanță Regională (Folosind funcții Window - OVER PARTITION)
-- (Compară numărul de programări al unei clinici cu media orașului din care face parte)
CREATE OR REPLACE VIEW OLAP_VIEW_REGIONAL_BENCHMARK
            TBLPROPERTIES ('AUTOREST' = 'olap/view/regional_benchmark')
AS
SELECT
    C.city AS city,
    C.clinic_name AS clinic_name,
    COUNT(F.appointment_id) AS clinic_appointments,
    ROUND(AVG(COUNT(F.appointment_id)) OVER (PARTITION BY C.city), 2) AS city_avg_appointments,
    ROUND(COUNT(F.appointment_id) - AVG(COUNT(F.appointment_id)) OVER (PARTITION BY C.city), 2) AS diff_from_avg
FROM OLAP_DIM_CLINICS C
         INNER JOIN OLAP_FACTS_APPOINTMENTS F ON C.clinic_id = F.clinic_id
GROUP BY C.city, C.clinic_name
ORDER BY city, diff_from_avg DESC;

SELECT * FROM OLAP_VIEW_REGIONAL_BENCHMARK;

--------------------------------------------------------------------------------
--- 4. Advanced SparkSQL Analytics
--------------------------------------------------------------------------------

-- a. Spark SQL PIVOT (Total No-Shows by Gender and City)
SELECT * FROM (
                  SELECT C.city, P.gender, F.is_no_show
                  FROM OLAP_FACTS_APPOINTMENTS F
                           INNER JOIN OLAP_DIM_CLINICS C ON F.clinic_id = C.clinic_id
                           INNER JOIN OLAP_DIM_PATIENTS P ON F.patient_id = P.patient_id
              ) V
    PIVOT (
  SUM(is_no_show)
  FOR gender IN ('M' AS Male, 'F' AS Female)
)
ORDER BY 1;

-- b. Spark SQL UNPIVOT (Transform Patient Attributes)
SELECT patient_id, detail_label, detail_value
FROM (
         SELECT patient_id, gender, CAST(age AS STRING) as age, bp_status
         FROM OLAP_DIM_PATIENTS
     ) p_view
    UNPIVOT INCLUDE NULLS(
    detail_value FOR detail_label IN (gender, age, bp_status)
);

-- c. Spark SQL Ranking Functions
SELECT clinic_id, Clinic_Appointments,
       RANK() OVER (ORDER BY Clinic_Appointments DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY Clinic_Appointments DESC) AS dense_rank,
       ROW_NUMBER() OVER (ORDER BY Clinic_Appointments DESC) AS row_number
FROM (
         SELECT clinic_id, COUNT(appointment_id) AS Clinic_Appointments
         FROM OLAP_FACTS_APPOINTMENTS
         GROUP BY clinic_id
     ) Top_Clinics
ORDER BY 2 DESC;

-- d. SparkSQL Advanced Statistical Functions (Central Tendencies)
WITH patient_stats AS (
    SELECT patient_id, COUNT(appointment_id) as total_app
    FROM OLAP_FACTS_APPOINTMENTS GROUP BY patient_id
)
SELECT
    AVG(total_app) AS avg_appointments,
    MEDIAN(total_app) AS median_appointments,
    MODE(total_app) AS mode_appointments
FROM patient_stats;

-- e. Pearson Coefficient Correlation (Age vs No-Show rate)
-- Valid range [-1, +1] => [negative, no, positive] correlation
SELECT CORR(P.age, F.is_no_show) AS CORRELATION_PEARSON
FROM OLAP_FACTS_APPOINTMENTS F
         INNER JOIN OLAP_DIM_PATIENTS P ON F.patient_id = P.patient_id;

--------------------------------------------------------------------------------
-- http://localhost:9990/DSA-SparkSQL-Service/rest/auto?redef=true
--------------------------------------------------------------------------------
-- ANALYTICAL WEB MODEL - REST ENDPOINTS (SparkSQL REST Service)
-- Base URL: http://localhost:9990/DSA-SparkSQL-Service/rest/view/
--------------------------------------------------------------------------------

-- 1. No-Show Analysis (City & Gender)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_NOSHOW_CITY_GEN

-- 2. SMS Impact Analysis (Age Cohorts)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_AGE_SMS_IMPACT

-- 3. Geographic & Specialty Hierarchy
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_GEO_HIERARCHY

-- 4. Hospital Capacity & Occupancy Rates
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_CAPACITY_HIERARCHY

-- 5. Precalculated Age Cohorts Statistics
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_AGE_COHORTS

-- 6. Regional Benchmark (Clinic vs City Average)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_REGIONAL_BENCHMARK

--------------------------------------------------------------------------------
-- REFRESH COMMAND (Run this if views are not visible in browser)
-- http://localhost:9990/DSA-SparkSQL-Service/rest/auto?redef=true
--------------------------------------------------------------------------------









/