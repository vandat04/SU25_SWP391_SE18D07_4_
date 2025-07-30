<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${isEdit}">Edit Product</c:when>
            <c:otherwise>Add New Product</c:otherwise>
        </c:choose>
        - Seller Dashboard
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <link rel="stylesheet" href="assets/css/seller.css">

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
            padding: 1.5rem; /* Add padding to main content */
        }

        .main-content.expanded {
            margin-left: 0;
        }

        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
            }
        }

        .content-header {
            background-color: #ffffff;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 1.5rem; /* Add margin-bottom for separation */
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
            font-weight: 500; /* Make separator bolder */
        }

        .breadcrumb-item a {
            color: #6b7280;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .breadcrumb-item a:hover {
            color: #3b82f6;
        }

        .breadcrumb-item.active {
            color: #374151;
            font-weight: 600; /* Make active bolder */
        }

        .detail-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem; /* Add margin-bottom */
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid #e2e8f0; /* Add a subtle border */
        }

        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .card-header {
            background: #e0e7ff;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #c3daff; /* Darker border for header */
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-header h5 {
            color: #1e293b;
            font-weight: 700; /* Make title bolder */
            margin: 0;
            display: flex;
            align-items: center;
        }

        .card-header .fas {
            color: #3b82f6; /* Consistent blue for icons in header */
        }

        .info-table th {
            font-weight: 600; /* Make table headers bolder */
            color: #374151;
            vertical-align: middle;
            padding-top: 0.75rem;
            padding-bottom: 0.75rem;
        }

        .info-table td {
            vertical-align: middle;
            padding-top: 0.75rem;
            padding-bottom: 0.75rem;
        }

        .form-control,
        .form-select {
            border-color: #cbd5e1; /* Slightly darker border */
            border-radius: 0.5rem;
            padding: 0.75rem 1rem; /* Increase padding */
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            background-color: #f8fafc; /* Light background for inputs */
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.25); /* Larger shadow */
            background-color: #ffffff;
        }

        /* Styling for input groups with icons */
        .input-group-icon {
            position: relative;
        }

        .input-group-icon .form-control,
        .input-group-icon .form-select {
            padding-left: 2.5rem; /* Space for the icon */
        }

        .input-group-icon .form-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            pointer-events: none; /* Icon should not interfere with input */
            z-index: 2; /* Ensure icon is above input */
        }
        
        /* Specific adjustments for select elements with icons */
        .input-group-icon .form-select {
            -webkit-appearance: none; /* Remove default arrow */
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 0.65em 0.65em;
        }
        .input-group-icon .form-select.has-icon {
            padding-right: 2.5rem; /* Add padding for custom arrow */
        }


        .img-thumbnail {
            border: 1px solid #e2e8f0; /* Add border to thumbnail */
            border-radius: 0.75rem;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .img-thumbnail:hover {
            transform: scale(1.02); /* Slight scale on hover */
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }

        .btn-outline-info {
            border-color: #60a5fa;
            color: #3b82f6; /* Darker blue for text */
            transition: all 0.2s ease;
        }

        .btn-outline-info:hover {
            background: #3b82f6; /* Darker blue on hover */
            color: white;
            border-color: #3b82f6;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border: none;
            transition: all 0.2s ease;
            padding: 0.75rem 1.5rem; /* Larger padding for buttons */
            border-radius: 0.75rem;
            font-weight: 600;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .btn-outline-secondary {
            border-color: #94a3b8; /* Darker grey for border */
            color: #475569; /* Darker grey for text */
            transition: all 0.2s ease;
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
        }

        .btn-outline-secondary:hover {
            background: #64748b; /* Darker grey on hover */
            color: white;
            border-color: #64748b;
        }

        .form-text {
            font-size: 0.875rem;
            color: #6b7280;
            display: flex;
            align-items: center;
            margin-top: 0.5rem;
        }
        .form-text .fas {
            margin-right: 0.5rem;
            color: #60a5fa;
        }
        
        /* Specific style for badge */
        .badge.bg-light.text-dark {
            background-color: #e2e8f0 !important;
            color: #374151 !important;
            padding: 0.5em 0.8em;
            font-size: 0.9em;
            border-radius: 0.5rem;
        }
        
        .badge.bg-info {
            background-color: #60a5fa !important;
            color: white !important;
        }

    </style>
</head>
<body>
    <div class="dashboard-layout">
        <jsp:include page="seller-sidebar.jsp" />

        <div class="main-content" id="mainContent">
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <div class="mb-3 mb-md-0">
                        <h1 class="h3 mb-1">
                            <c:choose>
                                <c:when test="${isEdit}">Edit Product</c:when>
                                <c:otherwise>Add New Product</c:otherwise>
                            </c:choose>
                        </h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item">
                                    <a href="seller-dashboard">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="seller-product-management">Product Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    <c:choose>
                                        <c:when test="${isEdit}">Edit Product</c:when>
                                        <c:otherwise>Add New Product</c:otherwise>
                                    </c:choose>
                                </li>
                            </ol>
                        </nav>
                    </div>
                    <div class="d-flex gap-2 align-items-center flex-wrap">
                        <button type="button" class="seller-toggle-sidebar btn btn-outline-primary d-lg-none">
                            <i class="fas fa-bars"></i>
                        </button>
                        <c:if test="${isEdit}">
                            <a href="seller-product-management?action=view&id=${product.pid}" class="btn btn-outline-info">
                                <i class="fas fa-eye me-2"></i>View Details
                            </a>
                        </c:if>
                        <a href="seller-product-management" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back
                        </a>
                    </div>
                </div>
            </div>

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
                        <div class="col-lg-6 mb-4">
                            <div class="detail-card h-100">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-info-circle me-2"></i>Product Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <table class="table info-table">
                                        <tbody>
                                            <tr>
                                                <th width="35%">Product Name:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-box-open form-icon"></i>
                                                        <input type="text" class="form-control" name="name"
                                                               value="${product.name}" required>
                                                    </div>
                                                </td>
                                            </tr>
                                            <c:if test="${isEdit}">
                                                <tr>
                                                    <th>Product ID:</th>
                                                    <td><span class="badge bg-light text-dark">#${product.pid}</span></td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <th>Price (VND):</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-dollar-sign form-icon"></i>
                                                        <input type="number" class="form-control" name="price"
                                                               value="${product.price}" min="0" step="any" required>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Stock Quantity:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-warehouse form-icon"></i>
                                                        <input type="number" class="form-control" name="stock"
                                                               value="${product.stock}" min="0" required>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Status:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-check-circle form-icon"></i>
                                                        <select class="form-select has-icon" name="status">
                                                            <option value="1" ${product.status == 1 ? 'selected' : ''}>Active</option>
                                                            <option value="0" ${product.status == 0 ? 'selected' : ''}>Inactive</option>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Craft Village:</th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isEdit}">
                                                            <c:forEach items="${sellerVillages}" var="village">
                                                                <c:if test="${product.villageID == village.villageID}">
                                                                    <div class="input-group-icon">
                                                                        <i class="fas fa-building form-icon"></i>
                                                                        <input type="text" class="form-control" value="${village.villageName}" readonly>
                                                                        <input type="hidden" name="villageId" value="${village.villageID}">
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="input-group-icon">
                                                                <i class="fas fa-building form-icon"></i>
                                                                <select class="form-select has-icon" name="villageId" required>
                                                                    <option value="">Select Craft Village</option>
                                                                    <c:forEach items="${sellerVillages}" var="village">
                                                                        <option value="${village.villageID}">
                                                                            ${village.villageName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Category:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-tags form-icon"></i>
                                                        <select class="form-select has-icon" name="categoryId" required>
                                                            <option value="">Select Category</option>
                                                            <c:forEach items="${categories}" var="category">
                                                                <option value="${category.categoryID}"
                                                                        ${product.categoryID == category.categoryID ? 'selected' : ''}>
                                                                    ${category.categoryName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Craft Type:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-tools form-icon"></i>
                                                        <select class="form-select has-icon" name="craftTypeId">
                                                            <option value="">Select Craft Type</option>
                                                            <c:forEach items="${craftTypes}" var="craftType">
                                                                <option value="${craftType.typeID}"
                                                                        ${product.craftTypeID == craftType.typeID ? 'selected' : ''}>
                                                                    ${craftType.typeName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>SKU Code:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-qrcode form-icon"></i>
                                                        <input type="text" class="form-control" name="sku"
                                                               value="${product.sku}">
                                                    </div>
                                                </td>
                                            </tr>
                                            <c:if test="${isEdit}">
                                                <tr>
                                                    <th>Created Date:</th>
                                                    <td>
                                                        <span class="text-muted">
                                                            <i class="fas fa-calendar-alt me-1"></i>
                                                            <fmt:formatDate value="${product.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Views:</th>
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

                        <div class="col-lg-6 mb-4">
                            <div class="detail-card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-file-alt me-2"></i>Product Description
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label d-flex align-items-center"><i class="fas fa-comment-alt me-2 text-primary"></i>Short Description:</label>
                                        <textarea class="form-control" name="description" rows="3">${product.description}</textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-cogs me-2"></i>Product Specifications
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <table class="table info-table">
                                        <tbody>
                                            <tr>
                                                <th width="35%">Dimensions:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-ruler form-icon"></i>
                                                        <input type="text" class="form-control" name="dimensions"
                                                               value="${product.dimensions}">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Weight:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-weight-hanging form-icon"></i>
                                                        <input type="number" class="form-control" name="weight"
                                                               value="${product.weight}" step="any" min="0">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Materials:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-palette form-icon"></i>
                                                        <input type="text" class="form-control" name="materials"
                                                               value="${product.materials}">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Care Instructions:</th>
                                                <td>
                                                    <label class="form-label d-flex align-items-center mb-1"><i class="fas fa-heartbeat me-2 text-primary"></i></label>
                                                    <textarea class="form-control" name="careInstructions" rows="2">${product.careInstructions}</textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Warranty:</th>
                                                <td>
                                                    <div class="input-group-icon">
                                                        <i class="fas fa-shield-alt form-icon"></i>
                                                        <input type="text" class="form-control" name="warranty"
                                                               value="${product.warranty}">
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="detail-card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-images me-2"></i>Product Images
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:if test="${isEdit && not empty product.mainImageUrl}">
                                        <div class="mb-3">
                                            <label class="form-label d-flex align-items-center"><i class="fas fa-image me-2 text-primary"></i>Current Image:</label>
                                            <div class="text-center p-3 border rounded-3 bg-light">
                                                <img src="${product.mainImageUrl}" alt="${product.name}"
                                                     class="img-thumbnail" style="max-height: 200px; object-fit: contain;">
                                            </div>
                                        </div>
                                    </c:if>
                                    <div class="mb-3">
                                        <label class="form-label d-flex align-items-center"><i class="fas fa-upload me-2 text-primary"></i>Add/Change Product Images:</label>
                                        <input type="file" class="form-control" name="images" multiple accept="image/*">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle"></i>
                                            Select multiple images, the first image will be the main image
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12">
                            <div class="detail-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <a href="seller-product-management" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>
                                            <c:choose>
                                                <c:when test="${isEdit}">Update Product</c:when>
                                                <c:otherwise>Add Product</c:otherwise>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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