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