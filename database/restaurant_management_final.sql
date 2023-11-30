-- -- Create a new database called 'DatabaseName'
-- -- Connect to the 'master' database to run this snippet
-- -- Create the new database if it does not exist already
IF NOT EXISTS (
	SELECT [name]
FROM sys.databases
WHERE [name] = N'btlfinal'
)
CREATE DATABASE btlfinal
GO

USE btlfinal

-- create table
CREATE TABLE restaurant
(
	res_id varchar(10),
	res_name nvarchar(50) not null,
	hotline varchar(10) not null unique,
	province nvarchar(50) not null,
	district nvarchar(50) not null,
	ward nvarchar(50) not null,
	address_number nvarchar(50) not null,
	primary key(res_id)
);


CREATE TABLE r_table
(
	res_id varchar(10),
	table_id varchar(10),
	slot_count tinyint not null,
	primary key(res_id, table_id)
);


CREATE TABLE staff
(
	staff_id int IDENTITY(1,1),
	identification char(12) unique not null,
	staff_name nvarchar(50) not null,
	gender bit not null,
	date_of_birth date not null,
	manager_id int,
	province nvarchar(50) not null,
	district nvarchar(50) not null,
	ward nvarchar(50) not null,
	address_number nvarchar(50) not null,
	res_id varchar(10) not null,
	account_id varchar(10) not null,
	primary key(staff_id)
);


CREATE TABLE staff_email
(
	staff_id int,
	email varchar(30),
	primary key(staff_id, email)
);

CREATE TABLE staff_phone
(
	staff_id int,
	phone varchar(10),
	primary key(staff_id, phone)
);


CREATE TABLE account
(
	account_id varchar(10),
	account_password varchar(20) not null,
	primary key(account_id)
);



CREATE TABLE customer
(
	cus_id varchar(10),
	cus_name nvarchar(50) not null,
	phone_num varchar(10),
	account_id varchar(10),
	primary key(cus_id)
);




CREATE TABLE reservation
(
	reservation_id varchar(10),
	quantity tinyint not null,
	reservation_datetime datetime,
	cus_id varchar(10),
	primary key(reservation_id)
);


CREATE TABLE dish
(
	dish_id varchar(10),
	dish_name nvarchar(50) not null unique,
	price int not null,
	dish_img varchar(255) not null unique,
	dish_type nvarchar(50) not null,
	primary key(dish_id)
);


CREATE TABLE promotion
(
	promotion_id varchar(10),
	promotion_name nvarchar(50) not null,
	promotion_type varchar(30) not null,
	start_time datetime not null,
	end_time datetime not null,
	reduced_price int,
	reduced_percent int,
	primary key(promotion_id)
);


CREATE TABLE bill
(
	bill_id varchar(10),
	bill_datetime datetime not null,
	pay_status bit not null,
	res_id varchar(10) not null,
	table_id varchar(10) not null,
	cus_id varchar(10) not null,
	primary key(bill_id)
);



CREATE TABLE reser_arrange_table
(
	reservation_id varchar(10),
	res_id varchar(10),
	table_id varchar(10),
	primary key(reservation_id, res_id, table_id)
);


CREATE TABLE reser_preorder_dish
(
	reservation_id varchar(10),
	dish_id varchar(10),
	dish_count tinyint not null,
	primary key(reservation_id, dish_id)
);


CREATE TABLE dish_isincluded_bill
(
	bill_id varchar(10),
	dish_id varchar(10),
	dish_count tinyint not null,
	primary key(bill_id, dish_id)
);

CREATE TABLE dish_isapplied_prom
(
	promotion_id varchar(10),
	dish_id varchar(10),
	primary key(promotion_id, dish_id)
);


CREATE TABLE prom_applies_bill
(
	promotion_id varchar(10),
	bill_id varchar(10),
	primary key(promotion_id, bill_id)
);


-- derived attributes
ALTER TABLE restaurant 
ADD table_count int;
-- +1 row r_table -> table_count+1

ALTER TABLE restaurant 
ADD total_slot int;
-- +1 row r_table -> total_slot + r_table.slot_count


ALTER TABLE customer 
ADD loyalty_point tinyint;
-- bill.total_cost > 1 000 000 -> loyalty_point+1

ALTER TABLE dish_isincluded_bill 
ADD current_price int;
-- if(price_discount){current_price = dish.price - promotion.reduced_price}
-- else(percentage_discount){current_price = dish.price(1 - promotion.reduced_percent/100)}

ALTER TABLE bill  
ADD total_cost int; -- total_cost = sum(dish_isincluded_bill.current_price*dish_isincluded_bill.dish_count) - 500 000 (10 loyalty_point <=> 500000)
GO

GO


-- foreign key
ALTER TABLE r_table 
ADD CONSTRAINT table_fk_resID_to_restaurant FOREIGN KEY (res_id) REFERENCES restaurant(res_id) ON DELETE CASCADE;

