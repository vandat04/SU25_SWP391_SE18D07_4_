-- Script để thêm dữ liệu test sản phẩm
USE [CraftDB]
GO

-- Thêm categories
INSERT INTO [dbo].[ProductCategory] (categoryName, description, status)
VALUES 
('Gốm sứ', N'Sản phẩm gốm sứ truyền thống', 1),
('Đồ gỗ', N'Sản phẩm từ gỗ thủ công', 1),
('Đá mỹ nghệ', N'Sản phẩm điêu khắc đá', 1);

-- Thêm craft villages
INSERT INTO [dbo].[CraftVillage] (villageName, description, address, status, typeID)
VALUES 
(N'Làng gốm Thanh Hà', N'Làng gốm truyền thống nổi tiếng', N'Thanh Hà, Hội An', 1, 1),
(N'Làng mộc Kim Bồng', N'Làng nghề mộc truyền thống', N'Kim Bồng, Hội An', 1, 2),
(N'Làng đá Non Nước', N'Làng điêu khắc đá nổi tiếng', N'Non Nước, Đà Nẵng', 1, 3);

-- Thêm sản phẩm
INSERT INTO [dbo].[Product] (name, price, description, stock, status, villageID, categoryID, mainImageUrl)
VALUES 
(N'Ấm trà gốm Thanh Hà', 250000, N'Ấm trà làm từ đất sét Thanh Hà, được nung ở nhiệt độ cao', 50, 1, 1, 1, 'assets/images/products/amtra-gom.jpg'),
(N'Chén trà gốm xanh', 45000, N'Chén trà men xanh ngọc bích đặc trưng Thanh Hà', 100, 1, 1, 1, 'assets/images/products/chen-tra.jpg'),
(N'Tượng Phật gỗ', 1200000, N'Tượng Phật được khắc từ gỗ hương thơm', 20, 1, 2, 2, 'assets/images/products/tuong-phat.jpg'),
(N'Hộp đựng trang sức gỗ', 350000, N'Hộp đựng trang sức làm từ gỗ sồi cao cấp', 30, 1, 2, 2, 'assets/images/products/hop-trang-suc.jpg'),
(N'Tượng rồng đá Non Nước', 2500000, N'Tượng rồng điêu khắc từ đá cẩm thạch', 15, 1, 3, 3, 'assets/images/products/tuong-rong.jpg'),
(N'Chậu cây cảnh đá', 450000, N'Chậu cây cảnh được chế tác từ đá tự nhiên', 25, 1, 3, 3, 'assets/images/products/chau-cay.jpg'),
(N'Bình hoa gốm men lam', 180000, N'Bình hoa gốm men lam cổ điển', 40, 1, 1, 1, 'assets/images/products/binh-hoa.jpg'),
(N'Khay trà gỗ cao cấp', 650000, N'Khay trà làm từ gỗ me tây nguyên khối', 15, 1, 2, 2, 'assets/images/products/khay-tra.jpg'),
(N'Tượng đôi cá chép đá', 1800000, N'Cặp tượng cá chép phong thủy bằng đá', 12, 1, 3, 3, 'assets/images/products/ca-chep.jpg');

GO 