<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <title>Danh mục sản phẩm - Da Nang Craft Village</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/animate.min.css">
    <link rel="stylesheet" href="assets/css/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <link rel="stylesheet" href="assets/css/slick.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/main-color03-green.css">
    <link rel="shortcut icon" href="hinhanh/Logo/cropped-Favicon-1-32x32.png" />
    <script>
        function addToCart(productId, quantity) {
            fetch("cart?action=add&id=" + productId + "&quantity=" + quantity, {
                method: "POST",
                credentials: 'same-origin'
            })
            .then(response => {
                if (response.redirected) {
                    alert("Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!");
                    window.location.href = 'Login.jsp';
                    return;
                }
                alert("Đã thêm sản phẩm vào giỏ hàng!");
            })
            .catch(error => {
                console.error("Lỗi:", error);
            });
        }

        function submitForm() {
            document.getElementById("filterForm").submit();
        }
    </script>
</head>
<body class="biolife-body">

    <jsp:include page="Menu.jsp"></jsp:include>

<div class="page-contain" style="padding: 60px 0; background: #f9f9f9; margin-top: 100px;">
    <div class="container">
        <div class="row">
            <!-- Sidebar bộ lọc -->
            <div class="col-12 col-md-3">
                <div class="top-functions-area">
                    <div class="flt-item to-left group-on-mobile">
                        <span class="flt-title">Lọc sản phẩm</span>
                        <div class="wrap-selectors">
                            <form id="filterForm" method="get" action="${not empty searchKeyword ? 'search' : 'category'}">
                                <c:if test="${empty searchKeyword}">
                                    <input type="hidden" name="cid" value="${cid}">
                                </c:if>
                                <c:if test="${not empty searchKeyword}">
                                    <input type="hidden" name="txt" value="${searchKeyword}">
                                </c:if>
                                <!-- Lọc giá -->
                                <div class="selector-item">
                                    <label>Giá:</label>
                                    <select name="price" class="selector" onchange="submitForm()">
                                        <option value="all" ${selectedPrice == 'all' ? 'selected' : ''}>Tất cả</option>
                                        <option value="0-100000" ${selectedPrice == '0-100000' ? 'selected' : ''}>Dưới 100.000</option>
                                        <option value="100000-500000" ${selectedPrice == '100000-500000' ? 'selected' : ''}>100.000 - 500.000</option>
                                        <option value="500000-1000000" ${selectedPrice == '500000-1000000' ? 'selected' : ''}>500.000 - 1 triệu</option>
                                        <option value="1000000+" ${selectedPrice == '1000000+' ? 'selected' : ''}>Trên 1 triệu</option>
                                    </select>
                                </div>
                                <!-- Sắp xếp -->
                                <div class="selector-item" style="margin-top: 15px;">
                                    <label>Sắp xếp:</label>
                                    <select name="orderby" class="selector" onchange="submitForm()">
                                        <option value="menu_order" ${orderby == 'menu_order' ? 'selected' : ''}>Mặc định</option>
                                        <option value="name_asc" ${orderby == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                                        <option value="name_desc" ${orderby == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                                        <option value="price_asc" ${orderby == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                                        <option value="price_desc" ${orderby == 'price_desc' ? 'selected' : ''}>Giá: Cao đến Thấp</option>
                                    </select>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Sản phẩm mới -->
                <div class="widget biolife-filter" style="margin-top: 30px;">
                    <h4 class="wgt-title">Sản phẩm mới</h4>
                    <div class="wgt-content">
                        <ul class="products">
                            <c:forEach var="p" items="${list5}">
                                <li class="pr-item">
                                    <div class="contain-product style-widget">
                                        <div class="product-thumb">
                                            <a href="detail?pid=${p.id}" class="link-to-product">
                                                <img src="${p.img}" alt="${p.name}" width="100" height="100" class="product-thumnail">
                                            </a>
                                        </div>
                                        <div class="info">
                                            <span class="categories">
                                                <c:forEach var="cat" items="${listCC}">
                                                    <c:if test="${cat.categoryID == p.cateID}">${cat.categoryName}</c:if>
                                                </c:forEach>
                                            </span>
                                            <h4 class="product-title"><a href="detail?pid=${p.id}" class="pr-name">${p.name}</a></h4>
                                            <div class="price">
                                                <ins><span class="price-amount"><fmt:formatNumber value="${p.price}" type="currency"/></span></ins>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Danh sách sản phẩm -->
            <div class="col-12 col-md-9">
                <div class="biolife-title-box">
                    <c:choose>
                        <c:when test="${not empty searchKeyword}">
                            <h3 class="main-title">Kết quả tìm kiếm: "${searchKeyword}"</h3>
                            <p class="search-results-info">Tìm thấy ${fn:length(listP)} sản phẩm</p>
                        </c:when>
                        <c:otherwise>
                            <h3 class="main-title">Danh mục sản phẩm</h3>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="product-grid">
                    <c:choose>
                        <c:when test="${empty listP}">
                            <div class="no-results">
                                <h4>Không tìm thấy sản phẩm nào</h4>
                                <p>Không có sản phẩm nào phù hợp với từ khóa "${searchKeyword}". Vui lòng thử lại với từ khóa khác.</p>
                                <a href="product" class="btn">Xem tất cả sản phẩm</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row">
                                <c:set var="pageSize" value="9" />
                                <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
                                <c:set var="start" value="${(currentPage - 1) * pageSize}" />
                                <c:set var="end" value="${start + pageSize}" />
                                <c:set var="totalProducts" value="${fn:length(listP)}" />
                                <c:set var="totalPages" value="${(totalProducts % pageSize == 0) ? (totalProducts / pageSize) : (totalProducts / pageSize + 1)}" />
                                <c:forEach var="o" items="${listP}" varStatus="status">
                            <c:if test="${status.index >= start && status.index < end}">
                                <div class="col-12 col-md-6 col-lg-4">
                                    <div class="product-item">
                                        <div class="contain-product layout-default">
                                            <div class="product-thumb">
                                                <a href="detail?pid=${o.id}" class="link-to-product">
                                                    <figure style="width:100%;height:270px;overflow:hidden;background-color:#f8f8f8;border-radius:8px;">
                                                        <img src="${o.img}" alt="${o.name}" style="width:100%;height:100%;object-fit:contain;">
                                                    </figure>
                                                </a>
                                            </div>
                                            <div class="info" style="padding: 15px;">
                                                <span class="categories">
                                                    <c:forEach var="cat" items="${listCC}">
                                                        <c:if test="${cat.categoryID == o.cateID}">${cat.categoryName}</c:if>
                                                    </c:forEach>
                                                </span>
                                                <h4 class="product-title"><a href="detail?pid=${o.id}" class="pr-name">${o.name}</a></h4>
                                                <div class="price">
                                                    <ins><span class="price-amount"><fmt:formatNumber value="${o.price}" type="currency"/></span></ins>
                                                </div>
                                                <div class="slide-down-box">
                                                    <div class="buttons" style="display:flex;gap:10px;justify-content:center;">
                                                        <form action="wishlist" method="post">
                                                            <input type="hidden" name="action" value="add">
                                                            <input type="hidden" name="userID" value="<%= session.getAttribute("userID") %>">
                                                            <input type="hidden" name="productID" value="${o.id}">
                                                            <input type="hidden" name="returnUrl" value="category?cid=${cid}">
                                                            <button type="submit" class="btn wishlist-btn" style="background:#fff;border:1px solid #4CAF50;color:#4CAF50;padding:8px 15px;border-radius:4px;" onclick="return confirm('Thêm sản phẩm vào wishlist?')">
                                                                <i class="fa fa-heart"></i>
                                                            </button>
                                                        </form>
                                                        <a onclick="addToCart('${o.id}', 1)" class="btn add-to-cart-btn" style="background:#4CAF50;color:#fff;padding:8px 15px;border-radius:4px;text-decoration:none;">
                                                            <i class="fa fa-cart-arrow-down"></i> Thêm vào giỏ
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Phân trang -->
                <c:if test="${not empty listP}">
                    <div class="pagination" style="display:flex;justify-content:center;align-items:center;margin-top:20px;">
                        <c:choose>
                            <c:when test="${not empty searchKeyword}">
                                <!-- Search pagination -->
                                <c:if test="${currentPage > 1}">
                                    <a href="search?txt=${searchKeyword}&page=${currentPage - 1}&price=${selectedPrice}&orderby=${orderby}" class="prev">&laquo; Trước</a>
                                </c:if>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="search?txt=${searchKeyword}&page=${i}&price=${selectedPrice}&orderby=${orderby}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="search?txt=${searchKeyword}&page=${currentPage + 1}&price=${selectedPrice}&orderby=${orderby}" class="next">Sau &raquo;</a>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <!-- Category pagination -->
                                <c:if test="${currentPage > 1}">
                                    <a href="category?cid=${cid}&page=${currentPage - 1}&price=${selectedPrice}&orderby=${orderby}" class="prev">&laquo; Trước</a>
                                </c:if>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="category?cid=${cid}&page=${i}&price=${selectedPrice}&orderby=${orderby}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="category?cid=${cid}&page=${currentPage + 1}&price=${selectedPrice}&orderby=${orderby}" class="next">Sau &raquo;</a>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script src="assets/js/jquery-3.4.1.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/jquery.countdown.min.js"></script>
<script src="assets/js/jquery.nice-select.min.js"></script>
<script src="assets/js/jquery.nicescroll.min.js"></script>
<script src="assets/js/slick.min.js"></script>
<script src="assets/js/biolife.framework.js"></script>
<script src="assets/js/functions.js"></script>

<style>
    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 20px;
        gap: 4px;
    }
    .pagination a {
        padding: 8px 16px;
        margin: 0 2px;
        border: 1px solid #ddd;
        text-decoration: none;
        color: #333;
        border-radius: 4px;
        display: inline-block;
        min-width: 40px;
        text-align: center;
    }
    .pagination a:hover, .pagination a.active {
        background-color: #4CAF50;
        color: white;
    }
    .pagination a.prev, .pagination a.next {
        font-weight: bold;
    }
    /* Ensure slide-down-box works properly */
    .product-grid .product-item {
        overflow: visible;
        margin-bottom: 40px; /* Add extra space for slide-down effect */
    }
    .product-grid .contain-product {
        position: relative;
        overflow: visible;
    }
    .product-grid .contain-product .info {
        position: relative;
        z-index: 1;
    }
    /* Ensure slide-down-box appears properly on hover */
    .product-grid .slide-down-box {
        z-index: 10;
    }
    /* Smooth transition for product hover effect */
    .product-grid .contain-product.layout-default {
        transition: all 0.3s ease;
    }
    .product-grid .contain-product.layout-default:hover {
        transform: translateY(-2px);
    }
    /* Make sure buttons are accessible when slide-down appears */
    .product-grid .slide-down-box .buttons {
        padding: 10px 15px;
    }
    /* Category styling */
    .categories {
        color: #4CAF50;
        font-size: 12px;
        text-transform: uppercase;
        margin-bottom: 5px;
        display: block;
        font-weight: normal !important;
    }
    
    /* Ensure normal font weight for product titles */
    .product-title {
        font-weight: normal !important;
    }
    
    .product-title a {
        font-weight: normal !important;
    }
    
    /* Ensure normal font weight for price */
    .price {
        font-weight: normal !important;
    }
    
    .price-amount {
        font-weight: 600 !important; /* Only price amount should be bold */
    }
    
    /* Ensure normal font weight for labels */
    label {
        font-weight: normal !important;
    }
    
    /* Font weight reset for category page content only */
    .page-contain .product-grid {
        font-weight: normal !important;
    }
    
    .page-contain .product-grid * {
        font-weight: normal !important;
    }
    
    .page-contain .widget {
        font-weight: normal !important;
    }
    
    .page-contain .widget * {
        font-weight: normal !important;
    }
    
    /* Exceptions for elements that should be bold */
    .price-amount,
    .btn,
    .pagination a.prev,
    .pagination a.next,
    .wgt-title,
    .main-title,
    .flt-title {
        font-weight: bold !important;
    }
    
    /* Ensure menu and navigation are not affected */
    .biolife-body,
    .biolife-body *,
    .biolife-body .biolife-nav,
    .biolife-body .biolife-nav *,
    .biolife-body .biolife-header,
    .biolife-body .biolife-header * {
        font-weight: inherit !important;
    }
    
    /* Ensure filter forms and selectors are not affected */
    .top-functions-area,
    .top-functions-area *,
    .wrap-selectors,
    .wrap-selectors *,
    .selector-item,
    .selector-item * {
        font-weight: inherit !important;
    }
    
    /* Search results styling */
    .search-results-info {
        color: #666;
        font-size: 14px;
        margin-top: 5px;
        font-style: italic;
    }
    
    /* No results message */
    .no-results {
        text-align: center;
        padding: 40px 20px;
        color: #666;
    }
    
    .no-results h4 {
        color: #333;
        margin-bottom: 10px;
    }
    
    .no-results p {
        margin-bottom: 20px;
    }
    
    .no-results .btn {
        background: #4CAF50;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 4px;
        display: inline-block;
    }
</style>
</body>
</html>
