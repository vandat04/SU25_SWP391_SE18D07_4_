Use CraftDB
Go

CREATE PROCEDURE [dbo].[UpdateProductFull]
    @pid INT,
    @name NVARCHAR(100),
    @price DECIMAL(10, 2),
    @description NVARCHAR(MAX) = NULL,
    @stock INT,
    @stockAdd INT = NULL,
    @status INT,
    @villageID INT,
    @categoryID INT,
    @mainImageUrl VARCHAR(MAX) = NULL,
    @craftTypeID INT = NULL,
    @sku VARCHAR(50) = NULL,
    @weight DECIMAL(10, 2) = NULL,
    @dimensions NVARCHAR(100) = NULL,
    @materials NVARCHAR(500) = NULL,
    @careInstructions NVARCHAR(MAX) = NULL,
    @warranty NVARCHAR(200) = NULL,
    @result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên sản phẩm (nhưng phải khác chính sản phẩm đang sửa)
        IF EXISTS (
            SELECT 1 
            FROM [dbo].[Product] 
            WHERE [name] = @name AND pid <> @pid
        )
        BEGIN
            SET @result = 2; -- Trùng tên sản phẩm khác
            RETURN;
        END

        -- Cập nhật sản phẩm
        UPDATE [dbo].[Product]
        SET 
            [name] = @name,
            [price] = @price,
            [description] = @description,
            [stock] = @stock + @stockAdd,
            [status] = @status,
            [villageID] = @villageID,
            [categoryID] = @categoryID,
            [mainImageUrl] = @mainImageUrl,
            [craftTypeID] = @craftTypeID,
            [sku] = @sku,
            [weight] = @weight,
            [dimensions] = @dimensions,
            [materials] = @materials,
            [careInstructions] = @careInstructions,
            [warranty] = @warranty,
            [updatedDate] = GETDATE()
        WHERE pid = @pid;

        -- Kiểm tra nếu không có dòng nào bị ảnh hưởng
        IF @@ROWCOUNT = 0
        BEGIN
            SET @result = 0; -- Không tìm thấy sản phẩm
            RETURN;
        END

        SET @result = 1; -- Thành công
    END TRY
    BEGIN CATCH
        SET @result = 0; -- Lỗi hệ thống
    END CATCH
END
GO

CREATE PROCEDURE CreateProductFull
    @Name NVARCHAR(255),
    @Price DECIMAL(18, 2),
    @Description NVARCHAR(MAX),
    @Stock INT,
    @Status INT,
    @VillageID INT,
    @CategoryID INT,
    @MainImageUrl NVARCHAR(500),
    @CraftTypeID INT,
    @Sku NVARCHAR(100),
    @Weight DECIMAL(10, 2),
    @Dimensions NVARCHAR(100),
    @Materials NVARCHAR(500),
    @CareInstructions NVARCHAR(1000),
    @Warranty NVARCHAR(255),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra trùng tên sản phẩm (không phân biệt hoa thường)
        IF EXISTS (
            SELECT 1 FROM Product WHERE LOWER(Name) = LOWER(@Name)
        )
        BEGIN
            SET @Result = -1; -- Tên đã tồn tại
            RETURN;
        END

        -- Thêm sản phẩm mới
        INSERT INTO Product (
            Name, Price,  Description, Stock,  Status,  VillageID, CategoryID,  MainImageUrl,
            CraftTypeID, SKU,  Weight, Dimensions, Materials, CareInstructions,  Warranty,  createdDate
        )
        VALUES (
            @Name, @Price,  @Description,  @Stock, @Status,  @VillageID,  @CategoryID, @MainImageUrl,
            @CraftTypeID, @Sku, @Weight, @Dimensions, @Materials, @CareInstructions, @Warranty, GETDATE()
        );

        SET @Result = 1; -- Thành công
    END TRY
    BEGIN CATCH
        SET @Result = 0; -- Lỗi SQL khác
    END CATCH
END;
GO

CREATE PROCEDURE DeleteProductByAdmin
    @pid INT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM OrderDetail
        WHERE product_id = @pid
    )
    BEGIN
        -- Sản phẩm có tồn tại trong OrderDetail → chỉ update status = 0
        UPDATE Product
        SET status = 0
        WHERE pid = @pid;
        SET @Result = 0;
    END
    ELSE
    BEGIN
        -- Sản phẩm chưa từng bán → xóa luôn
        DELETE FROM Product
        WHERE pid = @pid;
        SET @Result = 1;
    END
END
GO


