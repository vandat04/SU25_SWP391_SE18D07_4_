<%-- 
    Document   : seller-village-management
    Created on : Jul 27, 2025
    Author     : GitHub Copilot
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý làng nghề - CraftVillage</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/seller-style.css">
    
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
        }

        body {
            background: #f8f9fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }
        
        .village-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            height: 100%;
        }
        
        .village-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .village-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .village-status {
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-active {
            background: var(--success-color);
            color: white;
        }
        
        .status-inactive {
            background: var(--danger-color);
            color: white;
        }
        
        .village-info {
            padding: 20px;
        }
        
        .village-title {
            font-size: 18px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }
        
        .village-description {
            color: #718096;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 16px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .village-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 16px;
            padding: 12px;
            background: #f7fafc;
            border-radius: 8px;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 2px;
        }
        
        .stat-label {
            font-size: 11px;
            color: #a0aec0;
            font-weight: 500;
        }
        
        .village-contact {
            margin-bottom: 16px;
            padding: 12px;
            background: #f0f4f8;
            border-radius: 8px;
            border-left: 3px solid var(--primary-color);
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            margin-bottom: 6px;
            font-size: 13px;
            color: #4a5568;
        }
        
        .contact-item:last-child {
            margin-bottom: 0;
        }
        
        .contact-item i {
            width: 16px;
            margin-right: 8px;
            color: var(--primary-color);
        }
        
        .village-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-village {
            flex: 1;
            padding: 8px 12px;
            font-size: 12px;
            font-weight: 500;
            border-radius: 6px;
            transition: all 0.2s ease;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background: var(--primary-color);
            color: white;
        }
        
        .btn-outline-success {
            color: var(--success-color);
            border-color: var(--success-color);
        }
        
        .btn-outline-success:hover {
            background: var(--success-color);
            color: white;
        }
        
        .btn-outline-info {
            color: var(--info-color);
            border-color: var(--info-color);
        }
        
        .btn-outline-info:hover {
            background: var(--info-color);
            color: white;
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        
        .breadcrumb {
            background: transparent;
            margin-bottom: 0;
            padding: 0;
        }
        
        .breadcrumb-item a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
        }
        
        .breadcrumb-item.active {
            color: white;
        }
        
        .seller-content {
            margin-left: 280px;
            padding: 0;
            min-height: 100vh;
        }
        
        .summary-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .summary-card .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 16px 20px;
        }
        
        .summary-card .card-header h5 {
            margin: 0;
            color: #2d3748;
        }
        
        .summary-stats {
            padding: 20px;
        }
        
        .summary-stat-box {
            text-align: center;
            padding: 20px;
            border-radius: 8px;
            background: #f7fafc;
            transition: all 0.2s ease;
        }
        
        .summary-stat-box:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .summary-stat-box h3 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 4px;
        }
        
        .stat-primary h3 { color: var(--primary-color); }
        .stat-success h3 { color: var(--success-color); }
        .stat-warning h3 { color: var(--warning-color); }
        .stat-info h3 { color: var(--info-color); }
        
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .empty-state i {
            font-size: 3rem;
            color: #cbd5e0;
            margin-bottom: 20px;
        }
        
        .empty-state h4 {
            color: #4a5568;
            margin-bottom: 12px;
        }
        
        .empty-state p {
            color: #718096;
            margin-bottom: 24px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }
        
        /* Table Styles */
        .village-thumb {
            width: 320px;
            height: 200px;
            object-fit: cover;
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: transform 0.2s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .village-thumb:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 16px rgba(0,0,0,0.2);
        }
        
        .village-info-table {
            max-width: none;
            padding-right: 15px;
        }
        
        .village-name {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 4px;
        }
        
        .village-desc-short {
            font-size: 12px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .table > :not(caption) > * > * {
            padding: 20px 15px;
            vertical-align: middle;
        }
        
        .table-hover > tbody > tr:hover > * {
            background-color: rgba(103, 126, 234, 0.05);
        }
        
        .btn-group-sm .btn {
            padding: 4px 8px;
            font-size: 12px;
        }
        
        @media (max-width: 768px) {
            .seller-content {
                margin-left: 0;
                padding: 0 16px;
            }
            
            .village-stats {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .village-actions {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .village-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
    <!-- Mobile Navigation Toggle -->
    <button class="mobile-nav-toggle" id="mobileNavToggle" type="button">
        <i class="fas fa-bars"></i>
    </button>
    
    <!-- Include seller sidebar -->
    <jsp:include page="seller-sidebar.jsp" />
    
    <!-- Main content -->
    <div class="seller-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <div class="col">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="seller"><i class="fas fa-home"></i> Dashboard</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    Quản lý làng nghề
                                </li>
                            </ol>
                        </nav>
                        <h1 class="h2 mb-0">
                            <i class="fas fa-map-marker-alt"></i> Quản lý làng nghề của tôi
                        </h1>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Content -->
        <div class="container-fluid">
            <c:choose>
                <c:when test="${not empty sellerVillages}">
                    <!-- Village Statistics Summary -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="summary-card">
                                <div class="card-header">
                                    <h5 class="mb-0 d-flex align-items-center">
                                        <i class="fas fa-chart-line me-3" style="color: var(--primary-color);"></i>
                                        <span>Tóm tắt thống kê làng nghề</span>
                                    </h5>
                                </div>
                                <div class="summary-stats">
                                    <div class="row g-4">
                                        <div class="col-md-3 col-sm-6">
                                            <div class="summary-stat-box stat-primary">
                                                <h3>${fn:length(sellerVillages)}</h3>
                                                <p class="text-muted mb-0">Tổng số làng nghề</p>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-sm-6">
                                            <div class="summary-stat-box stat-success">
                                                <h3>
                                                    <c:set var="activeCount" value="0"/>
                                                    <c:forEach items="${sellerVillages}" var="village">
                                                        <c:if test="${village.status == 1}">
                                                            <c:set var="activeCount" value="${activeCount + 1}"/>
                                                        </c:if>
                                                    </c:forEach>
                                                    ${activeCount}
                                                </h3>
                                                <p class="text-muted mb-0">Đang hoạt động</p>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-sm-6">
                                            <div class="summary-stat-box stat-warning">
                                                <h3>
                                                    <c:set var="totalReviews" value="0"/>
                                                    <c:forEach items="${sellerVillages}" var="village">
                                                        <c:set var="totalReviews" value="${totalReviews + village.totalReviews}"/>
                                                    </c:forEach>
                                                    ${totalReviews}
                                                </h3>
                                                <p class="text-muted mb-0">Tổng đánh giá</p>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-sm-6">
                                            <div class="summary-stat-box stat-info">
                                                <h3>
                                                    <c:set var="totalViews" value="0"/>
                                                    <c:forEach items="${sellerVillages}" var="village">
                                                        <c:set var="totalViews" value="${totalViews + village.clickCount}"/>
                                                    </c:forEach>
                                                    ${totalViews}
                                                </h3>
                                                <p class="text-muted mb-0">Tổng lượt xem</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Village Cards -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="summary-card">
                                <div class="card-header">
                                    <h5 class="mb-0 d-flex align-items-center">
                                        <i class="fas fa-map-marked-alt me-3" style="color: var(--primary-color);"></i>
                                        <span>Danh sách làng nghề của bạn</span>
                                    </h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 350px;">Hình ảnh</th>
                                                    <th style="width: auto;">Tên làng nghề</th>
                                                    <th style="width: 130px;">Trạng thái</th>
                                                    <th style="width: 110px;" class="text-center">Đánh giá</th>
                                                    <th style="width: 110px;" class="text-center">Điểm TB</th>
                                                    <th style="width: 110px;" class="text-center">Lượt xem</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${sellerVillages}" var="village" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            <img src="${not empty village.mainImageUrl ? village.mainImageUrl : 'hinhanh/default-village.jpg'}" 
                                                                 alt="${village.villageName}" 
                                                                 class="village-thumb">
                                                        </td>
                                                        <td>
                                                            <div class="village-info-table">
                                                                <h6 class="village-name mb-1">${village.villageName}</h6>
                                                                <small class="text-muted d-block">
                                                                    <i class="fas fa-map-marker-alt me-1"></i> ${village.address}
                                                                </small>
                                                                <c:if test="${not empty village.description}">
                                                                    <p class="village-desc-short mt-1 mb-0 text-muted">${village.description}</p>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${village.status == 1 ? 'bg-success' : 'bg-danger'}">
                                                                ${village.status == 1 ? 'Hoạt động' : 'Tạm ngưng'}
                                                            </span>
                                                        </td>
                                                        <td class="text-center">
                                                            <strong class="text-primary">${village.totalReviews}</strong>
                                                        </td>
                                                        <td class="text-center">
                                                            <div class="d-flex align-items-center justify-content-center">
                                                                <strong class="text-warning me-1">
                                                                    <c:choose>
                                                                        <c:when test="${village.averageRating != null}">
                                                                            <fmt:formatNumber value="${village.averageRating}" maxFractionDigits="1"/>
                                                                        </c:when>
                                                                        <c:otherwise>0</c:otherwise>
                                                                    </c:choose>
                                                                </strong>
                                                                <i class="fas fa-star text-warning"></i>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <strong class="text-info">${village.clickCount}</strong>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-map-marker-alt"></i>
                        <h4>Chưa có làng nghề nào</h4>
                        <p>Bạn chưa quản lý làng nghề nào. Liên hệ với quản trị viên để được thêm làng nghề và bắt đầu bán sản phẩm truyền thống.</p>
                        <div class="d-flex gap-3 justify-content-center">
                            <a href="contact.jsp" class="btn btn-primary btn-lg px-4 py-2" style="border-radius: 12px;">
                                <i class="fas fa-envelope me-2"></i> Liên hệ hỗ trợ
                            </a>
                            <a href="seller" class="btn btn-outline-secondary btn-lg px-4 py-2" style="border-radius: 12px;">
                                <i class="fas fa-arrow-left me-2"></i> Về Dashboard
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Initialize tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Progressive loading animation for village cards
            const villageCards = document.querySelectorAll('.village-card.fade-in-up');
            villageCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.animationDelay = '0s';
                    card.classList.add('fade-in-up');
                }, index * 100);
            });
        });
        
        // Add active class to current sidebar item
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarLinks = document.querySelectorAll('.sidebar-link');
            sidebarLinks.forEach(link => {
                if (link.href.includes('seller-village-management')) {
                    link.classList.add('active');
                    link.parentElement.classList.add('active');
                }
            });
        });
        
        // Mobile navigation toggle
        document.addEventListener('DOMContentLoaded', function() {
            const mobileToggle = document.getElementById('mobileNavToggle');
            const sidebar = document.getElementById('sellerSidebar');
            const overlay = document.getElementById('sidebarOverlay');
            
            if (mobileToggle) {
                mobileToggle.addEventListener('click', function() {
                    sidebar.classList.add('active');
                    overlay.classList.add('active');
                });
            }
        });
        
        // Smooth scroll for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // Add loading state for external links
        document.addEventListener('DOMContentLoaded', function() {
            const externalLinks = document.querySelectorAll('a[target="_blank"]');
            externalLinks.forEach(link => {
                link.addEventListener('click', function() {
                    const icon = this.querySelector('i');
                    if (icon) {
                        const originalClass = icon.className;
                        icon.className = 'fas fa-spinner fa-spin';
                        setTimeout(() => {
                            icon.className = originalClass;
                        }, 1000);
                    }
                });
            });
        });
    </script>
</body>
</html>
