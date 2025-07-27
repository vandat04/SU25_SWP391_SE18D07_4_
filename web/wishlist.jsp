<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="no-js" lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Wishlist - Da Nang Craft Village</title>

    <!-- Các link CSS của dự án -->
    <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:600&display=swap" rel="stylesheet">
    <link rel="shortcut icon" type="image/x-icon" href="hinhanh/Logo/cropped-Favicon-1-32x32.png" />
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/animate.min.css">
    <link rel="stylesheet" href="assets/css/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <link rel="stylesheet" href="assets/css/slick.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/main-color03-green.css">
    
    <style>
        /* Tùy chỉnh nhỏ cho trang wishlist */
        .wishlist-table img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
        }
        .wishlist-table .product-name {
            font-weight: 600;
        }
        .wishlist-table .action-btn {
            display: inline-block;
            margin: 0 5px;
            padding: 8px 12px;
            border-radius: 4px;
            color: #fff;
            text-decoration: none;
        }
        .btn-add-to-cart-custom {
            background-color: #4CAF50; /* Green */
        }
        .btn-add-to-cart-custom:hover {
            background-color: #45a049;
        }
        .btn-remove-custom {
            background-color: #f44336; /* Red */
        }
        .btn-remove-custom:hover {
            background-color: #da190b;
        }
        .empty-wishlist-container {
            text-align: center;
            padding: 80px 20px;
            background-color: #fff;
            border-radius: 8px;
            border: 1px dashed #ddd;
        }
        .empty-wishlist-container i {
            font-size: 5rem;
            color: #ccc;
        }
        .empty-wishlist-container h3 {
            margin-top: 20px;
            color: #555;
        }
        .empty-wishlist-container .btn {
            margin-top: 20px;
            padding: 10px 30px;
            font-size: 16px;
        }
    </style>
</head>
<body class="biolife-body">

    <!-- HEADER/MENU -->
    <jsp:include page="Menu.jsp"></jsp:include>

    <div class="container">
                <nav class="biolife-nav">
                    <ul>
                        <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                        <li class="nav-item"><span class="current-page">Wishlist</span></li>
                    </ul>
                </nav>
            </div>
    
    <!-- Breadcrumb -->
    <div class="breadcrumb-section" style="background-image: url('assets/images/breadcrumb-bg.jpg'); margin-top: 100px;">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb-text">
                        <h2>Wishlist</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="page-contain wishlist-page" style="padding: 60px 0;">
        <div class="container">
            
            <!-- Messages -->
            <c:if test="${param.error != null}">
                <div class="alert alert-danger" role="alert">
                    <strong>Lỗi!</strong> ${param.error}
                </div>
            </c:if>
            <c:if test="${param.success != null}">
                <div class="alert alert-success" role="alert">
                    <strong>Thành công!</strong> ${param.success}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${wishlistWithProducts != null && !wishlistWithProducts.isEmpty()}">
                    
                    <!-- Nút hành động chung -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <a href="product" class="btn btn-outline-success">
                                <i class="fa fa-arrow-left"></i> Continue shopping
                            </a>
                        </div>
                        <div class="col-md-6 text-right">
                            <button type="button" class="btn btn-success" onclick="moveAllToCart()">
                                <i class="fa fa-cart-plus"></i>Add all to cart
                            </button>
                        </div>
                    </div>
                    
                    <!-- Bảng danh sách sản phẩm yêu thích -->
                    <div class="table-responsive">
                        <table class="table wishlist-table">
                            <thead class="thead-light">
                                <tr>
                                    <th scope="col" colspan="2">Product</th>
                                    <th scope="col">Price</th>
                                    <th scope="col" class="text-center">Created Date</th>
                                    <th scope="col" class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${wishlistWithProducts}">
                                    <tr>
                                        <td style="width: 100px;">
                                            <a href="detail?pid=${item.productID}">
                                                <img src="${item.productImage != null ? item.productImage : 'assets/images/products/default.jpg'}" alt="${item.productName}">
                                            </a>
                                        </td>
                                        <td>
                                            <a href="detail?pid=${item.productID}" class="product-name text-dark">${item.productName}</a>
                                        </td>
                                        <td>
                                            <div class="price">
                                                <ins><span class="price-amount"><fmt:formatNumber value="${item.productPrice}" type="currency"/></span></ins>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatDate value="${item.addedDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td class="text-center">
                                            <!-- Thêm vào giỏ -->
                                            <form action="wishlist" method="post" style="display:inline-block;">
                                                <input type="hidden" name="action" value="addToCart">
                                                <input type="hidden" name="productID" value="${item.productID}">
                                                <input type="hidden" name="wishlistID" value="${item.wishlistID}">
                                                <input type="hidden" name="userID" value="${userID}">
                                                <button type="submit" class="btn btn-sm btn-add-to-cart-custom" title="Thêm vào giỏ hàng">
                                                    <i class="fa fa-cart-plus"></i>
                                                </button>
                                            </form>
                                            
                                            <!-- Xóa khỏi wishlist -->
                                            <form action="wishlist" method="post" style="display:inline-block;">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="wishlistID" value="${item.wishlistID}">
                                                <input type="hidden" name="userID" value="${userID}">
                                                <button type="submit" class="btn btn-sm btn-remove-custom" title="Xóa"
                                                        onclick="return confirm('Remove this product from wishlist?')">
                                                    <i class="fa fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Giao diện khi wishlist rỗng -->
                    <div class="row">
                        <div class="col-12">
                            <div class="empty-wishlist-container">
                                <i class="fa fa-heart-o"></i>
                                <h3>Your favorites list is empty</h3>
                                <p class="text-muted">Explore the store and add your favorite products here!</p>
                                <a href="product" class="btn btn-success">
                                    <i class="fa fa-shopping-bag"></i> Explore Now
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="Footer.jsp"></jsp:include>

    <!-- Các script của dự án -->
    <script src="assets/js/jquery-3.4.1.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.countdown.min.js"></script>
    <script src="assets/js/jquery.nice-select.min.js"></script>
    <script src="assets/js/jquery.nicescroll.min.js"></script>
    <script src="assets/js/slick.min.js"></script>
    <script src="assets/js/biolife.framework.js"></script>
    <script src="assets/js/functions.js"></script>
    
    <script>
        // Tự động ẩn thông báo sau 5 giây
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                let alerts = document.querySelectorAll('.alert');
                if (alerts) {
                    alerts.forEach(function(alert) {
                        alert.style.display = 'none';
                    });
                }
            }, 5000);
        });
        // Thêm hàm chuyển tất cả vào giỏ hàng bằng fetch
        function moveAllToCart() {
            if (!confirm('Bạn có muốn chuyển tất cả sản phẩm vào giỏ hàng?')) return;
            const formData = new URLSearchParams();
            formData.append('action', 'moveAllToCart');
            formData.append('userID', document.querySelector('input[name="userID"]').value);
            fetch("wishlist", {
                method: "POST",
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                credentials: 'same-origin'
            })
            .then(response => {
                if (response.status === 401) {
                    alert("Vui lòng đăng nhập để sử dụng chức năng này!");
                    window.location.href = 'Login.jsp';
                    throw new Error('Authentication failed');
                }
                return response.json();
            })
            .then(data => {
                if (data && data.message) {
                    alert(data.message);
                    window.location.reload();
                }
            })
            .catch(error => {
                if (error.message !== 'Authentication failed') {
                    console.error("Lỗi khi chuyển tất cả vào cart:", error);
                    alert("Đã có lỗi xảy ra. Vui lòng thử lại.");
                }
            });
        }
    </script>
</body>
</html>