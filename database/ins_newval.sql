USE [btlfinal]

-- Insert values 
-- insert
-- restaurant
INSERT INTO restaurant
VALUES
	('R001', N'Ngô Quyền 1', '0346066323', N'TPHCM', N'Thủ Đức', N'Linh Trung', N'KTX Khu A', null, null);

INSERT INTO restaurant
VALUES
	('R002', N'Ngô Quyền 2', '0346066729', N'Đồng Nai', N'Biên Hòa', N'Phước Tân', N'Khu phố Hương Phước', null, null);

INSERT INTO restaurant
VALUES
	('R003', N'Ngô Quyền 3', '0346066768', N'TPHCM', N'Thủ Đức', N'Linh Trung', N'KTX Khu B', null, null);

INSERT INTO restaurant
VALUES
	('R004', N'Ngô Quyền 4', '0346066789', N'TPHCM', N'Gò Vấp', N'Phường 4', N'101 Phạm Ngũ Lão', null, null);

INSERT INTO restaurant
VALUES
	('R005', N'Ngô Quyền 5', '0346066658', N'TPHCM', N'Tân Bình', N'Phường 2', N'20 Bạch Đằng', null, null);

-- insert table
INSERT INTO r_table
VALUES
	('R001', 'T001', 10);

INSERT INTO r_table
VALUES
	('R001', 'T002', 6);

INSERT INTO r_table
VALUES
	('R002', 'T001', 10);

INSERT INTO r_table
VALUES
	('R002', 'T002', 8);

INSERT INTO r_table
VALUES
	('R003', 'T001', 10);

INSERT INTO r_table
VALUES
	('R003', 'T002', 6);

INSERT INTO r_table
VALUES
	('R004', 'T001', 4);

INSERT INTO r_table
VALUES
	('R004', 'T002', 8);

INSERT INTO r_table
VALUES
	('R005', 'T003', 10);

INSERT INTO r_table
VALUES
	('R005', 'T004', 10);


INSERT INTO account
VALUES
	('A000001112', 'tien123');


INSERT INTO account
VALUES
	('A000000321', 'ertfjhj');
INSERT INTO account
VALUES
	('A000000981', 'dddfgbf');
INSERT INTO account
VALUES
	('A100000001', 'tie123');
INSERT INTO account
VALUES
	('A100000011', '245556');
INSERT INTO account
VALUES
	('A100000002', 'adpfght');
INSERT INTO account
VALUES
	('A100000321', 'ertpfjhj');
INSERT INTO account
VALUES
	('A100000981', 'dddpfgbf');

INSERT INTO customer
VALUES
	('C00000001', N'Nguyễn Đại', '0123456789', 'A100000001', null);
INSERT INTO customer
VALUES
	('C00000002', N'Nguyễn Tiến', '0123456799', 'A100000011', null);
INSERT INTO customer
VALUES
	('C00000003', N'Nguyễn Quang', '0123456789', 'A100000002', null);
INSERT INTO customer
VALUES
	('C00000004', N'Nguyễn Hoàng', '0123456489', 'A100000321', null);
INSERT INTO customer
VALUES
	('C00000005', N'Lê Đại', '0123456389', 'A100000981', null);


INSERT INTO reservation
VALUES
	('RS00000001', 10, convert(datetime,'2023-11-22 08:08:08',120), 'C00000001');
INSERT INTO reservation
VALUES
	('RS00000002', 8, convert(datetime,'2023-10-22 07:08:08',120), 'C00000002');
INSERT INTO reservation
VALUES
	('RS00000003', 6, convert(datetime,'2023-11-22 11:08:08',120), 'C00000002');
INSERT INTO reservation
VALUES
	('RS00000004', 4, convert(datetime,'2023-11-22 12:08:08',120), 'C00000003');
INSERT INTO reservation
VALUES
	('RS00000005', 5, convert(datetime,'2023-11-22 08:08:09',120), 'C00000004');


