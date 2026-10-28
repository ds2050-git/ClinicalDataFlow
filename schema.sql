CREATE TABLE patients(
patient_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
first_name VARCHAR2(50) NOT NULL,
last_name VARCHAR2(50) NOT NULL,
dob DATE NOT NULL,
gender VARCHAR2(10),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE encounters(
encounter_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
patient_id NUMBER NOT NULL,
admission_date TIMESTAMP NOT NULL,
discharge_date TIMESTAMP,
department VARCHAR2(50) NOT NULL,
encounter_type VARCHAR2(30) NOT NULL,
CONSTRAINT fk_patient FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE diagnoses(
diagnosis_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
encounter_id NUMBER NOT NULL,
icd10_code VARCHAR2(10) NOT NULL,
diagnosis_description VARCHAR2(150),
is_primary NUMBER(1) DEFAULT 0,
CONSTRAINT fk_encounter_diag FOREIGN KEY(encounter_id) REFERENCES encounters(encounter_id)
);

CREATE TABLE orders(
order_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
encounter_id NUMBER NOT NULL,
order_name VARCHAR2(100) NOT NULL,
order_status VARCHAR2(20) NOT NULL,
order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_encounter_ord FOREIGN KEY(encounter_id) REFERENCES encounters(encounter_id)
);

CREATE TABLE clinical_events(
event_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
encounter_id NUMBER NOT NULL,
event_type VARCHAR2(50) NOT NULL,
event_value VARCHAR2(50) NOT NULL,
event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_encounter_evt FOREIGN KEY(encounter_id) REFERENCES encounters(encounter_id)
);

CREATE INDEX idx_enc_patient ON encounters(patient_id);
CREATE INDEX idx_diag_enc ON diagnoses(encounter_id);
CREATE INDEX idx_ord_enc ON orders(encounter_id);
CREATE INDEX idx_evt_enc ON clinical_events(encounter_id);