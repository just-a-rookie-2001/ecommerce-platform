select * from shoppingcart;
select * from product;

drop procedure if exists addtocart;
delimiter //
CREATE PROCEDURE addtocart(in pid int, in bid int, in qty int)
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
end //
delimiter ;

call addtocart(2, 25, 4);
select * from shoppingcart;
select * from product;
select * from buyerorder;
select * from order_has_product;