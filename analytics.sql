WITH patient_metrics AS(
SELECT
p.patient_id,
p.first_name||' '||p.last_name AS full_name,
e.encounter_id,
e.department,
e.admission_date,
e.discharge_date,
ROUND(CAST(NVL(e.discharge_date,CURRENT_TIMESTAMP) AS DATE)-CAST(e.admission_date AS DATE),2) AS los_days,
DENSE_RANK() OVER(PARTITION BY p.patient_id ORDER BY e.admission_date DESC) AS rnk,
LAG(e.discharge_date) OVER(PARTITION BY p.patient_id ORDER BY e.admission_date) AS prev_discharge
FROM patients p
JOIN encounters e ON p.patient_id=e.patient_id
)
SELECT
patient_id,
full_name,
encounter_id,
department,
los_days,
CASE
WHEN prev_discharge IS NOT NULL AND admission_date<=prev_discharge+INTERVAL '30' DAY THEN 1
ELSE 0
END AS is_30day_readmission
FROM patient_metrics
WHERE rnk=1
ORDER BY los_days DESC;