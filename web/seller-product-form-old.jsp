<%-- 
    Document   : seller-product-form
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
    <title>
        <c:choose>
            <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
        </c:choose>
        - Seller Dashboard
    </title>
    
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
        
        .detail-card {
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: none;
            margin-bottom: 1.5rem;
        }
        
        .detail-card .card-header {
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            border-radius: 0.75rem 0.75rem 0 0 !important;
            padding: 1.25rem 1.5rem;
        }
        
        .detail-card .card-body {
            padding: 1.5rem;
        }
        
        .info-table th {
            color: #64748b;
            font-weight: 600;
            border: none;
            padding: 0.75rem 0;
            vertical-align: middle;
        }
        
        .info-table td {
            border: none;
            padding: 0.75rem 0;
            vertical-align: middle;
        }
        
        .info-table tr:not(:last-child) {
            border-bottom: 1px solid #f1f5f9;
        }
        
        .form-control:focus,
        .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
        }
        
        .btn-primary {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
            border-color: #2563eb;
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
                        <h1 class="h3 mb-1">
                            <c:choose>
                                <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
                                <c:otherwise>Thêm sản phẩm mới</c:otherwise>
                            </c:choose>
                        </h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="seller-dashboard.jsp" class="text-decoration-none">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="seller-product-management" class="text-decoration-none">Quản lý sản phẩm</a></li>
                                <li class="breadcrumb-item active">
                                    <c:choose>
                                        <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
                                        <c:otherwise>Thêm sản phẩm</c:otherwise>
                                    </c:choose>
                                </li>
                            </ol>
                        </nav>
                    </div>
                    <div class="d-flex gap-2 align-items-center">
                        <button type="button" class="seller-toggle-sidebar btn btn-outline-primary d-lg-none">
                            <i class="fas fa-bars"></i>
                        </button>
                        <a href="seller-product-management" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>

            <!-- Content Body -->
            <div class="content-body">
                <form method="POST" action="seller-product-management" enctype="multipart/form-data">
                    <c:choose>
                        <c:when test="${isEdit}">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="id" value="${product.pid}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="add">
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="row">
                        <!-- Left Column - Product Information -->
                        <div class="col-lg-6">
                            <div class="detail-card h-100">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-info-circle me-2 text-primary"></i>Thông tin sản phẩm
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <table class="table info-table">
                                        <tbody>
                                            <tr>
                                                <th width="35%">Tên sản phẩm:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="name" 
                                                           value="${product.name}" required>
                                                </td>
                                            </tr>
                                            <c:if test="${isEdit}">
                                                <tr>
                                                    <th>Mã sản phẩm:</th>
                                                    <td><span class="badge bg-light text-dark">#${product.pid}</span></td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <th>Giá bán (VNĐ):</th>
                                                <td>
                                                    <input type="number" class="form-control" name="price" 
                                                           value="${product.price}" min="0" step="1000">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Số lượng tồn kho:</th>
                                                <td>
                                                    <input type="number" class="form-control" name="stock" 
                                                           value="${product.stock}" min="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Trạng thái:</th>
                                                <td>
                                                    <select class="form-select" name="status">
                                                        <option value="1" ${product.status == 1 ? 'selected' : ''}>Hoạt động</option>
                                                        <option value="0" ${product.status == 0 ? 'selected' : ''}>Không hoạt động</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Làng nghề:</th>
                                                <td>
                                                    <select class="form-select" name="villageId" required>
                                                        <option value="">Chọn làng nghề</option>
                                                        <c:forEach items="${sellerVillages}" var="village">
                                                            <option value="${village.villageID}" 
                                                                    ${product.villageID == village.villageID ? 'selected' : ''}>
                                                                ${village.villageName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Danh mục:</th>
                                                <td>
                                                    <select class="form-select" name="categoryId" required>
                                                        <option value="">Chọn danh mục</option>
                                                        <c:forEach items="${categories}" var="category">
                                                            <option value="${category.categoryID}" 
                                                                    ${product.categoryID == category.categoryID ? 'selected' : ''}>
                                                                ${category.categoryName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Loại thủ công:</th>
                                                <td>
                                                    <select class="form-select" name="craftTypeId">
                                                        <option value="">Chọn loại thủ công</option>
                                                        <c:forEach items="${craftTypes}" var="craftType">
                                                            <option value="${craftType.typeID}" 
                                                                    ${product.craftTypeID == craftType.typeID ? 'selected' : ''}>
                                                                ${craftType.typeName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Mã SKU:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="sku" 
                                                           value="${product.sku}">
                                                </td>
                                            </tr>
                                            <c:if test="${isEdit}">
                                                <tr>
                                                    <th>Ngày tạo:</th>
                                                    <td>
                                                        <span class="text-muted">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            <fmt:formatDate value="${product.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Lượt xem:</th>
                                                    <td>
                                                        <span class="badge bg-info">
                                                            <i class="fas fa-eye me-1"></i>${product.clickCount}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column - Additional Information -->
                        <div class="col-lg-6">
                            <!-- Description Section -->
                            <div class="detail-card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-file-alt me-2 text-primary"></i>Mô tả sản phẩm
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label">Mô tả ngắn:</label>
                                        <textarea class="form-control" name="description" rows="3">${product.description}</textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Product Specifications -->
                            <div class="detail-card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-cogs me-2 text-primary"></i>Thông số kỹ thuật
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <table class="table info-table">
                                        <tbody>
                                            <tr>
                                                <th width="35%">Kích thước:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="dimensions" 
                                                           value="${product.dimensions}">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Trọng lượng:</th>
                                                <td>
                                                    <input type="number" class="form-control" name="weight" 
                                                           value="${product.weight != null ? product.weight : ''}" step="0.01" min="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Chất liệu:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="materials" 
                                                           value="${product.materials}">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Hướng dẫn bảo quản:</th>
                                                <td>
                                                    <textarea class="form-control" name="careInstructions" rows="2">${product.careInstructions}</textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Bảo hành:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="warranty" 
                                                           value="${product.warranty}">
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Image Upload -->
                            <div class="detail-card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-images me-2 text-primary"></i>Hình ảnh sản phẩm
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:if test="${isEdit && not empty product.mainImageUrl}">
                                        <div class="mb-3">
                                            <label class="form-label">Ảnh hiện tại:</label>
                                            <div class="text-center">
                                                <img src="${product.mainImageUrl}" alt="${product.name}" 
                                                     class="img-thumbnail" style="max-height: 200px;">
                                            </div>
                                        </div>
                                    </c:if>
                                    <div class="mb-3">
                                        <label class="form-label">Thêm/Thay đổi ảnh sản phẩm:</label>
                                        <input type="file" class="form-control" name="images" multiple accept="image/*">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Chọn nhiều ảnh, ảnh đầu tiên sẽ làm ảnh chính
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mt-3">
                        <div class="col-12">
                            <div class="detail-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <a href="seller-product-management" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>Hủy bỏ
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>
                                            <c:choose>
                                                <c:when test="${isEdit}">Cập nhật sản phẩm</c:when>
                                                <c:otherwise>Thêm sản phẩm</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script src="assets/js/seller.js"></script>
</body>
</html>
            border-radius: 0.5rem;
            padding: 2rem;
            text-align: center;
            transition: border-color 0.2s ease;
            cursor: pointer;
        }
        
        .image-upload-container:hover {
            border-color: #3b82f6;
        }
        
        .image-upload-container.dragover {
            border-color: #3b82f6;
            background-color: #f0f9ff;
        }
        
        .uploaded-images {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .image-preview {
            position: relative;
            width: 120px;
            height: 120px;
            border-radius: 0.5rem;
            overflow: hidden;
            border: 2px solid #e2e8f0;
        }
        
        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .image-preview .remove-image {
            position: absolute;
            top: 0.25rem;
            right: 0.25rem;
            background: rgba(239, 68, 68, 0.9);
            color: white;
            border: none;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            font-size: 0.75rem;
            cursor: pointer;
        }
        
        .image-preview .main-image-badge {
            position: absolute;
            bottom: 0.25rem;
            left: 0.25rem;
            background: rgba(16, 185, 129, 0.9);
            color: white;
            padding: 0.125rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
        }
        
        .rich-editor {
            height: 200px;
        }
        
        .form-floating-custom {
            position: relative;
        }
        
        .form-floating-custom .form-label {
            position: absolute;
            top: 0;
            left: 0.75rem;
            font-size: 0.875rem;
            color: #6b7280;
            transform: translateY(-50%);
            background: white;
            padding: 0 0.25rem;
            z-index: 10;
        }
        
        .save-actions {
            position: sticky;
            bottom: 2rem;
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: 1px solid #e2e8f0;
            margin-top: 2rem;
            z-index: 50;
        }
        
        .field-required {
            color: #ef4444;
        }
        
        .validation-error {
            border-color: #ef4444 !important;
            box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.25) !important;
        }
        
        .validation-message {
            color: #ef4444;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        .form-floating > label {
            color: #6b7280;
            font-weight: 500;
        }
        
        .form-control:focus,
        .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, 0.25);
        }
        
        .btn-primary {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
            border-color: #2563eb;
        }
        
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Debug: Page is loading -->
    <div style="display: none;">Debug: Form page loaded, isEdit = ${isEdit}</div>
    
    <div class="dashboard-layout">
        <!-- Include Sidebar -->
        <jsp:include page="seller-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="main-content" id="mainContent">
            <!-- Content Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-2">
                                <li class="breadcrumb-item">
                                    <a href="seller" class="text-decoration-none">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="seller-product-management" class="text-decoration-none">Quản lý sản phẩm</a>
                                </li>
                                <li class="breadcrumb-item active">
                                    <c:choose>
                                        <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
                                        <c:otherwise>Thêm sản phẩm</c:otherwise>
                                    </c:choose>
                                </li>
                            </ol>
                        </nav>
                        <h1 class="h3 mb-1">
                            <c:choose>
                                <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
                                <c:otherwise>Thêm sản phẩm mới</c:otherwise>
                            </c:choose>
                        </h1>
                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${isEdit}">Cập nhật thông tin sản phẩm</c:when>
                                <c:otherwise>Tạo sản phẩm mới để bắt đầu bán hàng</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="d-flex gap-2 align-items-center">
                        <button type="button" class="seller-toggle-sidebar btn btn-outline-primary d-lg-none">
                            <i class="fas fa-bars"></i>
                        </button>
                        <a href="seller-product-management" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Content Body -->
            <div class="content-body">
                <!-- Form -->
                <form id="productForm" method="POST" action="seller-product-management" enctype="multipart/form-data">
                    <c:choose>
                        <c:when test="${isEdit}">
                            <input type="hidden" name="action" value="edit">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="add">
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${product.pid}">
                    </c:if>
                    
                    <!-- Basic Information -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-info-circle me-2"></i>Thông tin cơ bản
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-md-8">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="${product.name}" placeholder="Tên sản phẩm" required>
                                    <label for="name">Tên sản phẩm <span class="field-required">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="sku" name="sku" 
                                           value="${product.sku}" placeholder="Mã SKU">
                                    <label for="sku">Mã SKU</label>
                                </div>
                            </div>
                            
                            <div class="col-12">
                                <label for="description" class="form-label">Mô tả ngắn</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="3" placeholder="Mô tả ngắn về sản phẩm...">${product.description}</textarea>
                            </div>
                            
                            <div class="col-12">
                                <label for="detailedDescription" class="form-label">Mô tả chi tiết</label>
                                <div id="detailedDescriptionEditor" class="rich-editor"></div>
                                <textarea id="detailedDescription" name="detailedDescription" style="display: none;">${product.detailedDescription}</textarea>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Pricing & Inventory -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-dollar-sign me-2"></i>Giá bán & Tồn kho
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="price" name="price" 
                                           value="${product.price}" placeholder="Giá bán" min="0" step="1000" required>
                                    <label for="price">Giá bán (VNĐ) <span class="field-required">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="originalPrice" name="originalPrice" 
                                           value="${product.originalPrice}" placeholder="Giá gốc" min="0" step="1000">
                                    <label for="originalPrice">Giá gốc (VNĐ)</label>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="stock" name="stock" 
                                           value="${product.stock}" placeholder="Số lượng tồn kho" min="0" required>
                                    <label for="stock">Số lượng tồn kho <span class="field-required">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="minOrderQuantity" name="minOrderQuantity" 
                                           value="${product.minOrderQuantity > 0 ? product.minOrderQuantity : 1}" 
                                           placeholder="Số lượng đặt tối thiểu" min="1">
                                    <label for="minOrderQuantity">Số lượng đặt tối thiểu</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="maxOrderQuantity" name="maxOrderQuantity" 
                                           value="${product.maxOrderQuantity}" placeholder="Số lượng đặt tối đa" min="1">
                                    <label for="maxOrderQuantity">Số lượng đặt tối đa</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Categories & Classifications -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-tags me-2"></i>Phân loại & Danh mục
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="villageId" name="villageId" required>
                                        <option value="">Chọn làng nghề</option>
                                        <c:forEach items="${sellerVillages}" var="village">
                                            <option value="${village.villageID}" 
                                                    ${product.villageID == village.villageID ? 'selected' : ''}>
                                                ${village.villageName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <label for="villageId">Làng nghề <span class="field-required">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option value="">Chọn danh mục</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.categoryID}" 
                                                    ${product.categoryID == category.categoryID ? 'selected' : ''}>
                                                ${category.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <label for="categoryId">Danh mục <span class="field-required">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="craftTypeId" name="craftTypeId" required>
                                        <option value="">Chọn loại thủ công</option>
                                        <c:forEach items="${craftTypes}" var="craftType">
                                            <option value="${craftType.craftTypeID}" 
                                                    ${product.craftTypeID == craftType.craftTypeID ? 'selected' : ''}>
                                                ${craftType.craftTypeName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <label for="craftTypeId">Loại thủ công <span class="field-required">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-12">
                                <label for="tags" class="form-label">Thẻ sản phẩm</label>
                                <input type="text" class="form-control" id="tags" name="tags" 
                                       value="${product.tags}" placeholder="Nhập thẻ, phân cách bằng dấu phẩy...">
                                <div class="form-text">
                                    <i class="fas fa-lightbulb me-1 text-warning"></i>
                                    Thêm các thẻ để giúp khách hàng tìm thấy sản phẩm dễ dàng hơn. 
                                    Ví dụ: handmade, traditional, gift
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product Images -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-images me-2"></i>Hình ảnh sản phẩm
                        </h3>
                        
                        <div class="image-upload-container" id="imageUploadContainer">
                            <div class="mb-3">
                                <i class="fas fa-cloud-upload-alt fa-3x text-primary mb-3"></i>
                                <h5 class="mb-2">Kéo thả hoặc click để tải ảnh lên</h5>
                                <p class="text-muted mb-3">Hỗ trợ: JPG, PNG, GIF (tối đa 5MB mỗi ảnh)</p>
                                <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('imageUpload').click()">
                                    <i class="fas fa-folder-open me-2"></i>Chọn ảnh từ máy tính
                                </button>
                            </div>
                            <input type="file" id="imageUpload" name="images" multiple accept="image/*" style="display: none;">
                        </div>
                        
                        <div class="uploaded-images" id="uploadedImages">
                            <!-- Existing images will be loaded here -->
                            <c:if test="${isEdit && not empty product.images}">
                                <c:forEach items="${product.images}" var="image" varStatus="status">
                                    <div class="image-preview" data-image-id="${image.id}">
                                        <img src="${image.imageUrl}" alt="Product image">
                                        <button type="button" class="remove-image" onclick="removeExistingImage('${image.id}')">
                                            <i class="fas fa-times"></i>
                                        </button>
                                        <c:if test="${status.index == 0}">
                                            <div class="main-image-badge">Ảnh chính</div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                        
                        <div class="form-text mt-3">
                            <i class="fas fa-info-circle me-1 text-primary"></i>
                            Ảnh đầu tiên sẽ được đặt làm ảnh chính. Bạn có thể kéo thả để sắp xếp lại thứ tự.
                        </div>
                    </div>
                    
                    <!-- 3D Model File -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-cube me-2"></i>Mô hình 3D
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-12">
                                <label for="modelFile" class="form-label">File mô hình 3D</label>
                                <input type="file" class="form-control" id="modelFile" name="modelFile" 
                                       accept=".obj,.fbx,.gltf,.glb,.3ds,.dae,.ply,.stl">
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1 text-primary"></i>
                                    Hỗ trợ các định dạng: OBJ, FBX, GLTF, GLB, 3DS, DAE, PLY, STL (tối đa 50MB)
                                </div>
                                <c:if test="${isEdit && not empty product.modelFile}">
                                    <div class="mt-2">
                                        <div class="alert alert-info">
                                            <i class="fas fa-cube me-2"></i>
                                            File hiện tại: <strong>${product.modelFile}</strong>
                                            <br><small>Chọn file mới để thay thế file hiện tại</small>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product Specifications -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-cogs me-2"></i>Thông số sản phẩm
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="dimensions" name="dimensions" 
                                           value="${product.dimensions}" placeholder="Kích thước">
                                    <label for="dimensions">Kích thước</label>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="weight" name="weight" 
                                           value="${product.weight}" placeholder="Trọng lượng" step="0.01" min="0">
                                    <label for="weight">Trọng lượng (kg)</label>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="materials" name="materials" 
                                           value="${product.materials}" placeholder="Chất liệu">
                                    <label for="materials">Chất liệu</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="color" name="color" 
                                           value="${product.color}" placeholder="Màu sắc">
                                    <label for="color">Màu sắc</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="origin" name="origin" 
                                           value="${product.origin}" placeholder="Xuất xứ">
                                    <label for="origin">Xuất xứ</label>
                                </div>
                            </div>
                            
                            <div class="col-12">
                                <label for="careInstructions" class="form-label">Hướng dẫn bảo quản</label>
                                <textarea class="form-control" id="careInstructions" name="careInstructions" 
                                          rows="3" placeholder="Hướng dẫn cách bảo quản sản phẩm...">${product.careInstructions}</textarea>
                            </div>
                            
                            <div class="col-12">
                                <label for="warranty" class="form-label">Thông tin bảo hành</label>
                                <textarea class="form-control" id="warranty" name="warranty" 
                                          rows="2" placeholder="Thông tin về chính sách bảo hành...">${product.warranty}</textarea>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Additional Settings -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-sliders-h me-2"></i>Cài đặt bổ sung
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured" 
                                           value="true" ${product.isFeatured ? 'checked' : ''}>
                                    <label class="form-check-label" for="isFeatured">
                                        <i class="fas fa-star me-1 text-warning"></i>Sản phẩm nổi bật
                                    </label>
                                    <div class="form-text">Hiển thị sản phẩm trong danh sách nổi bật</div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="allowReviews" name="allowReviews" 
                                           value="true" ${product.allowReviews != false ? 'checked' : ''}>
                                    <label class="form-check-label" for="allowReviews">
                                        <i class="fas fa-comments me-1 text-primary"></i>Cho phép đánh giá
                                    </label>
                                    <div class="form-text">Khách hàng có thể để lại đánh giá</div>
                                </div>
                            </div>
                            
                            <c:if test="${isEdit}">
                                <div class="col-md-4">
                                    <div class="form-floating">
                                        <input type="number" class="form-control" id="clickCount" name="clickCount" 
                                               value="${product.clickCount}" readonly>
                                        <label for="clickCount">Lượt xem</label>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-floating">
                                        <input type="number" class="form-control" id="totalReviews" name="totalReviews" 
                                               value="${product.totalReviews}" readonly step="0.1">
                                        <label for="totalReviews">Số đánh giá</label>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-floating">
                                        <input type="number" class="form-control" id="averageRating" name="averageRating" 
                                               value="${product.averageRating}" readonly step="0.1" max="5">
                                        <label for="averageRating">Điểm trung bình</label>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Shipping & Policies -->
                    <div class="form-card">
                        <h3 class="section-title">
                            <i class="fas fa-shipping-fast me-2"></i>Vận chuyển & Chính sách
                        </h3>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="number" class="form-control" id="processingDays" name="processingDays" 
                                           value="${product.processingDays > 0 ? product.processingDays : 1}" 
                                           placeholder="Thời gian xử lý" min="1" max="30">
                                    <label for="processingDays">Thời gian xử lý (ngày)</label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="status" name="status">
                                        <option value="1" ${product.status == 1 ? 'selected' : ''}>Hoạt động</option>
                                        <option value="0" ${product.status == 0 ? 'selected' : ''}>Không hoạt động</option>
                                    </select>
                                    <label for="status">Trạng thái</label>
                                </div>
                            </div>
                            
                            <div class="col-12">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="customizable" name="customizable" 
                                           value="true" ${product.customizable ? 'checked' : ''}>
                                    <label class="form-check-label" for="customizable">
                                        Có thể tùy chỉnh theo yêu cầu
                                    </label>
                                </div>
                            </div>
                            
                            <div class="col-12">
                                <label for="customizationNotes" class="form-label">Ghi chú về tùy chỉnh</label>
                                <textarea class="form-control" id="customizationNotes" name="customizationNotes" 
                                          rows="2" placeholder="Thông tin về khả năng tùy chỉnh sản phẩm...">${product.customizationNotes}</textarea>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Save Actions -->
                    <div class="save-actions">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="saveAsDraft" name="saveAsDraft" value="true">
                                <label class="form-check-label" for="saveAsDraft">
                                    <i class="fas fa-file-alt me-1"></i>Lưu nháp (không hiển thị công khai)
                                </label>
                            </div>
                            
                            <div class="d-flex gap-2 flex-wrap">
                                <a href="seller-product-management" class="btn btn-outline-secondary">
                                    <i class="fas fa-times me-2"></i>Hủy bỏ
                                </a>
                                <button type="button" class="btn btn-outline-primary" onclick="previewProduct()">
                                    <i class="fas fa-eye me-2"></i>Xem trước
                                </button>
                                <button type="submit" class="btn btn-primary" id="saveBtn">
                                    <i class="fas fa-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${isEdit}">Cập nhật</c:when>
                                        <c:otherwise>Lưu</c:otherwise>
                                    </c:choose>
                                    sản phẩm
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Quill JS -->
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    
    <!-- Sortable JS for drag & drop -->
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
    
    <!-- Custom JS -->
    <script src="assets/js/seller.js"></script>
    
    <script>
        // Initialize rich text editor
        const quill = new Quill('#detailedDescriptionEditor', {
            theme: 'snow',
            placeholder: 'Nhập mô tả chi tiết về sản phẩm...',
            modules: {
                toolbar: [
                    ['bold', 'italic', 'underline', 'strike'],
                    ['blockquote', 'code-block'],
                    [{ 'header': 1 }, { 'header': 2 }],
                    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                    [{ 'script': 'sub'}, { 'script': 'super' }],
                    [{ 'indent': '-1'}, { 'indent': '+1' }],
                    [{ 'direction': 'rtl' }],
                    [{ 'size': ['small', false, 'large', 'huge'] }],
                    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                    [{ 'color': [] }, { 'background': [] }],
                    [{ 'font': [] }],
                    [{ 'align': [] }],
                    ['clean'],
                    ['link', 'image']
                ]
            }
        });
        
        // Set initial content
        const initialContent = document.getElementById('detailedDescription').value;
        if (initialContent) {
            quill.root.innerHTML = initialContent;
        }
        
        // Update hidden textarea on content change
        quill.on('text-change', function() {
            document.getElementById('detailedDescription').value = quill.root.innerHTML;
        });
        
        // Image upload handling
        const imageUpload = document.getElementById('imageUpload');
        const uploadedImages = document.getElementById('uploadedImages');
        const imageUploadContainer = document.getElementById('imageUploadContainer');
        
        let uploadedFiles = [];
        let removedImageIds = [];
        
        // Drag and drop functionality
        imageUploadContainer.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.classList.add('dragover');
        });
        
        imageUploadContainer.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.classList.remove('dragover');
        });
        
        imageUploadContainer.addEventListener('drop', function(e) {
            e.preventDefault();
            this.classList.remove('dragover');
            const files = Array.from(e.dataTransfer.files);
            handleFileUpload(files);
        });
        
        imageUpload.addEventListener('change', function(e) {
            const files = Array.from(e.target.files);
            handleFileUpload(files);
        });
        
        function handleFileUpload(files) {
            files.forEach(file => {
                if (file.type.startsWith('image/')) {
                    if (file.size <= 5 * 1024 * 1024) { // 5MB limit
                        uploadedFiles.push(file);
                        displayImagePreview(file);
                    } else {
                        alert('File ' + file.name + ' quá lớn. Vui lòng chọn file nhỏ hơn 5MB.');
                    }
                } else {
                    alert('File ' + file.name + ' không phải là hình ảnh.');
                }
            });
        }
        
        function displayImagePreview(file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const imagePreview = document.createElement('div');
                imagePreview.className = 'image-preview';
                imagePreview.innerHTML = 
                    '<img src="' + e.target.result + '" alt="Preview">' +
                    '<button type="button" class="remove-image" onclick="removeNewImage(this)">' +
                        '<i class="fas fa-times"></i>' +
                    '</button>' +
                    (uploadedImages.children.length === 0 ? '<div class="main-image-badge">Ảnh chính</div>' : '');
                uploadedImages.appendChild(imagePreview);
            };
            reader.readAsDataURL(file);
        }
        
        function removeNewImage(button) {
            const imagePreview = button.closest('.image-preview');
            const index = Array.from(uploadedImages.children).indexOf(imagePreview);
            uploadedFiles.splice(index, 1);
            imagePreview.remove();
            
            // Update main image badge
            updateMainImageBadge();
        }
        
        function removeExistingImage(imageId) {
            removedImageIds.push(imageId);
            const imagePreview = document.querySelector(`[data-image-id="${imageId}"]`);
            if (imagePreview) {
                imagePreview.remove();
                
                // Update main image badge
                updateMainImageBadge();
            }
        }
        
        function updateMainImageBadge() {
            // Remove all main image badges
            document.querySelectorAll('.main-image-badge').forEach(badge => badge.remove());
            
            // Add main image badge to first image
            const firstImage = uploadedImages.querySelector('.image-preview');
            if (firstImage) {
                const badge = document.createElement('div');
                badge.className = 'main-image-badge';
                badge.textContent = 'Ảnh chính';
                firstImage.appendChild(badge);
            }
        }
        
        // Make images sortable
        new Sortable(uploadedImages, {
            animation: 150,
            ghostClass: 'sortable-ghost',
            onEnd: function() {
                updateMainImageBadge();
            }
        });
        
        // Form submission
        document.getElementById('productForm').addEventListener('submit', function(e) {
            // Validate form
            if (!validateForm()) {
                e.preventDefault();
                return;
            }
            
            // Update detailed description before submit
            document.getElementById('detailedDescription').value = quill.root.innerHTML;
            
            // Show loading state
            const saveBtn = document.getElementById('saveBtn');
            const originalText = saveBtn.innerHTML;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lưu...';
            saveBtn.disabled = true;
            
            // Let the form submit normally (no preventDefault)
            // The servlet will handle the redirect
        });
        
        function validateForm() {
            let isValid = true;
            
            // Reset previous validation
            document.querySelectorAll('.validation-error').forEach(el => {
                el.classList.remove('validation-error');
            });
            document.querySelectorAll('.validation-message').forEach(el => {
                el.remove();
            });
            
            // Validate required fields
            const requiredFields = ['name', 'price', 'stock', 'villageId', 'categoryId'];
            requiredFields.forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (!field.value.trim()) {
                    showFieldError(field, 'Trường này là bắt buộc');
                    isValid = false;
                }
            });
            
            // Validate price
            const price = document.getElementById('price');
            if (price.value && parseFloat(price.value) <= 0) {
                showFieldError(price, 'Giá bán phải lớn hơn 0');
                isValid = false;
            }
            
            // Validate stock
            const stock = document.getElementById('stock');
            if (stock.value && parseInt(stock.value) < 0) {
                showFieldError(stock, 'Số lượng tồn kho không được âm');
                isValid = false;
            }
            
            return isValid;
        }
        
        function showFieldError(field, message) {
            field.classList.add('validation-error');
            const errorDiv = document.createElement('div');
            errorDiv.className = 'validation-message';
            errorDiv.textContent = message;
            field.parentNode.appendChild(errorDiv);
        }
        
        function showAlert(type, message) {
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-' + (type === 'success' ? 'success' : 'danger') + ' alert-dismissible fade show';
            alertDiv.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            document.querySelector('.content-body').insertBefore(alertDiv, document.querySelector('.form-card'));
            
            // Auto dismiss after 5 seconds
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }
        
        function previewProduct() {
            // Open preview in new tab
            const form = document.getElementById('productForm');
            const formData = new FormData(form);
            formData.set('action', 'preview');
            formData.set('detailedDescription', quill.root.innerHTML);
            
            // Create temporary form for preview
            const tempForm = document.createElement('form');
            tempForm.method = 'POST';
            tempForm.action = 'seller-product-management';
            tempForm.target = '_blank';
            
            for (let [key, value] of formData.entries()) {
                if (typeof value === 'string') {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    tempForm.appendChild(input);
                }
            }
            
            document.body.appendChild(tempForm);
            tempForm.submit();
            document.body.removeChild(tempForm);
        }
        
        // Auto-save functionality (disabled for now)
        // let autoSaveTimer;
        // function startAutoSave() {
        //     autoSaveTimer = setInterval(() => {
        //         if (document.getElementById('name').value.trim()) {
        //             saveAsDraft();
        //         }
        //     }, 30000);
        // }
        
        // function saveAsDraft() {
        //     // Auto-save disabled
        //     console.log('Auto-save feature disabled');
        // }
        
        // Start auto-save when page loads (disabled)
        // startAutoSave();
        
        // Clear auto-save timer when leaving page
        // window.addEventListener('beforeunload', () => {
        //     clearInterval(autoSaveTimer);
        // });
        
        // Sidebar toggle functionality
        document.addEventListener('DOMContentLoaded', function() {
            const toggleBtn = document.querySelector('.seller-toggle-sidebar');
            const mainContent = document.getElementById('mainContent');
            
            if (toggleBtn && mainContent) {
                toggleBtn.addEventListener('click', function() {
                    mainContent.classList.toggle('expanded');
                });
            }
        });
    </script>
</body>
</html>
