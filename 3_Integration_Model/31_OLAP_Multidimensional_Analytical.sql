-- 1. Test Oracle 
SELECT * FROM V_INSURANCE_REMOTE;

-- 2. Test Postgres 
SELECT * FROM V_PATIENTS_REMOTE;
SELECT * FROM V_APPOINTMENTS_REMOTE;

-- 3. Test MongoDB 
SELECT * FROM V_CLINICS_NOSQL;

-- 4. Test CSV 
SELECT * FROM EXT_MEDICAL_SAMPLES;

------------------------------------------------------------------------------------------------------------------------
--- 1. Dimensions
------------------------------------------------------------------------------------------------------------------------

-- D1: Dimensiunea Pacienți
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
FROM V_PATIENTS_REMOTE;

SELECT * FROM OLAP_DIM_PATIENTS;

-- D2: Dimensiunea Clinici (Locații)
CREATE OR REPLACE VIEW OLAP_DIM_CLINICS AS
SELECT 
    clinic_id, 
    clinic_name, 
    city, 
    bed_capacity
FROM V_CLINICS_NOSQL;

SELECT * FROM OLAP_DIM_CLINICS;

-- D3: Dimensiunea Asigurări
CREATE OR REPLACE VIEW OLAP_DIM_LIFESTYLE AS
SELECT 
    age,
    LOWER(sex) AS sex_standard,
    smoker
FROM V_INSURANCE_REMOTE;

SELECT * FROM OLAP_DIM_LIFESTYLE ;

-- D4: Dimensiunea Specialități
CREATE OR REPLACE VIEW OLAP_DIM_SPECIALTIES AS
SELECT 
    id_sample, 
    medical_specialty
FROM EXT_MEDICAL_SAMPLES;

SELECT * FROM OLAP_DIM_SPECIALTIES;

--------------------------------------------------------------------------------
--- 2. Facts:
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW OLAP_FACTS_MEDICAL_AMOUNT AS
SELECT 
    p.patient_id, 
    c.clinic_id, 
    s.id_sample,
    i.age AS insurance_age,
    i.smoker,
    SUM(i.charges) AS total_charges,
    AVG(i.bmi) AS avg_bmi
FROM V_PATIENTS_REMOTE p
INNER JOIN V_INSURANCE_REMOTE i ON i.age = p.age AND LOWER(i.sex) = (CASE WHEN p.gender = 'F' THEN 'female' ELSE 'male' END)
INNER JOIN V_CLINICS_NOSQL c ON c.clinic_id = 'C10' || MOD(p.age, 10)
INNER JOIN EXT_MEDICAL_SAMPLES s ON s.id_sample = MOD(ABS(p.patient_id), 4000) + 1
GROUP BY p.patient_id, c.clinic_id, s.id_sample, i.age, i.smoker;

SELECT * FROM OLAP_FACTS_MEDICAL_AMOUNT;

--------------------------------------------------------------------------------
--- 3. Analytical Views: OLAP Views
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- VIEW 1: Clasamentul Veniturilor pe orașe și gen
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW OLAP_VIEW_REVENUE_CITY_GEN AS
SELECT 
    CASE WHEN GROUPING(C.city) = 1 THEN '{Grand Total}' ELSE C.city END AS city,
    CASE WHEN GROUPING(P.gender) = 1 THEN '{All Genders}' ELSE P.gender END AS gender,
    SUM(NVL(F.total_charges, 0)) AS total_revenue,
    RANK() OVER (PARTITION BY GROUPING(C.city) ORDER BY SUM(F.total_charges) DESC) as profit_rank
FROM OLAP_DIM_CLINICS C
INNER JOIN OLAP_FACTS_MEDICAL_AMOUNT F ON C.clinic_id = F.clinic_id
INNER JOIN OLAP_DIM_PATIENTS P ON P.patient_id = F.patient_id
GROUP BY CUBE(C.city, P.gender)
ORDER BY total_revenue DESC;

SELECT * FROM OLAP_VIEW_REVENUE_CITY_GEN;

--------------------------------------------------------------------------------
-- VIEW 2: Analiza corelației (fumat vs hipertensiune cu STDDEV)
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW OLAP_VIEW_LIFESTYLE_CORRELATION AS
SELECT 
    NVL(F.smoker, '{All Types}') AS smoker_status,
    NVL(P.bp_status, '{All Conditions}') AS bp_status,
    COUNT(F.patient_id) AS patient_count,
    ROUND(AVG(F.total_charges), 2) AS avg_insurance_cost,
    ROUND(STDDEV(F.total_charges), 2) AS cost_variance
FROM OLAP_DIM_PATIENTS P
INNER JOIN OLAP_FACTS_MEDICAL_AMOUNT F ON P.patient_id = F.patient_id
GROUP BY F.smoker, P.bp_status
ORDER BY avg_insurance_cost DESC;

