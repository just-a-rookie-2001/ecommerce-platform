drop trigger if exists return_check;
DELIMITER //
create trigger return_check before insert on orderreturns for each row
begin
	declare deliverydt date;
    select delivery_date into deliverydt from buyerorder where Order_ID=new.Order_ID;
    if DATE_ADD(`deliverydt` , INTERVAL 14 DAY) < current_date then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You can not return the item after 2 weeks from the delivery date';
    end if;
end //
Delimiter ;

insert into orderreturns(Product_ID, order_id, quantity) values(1,1,1);