drop procedure if exists product_list;
delimiter //
CREATE procedure product_list(cat varchar(50))
begin
	if upper(cat) in (select upper(category) from product) then
		select * from Product where upper(Category)=upper(cat) and units_in_stock>0;
	else
		select * from Product where units_in_stock>0;
    end if;
end //
delimiter ;

select * from product;
call alter_product('furniture');
select * from product;