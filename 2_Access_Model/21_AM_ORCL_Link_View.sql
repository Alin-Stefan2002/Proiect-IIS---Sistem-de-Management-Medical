--------------------------------------------------------------------------------
-- 1. Curatam legaturile vechi (daca exista)
--------------------------------------------------------------------------------
ROLLBACK;
-- Inchidem orice conexiune activa pe link
-- (Inlocuim 'salesDB' cu 'insuranceDB' pentru proiectul tau)
-- ALTER SESSION CLOSE DATABASE LINK insuranceDB; 

DROP DATABASE LINK insuranceDB;

--------------------------------------------------------------------------------
-- 2. Cream legatura catre schema de asigurari
--------------------------------------------------------------------------------
CREATE DATABASE LINK insuranceDB
   CONNECT TO insurance IDENTIFIED BY insurance
   USING '//localhost:1521/XEPDB1';

-- Verificam daca link-ul a fost creat cu succes
SELECT * FROM user_db_links;

-- Listam tabelele pe care le vede link-ul in schema insurance
SELECT * FROM user_tables@insuranceDB;

-- Incercam sa citim datele din tabela de asigurari
SELECT * FROM patient_insurance@insuranceDB;

DROP VIEW V_INSURANCE_REMOTE;

CREATE OR REPLACE VIEW V_INSURANCE_REMOTE AS
SELECT 
    INSURANCE_ID, 
    AGE, 
    SEX, 
    BMI, 
    CHILDREN, 
    SMOKER, 
    REGION, 
    CHARGES
FROM patient_insurance@insuranceDB;

-- Testam vederea
SELECT * FROM V_INSURANCE_REMOTE;