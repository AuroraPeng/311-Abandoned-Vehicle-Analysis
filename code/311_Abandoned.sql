-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema 311_abandoned
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `311_abandoned` ;

-- -----------------------------------------------------
-- Schema 311_abandoned
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `311_abandoned` DEFAULT CHARACTER SET utf8 ;


USE `311_abandoned` ;

-- -----------------------------------------------------
-- Table `311_abandoned`.`Location`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `311_abandoned`.`Location` ;

CREATE TABLE IF NOT EXISTS `311_abandoned`.`Location` (
  `Location_id` INT NOT NULL AUTO_INCREMENT,
  `Street_Address` VARCHAR(80) NULL,
  `ZIP_Code` INT NULL,
  `X_Coordinate` DECIMAL(15,8) NULL,
  `Y_Coordinate` DECIMAL(15,8) NULL,
  `Ward` INT NULL,
  `Police_District` INT NULL,
  `Community_Area` INT NULL,
  `SSA` VARCHAR(45) NULL,
  `Latitude` DECIMAL(16,14) NULL,
  `Longitude` DECIMAL(16,14) NULL,
  `Location` POINT NULL COMMENT 'Set Location = Point (Longitude, Latitude)',
  PRIMARY KEY (`Location_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `311_abandoned`.`Vehicle`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `311_abandoned`.`Vehicle` ;

CREATE TABLE IF NOT EXISTS `311_abandoned`.`Vehicle` (
  `Vehicle_id` INT NOT NULL AUTO_INCREMENT,
  `License_Plate` VARCHAR(45) NULL,
  `Vehicle_Make` VARCHAR(45) NULL COMMENT 'Vehicle Make/Model',
  `Vehicle_Color` VARCHAR(45) NULL,
  PRIMARY KEY (`Vehicle_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `311_abandoned`.`Activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `311_abandoned`.`Activity` ;

CREATE TABLE IF NOT EXISTS `311_abandoned`.`Activity` (
  `Activity_id` INT NOT NULL AUTO_INCREMENT,
  `Current_Activity` VARCHAR(45) NULL,
  `most_recent_action` VARCHAR(45) NULL,
  `park_duration` INT NULL COMMENT 'park_duration is \'How many days has the vehicle being reported as parked?\'',
  PRIMARY KEY (`Activity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `311_abandoned`.`Service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `311_abandoned`.`Service` ;

CREATE TABLE IF NOT EXISTS `311_abandoned`.`Service` (
  `Creation_Date` DATETIME NOT NULL,
  `Completion_Date` DATETIME NULL,
  `Status` VARCHAR(45) NULL,
  `Service Request Number` VARCHAR(45) NOT NULL,
  `Activity_id` INT NOT NULL,
  `Location_id` INT NOT NULL,
  `Vehicle_id` INT NOT NULL,
  PRIMARY KEY (`Service Request Number`),
  CONSTRAINT `fk_Service_Activity`
    FOREIGN KEY (`Activity_id`)
    REFERENCES `311_abandoned`.`Activity` (`Activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Service_Location1`
    FOREIGN KEY (`Location_id`)
    REFERENCES `311_abandoned`.`Location` (`Location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Service_Vehicle1`
    FOREIGN KEY (`Vehicle_id`)
    REFERENCES `311_abandoned`.`Vehicle` (`Vehicle_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Service Request Number_UNIQUE` ON `311_abandoned`.`Service` (`Service Request Number` ASC) VISIBLE;

CREATE INDEX `fk_Service_Activity_idx` ON `311_abandoned`.`Service` (`Activity_id` ASC) VISIBLE;

CREATE INDEX `fk_Service_Location1_idx` ON `311_abandoned`.`Service` (`Location_id` ASC) VISIBLE;

CREATE INDEX `fk_Service_Vehicle1_idx` ON `311_abandoned`.`Service` (`Vehicle_id` ASC) VISIBLE;






