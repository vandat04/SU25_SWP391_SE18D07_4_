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
    
    <!-- Preconnect fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&family=Playfair+Display:wght@400;600;700&family=Poppins:wght@600&family=Ubuntu&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <style>
        :root {
            --background-color: #f9f9f9;
            --sidebar-bg: #10b981;
            --sidebar-hover-bg: #059669;
            --primary-text: #1e293b;
            --secondary-text: #64748b;
            --accent-color: #10b981;
            --accent-hover: #059669;
            --alternate-color: #3b82f6;
            --alternate-hover: #2563eb;
            --border-color: #e2e8f0;
            --shadow-color: rgba(0, 0, 0, 0.1);
            --font-heading: 'Playfair Display', serif;
            --font-body: 'Cairo', sans-serif;
            --success-bg: #e9f7ef;
            --success-border: #b8e9d1;
            --success-text: #1e6641;
        }
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: var(--font-body);
            background-color: var(--background-color);
            color: var(--primary-text);
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar { 
            width: 260px; 
            background-color: var(--sidebar-bg); 
            border-right: 1px solid var(--border-color); 
            display: flex; 
            flex-direction: column; 
            color: #fff; 
        }
        
        .sidebar-logo { 
            padding: 1.5rem 2rem; 
            text-align: center; 
            border-bottom: 1px solid var(--alternate-color); 
        }
        
        .sidebar-logo img { 
            max-width: 80%; 
            height: auto; 
            filter: brightness(0) invert(1); 
        }
        
        .sidebar-profile { 
            text-align: center; 
            padding: 2rem 1rem; 
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--alternate-color) 100%); 
            border-bottom: 1px solid var(--border-color); 
        }
        
        .sidebar-profile .avatar { 
            width: 80px; 
            height: 80px; 
            border-radius: 50%; 
            object-fit: cover; 
            border: 3px solid #fff; 
            margin-bottom: 1rem; 
        }
        
        .sidebar-profile h3 { 
            font-family: var(--font-heading); 
            font-size: 1.2rem; 
            margin-bottom: 0.25rem; 
            color: #fff; 
        }
        
        .sidebar-profile p { 
            font-size: 0.9rem; 
            color: #f0f0f0; 
        }
        
        .sidebar-nav { 
            list-style-type: none; 
            flex-grow: 1; 
            margin-top: 1rem; 
        }
        
        .sidebar-nav a { 
            display: flex; 
            align-items: center; 
            padding: 1rem 2rem; 
            color: #fff; 
            text-decoration: none; 
            font-weight: 500; 
            transition: background-color 0.2s, color 0.2s; 
            border-left: 4px solid transparent; 
        }
        
        .sidebar-nav a:nth-child(odd) { 
            background: linear-gradient(90deg, var(--accent-color) 0%, var(--alternate-color) 100%); 
        }
        
        .sidebar-nav a:nth-child(even) { 
            background: linear-gradient(90deg, var(--alternate-color) 0%, var(--accent-color) 100%); 
        }
        
        .sidebar-nav a:hover, .sidebar-nav a.active { 
            background: var(--sidebar-hover-bg); 
            color: #fff; 
            border-left-color: #fff; 
        }
        
        .sidebar-nav a i { 
            width: 25px; 
            margin-right: 1rem; 
            font-size: 1.1rem; 
            text-align: center; 
        }
        
        .sidebar-logout { 
            padding: 1rem 0; 
            border-top: 1px solid var(--alternate-color); 
        }
        
        .sidebar-logout a { 
            text-decoration: none; 
            color: #fff; 
            background: var(--accent-color); 
            padding: 1rem 2rem; 
            display: block; 
            transition: background-color 0.2s; 
        }
        
        .sidebar-logout a:hover { 
            background: var(--accent-hover); 
        }
        
        .main-content { 
            flex-grow: 1; 
            padding: 2rem 3rem; 
            overflow-y: auto; 
            background-color: #f1f5f9; 
        }
        
        .main-header { 
            margin-bottom: 2rem; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .main-header h1 { 
            font-family: var(--font-heading); 
            font-size: 2.5rem; 
            font-weight: 700; 
            color: var(--primary-text); 
            margin: 0; 
            display: flex; 
            align-items: center; 
            gap: 0.5rem; 
        }
        
        .main-header p { 
            color: var(--secondary-text); 
            font-size: 1rem; 
        }
        
        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
            font-size: 0.875rem;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "/";
            color: var(--secondary-text);
        }
        
        .breadcrumb-item a {
            color: var(--secondary-text);
            text-decoration: none;
        }
        
        .breadcrumb-item a:hover {
            color: var(--accent-color);
        }
        
        .breadcrumb-item.active {
            color: var(--primary-text);
            font-weight: 500;
        }
        
        .detail-card {
            background: linear-gradient(135deg, #ffffff 0%, var(--success-bg) 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px var(--shadow-color);
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px var(--shadow-color);
        }
        
        .card-header {
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--alternate-color) 100%);
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }
        
        .card-header h5 {
            color: #fff;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-table th {
            font-weight: 500;
            color: var(--primary-text);
            vertical-align: middle;
        }
        
        .info-table td {
            vertical-align: middle;
        }
        
        .form-control {
            border-color: var(--border-color);
            border-radius: 0.5rem;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        
        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.25);
        }
        
        .form-select {
            border-color: var(--border-color);
            border-radius: 0.5rem;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        
        .form-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.25);
        }
        
        .img-thumbnail {
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 2px 5px var(--shadow-color);
            transition: transform 0.2s ease;
        }
        
        .img-thumbnail:hover {
            transform: scale(1.05);
        }
        
        .btn-outline-info {
            border-color: var(--alternate-color);
            color: var(--alternate-color);
        }
        
        .btn-outline-info:hover {
            background: var(--alternate-color);
            color: white;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--accent-color), var(--alternate-color));
            border: none;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--accent-hover), var(--alternate-hover));
        }
        
        .btn-outline-secondary {
            border-color: var(--secondary-text);
            color: var(--secondary-text);
        }
        
        .btn-outline-secondary:hover {
            background: var(--secondary-text);
            color: white;
        }
        
        @media (max-width: 1024px) {
            .main-content {
                padding: 1rem;
            }
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                z-index: 1000;
            }
            .sidebar.active {
                transform: translateX(0);
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
                                <c:when test="${isEdit}">
                                    <i class="fas fa-edit me-2"></i>Edit Product
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-plus-circle me-2 text-success"></i>Add New Product
                                </c:otherwise>
                            </c:choose>
                        </h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item">
                                    <a href="seller-dashboard" class="text-decoration-none">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="seller-product-management" class="text-decoration-none">Product Management</a>
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
                    <div class="d-flex gap-2 align-items-center">
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
                                        <i class="fas fa-info-circle me-2 text-white"></i>Product Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <table class="table info-table">
                                        <tbody>
                                            <tr>
                                                <th width="35%">Product Name:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="name" 
                                                           value="${product.name}" required>
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
                                                    <input type="number" class="form-control" name="price" 
                                                           value="${product.price}" min="0" step="any">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Stock Quantity:</th>
                                                <td>
                                                    <input type="number" class="form-control" name="stock" 
                                                           value="${product.stock}" min="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Status:</th>
                                                <td>
                                                    <select class="form-select" name="status">
                                                        <option value="1" ${product.status == 1 ? 'selected' : ''}>Active</option>
                                                        <option value="0" ${product.status == 0 ? 'selected' : ''}>Inactive</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Craft Village:</th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isEdit}">
                                                            <!-- Readonly for edit - show current village -->
                                                            <c:forEach items="${sellerVillages}" var="village">
                                                                <c:if test="${product.villageID == village.villageID}">
                                                                    <input type="text" class="form-control" value="${village.villageName}" readonly>
                                                                    <input type="hidden" name="villageId" value="${village.villageID}">
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- Editable for new product -->
                                                            <select class="form-select" name="villageId" required>
                                                                <option value="">Select Craft Village</option>
                                                                <c:forEach items="${sellerVillages}" var="village">
                                                                    <option value="${village.villageID}">
                                                                        ${village.villageName}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Category:</th>
                                                <td>
                                                    <select class="form-select" name="categoryId" required>
                                                        <option value="">Select Category</option>
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
                                                <th>Craft Type:</th>
                                                <td>
                                                    <select class="form-select" name="craftTypeId">
                                                        <option value="">Select Craft Type</option>
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
                                                <th>SKU Code:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="sku" 
                                                           value="${product.sku}">
                                                </td>
                                            </tr>
                                            <c:if test="${isEdit}">
                                                <tr>
                                                    <th>Created Date:</th>
                                                    <td>
                                                        <span class="text-muted">
                                                            <i class="fas fa-calendar me-1"></i>
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

                        <!-- Right Column - Additional Information -->
                        <div class="col-lg-6">
                            <!-- Description Section -->
                            <div class="detail-card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-file-alt me-2 text-white"></i>Product Description
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label">Short Description:</label>
                                        <textarea class="form-control" name="description" rows="3">${product.description}</textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Product Specifications -->
                            <div class="detail-card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-cogs me-2 text-white"></i>Product Specifications
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <table class="table info-table">
                                        <tbody>
                                            <tr>
                                                <th width="35%">Dimensions:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="dimensions" 
                                                           value="${product.dimensions}">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Weight:</th>
                                                <td>
                                                    <input type="number" class="form-control" name="weight" 
                                                           value="${product.weight}" step="any" min="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Materials:</th>
                                                <td>
                                                    <input type="text" class="form-control" name="materials" 
                                                           value="${product.materials}">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Care Instructions:</th>
                                                <td>
                                                    <textarea class="form-control" name="careInstructions" rows="2">${product.careInstructions}</textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Warranty:</th>
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
                                        <i class="fas fa-images me-2 text-white"></i>Product Images
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:if test="${isEdit && not empty product.mainImageUrl}">
                                        <div class="mb-3">
                                            <label class="form-label">Current Image:</label>
                                            <div class="text-center">
                                                <img src="${product.mainImageUrl}" alt="${product.name}" 
                                                     class="img-thumbnail" style="max-height: 200px;">
                                            </div>
                                        </div>
                                    </c:if>
                                    <div class="mb-3">
                                        <label class="form-label">Add/Change Product Images:</label>
                                        <input type="file" class="form-control" name="images" multiple accept="image/*">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Select multiple images, the first image will be the main image
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Sidebar toggle functionality -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggleBtn = document.querySelector('.seller-toggle-sidebar');
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.createElement('div');
            overlay.className = 'sidebar-overlay';
            overlay.style.cssText = 'display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 999;';
            document.body.appendChild(overlay);
            
            if (toggleBtn && sidebar) {
                toggleBtn.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                    overlay.style.display = sidebar.classList.contains('active') ? 'block' : 'none';
                });
            }
            
            overlay.addEventListener('click', () => {
                sidebar.classList.remove('active');
                overlay.style.display = 'none';
            });
        });
    </script>