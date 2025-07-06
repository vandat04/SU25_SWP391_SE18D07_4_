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

<<<<<<< HEAD
=======

>>>>>>> dat
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