INSERT INTO dish
VALUES
	('D00001', N'Lẩu hải sản', 250000, 'https://cdn.tgdd.vn/2021/06/CookRecipe/Avatar/lau-hai-san-nam-thumbnail.jpg', N'Lẩu');
INSERT INTO dish
VALUES
	('D00002', N'Lẩu cá bớp', 250000, 'https://cdn.tgdd.vn/Files/2019/12/26/1228574/2-cach-nau-lau-ca-bop-ngon-khong-tanh-chua-chua-cay-cay-ai-cung-ghien--7.jpg' , N'Lẩu');
INSERT INTO dish
VALUES
	('D00003', N'Lẩu cá thác lác', 255000, 'https://cdn.tgdd.vn/Files/2019/06/05/1171211/cach-nau-lau-ca-thac-lac-kho-qua-cuc-ngon-cho-ngay-mua-202208251720312229.jpg' , N'Lẩu');
INSERT INTO dish
VALUES
	('D00004', N'Cơm rang hải sản', 175000, 'https://cdn.tgdd.vn/2021/01/CookProduct/comchienhaisan-1200x676.jpg' , N'Cơm');
INSERT INTO dish
VALUES
	('D00005', N'Cơm rang cá mặn', 79000 , 'https://cdn.tgdd.vn/Files/2021/04/10/1342295/cach-lam-com-chien-ca-man-gion-ngon-chuan-nha-hang-202104101405061079.jpg' , N'Cơm');
INSERT INTO dish
VALUES
	('D00006', N'Mì xào hải sản', 200000, 'https://cdn.tgdd.vn/2022/07/CookRecipe/Avatar/mi-xao-hai-san-thumbnail.jpg', N'Mì');
INSERT INTO dish
VALUES
	('D00007', N'Mì xào tôm', 175000, 'https://cdn.tgdd.vn/2021/03/CookRecipe/Avatar/mi-xao-tom-kieu-hong-kong-thumbnail-2.jpg' , N'Mì');
INSERT INTO dish
VALUES
	('D00008', N'Súp hải sản', 55000, 'https://cdn.tgdd.vn/Files/2020/02/07/1234859/cach-nau-sup-hai-san-thom-ngon-bo-duong-cho-ca-gia-dinh-202203151808152700.jpg', N'Súp');
INSERT INTO dish
VALUES
	('D00009', N'Súp cá hồi', 65000, 'https://cdn.tgdd.vn/2021/04/CookProduct/Cachnausupcahoiphomaichobeandambeomindinhduongdelam-1200x676.jpg' , N'Súp');
INSERT INTO dish
VALUES
	('D000010', N'Súp tôm kiểu Thái', 65000, 'https://nhahangphuongnamhalong.com/wp-content/uploads/2019/04/s%C3%BAp-t%C3%B4m-chua-cay.jpg', N'Súp');


INSERT INTO promotion
VALUES
	('P00001', N'Giảm giá 20/11', 'Percentage_discount', convert(datetime,'2023-11-18 00:00:00',120), convert(datetime,'2023-11-20 23:00:00',120), null , 10);
INSERT INTO promotion
VALUES
	('P00002', N'Giảm giá khai trương', 'Percentage_discount', convert(datetime,'2020-09-18 00:00:00',120), convert(datetime,'2020-09-20 23:00:00',120), null , 50);
INSERT INTO promotion
VALUES
	('P00003', N'Giảm giá 2/9', 'Percentage_discount', convert(datetime,'2023-09-01 00:00:00',120), convert(datetime,'2023-09-02 23:00:00',120), null , 20);
INSERT INTO promotion
VALUES
	('P00004', N'Giảm giá 30/4', 'Price_discount', convert(datetime,'2023-04-28 00:00:00',120), convert(datetime,'2023-05-01 23:00:00',120), 50 , null);
INSERT INTO promotion
VALUES
	('P00005', N'Giảm giá tết nguyên đán', 'Price_discount', convert(datetime,'2023-01-25 00:00:00',120), convert(datetime,'2023-01-30 23:00:00',120), 100 , null);

