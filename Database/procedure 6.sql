drop procedure if exists alter_address;
delimiter //
CREATE PROCEDURE alter_address(in bid int, in al1 varchar(45), in al2 varchar(45), in cty varchar(45), in stt varchar(45), in zp int, in cntry varchar(45))
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
	INSERT INTO Address(Buyer_ID, Address_Line1, Address_Line2, City, State, Zip, Country) values(bid, al1, al2, cty, stt, zp, cntry);
end//
delimiter ;

select * from address;
call alter_address(33,'test','test','test','test',12345,'test');
select * from address;