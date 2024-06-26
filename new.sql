-- MySQL Script generated by MySQL Workbench
-- Wed Jun 12 20:42:47 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema my_project
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `my_project` ;

-- -----------------------------------------------------
-- Schema my_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `my_project` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema new_schema1
-- -----------------------------------------------------
USE `my_project` ;

-- -----------------------------------------------------
-- Table `my_project`.`group_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`group_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`group_table` (
  `group_id` INT NOT NULL AUTO_INCREMENT,
  `group_name` VARCHAR(200) NOT NULL,
  `group_code` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`group_id`),
  UNIQUE INDEX `group_id_UNIQUE` (`group_id` ASC) VISIBLE,
  UNIQUE INDEX `group_code_UNIQUE` (`group_code` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`group_category_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`group_category_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`group_category_table` (
  `group_category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(200) NOT NULL,
  `transaction_type` VARCHAR(45) NULL,
  `category_description` VARCHAR(200) NULL,
  `group_id` INT NOT NULL,
  PRIMARY KEY (`group_category_id`, `group_id`),
  INDEX `group_category_fk_idx` (`group_id` ASC) VISIBLE,
  UNIQUE INDEX `group_category_id_UNIQUE` (`group_category_id` ASC) VISIBLE,
  CONSTRAINT `group_category_fk`
    FOREIGN KEY (`group_id`)
    REFERENCES `my_project`.`group_table` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`personal_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`personal_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`personal_table` (
  `personal_id` VARCHAR(200) NOT NULL,
  `user_name` VARCHAR(200) NOT NULL,
  `line_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`personal_id`),
  UNIQUE INDEX `personal_id_UNIQUE` (`personal_id` ASC) VISIBLE,
  UNIQUE INDEX `line_id_UNIQUE` (`line_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`group_account_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`group_account_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`group_account_table` (
  `group_account_id` INT NOT NULL AUTO_INCREMENT,
  `item` VARCHAR(200) NULL,
  `account_date` DATE NULL,
  `location` VARCHAR(200) NULL,
  `payment` INT NULL,
  `info_complete_flag` INT NOT NULL,
  `group_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `personal_id` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`group_account_id`, `group_id`, `category_id`, `personal_id`),
  INDEX `group_account_fk_idx` (`group_id` ASC) VISIBLE,
  INDEX `group_account_category_fk_idx` (`category_id` ASC) VISIBLE,
  INDEX `payment_fk_idx` (`personal_id` ASC) VISIBLE,
  UNIQUE INDEX `group_account_id_UNIQUE` (`group_account_id` ASC) VISIBLE,
  CONSTRAINT `group_account_fk`
    FOREIGN KEY (`group_id`)
    REFERENCES `my_project`.`group_table` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `group_account_category_fk`
    FOREIGN KEY (`category_id`)
    REFERENCES `my_project`.`group_category_table` (`group_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `payment_fk`
    FOREIGN KEY (`personal_id`)
    REFERENCES `my_project`.`personal_table` (`personal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`personal_category_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`personal_category_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`personal_category_table` (
  `personal_category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  `transaction_type` VARCHAR(200) NULL,
  `category_description` VARCHAR(200) NULL,
  `personal_id` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`personal_category_id`, `personal_id`),
  INDEX `personal_category_fk_idx` (`personal_id` ASC) VISIBLE,
  UNIQUE INDEX `personal_category_id_UNIQUE` (`personal_category_id` ASC) VISIBLE,
  CONSTRAINT `personal_category_fk`
    FOREIGN KEY (`personal_id`)
    REFERENCES `my_project`.`personal_table` (`personal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`personal_account_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`personal_account_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`personal_account_table` (
  `personal_account_id` INT NOT NULL AUTO_INCREMENT,
  `item` VARCHAR(200) NULL,
  `account_date` DATE NULL,
  `location` VARCHAR(200) NULL,
  `payment` INT NULL,
  `info_complete_flag` INT NOT NULL,
  `personal_id` VARCHAR(200) NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`personal_account_id`, `personal_id`, `category_id`),
  INDEX `personal_account_fk_idx` (`personal_id` ASC) VISIBLE,
  INDEX `personal_account_category_fk_idx` (`category_id` ASC) VISIBLE,
  UNIQUE INDEX `personal_account_id_UNIQUE` (`personal_account_id` ASC) VISIBLE,
  CONSTRAINT `personal_account_fk`
    FOREIGN KEY (`personal_id`)
    REFERENCES `my_project`.`personal_table` (`personal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `personal_account_category_fk`
    FOREIGN KEY (`category_id`)
    REFERENCES `my_project`.`personal_category_table` (`personal_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`split_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`split_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`split_table` (
  `split_id` INT NOT NULL AUTO_INCREMENT,
  `payment` INT NULL,
  `advance_payment` INT NULL,
  `group_account_id` INT NOT NULL,
  `personal_id` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`split_id`, `group_account_id`, `personal_id`),
  INDEX `group_account_split_fk_idx` (`group_account_id` ASC) VISIBLE,
  INDEX `receiver_fk_idx` (`personal_id` ASC) VISIBLE,
  UNIQUE INDEX `split_id_UNIQUE` (`split_id` ASC) VISIBLE,
  CONSTRAINT `group_account_split_fk`
    FOREIGN KEY (`group_account_id`)
    REFERENCES `my_project`.`group_account_table` (`group_account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `spliter_fk`
    FOREIGN KEY (`personal_id`)
    REFERENCES `my_project`.`personal_table` (`personal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`personal_group_linking_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`personal_group_linking_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`personal_group_linking_table` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `personal_id` VARCHAR(200) NOT NULL,
  `group_id` INT NOT NULL,
  PRIMARY KEY (`id`, `personal_id`, `group_id`),
  INDEX `group_fk_idx` (`group_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `personal_fk`
    FOREIGN KEY (`personal_id`)
    REFERENCES `my_project`.`personal_table` (`personal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `group_fk`
    FOREIGN KEY (`group_id`)
    REFERENCES `my_project`.`group_table` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `my_project`.`return_table`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_project`.`return_table` ;

CREATE TABLE IF NOT EXISTS `my_project`.`return_table` (
  `return_id` INT NOT NULL AUTO_INCREMENT,
  `return_payment` VARCHAR(45) NOT NULL,
  `payer` VARCHAR(45) NOT NULL,
  `receiver` VARCHAR(45) NOT NULL,
  `return_flag` VARCHAR(1) NOT NULL,
  `split_id` INT NOT NULL,
  PRIMARY KEY (`return_id`, `split_id`),
  INDEX `split_return_fk_idx` (`split_id` ASC) VISIBLE,
  CONSTRAINT `split_return_fk`
    FOREIGN KEY (`split_id`)
    REFERENCES `my_project`.`split_table` (`split_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
