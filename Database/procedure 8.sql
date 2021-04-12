drop procedure if exists alter_wishlist;
delimiter //
CREATE PROCEDURE alter_wishlist(in pid int, in bid int, in a varchar(7))
begin
    if a = 'insert' then
		if (select count(*) from wishlist where product_id=pid and buyer_id=bid) > 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This item is already in the wishlist';
		else
			insert into wishlist values(pid,bid);
		end if;
	elseif a = 'delete' then
		if (select count(*) from wishlist where product_id=pid and buyer_id=bid) <= 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Add the item to your wishlist first to be able to delete';
		else
			delete from wishlist where product_id=pid and buyer_id=bid;
		end if;
    end if;
end //
delimiter ;

select * from wishlist;
call alter_wishlist(1,33,'delete');
select * from wishlist;