drop procedure if exists alter_product;
delimiter //
CREATE PROCEDURE alter_product(in sid int, in nme varchar(50), in cate varchar(50),in des varchar(50), in stock int, in p decimal, in pid int)
begin
    if pid = -1 then
		insert into product(Supplier_ID,name,category,description,units_in_stock,price) values(sid,nme,cate,des,stock,p);
	else
		update product set name=nme,category=cate,description=des,units_in_stock=stock where Product_ID=pid;
    end if;
end //
delimiter ;

select * from product;
call alter_product(24, 'tv stand','furniture','test',45,35,4);
select * from product;