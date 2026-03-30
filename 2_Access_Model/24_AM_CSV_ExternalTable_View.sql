--------------------------------------------------------------------------------
-- 23_AM_CSV_ExternalTable_View.sql (Cu transcrieri medicale)
--------------------------------------------------------------------------------

-- 1. Ne asiguram ca indicatorul catre folderul de fisiere exista
CREATE OR REPLACE DIRECTORY EXT_FILE_DS AS '/tmp/';

-- 2. Stergem versiunile vechi (pentru a evita erori la rerulare)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EXT_MEDICAL_SAMPLES';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 3. Cream External Table (cu coloana transcription de 4000 caractere)
CREATE TABLE EXT_MEDICAL_SAMPLES (
    id_sample NUMBER(6),
    sample_name VARCHAR2(150),
    medical_specialty VARCHAR2(100),
    description VARCHAR2(1000),
    transcription VARCHAR2(4000), -- Iata coloana pe care o doreai!
    keywords VARCHAR2(1000)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY EXT_FILE_DS
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
        (
            id_sample, 
            sample_name CHAR(150), 
            medical_specialty CHAR(100), 
            description CHAR(1000), 
            transcription CHAR(4000), -- Specificam limitarea si aici
            keywords CHAR(1000)
        )
    )
    LOCATION ('mtsamples_ready.csv') -- Numele noului fisier
)
REJECT LIMIT UNLIMITED;

-- 4. TEST: Verificam daca vedem transcrierile lungi!
SELECT * FROM EXT_MEDICAL_SAMPLES WHERE ROWNUM <= 20;

-- 5. Cream vederea de integrare
CREATE OR REPLACE VIEW V_MEDICAL_SAMPLES_CSV AS
SELECT * FROM EXT_MEDICAL_SAMPLES;