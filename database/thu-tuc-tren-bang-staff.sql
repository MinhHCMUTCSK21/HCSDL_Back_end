USE btlfinal
GO

-- thu tuc them nhan vien
-- tu dong tao tai khoan (account) : name: identification, pass: identification
-- tu dong insert sdt
-- tu dong insert email ca nhan
CREATE OR ALTER PROCEDURE Add_staff
    @identification char(12),
    @staff_name nvarchar(50),
    @gender bit,
    @date_of_birth date,
    @manager_id varchar(10),
    @province nvarchar(50),
    @district nvarchar(50),
    @ward nvarchar(50),
    @address_number nvarchar(50),
    @res_id varchar(10),
    @email VARCHAR(30),
    @phone VARCHAR(10),
    @account_id VARCHAR(10)
AS
BEGIN
    -- Kiem tra ma dinh danh nhan vien
    IF @identification IS NULL
        THROW 51000, 'Khong duoc de trong ma dinh danh cua nhan vien', 1
    ELSE
    BEGIN
        IF (@identification LIKE '%[^0-9]%')
            THROW 51000, 'Ma dinh danh cua nhan vien khong dung dinh dang (dung 12 chu so)', 1
        ELSE IF (SELECT COUNT(*)
			FROM staff
			WHERE staff.identification = @identification) > 0
            THROW 51000, 'Ma dinh danh da ton tai',1
    END

    -- Kiem tra ten nhan vien
    IF @staff_name IS NULL
        THROW 51000, 'Khong duoc de trong ten nhan vien', 1

    -- Kiem tra gioi tinh nhan vien
    IF @gender IS NULL
		THROW 51000,'Khong duoc de trong gioi tinh cua nhan vien (1-Nam / 2-Nu)', 1

    -- kiem tra tuoi cua nhan vien
    IF @date_of_birth IS NULL
		THROW 51000,'Khong duoc de trong ngay sinh cua nhan vien', 1
    ELSE IF DATEDIFF(YEAR , CONVERT(datetime, @date_of_birth), GETDATE()) < 18
         THROW 51000, 'Nhan vien phai du 18 tuoi', 1

    -- kiem tra ma so cua nguoi quan ly
    IF @manager_id IS NOT NULL
        IF (SELECT COUNT(*)
        FROM staff
        WHERE staff.staff_id = @manager_id) = 0
			THROW 51000, 'Khong tim thay ma so cua nguoi quan ly', 1

    -- Kiem tra dia chi nhan vien
    IF @province IS NULL
		THROW 51000,'Khong duoc de trong dia chi (tinh thanh)', 1

    IF @district IS NULL
		THROW 51000,'Khong duoc de trong dia chi (quyan/huyen)', 1

    IF @ward IS NULL
		THROW 51000, 'Khong duoc de trong dia chi (phuong/xa)', 1

    IF @address_number IS NULL
		THROW 51000,'Khong duoc de trong dia chi (so duong)', 1

    -- Kiem tra ma nha hang
    IF @res_id IS NULL
		THROW 51000,'Khong duoc de trong ma nha hang', 1
    ELSE IF (SELECT COUNT(*)
			FROM restaurant
			WHERE restaurant.res_id = @res_id) = 0
        THROW 51000, 'Ma nha hang khong ton tai', 1

    IF @account_id IS NULL
		THROW 51000, 'Khong duoc de trong ma tai khoan', 1
    ELSE IF (SELECT COUNT(*)
        FROM account
        WHERE account.account_id = @account_id) > 0
			THROW 51000,'Ma tai khoan da ton tai.', 1

    INSERT INTO account
    VALUES(@account_id, @identification)

    INSERT INTO staff
        (identification, staff_name, gender, date_of_birth, manager_id, province, district, ward, address_number, res_id, account_id)
    VALUES(@identification, @staff_name, @gender, @date_of_birth, @manager_id, @province, @district, @ward, @address_number, @res_id, @account_id)

    -- insert cac bang staff email, phone
    DECLARE @staff_id INT

    SELECT @staff_id = staff.staff_id
    FROM staff
    WHERE staff.identification = @identification

    IF @email IS NOT NULL
    BEGIN
        INSERT INTO staff_email
        VALUES(@staff_id, @email)
    END

    IF @phone IS NOT NULL
    BEGIN
        INSERT INTO staff_phone
        VALUES(@staff_id, @phone)
    END

    PRINT 'Them nhan vien thanh cong'
END
GO

-- thu tuc cap nhat thong tin nhan vien theo staff id
CREATE OR ALTER PROCEDURE Update_staff_by_id
    @staff_id INT,
    @identification char(12),
    @staff_name nvarchar(50),
    @gender bit,
    @date_of_birth date,
    @manager_id varchar(10),
    @province nvarchar(50),
    @district nvarchar(50),
    @ward nvarchar(50),
    @address_number nvarchar(50),
    @res_id varchar(10),
    @account_id VARCHAR(10)
