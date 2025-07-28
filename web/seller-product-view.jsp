<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Detail - Seller Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
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
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .detail-card .card-header {
            background: #e0e7ff;
            border-bottom: 1px solid #e2e8f0;
            border-radius: 1rem 1rem 0 0;
            padding: 1.25rem 1.5rem;
        }
        
        .detail-card .card-body {
            padding: 1.5rem;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .status-active {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: 1px solid #047857;
        }
        
        .status-inactive {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            color: white;
            border: 1px solid #374151;
        }
        
        .product-image-main {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 2px solid #e2e8f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .product-image-main:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 16px rgba(0,0,0,0.2);
        }
        
        .product-image-thumb {
            width: 100%;
            height: 80px;
            object-fit: cover;
            border-radius: 0.375rem;
            border: 2px solid #e2e8f0;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .product-image-thumb:hover {
            border-color: #3b82f6;
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .info-table th {
            font-weight: 600;
            color: #1e293b;
            background: #f1f5f9;
            border: none;
            padding: 1rem;
        }
        
        .info-table td {
            padding: 1rem;
            border: none;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .action-buttons {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid #e2e8f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .action-buttons:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb, #1e40af);
        }
        
        .btn-outline-secondary {
            border-color: #9ca3af;
            color: #9ca3af;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
        }
        
        .btn-outline-secondary:hover {
            background: #9ca3af;
            color: white;
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
                        <h1 class="h3 mb-1">Product Detail</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="seller-dashboard.jsp" class="text-decoration-none">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="seller-product-management" class="text-decoration-none">Product Management</a></li>
                                <li class="breadcrumb-item active">Product Detail</li>
                            </ol>
                        </nav>
                    </div>
                    <div class="d-flex gap-2 align-items-center">
                        <button type="button" class="seller-toggle-sidebar btn btn-outline-primary d-lg-none">
                            <i class="fas fa-bars"></i>
                        </button>
                        <a href="seller-product-management?action=edit&id=${product.pid}" class="btn btn-primary">
                            <i class="fas fa-edit me-2"></i>Edit
                        </a>
                        <a href="seller-product-management" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back
                        </a>
                    </div>
                </div>
            </div>

            <!-- Content Body -->
            <div class="content-body">
            <c:if test="${not empty product}">
                <div class="row">
                    <!-- Product Images -->
                    <div class="col-lg-6">
                        <div class="detail-card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-images me-2 text-primary"></i>Product Images
                                </h5>
                            </div>
                            <div class="card-body">
                                <!-- Main Image -->
                                <div class="mb-4 text-center">
                                    <c:choose>
                                        <c:when test="${not empty product.mainImageUrl}">
                                            <img src="${product.mainImageUrl}" 
                                                 alt="${product.name}" 
                                                 class="product-image-main"
                                                 id="mainProductImage">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="bg-light rounded border d-flex align-items-center justify-content-center" 
                                                 style="height: 400px;">
                                                <div class="text-center text-muted">
                                                    <i class="fas fa-image fa-4x mb-3 text-muted"></i>
                                                    <p class="mb-0 fs-6">No image available</p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Additional Images -->
                                <c:if test="${not empty productImages && fn:length(productImages) > 0}">
                                    <div class="row g-2">
                                        <c:forEach var="image" items="${productImages}">
                                            <div class="col-3">
                                                <div class="position-relative">
                                                    <img src="${image.imageUrl}" 
                                                         alt="${image.altText}" 
                                                         class="product-image-thumb"
                                                         onclick="changeMainImage('${image.imageUrl}')">
                                                    <c:if test="${image.isMain}">
                                                        <span class="position-absolute top-0 start-0 badge bg-primary m-1">
                                                            <i class="fas fa-star fa-xs"></i>
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Product Details -->
                    <div class="col-lg-6">
                        <div class="detail-card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-info-circle me-2 text-primary"></i>Product Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <table class="table info-table">
                                    <tbody>
                                        <tr>
                                            <th width="35%">Product Name:</th>
                                            <td><strong class="text-dark">${product.name}</strong></td>
                                        </tr>
                                        <tr>
                                            <th>Product ID:</th>
                                            <td><span class="badge bg-light text-dark">#${product.pid}</span></td>
                                        </tr>
                                        <tr>
                                            <th>Price:</th>
                                            <td>
                                                <span class="fs-4 fw-bold text-primary">
                                                    <fmt:formatNumber value="${product.price}" type="currency" 
                                                                    currencySymbol="$" groupingUsed="true"/>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Stock Quantity:</th>
                                            <td>
                                                <span class="badge ${product.stock > 10 ? 'bg-success' : product.stock > 0 ? 'bg-warning text-dark' : 'bg-danger'} px-3 py-2">
                                                    <i class="fas fa-box me-1"></i>${product.stock} items
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Status:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.status == 1}">
                                                        <span class="status-badge status-active">
                                                            <i class="fas fa-check-circle me-1"></i>Active
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive">
                                                            <i class="fas fa-ban me-1"></i>Inactive
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Craft Village:</th>
                                            <td>
                                                <i class="fas fa-map-marker-alt text-muted me-1"></i>
                                                ${village.villageName}
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Category:</th>
                                            <td>
                                                <span class="badge bg-secondary px-3 py-2">
                                                    <i class="fas fa-tag me-1"></i>${category.categoryName}
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Views:</th>
                                            <td>
                                                <i class="fas fa-eye text-primary me-1"></i>
                                                <strong>${product.clickCount}</strong> views
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Created Date:</th>
                                            <td>
                                                <i class="fas fa-calendar-plus text-muted me-1"></i>
                                                <fmt:formatDate value="${product.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Updated Date:</th>
                                            <td>
                                                <i class="fas fa-calendar-edit text-muted me-1"></i>
                                                <fmt:formatDate value="${product.updatedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Description Section -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="detail-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-align-left me-2 text-primary"></i>Product Description
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty product.description}">
                                        <div class="formatted-text lh-lg">
                                            ${fn:replace(product.description, newline, '<br>')}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-file-alt fa-2x text-muted mb-2"></i>
                                            <p class="text-muted mb-0 fs-6">No description available for this product.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="action-buttons">
                            <div class="d-flex gap-2 justify-content-end flex-wrap">
                                <a href="seller-product-management?action=edit&id=${product.pid}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-edit me-2"></i>Edit Product
                                </a>
                                <a href="seller-product-management" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back to List
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty product}">
                <div class="detail-card">
                    <div class="card-body text-center py-5">
                        <div class="mb-4">
                            <i class="fas fa-exclamation-triangle fa-4x text-warning"></i>
                        </div>
                        <h4 class="text-muted mb-3">Product Not Found</h4>
                        <p class="text-muted mb-4">
                            The product you are looking for does not exist or has been deleted.
                        </p>
                        <a href="seller-product-management" class="btn btn-primary">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Change main image when clicking on thumbnail
        function changeMainImage(imageUrl) {
            const mainImage = document.getElementById('mainProductImage');
            if (mainImage) {
                mainImage.src = imageUrl;
            }
        }

        // Seller sidebar toggle
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