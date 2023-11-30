USE [btlfinal]
GO


-------------------- INSERT PROCS AND FUNCS --------------------
-- MAKE NEW BILL
-- var: RES_ID, TABLE_ID, CUS_ID,
-- NEW BILL ( GETDATE(), 0, RES_ID, TABLE_ID, CUS_ID)

-- ADD DISHES TO BILL
-- var: BILL_ID, DISH_ID, DISH_COUNT
-- NEW DISH_ISINCLUDED_BILL (BILL_ID, DISH_ID, DISH_COUNT, 0)

/*
CREATE OR ALTER PROCEDURE new_bill (@res_id VARCHAR(10), @table_id VARCHAR(10), @cus_id INT, @bill BIGINT OUTPUT)
AS
BEGIN
	INSERT INTO [dbo].[bill]
		VALUES (GETDATE(), 0, @res_id, @table_id, @cus_id, 0);
	SELECT @bill = MAX(b.bill_id) FROM [dbo].[bill] AS b;
END;
GO

CREATE OR ALTER FUNCTION return_bill_id (@res_id VARCHAR(10), @table_id VARCHAR(10), @cus_id INT)
RETURNS BIGINT AS
BEGIN
	DECLARE @bill_id BIGINT = 0;
	EXEC [dbo].[new_bill] @res_id, @table_id, @cus_id, @bill_id OUTPUT;
	RETURN @bill_id;
END;
GO

CREATE OR ALTER PROCEDURE add2bill (@bill_id BIGINT, @dish_id INT, @dish_count INT) AS
BEGIN
	INSERT INTO [dbo].[dish_isincluded_bill]
		VALUES (@bill_id, @dish_id, @dish_count, 0);
END;
GO


CREATE OR ALTER PROCEDURE THROW_ERROR (@message VARCHAR(50)) AS
BEGIN
	IF @message IS NOT NULL
		THROW 51000, @message, 1;
END
GO

*/

-------------------- CUSTOMIZED PROCS --------------------
GO
/****** Object:  StoredProcedure [dbo].[customer_expense] ******/
CREATE OR ALTER PROCEDURE [dbo].[customer_expense] (@month VARCHAR(10), @year VARCHAR(10), @amount BIGINT) AS
	IF (ISNUMERIC(@month) = 0 OR ISNUMERIC(@year) = 0) 
		RETURN 'ONLY ENTER NUMBERS FOR DATE FIELDS';
	DECLARE @m INT = CAST(@month AS INT),
			@y INT = CAST(@year AS INT);
	IF @y < 0 OR (@m NOT BETWEEN 1 AND 12)
		RETURN 'INVALID DATE INPUTED';
	IF @amount < 0
		RETURN 'INVALID AMOUNT INPUTED';
	SELECT		c.*, sum(b.total_cost) AS Total
	FROM		bill AS b JOIN customer AS c ON b.cus_id = c.cus_id
	WHERE		b.pay_status = 1 AND DATEPART(mm,b.bill_datetime) = @month AND DATEPART(yyyy,b.bill_datetime) = @year
	GROUP BY	c.cus_id, c.cus_name, c.phone_num, c.account_id, c.loyalty_point
	HAVING		sum(b.total_cost) > @amount
	ORDER BY	Total DESC;
GO


/****** Object:  StoredProcedure [dbo].[staff_age_above] ******/
CREATE OR ALTER PROCEDURE [dbo].[staff_age_in_range] (@agestart NVARCHAR(20),@ageend NVARCHAR(20)) AS
	IF (ISNUMERIC(@agestart) = 0 OR ISNUMERIC(@ageend) = 0) 
		THROW 51000, 'ONLY ENTERED NUMBERS FOR AGE FIELDS', 1;
	DECLARE @ystart DATETIME,
			@yend DATETIME;
	SELECT @ystart = DATEADD(year, - CAST(@ageend AS INT), GETDATE());
	SELECT @yend = DATEADD(year, - CAST(@agestart AS INT), GETDATE());
	IF @yend > GETDATE() OR @ystart > @yend
		THROW 51000, 'INVALID AGE INPUTED', 1;
	SELECT		s.*
	FROM		dbo.staff AS s JOIN dbo.restaurant AS r ON s.res_id = r.res_id
	WHERE		s.date_of_birth BETWEEN @ystart AND @yend
	ORDER BY	r.province;
GO

