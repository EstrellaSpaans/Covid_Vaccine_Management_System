# CVS's Covid Vaccination Management System
## MySql Database Project

Sun, Jan 31st 2021

This project focused on the creation of a data management system for the covid-19 vaccine. Tasks included were to define the purpose of the system, design the entity-relationship model, forward engineer it, import the data into the tables, generate ten meaningful reports, and introduce two procedures. 

Collaborator: [Ruisheng Wang](https://github.com/rishonwang) 

## The Purpose

CVS Pharmacy will be one of the leading carriers of the Covid Vaccine in the United States. It is widely known that this company has multiple chains in the United States. They also have an administrative office, which is located in Woonsocket, Rhode Island. Each department will have different dashboards that pull statistics through SQL queries from a database. In this project, we zoomed into the pharmacy locations in Boston. A web-based vaccine administration management application system (VAMS) will be used for each location that supports planning and execution (Centers for Disease Control and Prevention, 2020). The data gathered from the VAMS will be stored in the database.

** Information that can be gathered:**
-  The number of vaccine given by each each staff member and when they worked. 
-  The number of vaccines of each brand that are in stock for each location, which batches are utilized, the most popular location 
-  The number of appointment scheduled for each location and the earliest appointment date. 
-  The number of people of uninsured people with their addresses for potential billing. 
-  The number of people that are fully vaccinated by occupation. 
-  The number of incorrectly given vaccines based on the latest covid test or brand type and by whom they were given. 

## The Data Base Structure 

| Table Name  | Primary Key | Foreign Key | Relationship |
| ------------- | ------------- | ------------- | ------------- |
| admin_info  | location_id	  | | Parent
| departments_info  | department_id | | Parent
| medical_records | medical_record_id | | Parent
| insurance_info | insurance_id | | Parent 
| vaccine_info | vaccine_id | | Parent
| appointment_info | appointment_id	 | patient_id | Parent
| staff_info |staff_id | departments_id | Parent / Child
| patient_id | patient_id | medical_record_id, insurance_id | Parent / Child
| batch_info | batch_no, vaccine_id | vaccine_id | Parent / Child
| vaccine_inventory | vaccine_no | batch_no, vaccine_id, location_id | Parent / Child
| records | record_id | staff_id, patient_id, vaccine_id, vaccine_no, location_id | Child
| test_records | test_record_id, patient_id | | Child


