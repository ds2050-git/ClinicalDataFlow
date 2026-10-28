# ClinicalDataFlow

ClinicalDataFlow is a simple clinical data reporting system designed to store patient records, process health data, and calculate metrics like patient length of stay across departments.

## Repository Structure
```text
.
├── schema.sql           # Table structures and indexes
├── procedures.sql       # PL/SQL functions and procedures
├── analytics.sql        # Analytics queries using SQL
├── app.py               # Main Python execution script
└── requirements.txt     # Required packages
```

## Features
* Clean relational schema for patients, encounters, diagnoses, orders, and events.
* Stored procedures for adding encounters, updating discharges, and computing length of stay.
* Basic composite indexes to speed up joins and query performance.
* Python script that pulls analytics from the database and creates visual reports.

## Quick Start

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ds2050-git/ClinicalDataFlow.git
   cd ClinicalDataFlow
   ```

2. Install packages:
   ```bash
   pip install -r requirements.txt
   ```

### Execution
Run the script:
```bash
python app.py
```

### Outputs
Reports are created inside the `reports/` folder:
* `department_summary.csv` — Average length of stay by department.
* `los_by_department.png` — Visual bar chart of the summary data.
