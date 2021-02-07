-- Procedure 1: Updating Inventory Table

 -- Adding and altering columns
 ALTER TABLE `csv_database`.`vaccine_inventory` 
  ADD COLUMN `date_used` DATE NULL DEFAULT NULL AFTER `staff_id`,
  ADD COLUMN `used_by` INT NULL DEFAULT NULL AFTER `date_used`
  CHANGE COLUMN `staff_id` `added_by` INT NOT NULL ;

 -- Adding new foreign key to column
 ALTER TABLE `csv_database`.`vaccine_inventory` 
 ADD INDEX `fk_vaccine_inventory_service_idx` (`staff_id_service` ASC)     
 VISIBLE;

 ;
 ALTER TABLE `csv_database`.`vaccine_inventory` 
 ADD CONSTRAINT `fk_vaccine_inventory_service`
   FOREIGN KEY (`used_by`)
   REFERENCES `csv_database`.`staff_info` (`staff_id`)
   ON DELETE NO ACTION
   ON UPDATE NO ACTION;

-- Creating Procedure
CREATE PROCEDURE `inventory_update`
(IN in_vaccine_no DOUBLE, IN in_staff_id INT, IN in_dated DATE)

  BEGIN
	UPDATE vaccine_inventory
	SET staff_id_service = in_staff_id
	WHERE vaccine_no = in_vaccine_no;

	UPDATE vaccine_inventory
	SET date_used = in_dated
	WHERE vaccine_no = in_vaccine_no;
  END
  
  -- Calling Procedure
  CALL `csv_database`.`inventory_update`(1226481284, 69, '2021-01-01');
  
  -- Procedure 2: Government Export File
  -- Create procedure
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
   WHERE 
	record_id >= in_record_no
   LIMIT 
	200000; 
 END

   -- Call the procedure with the specific record_id 56. 
    CALL `csv_database`.`records_export`(56); 

 -- Call the procedure with the specific record_id 542. 
    CALL `csv_database`.`records_export`(542);

  
  
  
  