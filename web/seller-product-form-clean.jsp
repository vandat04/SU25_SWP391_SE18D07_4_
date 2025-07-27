<%-- 
    Document   : seller-product-form
    Created on : Jul 27, 2025
    Author     : GitHub Copilot
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-2">
                                <li class="breadcrumb-item">
                                    <a href="seller-dashboard.jsp" class="text-decoration-none">Dashboard</a>
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
                                                           value="${product.weight}" step="0.01" min="0">
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
    
    <!-- Sidebar toggle functionality -->
    <script>
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
