-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Email` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Date_Created` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `Type` VARCHAR(8) NULL DEFAULT 'BUYER',
  `Phone_Number` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `person_id_UNIQUE` (`ID` ASC) VISIBLE,
  UNIQUE INDEX `person_email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`buyer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`buyer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`buyer` (
  `Buyer_ID` INT NOT NULL,
  `has_membership` TINYINT(1) NULL DEFAULT '0',
  `First_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Last_Name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Buyer_ID`),
  UNIQUE INDEX `person_id_UNIQUE` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `person_id_fk_key`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`user` (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`address` (
  `Address_ID` INT NOT NULL AUTO_INCREMENT,
  `Buyer_ID` INT NOT NULL,
  `Address_Line1` VARCHAR(45) NULL DEFAULT NULL,
  `Address_Line2` VARCHAR(45) NULL DEFAULT NULL,
  `City` VARCHAR(45) NULL DEFAULT NULL,
  `State` VARCHAR(45) NULL DEFAULT NULL,
  `Zip` INT NULL DEFAULT NULL,
  `Country` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Address_ID`),
  UNIQUE INDEX `AddressID_UNIQUE` (`Address_ID` ASC) VISIBLE,
  INDEX `fk_Address_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Address_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`buyer` (`Buyer_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`payment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`payment` (
  `Payment_ID` INT NOT NULL AUTO_INCREMENT,
  `Buyer_ID` INT NOT NULL,
  `Card_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Card_Number` BIGINT NULL DEFAULT NULL,
  `Card_Expiry_Date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`Payment_ID`),
  UNIQUE INDEX `Payment_ID_UNIQUE` (`Payment_ID` ASC) VISIBLE,
  INDEX `fk_Payment_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`buyer` (`Buyer_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`buyerorder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`buyerorder` ;

CREATE TABLE IF NOT EXISTS `mydb`.`buyerorder` (
  `Order_ID` INT NOT NULL AUTO_INCREMENT,
  `Buyer_ID` INT NOT NULL,
  `Payment_ID` INT NOT NULL,
  `Address_ID` INT NOT NULL,
  `Order_Date` DATE NULL DEFAULT NULL,
  `Delivery_Date` DATE NULL DEFAULT NULL,
  `is_completed` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`Order_ID`),
  UNIQUE INDEX `Order_ID_UNIQUE` (`Order_ID` ASC) VISIBLE,
  INDEX `fk_Order_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  INDEX `fk_Order_Payment1_idx` (`Payment_ID` ASC) VISIBLE,
  INDEX `fk_Order_Address1_idx` (`Address_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Address1`
    FOREIGN KEY (`Address_ID`)
    REFERENCES `mydb`.`address` (`Address_ID`),
  CONSTRAINT `fk_Order_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`buyer` (`Buyer_ID`),
  CONSTRAINT `fk_Order_Payment1`
    FOREIGN KEY (`Payment_ID`)
    REFERENCES `mydb`.`payment` (`Payment_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`supplier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`supplier` ;

CREATE TABLE IF NOT EXISTS `mydb`.`supplier` (
  `Supplier_ID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Address_Line1` VARCHAR(45) NULL DEFAULT NULL,
  `Address_Line2` VARCHAR(45) NULL DEFAULT NULL,
  `City` VARCHAR(45) NULL DEFAULT NULL,
  `State` VARCHAR(45) NULL DEFAULT NULL,
  `Zip` INT NULL DEFAULT NULL,
  `Country` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Supplier_ID`),
  INDEX `fk_Organisation_Person1_idx` (`Supplier_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Organisation_Person1`
    FOREIGN KEY (`Supplier_ID`)
    REFERENCES `mydb`.`user` (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`product` ;

CREATE TABLE IF NOT EXISTS `mydb`.`product` (
  `Product_ID` INT NOT NULL AUTO_INCREMENT,
  `Supplier_ID` INT NOT NULL,
  `Category` VARCHAR(45) NULL DEFAULT NULL,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Description` VARCHAR(45) NULL DEFAULT NULL,
  `Units_In_Stock` INT NULL DEFAULT NULL,
  `Price` DECIMAL(9,2) NULL DEFAULT NULL,
  `product_rating` DECIMAL(2,1) NULL DEFAULT 0.0,
  PRIMARY KEY (`Product_ID`),
  UNIQUE INDEX `Product_ID_UNIQUE` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Product_Organisation1_idx` (`Supplier_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Organisation1`
    FOREIGN KEY (`Supplier_ID`)
    REFERENCES `mydb`.`supplier` (`Supplier_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`order_has_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`order_has_product` ;

CREATE TABLE IF NOT EXISTS `mydb`.`order_has_product` (
  `Order_ID` INT NOT NULL,
  `Product_ID` INT NOT NULL,
  `Quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Order_ID`, `Product_ID`),
  INDEX `fk_Order_has_Product_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Order_has_Product_Order1_idx` (`Order_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Order_has_Product_Order1`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `mydb`.`buyerorder` (`Order_ID`),
  CONSTRAINT `fk_Order_has_Product_Product1`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`product` (`Product_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`orderreturns`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`orderreturns` ;

CREATE TABLE IF NOT EXISTS `mydb`.`orderreturns` (
  `returnid` INT NOT NULL AUTO_INCREMENT,
  `quantity` INT NULL DEFAULT NULL,
  `Order_ID` INT NOT NULL,
  `Product_ID` INT NOT NULL,
  PRIMARY KEY (`returnid`),
  UNIQUE INDEX `returnid_UNIQUE` (`returnid` ASC) VISIBLE,
  INDEX `fk_orderreturns_Order1_idx` (`Order_ID` ASC) VISIBLE,
  INDEX `fk_orderreturns_Product1_idx` (`Product_ID` ASC) VISIBLE,
  CONSTRAINT `fk_orderreturns_Order1`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `mydb`.`buyerorder` (`Order_ID`),
  CONSTRAINT `fk_orderreturns_Product1`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`product` (`Product_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`review` ;

CREATE TABLE IF NOT EXISTS `mydb`.`review` (
  `reviewid` INT NOT NULL AUTO_INCREMENT,
  `Product_ID` INT NOT NULL,
  `Buyer_ID` INT NOT NULL,
  `Rating` DECIMAL(2,1) NULL DEFAULT '0.0',
  `Comment` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`reviewid`),
  UNIQUE INDEX `reviewid_UNIQUE` (`reviewid` ASC) VISIBLE,
  INDEX `fk_Wishlist_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Wishlist_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Wishlist_Buyer10`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`buyer` (`Buyer_ID`),
  CONSTRAINT `fk_Wishlist_Product11`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`product` (`Product_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`shoppingcart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`shoppingcart` ;

CREATE TABLE IF NOT EXISTS `mydb`.`shoppingcart` (
  `Product_ID` INT NOT NULL,
  `Buyer_ID` INT NOT NULL,
  `Quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Product_ID`, `Buyer_ID`),
  INDEX `fk_Wishlist_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_ShoppingCart_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_ShoppingCart_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`buyer` (`Buyer_ID`),
  CONSTRAINT `fk_Wishlist_Product10`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`product` (`Product_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`user_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_log` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_log` (
  `iduser_log` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `date_deleted` DATETIME NULL DEFAULT NULL,
  `type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`iduser_log`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`wishlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`wishlist` ;

CREATE TABLE IF NOT EXISTS `mydb`.`wishlist` (
  `Product_ID` INT NOT NULL,
  `Buyer_ID` INT NOT NULL,
  PRIMARY KEY (`Product_ID`, `Buyer_ID`),
  INDEX `fk_Wishlist_Product1_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Wishlist_Buyer1_idx` (`Buyer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Wishlist_Buyer1`
    FOREIGN KEY (`Buyer_ID`)
    REFERENCES `mydb`.`buyer` (`Buyer_ID`),
  CONSTRAINT `fk_Wishlist_Product1`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`product` (`Product_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure addtocart
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`addtocart`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `addtocart`(in pid int, in bid int, in qty int)
begin
	DECLARE exist, oldqty, stock int;
    select units_in_stock into stock from product where Product_ID=pid;
    if qty > stock then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity selected is more than the items available';
    else
		select count(*) into exist from shoppingcart where Buyer_ID=bid and Product_ID=pid;
		update product set Units_In_Stock = stock - qty where Product_ID=pid;
        if exist=0 then
			insert into shoppingcart values(pid, bid, qty);
		else
			select Quantity into oldqty from shoppingcart where Buyer_ID=bid and Product_ID=pid;
			update shoppingcart set Quantity = oldqty + qty where Buyer_ID=bid and Product_ID=pid;
		end if;
	end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alter_address
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`alter_address`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `alter_address`(in bid int, in al1 varchar(45), in al2 varchar(45), in cty varchar(45), in stt varchar(45), in zp int, in cntry varchar(45))
begin
	declare a1,a2,c varchar(50);
    declare z, finished int;
    DECLARE adres CURSOR FOR select upper(address_line1), upper(address_line2), zip, upper(Country) from address where Buyer_ID=bid;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    open adres;
    getadd: LOOP
			FETCH adres INTO a1,a2,z,c;
			IF finished = 1 THEN 
				LEAVE getadd;
			END IF;
            
			if TRIM(upper(a1))=al1 and TRIM(upper(a2))=al2 and zp=z and TRIM(upper(cntry))=c then
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This address already exists';
			end if;
	END LOOP getadd;
	CLOSE adres;
	INSERT INTO address(Buyer_ID, Address_Line1, Address_Line2, City, State, Zip, Country) values(bid, al1, al2, cty, stt, zp, cntry);
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alter_payment
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`alter_payment`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `alter_payment`(in bid int, in cname varchar(45), in cnum bigint, in cexpdt date)
begin
	declare nme varchar(50);
    declare numb, finished bigint;
    declare expdate date;
	DECLARE py CURSOR FOR select upper(card_name), card_number, Card_Expiry_Date from payment where Buyer_ID=bid;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    open py;
    getpy: LOOP
			FETCH py INTO nme, numb,expdate;
			IF finished = 1 THEN 
				LEAVE getpy;
			END IF;
            
			if cexpdt <= CURRENT_DATE then
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This card is already expired. Please add a new card';
			elseif cnum=numb then
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have already added this card';
			end if;
	END LOOP getpy;
	CLOSE py;
	INSERT INTO payment (Buyer_ID, Card_Name, Card_Number, Card_Expiry_Date) values(bid, cname, cnum, cexpdt);
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alter_product
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`alter_product`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `alter_product`(in sid int, in nme varchar(50), in cate varchar(50),in des varchar(50), in stock int, in p decimal, in pid int)
begin
    if pid = -1 then
		insert into product(Supplier_ID,name,category,description,units_in_stock,price) values(sid,nme,cate,des,stock,p);
	else
		update product set name=nme,category=cate,description=des,units_in_stock=stock where Product_ID=pid;
    end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alter_wishlist
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`alter_wishlist`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `alter_wishlist`(in pid int, in bid int, in a varchar(7))
begin
    if a = 'insert' then
		if (select count(*) from wishlist where product_id=pid and buyer_id=bid) > 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This item is already in the wishlist';
		else
			insert into wishlist values(pid,bid);
		end if;
	elseif a = 'delete' then
		if (select count(*) from wishlist where product_id=pid and buyer_id=bid) <= 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Add the item to your wishlist first to be able to delete';
		else
			delete from wishlist where product_id=pid and buyer_id=bid;
		end if;
    end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure checkout
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`checkout`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `checkout`(in bid int, in payid int, in addid int)
begin
    DECLARE p_id, qty, x, finished, lastorderid int;
    DECLARE cart CURSOR FOR SELECT Product_ID, Quantity from shoppingcart where Buyer_ID=bid;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    if (select count(*) from shoppingcart where Buyer_ID=bid > 0) then
		select max(order_id) into lastorderid from buyerorder;
        if lastorderid > 0 then
			select lastorderid into lastorderid;
		else
			select 0 into lastorderid;
		end if;
		insert into buyerorder values(lastorderid+1,bid,payid,addid,current_date,current_date+14, 0);
		OPEN cart;
		getCart: LOOP
			FETCH cart INTO p_id, qty;
			IF finished = 1 THEN 
				LEAVE getCart;
			END IF;
			insert into order_has_product values (lastorderid+1,p_id, qty);
			delete from shoppingcart where Buyer_ID=bid and Product_ID=p_id;
		END LOOP getCart;
		CLOSE cart;
    end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_user
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`create_user`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `create_user`(in email varchar(45), in _password varchar(45), in confirm_password varchar(45), in user_type varchar(10), in phonenum bigint)
begin
	if email NOT LIKE '%_@_%_.__%' then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter a valid email';
	end if;
  if length(_password) <= 7 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Your password must be atleast 8 characters in length';
	end if;
  if _password != confirm_password then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Your passwords do not match';
	end if;
  if upper(user_type) not in ('BUYER','SUPPLIER') then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User must be either a buyer or a supplier';
	end if;
  if length(phonenum)<=9 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone number must be atleast 10 digits';
	end if;
    
  INSERT INTO user(Email, Password, Phone_Number, Type) values(email, _password, phonenum, user_type);
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login_user
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`login_user`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `login_user`(in mail varchar(45), in _password varchar(45), out loggedinid int, out loggedinname varchar(50), out is_employee bool, out is_loggedin bool )
begin
	declare exist,uid,buy int;
    declare fname,lname varchar(45);
	select count(*) into exist from user where Email=mail and Password=_password;
    if exist <= 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect email or password';
	else
		select id into uid from user where Email=mail and Password=_password;
        set loggedinid = uid;
        set is_loggedin = 1;
        select count(*) into buy from buyer where buyer_id=uid;
        if (buy > 0) then
			set is_employee = 0;
            select first_name, last_name into fname,lname from buyer where buyer_id=uid;
            set loggedinname = concat(fname," ", lname);
		else
			set is_employee = 1;
            select `name` into loggedinname from supplier where supplier_id=uid;
        end if;
    end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure product_list
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`product_list`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `product_list`(cat varchar(50))
begin
	if upper(cat) in (select upper(category) from product) then
		select * from product where upper(Category)=upper(cat) and units_in_stock>0;
	else
		select * from product where units_in_stock>0;
    end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure removefromcart
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`removefromcart`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `removefromcart`(in pid int, in bid int)
begin
	declare qty, stock int;
	select quantity into qty from shoppingcart where Product_ID=pid and Buyer_ID=bid;
    select Units_in_stock into stock from product where Product_ID=pid;
	delete from shoppingcart where Product_ID=pid and Buyer_ID=bid;
    update product set Units_in_stock = stock + qty where Product_ID=pid;
end$$

DELIMITER ;
USE `mydb`;

DELIMITER $$

USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`delete_buyer` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`delete_buyer`
BEFORE DELETE ON `mydb`.`buyer`
FOR EACH ROW
begin
	delete from order_has_product where order_id in (select order_id from buyerorder where buyer_id=old.buyer_id);
    delete from orderreturns where order_id in (select order_id from buyerorder where buyer_id=old.buyer_id);
    delete from buyerorder where buyer_id=old.buyer_id;
    delete from payment where buyer_id=old.buyer_id;
    delete from address where buyer_id=old.buyer_id;
    delete from review where buyer_id=old.buyer_id;
    delete from wishlist where buyer_id=old.buyer_id;
end$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`delete_user` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`delete_user`
AFTER DELETE ON `mydb`.`buyer`
FOR EACH ROW
begin
	declare umail varchar(45);
    select email into umail from user where id=old.buyer_id;
    insert into user_log (email, date_deleted, type) values(umail, CURRENT_TIMESTAMP, 'BUYER');
    delete from user where id=old.buyer_id;
end$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`restock` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`restock`
BEFORE INSERT ON `mydb`.`orderreturns`
FOR EACH ROW
begin
	declare stock int;
    select units_in_stock into stock from product where product.Product_ID=new.product_id;
	update product set units_in_stock = stock + New.quantity where product.Product_ID=new.product_id;
    delete from order_has_product where product_id=New.product_id and order_id=NEW.order_id;
end$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`return_check` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`return_check`
BEFORE INSERT ON `mydb`.`orderreturns`
FOR EACH ROW
begin
	declare deliverydt date;
    select delivery_date into deliverydt from buyerorder where Order_ID=new.Order_ID;
    if DATE_ADD(`deliverydt` , INTERVAL 14 DAY) < current_date then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can not return the item after 2 weeks from the delivery date';
    end if;
end$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`review_calc_insert` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`review_calc_insert`
AFTER INSERT ON `mydb`.`review`
FOR EACH ROW
begin
	declare avgrating decimal(2,1);
	select avg(Rating) into avgrating from review;
    update product set product_rating = avgrating where product_id=NEW.product_id;
end$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`review_calc_update` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`review_calc_update`
AFTER UPDATE ON `mydb`.`review`
FOR EACH ROW
begin
	declare avgrating decimal(2,1);
	select avg(Rating) into avgrating from review;
    update product set product_rating = avgrating where product_id=NEW.product_id;
end$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`review_check` $$
USE `mydb`$$
CREATE TRIGGER `mydb`.`review_check`
BEFORE INSERT ON `mydb`.`review`
FOR EACH ROW
begin
	declare bought, returned int;
	select count(*) into bought from buyerorder bo, order_has_product ohp where bo.Buyer_ID=New.Buyer_ID and bo.Order_ID=ohp.Order_ID and ohp.Product_ID=new.Product_ID;
    select count(*) into returned from buyerorder bo, orderreturns odr where bo.Buyer_ID=New.Buyer_ID and bo.Order_ID=odr.Order_ID and odr.Product_ID=new.Product_ID;
    if bought <= 0 and returned <= 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have not bought this item. Please buy it first to be able to write a review.';
    end if;
end$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

delete from user;
insert into user values(1,"1@11.11",'11111111',CURRENT_timestamp, 'supplier',1111111111);
insert into supplier(supplier_id, name) values(1,"test");
insert into user values(2,"2@22.22",'22222222',CURRENT_timestamp, 'supplier',2222222222);
insert into supplier(supplier_id, name) values(2,"test");
insert into user values(3,"3@33.33",'33333333',CURRENT_timestamp, 'supplier',3333333333);
insert into supplier(supplier_id, name) values(3,"test");

insert into product values (1,1,'Fashion','T-Shirt','Be comfortable with casuals',25,649.49,3.1);
insert into product values (2,1,'Fashion','Kurta','Get ready for festives',54,950.25,3.7);
insert into product values (3,1,'Fashion','Suit','Grace your formal look',33,3500.5,4.3);
insert into product values (4,1,'Fashion','Dresses','Elegant traditional Indian for Women',21,1100.44,3.3);
insert into product values (5,1,'Fashion','Shoes','Do not let your sole hurt',125,543.2,2.7);
insert into product values (6,1,'Supermarket','Chocolate','Treat your taste buds',240,199,4.5);
insert into product values (7,1,'Supermarket','Juices','Get yourself refreshed',530,104.2,4.6);
insert into product values (8,1,'Supermarket','Fruits','Perfect for breakfast',495,39,4.9);
insert into product values (9,1,'Supermarket','Skincare','Skin should not be dry',123,139.6,3.7);
insert into product values (10,1,'Supermarket','Air Freshener','Mask bad odour',9,543.2,2.5);
insert into product values (11,2,'Mobiles','Apple','California USA',489,124999.94,4.6);
insert into product values (12,2,'Mobiles','Samsung','Seoul South Korea',799,25499.54,4.1);
insert into product values (13,2,'Mobiles','Realme','Shenzhen China',1200,17999.79,4.0);
insert into product values (14,2,'Mobiles','Oppo','Dongguan China',650,16599.65,3.5);
insert into product values (15,2,'Mobiles','Vivo','BBK Electronics',765,13459,4.5);
insert into product values (16,2,'Electronics','Headphones','Bose JBL Boult',564,1299.12,4.1);
insert into product values (17,2,'Electronics','Speakers','Skullcandy Boat',221,2495,4.6);
insert into product values (18,2,'Electronics','Soundbar','Samsung LG MarQ',108,6500,3.5);
insert into product values (19,2,'Electronics','Printers','Epson HP Canon',32,11499,3.4);
insert into product values (20,2,'Electronics','Powerbank','Ambrane Mi',765,1349,2.9);
insert into product values (21,2,'Books','Academics','Physics Chemistry',1450,449,2.6);
insert into product values (22,2,'Books','Fiction','Mystery Detective',1300,1125,3.9);
insert into product values (23,2,'Books','Non Fiction','Business Politics',1050,888.88,4.2);
insert into product values (24,2,'Books','Literature','History Civics',325,540.45,3.5);
insert into product values (25,2,'Books','Language','English Hindi',284,685.5,3.1);
insert into product values (26,3,'Furniture','Bed','Single Double',6,9590.59,3.4);
insert into product values (27,3,'Furniture','Wardrobe','Wood',23,7595.75,3.8);
insert into product values (28,3,'Furniture','TV Unit','With Set Top Box',51,4990.49,4.2);
insert into product values (29,3,'Furniture','Locker','Store anything with safety',17,5499.49,3.2);
insert into product values (30,3,'Furniture','Table','Ideal for four',44,1179.19,4.1);
insert into product values (31,1,'Furniture','Bookshelf','Organise your library at home',8,499.6,2.4);
insert into product values (32,3,'Kitchen','Oven','Convection Microwave',134,23200.32,4.1);
insert into product values (33,3,'Kitchen','Kettle','Pigeon Electric',325,599.59,3.9);
insert into product values (34,3,'Kitchen','Chimney','Auto Clean',72,10900.1,4.0);
insert into product values (35,3,'Kitchen','Mixer','Grinder Bajaj',510,2099.29,3.8);
insert into product values (36,3,'Kitchen','Stove','Induction Cooktop',1324,1499.14,3.7);
insert into product values (37,1,'Kitchen','Cookware','Delicious food in minutes',16,2183.11,4.2);
insert into product values (38,3,'Baby','Diapers','Pampers Angel',1024,699,3.7);
insert into product values (39,3,'Baby','Wipes','Multipurpose Sanitising',754,559.55,3.7);
insert into product values (40,3,'Baby','Grooming','Oil Powder',500,70,3.7);
insert into product values (41,3,'Baby','Nursing','Premium Shield',423,329.23,3.7);
insert into product values (42,3,'Baby','Bottles','Sippy Cup',265,194.14,3.7);

insert into user values(4,"4@44.44",'44444444',current_timestamp, 'buyer', 4444444444);
insert into buyer values(4,0,"demo","user");
insert into address values(1,4,"test address","google maps","x","y",123123,"z");
insert into payment values(1,4,"test card",123412341234,STR_TO_DATE('14/02/2025', '%d/%m/%Y'));
insert into buyerorder values(1,4,1,1,STR_TO_DATE('14/02/2020', '%d/%m/%Y'),STR_TO_DATE('20/02/2020', '%d/%m/%Y'), 1);
insert into order_has_product values(1,1,1)