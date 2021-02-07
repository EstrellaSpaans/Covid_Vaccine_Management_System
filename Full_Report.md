# CVS's Covid Vaccination Management System

# 1. **Flow of System**

CVS Pharmacy will be one of the leading carriers of the Covid Vaccine in the United States. It is widely known that this company has multiple chains in the United States. They also have an administrative office, which is located in Woonsocket, Rhode Island. Each department will have different dashboards that pull statistics through SQL queries from a database. In this assignment, it is assumed that we zoom into the pharmacy locations in Boston. A web-based vaccine administration management application system (VAMS) will be used for each location that supports planning and execution (Centers for Disease Control and Prevention, 2020). The data gathered from the VAMS will be stored in the database. 

**Use Cases:**

Each location has different staff available on-site responsible for managing the pharmacy location operations. Inventory will be handled with the internal VAMS by connecting with an API from the manufacturer that provides information about the type of vaccine and information about the different manufactured batches. This information is needed to store the inventory in optimal conditions and assure that each vaccine gets utilized before the expiration. The information about the vaccine also ensures that the right vaccine is provided for each patient's condition. 

The majority of the staff will be responsible for providing the vaccine to the patient. The VAMS helps CVS's pharmacies to gather the information of each patient. The patient goes to the online portal and enters general patient information into the system. After this information is stored, the patient is able to schedule an appointment through the system for their vaccination. Each patient will be matched with data from other pre-existing information management systems through APIs. This data includes medical records, insurance information, and information from COVID- testing systems.

The appointment day will be confirmed in the (VAMS) by the staff members. When the patients show at the location, the patient's medical record needs to be checked to determine which a doctor prescribes vaccine type. Then, the information from the COVID-testing system needs to be pulled. Vaccines can only be given to people with a negative COVID-19 test result that is not older than seven days. Otherwise, a wait-time of 90 days is required (Mayo Foundation for Medical Education and Research, n.d.). Once all this information is checked, the staff member is ready to provide the vaccine.  

Each vaccination must be recorded and must comply with specific technical standards to share this information with the governmental body, which decided the inventory allocation. The staff worker enters in the id associated with the patient, the vaccine number, the date, and whether it is the first or second shot. Inventory will be updated based on the vaccine number entered (or scanned through a barcode). After the vaccine, the patient will create a second appointment in person, where the staff member enters in the second date, keeping the appropriate waiting time in mind between the shots.

The pharmacy and the staff member's location are automatically recorded when the staff member logs into the system. The record information will be recorded into a master file that contains all locations. At the end of the day, 200,000 rows will be exported to be reported to the government (Centers for Disease Control and Prevention, 2020). This is one of the procedures that is implemented. Every day a specific record_id can be entered into the stored procedure, which generates a report that can be exported as a CSV-file.  


**From the database, it is possible for multiple deparments to track different information:** 

-	The HR department, for instance, can keep track of how many vaccines each staff member has given and when they worked last.
-	The Inventory department can get updates about the daily changes. It is possible to get an overview of each brand's number of vaccines that are in stock for each location. It also shows how much inventory there is for each batch, when it expires, and if the vaccines are utilized correctly. The most popular locations are shown on the side as well to make sure that those locations get priority when allocating inventory.
-	Each location can check the number of unconfirmed appointments that are scheduled for the second shot. This helps to check if the right inventory is in stock for the upcoming days. It is also possible to check if there are appointments for the first and second shot; however, there aren’t any appointments scheduled for shot number one. This is why the appointments for the first shot are not shown in the current dashboard. 
-	The finance staff members at the headquarters can get an overview of all uninsured people with their addresses to make it easier to do billing if this is applicable.
-	Information about the vaccine progress can be reported.  A dashboard presents the number of people that have received both shots of the vaccination.  It also shows how many people have been vaccinated by Occupation. This helps to see whether the vaccination progress is going according to the phases of the government.
-	Administration and operations are responsible for the quality control of the vaccine process. An overview could be generated when the vaccine date does not match the requirement of a seven-day-old test or when the patient's age did not match with the vaccine requirements.  There will also be an overview of all the patients who got the incorrect brand of the vaccine.  Each report will show who was responsible for the mistake.

After the first trial of the data management system, CVS's chief data officer has decided to implement a procedure to update the inventory after a vaccine has been given to a patient to have up to date data. 


# 2. **Database Structure**

