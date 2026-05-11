-- Cream tabela pentru datele demografice ale pacientilor
CREATE TABLE appointments.patients (
    patient_id NUMERIC(20) PRIMARY KEY,
    gender CHAR(1),
    age NUMERIC(3),
    neighbourhood VARCHAR(100),
    scholarship NUMERIC(1),
    hipertension NUMERIC(1),
    diabetes NUMERIC(1),
    alcoholism NUMERIC(1),
    handcap NUMERIC(1)
);

-- Cream tabela pentru programari
CREATE TABLE appointments.medical_appointments (
    appointment_id NUMERIC(20) PRIMARY KEY,
    patient_id NUMERIC(20) REFERENCES appointments.patients(patient_id),
    scheduled_day TIMESTAMP,
    appointment_day TIMESTAMP,
    sms_received NUMERIC(1),
    no_show VARCHAR(5)
);

