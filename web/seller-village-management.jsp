<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Craft Village Management - CraftVillage</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/seller.css">
    
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
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
        
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
                padding: 0 16px;
            }
        }
        
        .content-header {
            background: white;
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
            font-size: 0.875rem;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "/";
            color: #6b7280;
        }
        
        .breadcrumb-item a {
            color: #6b7280;
            text-decoration: none;
        }
        
        .breadcrumb-item a:hover {
            color: #3b82f6;
        }
        
        .breadcrumb-item.active {
            color: #374151;
            font-weight: 500;
        }
        
        .summary-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .card-header {
            background: #e0e7ff;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .card-header h5 {
            color: #1e293b;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .summary-stats {
            padding: 1.5rem;
        }
        
        .summary-stat-box {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .summary-stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .summary-stat-box h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .stat-primary h3 { color: #3b82f6; }
        .stat-success h3 { color: #10b981; }
        .stat-warning h3 { color: #f59e0b; }
        .stat-info h3 { color: #60a5fa; }
        
        .summary-stat-box p {
            color: #64748b;
            font-size: 0.875rem;
            margin: 0;
        }
        
        .village-table-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .village-table-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .village-thumb {
            width: 320px;
            height: 200px;
            object-fit: cover;
            border-radius: 0.75rem;
            border: 2px solid #e2e8f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .village-thumb:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 16px rgba(0,0,0,0.2);
        }
        
        .village-info-table {
            padding: 1rem 1.5rem;
        }
        
        .village-name {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        
        .village-desc-short {
            font-size: 0.875rem;
            line-height: 1.4;
            color: #64748b;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .table > :not(caption) > * > * {
            padding: 1rem 1.5rem;
            vertical-align: middle;
        }
        
        .table-hover > tbody > tr:hover > * {
            background-color: rgba(59, 130, 246, 0.05);
        }
        
        .empty-state {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 3rem 2rem;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .empty-state:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .empty-state i {
            font-size: 3rem;
            color: #9ca3af;
            margin-bottom: 1.5rem;
        }
        
        .empty-state h4 {
            color: #1e293b;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: #64748b;
            margin-bottom: 2rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb, #1e40af);
        }
        
        .btn-outline-secondary {
            border-color: #9ca3af;
            color: #9ca3af;
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
        }
        
        .btn-outline-secondary:hover {
            background: #9ca3af;
            color: white;
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
    <div class="main-content">
        <!-- Content Header -->
        <div class="content-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h3 mb-1">
                        <i class="fas fa-map-marker-alt"></i> My Craft Village Management
                    </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="seller" class="text-decoration-none">Dashboard</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Craft Village Management</li>
                        </ol>
                    </nav>
                </div>
            </div>
        </div>
        
        <!-- Content Body -->
        <div class="content-body">
            <c:choose>
                <c:when test="${not empty sellerVillages}">
                    <!-- Village Statistics Summary -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="summary-card">
                                <div class="card-header">
                                    <h5 class="mb-0 d-flex align-items-center">
                                        <i class="fas fa-chart-line me-3" style="color: #3b82f6;"></i>
                                        <span>Craft Village Statistics Summary</span>
                                    </h5>
                                </div>
                                <div class="summary-stats">
                                    <div class="row g-4">
                                        <div class="col-md-3 col-sm-6">
                                            <div class="summary-stat-box stat-primary">
                                                <h3>${fn:length(sellerVillages)}</h3>
                                                <p class="text-muted mb-0">Total Villages</p>
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
                                                <p class="text-muted mb-0">Active</p>
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
                                                <p class="text-muted mb-0">Total Reviews</p>
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
                                                <p class="text-muted mb-0">Total Views</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Village Table -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="village-table-card">
                                <div class="card-header">
                                    <h5 class="mb-0 d-flex align-items-center">
                                        <i class="fas fa-map-marked-alt me-3" style="color: #3b82f6;"></i>
                                        <span>Your Craft Village List</span>
                                    </h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 350px;">Image</th>
                                                    <th style="width: auto;">Village Name</th>
                                                    <th style="width: 130px;">Status</th>
                                                    <th style="width: 110px;" class="text-center">Reviews</th>
                                                    <th style="width: 110px;" class="text-center">Average Rating</th>
                                                    <th style="width: 110px;" class="text-center">Views</th>
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
                                                                ${village.status == 1 ? 'Active' : 'Inactive'}
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
                        <h4>No Craft Villages Yet</h4>
                        <p>You are not managing any craft villages yet. Contact an administrator to add a craft village and start selling traditional products.</p>
                        <div class="d-flex gap-3 justify-content-center">
                            <a href="contact.jsp" class="btn btn-primary btn-lg px-4 py-2">
                                <i class="fas fa-envelope me-2"></i> Contact Support
                            </a>
                            <a href="seller" class="btn btn-outline-secondary btn-lg px-4 py-2">
                                <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
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
            const villageRows = document.querySelectorAll('.table tbody tr');
            villageRows.forEach((row, index) => {
                setTimeout(() => {
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
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
            const mainContent = document.querySelector('.main-content');
            
            if (mobileToggle) {
                mobileToggle.addEventListener('click', function() {
                    sidebar.classList.add('active');
                    mainContent.classList.add('expanded');
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
    </script>