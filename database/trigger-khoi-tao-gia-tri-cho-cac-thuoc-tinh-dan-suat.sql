USE btlfinal
GO
-- trigger auto set derived attribute to zero
-- on restaurant
CREATE OR ALTER TRIGGER set_zero_derived_attribute_on_restaurant
ON restaurant
FOR INSERT
AS
BEGIN
	UPDATE restaurant
	SET  restaurant.table_count = 0, restaurant.total_slot = 0
	WHERE restaurant.res_id = (SELECT inserted.res_id
	FROM inserted)
END
GO

-- on customer
CREATE OR ALTER TRIGGER set_zero_derived_attribute_on_customer
ON customer
FOR INSERT
AS
BEGIN
	UPDATE customer
	SET  customer.loyalty_point = 0
	WHERE customer.cus_id = (SELECT inserted.cus_id
	FROM inserted)
END
GO

-- on customer
CREATE OR ALTER TRIGGER set_zero_derived_attribute_on_bill
ON bill
FOR INSERT
AS
BEGIN
	UPDATE bill
	SET  bill.total_cost = 0
	WHERE bill.bill_id = (SELECT inserted.bill_id
	FROM inserted)
END
GO

-- on dish_isincluded_bill
-- trigger