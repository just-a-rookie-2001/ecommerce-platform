drop trigger if exists review_check;
DELIMITER //
create trigger review_check before insert on review for each row
begin
	declare bought, returned int;
	select count(*) into bought from buyerorder bo, order_has_product ohp where bo.Buyer_ID=New.Buyer_ID and bo.Order_ID=ohp.Order_ID and ohp.Product_ID=new.Product_ID;
    select count(*) into returned from buyerorder bo, orderreturns odr where bo.Buyer_ID=New.Buyer_ID and bo.Order_ID=odr.Order_ID and odr.Product_ID=new.Product_ID;
    if bought <= 0 and returned <= 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have not bought this item. Please buy it first to be able to write a review.';
    end if;
end //
Delimiter ;

select * from buyerorder;
select * from orderreturns;
select * from order_has_product;
insert into review(product_id, buyer_id, rating, comment) values(2,25,4.5,"Good");
select * from review;