AS
BEGIN
    IF @staff_id IS NULL
		THROW 51000,'Khong de trong truong staff id', 1
    ELSE IF (SELECT COUNT(*)
        FROM staff
        WHERE staff.staff_id = @staff_id) = 0
			THROW 51000,'Khong tim thay staff id.', 1

    -- Kiem tra ma dinh danh nhan vien
    IF @identification IS NULL
    BEGIN
        SELECT @identification = staff.identification
        FROM staff
        WHERE staff.staff_id = @staff_id
    END
    ELSE IF (@identification LIKE '%[^0-9]%')
			THROW 51000,'Ma dinh danh cua nhan vien khong dung dinh dang (dung 12 chu so)', 1
        ELSE IF (SELECT COUNT(*)
        FROM staff
        WHERE staff.identification = @identification) > 0
			THROW 51000,'Ma dinh danh da ton tai', 1

    -- Kiem tra ten nhan vien
    IF @staff_name IS NULL
    BEGIN
        SELECT @staff_name = staff.staff_name
        FROM staff
        WHERE staff.staff_id = @staff_id
    END

    -- Kiem tra gioi tinh nhan vien
    IF @gender IS NULL
    BEGIN
        SELECT @gender = staff.gender
        FROM staff
        WHERE staff.staff_id = @staff_id
    END

    -- kiem tra tuoi cua nhan vien
    IF @date_of_birth IS NULL
    BEGIN
        SELECT @date_of_birth = staff.date_of_birth
        FROM staff
        WHERE staff.staff_id = @staff_id
    END
    ELSE IF DATEDIFF(YEAR , CONVERT(datetime, @date_of_birth), GETDATE()) < 18
			THROW 51000,'Nhan vien phai du 18 tuoi', 1

    -- kiem tra ma so cua nguoi quan ly
    IF @manager_id IS NULL
    BEGIN
        SELECT @manager_id = staff.manager_id
        FROM staff
        WHERE staff.staff_id = @staff_id
    END
    ELSE IF (SELECT COUNT(*)
        FROM staff
        WHERE staff.staff_id = @manager_id) = 0
			THROW 51000, 'Khong tim thay ma so cua nguoi quan ly', 1

        IF @staff_id = @manager_id
			THROW 51000, 'Ma nhan vien khong duoc trung voi ma nguoi quan ly', 1

    -- Kiem tra dia chi nhan vien
    IF @province IS NULL
    BEGIN
        SELECT @province = staff.province
        FROM staff
        WHERE staff.staff_id = @staff_id
    END

    IF @district IS NULL
    BEGIN
        SELECT @district = staff.district
        FROM staff
        WHERE staff.staff_id = @staff_id
    END

    IF @ward IS NULL
    BEGIN
        SELECT @ward = staff.ward
        FROM staff
        WHERE staff.staff_id = @staff_id
    END

    IF @address_number IS NULL
    BEGIN
        SELECT @address_number = staff.address_number
        FROM staff
        WHERE staff.staff_id = @staff_id
    END

    -- Kiem tra ma nha hang
    IF @res_id IS NULL
    BEGIN
        SELECT @res_id = staff.res_id
        FROM staff
        WHERE staff.staff_id = @staff_id
    END
    ELSE IF (SELECT COUNT(*)
        FROM restaurant
        WHERE restaurant.res_id = @res_id) = 0
			THROW 51000, 'Ma nha hang khong ton tai', 1

    IF @account_id IS NULL
    BEGIN
        SELECT @account_id = staff.account_id
        FROM staff
        WHERE staff.staff_id = @staff_id
    END
    ELSE IF (SELECT COUNT(*)
        FROM account
        WHERE account.account_id = @account_id) = 0
			THROW 51000,'Ma tai khoan khong ton tai', 1
        ELSE IF (SELECT COUNT(*)
                FROM staff
                WHERE staff.account_id = @account_id) > 0
                OR
                (SELECT COUNT(*)
                FROM customer
                WHERE customer.account_id = @account_id) > 0
            THROW 51000, 'Ma tai khoan da duoc nguoi khac su dung', 1

    UPDATE staff
    SET
        identification = @identification,
        staff_name = @staff_name,
        gender = @gender,
        date_of_birth = @date_of_birth,
        manager_id = @manager_id,
        province = @province,
        district = @district,
        ward = @ward,
        address_number = @address_number,
        res_id = @res_id,
        account_id = @account_id
    WHERE
        staff_id = @staff_id;

    PRINT 'Cap nhat thong tin nhan vien thanh cong'
END
GO

CREATE OR ALTER PROCEDURE Delete_staff_by_id
    @staff_id INT
AS
BEGIN

    IF @staff_id IS NULL
		THROW 51000, 'Khong de trong truong staff id', 1
    ELSE IF (SELECT COUNT(*)
        FROM staff
        WHERE staff.staff_id = @staff_id) = 0
			THROW 51000,'Khong tim thay staff id.', 1

    UPDATE staff
    SET manager_id = NULL
    WHERE manager_id = @staff_id

    DELETE staff WHERE staff.staff_id = @staff_id

    PRINT 'Xoa nhan vien thanh cong'
END
GO

SELECT *
FROM staff