SELECT * FROM OLAP_VIEW_LIFESTYLE_CORRELATION;

--------------------------------------------------------------------------------
-- VIEW 3: Ierarhia geografică 
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW OLAP_VIEW_GEO_HIERARCHY AS
SELECT 
  CASE WHEN GROUPING(C.city) = 1 THEN '{Grand Total}' ELSE C.city END AS city,
  CASE 
    WHEN GROUPING(C.city) = 1 THEN ' '
    WHEN GROUPING(C.clinic_name) = 1 THEN 'City Subtotal ' || C.city
    ELSE C.clinic_name END AS clinic,
  CASE 
    WHEN GROUPING(C.city) = 1 THEN ' '
    WHEN GROUPING(C.clinic_name) = 1 THEN ' '
    WHEN GROUPING(S.medical_specialty) = 1 THEN 'Clinic Subtotal ' || C.clinic_name
    ELSE S.medical_specialty END AS specialty,
  SUM(NVL(F.total_charges, 0)) AS revenue,
  COUNT(DISTINCT F.patient_id) AS unique_patients
FROM OLAP_DIM_CLINICS C
INNER JOIN OLAP_FACTS_MEDICAL_AMOUNT F ON C.clinic_id = F.clinic_id
INNER JOIN OLAP_DIM_SPECIALTIES S ON S.id_sample = F.id_sample
GROUP BY ROLLUP(C.city, C.clinic_name, S.medical_specialty)
ORDER BY C.city, C.clinic_name, S.medical_specialty;

SELECT * FROM OLAP_VIEW_GEO_HIERARCHY;

--------------------------------------------------------------------------------
-- VIEW 4: Ierarhia capacității și utilizării spitalelor 
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW OLAP_VIEW_CAPACITY_HIERARCHY AS
SELECT 
  CASE
    WHEN GROUPING(C.city) = 1 THEN '{Grand Total}'
    ELSE C.city END AS city,
    
  CASE 
    WHEN GROUPING(C.city) = 1 THEN ' '
    WHEN GROUPING(C.clinic_name) = 1 THEN 'City Subtotal ' || C.city
    ELSE C.clinic_name END AS clinic_name,
    
  SUM(C.bed_capacity) AS total_bed_capacity,
  COUNT(P.patient_id) AS total_patients,
  
  ROUND((COUNT(P.patient_id) / NULLIF(SUM(C.bed_capacity), 0)) * 100, 2) AS occupancy_rate_percent
FROM OLAP_DIM_CLINICS C
  LEFT JOIN OLAP_DIM_PATIENTS P ON 'C10' || MOD(P.age, 10) = C.clinic_id
GROUP BY ROLLUP (C.city, C.clinic_name)
ORDER BY C.city, C.clinic_name;


SELECT * FROM OLAP_VIEW_CAPACITY_HIERARCHY;


--------------------------------------------------------------------------------
-- VIEW 5: Categorii de vârstă precalculate din dimensiuni
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW OLAP_VIEW_AGE_COHORTS AS
SELECT 
    CASE WHEN GROUPING(P.age_cohort) = 1 THEN '{Grand Total}' ELSE P.age_cohort END AS age_cohort,
    CASE WHEN GROUPING(P.gender) = 1 THEN '{All Genders}' ELSE P.gender END AS gender,
    SUM(NVL(F.total_charges, 0)) AS total_revenue,
    ROUND(AVG(F.avg_bmi), 2) AS avg_bmi
FROM OLAP_DIM_PATIENTS P
INNER JOIN OLAP_FACTS_MEDICAL_AMOUNT F ON P.patient_id = F.patient_id
GROUP BY ROLLUP(P.age_cohort, P.gender)
ORDER BY P.age_cohort;

SELECT * FROM OLAP_VIEW_AGE_COHORTS;

--------------------------------------------------------------------------------
-- VIEW 6: Discrepanță regională 
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW OLAP_VIEW_REGIONAL_BENCHMARK AS
SELECT 
    C.city,
    C.clinic_name,
    SUM(F.total_charges) AS clinic_revenue,
    AVG(SUM(F.total_charges)) OVER (PARTITION BY C.city) AS city_average,
    SUM(F.total_charges) - AVG(SUM(F.total_charges)) OVER (PARTITION BY C.city) AS difference_from_average
FROM OLAP_DIM_CLINICS C
INNER JOIN OLAP_FACTS_MEDICAL_AMOUNT F ON C.clinic_id = F.clinic_id
GROUP BY C.city, C.clinic_name;

SELECT * FROM OLAP_VIEW_REGIONAL_BENCHMARK ;