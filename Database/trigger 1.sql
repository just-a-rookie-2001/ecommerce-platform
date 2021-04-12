select * from product;

DELIMITER //
create trigger restock before insert on orderreturns for each row
begin
	declare stock int;
    select units_in_stock into stock from product where product.Product_ID=new.product_id;
	update product set units_in_stock = stock + New.quantity where product.Product_ID=new.product_id;
    delete from order_has_product where product_id=New.product_id and order_id=NEW.order_id;
end //
Delimiter ;

insert into orderreturns(Product_ID, order_id, quantity) values(3,3,8);
select * from orderreturns;
select * from order_has_product;
select * from product;