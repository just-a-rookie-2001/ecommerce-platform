drop trigger if exists review_calc_insert;
DELIMITER //
create trigger review_calc_insert after insert on review for each row
begin
	declare avgrating decimal(2,1);
	select avg(Rating) into avgrating from review;
    update product set product_rating = avgrating where product_id=NEW.product_id;
end //
delimiter ;

drop trigger if exists review_calc_update;
DELIMITER //
create trigger review_calc_update after update on review for each row
begin
	declare avgrating decimal(2,1);
	select avg(Rating) into avgrating from review;
    update product set product_rating = avgrating where product_id=NEW.product_id;
end //
Delimiter ;

insert into review(product_id, buyer_id, rating, comment) values(2,23,3.2,'eh!');
select * from review;
select * from buyerorder;
select * from orderreturns;
select * from order_has_product;