![Database Structure](https://static.wixstatic.com/media/3fe52d_1d408210ffc94812971bdc69e2c95f51~mv2.png)

**Table: admin_info**

This table provides information for each location. This includes the address, the CNN number to verify the Medicare/Medicaid certification, and whether the operation is an office or a pharmacy. Number 17 refers to a pharmacy chain [(Centers for Disease Control and Prevention, 2020)](https://www.cdc.gov/vaccines/covid-19/reporting/requirements/specification-instructions.html).

**Table: departments_info**

The department table shows the name of each department that is available in each pharmacy.

**Table: medical_records**

The medical record table shows the information needed on whether someone is eligible to receive a specific vaccine based on a prescribed recommendation. A medical record is only created once a doctor has entered the prescription into an API system.

**Table: insurance_info**

The insurance information table shows whether the person is insured. The finance department will know whether they have to send the bill for the vaccine costs to the insurance company or to the patient (if this is applicable). The data includes a unique id associated with the patient, the provider name, the start/end date of a specific plan, and the amount covered. This information is retrieved by an API once the patient is identified and shared with the insurance id.

**Table: vaccine_info**

This table provides more information about the vaccine itself: the name, the manufacturer, a description, the age restrictions, and the dose. When providing the vaccine, healthcare workers need to be aware of these conditions during the immunization process.

**Table: appointment_info**

This table shows the information for the first appointment for the first shot and the second appointment for the second shot. This table will be checked by a staff member when a patient arrives. It is able to be updated in the portal by the patient or by a staff member.

**Table: staff_info**

The staff table provides a detailed overview of each employee: name, surname, department, date_of_birth, and at which location they work.

**Table: patient_info**

This table shows each patient's general information and connections to the medical information, insurance information, test results, and scheduled appointments.

**Table: batch_info**

The information in the batch_info table shows info for each batch, such as temperature, storage info, and when the vaccine expires.

**Table: vaccine_inventory**

This table shows the number of vaccines that are in each location. Each vaccine has a batch number, a vaccination id (which refers to the type of vaccine and manufacturers), and a unique vaccine number.

**Table: test_records**

This table shows the latest COVID-19 test of the patient and the results.

# 3. **Entity-Relational (ER) Model**

![ER-Model](https://static.wixstatic.com/media/3fe52d_2b22c6baa1034741bc2048c9448fa909~mv2.png)

# 4. Meaningful Insights

### 1. **Report: HR Daily Stats**

This report shows how many patients each employee has vaccinated. It also shows the latest workday. This gives a sense of hours as well as the performance of each employee. It is important to keep track of when the staff are deployed. 

```sql
/* - COLUMNS: staff_id,staff_name,Number of Shot,Latest Work Date,Location
   - AGGREGATIONS: concat_ws(",",s.first_name,s.last_name),COUNT(r.record_id)
   - TABLES: records, admin_info, departments_info,staff_info
   - JOINS: INNER JOIN admin_info with location_id
						INNER JOIN staff_info with location_id
						INNER JOIN departments_info with department_id
   - GROUP BY: s.staff_id, a.street, r.date_shot, concat_ws(",",s.first_name,s.last_name)*/

SELECT 
	  s.staff_id,
    concat_ws(",",s.first_name,s.last_name) AS "Staff Name", 
    COUNT(r.record_id) AS "Number of Shot",
    r.date_shot AS "Latest Work Date",
    a.street AS "Location"
FROM 
	records AS r, 
	admin_info AS a, 
	departments_info AS d,
	staff_info AS s
WHERE 
	r.location_id = a.location_id
AND 
	s.location_id = a.location_id
AND 
	d.department_id = s.department_id
AND 
	d.department_name = "Service"
AND
	r.date_shot = (SELECT MAX(r.date_shot)
				  FROM records AS rr
				  WHERE rr.record_id = r.record_id)
GROUP BY
	s.staff_id,
  a.street,
	r.date_shot,
	concat_ws(",",s.first_name,s.last_name)    
ORDER BY
	MAX(r.date_shot) DESC;
```

R**esult:**

![results_report_1](https://static.wixstatic.com/media/3fe52d_34d5e3457553492cb2b0f628242b2df7~mv2.jpg)

**Insights can be drawn:**

-	Some staff are not working enough hours. The efficiency varies greatly showing that some staff are able to vaccinate more people in less time. The patients seen and division of work differs in each location.
- 	The number of staff working on each day is growing gradually, which means if the company wants to save the labor cost, they need to train the staff to service more patients daily.


### 2. **Report: Stock Brand Inventory**

This query is essential in order to know how many vaccinations each location has left. As a pharmacy, you want to match the demand (based on the appointments) and make sure that the right brand is in stock. This query shows each location number, the type of vaccine, and the number of vaccines they still have left in stock. Showing the records where there is a NULL value means that the vaccine is not used yet. This query shows an overview of all stock details.

```sql
/* - COLUMNS: location_id, vaccine_name
   - AGGREGATIONS: COUNT(vaccine_number)
   - TABLES: vaccine_inventory, vaccine_info, records
   - JOINS: LEFT JOIN vaccine_inventory with vaccine_info
				    LEFT JOIN vaccine_inventory with records
   - GROUP BY: By each vaccination brand */

SELECT 
	inv.location_id AS "Loc Number", 
	adm.street AS "Location", 
	info.vaccine_name AS "Vaccine", 
	COUNT(inv.vaccine_no) AS "Available Inventory"
FROM 
	vaccine_inventory AS inv
LEFT JOIN 
	vaccine_info AS info
ON 
	inv.vaccine_id = info.vaccine_id
LEFT JOIN 
	records as rec
ON 
	inv.vaccine_no = rec.vaccine_no
LEFT JOIN 
	admin_info AS adm
ON 
	inv.location_id = adm.location_id
WHERE 
	rec.record_id IS NULL
GROUP BY 
	inv.location_id, inv.vaccine_id
ORDER BY 
	inv.location_id, inv.vaccine_id;
```

**Result:** 

![results_report_2](https://static.wixstatic.com/media/3fe52d_d13983d906884f2c9a2e2b4d011acda2~mv2.jpg)

**Insights that can be drawn:** 

-	Locations 6,7,8,10 has the least inventory (below 120 vaccines in total). 
-	The location on Boylston Street only has 3 Moderna vaccines left. 
-	There are more Moderna vaccines in stock compared to the Phizers BioNTech vaccine. 


### 3**. Report: Stock Batch Inventory with Expiration Days**

To manage inventory properly, the batches that expire the earliest should be consumed first. Inventory staff members are responsible for adding each batch into the inventory correctly, sorted from the earliest to the latest date. The service staff members have to make sure that they pick the right vaccine number and not accidentally choose a later batch. However, there will always be a case that the wrong batch gets selected because of human error. 

```sql
/* - COLUMNS: batch_no, vaccine_no, expiration_date
   - AGGREGATIONS: COUNT(),DATEDIFF()
   - TABLES: vaccine_inventory, batch_info, records
   - JOINS: LEFT JOIN vaccine_inventory with batch_info
						LEFT JOIN vaccine_inventory with records
   - GROUP BY: batch, expiration date
	 - ORDER BY: days expiring */

SELECT 
	bat.batch_no AS "Batch Number", 
  COUNT(inv.vaccine_no) AS "Inventory",
  bat.expiration_date AS "Expiration Date", 
  DATEDIFF(bat.expiration_date,DATE(NOW())) AS "Days Left"
FROM 
	vaccine_inventory AS inv
LEFT JOIN 
	batch_info AS bat
ON 
	inv.batch_no = bat.batch_no
LEFT JOIN 
	records as rec
ON 
	inv.vaccine_no = rec.vaccine_no
WHERE 
	rec.record_id IS NULL 
GROUP BY 
	inv.batch_no, 
    bat.expiration_date
ORDER BY 
	DATEDIFF(bat.expiration_date,DATE(NOW())) ASC;
```

**Result:**

![reports_result_3](https://static.wixstatic.com/media/3fe52d_55cc8b244d4b41afb9e803f95dbd2079~mv2.jpg)

**Insights that can be drawn:** 

-	Batches are not chosen correctly or sorted correctly as some batches that have a later expiration date have less inventory than batches with a sooner expiration date.

### 4. Report: Top 3 Pharmacy Locations

To reallocate inventory within the CVS branches in Boston or to receive inventory in general, it is essential to know which locations are the most visited. These locations have to make sure that they have enough inventory. In combination with the previous question, CVS can now better grasp how to allocate the inventory. 

```sql
/* - COLUMNS: street, record_id
   - AGGREGATIONS: COUNT(record_id)
   - TABLES: records, admin_info
   - JOINS: LEFT JOIN records with admin_info
   - GROUP BY: location
	 - ORDER BY: aggregation COUNT
   - RESULT: 3 ROWS */

SELECT adm.street AS "Location Name", COUNT(r.record_id) AS "Number Vaccines"
FROM records as r
LEFT JOIN admin_info AS adm
ON adm.location_id = r.location_id
GROUP BY adm.location_id
ORDER BY COUNT(r.record_id)
LIMIT 3;
```

**Result:**

![report_4_results](https://static.wixstatic.com/media/3fe52d_de63f501efb54e3ea74ba97fb0d2248f~mv2.jpg)

**Insights that can be drawn:** 

-	In order to meet the demand, the pharmacy located at '285 Columbus Ave.' does not have a lot of inventory available.

### 5**. Report: Uninsured-Patients Administration**

This query is important because it will list all the people who do not have insurance. The address of each patient is also presented, making it easier for the finance department to send a bill to each of these people (if this is applicable).

```sql
/* - COLUMNS: patient name, street, zip, city, state 
   - AGGREGATIONS: concat_ws(first_name, last_name)
   - TABLES: insurance_info, patient_info, records
   - JOINS: RIGHT JOIN patient_info with records
				    LEFT JOIN patient_info with insurance_info
   - GROUP BY: patients*/

SELECT 
	concat_ws(" ",p.first_name,p.last_name) AS "Patient Name", 
	p.street_address AS "Street", 
	p.zip_code AS "Zip", 
	p.city AS "City", 
	p.state AS "State"
FROM 
	patient_info AS p
RIGHT JOIN 
	records AS rec
ON 
	p.patient_id = rec.patient_id
LEFT JOIN 
	insurance_info AS insur
ON 
	p.insurance_id = insur.insurance_id
WHERE 
	insur.insurance_id IS NULL
GROUP BY 
	p.patient_id;
```

**Result**:

![result_5_report](https://static.wixstatic.com/media/3fe52d_173bcdd5fb724f1fa1b977dbd364c224~mv2.jpg)

**Insights that can be drawn:** 

-	Approximately 70% of the uninsured 104 people  live in the suburbs of Boston.

### 6**.  Report: Fully Vaccinated Patients**

This information is essential information that can be shared with the government. It keeps track of the number of people that had both of their shots regardless of the type of vaccine. An accumulative overview of all vaccination locations gives the government a full view of each state's immunization progress.

```sql
/* - COLUMNS: vaccine_name, shot_no
   - AGGREGATIONS: COUNT(shot_no)
   - TABLES: records, vaccine_inventory, vaccine_info
   - JOINS: INNER JOIN vaccine_inventory with records
				    INNER JOIN vaccine_inventory with vaccine_info
   - CONDITION: shot_no = 2
   - GROUP BY: By each vaccination brand */

SELECT 
	vac.vaccine_name AS "Vaccine", 
	COUNT(rec.shot_no) AS "Number of people"
FROM 
	vaccine_inventory AS inf
INNER JOIN 
	records AS rec
ON 
	inf.vaccine_no = rec.vaccine_no
INNER JOIN 
	vaccine_info AS vac
ON 
	inf.vaccine_id = vac.vaccine_id
WHERE 
	rec.shot_no = 2
GROUP BY 
	vac.vaccine_name;
```

**Result:**

![report_result_6](https://static.wixstatic.com/media/3fe52d_82a51567c47742348f571e53017e1c6a~mv2.jpg)

**Insights can be drawn:** 

-	There are more people with the Moderna vaccine that are vaccinated at the moment.

### 7**. Report: Fully Vaccinated Patients By Occupation**

The query indicates how many people in different Occupations have been vaccinated who live in Boston. This query could give the government additional information on whether most people are vaccinated according to the vaccine release stages.  

```sql
/* - COLUMNS: Occupation,Number of People
   - AGGREGATIONS: count(*)
   - TABLES: patient_info,records
   - Filter the specific location
	 - Group BY: occupation
	 - Order By: count(*) DESC*/

SELECT 
	occupation as Occupation,count(*) as "Number of People"
FROM 
	patient_info as p
JOIN 
	records as r
ON 
	p.patient_id = r.patient_id
WHERE 
	p.city = "Boston"
AND 
	r.shot_no = 2
GROUP BY 
	occupation
Order BY 
	count(*) DESC;
```

**Result:** 

![report_7_result](https://static.wixstatic.com/media/3fe52d_1e1b3116646f485ab9824a84136e4aba~mv2.jpg)

### 8**. Report: Incorrectly given Vaccines: Covid-19 test**

How many patients received the vaccine despite having a "negative" test result older than seven days? This query was created to check if the staff members made a mistake. Considering the vaccine's effectiveness, patients need to show the negative testing result they got within 7 days prior to their vaccination. This report is created with a view, which makes it easy to access the report. 

```sql
/* - Create a View named 7_days_ahead_testing 
	 - COLUMNS: patient name, test_date,date_shot
   - AGGREGATIONS: MAX(test_date)
   - TABLES: patient_info,test_records,records
   - JOINS: JOIN patient_info with patient_id
				    JOIN test_records with patient_id
						JOIN records with patient_id
	 - FILTER test_result with negative before the 1st shot
   - VIEW: yes */

CREATE VIEW 7_days_ahead_testing
 AS   
SELECT 
	concat_ws(",",p.first_name,p.last_name) AS "Patient Name", 
	t.test_date "Test Date", 
	r.date_shot AS "Shot Date",
  (datediff(date_shot,test_date)- 7) AS "Days Past Requirement",
  s.staff_id AS "Staff Number",
  concat_ws(",",s.first_name,s.last_name) AS "Staff Name",
  a.street AS "Location Name"
FROM 
	patient_info AS p, 
	test_records AS t, 
	records AS r,
  staff_info AS s,
  admin_info AS a
WHERE 
	p.patient_id = t.patient_id
AND 
	p.patient_id= r.patient_id
AND 
	r.staff_id = s.staff_id
AND 
	r.location_id = a.location_id
AND
	t.test_date = (SELECT MAX(tt.test_date)
							   FROM test_records AS tt
							   WHERE t.patient_id = tt.patient_id)
AND 
	t.test_result = "negative"
AND 
	r.shot_no = 1;
 
-- Use the view to check if there are records with date differnt more than 7
-- datediff(date_shot,test_date)

SELECT 
	*
FROM 
	7_days_ahead_testing
WHERE 
	datediff(date_shot,test_date)>7;
```

**Result:**

![result_report_8](https://static.wixstatic.com/media/3fe52d_db5d7f156f2b472899292cc6ce52736c~mv2.jpg)

**Insights can be drawn:** 

-	The query returned 1 row, which indicates that the service team in the CVS should take more training to make sure all patients got the negative test result within seven days before accepting the vaccine.

### 9**Report: Incorrectly given Vaccines: Brand**

This report shows whether an error has occurred in the vaccination process. Certain vaccines are meant for different age groups. Only BioNTech can be given to patients between 16 and 18 years old. If the patients in this age group take the Moderna vaccination, it means the staff gave the shot in error.

```sql
/* - COLUMNS: Patient Name,Recommendation,Age,Vaccine Given,shot_no,
		 Status,staff_id,Staff Name,Location Name
   - AGGREGATIONS: concat_ws(",",p.first_name, p.last_name),
		 ROUND((DATEDIFF(DATE(NOW()),p.date_of_birth))/365,0)
   - CASE:  WHEN m.vaccine_prescription <> v.vaccine_name
						THEN "Mistake"
					  ELSE "Not Mistake"
					  END AS "Status",
	 - TABLES: medical_records,patient_info, records,vaccine_inventory,
						vaccine_info,staff_info,admin_info
   - JOINs: INNER JOIN patient_info with medical_record_id
						RIGHT JOIN records with patient_id
						LEFT JOIN vaccine_inventory with vaccine_no
					  LEFT JOIN vaccine_info with vaccine_id
						LEFT JOIN staff_info with staff_id
						LEFT JOIN admin_info with location_id
	 - HAVING: status = "Mistake"*/

SELECT 
	concat_ws(",",p.first_name, p.last_name) AS "Patient Name", 
  m.vaccine_prescription AS "Recommendation", 
  ROUND((DATEDIFF(DATE(NOW()),p.date_of_birth))/365,0) AS Age,
  v.vaccine_name AS "Vaccine Given", 
  r.shot_no,
  CASE 
	WHEN m.vaccine_prescription <> v.vaccine_name
	THEN "Mistake"
  ELSE "Not Mistake"
  END AS "Status",
	s.staff_id,
  concat_ws(",",s.first_name,s.last_name) AS "Staff Name",
  a.street aS "Location Name"
FROM 
	medical_records AS m
INNER JOIN 
	patient_info AS p
ON 
	p.medical_record_id = m.medical_record_id
Right JOIN 
	records AS r
ON 
	r.patient_id = p.patient_id
LEFT JOIN 
	vaccine_inventory AS inv
ON 
	inv.vaccine_no = r.vaccine_no
LEFT JOIN 
	vaccine_info AS v
ON 
	v.vaccine_id = inv.vaccine_id
LEFT JOIN 
	staff_info AS s
ON 
	s.staff_id = r.staff_id
LEFT JOIN 
	admin_info AS a
ON 
	a.location_id = r.location_id
HAVING 
	status = "Mistake";
```

**Result:**

![result_9_report](https://static.wixstatic.com/media/3fe52d_d4d9ff725dda4444a93835b5818b12fe~mv2.jpg)

**Insights can be drawn:**

-	Staff members Jeffrey and Carolyn made mistakes with the same patient, which means they need more training on how to check the medical recommendations to avoid repeating this mistake in the future.

### 10**.  How many 2nd appointments are scheduled per location?**

After the first shot, the patients need to make appointments for the 2nd shot. Due to the fact that there are no walk-in sessions for the vaccine, each patient has to schedule an appointment in order to get the vaccine. This is due to the limited number of vaccines available and the government’s plan. The staff must check the patient’s info and confirm the appointment to make sure it is valid. This query shows how many appointments have not been confirmed, and how soon they will likely be confirmed based on availability.

```sql
/* - COLUMNS: Unconfirmed 2nd shot, the earliest appointment
   - AGGREGATIONS: count(appointment_date_2),min(appointment_date_2)
   - TABLES: appointment_info, admin_info
	 - Filter: status*/

SELECT 
	  ad.street as "Location Name",
    location_id_ap2 AS "Location", 
    COUNT(appointment_date_2) AS "Number Unconfirmed", 
    MIN(appointment_date_2) as "Earliest Appointment"
FROM 
	appointment_info as a ,admin_info as ad
WHERE  
	ad.location_id = a.location_id_ap2
AND status_2 = "unconfirmed"
GROUP BY location_id_ap2,ad.street
ORDER BY MIN(appointment_date_2);
```

**Result:**

![result_10_report](https://static.wixstatic.com/media/3fe52d_fe3dfbf040b141ab98b264140c7693d0~mv2.jpg)

**Insights can be drawn:**

-	At least 4+ vaccines are needed in inventory in order to meet the demand for upcoming second shots.

# 5. SQL Procedures

### 1. Updating Table: Inventory

After considering the data structure, management has decided that the vaccine inventory needs to be updated in real-time when a vaccine is used. This means that additional columns are required: date_used, used_by, and the staff_idd column name gets updated to added_by to avoid confusion between the different staff members who added to the inventory sheet and who used the vaccine on the patient.

```sql
-- Adding and altering columns
ALTER TABLE `csv_database`.`vaccine_inventory` 
ADD COLUMN `date_used` DATE NULL DEFAULT NULL AFTER `staff_id`,
ADD COLUMN `used_by` INT NULL DEFAULT NULL AFTER `date_used`
CHANGE COLUMN `staff_id` `added_by` INT NOT NULL ;

-- Adding new foreign key to column
ALTER TABLE `csv_database`.`vaccine_inventory` 
ADD INDEX `fk_vaccine_inventory_service_idx` (`staff_id_service` ASC) VISIBLE;
;
ALTER TABLE `csv_database`.`vaccine_inventory` 
ADD CONSTRAINT `fk_vaccine_inventory_service`
  FOREIGN KEY (`used_by`)
  REFERENCES `csv_database`.`staff_info` (`staff_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
```

**Procedure details:** 

- Schema Name: vaccine_inventory
- Object Name: inventory_update
- Input: vaccine_no, date, staff_id
- Output Updated columns: date_used, used_by
- Functionality: This SQL procedure makes sure that when a vaccine has been given to a patient, the staff member will update the inventory.

**Procedure Code**

```sql
CREATE PROCEDURE `inventory_update`(IN in_vaccine_no DOUBLE, IN in_staff_id INT, 
IN in_dated DATE)

BEGIN

UPDATE vaccine_inventory
SET 
    staff_id_service = in_staff_id
WHERE
    vaccine_no = in_vaccine_no;

UPDATE vaccine_inventory
SET 
    date_used = in_dated
WHERE
    vaccine_no = in_vaccine_no;
END
```

**Procedure Call**

```sql
-- CALL `csv_database`.`inventory_update`(vaccine_no, staff_id, 'date');
   CALL `csv_database`.`inventory_update`(1226481284, 69, '2021-01-01');
```

**Result:** 

![procudre_result_1](https://static.wixstatic.com/media/3fe52d_3d190e296acc41a4a1b6a5c4b87efd7f~mv2.jpg)

### 2. **Report: Government Export File**

Every day, a report needs to be generated that can contain 200.000 rows. The report cannot include previously exported records. Therefore, it is crucial to keep track of the last record_id that has been exported. The following day, the following record_id number has been entered as the starting point of the new report. 

**Procedure details:** 

- Schema Name: records, vaccine_info, vaccine_inventory, patient_info, admin_info, staff_info
- Object Name: records_export
- Input: record_id
- Functionality: The procedure generates an overview of all the columns that need to be recorded for all records that have not been exported yet.

In the future, the company can add an INTO OUTFILE possibility. This automatically generates a CSV file that is ready to go.

```sql
CREATE PROCEDURE `records_export`(IN in_record_no INT)
BEGIN

SELECT 
	r.record_id,
	concat_ws(",",p.first_name, p.last_name) AS "Patient Name", 
	r.shot_no AS "Shot NO", 
	r.date_shot AS "Shot Date", 
	r. vaccine_no AS "Vaccine NO",
	v.vaccine_name AS "Vaccine",
	a.street AS "Given at",
	concat_ws(",",s.first_name, s.last_name) AS "Given By",
	a.CNN AS "Pharmacy CNN", 
	CURRENT_TIMESTAMP  AS "Export Date"
FROM 
	records AS r
LEFT JOIN 
	vaccine_inventory AS inv
ON 
	inv.vaccine_no = r.vaccine_no
LEFT JOIN 
	vaccine_info AS v
ON 
	inv.vaccine_id = v.vaccine_id
LEFT JOIN 
	patient_info AS p
ON 
	p.patient_id = r.patient_id
LEFT JOIN 
	admin_info AS a
ON 
	r.location_id = a.location_id
LEFT JOIN 
	staff_info AS s
ON 
	s.staff_id = r.staff_id
WHERE record_id >= in_record_no
LIMIT 200000; 
END
```

**Call the procedure**

Example: It is assumed that record_id 1 to 55, we part of yesterdays' report. Today, a new report needs to be generated, starting from record_id 56. This generated a report of up to 200000 different records. At the moment, there are only 486 records available, which means the last record on this report is 541. 

Tomorrow's report should start at 542. Right now, this one is empty, as there are no records for this one yet.

```sql
-- Call the procedure with the specific record_id 56. 
CALL `csv_database`.`records_export`(56);

-- Call the procedure with the specific record_id 542. 
CALL `csv_database`.`records_export`(542);
```

**Result:**

![procedure_report_2](https://static.wixstatic.com/media/3fe52d_14742d13fae34f6aad0a276800fc05bb~mv2.jpg)

# 6. **Appendix**

## 6.1 Create Table Scripts

```sql
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema csv_database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `csv_database` DEFAULT CHARACTER SET utf8 ;
USE `csv_database` ;

-- -----------------------------------------------------
-- Table `csv_database`.`medical_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`medical_records` (
  `medical_record_id` VARCHAR(7) NOT NULL,
  ` vaccine_prescription` VARCHAR(45) NULL,
  PRIMARY KEY (`medical_record_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`insurance_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`insurance_info` (
  `insurance_id` VARCHAR(10) NOT NULL,
  `insurance_provider` VARCHAR(45) NOT NULL,
  `amount_coverage` INT(4) NOT NULL,
  `insurance_start_date` DATE NOT NULL,
  `insurance_end_date` DATE NOT NULL,
  PRIMARY KEY (`insurance_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`appointment_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`appointment_info` (
  `appointment_id` VARCHAR(3) NOT NULL,
  `appointment_date_1` DATETIME NULL DEFAULT NULL,
  `status_1` ENUM('confirmed', 'unconfirmed') NULL DEFAULT NULL,
  `appointment_date_2` DATETIME NULL DEFAULT NULL,
  `status_2` ENUM('confirmed', 'unconfirmed') NULL DEFAULT NULL,
  `location_id_ap1` INT NULL DEFAULT NULL,
  `location_id_ap2` INT NULL DEFAULT NULL,
  PRIMARY KEY (`appointment_id`))
ENGINE = InnoDB

-- -----------------------------------------------------
-- Table `csv_database`.`patient_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`patient_info` (
  `patient_id` INT(3) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `street_address` VARCHAR(45) NOT NULL,
  `zip_code` INT(5) NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `phone_number` VARCHAR(10) NOT NULL,
  `email_address` VARCHAR(45) NOT NULL,
  `occupation` VARCHAR(45) NOT NULL,
  `gender` ENUM('M', 'F') NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `medical_record_id` VARCHAR(7) NULL,
  `insurance_id` VARCHAR(10) NULL,
  `appointment_id` VARCHAR(3) NULL,
  PRIMARY KEY (`patient_id`),
  INDEX `fk_patient_info_medical_records1_idx` (`medical_record_id` ASC) VISIBLE,
  INDEX `fk_patient_info_insurance_info1_idx` (`insurance_id` ASC) VISIBLE,
  INDEX `fk_patient_info_appointment_info1_idx` (`appointment_id` ASC) VISIBLE,
  CONSTRAINT `fk_patient_info_medical_records1`
    FOREIGN KEY (`medical_record_id`)
    REFERENCES `csv_database`.`medical_records` (`medical_record_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_patient_info_insurance_info1`
    FOREIGN KEY (`insurance_id`)
    REFERENCES `csv_database`.`insurance_info` (`insurance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_patient_info_appointment_info1`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `csv_database`.`appointment_info` (`appointment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`admin_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`admin_info` (
  `location_id` INT(2) NOT NULL,
  `admin_type` INT(2) NOT NULL,
  `location_type` ENUM('office', 'pharmacy') NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `zip_code` INT(5) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `CNN` DOUBLE NOT NULL,
  PRIMARY KEY (`location_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`vaccine_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`vaccine_info` (
  `vaccine_id` VARCHAR(2) NOT NULL,
  `vaccine_name` VARCHAR(45) NOT NULL,
  `vaccine_description` VARCHAR(255) NOT NULL,
  `manufacturing_name` VARCHAR(45) NOT NULL,
  `wait_days` INT(2) NOT NULL,
  `dose_mL` DECIMAL(1) NOT NULL,
  `age_restriction` INT(2) NOT NULL,
  PRIMARY KEY (`vaccine_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`batch_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`batch_info` (
  `batch_no` VARCHAR(4) NOT NULL,
  `release_date` DATE NOT NULL,
  `expiration_date` DATE NOT NULL,
  `vaccine_temperature` INT(2) NOT NULL,
  `vaccine_id` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`batch_no`, `vaccine_id`),
  INDEX `fk_batch_info_vaccine_info1_idx` (`vaccine_id` ASC) VISIBLE,
  CONSTRAINT `fk_batch_info_vaccine_info1`
    FOREIGN KEY (`vaccine_id`)
    REFERENCES `csv_database`.`vaccine_info` (`vaccine_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`departments_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`departments_info` (
  `department_id` INT(2) UNSIGNED NOT NULL,
  `department_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`staff_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`staff_info` (
  `staff_id` INT(3) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `location_id` INT(2) NOT NULL,
  `department_id` INT(2) UNSIGNED NOT NULL,
  PRIMARY KEY (`staff_id`),
  INDEX `fk_staff_info_departments_info1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_staff_info_departments_info1`
    FOREIGN KEY (`department_id`)
    REFERENCES `csv_database`.`departments_info` (`department_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`vaccine_inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`vaccine_inventory` (
  `vaccine_no` DOUBLE NOT NULL,
  `batch_no` VARCHAR(4) NOT NULL,
  `vaccine_id` VARCHAR(2) NOT NULL,
  `location_id` INT(2) NOT NULL,
  `date_added` DATE NULL,
  `staff_id` INT(3) NOT NULL,
  INDEX `fk_vaccine_inventory_batch_info1_idx` (`batch_no` ASC) VISIBLE,
  INDEX `fk_vaccine_inventory_vaccine_info1_idx` (`vaccine_id` ASC) VISIBLE,
  PRIMARY KEY (`vaccine_no`),
  INDEX `fk_vaccine_inventory_admin_info1_idx` (`location_id` ASC) VISIBLE,
  INDEX `fk_vaccine_inventory_staff_info1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_vaccine_inventory_batch_info1`
    FOREIGN KEY (`batch_no`)
    REFERENCES `csv_database`.`batch_info` (`batch_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vaccine_inventory_vaccine_info1`
    FOREIGN KEY (`vaccine_id`)
    REFERENCES `csv_database`.`vaccine_info` (`vaccine_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vaccine_inventory_admin_info1`
    FOREIGN KEY (`location_id`)
    REFERENCES `csv_database`.`admin_info` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vaccine_inventory_staff_info1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `csv_database`.`staff_info` (`staff_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `csv_database`.`records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`records` (
  `record_id` INT(3) NOT NULL,
  `shot_no` INT(1) NOT NULL,
  `date_shot` DATE NOT NULL,
  `patient_id` INT(3) NOT NULL,
  `location_id` INT(2) NOT NULL,
  `vaccine_no` DOUBLE NOT NULL,
  `staff_id` INT(3) NOT NULL,
  PRIMARY KEY (`record_id`),
  INDEX `fk_records_patient_info1_idx` (`patient_id` ASC) VISIBLE,
  INDEX `fk_records_admin_info1_idx` (`location_id` ASC) VISIBLE,
  INDEX `fk_records_vaccine_inventory1_idx` (`vaccine_no` ASC) VISIBLE,
  INDEX `fk_records_staff_info1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_records_patient_info1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `csv_database`.`patient_info` (`patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_records_admin_info1`
    FOREIGN KEY (`location_id`)
    REFERENCES `csv_database`.`admin_info` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_records_vaccine_inventory1`
    FOREIGN KEY (`vaccine_no`)
    REFERENCES `csv_database`.`vaccine_inventory` (`vaccine_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_records_staff_info1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `csv_database`.`staff_info` (`staff_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

```

```sql
-- -----------------------------------------------------
-- Table `csv_database`.`test_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`test_records` (
  `test_record_id` VARCHAR(7) NOT NULL,
  `test_date` DATE NULL,
  `test_result` ENUM('positive', 'negative') NOT NULL,
  `patient_id` INT(3) NOT NULL,
  PRIMARY KEY (`test_record_id`, `patient_id`),
  INDEX `fk_test_records_patient_info1_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `fk_test_records_patient_info1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `csv_database`.`patient_info` (`patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
```

## 6.2 Insert scripts in Order

```sql
-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 297 rows: `appointment_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`appointment_info`
(`appointment_id`,`appointment_date_1`,`status_1`,`appointment_date_2`,`status_2`,
`location_id_ap1`,`location_id_ap2`)
VALUES ('1','2021-01-01 12:00:00','confirmed','2021-01-29 12:00:00','confirmed',5,2),
('10','2021-01-01 12:00:00','confirmed','2021-01-29 12:00:00','confirmed',3,2),
('100','2021-01-06 13:00:00','confirmed','2021-02-03 14:00:00','confirmed',8,7),
('101','2021-01-06 13:00:00','confirmed','2021-02-03 14:00:00','confirmed',2,9),
('102','2021-01-06 13:00:00','confirmed','2021-01-27 09:00:00','confirmed',7,8),
('103','2021-01-06 13:00:00','confirmed','2021-01-27 09:00:00','confirmed',6,9),
('104','2021-01-06 13:00:00','confirmed','2021-01-27 09:00:00','confirmed',5,4),
('105','2021-01-06 13:00:00','confirmed','2021-01-27 09:00:00','confirmed',8,9),
('106','2021-01-06 13:00:00','confirmed','2021-01-27 09:00:00','confirmed',3,7),
('107','2021-01-06 13:00:00','confirmed','2021-02-03 12:00:00','confirmed',2,10)

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 300 rows:`insurance_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`insurance_info`
(`insurance_id`,`insurance_provider`,`amount_coverage`,`insurance_start_date`,
`insurance_end_date`) VALUES 
('i911872370','UnitedHealth',6000,'2019-04-08','2020-04-07'),
('i912126777','AnthemInc',6000,'2019-06-26','2020-06-25'),
('i912329729','Wellcare',5000,'2019-06-08','2020-06-07'),
('i912856366','Wellcare',4000,'2019-08-15','2020-08-14'),
('i912890364','Wellcare',4000,'2019-05-27','2020-05-26'),
('i913038019','AnthemInc',6000,'2019-04-24','2020-04-23'),
('i913942068','Wellcare',3500,'2019-08-07','2020-08-06'),
('i914126172','KaiserFoundation',3500,'2019-11-01','2020-10-31'),
('i914350710','BlueCrossBlueShield',6000,'2019-07-14','2020-07-13'),
('i914371409','BlueCrossBlueShield',6000,'2019-07-18','2020-07-17'); 

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 297 rows:`medical_records`
-- -----------------------------------------------------
INSERT INTO `medical_records` VALUES 
('m115457','Moderna'),
('m121396','Moderna'),
('m122256','Moderna'),
('m122524','Moderna'),
('m124148','Moderna'),
('m125135','BioNTech'),
('m126177','BioNTech'),
('m129645','BioNTech'),
('m131121','BioNTech'),
('m133064','BioNTech'))

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 500 rows:`patient_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`patient_info`
(`patient_id`,`first_name`,`last_name`,`street_address`,`zip_code`,`state`,
`city`,`phone_number`,`email_address`,`occupation`,`gender`,`date_of_birth`,
`medical_record_id`,`insurance_id`,`appointment_id`)
VALUES 
(1,'MARY','SMITH','1 Shore Ave.',2101,'MA','Boston','7748361034',
'MARY.SMITH@sakilacustomer.org','Student ','M','1970-01-28','m516751','i919802484','148'),
(2,'PATRICIA','JOHNSON','1 South Gates St.',2122,'MA','Quincy','6991471651',
'PATRICIA.JOHNSON@sakilacustomer.org','Student ','M','1979-01-13','m143181','i987766319','20'),
(3,'LINDA','WILLIAMS','10 Walnut St.',2124,'MA','Somerville ','4972917751',
'LINDA.WILLIAMS@sakilacustomer.org','Student ','F','1983-12-14',NULL,'i952046885',NULL),
(4,'BARBARA','JONES','11 St Louis St.',2125,'MA','Malden','7021027258',
'BARBARA.JONES@sakilacustomer.org','Teacher ','F','1989-02-07',NULL,NULL,NULL),
(5,'ELIZABETH','BROWN','111 Creekside St.',2121,'MA','Revere','4892833945',
'ELIZABETH.BROWN@sakilacustomer.org','Sales ','M','1977-08-31',NULL,NULL,NULL),
(6,'JENNIFER','DAVIS','119 Prince Lane',2241,'MA','Boston','2977980314',
'JENNIFER.DAVIS@sakilacustomer.org','Manager ','F','1981-12-26','m420025',NULL,'109'),
(7,'MARIA','MILLER','122 Golf Rd.',2297,'MA','Boston','7517057834',
'MARIA.MILLER@sakilacustomer.org','Doctor ','M','1980-12-03','m391950',NULL,'101'),
(8,'SUSAN','WILSON','13 Grandrose Rd.',2467,'MA','Brooklin','7263122172',
'SUSAN.WILSON@sakilacustomer.org','Engineer','F','1989-04-05','m495255',NULL,'135'),
(9,'MARGARET','MOORE','15 Grand Rd.',1601,'MA','Worcester','2384955834',
'MARGARET.MOORE@sakilacustomer.org','Manager ','F','1970-04-16','m376961','i968932859','92'),
(10,'DOROTHY','TAYLOR','153 Tanglewood Street',1653,'MA','Worcester','8729292963',
'DOROTHY.TAYLOR@sakilacustomer.org','Doctor ','F','1993-11-03','m465401','i946997487','123');

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 OF 650 rows:`test_records`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`test_records`
(`test_record_id`,`test_date`,`test_result`,`patient_id`)
VALUES ('t000001','2020-12-30','negative',274),
('t000002','2020-12-30','negative',218),
('t000003','2020-12-30','negative',344),
('t000004','2020-12-30','negative',246),
('t000005','2020-12-30','negative',60),
('t000006','2020-12-31','negative',325),
('t000007','2020-12-31','negative',204),
('t000008','2020-12-31','negative',270),
('t000009','2020-12-31','negative',271),
('t000010','2020-12-31','negative',77),
('t000011','2020-12-31','negative',64);

-- -----------------------------------------------------
-- EXAMPLE INSERT ALL rows:`departments_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`departments_info`
(`department_id`,`department_name`)
VALUES (1,'IT'),
(2,'HR'),
(3,'Inventory'),
(4,'Logistics'),
(5,'Administration'),
(6,'Service'),
(7,'Consulting '),
(8,'Finance'),
(9,'Operation'),
(10,'Legal');

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 334 rows:`staff_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`staff_info`
(`staff_id`,`first_name`,`last_name`,`date_of_birth`,`location_id`,`department_id`)
VALUES (1,'BARBARA','JONES','1986-10-26',1,1),
(2,'ALICE','STEWART','1980-10-26',1,1),
(3,'VICTORIA','GIBSON','1974-03-15',1,1),
(4,'HEIDI','LARSON','1977-04-09',1,1),
(5,'MAXINE','SILVA','1988-07-09',1,1),
(6,'MELISSA','KING','1979-07-08',1,2),
(7,'MICHELE','GRANT','1984-12-20',1,2),
(8,'AUDREY','RAY','1985-05-16',1,2),
(9,'NORA','HERRERA','1971-10-14',1,2),
(10,'HELEN','HARRIS','1984-01-11',1,3); 

-- -----------------------------------------------------
-- EXAMPLE INSERT ALL values into: `admin_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`admin_info`
(`location_id`,`admin_type`,`location_type`,`street`,`zip_code`,`city`,`state`,
`CNN`) VALUES 
(1,17,'office','1 CVS Drive',2895,'Woonsocket','RI',7648391033),
(2,17,'pharmacy','341 Harrison Ave.',2118,'Boston','MA',7648391033),
(3,17,'pharmacy','333 Washington Street',2108,'Boston','MA',7648391033),
(4,17,'pharmacy','285 Columbus Ave.',2116,'Boston','MA',7648391033),
(5,17,'pharmacy','700 Atlantic Ave.',2111,'Boston','MA',7648391033),
(6,17,'pharmacy','587 Boylston Street',2116,'Boston','MA',7648391033),
(7,17,'pharmacy','900 Commonwealth Avenue',2215,'Boston','MA',7648391033),
(8,17,'pharmacy','231 Massachusetts Avenue',2115,'Boston','MA',7648391033),
(9,17,'pharmacy','191 Cambridge Street',2114,'Boston','MA',7648391033),
(10,17,'pharmacy','100 Cambridge Street',2114,'Boston','MA',7648391033),
(11,17,'pharmacy','85 Seaport Blvd.',2210,'Boston','MA',7648391033);

-- -----------------------------------------------------
-- EXAMPLE INSERT ALL rows: into `vaccine_info`
-- ----------------------------------------------------
INSERT INTO `csv_database`.`vaccine_info`
(`vaccine_id`,`vaccine_name`,`vaccine_description`,`manufacturing_name`,
`wait_days`,`dose_mL`,`age_restriction`)
VALUES 
('v1','BioNTech','Diluent: 0.9% sodium chloride (normal saline, preservative-free).','Pfizer',21,0,16),
('v2','Moderna','Do NOT mix with a diluent.\nDiscard vial when there is not enough vaccine to obtain a complete dose. Do NOT combine residual vaccine from multiple vials to obtain a dose.','Moderna',28,2,18);

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 44 rows:`batch_info`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`batch_info`
(`batch_no`,`release_date`,`expiration_date`,`vaccine_temperature`,`vaccine_id`) 
VALUES ('b123','2020-08-27','2021-02-27',-71,'v1'),
('b124','2020-08-28','2021-02-28',-71,'v1'),
('b125','2020-09-01','2021-03-01',-71,'v1'),
('b126','2020-09-02','2021-03-02',-71,'v1'),
('b127','2020-09-03','2021-03-03',-70,'v1'),
('b128','2020-09-04','2021-03-04',-70,'v1'),
('b129','2020-09-05','2021-03-05',-70,'v1'),
('b130','2020-09-06','2021-03-06',-70,'v1'),
('b131','2020-09-07','2021-03-07',-70,'v1'),
('b132','2020-09-08','2021-03-08',-70,'v1'); 

-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 2386 rows:`vaccine_inventory`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`vaccine_inventory`
(`vaccine_no`,`batch_no`,`vaccine_id`,`location_id`,
`date_added`,`staff_id`)
VALUES (1113191137,'b266','v2',5,'2020-09-26',123),
(1115037585,'b131','v1',4,'2020-09-20',89),
(1126350560,'b443','v2',10,'2020-09-23',278),
(1132358986,'b133','v1',5,'2020-09-21',123),
(1133283932,'b131','v1',4,'2020-09-20',89),
(1136337921,'b258','v2',2,'2020-09-17',39),
(1140914567,'b343','v1',7,'2020-10-15',183),
(1141790806,'b343','v1',7,'2020-10-15',183),
(1143644197,'b351','v1',11,'2020-12-03',305),
(1144064655,'b137','v1',6,'2020-09-26',157); 
```

```sql
-- -----------------------------------------------------
-- EXAMPLE INSERT 10 of 541 rows:`records`
-- -----------------------------------------------------
INSERT INTO `csv_database`.`records`
(`record_id`,`shot_no`,`date_shot`,`patient_id`,`location_id`,`vaccine_no`,
`staff_id`) VALUES (1,1,'2021-01-01',289,3,1226481284,69),
(2,1,'2021-01-01',443,4,1224037928,95),
(3,1,'2021-01-01',274,5,1655020696,131),
(4,1,'2021-01-01',83,5,1785771860,132),
(5,1,'2021-01-01',248,5,2032481911,133),
(6,1,'2021-01-01',410,5,1132358986,134),
(7,1,'2021-01-01',293,5,1326450948,135),
(8,1,'2021-01-01',218,6,1485734107,166),
(9,1,'2021-01-01',246,6,1144064655,167),
(10,1,'2021-01-01',395,7,1274246426,191); 
```

