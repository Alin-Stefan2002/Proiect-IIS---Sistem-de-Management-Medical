ALTER SESSION SET CURRENT_SCHEMA = insurance;

DROP TABLE patient_insurance;

CREATE TABLE patient_insurance (
    insurance_id NUMBER(10) CONSTRAINT pk_insurance PRIMARY KEY,
    age NUMBER(3),
    sex VARCHAR2(10),
    bmi NUMBER(5,2),
    children NUMBER(2),
    smoker VARCHAR2(3),
    region VARCHAR2(50),
    charges NUMBER(12,2)
);

-- Inseram datele de test pentru sistemul medical
INSERT INTO patient_insurance VALUES (5001, 19, 'female', 27.9, 0, 'yes', 'southwest', 16884.92);
INSERT INTO patient_insurance VALUES (5002, 18, 'male', 33.77, 1, 'no', 'southeast', 1725.55);

COMMIT;

SELECT * FROM patient_insurance;