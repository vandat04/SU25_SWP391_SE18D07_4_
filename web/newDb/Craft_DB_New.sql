create database CraftDB
go

USE [CraftDB]
GO

-- Create Password Hashing Function
CREATE FUNCTION [dbo].[HashPassword](@password NVARCHAR(100))
RETURNS VARBINARY(64)
AS
BEGIN
    RETURN HASHBYTES('SHA2_512', @password);
END
GO


----------------------------------------------------Account-------------
--Table [Role] -- Tạo thêm bảng Role để mô tả về Role
CREATE TABLE [dbo].[Role](
	[roleID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[roleName] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[status] [int] NOT NULL DEFAULT(1),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE()
)
GO

--Table [Account] -- THEM UNIQUE CHO USERNAME, EMAIL
CREATE TABLE [dbo].[Account](
	[userID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userName] [nvarchar](100) UNIQUE NOT NULL,
	[password] [varbinary](64) NOT NULL,
	[email] [nvarchar](100) UNIQUE NOT NULL,
	[address] [nvarchar](200) NULL,
	[phoneNumber] [nvarchar](20) NULL,
	[status] [int] NOT NULL DEFAULT(1), --1: hoạt động, 0: bị chặn 
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	[roleID] [int] NOT NULL DEFAULT(1) CHECK (([roleID]=(3) OR [roleID]=(2) OR [roleID]=(1))), --User: 1 - Seller: 2, Admin: 3
	[isEmailVerified] [bit] NOT NULL DEFAULT(0), 
	[lastLoginDate] [datetime] NULL,
	[loginAttempts] [int] NOT NULL DEFAULT(0),
	[lockedUntil] [datetime] NULL, 
	[avatarUrl] [varchar](max) NULL,
	[preferredLanguage] [varchar](10) DEFAULT('vi'),
	fullName NVARCHAR(100),
	CONSTRAINT FK_Account_Role FOREIGN KEY (roleID) REFERENCES [dbo].[Role](roleID)
)
GO

--Table [AccountPoints]
CREATE TABLE [dbo].[AccountPoints](
	[pointsID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[points]  [int] NOT NULL default(0),
	CONSTRAINT [FK_AccountPoints_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO


--Table [EmailVerification] 
CREATE TABLE [dbo].[EmailVerification](
	[verificationID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[verificationToken] [varchar](100) NOT NULL UNIQUE,
	[expiryDate] [datetime] NOT NULL,
	[isUsed] [bit] NOT NULL DEFAULT(0),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_EmailVerification_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO

--Table [PasswordReset]
CREATE TABLE [dbo].[PasswordReset](
	[resetID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[resetToken] [varchar](100) NOT NULL UNIQUE,
	[expiryDate] [datetime] NOT NULL,
	[isUsed] [bit] NOT NULL DEFAULT(0),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[usedDate] [datetime] NULL,
	CONSTRAINT [FK_PasswordReset_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO

----------------------------------------------------Craft Village-------------
--Table [CraftType] 
CREATE TABLE [dbo].[CraftType](
	[typeID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[typeName] [nvarchar](100) NOT NULL UNIQUE,
	[description] [nvarchar](max) NULL,
	[status] [int] NOT NULL DEFAULT(1), --1: hoạt động, 0: ẩn
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL
)
GO

-- Table [CraftVillage]
CREATE TABLE [dbo].[CraftVillage](
	[villageID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL ,
	[typeID] [int],
	[villageName] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[address] [nvarchar](200) NOT NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[contactPhone] [nvarchar](20) NULL,
	[contactEmail] [nvarchar](100) NULL,
	[status] [int] NOT NULL, -- 0: đang ẩn, 1 đang hoạt động, 2: đang duyệt
	[clickCount] [int] NOT NULL DEFAULT(0),
	[lastClicked] [datetime] NULL DEFAULT GETDATE(),
	[mainImageUrl] [varchar](max) NULL,
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	[sellerId] [int] NULL,
	[openingHours] [nvarchar](200) NULL,
	[closingDays] [nvarchar](100) NULL,
	[averageRating] [decimal](3, 2) NULL,
	[totalReviews] [int] NOT NULL DEFAULT(0),
	[mapEmbedUrl] [varchar](max) NULL,
	[virtualTourUrl] [varchar](max) NULL,
	[history] [nvarchar](max) NULL,
	[specialFeatures] [nvarchar](max) NULL,
	[famousProducts] [nvarchar](max) NULL,
	[culturalEvents] [nvarchar](max) NULL,
	[craftProcess] [nvarchar](max) NULL,
	[videoDescriptionUrl] [nvarchar](500) NULL,
	[travelTips] [nvarchar](max) NULL,
	CONSTRAINT [FK_CraftVillage_Seller] FOREIGN KEY([sellerId]) REFERENCES [dbo].[Account] ([userID]),
	CONSTRAINT [FK_CraftVillage_CraftType] FOREIGN KEY([typeID]) REFERENCES [dbo].[CraftType] ([typeID])
)
GO

--Table [VillageImage]
CREATE TABLE [dbo].[VillageImage](
	[imageID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[villageID] [int] NOT NULL,
	[imageUrl] [varchar](max) NOT NULL,
	[isMain] [bit] NOT NULL DEFAULT(0),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_VillageImage_Village] FOREIGN KEY([villageID]) REFERENCES [dbo].[CraftVillage] ([villageID])
)
GO

--Table [FavoriteVillage]
CREATE TABLE [dbo].[FavoriteVillage](
	[favoriteID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[villageID] [int] NOT NULL,
	[addedDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_FavoriteVillage_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID]),
	CONSTRAINT [FK_FavoriteVillage_Village] FOREIGN KEY([villageID]) REFERENCES [dbo].[CraftVillage] ([villageID]),
	CONSTRAINT [UC_FavoriteVillage] UNIQUE NONCLUSTERED ([userID], [villageID]) --1 NGƯỜI THÍCH 1 LÀNG 1 LẦN
)
GO

--Table [VillageReview]
CREATE TABLE [dbo].[VillageReview](
	[reviewID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[villageID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[rating] [int] NOT NULL CHECK  (([rating]>=(1) AND [rating]<=(5))),
	[reviewText] [nvarchar](max) NULL,
	[reviewDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[response] [nvarchar](max) NULL,
	[responseDate] [datetime] NULL,
        [pictrureUrl] nvarchar(100),
	CONSTRAINT [FK_VillageReview_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID]),
	CONSTRAINT [FK_VillageReview_Village] FOREIGN KEY([villageID]) REFERENCES [dbo].[CraftVillage] ([villageID])
)
GO
----------------------------------------------------Ticket-------------
--Table [TicketType]
CREATE TABLE [dbo].[TicketType](
	[typeID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[typeName] [nvarchar](50) NOT NULL UNIQUE,
	[description] [nvarchar](200) NULL,
	[ageRange] [nvarchar](50) NULL,
	[status] [int] NOT NULL DEFAULT(1),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL
)
GO

--Table [VillageTicket]
CREATE TABLE [dbo].[VillageTicket](
	[ticketID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[villageID] [int] NOT NULL,
	[typeID] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[status] [int] NOT NULL  DEFAULT(1),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_VillageTicket_Village] FOREIGN KEY([villageID]) REFERENCES [dbo].[CraftVillage] ([villageID]),
	CONSTRAINT [FK_VillageTicket_TicketType] FOREIGN KEY([typeID]) REFERENCES [dbo].[TicketType] ([typeID]),
	CONSTRAINT [UC_FavoriteTicket] UNIQUE NONCLUSTERED ([villageID], [typeID])
)
GO

----------------------------------------------------Product-------------
--Table [ProductCategory]
CREATE TABLE [dbo].[ProductCategory](
	[categoryID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[categoryName] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[status] [int] NOT NULL DEFAULT(1),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL
)
GO

--Table [Product] 
CREATE TABLE [dbo].[Product]( --22 trường
	[pid] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[description] [nvarchar](max) NULL,
	[stock] [int] NOT NULL,
	[status] [int] NOT NULL DEFAULT(1), --1: hoạt dông, 2: ẩn, 3: đợi admin duyêt
	[villageID] [int] NOT NULL,
	[categoryID] [int] NOT NULL,
	[mainImageUrl] [varchar](max) NULL,
	[clickCount] [int] NOT NULL DEFAULT(0),
	[lastClicked] [datetime] NULL DEFAULT GETDATE(),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	[craftTypeID] [int] NULL, 
	[sku] [varchar](50) NULL,
	[weight] [decimal](10, 2) NULL,
	[dimensions] [nvarchar](100) NULL,
	[materials] [nvarchar](500) NULL,
	[careInstructions] [nvarchar](max) NULL,
	[warranty] [nvarchar](200) NULL,
	[isFeatured] [bit] NOT NULL DEFAULT(0), -- Bỏ
	[averageRating] [decimal](3, 2) NULL,
	[totalReviews] [int] NOT NULL DEFAULT(0),
	[modelFile] [nvarchar](max) NULL,
	CONSTRAINT [FK_Product_Village] FOREIGN KEY([villageID]) REFERENCES [dbo].[CraftVillage] ([villageID]),
	CONSTRAINT [FK_Product_Category] FOREIGN KEY([categoryID]) REFERENCES [dbo].[ProductCategory] ([categoryID])
)
GO

--Table [ProductImage]
CREATE TABLE [dbo].[ProductImage](
	[imageID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[productID] [int] NOT NULL,
	[imageUrl] [varchar](max) NOT NULL,
	[isMain] [bit] NOT NULL DEFAULT(0),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_ProductImage_Product] FOREIGN KEY([productID]) REFERENCES [dbo].[Product] ([pid])
)
GO

--Table [ProductReview]
CREATE TABLE [dbo].[ProductReview](
	[reviewID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[productID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[rating] [int] NOT NULL CHECK (([rating]>=(1) AND [rating]<=(5))),
	[reviewText] [nvarchar](max) NULL,
	[reviewDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[response] [nvarchar](max) NULL,
	[responseDate] [datetime] NULL,
        [pictrureUrl] nvarchar(100),
	CONSTRAINT [FK_ProductReview_Product] FOREIGN KEY([productID]) REFERENCES [dbo].[Product] ([pid]),
	CONSTRAINT [FK_ProductReview_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO
--Table [Wishlist]
CREATE TABLE [dbo].[Wishlist](
	[wishlistID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[productID] [int] NOT NULL,
	[addedDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_Wishlist_Product] FOREIGN KEY([productID]) REFERENCES [dbo].[Product] ([pid]),
	CONSTRAINT [FK_Wishlist_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID]),
	CONSTRAINT [UC_FavoriteProduct] UNIQUE NONCLUSTERED ([userID], [productID]) --1 User, 1 SP, Thêm 1 lần
)
GO

--Table [Cart]
CREATE TABLE [dbo].[Cart](
	[cartID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_Cart_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO

--Table [CartItem]
CREATE TABLE [dbo].[CartItem](
	[itemID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[cartID] [int] NOT NULL,
	[productID] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_CartItem_Cart] FOREIGN KEY([cartID]) REFERENCES [dbo].[Cart] ([cartID]),
	CONSTRAINT [FK_CartItem_Product] FOREIGN KEY([productID]) REFERENCES [dbo].[Product] ([pid])
)
GO

----------------------------------------------------Order-------------
--Table [Orders] -- 
CREATE TABLE [dbo].[Orders](
	[id] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[total_price] [decimal](10, 2) NOT NULL,
	[shippingAddress] [nvarchar](200) NOT NULL,
	[shippingPhone] [nvarchar](20) NOT NULL,
	[shippingName] [nvarchar](100) NOT NULL,
	[paymentMethod] [nvarchar](50) NOT NULL,
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[email] NVARCHAR(100),
	CONSTRAINT FK_Orders_Account FOREIGN KEY (userID) REFERENCES [dbo].[Account](userID)
)

CREATE TABLE [dbo].[SubOrders] (
    [subOrderId] INT PRIMARY KEY IDENTITY(1,1),
    [orderId] INT NOT NULL,
    [villageId] INT NOT NULL, -- seller/làng nghề
    [total_price] DECIMAL(10,2) NOT NULL,
    [points] INT NULL, -- nếu có hệ thống tích điểm
    [paymentMethod] NVARCHAR(50) NOT NULL,
    [paymentStatus] INT DEFAULT 0 NOT NULL, -- 0: Unpaid, 1: Paid
    [orderStatus] INT NULL, -- 0: New, 1: Accepted, 2: Preparing, 3: Shipping, 4: Completed, 5: Cancelled
    [note] NVARCHAR(MAX) NULL,
    [reviewStatus] int default(0),
    
    -- Huỷ đơn / Hoàn tiền
    [cancelReason] NVARCHAR(500),
    [cancelDate] DATETIME,
    [refundAmount] DECIMAL(10,2),
    [refundDate] DATETIME,
    [refundReason] NVARCHAR(500),

    -- GHN Shipping Info
    [shippingPartner] NVARCHAR(50), -- ví dụ: 'GHN'
    [shippingOrderCode] NVARCHAR(100), -- mã vận đơn GHN
    [shippingStatus] NVARCHAR(50) DEFAULT 'Not Created', -- Shipping, Delivered...
    [shippingFee] DECIMAL(10,2) DEFAULT 0,
    [estimatedDeliveryDate] DATE,
    [shippingCreatedAt] DATETIME,
    [shippingUpdatedAt] DATETIME,
    [labelUrl] NVARCHAR(255), -- in vận đơn
    [trackingUrl] NVARCHAR(255), -- link theo dõi đơn
    [shippingToken] NVARCHAR(255), -- để huỷ/truy vấn nếu GHN cần

    [createdDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [updatedDate] DATETIME,

    CONSTRAINT FK_SubOrders_Orders FOREIGN KEY ([orderId]) REFERENCES [dbo].[Orders](id)
);

--Table [OrderDetail]
CREATE TABLE [dbo].[OrderDetail](
	[id] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[subOrderId] [int] not null,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[subtotal] AS ([price] * [quantity]) PERSISTED,
	[villageID] int,
        [reviewStatus] int default(0),
	CONSTRAINT FK_OrderDetail_SubOrders FOREIGN KEY ([subOrderId]) REFERENCES [dbo].[SubOrders](subOrderId),
	CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (product_id) REFERENCES [dbo].[Product](pid)
)
GO


--Table [TicketOrderDetail]
CREATE TABLE [dbo].[TicketOrderDetail](
	[detailID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[orderID] [int] NOT NULL,
	[subOrderId] [int] not null,
	[ticketID] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[subtotal] AS ([price] * [quantity]) PERSISTED,
	[villageID] int,
        [reviewStatus] int default(0),
        [TicketCode] nvarchar(50),
        status int default(0),
        bookDate DATETIME,
	CONSTRAINT FK_TicketOrderDetail_SubOrders FOREIGN KEY ([subOrderId]) REFERENCES [dbo].[SubOrders](subOrderId),
	CONSTRAINT [FK_TicketOrderDetail_Ticket] FOREIGN KEY([ticketID]) REFERENCES [dbo].[VillageTicket] ([ticketID])
)
GO

----------------------------------------------------Support-------------
--Table [MessageThread]---Dư thì lma
CREATE TABLE [dbo].[MessageThread](
	[threadID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[sellerID] [int] NOT NULL,
	[messageName] [varchar](max) NULL,
	CONSTRAINT [FK_MessageThread_User1] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID]),
	CONSTRAINT [FK_MessageThread_User2] FOREIGN KEY([sellerID]) REFERENCES [dbo].[Account] ([userID])
)
GO

--Table [Message]---Dư thì lma
CREATE TABLE [dbo].[Message](
	[messageID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[threadID] [int] NOT NULL,
	[senderID] [int] NOT NULL,
	[messageContent] [nvarchar](max) NOT NULL,
	[attachmentUrl] [varchar](max) NULL,
	[sentDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[userRead] int default (0),
	CONSTRAINT [FK_Message_Thread] FOREIGN KEY([threadID]) REFERENCES [dbo].[MessageThread] ([threadID])
)
GO

----------------------------------------------------Notification-------------
--Table [NotificationType]
CREATE TABLE [dbo].[NotificationType](
	[typeID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[typeName] [nvarchar](50) UNIQUE NOT NULL
)
GO

--Table [Notification]
CREATE TABLE [dbo].[Notification](
	[notificationID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[typeID] [int] NOT NULL,
	[title] [nvarchar](200) NOT NULL,
	[content] [nvarchar](max) NOT NULL,
	[targetUrl] [varchar](500) NULL,
	[isRead] [bit] NOT NULL DEFAULT(0),
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[readDate] [datetime] NULL,
	CONSTRAINT [FK_Notification_Type] FOREIGN KEY([typeID]) REFERENCES [dbo].[NotificationType] ([typeID]),
	CONSTRAINT [FK_Notification_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO


--Table [SearchHistory] --- SearchType: nvarchar --> int  BOTCHAT
CREATE TABLE [dbo].[SearchHistory](
	[searchID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[userID] [int] NULL,
	[searchKeyword] [nvarchar](200) NOT NULL,
	[searchType] [nvarchar](50) NULL,
	[resultCount] [int] NULL,
	[ipAddress] [varchar](50) NULL,
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_SearchHistory_User] FOREIGN KEY([userID]) REFERENCES [dbo].[Account] ([userID])
)
GO

----------------------------------------------------Payment-------------
--Table [Payment]

CREATE TABLE [dbo].[Payment](
    [paymentID] INT PRIMARY KEY IDENTITY(1,1),
    [subOrderId] INT NOT NULL,                 -- Gắn với SubOrders
    [sellerID] INT NOT NULL,                   -- Ai nhận tiền
    [amount] DECIMAL(10, 2) NOT NULL,          -- Tổng tiền phải trả
    [paymentMethod] NVARCHAR(50) NOT NULL,     -- Ví dụ: PayOS, COD
    [paymentStatus] INT DEFAULT 0 NOT NULL,    -- 0: Chưa thanh toán / đã hoàn tiền, 1: Đã thanh toán
    [transactionID] NVARCHAR(100) NULL,        -- Mã giao dịch từ PayOS/GHN
    [paymentDate] DATETIME DEFAULT GETDATE(),  -- Ngày thanh toán
    [updatedDate] DATETIME NULL,               -- Cập nhật gần nhất

    CONSTRAINT FK_Payment_SubOrder FOREIGN KEY ([subOrderId]) REFERENCES [dbo].[SubOrders]([subOrderId]),
    CONSTRAINT FK_Payment_Account FOREIGN KEY ([sellerID]) REFERENCES [dbo].[Account]([userID])
);
GO

----------------------------------------------------Admin-Seller-------------
--Table [SalesReport]
CREATE TABLE [dbo].[SalesReport](
	[reportID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[sellerID] [int] NOT NULL,
	[reportMonth] [int] NOT NULL,
	[reportYear] [int] NOT NULL,
	[totalOrders] [int] NOT NULL DEFAULT(0),
	[totalRevenue] [decimal](15, 2) NOT NULL DEFAULT(0),
	[totalProducts] [int] NOT NULL  DEFAULT(0),
	[commission] [decimal](15, 2) NOT NULL  DEFAULT(0),
	[netRevenue] [decimal](15, 2) NOT NULL  DEFAULT(0),
	[generatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_SalesReport_Seller] FOREIGN KEY([sellerID]) REFERENCES [dbo].[Account]([userID])
)
GO

--Table [SellerVerification] --loại làng nggeef đăng kí. 
CREATE TABLE [dbo].[SellerVerification] (
    [verificationID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,   
    -- Khóa ngoại liên kết với User muốn nâng cấp-- Check thử account >18 tuổi
    [sellerID] INT NOT NULL,
    -- Thông tin cơ bản
    [businessType] NVARCHAR(100) NOT NULL,         -- Cá nhân / Hộ kinh doanh / Công ty TNHH / HTX / Làng nghề
    [businessVillageCategry] NVARCHAR(200) NOT NULL, -- Loại làng
    [businessVillageName] NVARCHAR(200) NOT NULL,         -- Tên cá nhân / tổ chức / làng nghề
    [businessVillageAddress] NVARCHAR(500) NOT NULL,      -- Địa chỉ kinh doanh
    [productProductCategory] NVARCHAR(200) NOT NULL,      -- Nhóm sản phẩm kinh doanh/ Thêm cột cho ProductCategory
    [profileVillagePictureUrl] VARCHAR(MAX) NULL,         -- Ảnh đại diện hoặc logo
    -- Thông tin liên hệ lấy từ bảng Account
    [contactPerson] NVARCHAR(200) NOT NULL,        -- Người đại diện 
    [contactPhone] NVARCHAR(20) NOT NULL,          -- Số điện thoại liên hệ - 
    [contactEmail] NVARCHAR(200) NOT NULL,         -- Email liên hệ
    -- Thông tin cá nhân (dùng khi businessType = Cá nhân)
    [idCardNumber] NVARCHAR(50) NULL,              -- Số CMND/CCCD
    [idCardFrontUrl] VARCHAR(MAX) NULL,            -- Link ảnh mặt trước CMND/CCCD
    [idCardBackUrl] VARCHAR(MAX) NULL,             -- Link ảnh mặt sau CMND/CCCD
    -- Thông tin doanh nghiệp (dùng khi businessType != Cá nhân)
    [businessLicense] NVARCHAR(100) NULL,          -- Số giấy phép kinh doanh
    [taxCode] NVARCHAR(50) NULL,                   -- Mã số thuế
    [documentUrl] VARCHAR(MAX) NULL,               -- Link ảnh/file giấy phép kinh doanh
    -- Ghi chú bổ sung
    [note] NVARCHAR(MAX) NULL,                     -- Ghi chú Seller gửi Admin
    -- Trạng thái duyệt
    [verificationStatus] INT NOT NULL DEFAULT 0,   -- 0: Đang xử lý, 1: Đã duyệt, 2: Từ chối
    [verifiedBy] INT NULL,                         -- Admin duyệt
    [verifiedDate] DATETIME NULL,                  -- Ngày duyệt
    [rejectReason] NVARCHAR(MAX) NULL,             -- Lý do từ chối
    -- Ngày tạo
    [createdDate] DATETIME NOT NULL DEFAULT GETDATE(),    
    -- Ràng buộc FK
    CONSTRAINT [FK_SellerVerification_Seller] FOREIGN KEY ([sellerID]) REFERENCES [dbo].[Account] ([userID])
);
GO

-- 2. TẠO BẢNG CÒN THIẾU
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CartTicket]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CartTicket](
        [itemID] [int] IDENTITY(1,1) NOT NULL,
        [cartID] [int] NOT NULL,
        [ticketID] [int] NOT NULL,
        [quantity] [int] NOT NULL,
        [ticketDate] [date] NOT NULL,
        [createdDate] [datetime] NOT NULL,
        [updatedDate] [datetime] NULL,
        PRIMARY KEY CLUSTERED ([itemID] ASC),
        CONSTRAINT [UC_CartTicket_Item] UNIQUE NONCLUSTERED ([cartID] ASC, [ticketID] ASC, [ticketDate] ASC)
    );
    ALTER TABLE [dbo].[CartTicket] ADD CONSTRAINT [FK_CartTicket_Cart] FOREIGN KEY([cartID]) REFERENCES [dbo].[Cart] ([cartID]);
    ALTER TABLE [dbo].[CartTicket] ADD CONSTRAINT [FK_CartTicket_VillageTicket] FOREIGN KEY([ticketID]) REFERENCES [dbo].[VillageTicket] ([ticketID]);
    ALTER TABLE [dbo].[CartTicket] ADD CHECK ([quantity] > 0);
    CREATE NONCLUSTERED INDEX [IX_CartTicket_CartID] ON [dbo].[CartTicket]([cartID] ASC);
    CREATE NONCLUSTERED INDEX [IX_CartTicket_TicketDate] ON [dbo].[CartTicket]([ticketDate] ASC);
END
Go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TicketAvailability]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[TicketAvailability](
        [availabilityID] [int] IDENTITY(1,1) NOT NULL,
        [ticketID] [int] NOT NULL,
        [availableDate] [date] NOT NULL,
        [totalSlots] [int] NOT NULL,
        [bookedSlots] [int] NOT NULL DEFAULT(0),
        [availableSlots] [int] NOT NULL, -- Cột này giống y Database 1
        [status] [bit] NOT NULL DEFAULT(1),
        [createdDate] [datetime] NOT NULL DEFAULT(GETDATE()),
        [updatedDate] [datetime] NULL,
        CONSTRAINT [PK_TicketAvailability] PRIMARY KEY CLUSTERED ([availabilityID] ASC),
        CONSTRAINT [UC_TicketAvailability_TicketDate] UNIQUE NONCLUSTERED ([ticketID] ASC, [availableDate] ASC)
    );
    ALTER TABLE [dbo].[TicketAvailability] ADD CONSTRAINT [FK_TicketAvailability_Ticket] FOREIGN KEY([ticketID]) REFERENCES [dbo].[VillageTicket] ([ticketID]);
END
Go

IF NOT EXISTS (
    SELECT * FROM sys.indexes WHERE name = 'IX_TicketAvailability_Date' AND object_id = OBJECT_ID('dbo.TicketAvailability')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_TicketAvailability_Date] ON [dbo].[TicketAvailability]([availableDate] ASC)
    WHERE ([status]=(1));
END
Go
-- 5. BỔ SUNG CONSTRAINT/CHECK CÒN THIẾU
-- TicketAvailability
ALTER TABLE [dbo].[TicketAvailability] WITH NOCHECK ADD CHECK ([bookedSlots] >= 0);
Go
ALTER TABLE [dbo].[TicketAvailability] WITH NOCHECK ADD CHECK ([totalSlots] > 0);
Go
ALTER TABLE [dbo].[TicketAvailability] WITH NOCHECK ADD CONSTRAINT [CK_TicketAvailability_BookedSlots] CHECK ([bookedSlots] <= [totalSlots]);
Go

---------------------------------------------------Virtual Tour 360° System-------------
--Table [Tours] - Quản lý các tour 360° của mỗi làng nghề
CREATE TABLE [dbo].[Tours](
	[tourID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[villageID] [int] NOT NULL,
	[tourName] [nvarchar](200) NOT NULL,
	[description] [nvarchar](max) NULL,
	[status] [int] NOT NULL DEFAULT(1), -- 1: active, 0: inactive
	[isDefault] [bit] NOT NULL DEFAULT(0), -- 1: tour mặc định của làng
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	[createdBy] [int] NULL, -- userID của người tạo
	CONSTRAINT [FK_Tours_CraftVillage] FOREIGN KEY([villageID]) REFERENCES [dbo].[CraftVillage]([villageID]),
	CONSTRAINT [FK_Tours_Account] FOREIGN KEY([createdBy]) REFERENCES [dbo].[Account]([userID])
)
GO

--Table [Panoramas] - Lưu các ảnh panorama của mỗi tour
CREATE TABLE [dbo].[Panoramas](
	[panoramaID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[tourID] [int] NOT NULL,
	[panoramaName] [nvarchar](200) NOT NULL,
	[imageUrl] [varchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[orderIndex] [int] NOT NULL DEFAULT(0), -- Thứ tự hiển thị trong tour
	[isStartPoint] [bit] NOT NULL DEFAULT(0), -- 1: điểm bắt đầu tour
	[status] [int] NOT NULL DEFAULT(1), -- 1: active, 0: inactive
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_Panoramas_Tours] FOREIGN KEY([tourID]) REFERENCES [dbo].[Tours]([tourID])
)
GO

--Table [NavigationPoints] - Điểm chuyển cảnh giữa các panorama (đã cập nhật)
CREATE TABLE [dbo].[NavigationPoints](
	[navigationID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[panoramaID] [int] NOT NULL, -- Panorama xuất phát
	[targetPanoramaID] [int] NOT NULL, -- Panorama đích
	[x] [float] NOT NULL, -- Tọa độ X trên panorama (0-1)
	[y] [float] NOT NULL, -- Tọa độ Y trên panorama (0-1)
	[yaw] [float] NULL, -- Góc yaw (nếu cần)
	[pitch] [float] NULL, -- Góc pitch (nếu cần)
	[description] [nvarchar](255) NULL,
	[navigationType] [nvarchar](50) NOT NULL DEFAULT('scene'), -- 'scene', 'info', 'product', 'shop'
	[targetUrl] [varchar](max) NULL, -- URL đích nếu navigationType = 'info' hoặc 'product'
	[iconClass] [nvarchar](100) NULL, -- CSS class cho icon
	[status] [int] NOT NULL DEFAULT(1), -- 1: active, 0: inactive
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_NavigationPoints_Panorama] FOREIGN KEY([panoramaID]) REFERENCES [dbo].[Panoramas]([panoramaID]),
	CONSTRAINT [FK_NavigationPoints_TargetPanorama] FOREIGN KEY([targetPanoramaID]) REFERENCES [dbo].[Panoramas]([panoramaID])
)
GO

--Table [TourHotspots] - Các điểm nóng (hotspot) thông tin trên panorama
CREATE TABLE [dbo].[TourHotspots](
	[hotspotID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[panoramaID] [int] NOT NULL,
	[x] [float] NOT NULL, -- Tọa độ X trên panorama (0-1)
	[y] [float] NOT NULL, -- Tọa độ Y trên panorama (0-1)
	[yaw] [float] NULL, -- Góc yaw
	[pitch] [float] NULL, -- Góc pitch
	[title] [nvarchar](200) NOT NULL,
	[description] [nvarchar](max) NULL,
	[hotspotType] [nvarchar](50) NOT NULL DEFAULT('info'), -- 'info', 'product', 'shop', 'video'
	[targetUrl] [varchar](max) NULL, -- URL đích hoặc nội dung
	[iconClass] [nvarchar](100) NULL, -- CSS class cho icon
	[productID] [int] NULL, -- Liên kết với sản phẩm nếu hotspotType = 'product'
	[status] [int] NOT NULL DEFAULT(1), -- 1: active, 0: inactive
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_TourHotspots_Panorama] FOREIGN KEY([panoramaID]) REFERENCES [dbo].[Panoramas]([panoramaID]),
	CONSTRAINT [FK_TourHotspots_Product] FOREIGN KEY([productID]) REFERENCES [dbo].[Product]([pid])
)
GO

--Table [TourSettings] - Cài đặt cho mỗi tour
CREATE TABLE [dbo].[TourSettings](
	[settingID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[tourID] [int] NOT NULL,
	[settingKey] [nvarchar](100) NOT NULL,
	[settingValue] [nvarchar](max) NULL,
	[settingType] [nvarchar](50) NOT NULL DEFAULT('string'), -- 'string', 'number', 'boolean', 'json'
	[description] [nvarchar](255) NULL,
	[createdDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[updatedDate] [datetime] NULL,
	CONSTRAINT [FK_TourSettings_Tours] FOREIGN KEY([tourID]) REFERENCES [dbo].[Tours]([tourID]),
	CONSTRAINT [UC_TourSettings_Key] UNIQUE NONCLUSTERED ([tourID], [settingKey])
)
GO

-- Tạo indexes để tối ưu hiệu suất
CREATE NONCLUSTERED INDEX [IX_Tours_VillageID] ON [dbo].[Tours]([villageID] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_Panoramas_TourID] ON [dbo].[Panoramas]([tourID] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_Panoramas_OrderIndex] ON [dbo].[Panoramas]([orderIndex] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_NavigationPoints_PanoramaID] ON [dbo].[NavigationPoints]([panoramaID] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_TourHotspots_PanoramaID] ON [dbo].[TourHotspots]([panoramaID] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_TourSettings_TourID] ON [dbo].[TourSettings]([tourID] ASC)
GO

-- Thêm constraints để đảm bảo tính toàn vẹn dữ liệu
ALTER TABLE [dbo].[Panoramas] WITH NOCHECK ADD CHECK ([orderIndex] >= 0)
GO

ALTER TABLE [dbo].[NavigationPoints] WITH NOCHECK ADD CHECK ([x] >= 0 AND [x] <= 1)
GO

ALTER TABLE [dbo].[NavigationPoints] WITH NOCHECK ADD CHECK ([y] >= 0 AND [y] <= 1)
GO

ALTER TABLE [dbo].[TourHotspots] WITH NOCHECK ADD CHECK ([x] >= 0 AND [x] <= 1)
GO

ALTER TABLE [dbo].[TourHotspots] WITH NOCHECK ADD CHECK ([y] >= 0 AND [y] <= 1)
GO

-- Cập nhật bảng CraftVillage để thêm foreign key tới tour mặc định
ALTER TABLE [dbo].[CraftVillage] ADD [defaultTourID] [int] NULL
GO

ALTER TABLE [dbo].[CraftVillage] ADD CONSTRAINT [FK_CraftVillage_DefaultTour] 
FOREIGN KEY([defaultTourID]) REFERENCES [dbo].[Tours]([tourID])
GO

-- Xóa bảng NavigationPoints cũ nếu tồn tại (để thay thế bằng bảng mới)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NavigationPoints]') AND type in (N'U'))
BEGIN
    -- Kiểm tra xem có dữ liệu trong bảng cũ không
    IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[NavigationPoints])
    BEGIN
        DROP TABLE [dbo].[NavigationPoints]
        PRINT 'Dropped old NavigationPoints table (was empty)'
    END
    ELSE
    BEGIN
        PRINT 'WARNING: Old NavigationPoints table contains data. Please migrate data before dropping.'
    END
END
GO

-- Tạo stored procedures cho quản lý tour 360°

-- Stored procedure tạo tour mới
CREATE PROCEDURE [dbo].[sp_CreateTour]
    @villageID INT,
    @tourName NVARCHAR(200),
    @description NVARCHAR(MAX) = NULL,
    @createdBy INT = NULL,
    @tourID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO [dbo].[Tours] ([villageID], [tourName], [description], [createdBy])
        VALUES (@villageID, @tourName, @description, @createdBy);
        
        SET @tourID = SCOPE_IDENTITY();
        
        -- Nếu đây là tour đầu tiên của làng, đặt làm tour mặc định
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Tours] WHERE [villageID] = @villageID AND [tourID] != @tourID)
        BEGIN
            UPDATE [dbo].[Tours] SET [isDefault] = 1 WHERE [tourID] = @tourID;
            UPDATE [dbo].[CraftVillage] SET [defaultTourID] = @tourID WHERE [villageID] = @villageID;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Stored procedure thêm panorama vào tour
CREATE PROCEDURE [dbo].[sp_AddPanorama]
    @tourID INT,
    @panoramaName NVARCHAR(200),
    @imageUrl VARCHAR(MAX),
    @description NVARCHAR(MAX) = NULL,
    @orderIndex INT = NULL,
    @isStartPoint BIT = 0,
    @panoramaID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Nếu không chỉ định orderIndex, tự động tính
        IF @orderIndex IS NULL
        BEGIN
            SELECT @orderIndex = ISNULL(MAX([orderIndex]), -1) + 1 
            FROM [dbo].[Panoramas] 
            WHERE [tourID] = @tourID;
        END
        
        -- Nếu đây là panorama đầu tiên, đặt làm điểm bắt đầu
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Panoramas] WHERE [tourID] = @tourID)
        BEGIN
            SET @isStartPoint = 1;
        END
        
        INSERT INTO [dbo].[Panoramas] ([tourID], [panoramaName], [imageUrl], [description], [orderIndex], [isStartPoint])
        VALUES (@tourID, @panoramaName, @imageUrl, @description, @orderIndex, @isStartPoint);
        
        SET @panoramaID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- Stored procedure lấy thông tin tour hoàn chỉnh
CREATE PROCEDURE [dbo].[sp_GetCompleteTourInfo]
    @tourID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy thông tin tour
    SELECT 
        t.[tourID],
        t.[tourName],
        t.[description],
        t.[status],
        t.[isDefault],
        t.[createdDate],
        t.[updatedDate],
        cv.[villageID],
        cv.[villageName],
        cv.[description] AS villageDescription,
        cv.[address],
        cv.[mainImageUrl] AS villageImageUrl
    FROM [dbo].[Tours] t
    INNER JOIN [dbo].[CraftVillage] cv ON t.[villageID] = cv.[villageID]
    WHERE t.[tourID] = @tourID;
    
    -- Lấy danh sách panorama
    SELECT 
        p.[panoramaID],
        p.[panoramaName],
        p.[imageUrl],
        p.[description],
        p.[orderIndex],
        p.[isStartPoint],
        p.[status]
    FROM [dbo].[Panoramas] p
    WHERE p.[tourID] = @tourID
    ORDER BY p.[orderIndex];
    
    -- Lấy danh sách navigation points
    SELECT 
        np.[navigationID],
        np.[panoramaID],
        np.[targetPanoramaID],
        np.[x],
        np.[y],
        np.[yaw],
        np.[pitch],
        np.[description],
        np.[navigationType],
        np.[targetUrl],
        np.[iconClass],
        p1.[panoramaName] AS sourcePanoramaName,
        p2.[panoramaName] AS targetPanoramaName
    FROM [dbo].[NavigationPoints] np
    INNER JOIN [dbo].[Panoramas] p1 ON np.[panoramaID] = p1.[panoramaID]
    INNER JOIN [dbo].[Panoramas] p2 ON np.[targetPanoramaID] = p2.[panoramaID]
    WHERE p1.[tourID] = @tourID
    ORDER BY p1.[orderIndex], np.[x];
    
    -- Lấy danh sách hotspots
    SELECT 
        th.[hotspotID],
        th.[panoramaID],
        th.[x],
        th.[y],
        th.[yaw],
        th.[pitch],
        th.[title],
        th.[description],
        th.[hotspotType],
        th.[targetUrl],
        th.[iconClass],
        th.[productID],
        p.[name] AS productName,
        p.[price] AS productPrice,
        p.[mainImageUrl] AS productImageUrl
    FROM [dbo].[TourHotspots] th
    LEFT JOIN [dbo].[Product] p ON th.[productID] = p.[pid]
    INNER JOIN [dbo].[Panoramas] pan ON th.[panoramaID] = pan.[panoramaID]
    WHERE pan.[tourID] = @tourID
    ORDER BY pan.[orderIndex], th.[x];
    
    -- Lấy cài đặt tour
    SELECT 
        ts.[settingKey],
        ts.[settingValue],
        ts.[settingType],
        ts.[description]
    FROM [dbo].[TourSettings] ts
    WHERE ts.[tourID] = @tourID;
END
GO

-- Stored procedure lấy tour mặc định của làng
CREATE PROCEDURE [dbo].[sp_GetDefaultTourByVillage]
    @villageID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @defaultTourID INT;
    
    -- Lấy tour mặc định từ bảng CraftVillage
    SELECT @defaultTourID = [defaultTourID] 
    FROM [dbo].[CraftVillage] 
    WHERE [villageID] = @villageID;
    
    -- Nếu không có tour mặc định, lấy tour đầu tiên
    IF @defaultTourID IS NULL
    BEGIN
        SELECT TOP 1 @defaultTourID = [tourID]
        FROM [dbo].[Tours]
        WHERE [villageID] = @villageID AND [status] = 1
        ORDER BY [isDefault] DESC, [createdDate] ASC;
    END
    
    -- Trả về thông tin tour
    IF @defaultTourID IS NOT NULL
    BEGIN
        EXEC [dbo].[sp_GetCompleteTourInfo] @defaultTourID;
    END
    ELSE
    BEGIN
        -- Trả về thông tin làng nếu không có tour
        SELECT 
            NULL AS tourID,
            NULL AS tourName,
            NULL AS description,
            NULL AS status,
            NULL AS isDefault,
            NULL AS createdDate,
            NULL AS updatedDate,
            cv.[villageID],
            cv.[villageName],
            cv.[description] AS villageDescription,
            cv.[address],
            cv.[mainImageUrl] AS villageImageUrl
        FROM [dbo].[CraftVillage] cv
        WHERE cv.[villageID] = @villageID;
    END
END
GO

-- Stored procedure thêm navigation point
CREATE PROCEDURE [dbo].[sp_AddNavigationPoint]
    @panoramaID INT,
    @targetPanoramaID INT,
    @x FLOAT,
    @y FLOAT,
    @yaw FLOAT = NULL,
    @pitch FLOAT = NULL,
    @description NVARCHAR(255) = NULL,
    @navigationType NVARCHAR(50) = 'scene',
    @targetUrl VARCHAR(MAX) = NULL,
    @iconClass NVARCHAR(100) = NULL,
    @navigationID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Kiểm tra panorama tồn tại và thuộc cùng tour
        DECLARE @tourID1 INT, @tourID2 INT;
        
        SELECT @tourID1 = [tourID] FROM [dbo].[Panoramas] WHERE [panoramaID] = @panoramaID;
        SELECT @tourID2 = [tourID] FROM [dbo].[Panoramas] WHERE [panoramaID] = @targetPanoramaID;
        
        IF @tourID1 IS NULL OR @tourID2 IS NULL
        BEGIN
            RAISERROR('Panorama không tồn tại', 16, 1);
            RETURN;
        END
        
        IF @tourID1 != @tourID2
        BEGIN
            RAISERROR('Panorama phải thuộc cùng một tour', 16, 1);
            RETURN;
        END
        
        INSERT INTO [dbo].[NavigationPoints] 
        ([panoramaID], [targetPanoramaID], [x], [y], [yaw], [pitch], [description], [navigationType], [targetUrl], [iconClass])
        VALUES (@panoramaID, @targetPanoramaID, @x, @y, @yaw, @pitch, @description, @navigationType, @targetUrl, @iconClass);
        
        SET @navigationID = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- Stored procedure thêm hotspot
CREATE PROCEDURE [dbo].[sp_AddTourHotspot]
    @panoramaID INT,
    @x FLOAT,
    @y FLOAT,
    @yaw FLOAT = NULL,
    @pitch FLOAT = NULL,
    @title NVARCHAR(200),
    @description NVARCHAR(MAX) = NULL,
    @hotspotType NVARCHAR(50) = 'info',
    @targetUrl VARCHAR(MAX) = NULL,
    @iconClass NVARCHAR(100) = NULL,
    @productID INT = NULL,
    @hotspotID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Kiểm tra panorama tồn tại
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Panoramas] WHERE [panoramaID] = @panoramaID)
        BEGIN
            RAISERROR('Panorama không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra product tồn tại nếu có
        IF @productID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[Product] WHERE [pid] = @productID)
        BEGIN
            RAISERROR('Sản phẩm không tồn tại', 16, 1);
            RETURN;
        END
        
        INSERT INTO [dbo].[TourHotspots] 
        ([panoramaID], [x], [y], [yaw], [pitch], [title], [description], [hotspotType], [targetUrl], [iconClass], [productID])
        VALUES (@panoramaID, @x, @y, @yaw, @pitch, @title, @description, @hotspotType, @targetUrl, @iconClass, @productID);
        
        SET @hotspotID = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
