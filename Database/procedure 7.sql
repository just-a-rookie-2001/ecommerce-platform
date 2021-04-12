drop procedure if exists alter_payment;
delimiter //
CREATE PROCEDURE alter_payment(in bid int, in cname varchar(45), in cnum bigint, in cexpdt date)
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
end//
delimiter ;

select * from payment;
call alter_payment(33,'test',1234132412341234,current_date);
select * from payment;