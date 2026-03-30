--------------------------------------------------------------------------------
-- 26_AM_POSTGREST_View.sql 
--------------------------------------------------------------------------------

-- =============================================================================
-- 1. TESTE DE CONECTIVITATE (Oracle "suna" la PostgREST)
-- =============================================================================
-- Test pentru pacienti:
SELECT HTTPURITYPE.createuri('http://host.docker.internal:3000/patients').getclob() as doc_patients 
FROM dual;

-- Test pentru programari:
SELECT HTTPURITYPE.createuri('http://host.docker.internal:3000/medical_appointments').getclob() as doc_appointments 
FROM dual;

-- =============================================================================
-- 2. VIEW PENTRU PACIENTI (V_PATIENTS_REMOTE)
-- =============================================================================
CREATE OR REPLACE VIEW V_PATIENTS_REMOTE AS
WITH rest_doc AS
    (SELECT HTTPURITYPE.createuri('http://host.docker.internal:3000/patients')
    .getclob() as doc from dual)
SELECT 
  patient_id, gender, age, neighbourhood, scholarship, hipertension, diabetes, alcoholism, handcap
FROM JSON_TABLE( (select doc from rest_doc) , '$[*]'  
            COLUMNS ( 
                patient_id      NUMBER(20)    PATH '$.patient_id',
                gender          VARCHAR2(1)   PATH '$.gender',
                age             NUMBER(3)     PATH '$.age',
                neighbourhood   VARCHAR2(100) PATH '$.neighbourhood',
                scholarship     NUMBER(1)     PATH '$.scholarship',
                hipertension    NUMBER(1)     PATH '$.hipertension',
                diabetes        NUMBER(1)     PATH '$.diabetes',
                alcoholism      NUMBER(1)     PATH '$.alcoholism',
                handcap         NUMBER(1)     PATH '$.handcap' )
);

-- =============================================================================
-- 3. VIEW (V_MEDICAL_APPOINTMENTS_REMOTE)
-- Oglindeste tabela appointments.medical_appointments din Postgres
-- =============================================================================
CREATE OR REPLACE VIEW V_APPOINTMENTS_REMOTE AS
WITH rest_doc AS
    (SELECT HTTPURITYPE.createuri('http://host.docker.internal:3000/medical_appointments')
    .getclob() as doc from dual)
SELECT 
  appointment_id, patient_id, scheduled_day, appointment_day, sms_received, no_show
FROM JSON_TABLE( (select doc from rest_doc) , '$[*]'  
            COLUMNS ( 
                appointment_id   NUMBER(20)    PATH '$.appointment_id',
                patient_id       NUMBER(20)    PATH '$.patient_id',
                scheduled_day    TIMESTAMP     PATH '$.scheduled_day',
                appointment_day  TIMESTAMP     PATH '$.appointment_day',
                sms_received     NUMBER(1)     PATH '$.sms_received',
                no_show          VARCHAR2(5)   PATH '$.no_show' )
);


-- =============================================================================
-- 4. VERIFICARI  IN ORACLE
-- =============================================================================
SELECT * FROM V_PATIENTS_REMOTE;
SELECT * FROM V_APPOINTMENTS_REMOTE;