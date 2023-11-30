USE btlfinal
GO


-- trigger cap nhat diem tich luy khi khach hang thanh toan hoa don
CREATE OR ALTER TRIGGER update_loyalty_point_when_pay_bill
ON bill 
FOR UPDATE
AS 
BEGIN
    DECLARE @cus_id VARCHAR(10)
    DECLARE @old_pay_status BIT
    DECLARE @new_pay_status BIT
    DECLARE @total_cost INT

    SELECT @cus_id = inserted.cus_id, @new_pay_status = inserted.pay_status, @total_cost = inserted.total_cost
    FROM inserted

    SELECT @old_pay_status = deleted.pay_status
    FROM deleted

    IF @new_pay_status = 1 AND @old_pay_status = 0
    BEGIN
        UPDATE customer
        SET customer.loyalty_point = customer.loyalty_point + FLOOR(@total_cost/1000000.0)
        WHERE customer.cus_id = @cus_id
    END
END
GO

-- Trigger tinh total price khi ap dung khuyen mai diem tich luy
CREATE OR ALTER TRIGGER total_cost_when_use_loyalty_point
ON prom_applies_bill
FOR INSERT
AS 
BEGIN
    DECLARE @promotion_id VARCHAR(10)
    DECLARE @bill_id VARCHAR(10)
    DECLARE @cus_id VARCHAR(10)
    DECLARE @check INT
    DECLARE @promotion_type VARCHAR(30)
    DECLARE @reduce_price INT


    SELECT @promotion_id = inserted.promotion_id, @bill_id = inserted.bill_id
    FROM inserted

    SELECT @promotion_type = promotion.promotion_type, @reduce_price = promotion.reduced_price
    FROM promotion
    WHERE promotion.promotion_id = @promotion_id

    IF LOWER(@promotion_type) <> LOWER('LOYALTY_POINT')
    BEGIN
        RETURN
    END

    IF (SELECT bill.pay_status
    FROM bill
    WHERE bill.bill_id = @bill_id) = 1
    BEGIN
        PRINT 'Khong ap dung khuyen mai diem tich luy cho hoa don da thanh toan'
        ROLLBACK
        RETURN
    END

    SELECT @check = COUNT(promotion.promotion_id)
    FROM prom_applies_bill JOIN promotion ON prom_applies_bill.promotion_id = promotion.promotion_id
    WHERE prom_applies_bill.bill_id = @bill_id AND LOWER(promotion.promotion_type) = LOWER('LOYALTY_POINT')
        AND prom_applies_bill.promotion_id <> @promotion_id

    IF @check > 0
    BEGIN
        PRINT 'Hoa don da duoc ap dung khuyen mai diem tich luy'
        ROLLBACK
        RETURN
    END

    SELECT @cus_id = bill.cus_id
    FROM bill
    WHERE bill.bill_id = @bill_id

    SELECT @check = customer.loyalty_point
    FROM customer
    WHERE customer.cus_id = @cus_id

    IF @check < 10
    BEGIN
        PRINT 'Khach hang khong du diem tich luy'
        ROLLBACK
        RETURN
    END

    UPDATE customer
    SET customer.loyalty_point = customer.loyalty_point - 10
    WHERE customer.cus_id = @cus_id

    -- disable trigger 
    ALTER TABLE bill DISABLE TRIGGER update_loyalty_point_when_pay_bill
    UPDATE bill 
    SET bill.total_cost = bill.total_cost - @reduce_price
    WHERE bill.bill_id = @bill_id
    -- enable trigger 
    ALTER TABLE bill ENABLE TRIGGER update_loyalty_point_when_pay_bill
END
GO

CREATE OR ALTER TRIGGER total_cost_when_unuse_loyalty_point
ON prom_applies_bill
FOR DELETE
AS 
BEGIN
    DECLARE @promotion_id VARCHAR(10)
    DECLARE @bill_id VARCHAR(10)
    DECLARE @cus_id VARCHAR(10)
    DECLARE @promotion_type VARCHAR(30)
    DECLARE @reduce_price INT


    SELECT @promotion_id = deleted.promotion_id, @bill_id = deleted.bill_id
    FROM deleted

    SELECT @promotion_type = promotion.promotion_type, @reduce_price = promotion.reduced_price
    FROM promotion
    WHERE promotion.promotion_id = @promotion_id

    IF LOWER(@promotion_type) <> LOWER('LOYALTY_POINT')
    BEGIN
        RETURN
    END

    SELECT @cus_id = bill.cus_id
    FROM bill
    WHERE bill.bill_id = @bill_id

    UPDATE customer
    SET customer.loyalty_point = customer.loyalty_point + 10
    WHERE customer.cus_id = @cus_id

    -- disable trigger 
    ALTER TABLE bill DISABLE TRIGGER update_loyalty_point_when_pay_bill
    UPDATE bill 
    SET bill.total_cost = bill.total_cost + @reduce_price
    WHERE bill.bill_id = @bill_id
    -- enable trigger 
    ALTER TABLE bill ENABLE TRIGGER update_loyalty_point_when_pay_bill
END
GO