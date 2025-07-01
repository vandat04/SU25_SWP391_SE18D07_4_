<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không Gian Sáng Tác - ${artistName}</title>
    
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
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: var(--font-body);
            background-color: var(--background-color);
            color: var(--primary-text);
            display: flex;
            min-height: 100vh;
        }

        /* --- Sidebar (Giữ nguyên phần lớn) --- */
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
        
        /* --- Bố cục lưới cho nội dung chính --- */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .main-column {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .side-column {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        /* --- Panel chung --- */
        .panel {
            background-color: #fff;
            padding: 2rem;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 15px var(--shadow-color);
        }
        .panel-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem; }
        .panel-title { font-family: var(--font-heading); font-size: 1.5rem; }
        .panel a.view-all { font-size: 0.9rem; color: var(--accent-color); text-decoration: none; font-weight: 500; }

        /* --- Panel Hành động nhanh --- */
        .action-list a {
            display: flex;
            align-items: center;
            padding: 1rem;
            margin: 0 -1rem; /* Mở rộng ra cho đẹp */
            border-radius: 8px;
            text-decoration: none;
            color: var(--primary-text);
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .action-list a:hover { background-color: var(--background-color); }
        .action-list i { margin-right: 1rem; color: var(--accent-color); font-size: 1.2rem; width: 25px; }
        .action-list .badge { margin-left: auto; background-color: var(--accent-color); color: #fff; font-size: 0.8rem; font-weight: 700; padding: 0.2rem 0.6rem; border-radius: 20px; }
        
        /* --- Panel Tác phẩm gần đây --- */
        .recent-products-list { list-style: none; }
        .recent-products-list li { display: flex; align-items: center; gap: 1rem; padding: 0.75rem 0; border-bottom: 1px solid var(--border-color); }
        .recent-products-list li:last-child { border-bottom: none; }
        .recent-products-list img { width: 50px; height: 50px; border-radius: 8px; object-fit: cover; }
        .recent-products-list .product-name { font-weight: 500; flex-grow: 1; }
        .recent-products-list .product-price { font-size: 0.9rem; color: var(--secondary-text); }
        .primary-action-btn {
            display: block;
            width: 100%;
            padding: 1rem;
            margin-top: 1.5rem;
            background: var(--accent-color);
            color: #fff;
            border: none;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        .primary-action-btn:hover { background: var(--accent-hover); }

        /* --- Panel Cảm hứng --- */
        .inspiration-quote {
            text-align: center;
            font-style: italic;
            font-family: var(--font-heading);
            font-size: 1.1rem;
            line-height: 1.6;
            color: var(--primary-text);
        }
        .inspiration-quote i { color: var(--accent-color); margin: 0 0.5rem; }

    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-logo">
            <a href="home"><img src="hinhanh/Logo/logocraft.png" alt="Craft Village Logo"></a>
        </div>
        
        <div class="sidebar-profile">
            <img src="https://i.pravatar.cc/150?u=${sessionScope.acc.userID}" alt="Avatar nghệ nhân" class="avatar">
            <h3>${artistName}</h3>
            <p>Nghệ nhân</p>
        </div>
        
        <ul class="sidebar-nav">
            <li><a href="seller" class="active"><i class="fas fa-tachometer-alt"></i> Bảng điều khiển</a></li>
            <li><a href="manageProduct"><i class="fas fa-palette"></i> Xưởng chế tác</a></li>
            <!-- === BẮT ĐẦU SỬA ĐỔI === -->
            <li><a href="village-posts"><i class="fas fa-newspaper"></i> Quản lý bài đăng</a></li>
            <!-- === KẾT THÚC SỬA ĐỔI === -->
            <li><a href="statistics"><i class="fas fa-chart-pie"></i> Thống kê</a></li>
            <li><a href="contact"><i class="fas fa-headset"></i> Liên hệ & Hỗ trợ</a></li>
        </ul>

        <div class="sidebar-logout">
             <a href="logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Đăng xuất</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Không gian sáng tác</h1>
            <p>Chào mừng nghệ nhân ${artistName} trở lại! Hãy cùng thăng hoa với những ý tưởng mới.</p>
        </header>

        <div class="dashboard-grid">
            <div class="main-column">
                <section class="panel">
                    <div class="panel-header">
                        <h2 class="panel-title">Xưởng Chế Tác Của Bạn</h2>
                        <a href="manageProduct" class="view-all">Xem tất cả &rarr;</a>
                    </div>
                    <%-- Ghi chú: Backend cần cung cấp một list tên là 'recentProducts' --%>
                    <ul class="recent-products-list">
                        <c:forEach var="p" items="${recentProducts}">
                             <li>
                                <img src="${p.imageURL}" alt="${p.name}">
                                <span class="product-name">${p.name}</span>
                                <span class="product-price">${p.price} VNĐ</span>
                            </li>
                        </c:forEach>
                        <%-- Dữ liệu mẫu nếu list rỗng --%>
                        <c:if test="${empty recentProducts}">
                             <li>Chưa có tác phẩm nào gần đây.</li>
                        </c:if>
                    </ul>
                    <a href="createProduct" class="primary-action-btn"><i class="fas fa-plus"></i> Thêm tác phẩm mới</a>
                </section>
            </div>
            <div class="side-column">
                <section class="panel">
                    <h2 class="panel-title" style="margin-bottom: 1.5rem;">Việc Cần Làm</h2>
                    <div class="action-list">
                        <a href="#">
                            <i class="fas fa-box-open"></i>
                            Đơn hàng mới
                            <%-- Ghi chú: Backend cần cung cấp biến 'newOrderCount' --%>
                            <span class="badge">${newOrderCount > 0 ? newOrderCount : '0'}</span>
                        </a>
                         <a href="#">
                            <i class="fas fa-envelope"></i>
                            Tin nhắn chưa đọc
                            <span class="badge">3</span>
                        </a>
                        <a href="#">
                            <i class="fas fa-star"></i>
                            Đánh giá mới
                            <span class="badge">5</span>
                        </a>
                    </div>
                </section>

                <section class="panel">
                     <h2 class="panel-title" style="margin-bottom: 1.5rem;">Góc Nhìn Nghệ Nhân</h2>
                     <p class="inspiration-quote">
                         <i class="fas fa-quote-left"></i>
                         Bàn tay tạo tác, gửi gắm tâm hồn vào từng sản phẩm.
                         <i class="fas fa-quote-right"></i>
                     </p>
                </section>
            </div>
        </div>
        
    </main>

</body>
</html>
