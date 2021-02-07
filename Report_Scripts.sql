 -- Report 1: HR Daily Stats
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
    
 -- Report 2: Stock Brand Inventory
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

 -- Report 3: Stock Batch Inventory with Expiration Days
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

 -- Report 4: Top 3 Pharmacy Locations
   SELECT 
	adm.street AS "Location Name", 
	COUNT(r.record_id) AS "Number Vaccines"
  FROM 
	records as r
  LEFT JOIN 
	admin_info AS adm
  ON 
	adm.location_id = r.location_id
  GROUP BY 
	adm.location_id
  ORDER BY 
	COUNT(r.record_id)
  LIMIT 
	3;

 -- Report 5: Uninsured-Patients Administration
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

 -- Report 6: Fully Vaccinated Patients
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

 -- Report 7: Fully Vaccinated Patients by Occupation
 SELECT 
	occupation as Occupation,
     count(*) as "Number of People"
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
    
-- 9 Report: Incorrectly given Vaccines: Brand  
SELECT 
	concat_ws(",",p.first_name, p.last_name) AS "Patient Name", 	m.vaccine_prescription AS "Recommendation", 
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

-- Report 10: How many 2nd appointments are scheduled per location?
SELECT 
	ad.street as "Location Name",
 	location_id_ap2 AS "Location", 
 	COUNT(appointment_date_2) AS "Number Unconfirmed", 
 	MIN(appointment_date_2) as "Earliest Appointment"
  FROM 
	appointment_info as a,
	admin_info as ad
  WHERE  
	ad.location_id = a.location_id_ap2
  AND 
	status_2 = "unconfirmed"
  GROUP BY 
	location_id_ap2,ad.street
  ORDER BY 
	MIN(appointment_date_2);


-- Report 8: Incorrectly given Vaccines: Covid-19 test (view)

CREATE VIEW 7_days_ahead_testing AS   
  (SELECT 
	concat_ws(",",p.first_name,p.last_name) AS "Patient Name", 
	t.test_date "Test Date", 
	r.date_shot AS "Shot Date",
     (datediff(date_shot,test_date)- 7) AS "Days Past Requirement",
 	s.staff_id AS "Staff Number",
	concat_ws(",",s.first_name,s.last_name) AS "Staff Name",
	a.street AS "Location Name"
   FROM 
	patient_info AS p, test_records AS t, 
	records AS r, staff_info AS s,
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
 
 -- CALL VIEW:
   SELECT *
  FROM 
	7_days_ahead_testing
  WHERE 
	datediff(date_shot,test_date)>7;