INSERT INTO promotion
VALUES
	('P00010', N'Giảm giá tết duong lich', 'Price_discount', convert(datetime,'2023-11-25 00:00:00',120), convert(datetime,'2024-01-30 23:00:00',120), 100000 , null);

INSERT INTO promotion
VALUES
	('P00011', N'Giảm giá tết duong lich', 'Percentage_discount', convert(datetime,'2023-11-25 00:00:00',120), convert(datetime,'2024-01-30 23:00:00',120), null , 10);

INSERT INTO promotion
VALUES
	('P11111', N'loyalty', 'LOYALTY_POINT', convert(datetime,'2022-11-25 00:00:00',120), convert(datetime,'2024-01-30 23:00:00',120), 500000 , null);

INSERT INTO bill
VALUES
	('B00001', convert(datetime,'2023-11-18 10:00:00',120), 1, 'R001', 'T001', 'C00000001', null);
INSERT INTO bill
VALUES
	('B00002', convert(datetime,'2023-11-10 10:00:00',120), 1, 'R001', 'T002', 'C00000001', null);
INSERT INTO bill
VALUES
	('B00003', convert(datetime,'2023-11-11 10:00:00',120), 1, 'R002', 'T001', 'C00000002', null);
INSERT INTO bill
VALUES
	('B00004', convert(datetime,'2023-11-22 10:00:00',120), 1, 'R002', 'T001', 'C00000003', null);
INSERT INTO bill
VALUES
	('B00005', convert(datetime,'2023-11-23 10:00:00',120), 0, 'R003', 'T001', 'C00000004', null);


INSERT INTO reser_arrange_table
VALUES
	('RS00000001', 'R001', 'T001');
INSERT INTO reser_arrange_table
VALUES
	('RS00000002', 'R001', 'T002');
INSERT INTO reser_arrange_table
VALUES
	('RS00000003', 'R002', 'T001');
INSERT INTO reser_arrange_table
VALUES
	('RS00000004', 'R002', 'T002');
INSERT INTO reser_arrange_table
VALUES
	('RS00000005', 'R003', 'T001');

INSERT INTO reser_preorder_dish
VALUES
	('RS00000001', 'D00001', 1);
INSERT INTO reser_preorder_dish
VALUES
	('RS00000001', 'D00004', 2);
INSERT INTO reser_preorder_dish
VALUES
	('RS00000002', 'D00002', 3);
INSERT INTO reser_preorder_dish
VALUES
	('RS00000005', 'D00001', 1);
INSERT INTO reser_preorder_dish
VALUES
	('RS00000005', 'D00003', 2);

INSERT INTO dish_isincluded_bill
VALUES
	('B00001', 'D00001', 1, null);
INSERT INTO dish_isincluded_bill
VALUES
	('B00001', 'D00002', 1, null);
INSERT INTO dish_isincluded_bill
VALUES
	('B00001', 'D00003', 1, null);
INSERT INTO dish_isincluded_bill
VALUES
	('B00002', 'D00001', 1, null);
INSERT INTO dish_isincluded_bill
VALUES
	('B00002', 'D00005', 5, null);

INSERT INTO dish_isapplied_prom
VALUES
	('P00001', 'D00001');
INSERT INTO dish_isapplied_prom
VALUES
	('P00001', 'D00002');
INSERT INTO dish_isapplied_prom
VALUES
	('P00001', 'D00003');
INSERT INTO dish_isapplied_prom
VALUES
	('P00002', 'D00001');
INSERT INTO dish_isapplied_prom
VALUES
	('P00002', 'D00005');

INSERT INTO dish_isapplied_prom
VALUES
	('P00011', 'D00001');

INSERT INTO dish_isapplied_prom
VALUES
	('P00010', 'D00002');

-- ap dung ma khuyen mai dang diem
INSERT INTO prom_applies_bill
VALUES
	('P11111', 'B00005');