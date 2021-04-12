drop trigger if exists delete_buyer;
DELIMITER //
create trigger delete_buyer before delete on buyer for each row
begin
	delete from order_has_product where order_id in (select order_id from buyerorder where buyer_id=old.buyer_id);
    delete from orderreturns where order_id in (select order_id from buyerorder where buyer_id=old.buyer_id);
    delete from buyerorder where buyer_id=old.buyer_id;
    delete from payment where buyer_id=old.buyer_id;
    delete from address where buyer_id=old.buyer_id;
    delete from review where buyer_id=old.buyer_id;
    delete from wishlist where buyer_id=old.buyer_id;
end //
delimiter ;

drop trigger if exists delete_user;
DELIMITER //
create trigger delete_user after delete on buyer for each row
begin
	declare umail varchar(45);
    select email into umail from user where id=old.buyer_id;
    insert into user_log (email, date_deleted, type) values(umail, CURRENT_TIMESTAMP, 'BUYER');
    delete from user where id=old.buyer_id;
end //
delimiter ;

select * from buyer;
delete from buyer where Buyer_ID=27;
select * from buyer;
select * from user_log;