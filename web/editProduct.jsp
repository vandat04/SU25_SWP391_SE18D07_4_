<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Tác Phẩm - ${product.name}</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        :root {
            --background-color: #fdfaf6;
            --sidebar-bg: #ffffff;
            --primary-text: #3d3d3d;
            --secondary-text: #888;
            --accent-color: #8c6d46;
            --accent-hover: #7a5c35;
            --border-color: #e0d9cf;
            --shadow-color: rgba(0, 0, 0, 0.05);
            --font-heading: 'Playfair Display', serif;
            --font-body: 'Montserrat', sans-serif;
            --error-bg: #fdeaea;
            --error-border: #f8c9c9;
            --error-text: #a82a2a;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: var(--font-body);
            background-color: var(--background-color);
            color: var(--primary-text);
            display: flex;
            min-height: 100vh;
        }

        /* --- Sidebar --- */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; }
        .sidebar-logo { padding: 1.5rem 2rem; text-align: center; border-bottom: 1px solid var(--border-color); }
        .sidebar-logo img { max-width: 80%; height: auto; }
        .sidebar-profile { text-align: center; padding: 2rem 1rem; }
        .sidebar-profile .avatar { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid var(--accent-color); margin-bottom: 1rem; }
        .sidebar-profile h3 { font-family: var(--font-heading); font-size: 1.2rem; margin-bottom: 0.25rem; }
        .sidebar-profile p { font-size: 0.9rem; color: #999; }
        .sidebar-nav { list-style-type: none; flex-grow: 1; margin-top: 1rem; }
        .sidebar-nav a { display: flex; align-items: center; padding: 1rem 2rem; color: var(--primary-text); text-decoration: none; font-weight: 500; transition: background-color 0.2s, color 0.2s; border-left: 4px solid transparent; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background-color: var(--background-color); color: var(--accent-color); border-left-color: var(--accent-color); }
        .sidebar-nav a i { width: 25px; margin-right: 1rem; font-size: 1.1rem; text-align: center; }
        .sidebar-logout { padding: 1rem 0; border-top: 1px solid var(--border-color); }
        .sidebar-logout a { text-decoration: none; color: var(--primary-text); }
        
        /* --- Main Content --- */
        .main-content { flex-grow: 1; padding: 2rem 3rem; overflow-y: auto; }
        .main-header { margin-bottom: 2rem; }
        .main-header h1 { font-family: var(--font-heading); font-size: 2.5rem; font-weight: 700; }
        .main-header p { color: var(--secondary-text); font-size: 1rem; }
        .panel { background-color: #fff; padding: 2.5rem; border-radius: 10px; border: 1px solid var(--border-color); box-shadow: 0 4px 15px var(--shadow-color); }

        /* --- CSS CHO FORM --- */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem 2rem;
        }
        .form-group {
            margin-bottom: 0;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.75rem;
            font-weight: 500;
            font-size: 0.9rem;
            color: var(--primary-text);
        }
        .form-control {
            width: 100%;
            padding: 0.85rem 1rem;
            font-size: 1rem;
            font-family: var(--font-body);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background-color: #fff;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(140, 109, 70, 0.15);
        }
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        .form-check {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .form-check-input {
            width: 1.25em;
            height: 1.25em;
        }
        .form-actions {
            margin-top: 2.5rem;
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            grid-column: 1 / -1;
        }
        .action-button {
            background-color: var(--accent-color);
            color: #fff;
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 8px;
            font-family: var(--font-body);
            font-weight: 700;
            font-size: 1rem;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }
        .action-button:hover {
            background-color: var(--accent-hover);
            transform: translateY(-2px);
        }
        .action-button.secondary {
            background-color: #f0f0f0;
            color: var(--primary-text);
        }
        .action-button.secondary:hover {
            background-color: #e0e0e0;
        }
        .alert-error {
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            border-radius: 8px;
            border: 1px solid var(--error-border);
            background-color: var(--error-bg);
            color: var(--error-text);
            font-weight: 500;
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <!-- Phần sidebar giữ nguyên như trang manageProduct.jsp -->
        <div class="sidebar-logo"><a href="home"><img src="hinhanh/Logo/logocraft.png" alt="Craft Village Logo"></a></div>
        <div class="sidebar-profile"><img src="${not empty sessionScope.acc.avatarUrl ? sessionScope.acc.avatarUrl : 'https://i.pravatar.cc/150?u='}${sessionScope.acc.userID}" alt="Avatar nghệ nhân" class="avatar"><h3>${sessionScope.acc.userName}</h3><p>Nghệ nhân</p></div>
        <ul class="sidebar-nav">
              <li><a href="seller"><i class="fas fa-tachometer-alt"></i> Bảng điều khiển</a></li>
              <li><a href="manageProduct" class="active"><i class="fas fa-palette"></i> Xưởng chế tác</a></li>
              <li><a href="#"><i class="fas fa-book"></i> Sổ đặt hàng</a></li>
              <li><a href="#"><i class="fas fa-chart-pie"></i> Thống kê</a></li>
              <li><a href="userprofile"><i class="fas fa-user-circle"></i> Hồ sơ nghệ nhân</a></li>
        </ul>
        <div class="sidebar-logout"><a href="logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Đăng xuất</a></div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Chỉnh Sửa Tác Phẩm</h1>
            <p>Cập nhật thông tin chi tiết cho tác phẩm: <strong>${product.name}</strong></p>
        </header>

        <section class="panel">
            <%-- Hiển thị thông báo lỗi nếu có --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>
            
            <%-- Form sẽ gửi dữ liệu đến servlet 'editProduct' bằng phương thức POST --%>
            <form action="editProduct" method="post">
                <%-- Trường ẩn để gửi đi ID của sản phẩm đang được sửa --%>
                <input type="hidden" name="pid" value="${product.pid}">

                <div class="form-grid">
                    
                    <div class="form-group full-width">
                        <label for="name">Tên tác phẩm</label>
                        <input id="name" type="text" name="name" class="form-control" required value="${product.name}">
                    </div>

                    <div class="form-group">
                        <label for="sku">Mã sản phẩm (SKU)</label>
                        <input id="sku" type="text" name="sku" class="form-control" value="${product.sku}">
                    </div>
                    
                    <div class="form-group">
                        <label for="categoryId">Loại sản phẩm</label>
                        <select id="categoryId" name="categoryId" class="form-control">
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.categoryID}" ${product.categoryID == cat.categoryID ? 'selected' : ''}>${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="price">Giá (VNĐ)</label>
                        <input id="price" type="number" step="1000" name="price" class="form-control" required value="${product.price}">
                    </div>

                    <div class="form-group">
                        <label for="stock">Số lượng tồn kho</label>
                        <input id="stock" type="number" name="stock" class="form-control" required value="${product.stock}">
                    </div>
                    
                    <div class="form-group">
                        <label for="weight">Trọng lượng (gram)</label>
                        <input id="weight" type="number" step="1" name="weight" class="form-control" value="${product.weight}">
                    </div>

                    <div class="form-group">
                        <label for="dimensions">Kích thước (D x R x C)</label>
                        <input id="dimensions" type="text" name="dimensions" class="form-control" value="${product.dimensions}">
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="description">Mô tả chi tiết</label>
                        <textarea id="description" name="description" class="form-control" rows="6">${product.description}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="materials">Chất liệu</label>
                        <input id="materials" type="text" name="materials" class="form-control" value="${product.materials}">
                    </div>

                    <div class="form-group full-width">
                        <label for="careInstructions">Hướng dẫn bảo quản</label>
                        <textarea id="careInstructions" name="careInstructions" class="form-control" rows="4">${product.careInstructions}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="warranty">Thông tin bảo hành</label>
                        <input id="warranty" type="text" name="warranty" class="form-control" value="${product.warranty}">
                    </div>

                    <div class="form-group">
                        <label for="imageUrl">URL Hình ảnh chính</label>
                        <input id="imageUrl" type="text" name="imageUrl" class="form-control" value="${product.mainImageUrl}">
                    </div>
                    
                    <div class="form-group">
                        <div class="form-check" style="padding-top: 1.5rem;">
                            <input id="status" class="form-check-input" type="checkbox" name="status" value="1" ${product.status == 1 ? 'checked' : ''}>
                            <label for="status">Hiển thị tác phẩm này để bán</label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="form-check" style="padding-top: 1.5rem;">
                            <input id="isFeatured" class="form-check-input" type="checkbox" name="isFeatured" value="true" ${product.isFeatured ? 'checked' : ''}>
                            <label for="isFeatured">Đặt làm sản phẩm nổi bật</label>
                        </div>
                    </div>
                    
                    <input type="hidden" name="craftTypeID" value="${product.craftTypeID != null ? product.craftTypeID : '1'}"> 
                    
                    <div class="form-actions">
                         <a href="manageProduct" class="action-button secondary">Hủy</a>
                        <button type="submit" class="action-button">
                            <i class="fas fa-save"></i> Cập Nhật Tác Phẩm
                        </button>
                    </div>
                </div>
            </form>
        </section>
    </main>

</body>
</html>
