# Báo Cáo Chuyển Đổi Chức Năng

## Tổng quan
Đã chuyển đổi thành công 5 chức năng chính từ dự án **SWP-2-6-2025** sang **SU25_SWP391_SE18D07_4_**:

1. **Search Product (Tìm kiếm sản phẩm)**
2. **View Profile (Xem profile người dùng)**  
3. **View List Product (Xem danh sách sản phẩm)**
4. **Update Profile** (Cập nhật profile người dùng)
5. **Change Password** (Đổi mật khẩu)

## Cấu trúc Controllers

### 🔍 **Product Controllers** → `controller/product/`
- **SearchControl.java** 
  - Package: `controller.product`
  - URL: `/search`
  - Chức năng: Tìm kiếm sản phẩm theo tên với advanced filtering
  - Forward tới: `Category.jsp`
  - Features: Price filtering, sorting, category sidebar

- **ProductListControl.java**
  - Package: `controller.product` 
  - URL: `/productlist`
  - Chức năng: Xem danh sách sản phẩm với filter category
  - Forward tới: `Shop.jsp`

### 👤 **Account Controllers** → `controller/account/`
- **UserProfileController.java**
  - Package: `controller.account`
  - URL: `/userprofile`
  - Chức năng: Xem và cập nhật profile người dùng
  - Forward tới: `UserProfile.jsp`

- **UpdateProfileController.java**
  - Package: `controller.account`
  - URL: `/updateProfile`
  - Chức năng: Cập nhật thông tin profile
  - Forward tới: `UserProfile.jsp`

- **ChangePasswordServlet.java**
  - Package: `controller.account`
  - URL: `/changePassword`
  - Chức năng: Đổi mật khẩu

## Các Điều Chỉnh Thực Hiện

### Method Mapping Fixes
Do dự án đích có structure khác, đã thực hiện mapping các methods:

**ProductService:**
- `getAllProduct()` → `getAllProducts()`
- `getProductByCID()` → `getProductByCategoryID()`

**AccountService:**
- `updateAccount()` → `updateProfile()`
- `getAccountById()` → Sử dụng session account (method chưa implement)

### Entity Imports
- `entity.Product.Product`
- `entity.Product.ProductCategory` 
- `entity.Account.Account`

### Service Dependencies
- `service.ProductService`
- `service.CategoryService` 
- `service.AccountService`

## URL Patterns

### Tìm kiếm sản phẩm
```
GET/POST /search?txt=keyword
GET/POST /search?name=keyword
```

### Danh sách sản phẩm
```
GET /productlist
GET /productlist?cid=categoryId
GET /productlist?action=newest
```

### Profile người dùng
```
GET /userprofile                    // Xem profile
POST /userprofile?action=update     // Cập nhật profile
```

## JSP Attributes

### SearchControl & ProductListControl → Shop.jsp
- `listP` - Danh sách sản phẩm chính
- `listCC` - Danh sách categories
- `list5` - Top 5 sản phẩm mới nhất
- `searchKeyword` - Từ khóa tìm kiếm
- `selectedCategoryId` - Category được chọn

### UserProfileController → UserProfile.jsp
- Session `acc` - Account object
- `success` - Thông báo thành công
- `error` - Thông báo lỗi

## Tính Năng Đã Implement

### ✅ Search Product
- Tìm kiếm theo tên sản phẩm
- Hỗ trợ parameters: `txt`, `name`
- **Advanced filtering**: `price`, `orderby`
- **Price ranges**: 0-100k, 100k-500k, 500k-1M, 1M+
- **Sorting options**: Name A-Z/Z-A, Price low-to-high/high-to-low
- **Category sidebar**: Navigate by categories
- **Responsive design**: Professional category page layout
- Xử lý UTF-8 encoding
- Error handling with fallback to basic search

### ✅ View List Product  
- Hiển thị tất cả sản phẩm
- Filter theo category (`cid`)
- Hiển thị sản phẩm mới nhất (`action=newest`)
- Integration với CategoryService

### ✅ View Profile
- Hiển thị thông tin profile từ session
- Cập nhật profile (tên, email, SĐT, địa chỉ)
- Validation input
- Session management

### ✅ Update Profile
- Cập nhật thông tin profile
- Validate email và phone không trùng lặp
- Hỗ trợ đổi mật khẩu kèm theo (nếu có)
- Refresh session sau khi update thành công

### ✅ Change Password
- Đổi mật khẩu
- Validate mật khẩu hiện tại
- Validate mật khẩu mới (ít nhất 6 ký tự, khác mật khẩu cũ)
- Validate confirm password phải khớp

## Test URLs

### Development Testing
```bash
# Tìm kiếm sản phẩm
http://localhost:8080/CraftVillage/search?txt=ấm
http://localhost:8080/CraftVillage/search?txt=gốm&price=100000-500000&orderby=price_asc

# Danh sách sản phẩm  
http://localhost:8080/CraftVillage/productlist
http://localhost:8080/CraftVillage/productlist?cid=1

# Profile người dùng
http://localhost:8080/CraftVillage/userprofile
http://localhost:8080/CraftVillage/updateProfile
http://localhost:8080/CraftVillage/changePassword
```

## Compilation Fixes

### Fixed Methods
1. **SearchControl**: `getAllProduct()` → `getAllProducts()`
2. **ProductListControl**: `getProductByCID()` → `getProductByCategoryID()`
3. **UserProfileController**: `updateAccount()` → `updateProfile()`

### Workarounds Applied
- `getAccountById()` method chưa implement → sử dụng session account
- Đã map đúng methods với ProductService có sẵn

## Files Created/Modified

### Controllers Created
1. `src/java/controller/product/SearchControl.java`
2. `src/java/controller/product/ProductListControl.java` 
3. `src/java/controller/account/UserProfileController.java`
4. `src/java/controller/account/UpdateProfileController.java`
5. `src/java/controller/account/ChangePasswordServlet.java`

### Services & DAOs
- Sử dụng các service có sẵn: `ProductService`, `CategoryService`, `AccountService`
- Sử dụng `CategoryDAO` đã tạo trước đó

### JSP Files
- Sử dụng các JSP có sẵn: `Shop.jsp`, `UserProfile.jsp`

## Lưu Ý Kỹ Thuật

### Session Management
- UserProfileController yêu cầu user đã login (session `acc`)
- Redirect về `Login.jsp` nếu chưa authenticate

### Error Handling
- Try-catch blocks cho tất cả database operations
- Logging với `java.util.logging.Logger`
- Graceful error messages cho user

### UTF-8 Support
- `request.setCharacterEncoding("UTF-8")`
- `response.setContentType("text/html;charset=UTF-8")`

## Trạng Thái Hoàn Thành
- ✅ SearchControl: Hoàn thành và tested
- ✅ ProductListControl: Hoàn thành và tested  
- ✅ UserProfileController: Hoàn thành và tested
- ✅ UpdateProfileController: Hoàn thành và tested
- ✅ ChangePasswordServlet: Hoàn thành và tested
- ✅ Compilation errors: Đã fix
- ✅ Method mapping: Đã điều chỉnh phù hợp với target project

**Tất cả 5 chức năng đã được chuyển đổi thành công và sẵn sàng sử dụng!**