-------------------- CUSTOMIZED FUNCS --------------------
CREATE OR ALTER FUNCTION [dbo].[most_fav_dish] (@month VARCHAR(100), @year VARCHAR(100))
RETURNS NVARCHAR(512) AS
BEGIN
	-- PRECHECK INPUTS --
	IF (ISNUMERIC(@month) = 0 OR ISNUMERIC(@year) = 0) 
		RETURN 'ONLY ENTER NUMBERS FOR DATE FIELDS';
	DECLARE @m INT = CAST(@month AS INT),
			@y INT = CAST(@year AS INT);
	IF @y < 0 OR (@m NOT BETWEEN 1 AND 12)
		RETURN 'INVALID DATE INPUTED';
	-- DECLARE VARS --
	DECLARE @result NVARCHAR(1024),
			@max INT = -1,
			@tmpname NVARCHAR(256),
			@tmpC INT = 0,
			@i INT = 0;
	DECLARE dsh_count CURSOR FOR
	SELECT d.dish_name, SUM(i.dish_count) AS Count
	FROM	([dbo].[bill] as b JOIN [dbo].[dish_isincluded_bill] as i ON b.bill_id = i.bill_id) JOIN [dbo].[dish] as d ON i.dish_id = d.dish_id
	WHERE	b.pay_status = 1 AND DATEPART(mm, b.bill_datetime) = @m AND DATEPART(yyyy, b.bill_datetime) = @y
	GROUP BY d.dish_name
	ORDER BY Count DESC;
	-- COMPUTE --
	OPEN dsh_count;
	FETCH NEXT FROM dsh_count INTO
			@tmpname,
			@tmpC;
	SET @max = @tmpC;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @tmpC < @max
			BREAK;
		IF @i > 0
			SET @result = CONCAT(@result, N', ');
		SET @result = CONCAT(@result, @tmpname);
		-- next loop init--
		SET @i = @i + 1;
		FETCH NEXT FROM dsh_count INTO
				@tmpname,
				@tmpC;
		
	END
	CLOSE dsh_count
	DEALLOCATE dsh_count;
	-- add the total count for them
	SET @result = CONCAT(@result, N': ', CAST(@max AS NVARCHAR(20)), N' lần.');
	RETURN @result
END
GO

CREATE OR ALTER FUNCTION [dbo].[income_in_year] (@year VARCHAR(10), @res_id VARCHAR(10))
RETURNS VARCHAR(1024) AS
BEGIN
	IF (ISNUMERIC(@year) = 0) 
		RETURN 'ERROR: ONLY ENTER NUMBERS FOR DATE FIELDS';
	--IF (SELECT DATALENGTH(@res_id)) <> 4)-- OR  @res_id NOT LIKE '%[^a-zA-Z0-9]%'
	--	RETURN 'ERROR: ONLY ENTER 4 NUMBERS AND/OR CHARACTERS FOR RESTAURANT ID FIELD';
	-- DECLARE VARS AND CURSOR --
	DECLARE c CURSOR FOR
		SELECT	DATEPART(mm, b.bill_datetime) AS Month, SUM(b.total_cost) AS Total
		FROM	[dbo].[bill] as b
		WHERE	b.pay_status = 1 AND b.res_id = @res_id AND DATEPART(yyyy, b.bill_datetime) = CAST(@year AS INT)
		GROUP BY	DATEPART(mm, b.bill_datetime)
		ORDER BY Total DESC;
	DECLARE @result VARCHAR(1024) = 'Max: Month ',
			@sum INT = 0,
			@m INT,
			@count INT = 0,
			@mon INT;

	-- COMPUTE --
	OPEN c
	FETCH NEXT FROM c INTO
		@mon,
		@m;
	SET @result = CONCAT(@result, CAST(@mon AS VARCHAR(10)), ', with income = ', CAST(@m AS VARCHAR(10)));
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sum = @sum + @m;
		SET @count = @count + 1;
		FETCH NEXT FROM c INTO
			@mon,
			@m;
	END
	CLOSE c
	DEALLOCATE c;
	SET @result = CONCAT(@result, '; Min: Month ', CAST(@mon AS VARCHAR(10)), ', with income = ',CAST(@m AS VARCHAR(10)));
	SET @sum = ROUND(@sum / @count, 0);
	SET @result = CONCAT(@result, '; Average (rounded to integer) = ', CAST(@sum AS VARCHAR(10)),'.');
	RETURN @result;
END 
GO
