drop procedure if exists create_user;
delimiter //
CREATE PROCEDURE create_user(in email varchar(45), in _password varchar(45), in confirm_password varchar(45), in user_type varchar(10), in phonenum bigint)
begin
	if email NOT LIKE '%_@_%_.__%' then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter a valid email';
	end if;
    if length(_password) <= 7 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Your password must be atleast 8 characters in length';
	end if;
    if _password != confirm_password then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Your passwords do not match';
	end if;
    if upper(user_type) not in ('BUYER','SUPPLIER') then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User must be either a buyer or a supplier';
	end if;
    if length(phonenum)<=9 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone number must be atleast 10 digits';
	end if;
    
    INSERT INTO User(Email, Password, Phone_Number, Type) values(email, _password, phonenum, user_type);
end//
delimiter ;

call create_user('sfaf@gvr.gd','12345678','12345678','buyer',1234567891);
select * from user;