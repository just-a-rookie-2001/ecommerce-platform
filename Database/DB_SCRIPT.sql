-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`User` ;

CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Email` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Date_Created` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `Type` VARCHAR(8) NULL DEFAULT 'BUYER',
  `Phone_Number` BIGINT(10) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `person_id_UNIQUE` (`ID` ASC) VISIBLE,
  UNIQUE INDEX `person_email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Buyer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Buyer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Buyer` (
  `Buyer_ID` INT NOT NULL,
  `has_membership` TINYINT(1) NULL DEFAULT 0,
  `First_Name` VARCHAR(45) NULL,
  `Last_Name` VARCHAR(45) NULL,
  PRIMARY KEY (`Buyer_ID`),
  UNIQUE INDEX `person_id_UNIQUE` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `person_id_fk_key`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Supplier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Supplier` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Supplier` (
  `Supplier_ID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Address_Line1` VARCHAR(45) NULL,
  `Address_Line2` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(45) NULL,
  `Zip` INT NULL,
  `Country` VARCHAR(45) NULL,
  PRIMARY KEY (`Supplier_ID`),
  INDEX `fk_Organisation_Person1_idx` (`Supplier_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Organisation_Person1`
    FOREIGN KEY (`Supplier_ID`)
    REFERENCES `mydb`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Address` (
  `Address_ID` INT NOT NULL AUTO_INCREMENT,
  `Buyer_ID` INT NOT NULL,
  `Address_Line1` VARCHAR(45) NULL,
  `Address_Line2` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(45) NULL,
  `Zip` INT NULL,
  `Country` VARCHAR(45) NULL,
  PRIMARY KEY (`Address_ID`),
  UNIQUE INDEX `AddressID_UNIQUE` (`Address_ID` ASC) VISIBLE,
  INDEX `fk_Address_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Address_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`Buyer` (`Buyer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Payment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Payment` (
  `Payment_ID` INT NOT NULL AUTO_INCREMENT,
  `Buyer_ID` INT NOT NULL,
  `Card_Name` VARCHAR(45) NULL,
  `Card_Number` BIGINT(15) NULL,
  `Card_Expiry_Date` DATE NULL,
  INDEX `fk_Payment_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  PRIMARY KEY (`Payment_ID`),
  UNIQUE INDEX `Payment_ID_UNIQUE` (`Payment_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`Buyer` (`Buyer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Order` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Order` (
  `Order_ID` INT NOT NULL AUTO_INCREMENT,
  `Buyer_ID` INT NOT NULL,
  `Payment_ID` INT NOT NULL,
  `Address_ID` INT NOT NULL,
  `Order_Date` DATETIME NULL,
  `Delivery_Date` DATETIME NULL,
  `is_completed` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`Order_ID`),
  UNIQUE INDEX `Order_ID_UNIQUE` (`Order_ID` ASC) VISIBLE,
  INDEX `fk_Order_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  INDEX `fk_Order_Payment1_idx` (`Payment_ID` ASC) VISIBLE,
  INDEX `fk_Order_Address1_idx` (`Address_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`Buyer` (`Buyer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Payment1`
    FOREIGN KEY (`Payment_ID`)
    REFERENCES `mydb`.`Payment` (`Payment_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Address1`
    FOREIGN KEY (`Address_ID`)
    REFERENCES `mydb`.`Address` (`Address_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Product` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Product` (
  `Product_ID` INT NOT NULL AUTO_INCREMENT,
  `Supplier_ID` INT NOT NULL,
  `Category` VARCHAR(45) NULL,
  `Name` VARCHAR(45) NULL,
  `Description` VARCHAR(45) NULL,
  `Units_In_Stock` INT NULL,
  `Price` DECIMAL(9,2) NULL,
  `Product_Rating` DECIMAL(1,1) NULL,
  PRIMARY KEY (`Product_ID`),
  UNIQUE INDEX `Product_ID_UNIQUE` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Product_Organisation1_idx` (`Supplier_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Organisation1`
    FOREIGN KEY (`Supplier_ID`)
    REFERENCES `mydb`.`Supplier` (`Supplier_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Wishlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Wishlist` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Wishlist` (
  `Product_ID` INT NOT NULL,
  `Buyer_Buyer_ID` INT NOT NULL,
  PRIMARY KEY (`Product_ID`, `Buyer_Buyer_ID`),
  INDEX `fk_Wishlist_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Wishlist_Buyer1_idx` (`Buyer_Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Wishlist_Product1`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wishlist_Buyer1`
    FOREIGN KEY (`Buyer_Buyer_ID`)
    REFERENCES `mydb`.`Buyer` (`Buyer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ShoppingCart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ShoppingCart` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ShoppingCart` (
  `Product_ID` INT NOT NULL,
  `Buyer_ID` INT NOT NULL,
  `Quantity` INT NULL,
  PRIMARY KEY (`Product_ID`, `Buyer_ID`),
  INDEX `fk_Wishlist_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_ShoppingCart_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Wishlist_Product10`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ShoppingCart_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`Buyer` (`Buyer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Review` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Review` (
  `Product_ID` INT NOT NULL,
  `Buyer_ID` INT NOT NULL,
  `Rating` DECIMAL(1,1) NULL,
  `Comment` TEXT(200) NULL,
  PRIMARY KEY (`Product_ID`, `Buyer_ID`),
  INDEX `fk_Wishlist_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Wishlist_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Wishlist_Product11`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wishlist_Buyer10`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`Buyer` (`Buyer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order_has_Product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Order_has_Product` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Order_has_Product` (
  `Order_ID` INT NOT NULL,
  `Product_ID` INT NOT NULL,
  `Quantity` INT NULL,
  PRIMARY KEY (`Order_ID`, `Product_ID`),
  INDEX `fk_Order_has_Product_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Order_has_Product_Order1_idx` (`Order_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Order_has_Product_Order1`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `mydb`.`Order` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_has_Product_Product1`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Returns`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Returns` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Returns` (
  `Order_ID` INT NOT NULL,
  `Product_ID` INT NOT NULL,
  `Quantity` INT NULL,
  `Comments` TEXT(200) NULL,
  `Is_Approved` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`Order_ID`, `Product_ID`),
  INDEX `fk_Order_has_Product_copy1_Order_has_Product2_idx` (`Product_ID` ASC) INVISIBLE,
  CONSTRAINT `fk_Order_has_Product_copy1_Order_has_Product1`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `mydb`.`Order_has_Product` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_has_Product_copy1_Order_has_Product2`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Order_has_Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
