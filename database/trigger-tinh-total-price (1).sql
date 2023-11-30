USE btlfinal
GO
-- Trigger tinh total price khi them mot mon an vao hoa don
CREATE OR ALTER TRIGGER calculate_current_price_when_add_a_dish_to_bill
ON dbo.dish_isincluded_bill
FOR INSERT
AS
BEGIN
    DECLARE @dish_id VARCHAR(10)
    DECLARE @bill_id VARCHAR(10)
    DECLARE @time DATETIME
    DECLARE @orignPrice INT

    DECLARE @promotion_id VARCHAR(10)
    DECLARE @promotion_type VARCHAR(30)
    DECLARE @reduce_price INT
    DECLARE @reduce_percent INT


    SET @time = GETDATE()

    SELECT @dish_id = inserted.dish_id, @bill_id = inserted.bill_id
    FROM inserted


    SELECT @orignPrice = dish.price
    FROM dish
    WHERE dish.dish_id = @dish_id

    -- disable trigger 
    ALTER TABLE dish_isincluded_bill DISABLE TRIGGER update_total_price_when_change_numOf_dish_in_bill
    -- gan current price = gia goc
    UPDATE dish_isincluded_bill
    SET dish_isincluded_bill.current_price = @orignPrice
    WHERE dish_isincluded_bill.bill_id = @bill_id AND dish_isincluded_bill.dish_id = @dish_id
    -- enable trigger
    ALTER TABLE dish_isincluded_bill ENABLE TRIGGER update_total_price_when_change_numOf_dish_in_bill


    -- tinh current price neu co khuyen mai
    DECLARE mycursor CURSOR
    FOR
    SELECT promotion.promotion_id, promotion.promotion_type, promotion.reduced_price, promotion.reduced_percent
    FROM promotion JOIN dish_isapplied_prom ON promotion.promotion_id = dish_isapplied_prom.promotion_id
    WHERE (@time BETWEEN promotion.start_time AND promotion.end_time)
        AND dish_isapplied_prom.dish_id = @dish_id
        AND LOWER(promotion.promotion_type) <> LOWER('LOYALTY_POINT')
    
    OPEN mycursor
    FETCH NEXT FROM mycursor INTO @promotion_id, @promotion_type, @reduce_price, @reduce_percent

    -- disable trigger 
    ALTER TABLE prom_applies_bill DISABLE TRIGGER total_cost_when_use_loyalty_point
    -- disable trigger 
    ALTER TABLE dish_isincluded_bill DISABLE TRIGGER update_total_price_when_change_numOf_dish_in_bill
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'fetch status = 0'
        -- tu dong insert ma khuyen mai, neu da co ma khuyen mai thi khong insert
        IF (SELECT COUNT(*)
        FROM prom_applies_bill
        WHERE prom_applies_bill.promotion_id = @promotion_id) = 0
        BEGIN
            INSERT INTO prom_applies_bill
            VALUES(@promotion_id, @bill_id)
        END

        -- tinh current price dua vao loai khuyen mai
        IF LOWER(@promotion_type) = LOWER('Percentage_discount')
        BEGIN
            UPDATE dish_isincluded_bill
            SET dish_isincluded_bill.current_price = ROUND(dish_isincluded_bill.current_price - @orignPrice*(@reduce_percent/100.0), 0)
            WHERE dish_isincluded_bill.bill_id = @bill_id AND dish_isincluded_bill.dish_id = @dish_id
        END
        ELSE IF LOWER(@promotion_type) = LOWER('Price_discount')
        BEGIN
            UPDATE dish_isincluded_bill
            SET dish_isincluded_bill.current_price = ROUND(dish_isincluded_bill.current_price - @reduce_price, 0)
            WHERE dish_isincluded_bill.bill_id = @bill_id AND dish_isincluded_bill.dish_id = @dish_id
        END

        FETCH NEXT FROM mycursor INTO @promotion_id, @promotion_type, @reduce_price, @reduce_percent
    END
    -- enable trigger
    ALTER TABLE prom_applies_bill ENABLE TRIGGER total_cost_when_use_loyalty_point
    -- enable trigger
    ALTER TABLE dish_isincluded_bill ENABLE TRIGGER update_total_price_when_change_numOf_dish_in_bill

    CLOSE mycursor
    DEALLOCATE mycursor

    DECLARE @numOfDish INT

    -- tinh/cap nhat tong tien cua bill
    SELECT @orignPrice = dish_isincluded_bill.current_price, @numOfDish = dish_isincluded_bill.dish_count
    FROM dish_isincluded_bill
    WHERE dish_isincluded_bill.bill_id = @bill_id AND dish_isincluded_bill.dish_id = @dish_id

    -- disable trigger 
    ALTER TABLE bill DISABLE TRIGGER update_loyalty_point_when_pay_bill
    UPDATE bill
    SET bill.total_cost = bill.total_cost + @orignPrice*@numOfDish
    WHERE bill.bill_id = @bill_id
    -- enable trigger 
    ALTER TABLE bill ENABLE TRIGGER update_loyalty_point_when_pay_bill

END
GO


-- Trigger tinh total price khi xoa mot mon an khoi hoa don
CREATE OR ALTER TRIGGER calculate_total_price_when_delete_a_dish_to_bill
ON dbo.dish_isincluded_bill
FOR DELETE
AS
BEGIN
    DECLARE @bill_id VARCHAR(10)
    DECLARE @currentPrice INT
    DECLARE @numOfDish INT

    SELECT @currentPrice = deleted.current_price, @bill_id = deleted.bill_id, @numOfDish = deleted.dish_count
    FROM deleted

    -- disable trigger 
    ALTER TABLE bill DISABLE TRIGGER update_loyalty_point_when_pay_bill
    UPDATE bill
    SET bill.total_cost = total_cost - @currentPrice*@numOfDish
    WHERE bill.bill_id = @bill_id
    -- enable trigger 
    ALTER TABLE bill ENABLE TRIGGER update_loyalty_point_when_pay_bill


END
GO

-- Trigger tinh total price khi thay doi so luong mot mon an khoi hoa don
CREATE OR ALTER TRIGGER update_total_price_when_change_numOf_dish_in_bill
ON dbo.dish_isincluded_bill
FOR UPDATE
AS
BEGIN
    DECLARE @bill_id VARCHAR(10)
    DECLARE @currentPrice INT
    DECLARE @newNum INT
    DECLARE @oldNum INT

    SELECT @currentPrice = deleted.current_price, @bill_id = deleted.bill_id, @oldNum = deleted.dish_count
    FROM deleted

    SELECT @newNum = inserted.dish_count
    FROM inserted

    IF @newNum = @oldNum
    BEGIN
        RETURN
    END

    UPDATE bill
    SET bill.total_cost = total_cost + @currentPrice*(CONVERT(int, @newNum) - CONVERT(int, @oldNum))
    WHERE bill.bill_id = @bill_id
END
GO



