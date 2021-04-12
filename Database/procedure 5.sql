drop procedure if exists login_user;
delimiter //
CREATE PROCEDURE login_user(in mail varchar(45), in _password varchar(45), out loggedinid int, out loggedinname varchar(50), out is_employee bool, out is_loggedin bool )
begin
	declare exist,uid,buy int;
    declare fname,lname varchar(45);
	select count(*) into exist from user where Email=mail and Password=_password;
    if exist <= 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect email or password';
	else
		select id into uid from user where Email=mail and Password=_password;
        set loggedinid = uid;
        set is_loggedin = 1;
        select count(*) into buy from buyer where buyer_id=uid;
        if (buy > 0) then
			set is_employee = 0;
            select first_name, last_name into fname,lname from buyer where buyer_id=uid;
            set loggedinname = concat(fname," ", lname);
		else
			set is_employee = 1;
            select `name` into loggedinname from supplier where supplier_id=uid;
        end if;
    end if;
end//
delimiter ;

select * from user;
set @loggedinid=-1, @loggedinname=" ", @is_employee=0, @is_loggedin=0;
call login_user('test@test.test','123456789', @loggedinid, @loggedinname, @is_employee, @is_loggedin);
select @loggedinid, @loggedinname, @is_employee, @is_loggedin;