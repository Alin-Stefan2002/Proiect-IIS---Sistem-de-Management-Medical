-- 1. Activam Schema
BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'FDBO',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'fdbo',
        p_auto_rest_auth => FALSE
    );
    COMMIT;
END;
/

-- 2. Activam Vederea
BEGIN
    ORDS.ENABLE_OBJECT(
        p_enabled => TRUE,
        p_schema => 'FDBO',
        p_object => 'OLAP_VIEW_MEDICAL_ANALYSIS',
        p_object_type => 'VIEW',
        p_object_alias => 'medical_report', 
        p_auto_rest_auth => FALSE
    );
    COMMIT;
END;
/