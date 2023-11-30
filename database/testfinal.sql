USE btlfinal
GO

-- In ra tất cả các bảng
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- In dữ liệu từ mỗi bảng
DECLARE @tableName NVARCHAR(255);
DECLARE tableCursor CURSOR FOR
    SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

OPEN tableCursor;
FETCH NEXT FROM tableCursor INTO @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('SELECT * FROM ' + @tableName);
    FETCH NEXT FROM tableCursor INTO @tableName;
END

CLOSE tableCursor;
DEALLOCATE tableCursor;


-- test

-- insert staff

EXECUTE Add_staff '075203002000', N'Nguyễn Đại Tiến', 1, '2003-08-22', NULL, N'Đồng Nai', N'Biên Hòa', N'Phước Tân', N'Khu phố Hương Phước', 'R002','tiennguyen2283@gmail.com', '0346066555', 'A100000001'

EXECUTE Add_staff '075203002949', N'Bùi Tiến Dũng', 1, '2003-09-23', NULL, N'Đồng Nai', N'Biên Hòa', N'Tân Phong', N'Khu phố 6', 'R002', 'tiendung03@gmail.com', '0353260326', 'A100000011'

EXECUTE Add_staff '076203002850', N'Đồng Minh Thiện', 1, '2003-08-09', NULL, N'TPHCM', N'Thủ Đức', N'Linh Trung', N'KTX Khu A', 'R001', NULL, '0123456789','A100000002'

EXECUTE Add_staff '076203002851', N'Đồng Minh Thiện', 1, '2003-08-09', 7, N'TPHCM', N'Thủ Đức', N'Linh Trung', N'KTX Khu A', 'R001', NULL, '0123456789','A100000202'


EXECUTE Update_staff_by_id 1, NULL, N'Đồng Minh Thiện x', 1, '2003-08-09', 1, N'TPHCM', NULL, N'Linh Trung', N'KTX Khu A', 'R003', NULL

EXECUTE Update_staff_by_id 6, NULL, N'Đồng Minh Thiện x', 1, '2003-08-09', 9, N'TPHCM', NULL, N'Linh Trung', N'KTX Khu A', 'R003', NULL

EXECUTE Delete_staff_by_id 7
-- select
SELECT *
FROM restaurant
SELECT *
FROM r_table
SELECT *
FROM staff
SELECT *
FROM account
SELECT *
FROM staff_email
SELECT *
FROM staff_phone

SELECT *
FROM dish_isapplied_prom
SELECT *
FROM bill
SELECT *
FROM dish_isincluded_bill
SELECT *
FROM prom_applies_bill

SELECT *
FROM customer

DELETE staff
DELETE staff_email
DELETE staff_phone
DELETE account
DELETE restaurant
DELETE reservation
DELETE r_table WHERE r_table.res_id = 'R001' AND r_table.table_id = 'T001'

DELETE dish_isincluded_bill
DELETE prom_applies_bill
DELETE bill
DELETE customer WHERE customer.cus_id = 'C00000001'


INSERT INTO customer
VALUES
	('C00000010', N'Lê Đại', '0123456389', 'A100000981', null);

INSERT INTO bill
VALUES
    ('B00010', convert(datetime,'2023-11-23 10:00:00',120), 0, 'R003', 'T001', 'C00000004', null);

INSERT INTO dish_isincluded_bill
VALUES
    ('B00010', 'D00001', 3, null);
INSERT INTO dish_isincluded_bill
VALUES
    ('B00010', 'D00002', 3, null);
INSERT INTO dish_isincluded_bill
VALUES
    ('B00010', 'D00003', 3, null);

UPDATE dish_isincluded_bill
SET dish_count = 100
WHERE dish_id = 'D00001' AND bill_id = 'B00010'

SELECT *
FROM bill
SELECT *
FROM dish_isincluded_bill
SELECT *
FROM prom_applies_bill
SELECT *
FROM customer


SELECT *
FROM customer
UPDATE bill
SET bill.pay_status = 0
WHERE bill.bill_id = 'B00010'
SELECT *
FROM customer

INSERT INTO prom_applies_bill
VALUES
	('P00010', 'B00010');


SELECT *
FROM bill
SELECT *
FROM customer
INSERT INTO prom_applies_bill
VALUES
	('P11111', 'B00010');
SELECT *
FROM bill
SELECT *
FROM customer

SELECT *
FROM bill
SELECT *
FROM customer
DELETE prom_applies_bill
WHERE bill_id = 'B00010' AND promotion_id = 'P11111'
SELECT *
FROM bill
SELECT *
FROM customer

SELECT *
FROM bill

SELECT *
FROM bill
