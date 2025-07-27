<%-- 
    Document   : seller-product-list
    Created on : Jul 27, 2025
    Author     : GitHub Copilot
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - Seller Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/seller.css">
    
    <style>
        body {
            background-color: #f8fafc;
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
        
        .filters-card {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        
        .product-card {
            background: white;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
        }
        
        .product-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: #f1f5f9;
        }
        
        .product-status {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            z-index: 10;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-active {
            background: #10b981;  /* Darker green background */
            color: white;         /* White text for better contrast */
            border: 1px solid #059669;
        }
        
        .status-inactive {
            background: #6b7280;  /* Gray background */
            color: white;         /* White text */
            border: 1px solid #4b5563;
        }
        
        .bulk-actions {
            background: white;
            border-radius: 0.75rem;
            padding: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            display: none;
        }
        
        .bulk-actions.show {
            display: block;
        }
        
        .table-view .product-row {
            background: white;
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .view-toggle {
            background: white;
            border-radius: 0.5rem;
            padding: 0.25rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .view-toggle button {
            border: none;
            background: transparent;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            transition: all 0.2s ease;
        }
        
        .view-toggle button.active {
            background: #3b82f6;
            color: white;
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
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="seller-dashboard" class="text-decoration-none">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Quản lý sản phẩm</li>
                    </ol>
                </nav>
                
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 mb-1">Quản lý sản phẩm</h1>
                        <p class="text-muted mb-0">Quản lý tất cả sản phẩm của bạn</p>
                    </div>
                    <div class="d-flex gap-2 align-items-center">
                        <!-- View Toggle -->
                        <div class="view-toggle">
                            <button type="button" class="grid-view active" data-view="grid">
                                <i class="fas fa-th"></i>
                            </button>
                            <button type="button" class="list-view" data-view="list">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                        
                        <a href="seller-product-management?action=add" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Content Body -->
            <div class="content-body">
                <!-- Alerts -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Filters -->
                <div class="filters-card">
                    <form method="GET" action="seller-product-management" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label for="status" class="form-label">Trạng thái</label>
                            <select name="status" id="status" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="1" ${selectedStatus == '1' ? 'selected' : ''}>Hoạt động</option>
                                <option value="0" ${selectedStatus == '0' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>
                        
                        <div class="col-md-4">
                            <label for="categoryId" class="form-label">Danh mục</label>
                            <select name="categoryId" id="categoryId" class="form-select">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.categoryID}" ${selectedCategoryId == category.categoryID ? 'selected' : ''}>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-3">
                            <label for="search" class="form-label">Tìm kiếm</label>
                            <div class="input-group">
                                <input type="text" name="search" id="search" class="form-control" 
                                       placeholder="Tên sản phẩm..." value="${searchQuery}">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div class="col-md-1">
                            <button type="button" class="btn btn-outline-secondary w-100" onclick="resetFilters()">
                                <i class="fas fa-undo"></i>
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Bulk Actions -->
                <div class="bulk-actions" id="bulkActions">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong><span id="selectedCount">0</span> sản phẩm được chọn</strong>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-success btn-sm" data-bulk-action="activate">
                                <i class="fas fa-check me-1"></i>Kích hoạt
                            </button>
                            <button type="button" class="btn btn-warning btn-sm" data-bulk-action="deactivate">
                                <i class="fas fa-ban me-1"></i>Vô hiệu hóa
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Products Grid/List -->
                <div id="productsContainer">
                    
                    <c:choose>
                        <c:when test="${not empty products}">
                            <!-- Products Grid View -->
                            <div class="grid-view-container">
                                <div class="row g-3">
                                    <c:forEach items="${products}" var="product">
                                        <div class="col-xl-3 col-lg-4 col-md-6">
                                            <div class="product-card position-relative">
                                                <!-- Product Status -->
                                                <div class="product-status">
                                                    <c:choose>
                                                        <c:when test="${product.status == 1}">
                                                            <span class="status-badge status-active">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-inactive">Không hoạt động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <!-- Product Image -->
                                                <div class="position-relative">
                                                    <c:choose>
                                                        <c:when test="${not empty product.mainImageUrl}">
                                                            <img src="${product.mainImageUrl}" alt="${product.name}" class="product-image">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="product-image d-flex align-items-center justify-content-center bg-light">
                                                                <i class="fas fa-image text-muted fa-3x"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <!-- Selection Checkbox -->
                                                    <div class="position-absolute top-0 start-0 p-2">
                                                        <input type="checkbox" class="form-check-input product-select" 
                                                               value="${product.pid}" data-select-row>
                                                    </div>
                                                </div>
                                                
                                                <!-- Product Content -->
                                                <div class="card-body p-3">
                                                    <h6 class="card-title mb-2 text-truncate" title="${product.name}">
                                                        ${product.name}
                                                    </h6>
                                                    
                                                    <div class="mb-2">
                                                        <span class="text-primary fw-bold">
                                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                                        </span>
                                                    </div>
                                                    
                                                    <div class="mb-2 small text-muted">
                                                        <i class="fas fa-box me-1"></i>Kho: ${product.stock}
                                                        <c:if test="${product.stock < 10}">
                                                            <span class="text-warning">
                                                                <i class="fas fa-exclamation-triangle ms-1"></i>
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    
                                                    <div class="small text-muted mb-3">
                                                        SKU: ${not empty product.sku ? product.sku : 'N/A'}
                                                    </div>
                                                    
                                                    <!-- Product Actions -->
                                                    <div class="d-flex gap-1 flex-wrap">
                                                        <a href="seller-product-management?action=view&id=${product.pid}" 
                                                           class="btn btn-outline-primary btn-sm flex-fill">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="seller-product-management?action=edit&id=${product.pid}" 
                                                           class="btn btn-outline-secondary btn-sm flex-fill">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <!-- Products List View (Hidden by default) -->
                            <div class="list-view-container" style="display: none;">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="50">
                                                    <input type="checkbox" class="form-check-input" id="selectAll">
                                                </th>
                                                <th width="80">Ảnh</th>
                                                <th>Tên sản phẩm</th>
                                                <th width="120">Giá</th>
                                                <th width="80">Kho</th>
                                                <th width="100">Trạng thái</th>
                                                <th width="120">Ngày tạo</th>
                                                <th width="150">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${products}" var="product">
                                                <tr>
                                                    <td>
                                                        <input type="checkbox" class="form-check-input product-select" 
                                                               value="${product.pid}" data-select-row>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty product.mainImageUrl}">
                                                                <img src="${product.mainImageUrl}" alt="${product.name}" 
                                                                     class="rounded" style="width: 50px; height: 50px; object-fit: cover;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="bg-light rounded d-flex align-items-center justify-content-center" 
                                                                     style="width: 50px; height: 50px;">
                                                                    <i class="fas fa-image text-muted"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="fw-medium">${product.name}</div>
                                                        <small class="text-muted">SKU: ${not empty product.sku ? product.sku : 'N/A'}</small>
                                                    </td>
                                                    <td>
                                                        <span class="fw-bold text-primary">
                                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="${product.stock < 10 ? 'text-warning' : ''}">
                                                            ${product.stock}
                                                            <c:if test="${product.stock < 10}">
                                                                <i class="fas fa-exclamation-triangle ms-1"></i>
                                                            </c:if>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.status == 1}">
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Không hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${product.createdDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <a href="seller-product-management?action=view&id=${product.pid}" 
                                                               class="btn btn-outline-primary" title="Xem chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="seller-product-management?action=edit&id=${product.pid}" 
                                                               class="btn btn-outline-secondary" title="Chỉnh sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="text-center py-5">
                                <div class="mb-4">
                                    <i class="fas fa-box-open fa-4x text-muted"></i>
                                </div>
                                <h4 class="text-muted mb-3">Chưa có sản phẩm nào</h4>
                                <p class="text-muted mb-4">
                                    Bạn chưa có sản phẩm nào. Hãy thêm sản phẩm đầu tiên để bắt đầu bán hàng!
                                </p>
                                <a href="seller-product-management?action=add" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Product pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&status=${selectedStatus}&categoryId=${selectedCategoryId}&search=${searchQuery}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <li class="page-item active">
                                                <span class="page-link">${i}</span>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${i}&status=${selectedStatus}&categoryId=${selectedCategoryId}&search=${searchQuery}">${i}</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&status=${selectedStatus}&categoryId=${selectedCategoryId}&search=${searchQuery}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                    
                    <!-- Pagination Summary -->
                    <c:if test="${totalProducts > 0}">
                        <div class="text-center mt-3">
                            <small class="text-muted">
                                Hiển thị ${(currentPage - 1) * 8 + 1} - ${currentPage * 8 > totalProducts ? totalProducts : currentPage * 8} 
                                trong tổng số ${totalProducts} sản phẩm
                            </small>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // View toggle functionality
        document.addEventListener('DOMContentLoaded', function() {
            const gridViewBtn = document.querySelector('.grid-view');
            const listViewBtn = document.querySelector('.list-view');
            const gridContainer = document.querySelector('.grid-view-container');
            const listContainer = document.querySelector('.list-view-container');
            
            gridViewBtn.addEventListener('click', function() {
                gridViewBtn.classList.add('active');
                listViewBtn.classList.remove('active');
                gridContainer.style.display = 'block';
                listContainer.style.display = 'none';
            });
            
            listViewBtn.addEventListener('click', function() {
                listViewBtn.classList.add('active');
                gridViewBtn.classList.remove('active');
                gridContainer.style.display = 'none';
                listContainer.style.display = 'block';
            });
            
            // Bulk selection
            const selectAllCheckbox = document.getElementById('selectAll');
            const productCheckboxes = document.querySelectorAll('.product-select');
            const bulkActions = document.getElementById('bulkActions');
            const selectedCount = document.getElementById('selectedCount');
            
            function updateBulkActions() {
                const selectedProducts = document.querySelectorAll('.product-select:checked');
                selectedCount.textContent = selectedProducts.length;
                
                if (selectedProducts.length > 0) {
                    bulkActions.classList.add('show');
                } else {
                    bulkActions.classList.remove('show');
                }
            }
            
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    productCheckboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                    updateBulkActions();
                });
            }
            
            productCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', updateBulkActions);
            });
        });
        
        // Reset filters
        function resetFilters() {
            window.location.href = 'seller-product-management';
        }
    </script>
</body>
</html>