-- Them SellerVerification
CREATE PROCEDURE sp_InsertSellerVerification_Individual
    @sellerID INT,
    @businessType NVARCHAR(100),
    @businessVillageCategry NVARCHAR(200),
    @businessVillageName NVARCHAR(200),
    @businessVillageAddress NVARCHAR(500),
    @productProductCategory NVARCHAR(200),
    @profileVillagePictureUrl VARCHAR(MAX),
    @contactPerson NVARCHAR(200),
    @contactPhone NVARCHAR(20),
    @contactEmail NVARCHAR(200),
    @idCardNumber NVARCHAR(50),
    @idCardFrontUrl VARCHAR(MAX),
    @idCardBackUrl VARCHAR(MAX),
    @note NVARCHAR(MAX)
AS
BEGIN
    -- Check for duplicate
    IF EXISTS (
        SELECT 1
        FROM SellerVerification
        WHERE businessVillageName = @businessVillageName
    )
    BEGIN
        RETURN 0; -- Duplicate found
    END

    -- Insert if no duplicate
    INSERT INTO SellerVerification
    (
        sellerID,
        businessType,
        businessVillageCategry,
        businessVillageName,
        businessVillageAddress,
        productProductCategory,
        profileVillagePictureUrl,
        contactPerson,
        contactPhone,
        contactEmail,
        idCardNumber,
        idCardFrontUrl,
        idCardBackUrl,
        note
    )
    VALUES
    (
        @sellerID,
        @businessType,
        @businessVillageCategry,
        @businessVillageName,
        @businessVillageAddress,
        @productProductCategory,
        @profileVillagePictureUrl,
        @contactPerson,
        @contactPhone,
        @contactEmail,
        @idCardNumber,
        @idCardFrontUrl,
        @idCardBackUrl,
        @note
    )

    RETURN 1; -- Success
END
GO
CREATE PROCEDURE sp_InsertSellerVerification_CraftVillage
    @sellerID INT,
    @businessType NVARCHAR(100),
    @businessVillageCategry NVARCHAR(200),
    @businessVillageName NVARCHAR(200),
    @businessVillageAddress NVARCHAR(500),
    @productProductCategory NVARCHAR(200),
    @profileVillagePictureUrl VARCHAR(MAX),
    @contactPerson NVARCHAR(200),
    @contactPhone NVARCHAR(20),
    @contactEmail NVARCHAR(200),
    @businessLicense NVARCHAR(100),
    @taxCode NVARCHAR(50),
    @documentUrl VARCHAR(MAX),
    @note NVARCHAR(MAX)
AS
BEGIN
    -- Check for duplicate
    IF EXISTS (
        SELECT 1
        FROM SellerVerification
        WHERE businessVillageName = @businessVillageName
    )
    BEGIN
        RETURN 0; -- Duplicate found
    END

    -- Insert if no duplicate
    INSERT INTO SellerVerification
    (
        sellerID,
        businessType,
        businessVillageCategry,
        businessVillageName,
        businessVillageAddress,
        productProductCategory,
        profileVillagePictureUrl,
        contactPerson,
        contactPhone,
        contactEmail,
        businessLicense,
        taxCode,
        documentUrl,
        note
    )
    VALUES
    (
        @sellerID,
        @businessType,
        @businessVillageCategry,
        @businessVillageName,
        @businessVillageAddress,
        @productProductCategory,
        @profileVillagePictureUrl,
        @contactPerson,
        @contactPhone,
        @contactEmail,
        @businessLicense,
        @taxCode,
        @documentUrl,
        @note
    )

    RETURN 1; -- Success
END
GO

