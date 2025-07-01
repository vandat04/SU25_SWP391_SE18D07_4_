<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê & Phân Tích</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    
    <!-- Import thư viện Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
        
        /* --- Statistics Cards --- */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2.5rem; }
        .stat-card { background: #fff; border: 1px solid var(--border-color); border-radius: 10px; padding: 1.5rem; display: flex; align-items: flex-start; gap: 1rem; }
        .stat-card .icon { font-size: 2rem; color: var(--accent-color); background: var(--background-color); padding: 0.8rem; border-radius: 50%; width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; }
        .stat-card .info .title { font-size: 0.9rem; color: var(--secondary-text); margin-bottom: 0.5rem; }
        .stat-card .info .value { font-size: 1.8rem; font-weight: 700; }
        
        /* --- Charts --- */
        .chart-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; }
        .chart-container { background: #fff; padding: 2rem; border-radius: 10px; border: 1px solid var(--border-color); }
        .chart-title { font-family: var(--font-heading); font-size: 1.4rem; margin-bottom: 1.5rem; }
        
        .top-products-list { list-style: none; }
        .top-products-list li { display: flex; justify-content: space-between; padding: 0.8rem 0; border-bottom: 1px solid #f0f0f0; }
        .top-products-list li:last-child { border-bottom: none; }
        .top-products-list .product-name { font-weight: 500; }
        .top-products-list .quantity { font-weight: 700; color: var(--accent-color); }

    </style>
</head>
<body>
    <aside class="sidebar">
        <!-- Sidebar content -->
        <div class="sidebar-logo"><a href="home"><img src="hinhanh/Logo/logocraft.png" alt="Craft Village Logo"></a></div>
        <div class="sidebar-profile"><img src="${not empty sessionScope.acc.avatarUrl ? sessionScope.acc.avatarUrl : 'https://i.pravatar.cc/150?u='}${sessionScope.acc.userID}" alt="Avatar nghệ nhân" class="avatar"><h3>${sessionScope.acc.userName}</h3><p>Nghệ nhân</p></div>
        <ul class="sidebar-nav">
              <li><a href="seller"><i class="fas fa-tachometer-alt"></i> Bảng điều khiển</a></li>
              <li><a href="manageProduct"><i class="fas fa-palette"></i> Xưởng chế tác</a></li>
              <li><a href="#"><i class="fas fa-book"></i> Sổ đặt hàng</a></li>
              <li><a href="statistics" class="active"><i class="fas fa-chart-pie"></i> Thống kê</a></li>
              <li><a href="contact"><i class="fas fa-headset"></i> Liên hệ & Hỗ trợ</a></li>
        </ul>
        <div class="sidebar-logout"><a href="logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Đăng xuất</a></div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Thống Kê & Phân Tích</h1>
        </header>

        <!-- Summary Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                <div class="info">
                    <div class="title">TỔNG DOANH THU</div>
                    <div class="value"><fmt:formatNumber value="${summary.totalRevenue}" type="currency" currencyCode="VND" /></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="fas fa-box-open"></i></div>
                <div class="info">
                    <div class="title">TỔNG SỐ ĐƠN HÀNG</div>
                    <div class="value">${summary.totalOrders}</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="icon"><i class="fas fa-tshirt"></i></div>
                <div class="info">
                    <div class="title">SẢN PHẨM ĐÃ BÁN</div>
                    <div class="value">${summary.totalProductsSold}</div>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="chart-grid">
            <div class="chart-container">
                <h3 class="chart-title">Doanh Thu Theo Tháng (12 tháng qua)</h3>
                <canvas id="revenueChart"></canvas>
            </div>
            <div class="chart-container">
                <h3 class="chart-title">Top 5 Tác Phẩm Bán Chạy</h3>
                <ul class="top-products-list">
                    <c:forEach var="product" items="${topProducts}">
                        <li>
                            <span class="product-name">${product.productName}</span>
                            <span class="quantity">${product.totalQuantitySold} đã bán</span>
                        </li>
                    </c:forEach>
                    <c:if test="${empty topProducts}">
                        <li>Chưa có dữ liệu.</li>
                    </c:if>
                </ul>
            </div>
        </div>

    </main>
    
    <script>
        // Data from Servlet
        const monthlyRevenueLabels = [];
        const monthlyRevenueValues = [];
        <c:forEach var="item" items="${monthlyRevenueData}">
            monthlyRevenueLabels.push('${item.month}');
            monthlyRevenueValues.push(${item.revenue});
        </c:forEach>

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: monthlyRevenueLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: monthlyRevenueValues,
                    borderColor: '#8c6d46',
                    backgroundColor: 'rgba(140, 109, 70, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value, index, values) {
                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed.y !== null) {
                                     label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                }
                                return label;
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
