-- Creare rol (user) pentru programari
CREATE ROLE appointments WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT
    NOREPLICATION
    CONNECTION LIMIT -1
    PASSWORD 'appointments';
    
-- Creare schema detinuta de acest rol
CREATE SCHEMA appointments AUTHORIZATION appointments;