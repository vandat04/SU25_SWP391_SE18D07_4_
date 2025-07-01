<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xưởng Chế Tác - ${sessionScope.acc.userName}</title>
    
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
            --success-bg: #e9f7ef;
            --success-border: #b8e9d1;
            --success-text: #1e6641;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-body); background-color: var(--background-color); color: var(--primary-text); display: flex; min-height: 100vh; }
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
        .main-content { flex-grow: 1; padding: 2rem 3rem; overflow-y: auto; }
        .main-header { margin-bottom: 2rem; }
        .main-header h1 { font-family: var(--font-heading); font-size: 2.5rem; font-weight: 700; }
        .main-header p { color: var(--secondary-text); font-size: 1rem; }
        .panel { background-color: #fff; padding: 2rem; border-radius: 10px; border: 1px solid var(--border-color); box-shadow: 0 4px 15px var(--shadow-color); }
        .panel-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem; }
        .panel-title { font-family: var(--font-heading); font-size: 1.5rem; }
        .primary-action-btn { background: var(--accent-color); color: #fff; text-decoration: none; padding: 0.7rem 1.2rem; border-radius: 8px; font-weight: 500; transition: background-color 0.3s; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 0.5rem; }
        .primary-action-btn:hover { background: var(--accent-hover); }
        .product-table { width: 100%; border-collapse: collapse; margin-top: 1.5rem; }
        .product-table th, .product-table td { padding: 12px 15px; border-bottom: 1px solid var(--border-color); text-align: left; vertical-align: middle; }
        .product-table thead th { font-weight: 500; color: var(--secondary-text); text-transform: uppercase; font-size: 0.85rem; }
        .product-table tbody tr:hover { background-color: var(--background-color); }
        .product-table img { width: 70px; height: 70px; object-fit: cover; border-radius: 8px; }
        .action-buttons button, .action-buttons a { background: none; border: none; cursor: pointer; margin: 0 8px; text-decoration: none; color: var(--secondary-text); font-size: 1.1rem; transition: color 0.2s; }
        .action-buttons button:hover, .action-buttons a:hover { color: var(--accent-color); }
        .alert { padding: 1rem 1.5rem; margin-bottom: 2rem; border-radius: 8px; border: 1px solid transparent; font-weight: 500; }
        .alert-error { background-color: var(--error-bg); border-color: var(--error-border); color: var(--error-text); }
        .alert-success { background-color: var(--success-bg); border-color: var(--success-border); color: var(--success-text); }
    </style>
</head>
<body>
    <aside class="sidebar">
        <!-- Nội dung sidebar của bạn -->
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Xưởng Chế Tác</h1>
            <p>Nơi bạn quản lý, thêm, sửa, xóa các tác phẩm của mình.</p>
        </header>

        <section class="panel">
            <div class="panel-header">
                <h2 class="panel-title">Danh sách tác phẩm</h2>
                <a href="createProduct" class="primary-action-btn">
                    <i class="fas fa-plus"></i> Thêm Tác Phẩm Mới
                </a>
            </div>
            
            <!-- === BẮT ĐẦU SỬA: Thêm khu vực hiển thị thông báo === -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>
            <!-- === KẾT THÚC SỬA === -->
            
            <table class="product-table">
                <thead>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên Tác phẩm</th>
                        <th>Giá</th>
                        <th>Tồn kho</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${productList}">
                        <tr>
                            <td><img src="${p.mainImageUrl}" alt="${p.name}" onerror="this.src='https://placehold.co/70x70/E0D9CF/3D3D3D?text=Ảnh'"></td>
                            <td>${p.name}</td>
                            <td><fmt:formatNumber value="${p.price}" type="currency" currencyCode="VND" /></td>
                            <td>${p.stock}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 1}">
                                        <span style="color: green; font-weight: 500;">● Đang bán</span>
                                    </c:when>
                                    <c:when test="${p.status == 2}">
                                        <span style="color: red; font-weight: 500;">● Đã ẩn</span>
                                    </c:when>
                                    <c:when test="${p.status == 3}">
                                        <span style="color: orange; font-weight: 500;">● Đợi duyệt</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: grey;">Không xác định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-buttons">
                                <a href="editProduct?pid=${p.pid}" title="Chỉnh sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="deleteProduct" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn ẩn tác phẩm này?');">
                                    <input type="hidden" name="pid" value="${p.pid}">
                                    <button type="submit" title="Ẩn sản phẩm" style="background:none; border:none; cursor:pointer; padding:0; font-size: 1.1rem; color: #888; vertical-align: middle;">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty productList}">
                        <tr><td colspan="6" style="text-align: center; padding: 3rem;">Bạn chưa có tác phẩm nào trong xưởng.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </section>
    </main>
</body>
</html>
