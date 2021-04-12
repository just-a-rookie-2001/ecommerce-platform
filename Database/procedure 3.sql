select * from shoppingcart;
select * from product;

drop procedure if exists removefromcart;
delimiter //
CREATE PROCEDURE removefromcart(in pid int, in bid int)
begin
	declare qty, stock int;
	select quantity into qty from shoppingcart where Product_ID=pid and Buyer_ID=bid;
    select Units_in_stock into stock from product where Product_ID=pid;
	delete from shoppingcart where Product_ID=pid and Buyer_ID=bid;
    update product set Units_in_stock = stock + qty where Product_ID=pid;
end //
delimiter ;

call removefromcart(3, 25);
select * from shoppingcart;
select * from product;