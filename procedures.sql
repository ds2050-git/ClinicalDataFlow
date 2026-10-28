CREATE OR REPLACE PACKAGE clinical_ops AS
PROCEDURE register_encounter(p_pid IN NUMBER,p_dept IN VARCHAR2,p_type IN VARCHAR2,p_eid OUT NUMBER);
PROCEDURE complete_discharge(p_eid IN NUMBER);
FUNCTION calculate_los(p_eid IN NUMBER) RETURN NUMBER;
END clinical_ops;
/

CREATE OR REPLACE PACKAGE BODY clinical_ops AS

PROCEDURE register_encounter(p_pid IN NUMBER,p_dept IN VARCHAR2,p_type IN VARCHAR2,p_eid OUT NUMBER) IS
BEGIN
INSERT INTO encounters(patient_id,admission_date,department,encounter_type)
VALUES(p_pid,CURRENT_TIMESTAMP,p_dept,p_type)
RETURNING encounter_id INTO p_eid;
COMMIT;
END register_encounter;

PROCEDURE complete_discharge(p_eid IN NUMBER) IS
BEGIN
UPDATE encounters
SET discharge_date=CURRENT_TIMESTAMP
WHERE encounter_id=p_eid;
COMMIT;
END complete_discharge;

FUNCTION calculate_los(p_eid IN NUMBER) RETURN NUMBER IS
v_adm TIMESTAMP;
v_dis TIMESTAMP;
v_hours NUMBER;
BEGIN
SELECT admission_date,NVL(discharge_date,CURRENT_TIMESTAMP)
INTO v_adm,v_dis
FROM encounters
WHERE encounter_id=p_eid;
v_hours:=EXTRACT(DAY FROM(v_dis-v_adm))*24+EXTRACT(HOUR FROM(v_dis-v_adm));
RETURN ROUND(v_hours/24,2);
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN 0;
END calculate_los;

END clinical_ops;
/