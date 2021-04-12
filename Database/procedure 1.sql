select * from product;
select * from order_has_product;
select * from buyerorder;

drop procedure if exists checkout;
delimiter //
CREATE PROCEDURE checkout(in bid int, in payid int, in addid int)
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
end //
delimiter ;

call checkout(25,1,1);
select * from product;
select * from order_has_product;
select * from buyerorder;