--ApprovedUpgradeAccount
CREATE PROCEDURE sp_ApprovedUpgradeAccount
(
    @verificationID INT,
    @sellerID INT,
    @businessVillageCategry NVARCHAR(200),
    @businessVillageName NVARCHAR(200),
    @businessVillageAddress NVARCHAR(500),
    @productProductCategory NVARCHAR(200),
    @profileVillagePictureUrl VARCHAR(MAX),
    @contactPerson NVARCHAR(200),
    @contactPhone NVARCHAR(20),
    @contactEmail NVARCHAR(200),
    @verificationStatus INT,
    @verifiedBy INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @typeID INT;
        DECLARE @villageID INT;
        DECLARE @categoryID INT;

        -- 1. Tìm hoặc thêm mới CraftType
        SELECT TOP 1 @typeID = typeID
        FROM dbo.CraftType
        WHERE LOWER(typeName) = LOWER(@businessVillageCategry);

        IF @typeID IS NULL
        BEGIN
            INSERT INTO dbo.CraftType (typeName)
            VALUES (@businessVillageCategry);

            SET @typeID = SCOPE_IDENTITY();
        END

        -- *** BỔ SUNG: kiểm tra trùng tên CraftVillage ***
        IF EXISTS (
            SELECT 1
            FROM dbo.CraftVillage
            WHERE LOWER(villageName) = LOWER(@businessVillageName)
        )
        BEGIN
            -- Nếu tên làng nghề đã tồn tại, rollback và return lỗi
            ROLLBACK TRANSACTION;
            RETURN -2; -- mã lỗi trùng tên làng nghề
        END

        -- 2. Thêm mới CraftVillage
        INSERT INTO dbo.CraftVillage
        (
            typeID,
            villageName,
            address,
            contactPhone,
            contactEmail,
            status,
            mainImageUrl,
            sellerId
        )
        VALUES
        (
            @typeID,
            @businessVillageName,
            @businessVillageAddress,
            @contactPhone,
            @contactEmail,
            1, -- status: 1 = hoạt động
            @profileVillagePictureUrl,
            @sellerID
        );

        SET @villageID = SCOPE_IDENTITY();

        -- 3. Tìm hoặc thêm mới ProductCategory
        SELECT TOP 1 @categoryID = categoryID
        FROM dbo.ProductCategory
        WHERE LOWER(categoryName) = LOWER(@productProductCategory);

        IF @categoryID IS NULL
        BEGIN
            INSERT INTO dbo.ProductCategory (categoryName)
            VALUES (@productProductCategory);

            SET @categoryID = SCOPE_IDENTITY();
        END

        -- 4. Cập nhật trạng thái approved
        UPDATE dbo.SellerVerification
        SET 
            verificationStatus = @verificationStatus,
            verifiedBy = @verifiedBy,
            verifiedDate = GETDATE()
        WHERE
            verificationID = @verificationID;

        UPDATE dbo.Account
        SET 
            roleID = 2
        WHERE
            userID = @sellerID;

        COMMIT TRANSACTION;

        RETURN 1;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RETURN -1; -- mã lỗi tổng quát
    END CATCH
END
GO

CREATE PROCEDURE sp_RejectedUpgradeAccount
(
    @verificationID INT,
    @verificationStatus INT,
    @verifiedBy INT,
    @rejectReason NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.SellerVerification
    SET 
        verificationStatus = @verificationStatus,
        verifiedBy = @verifiedBy,
        verifiedDate = GETDATE(),
        rejectReason = @rejectReason
    WHERE
        verificationID = @verificationID;
    -- Kiểm tra có cập nhật được bản ghi nào không
    IF @@ROWCOUNT > 0
        RETURN 1;      -- thành công
    ELSE
        RETURN 0;      -- không thành công
END
GO
--Add New Ticket
CREATE OR ALTER PROCEDURE AddTicketByAdmin
(
    @villageID INT,
    @typeID INT,
    @price DECIMAL(10,2),
    @status INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if ticket already exists
    IF EXISTS (
        SELECT 1 
        FROM VillageTicket 
        WHERE villageID = @villageID 
          AND typeID = @typeID
    )
    BEGIN
        -- Return 0 → fail because ticket exists
        RETURN 0;
    END

    -- Insert new Ticket
    INSERT INTO VillageTicket (villageID, typeID, price, status, createdDate)
    VALUES (@villageID, @typeID, @price, @status, GETDATE());

    -- Return 1 → success
    RETURN 1;
END
GO

--Update Ticket
CREATE PROCEDURE UpdateTicketByAdmin
(
    @ticketID INT,
    @price DECIMAL(10, 2),
    @status INT
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE VillageTicket
    SET
        price = @price,
        status = @status,
        updatedDate = GETDATE()
    WHERE ticketID = @ticketID;
    RETURN 1;
END
GO

--Delete Ticket
CREATE PROCEDURE DeleteTicketByAdmin
(
    @ticketID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE VillageTicket
    SET
        status = 0,
        updatedDate = GETDATE()
    WHERE ticketID = @ticketID;
    RETURN 1;
END
GO

CREATE PROCEDURE sp_ResponseProductReviewByAdmin
    @reviewID INT,
    @response NVARCHAR(MAX),
    @result INT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ProductReview WHERE reviewID = @reviewID)
    BEGIN
        UPDATE ProductReview
        SET response = @response,
            responseDate = GETDATE()
        WHERE reviewID = @reviewID;

        SET @result = 1; -- Thành công
    END
    ELSE
    BEGIN
        SET @result = 0; -- Không tồn tại review
    END
END
Go

CREATE PROCEDURE sp_DeleteProductReviewByAdmin
    @reviewID INT,
    @result INT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ProductReview WHERE reviewID = @reviewID)
    BEGIN
        DELETE FROM ProductReview WHERE reviewID = @reviewID;
        SET @result = 1; -- Thành công
    END
    ELSE
    BEGIN
        SET @result = 0; -- Không tìm thấy review để xóa
    END
END
go

CREATE PROCEDURE sp_ResponseVillageReviewByAdmin
    @reviewID INT,
    @response NVARCHAR(MAX),
    @result INT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM VillageReview WHERE reviewID = @reviewID)
    BEGIN
        UPDATE VillageReview
        SET response = @response,
            responseDate = GETDATE()
        WHERE reviewID = @reviewID;

        SET @result = 1; -- Thành công
    END
    ELSE
    BEGIN
        SET @result = 0; -- Không tồn tại review
    END
END
go

CREATE PROCEDURE sp_DeleteVillageReviewByAdmin
    @reviewID INT,
    @result INT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM VillageReview WHERE reviewID = @reviewID)
    BEGIN
        DELETE FROM VillageReview WHERE reviewID = @reviewID;
        SET @result = 1; -- Thành công
    END
    ELSE
    BEGIN
        SET @result = 0; -- Không tìm thấy review để xóa
    END
END
go

CREATE PROCEDURE UpdateVillageFullByAdmin
    @villageID int,
    @villageName nvarchar(255),
    @typeID int,
    @description nvarchar(max),
    @address nvarchar(max),
    @latitude float,
    @longitude float,
    @contactPhone nvarchar(100),
    @contactEmail nvarchar(200),
    @status int,
    @sellerId int,
    @openingHours nvarchar(255),
    @closingDays nvarchar(255),
    @mapEmbedUrl nvarchar(max),
    @virtualTourUrl nvarchar(max),
    @history nvarchar(max),
    @specialFeatures nvarchar(max),
    @famousProducts nvarchar(max),
    @culturalEvents nvarchar(max),
    @craftProcess nvarchar(max),
    @videoDescriptionUrl nvarchar(500),
    @travelTips nvarchar(max),
    @mainImageUrl nvarchar(500),
    @result int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra tên không trùng (không phân biệt hoa thường, không dấu)
    IF EXISTS (
        SELECT 1
        FROM CraftVillage
        WHERE
            villageID <> @villageID
            AND villageName COLLATE Latin1_General_CI_AI
                = @villageName COLLATE Latin1_General_CI_AI
    )
    BEGIN
        -- Trùng tên với village khác → không update
        SET @result = 0;
        RETURN;
    END

    -- Thực hiện UPDATE
    UPDATE CraftVillage
    SET
        villageName = @villageName,
        typeID = @typeID,
        description = @description,
        address = @address,
        latitude = @latitude,
        longitude = @longitude,
        contactPhone = @contactPhone,
        contactEmail = @contactEmail,
        status = @status,
        sellerId = @sellerId,
        openingHours = @openingHours,
        closingDays = @closingDays,
        mapEmbedUrl = @mapEmbedUrl,
        virtualTourUrl = @virtualTourUrl,
        history = @history,
        specialFeatures = @specialFeatures,
        famousProducts = @famousProducts,
        culturalEvents = @culturalEvents,
        craftProcess = @craftProcess,
        videoDescriptionUrl = @videoDescriptionUrl,
        travelTips = @travelTips,
        mainImageUrl = @mainImageUrl,
        updatedDate = GETDATE()
    WHERE villageID = @villageID;

    SET @result = 1;
END;
go

CREATE PROCEDURE DeleteVillageByAdmin
    @villageID INT,
    @result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @existsInProduct BIT = 0;
    DECLARE @existsInTicket BIT = 0;

    -- Kiểm tra xem villageID có tồn tại trong Product
    IF EXISTS (
        SELECT 1
        FROM Product
        WHERE villageID = @villageID
    )
    BEGIN
        SET @existsInProduct = 1;
    END

    -- Kiểm tra xem villageID có tồn tại trong VillageTicket
    IF EXISTS (
        SELECT 1
        FROM VillageTicket
        WHERE villageID = @villageID
    )
    BEGIN
        SET @existsInTicket = 1;
    END

    -- Nếu có xuất hiện ở Product hoặc VillageTicket
    IF @existsInProduct = 1 OR @existsInTicket = 1
    BEGIN
        -- Update status = 0 trong Product
        UPDATE Product
        SET status = 0
        WHERE villageID = @villageID;

        -- Update status = 0 trong VillageTicket
        UPDATE VillageTicket
        SET status = 0
        WHERE villageID = @villageID;

		UPDATE CraftVillage
        SET status = 0
        WHERE villageID = @villageID;

        -- Không xóa CraftVillage
        SET @result = 2; -- 2 = Chỉ update status, không xóa
    END
    ELSE
    BEGIN
        -- Không tồn tại ở các bảng → XÓA hẳn CraftVillage
        DELETE FROM CraftVillage
        WHERE villageID = @villageID;

        SET @result = 1; -- 1 = Xóa thành công
    END
END;
go