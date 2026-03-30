--------------------------------------------------------------------------------
-- 28_AM_JSON_MongoDB_View.sql (Adaptat pentru Proiectul Medical)
--------------------------------------------------------------------------------

-- 1. Stergem vederea veche (daca exista) pentru a evita erorile
BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW V_CLINICS_NOSQL';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 2. Cream functia care se autentifica la RESTHeart (exact ca in laborator)
CREATE OR REPLACE FUNCTION get_restheart_data(pURL VARCHAR2, pUserPass VARCHAR2) 
RETURN CLOB IS
  l_req   UTL_HTTP.req;
  l_resp  UTL_HTTP.resp;
  l_buffer CLOB; 
BEGIN
  l_req  := UTL_HTTP.begin_request(pURL);
  UTL_HTTP.set_header(l_req, 'Authorization', 'Basic ' || 
    UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_I18N.string_to_raw(pUserPass, 'AL32UTF8')))); 
  l_resp := UTL_HTTP.get_response(l_req);
  UTL_HTTP.READ_TEXT(l_resp, l_buffer);
  UTL_HTTP.end_response(l_resp);
  RETURN l_buffer;
EXCEPTION WHEN OTHERS THEN
  RETURN NULL;
END;
/

-- 3. Cream Vederea de Integrare (Integration View) folosind JSON_TABLE
CREATE OR REPLACE VIEW V_CLINICS_NOSQL AS
WITH rest_json AS (
    SELECT get_restheart_data('http://host.docker.internal:8081/medical/clinics', 'admin:secret') as doc 
    FROM dual
)
SELECT 
    clinic_id,
    clinic_name,
    city,
    bed_capacity
FROM JSON_TABLE(
    (SELECT doc FROM rest_json), '$[*]'
    COLUMNS (
        clinic_id         VARCHAR2(10)  PATH '$._id',
        clinic_name       VARCHAR2(100) PATH '$.clinic_name', 
        city              VARCHAR2(50)  PATH '$.city',        
        bed_capacity      NUMBER(4)     PATH '$.bed_capacity' 
    )
);

-- 4. TESTUL FINAL: Afisam datele!
SELECT * FROM V_CLINICS_NOSQL;
