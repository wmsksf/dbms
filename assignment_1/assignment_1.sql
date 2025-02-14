-- MySQL Script generated by MySQL Workbench
-- Τρι 10 Απρ 2018 02:32:37 μμ EEST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`contact_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`contact_info` (
  `phone` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `postcode` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`phone`),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`traffic_police`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`traffic_police` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `contact_info_phone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`, `contact_info_phone`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_traffic_police_contact_info1_idx` (`contact_info_phone` ASC),
  CONSTRAINT `fk_traffic_police_contact_info1`
    FOREIGN KEY (`contact_info_phone`)
    REFERENCES `mydb`.`contact_info` (`phone`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`police_officer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`police_officer` (
  `badge` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `rank` VARCHAR(45) NOT NULL,
  `traffic_police_id` INT NOT NULL,
  `chief` INT NOT NULL,
  PRIMARY KEY (`badge`, `traffic_police_id`),
  UNIQUE INDEX `badge_UNIQUE` (`badge` ASC),
  INDEX `fk_police_officer_traffic_police_idx` (`traffic_police_id` ASC),
  INDEX `fk_police_officer_police_officer1_idx` (`chief` ASC),
  CONSTRAINT `fk_police_officer_traffic_police`
    FOREIGN KEY (`traffic_police_id`)
    REFERENCES `mydb`.`traffic_police` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_police_officer_chief`
    FOREIGN KEY (`chief`)
    REFERENCES `mydb`.`police_officer` (`badge`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`street_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`street_info` (
  `name` VARCHAR(45) NOT NULL,
  `number` INT NOT NULL,
  `road_surface` VARCHAR(45) NOT NULL,
  `state_of_road_surface` VARCHAR(45) NOT NULL,
  `speed_limit` INT NOT NULL,
  PRIMARY KEY (`name`, `number`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`report` (
  `DOTA` INT NOT NULL,
  `traffic_police_id` INT NOT NULL,
  PRIMARY KEY (`DOTA`),
  UNIQUE INDEX `DOTA_UNIQUE` (`DOTA` ASC),
  INDEX `fk_report_traffic_police1_idx` (`traffic_police_id` ASC),
  CONSTRAINT `fk_report_traffic_police1`
    FOREIGN KEY (`traffic_police_id`)
    REFERENCES `mydb`.`traffic_police` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`accident`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`accident` (
  `date_of_registration` DATE NOT NULL,
  `date_of_review` DATE NOT NULL,
  `description` TEXT NOT NULL,
  `traffic_police_id` INT NOT NULL,
  `coordinates_latitude` INT NOT NULL,
  `coordinates_longitude` INT NOT NULL,
  `redactor` INT NOT NULL,
  `chief` INT NOT NULL,
  `street_info_name` VARCHAR(45) NOT NULL,
  `street_info_number` INT NOT NULL,
  `report_DOTA` INT NOT NULL,
  INDEX `fk_accident_traffic_police1_idx` (`traffic_police_id` ASC),
  INDEX `fk_accident_police_officer1_idx` (`redactor` ASC),
  INDEX `fk_accident_police_officer2_idx` (`chief` ASC),
  INDEX `fk_accident_street_info1_idx` (`street_info_name` ASC, `street_info_number` ASC),
  PRIMARY KEY (`report_DOTA`),
  CONSTRAINT `fk_accident_traffic_police`
    FOREIGN KEY (`traffic_police_id`)
    REFERENCES `mydb`.`traffic_police` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accident_redactor`
    FOREIGN KEY (`redactor`)
    REFERENCES `mydb`.`police_officer` (`badge`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accident_chief`
    FOREIGN KEY (`chief`)
    REFERENCES `mydb`.`police_officer` (`chief`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accident_street_info1`
    FOREIGN KEY (`street_info_name` , `street_info_number`)
    REFERENCES `mydb`.`street_info` (`name` , `number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accident_report1`
    FOREIGN KEY (`report_DOTA`)
    REFERENCES `mydb`.`report` (`DOTA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ADT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ADT` (
  `id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `AFM` INT NOT NULL,
  `AMKA` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `AFM_UNIQUE` (`AFM` ASC),
  UNIQUE INDEX `AMKA_UNIQUE` (`AMKA` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`hospital` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`passenger`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`passenger` (
  `seat` VARCHAR(45) NOT NULL,
  `seatbelt` INT NULL COMMENT 'the datatype (integer) of seatbelt and airbag refers to whether the passenger was or wasn\'t using the specific equipment (0: not using, 1:using)',
  `airbag` INT NULL,
  `vehicle_id` INT NOT NULL,
  PRIMARY KEY (`seat`),
  INDEX `fk_passenger_vehicle1_idx` (`vehicle_id` ASC),
  CONSTRAINT `fk_passenger_vehicle1`
    FOREIGN KEY (`vehicle_id`)
    REFERENCES `mydb`.`vehicle` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`person` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nature` INT NOT NULL,
  `age` INT NOT NULL,
  `ADT_id` INT NOT NULL,
  `hospital_id` INT NULL,
  `passenger_seat` VARCHAR(45) NULL,
  `accident_report_DOTA` INT NOT NULL,
  `driver_KOK` INT NULL,
  PRIMARY KEY (`id`, `ADT_id`, `accident_report_DOTA`, `hospital_id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_person_ADT1_idx` (`ADT_id` ASC),
  INDEX `fk_person_hospital1_idx` (`hospital_id` ASC),
  INDEX `fk_person_passenger1_idx` (`passenger_seat` ASC),
  INDEX `fk_person_accident1_idx` (`accident_report_DOTA` ASC),
  INDEX `fk_person_driver1_idx` (`driver_KOK` ASC),
  CONSTRAINT `fk_person_ADT1`
    FOREIGN KEY (`ADT_id`)
    REFERENCES `mydb`.`ADT` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_person_hospital1`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_person_passenger1`
    FOREIGN KEY (`passenger_seat`)
    REFERENCES `mydb`.`passenger` (`seat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_person_accident1`
    FOREIGN KEY (`accident_report_DOTA`)
    REFERENCES `mydb`.`accident` (`report_DOTA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_person_driver1`
    FOREIGN KEY (`driver_KOK`)
    REFERENCES `mydb`.`driver` (`KOK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`alcotest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`alcotest` (
  `type` VARCHAR(45) NOT NULL,
  `time` TIME NOT NULL,
  `result` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`driver`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`driver` (
  `KOK` INT NOT NULL,
  `ADT_id` INT NOT NULL,
  `alcotest_type` VARCHAR(45) NOT NULL,
  INDEX `fk_ADT_id_idx` (`ADT_id` ASC),
  PRIMARY KEY (`ADT_id`),
  INDEX `fk_driver_alcotest1_idx` (`alcotest_type` ASC),
  CONSTRAINT `fk_ADT_id`
    FOREIGN KEY (`ADT_id`)
    REFERENCES `mydb`.`person` (`ADT_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_driver_alcotest1`
    FOREIGN KEY (`alcotest_type`)
    REFERENCES `mydb`.`alcotest` (`type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vehicle_registration`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vehicle_registration` (
  `plate_number` INT NOT NULL,
  `frame_number` INT NOT NULL,
  `manufacturer` VARCHAR(45) NOT NULL,
  `model` VARCHAR(45) NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  `engine_ccm` INT NOT NULL,
  `release_year` INT NOT NULL,
  `driver_person_ADT_id` INT NOT NULL,
  `driver_ADT_id` INT NOT NULL,
  PRIMARY KEY (`plate_number`, `frame_number`, `driver_ADT_id`),
  UNIQUE INDEX `plate_number_UNIQUE` (`plate_number` ASC),
  UNIQUE INDEX `frame_number_UNIQUE` (`frame_number` ASC),
  INDEX `fk_vehicle_registration_driver1_idx` (`driver_ADT_id` ASC),
  CONSTRAINT `fk_vehicle_registration_driver1`
    FOREIGN KEY (`driver_ADT_id`)
    REFERENCES `mydb`.`driver` (`ADT_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`insurance_company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`insurance_company` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `parent_company` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_insurance_company_insurance_company1_idx` (`parent_company` ASC),
  CONSTRAINT `fk_insurance_company_insurance_company1`
    FOREIGN KEY (`parent_company`)
    REFERENCES `mydb`.`insurance_company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`risk_of_merchandise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`risk_of_merchandise` (
  `id` INT NOT NULL,
  `class` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`commercial_firm`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`commercial_firm` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `parent_company` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_commercial_firm_commercial_firm1_idx` (`parent_company` ASC),
  CONSTRAINT `fk_commercial_firm_commercial_firm1`
    FOREIGN KEY (`parent_company`)
    REFERENCES `mydb`.`commercial_firm` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`merchandise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`merchandise` (
  `id` INT NOT NULL,
  `weight` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `risk_of_merchandise_id` INT NULL,
  `commercial_firm_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_merchandise_risk_of_merchandise1_idx` (`risk_of_merchandise_id` ASC),
  INDEX `fk_merchandise_commercial_firm1_idx` (`commercial_firm_id` ASC),
  CONSTRAINT `fk_merchandise_risk_of_merchandise1`
    FOREIGN KEY (`risk_of_merchandise_id`)
    REFERENCES `mydb`.`risk_of_merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_merchandise_commercial_firm1`
    FOREIGN KEY (`commercial_firm_id`)
    REFERENCES `mydb`.`commercial_firm` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vehicle` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  `estimated_collision_speed` INT NOT NULL,
  `total_passengers` INT NULL,
  `vehicle_registration_plate_number` INT NOT NULL,
  `vehicle_registration_frame_number` INT NOT NULL,
  `insurance_company_id` INT NULL,
  `merchandise_id` INT NULL,
  `accident_report_DOTA` INT NOT NULL,
  PRIMARY KEY (`id`, `vehicle_registration_plate_number`, `vehicle_registration_frame_number`, `accident_report_DOTA`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_vehicle_vehicle_registration1_idx` (`vehicle_registration_plate_number` ASC, `vehicle_registration_frame_number` ASC),
  INDEX `fk_vehicle_insurance_company1_idx` (`insurance_company_id` ASC),
  INDEX `fk_vehicle_merchandise1_idx` (`merchandise_id` ASC),
  INDEX `fk_vehicle_accident1_idx` (`accident_report_DOTA` ASC),
  UNIQUE INDEX `vehicle_registration_plate_number_UNIQUE` (`vehicle_registration_plate_number` ASC),
  UNIQUE INDEX `vehicle_registration_frame_number_UNIQUE` (`vehicle_registration_frame_number` ASC),
  CONSTRAINT `fk_vehicle_vehicle_registration1`
    FOREIGN KEY (`vehicle_registration_plate_number` , `vehicle_registration_frame_number`)
    REFERENCES `mydb`.`vehicle_registration` (`plate_number` , `frame_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehicle_insurance_company1`
    FOREIGN KEY (`insurance_company_id`)
    REFERENCES `mydb`.`insurance_company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehicle_merchandise1`
    FOREIGN KEY (`merchandise_id`)
    REFERENCES `mydb`.`merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehicle_accident1`
    FOREIGN KEY (`accident_report_DOTA`)
    REFERENCES `mydb`.`accident` (`report_DOTA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`license`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`license` (
  `id` INT NOT NULL,
  `ethnicity` VARCHAR(45) NOT NULL,
  `category` VARCHAR(45) NOT NULL,
  `date_issued` DATE NOT NULL,
  `driver_ADT_id` INT NOT NULL,
  PRIMARY KEY (`id`, `driver_ADT_id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_license_driver1_idx` (`driver_ADT_id` ASC),
  CONSTRAINT `fk_license_driver1`
    FOREIGN KEY (`driver_ADT_id`)
    REFERENCES `mydb`.`driver` (`ADT_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`accident_report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`accident_report` (
  `date_of_report` DATE NOT NULL,
  `estimated_damage` INT NOT NULL,
  `estimated_compensation` INT NOT NULL,
  `insurance_company_id` INT NOT NULL,
  `vehicle_id` INT NOT NULL,
  `vehicle_vehicle_registration_plate_number` INT NOT NULL,
  `vehicle_vehicle_registration_frame_number` INT NOT NULL,
  `vehicle_accident_report_DOTA` INT NOT NULL,
  INDEX `fk_accident_report_insurance_company1_idx` (`insurance_company_id` ASC),
  INDEX `fk_accident_report_vehicle1_idx` (`vehicle_id` ASC, `vehicle_vehicle_registration_plate_number` ASC, `vehicle_vehicle_registration_frame_number` ASC, `vehicle_accident_report_DOTA` ASC),
  CONSTRAINT `fk_accident_report_insurance_company1`
    FOREIGN KEY (`insurance_company_id`)
    REFERENCES `mydb`.`insurance_company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accident_report_vehicle1`
    FOREIGN KEY (`vehicle_id` , `vehicle_vehicle_registration_plate_number` , `vehicle_vehicle_registration_frame_number` , `vehicle_accident_report_DOTA`)
    REFERENCES `mydb`.`vehicle` (`id` , `vehicle_registration_plate_number` , `vehicle_registration_frame_number` , `accident_report_DOTA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`doctor` (
  `id` INT NOT NULL,
  `licence_id` INT NOT NULL,
  `specialisation` VARCHAR(45) NOT NULL,
  `hospital_id` INT NOT NULL,
  PRIMARY KEY (`id`, `hospital_id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `licence_id_UNIQUE` (`licence_id` ASC),
  INDEX `fk_doctor_hospital1_idx` (`hospital_id` ASC),
  CONSTRAINT `fk_doctor_hospital1`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`medical_procedure`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`medical_procedure` (
  `id` INT NOT NULL,
  `description` TEXT NOT NULL,
  `body_parts` VARCHAR(45) NOT NULL,
  `duration` INT NOT NULL,
  `result` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`discharge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`discharge` (
  `day` VARCHAR(45) NOT NULL,
  `time` TIME NOT NULL,
  `id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`patient` (
  `medical_procedure_id` INT NULL,
  `person_id` INT NULL,
  `person_ADT_id` INT NULL,
  `person_accident_report_DOTA` INT NULL,
  `person_hospital_id` INT NULL,
  INDEX `fk_patient_medical_procedure1_idx` (`medical_procedure_id` ASC),
  INDEX `fk_patient_person1_idx` (`person_id` ASC, `person_ADT_id` ASC, `person_accident_report_DOTA` ASC, `person_hospital_id` ASC),
  PRIMARY KEY (`person_id`),
  CONSTRAINT `fk_patient_medical_procedure1`
    FOREIGN KEY (`medical_procedure_id`)
    REFERENCES `mydb`.`medical_procedure` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_patient_person1`
    FOREIGN KEY (`person_id` , `person_ADT_id` , `person_accident_report_DOTA` , `person_hospital_id`)
    REFERENCES `mydb`.`person` (`id` , `ADT_id` , `accident_report_DOTA` , `hospital_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`admission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`admission` (
  `id` INT NOT NULL,
  `day` VARCHAR(45) NOT NULL,
  `time` TIME NOT NULL,
  `severity` TEXT NOT NULL,
  `description` TEXT NOT NULL,
  `discharge_id` INT NOT NULL,
  `patient_person_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_admission_discharge1_idx` (`discharge_id` ASC),
  INDEX `fk_admission_patient1_idx` (`patient_person_id` ASC),
  CONSTRAINT `fk_admission_discharge`
    FOREIGN KEY (`discharge_id`)
    REFERENCES `mydb`.`discharge` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_admission_patient1`
    FOREIGN KEY (`patient_person_id`)
    REFERENCES `mydb`.`patient` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`catalog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`catalog` (
  `hospital_id` INT NOT NULL,
  `procedure` INT NOT NULL,
  PRIMARY KEY (`hospital_id`, `procedure`),
  UNIQUE INDEX `procedure_UNIQUE` (`procedure` ASC),
  UNIQUE INDEX `hospital_id_UNIQUE` (`hospital_id` ASC),
  CONSTRAINT `fk_catalog_hospital1`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_medical_procedure`
    FOREIGN KEY (`procedure`)
    REFERENCES `mydb`.`medical_procedure` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`medical_procedure_has_doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`medical_procedure_has_doctor` (
  `medical_procedure_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `doctor_hospital_id` INT NOT NULL,
  PRIMARY KEY (`medical_procedure_id`, `doctor_id`, `doctor_hospital_id`),
  INDEX `fk_medical_procedure_has_doctor_doctor1_idx` (`doctor_id` ASC, `doctor_hospital_id` ASC),
  INDEX `fk_medical_procedure_has_doctor_medical_procedure1_idx` (`medical_procedure_id` ASC),
  CONSTRAINT `fk_medical_procedure_has_doctor_medical_procedure1`
    FOREIGN KEY (`medical_procedure_id`)
    REFERENCES `mydb`.`medical_procedure` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_medical_procedure_has_doctor_doctor1`
    FOREIGN KEY (`doctor_id` , `doctor_hospital_id`)
    REFERENCES `mydb`.`doctor` (`id` , `hospital_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
