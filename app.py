import os
import sqlite3
import pandas as pd
import matplotlib.pyplot as plt

def init_mock_db():
    conn=sqlite3.connect("clinical_warehouse.db")
    c=conn.cursor()
    c.execute("""
    CREATE TABLE IF NOT EXISTS patients(
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT,
    last_name TEXT,
    dob TEXT,
    gender TEXT
    )""")
    c.execute("""
    CREATE TABLE IF NOT EXISTS encounters(
    encounter_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    admission_date TEXT,
    discharge_date TEXT,
    department TEXT,
    encounter_type TEXT
    )""")
    c.execute("DELETE FROM patients")
    c.execute("DELETE FROM encounters")
    c.executemany("INSERT INTO patients(first_name,last_name,dob,gender) VALUES(?,?,?,?)",[
        ("John","Doe","1985-04-12","M"),
        ("Jane","Smith","1990-08-22","F"),
        ("Alex","Jones","1978-12-05","M"),
        ("Emily","Brown","1995-02-18","F")
    ])
    c.executemany("INSERT INTO encounters(patient_id,admission_date,discharge_date,department,encounter_type) VALUES(?,?,?,?,?)",[
        (1,"2026-10-01 08:00:00","2026-10-05 12:00:00","ICU","Inpatient"),
        (1,"2026-10-20 10:00:00","2026-10-22 14:00:00","Cardiology","Inpatient"),
        (2,"2026-10-10 09:00:00","2026-10-11 11:00:00","Emergency","Outpatient"),
        (3,"2026-10-15 14:00:00","2026-10-25 10:00:00","Orthopedics","Inpatient"),
        (4,"2026-10-18 07:00:00",None,"ICU","Inpatient")
    ])
    conn.commit()
    return conn

def fetch_analytics(conn):
    q="""
    SELECT
    p.patient_id,
    p.first_name||' '||p.last_name AS patient_name,
    e.encounter_id,
    e.department,
    e.admission_date,
    e.discharge_date,
    ROUND((JULIANDAY(COALESCE(e.discharge_date,DATETIME('now')))-JULIANDAY(e.admission_date)),2) AS los_days
    FROM patients p
    JOIN encounters e ON p.patient_id=e.patient_id
    """
    df=pd.read_sql_query(q,conn)
    return df

def generate_report(df):
    os.makedirs("reports",exist_ok=True)
    summary=df.groupby("department")["los_days"].mean().reset_index()
    summary.columns=["department","avg_los_days"]
    summary.to_csv("reports/department_summary.csv",index=False)
    
    plt.figure(figsize=(8,5))
    plt.bar(summary["department"],summary["avg_los_days"],color="navy")
    plt.title("Average Length of Stay (LOS) by Department")
    plt.xlabel("Department")
    plt.ylabel("Days")
    plt.tight_layout()
    plt.savefig("reports/los_by_department.png")
    plt.close()

def run_pipeline():
    conn=init_mock_db()
    df=fetch_analytics(conn)
    generate_report(df)
    conn.close()

if __name__=="__main__":
    run_pipeline()