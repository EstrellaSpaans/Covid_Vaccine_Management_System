-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema csv_database
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema csv_database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `csv_database` DEFAULT CHARACTER SET utf8 ;
USE `csv_database` ;

-- -----------------------------------------------------
-- Table `csv_database`.`admin_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`admin_info` (
  `location_id` INT NOT NULL,
  `admin_type` INT NOT NULL,
  `location_type` ENUM('office', 'pharmacy') NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `zip_code` INT NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `CNN` DOUBLE NOT NULL,
  PRIMARY KEY (`location_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


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
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`vaccine_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`vaccine_info` (
  `vaccine_id` VARCHAR(2) NOT NULL,
  `vaccine_name` VARCHAR(45) NOT NULL,
  `vaccine_description` VARCHAR(255) NOT NULL,
  `manufacturing_name` VARCHAR(45) NOT NULL,
  `wait_days` INT NOT NULL,
  `dose_mL` DECIMAL(1,0) NOT NULL,
  `age_restriction` INT NOT NULL,
  PRIMARY KEY (`vaccine_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`batch_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`batch_info` (
  `batch_no` VARCHAR(4) NOT NULL,
  `release_date` DATE NOT NULL,
  `expiration_date` DATE NOT NULL,
  `vaccine_temperature` INT NOT NULL,
  `vaccine_id` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`batch_no`, `vaccine_id`),
  INDEX `fk_batch_info_vaccine_info1_idx` (`vaccine_id` ASC) VISIBLE,
  CONSTRAINT `fk_batch_info_vaccine_info1`
    FOREIGN KEY (`vaccine_id`)
    REFERENCES `csv_database`.`vaccine_info` (`vaccine_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`departments_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`departments_info` (
  `department_id` INT UNSIGNED NOT NULL,
  `department_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`insurance_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`insurance_info` (
  `insurance_id` VARCHAR(10) NOT NULL,
  `insurance_provider` VARCHAR(45) NOT NULL,
  `amount_coverage` INT NOT NULL,
  `insurance_start_date` DATE NOT NULL,
  `insurance_end_date` DATE NOT NULL,
  PRIMARY KEY (`insurance_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`medical_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`medical_records` (
  `medical_record_id` VARCHAR(7) NOT NULL,
  `vaccine_prescription` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`medical_record_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`patient_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`patient_info` (
  `patient_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `street_address` VARCHAR(45) NOT NULL,
  `zip_code` INT NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `phone_number` VARCHAR(10) NOT NULL,
  `email_address` VARCHAR(45) NOT NULL,
  `occupation` VARCHAR(45) NOT NULL,
  `gender` ENUM('M', 'F') NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `medical_record_id` VARCHAR(7) NULL DEFAULT NULL,
  `insurance_id` VARCHAR(10) NULL DEFAULT NULL,
  `appointment_id` VARCHAR(3) NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  INDEX `fk_patient_info_medical_records1_idx` (`medical_record_id` ASC) VISIBLE,
  INDEX `fk_patient_info_insurance_info1_idx` (`insurance_id` ASC) VISIBLE,
  INDEX `fk_patient_info_appointment_info1_idx` (`appointment_id` ASC) VISIBLE,
  CONSTRAINT `fk_patient_info_appointment_info1`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `csv_database`.`appointment_info` (`appointment_id`),
  CONSTRAINT `fk_patient_info_insurance_info1`
    FOREIGN KEY (`insurance_id`)
    REFERENCES `csv_database`.`insurance_info` (`insurance_id`),
  CONSTRAINT `fk_patient_info_medical_records1`
    FOREIGN KEY (`medical_record_id`)
    REFERENCES `csv_database`.`medical_records` (`medical_record_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`staff_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`staff_info` (
  `staff_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `location_id` INT NOT NULL,
  `department_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`staff_id`),
  INDEX `fk_staff_info_departments_info1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_staff_info_departments_info1`
    FOREIGN KEY (`department_id`)
    REFERENCES `csv_database`.`departments_info` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`vaccine_inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`vaccine_inventory` (
  `vaccine_no` DOUBLE NOT NULL,
  `batch_no` VARCHAR(4) NOT NULL,
  `vaccine_id` VARCHAR(2) NOT NULL,
  `location_id` INT NOT NULL,
  `date_added` DATE NULL DEFAULT NULL,
  `staff_id` INT NOT NULL,
  PRIMARY KEY (`vaccine_no`),
  INDEX `fk_vaccine_inventory_batch_info1_idx` (`batch_no` ASC) VISIBLE,
  INDEX `fk_vaccine_inventory_vaccine_info1_idx` (`vaccine_id` ASC) VISIBLE,
  INDEX `fk_vaccine_inventory_admin_info1_idx` (`location_id` ASC) VISIBLE,
  INDEX `fk_vaccine_inventory_staff_info1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_vaccine_inventory_admin_info1`
    FOREIGN KEY (`location_id`)
    REFERENCES `csv_database`.`admin_info` (`location_id`),
  CONSTRAINT `fk_vaccine_inventory_batch_info1`
    FOREIGN KEY (`batch_no`)
    REFERENCES `csv_database`.`batch_info` (`batch_no`),
  CONSTRAINT `fk_vaccine_inventory_staff_info1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `csv_database`.`staff_info` (`staff_id`),
  CONSTRAINT `fk_vaccine_inventory_vaccine_info1`
    FOREIGN KEY (`vaccine_id`)
    REFERENCES `csv_database`.`vaccine_info` (`vaccine_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`records` (
  `record_id` INT NOT NULL,
  `shot_no` INT NOT NULL,
  `date_shot` DATE NOT NULL,
  `patient_id` INT NOT NULL,
  `location_id` INT NOT NULL,
  `vaccine_no` DOUBLE NOT NULL,
  `staff_id` INT NOT NULL,
  PRIMARY KEY (`record_id`),
  INDEX `fk_records_patient_info1_idx` (`patient_id` ASC) VISIBLE,
  INDEX `fk_records_admin_info1_idx` (`location_id` ASC) VISIBLE,
  INDEX `fk_records_vaccine_inventory1_idx` (`vaccine_no` ASC) VISIBLE,
  INDEX `fk_records_staff_info1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_records_admin_info1`
    FOREIGN KEY (`location_id`)
    REFERENCES `csv_database`.`admin_info` (`location_id`),
  CONSTRAINT `fk_records_patient_info1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `csv_database`.`patient_info` (`patient_id`),
  CONSTRAINT `fk_records_staff_info1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `csv_database`.`staff_info` (`staff_id`),
  CONSTRAINT `fk_records_vaccine_inventory1`
    FOREIGN KEY (`vaccine_no`)
    REFERENCES `csv_database`.`vaccine_inventory` (`vaccine_no`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `csv_database`.`test_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `csv_database`.`test_records` (
  `test_record_id` VARCHAR(7) NOT NULL,
  `test_date` DATE NULL DEFAULT NULL,
  `test_result` ENUM('positive', 'negative') NOT NULL,
  `patient_id` INT NOT NULL,
  PRIMARY KEY (`test_record_id`, `patient_id`),
  INDEX `fk_test_records_patient_info1_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `fk_test_records_patient_info1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `csv_database`.`patient_info` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `csv_database` ;

-- -----------------------------------------------------
-- procedure day_staff_statistics
-- -----------------------------------------------------

DELIMITER $$
USE `csv_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `day_staff_statistics`(IN in_date DATE)
BEGIN
-- Connect 4 tables together, filter the department name as "service" and make sure the date_shot = in_date 
SELECT 
	DISINCT(concat_ws(",",s.first_name,s.last_name)) AS "Staff Name", 
    COUNT(r.record_id) AS "Number of Shots",
	a.street AS "Address"
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
	r.date_shot = in_date
GROUP BY concat_ws(",",s.first_name,s.last_name), a.street
ORDER BY 
	a.street DESC;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inventory_update
-- -----------------------------------------------------

DELIMITER $$
USE `csv_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inventory_update`(IN in_vaccine_no DOUBLE, IN in_staff_id INT, IN in_date DATE)
BEGIN

UPDATE vaccine_inventory
SET 
    used_by = in_staff_id
WHERE
    vaccine_no = in_vaccine_no;

UPDATE vaccine_inventory
SET 
    date_used = in_date
WHERE
    vaccine_no = in_vaccine_no;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure new_procedure
-- -----------------------------------------------------

DELIMITER $$
USE `csv_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`()
BEGIN
declare cur_no INTEGER DEFAULT 0;

declare cur1 cursor for
	SELECT p.patient_id
	from appointment_info as a, patient_info as p, records as r
	WHERE p.appointment_id = a.appointment_id
	AND r.patient_id = p.patient_id
    AND shot_no = 1
	ORDER BY p.patient_id;
    
open cur1;
a1:loop
fetch cur1 into cur_no;
update appointment_info
set a.location_id_ap1 = new_view.location_id
where patient_id = cur_no;
end loop a1;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure records_export
-- -----------------------------------------------------

DELIMITER $$
USE `csv_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `records_export`(IN in_record_no INT)
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure records_export_file
-- -----------------------------------------------------

DELIMITER $$
USE `csv_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `records_export_file`(IN in_record_no INT)
BEGIN

SELECT 
	concat_ws(",",p.first_name, p.last_name) AS "Patient Name", 
	r.shot_no AS "Shot NO", 
	r.date_shot AS "Shot Date", 
	r. vaccine_no AS "Vaccine NO",
	v.vaccine_name AS "Vaccine",
	a.street AS "Given at",
	concat_ws(",",s.first_name, s.last_name) AS "Given By",
	a.CNN AS "Pharmacy CNN", 
	CURRENT_TIMESTAMP  AS "Export Date"
INTO OUTFILE '/Desktop/result.txt' FIELDS TERMINATED BY ',' LINES TERMINATED BY '/n'
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
WHERE record_id > in_record_no
LIMIT 200000; 
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
