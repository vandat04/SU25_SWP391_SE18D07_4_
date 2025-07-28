
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard - CraftVillage</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/seller.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="hinhanh/Logo/logocraft.png">
    
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            margin-left: 280px;
            transition: margin-left 0.3s ease;
        }
        
        .main-content.expanded {
            margin-left: 0;
        }
        
        .content-header {
            background: white;
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .content-body {
            padding: 2rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border-left: 4px solid #3b82f6;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .stat-card.success {
            border-left-color: #10b981;
        }
        
        .stat-card.warning {
            border-left-color: #f59e0b;
        }
        
        .stat-card.danger {
            border-left-color: #ef4444;
        }
        
        .chart-container {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            border: 1px solid #e2e8f0;
        }
        
        .chart-container h5 {
            color: #1e293b;
            font-weight: 600;
        }
        
        .chart-container small {
            color: #64748b;
        }
        
        .chart-stats-summary {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1rem;
        }
        
        .chart-stats-summary .bg-light {
            background: white !important;
            border: 1px solid #e2e8f0;
            transition: all 0.2s ease;
        }
        
        .chart-stats-summary .bg-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .btn-group .btn-outline-primary {
            border-color: #e2e8f0;
            color: #64748b;
        }
        
        .btn-group .btn-outline-primary:hover,
        .btn-group .btn-outline-primary.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-color: #3b82f6;
            color: white;
        }
        
        .recent-activities {
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .activity-item {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1rem;
        }
        
        .activity-icon.success {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }
        
        .activity-icon.warning {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }
        
        .activity-icon.info {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .quick-action-btn {
            background: white;
            border: 2px dashed #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            text-align: center;
            text-decoration: none;
            color: #64748b;
            transition: all 0.2s ease;
        }
        
        .quick-action-btn:hover {
            border-color: #3b82f6;
            color: #3b82f6;
            background: rgba(59, 130, 246, 0.05);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 0.75rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <!-- Include Sidebar -->
        <jsp:include page="seller-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="main-content" id="mainContent">
            <!-- Content Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 mb-1">Dashboard</h1>
                        <p class="text-muted mb-0">Chào mừng trở lại, ${sessionScope.acc.fullName}!</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="seller-toggle-sidebar btn btn-outline-primary d-lg-none">
                            <i class="fas fa-bars"></i>
                        </button>
                        <a href="seller-product-management?action=add" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Content Body -->
            <div class="content-body">
                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <!-- Welcome Banner -->
                <div class="welcome-banner">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h2 class="h4 mb-2">Chào mừng đến với Seller Dashboard!</h2>
                            <p class="mb-3 opacity-90">
                                Quản lý sản phẩm, đơn hàng và làng nghề của bạn một cách dễ dàng và hiệu quả.
                            </p>
                            <a href="seller-product-management" class="btn btn-light">
                                <i class="fas fa-rocket me-2"></i>Bắt đầu ngay
                            </a>
                        </div>
                        <div class="col-lg-4 text-center">
                            <i class="fas fa-store" style="font-size: 4rem; opacity: 0.3;"></i>
                        </div>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-xl-3 col-lg-6 col-md-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="text-muted mb-2">Tổng sản phẩm</h6>
                                    <h3 class="mb-0">
                                        <c:choose>
                                            <c:when test="${totalProducts != null}">${totalProducts}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <small class="text-success">
                                        <i class="fas fa-arrow-up me-1"></i>
                                        <c:choose>
                                            <c:when test="${activeProducts != null}">${activeProducts}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose> đang hoạt động
                                    </small>
                                </div>
                                <div class="bg-primary bg-opacity-10 p-3 rounded">
                                    <i class="fas fa-box text-primary"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-lg-6 col-md-6">
                        <div class="stat-card success">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="text-muted mb-2">Làng nghề</h6>
                                    <h3 class="mb-0">
                                        <c:choose>
                                            <c:when test="${sellerVillages != null}">${fn:length(sellerVillages)}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <small class="text-success">
                                        <i class="fas fa-check-circle me-1"></i>
                                        <c:choose>
                                            <c:when test="${not empty sellerVillages}">
                                                <c:set var="activeVillages" value="0"/>
                                                <c:forEach items="${sellerVillages}" var="village">
                                                    <c:if test="${village.status == 1}">
                                                        <c:set var="activeVillages" value="${activeVillages + 1}"/>
                                                    </c:if>
                                                </c:forEach>
                                                ${activeVillages} đã xác thực
                                            </c:when>
                                            <c:otherwise>0 đã xác thực</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                                <div class="bg-success bg-opacity-10 p-3 rounded">
                                    <i class="fas fa-map-marker-alt text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-lg-6 col-md-6">
                        <div class="stat-card warning">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="text-muted mb-2">Đơn hàng gần đây</h6>
                                    <h3 class="mb-0">
                                        <c:choose>
                                            <c:when test="${recentOrders != null}">${fn:length(recentOrders)}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <small class="text-warning">
                                        <i class="fas fa-clock me-1"></i>
                                        7 ngày qua
                                    </small>
                                </div>
                                <div class="bg-warning bg-opacity-10 p-3 rounded">
                                    <i class="fas fa-shopping-cart text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-lg-6 col-md-6">
                        <div class="stat-card danger">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="text-muted mb-2">Doanh thu tháng</h6>
                                    <h3 class="mb-0">
                                        <c:choose>
                                            <c:when test="${revenueData != null && revenueData['currentMonth'] != null}">
                                                <fmt:formatNumber value="${revenueData['currentMonth']}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                            </c:when>
                                            <c:otherwise>₫0</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <small class="text-info">
                                        <i class="fas fa-chart-line me-1"></i>
                                        Tháng hiện tại
                                    </small>
                                </div>
                                <div class="bg-danger bg-opacity-10 p-3 rounded">
                                    <i class="fas fa-dollar-sign text-danger"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions">
                    <a href="seller-product-management?action=add" class="quick-action-btn">
                        <i class="fas fa-plus-circle fa-2x mb-2 d-block"></i>
                        <strong>Thêm sản phẩm mới</strong>
                        <small class="d-block text-muted">Tạo sản phẩm mới cho làng nghề</small>
                    </a>
                    
                    <a href="seller-order-management" class="quick-action-btn">
                        <i class="fas fa-list-alt fa-2x mb-2 d-block"></i>
                        <strong>Xem đơn hàng</strong>
                        <small class="d-block text-muted">Quản lý đơn hàng từ khách hàng</small>
                    </a>
                    
                    <a href="seller-inventory-management" class="quick-action-btn">
                        <i class="fas fa-warehouse fa-2x mb-2 d-block"></i>
                        <strong>Quản lý kho</strong>
                        <small class="d-block text-muted">Cập nhật số lượng tồn kho</small>
                    </a>
                    
                    <a href="seller-reports" class="quick-action-btn">
                        <i class="fas fa-chart-bar fa-2x mb-2 d-block"></i>
                        <strong>Xem báo cáo</strong>
                        <small class="d-block text-muted">Phân tích doanh số bán hàng</small>
                    </a>
                </div>
                
                <div class="row">
                    <!-- Sales Chart -->
                    <div class="col-lg-8">
                        <div class="chart-container">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h5 class="mb-0">Doanh thu theo tháng</h5>
                                    <small class="text-muted">Theo dõi xu hướng doanh thu 6 tháng gần nhất</small>
                                </div>
                                <div class="btn-group btn-group-sm" role="group">
                                    <input type="radio" class="btn-check" name="chartPeriod" id="chart3months">
                                    <label class="btn btn-outline-primary" for="chart3months">3 tháng</label>
                                    
                                    <input type="radio" class="btn-check" name="chartPeriod" id="chart6months" checked>
                                    <label class="btn btn-outline-primary" for="chart6months">6 tháng</label>
                                    
                                    <input type="radio" class="btn-check" name="chartPeriod" id="chart12months">
                                    <label class="btn btn-outline-primary" for="chart12months">12 tháng</label>
                                </div>
                            </div>
                            
                            <!-- Chart Stats Summary -->
                            <div class="row mb-3">
                                <div class="col-4">
                                    <div class="text-center p-2 bg-light rounded">
                                        <div class="text-muted small">Tổng doanh thu</div>
                                        <div class="fw-bold text-primary" id="totalRevenue">₫0</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="text-center p-2 bg-light rounded">
                                        <div class="text-muted small">Trung bình/tháng</div>
                                        <div class="fw-bold text-success" id="avgRevenue">₫0</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="text-center p-2 bg-light rounded">
                                        <div class="text-muted small">Tháng cao nhất</div>
                                        <div class="fw-bold text-warning" id="bestMonth">₫0</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div style="position: relative; height: 350px;">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Activities -->
                    <div class="col-lg-4">
                        <div class="recent-activities">
                            <div class="p-3 border-bottom">
                                <h5 class="mb-0">Hoạt động gần đây</h5>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty recentOrders}">
                                    <c:forEach items="${recentOrders}" var="order" end="4">
                                        <div class="activity-item">
                                            <div class="activity-icon success">
                                                <i class="fas fa-shopping-bag"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1">Đơn hàng mới #${order.id}</h6>
                                                <p class="text-muted mb-1 small">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                                </p>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="activity-item">
                                        <div class="activity-icon info">
                                            <i class="fas fa-info-circle"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">Chưa có đơn hàng nào</h6>
                                            <p class="text-muted mb-0 small">
                                                Hãy thêm sản phẩm để bắt đầu bán hàng!
                                            </p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- View all activities -->
                            <div class="p-3 text-center border-top">
                                <a href="seller-activity-log" class="btn btn-sm btn-outline-primary">
                                    Xem tất cả hoạt động
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script src="assets/js/seller.js"></script>
    
    <!-- Chart.js Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Revenue Chart
            const ctx = document.getElementById('revenueChart');
            if (ctx) {
                const ctxContext = ctx.getContext('2d');
                
                // Revenue data from server
                const revenueData = [
                    <c:choose><c:when test="${revenueData != null && revenueData['month1'] != null}">${revenueData['month1']}</c:when><c:otherwise>0</c:otherwise></c:choose>,
                    <c:choose><c:when test="${revenueData != null && revenueData['month2'] != null}">${revenueData['month2']}</c:when><c:otherwise>0</c:otherwise></c:choose>,
                    <c:choose><c:when test="${revenueData != null && revenueData['month3'] != null}">${revenueData['month3']}</c:when><c:otherwise>0</c:otherwise></c:choose>,
                    <c:choose><c:when test="${revenueData != null && revenueData['month4'] != null}">${revenueData['month4']}</c:when><c:otherwise>0</c:otherwise></c:choose>,
                    <c:choose><c:when test="${revenueData != null && revenueData['month5'] != null}">${revenueData['month5']}</c:when><c:otherwise>0</c:otherwise></c:choose>,
                    <c:choose><c:when test="${revenueData != null && revenueData['month6'] != null}">${revenueData['month6']}</c:when><c:otherwise>0</c:otherwise></c:choose>
                ];
                
                // Get month labels (last 6 months)
                const monthLabels = [];
                const now = new Date();
                for (let i = 5; i >= 0; i--) {
                    const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
                    monthLabels.push(date.toLocaleDateString('vi-VN', { month: 'short', year: 'numeric' }));
                }
                
                // Create gradient
                const gradient = ctxContext.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, 'rgba(59, 130, 246, 0.8)');
                gradient.addColorStop(0.5, 'rgba(59, 130, 246, 0.6)');
                gradient.addColorStop(1, 'rgba(59, 130, 246, 0.3)');
                
                const hoverGradient = ctxContext.createLinearGradient(0, 0, 0, 400);
                hoverGradient.addColorStop(0, 'rgba(16, 185, 129, 0.8)');
                hoverGradient.addColorStop(0.5, 'rgba(16, 185, 129, 0.6)');
                hoverGradient.addColorStop(1, 'rgba(16, 185, 129, 0.3)');
                
                const revenueChart = new Chart(ctxContext, {
                    type: 'bar',
                    data: {
                        labels: monthLabels,
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: revenueData,
                            backgroundColor: gradient,
                            borderColor: '#3b82f6',
                            borderWidth: 2,
                            borderRadius: 8,
                            borderSkipped: false,
                            hoverBackgroundColor: hoverGradient,
                            hoverBorderColor: '#10b981',
                            hoverBorderWidth: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            duration: 2000,
                            easing: 'easeInOutQuart'
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                titleColor: '#fff',
                                bodyColor: '#fff',
                                borderColor: '#3b82f6',
                                borderWidth: 1,
                                cornerRadius: 8,
                                displayColors: false,
                                callbacks: {
                                    title: function(context) {
                                        return 'Tháng ' + context[0].label;
                                    },
                                    label: function(context) {
                                        return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN', {
                                            style: 'currency',
                                            currency: 'VND',
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(context.parsed.y);
                                    }
                                }
                            }
                        },
                        scales: {
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    color: '#64748b',
                                    font: {
                                        weight: '500'
                                    }
                                }
                            },
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(148, 163, 184, 0.1)',
                                    drawBorder: false
                                },
                                ticks: {
                                    color: '#64748b',
                                    callback: function(value) {
                                        if (value >= 1000000) {
                                            return (value / 1000000).toFixed(1) + 'M₫';
                                        } else if (value >= 1000) {
                                            return (value / 1000).toFixed(0) + 'K₫';
                                        }
                                        return new Intl.NumberFormat('vi-VN', {
                                            style: 'currency',
                                            currency: 'VND',
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(value);
                                    }
                                }
                            }
                        },
                        onHover: (event, activeElements) => {
                            event.native.target.style.cursor = activeElements.length > 0 ? 'pointer' : 'default';
                        }
                    }
                });
                
                // Update summary statistics
                updateChartSummary(revenueData);
                
                // Handle chart period change
                const chartPeriodRadios = document.querySelectorAll('input[name="chartPeriod"]');
                chartPeriodRadios.forEach(radio => {
                    radio.addEventListener('change', function() {
                        // Animation for period change
                        revenueChart.update('active');
                        console.log('Chart period changed to:', this.id);
                        // Here you can implement AJAX call to get different period data
                    });
                });
            }
            
            // Function to update chart summary
            function updateChartSummary(data) {
                const total = data.reduce((sum, value) => sum + parseFloat(value || 0), 0);
                const average = total / data.length;
                const max = Math.max(...data.map(v => parseFloat(v || 0)));
                
                document.getElementById('totalRevenue').textContent = formatCurrency(total);
                document.getElementById('avgRevenue').textContent = formatCurrency(average);
                document.getElementById('bestMonth').textContent = formatCurrency(max);
            }
            
            // Currency formatting function
            function formatCurrency(value) {
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND',
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 0
                }).format(value);
            }
            
            // Initialize sidebar toggle functionality
            const sidebarToggle = document.querySelector('.seller-toggle-sidebar');
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sellerSidebar');
            const overlay = document.getElementById('sidebarOverlay');
            
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    sidebar?.classList.toggle('active');
                    overlay?.classList.toggle('active');
                });
            }
            
            // Close sidebar when clicking overlay
            if (overlay) {
                overlay.addEventListener('click', function() {
                    sidebar?.classList.remove('active');
                    overlay?.classList.remove('active');
                });
            }
            
            // Confirmation dialogs for logout and other actions
            const confirmLinks = document.querySelectorAll('[data-confirm]');
            confirmLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    const message = this.getAttribute('data-confirm');
                    if (!confirm(message)) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>
