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
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card">
                    <div class="card-header">
                        <h4>
                            <c:choose>
                                <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
                                <c:otherwise>Thêm sản phẩm mới</c:otherwise>
                            </c:choose>
                        </h4>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="seller-product-management">
                            <c:choose>
                                <c:when test="${isEdit}">
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="id" value="${product.pid}">
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="action" value="add">
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="mb-3">
                                <label for="name" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${product.name}" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="3">${product.description}</textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="price" class="form-label">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="price" name="price" 
                                               value="${product.price}" min="0" step="1000" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="stock" class="form-label">Số lượng tồn kho <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="stock" name="stock" 
                                               value="${product.stock}" min="0" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="villageId" class="form-label">Làng nghề <span class="text-danger">*</span></label>
                                        <select class="form-select" id="villageId" name="villageId" required>
                                            <option value="">Chọn làng nghề</option>
                                            <c:forEach items="${sellerVillages}" var="village">
                                                <option value="${village.villageID}" 
                                                        <c:if test="${product.villageID == village.villageID}">selected</c:if>>
                                                    ${village.villageName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="categoryId" class="form-label">Danh mục <span class="text-danger">*</span></label>
                                        <select class="form-select" id="categoryId" name="categoryId" required>
                                            <option value="">Chọn danh mục</option>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.categoryID}" 
                                                        <c:if test="${product.categoryID == category.categoryID}">selected</c:if>>
                                                    ${category.categoryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="status" class="form-label">Trạng thái</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="1" <c:if test="${product.status == 1}">selected</c:if>>Hoạt động</option>
                                    <option value="0" <c:if test="${product.status == 0}">selected</c:if>>Không hoạt động</option>
                                </select>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="seller-product-management" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${isEdit}">Cập nhật</c:when>
                                        <c:otherwise>Lưu</c:otherwise>
                                    </c:choose>
                                    sản phẩm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