ALTER TABLE staff 
ADD CONSTRAINT staff_id_diff_manage_id CHECK (staff.staff_id <> staff.manager_id)

ALTER TABLE staff 
ADD CONSTRAINT staff_fk_managerID_to_staff FOREIGN KEY (manager_id) REFERENCES staff(staff_id),
	CONSTRAINT staff_fk_resID_to_restaurant FOREIGN KEY (res_id) REFERENCES restaurant(res_id),
	CONSTRAINT staff_fk_accountID_to_account FOREIGN KEY (account_id) REFERENCES account(account_id) ON UPDATE CASCADE;

ALTER TABLE staff_email 
ADD CONSTRAINT semail_fk_staffID_to_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE;

ALTER TABLE staff_phone
ADD CONSTRAINT sphone_fk_staffID_to_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE;

ALTER TABLE customer 
ADD CONSTRAINT customer_fk_accountID_to_account FOREIGN KEY (account_id) REFERENCES account(account_id);

ALTER TABLE reservation 
ADD CONSTRAINT reservation_fk_cusID_to_customer FOREIGN KEY (cus_id) REFERENCES customer(cus_id);

ALTER TABLE bill 
ADD CONSTRAINT bill_fk_cusID_to_customer FOREIGN KEY (cus_id) REFERENCES customer(cus_id),
	CONSTRAINT bill_fk_resID_tableID_to_table FOREIGN KEY (res_id,table_id) REFERENCES r_table(res_id,table_id);

ALTER TABLE reser_arrange_table 
ADD CONSTRAINT arranges_fk_reservationID_to_reservation FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
	CONSTRAINT arranges_fk_resID_tableID_to_table FOREIGN KEY (res_id,table_id) REFERENCES r_table(res_id,table_id);


ALTER TABLE reser_preorder_dish 
ADD CONSTRAINT preorder_fk_reservationID_to_reservation FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
	CONSTRAINT preorder_fk_dishID_to_dish FOREIGN KEY (dish_id) REFERENCES dish(dish_id);

ALTER TABLE dish_isincluded_bill 
ADD CONSTRAINT isincluded_fk_billID_to_bill FOREIGN KEY (bill_id) REFERENCES bill(bill_id),
	CONSTRAINT isincluded_fk_dishID_to_dish FOREIGN KEY (dish_id) REFERENCES dish(dish_id);

ALTER TABLE dish_isapplied_prom
ADD CONSTRAINT dishIsappliedProm_fk_promotionID_to_promotion FOREIGN KEY (promotion_id) REFERENCES promotion(promotion_id),
	CONSTRAINT dishIsappliedProm_fk_dishID_to_dish FOREIGN KEY (dish_id) REFERENCES dish(dish_id);


ALTER TABLE prom_applies_bill
ADD CONSTRAINT promAppliesBill_fk_promotionID_to_promotion FOREIGN KEY (promotion_id) REFERENCES promotion(promotion_id),
	CONSTRAINT promAppliesBill_fk_billID_to_bill FOREIGN KEY (bill_id) REFERENCES bill(bill_id);


-- check constraint
ALTER TABLE r_table 
ADD CONSTRAINT table_check_slotcount CHECK (slot_count in (4,6,8,10));

ALTER TABLE staff 
ADD CONSTRAINT staff_check_identification CHECK (identification not like '%[^0-9]%'),
	CONSTRAINT staff_check_dob CHECK (date_of_birth between '1990-01-01' and '2005-12-31');

ALTER TABLE staff_email
ADD CONSTRAINT semail_check_email CHECK (email like '%_@__%.__%');

ALTER TABLE staff_phone
ADD CONSTRAINT sphone_check_phonenumber CHECK (phone not like '%[^0-9]%');

ALTER TABLE account
ADD CONSTRAINT account_check_password CHECK (len(account_password) >= 6);

ALTER TABLE customer
ADD CONSTRAINT customer_check_phonenumber CHECK (phone_num not like '%[^0-9]%');

ALTER TABLE reservation
ADD CONSTRAINT reservation_check_quantity CHECK (quantity > 0);

ALTER TABLE dish
ADD CONSTRAINT dish_check_price CHECK (price > 0);

ALTER TABLE promotion
ADD CONSTRAINT promotion_check_reducedPrice CHECK (reduced_price > 0),
	CONSTRAINT promotion_check_reducedPercent CHECK (reduced_percent > 0 and reduced_percent <=100),
	CONSTRAINT promotion_check_duration CHECK (start_time < end_time);

ALTER TABLE reser_preorder_dish
ADD CONSTRAINT preorder_check_dishCount CHECK (dish_count > 0);

ALTER TABLE dish_isincluded_bill
ADD CONSTRAINT isincluded_check_dishCount CHECK (dish_count > 0);


