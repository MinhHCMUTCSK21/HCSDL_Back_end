USE btlfinal
GO

-- add trigger --
-- Trigger 1 begin
-- trigger increase/decrease table_count
CREATE OR ALTER TRIGGER increase_table_count_when_add_table
ON r_table
FOR INSERT
AS
BEGIN
	UPDATE restaurant
	SET  restaurant.table_count = restaurant.table_count + 1
	WHERE restaurant.res_id = (SELECT inserted.res_id
	FROM inserted)
END
GO

CREATE OR ALTER TRIGGER decrease_table_count_when_delete_table
ON r_table
FOR DELETE
AS
BEGIN
	UPDATE restaurant
	SET restaurant.table_count = restaurant.table_count - 1
	WHERE restaurant.res_id = (SELECT deleted.res_id
	FROM deleted)
END
GO

--  trigger increase/decrease total_slot
CREATE OR ALTER TRIGGER increase_total_slot_when_add_table
ON r_table
FOR INSERT
AS
BEGIN
	UPDATE restaurant
	SET restaurant.total_slot = restaurant.total_slot + (SELECT inserted.slot_count
	FROM inserted)
	WHERE restaurant.res_id = (SELECT inserted.res_id
	FROM inserted)
END
GO

CREATE OR ALTER TRIGGER increase_total_slot_when_delete_table
ON r_table
FOR DELETE
AS
BEGIN
	UPDATE restaurant
	SET restaurant.total_slot = restaurant.total_slot - (SELECT deleted.slot_count
	FROM deleted)
	WHERE restaurant.res_id = (SELECT deleted.res_id
	FROM deleted)
END
GO