<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>


<!DOCTYPE html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Da Nang Craft Village</title>
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&amp;display=swap" rel="stylesheet">
        <link rel="shortcut icon" type="image/x-icon" href="hinh anh/Logo/cropped-Favicon-1-32x32.png" />
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        <style>
            .review-tab .container,
            .tab-contain.review-tab .container {
                background: none !important;
                box-shadow: none !important;
            }
            /* Làm đẹp cho phần đánh giá sao */
            #comments, #comments h3, .review-tab .comment-title {
                border-top: none !important;
                border-bottom: none !important;
                box-shadow: none !important;
            }
            .comment-title {
                margin: 0 !important;
            }
            #comments {
                margin-top: 0 !important;
            }
            .comment-form-rating .stars {
                display: inline-block;
                margin: 0;
                padding: 0;
            }
            .comment-form-rating .stars a.btn-rating {
                display: inline-block;
                margin-right: 5px;
                font-size: 16px;
                color: #ccc;
                text-decoration: none;
            }
            .biolife-panigations-block.version-2 {
                text-align: center;
                padding-top: 7px !important;
                padding-bottom: 49px !important;
            }
            .comment-form-rating .stars a.btn-rating .fa-star {
                color: #f9ba48; /* Màu của sao đầy đủ */
            }
            .comment-form-rating .stars a.btn-rating .fa-star-o {
                color: #ccc; /* Màu của sao rỗng */
            }
            .comment-form-rating .stars a.btn-rating .fa-star-half-o {
                color: #808080; /* Màu xám */
            }
            .comment-form-rating .stars a.btn-rating:hover {
                transform: scale(1.2);
            }
            /* Hiệu ứng khi hover */
            .comment-form-rating .stars a.btn-rating:hover ~ a.btn-rating .fa {
                color: #ccc;
            }
            /* Cải thiện nút gửi đánh giá */
            .review-form-wrapper button[type="submit"] {
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            .review-form-wrapper button[type="submit"]:hover {
                background-color: #45a049;
            }
            .category-label {
                display: block;
                text-align: center;
                margin-bottom: 5px;
                font-size: 12px;
                text-transform: uppercase;
            }
            .category-label-left {
                display: block;
                text-align: left;
                margin-bottom: 5px;
                font-size: 12px;
                text-transform: uppercase;
            }
            .star-rating {
                position: relative;
                display: inline-block;
            }
            /* Thanh rating bar */
            .rating-bar {
                width: 130px;
                height: 8px;
                background: #eee;
                border-radius: 3px;
                overflow: hidden;
                display: inline-block;
            }
            .bar-fill {
                height: 100%;
                background: #ffc107;
                border-radius: 3px;
                transition: width 0.4s;
            }

        </style>
        <script>
            function addToCart(productId, quantity) {
                fetch("cart?action=add&id=" + productId + "&quantity=" + quantity, {
                    method: "POST",
                    credentials: 'same-origin'
                })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.text();
                        })
                        .then(data => {
                            if (data.includes("login")) {
                                alert("Please login to add products to cart!");
                                window.location.href = 'Login.jsp';
                            } else {
                                alert("Product added to cart!");
                            }
                        })
                        .catch(error => {
                            console.error("Lỗi:", error);
                            alert("An error occurred while adding the product to the cart!");
                        });
            }
        </script>
        <!-- filepath: d:\KI4\PRJ301\DuanNho\DuAnBanHang\DuAnBanHang\web\Category.jsp -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Đã loại bỏ cập nhật tên danh mục bằng JS, dùng JSTL trực tiếp trong JSP
            });
        </script>
        <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            a {
                text-decoration: none !important;
            }
        </style>
    </head>
    <body class="biolife-body">

        <!-- Preloader -->
        <div id="biof-loading">
            <div class="biof-loading-center">
                <div class="biof-loading-center-absolute">
                    <div class="dot dot-one"></div>
                    <div class="dot dot-two"></div>
                    <div class="dot dot-three"></div>
                </div>
            </div>
        </div>

        <!-- HEADER -->

        <jsp:include page="Menu.jsp"></jsp:include>



            <!--Hero Section-->
            <div class="hero-section hero-background">
                <h1 class="page-title">Details</h1>
            </div>

            <!--Navigation section-->
            <div class="container">
                <nav class="biolife-nav">
                    <ul>
                        <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                        <li class="nav-item"><a href="product" class="permal-link">Product</a></li>
                        <li class="nav-item"><span class="current-page">${productName}</span></li>
                </ul>
            </nav>
        </div>

        <div class="page-contain single-product">
            <div class="container">

                <!-- Main content -->
                <div id="main-content" class="main-content">

                    <!-- summary info -->
                    <div class="sumary-product single-layout"" >
                        <div class="media">
                            <ul class="biolife-carousel slider-for" data-slick='{"arrows":false,"dots":false,"slidesMargin":30,"slidesToShow":1,"slidesToScroll":1,"fade":true,"asNavFor":".slider-nav"}'>
                                <li><img src="${img}" alt=""  style="
                                         width: 400px;
                                         height: 350px;
                                         object-fit: cover;
                                         display: block;
                                         margin: 0 auto;
                                         border-radius: 8px;
                                         background-color: #f8f8f8;
                                         box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                                         transition: transform 0.3s ease;
                                         "
                                         onmouseover="this.style.transform = 'scale(1.05)'" 
                                         onmouseout="this.style.transform = 'scale(1)'"></li>
                            </ul>
                            <ul class="biolife-carousel slider-nav" data-slick='{"arrows":false,"dots":false,"centerMode":false,"focusOnSelect":true,"slidesMargin":10,"slidesToShow":4,"slidesToScroll":1,"asNavFor":".slider-for"}'>
                                <li><img src="${img}" alt="" style="
                                         width: 88px;
                                         height: 88px;
                                         object-fit: cover;
                                         border-radius: 4px;
                                         border: 2px solid transparent;
                                         background-color: #f8f8f8;
                                         transition: all 0.3s ease;
                                         cursor: pointer;
                                         "
                                         onmouseover="this.style.borderColor = '#4CAF50'" 
                                         onmouseout="this.style.borderColor = 'transparent'"></li>
                            </ul>
                        </div>
                        <div class="product-attribute">
                            <h3 class="title">${productName}</h3>
                            <!-- Sản phẩm chính -->
                            <c:if test="${not empty listCC}">
                                <c:forEach var="cat" items="${listCC}">
                                    <c:if test="${cat.categoryID == detail.cateID}">
                                        <b class="category-label-left">${cat.categoryName}</b>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <div>
                                <div class="star-rating">
                                    <c:set var="fullStars" value="${averageRating != null ? averageRating - (averageRating % 1) : 0}" />
                                    <c:set var="halfStar" value="${averageRating != null && (averageRating % 1) >= 0.5 ? 1 : 0}" />
                                    <c:set var="emptyStars" value="${5 - fullStars - halfStar}" />
                                    <c:forEach var="i" begin="1" end="${fullStars}">
                                        <i class="fa fa-star" style="color: #ffc107;"></i>
                                    </c:forEach>
                                    <c:if test="${halfStar == 1}">
                                        <i class="fa fa-star-half-o" style="color: #ffc107;"></i>
                                    </c:if>
                                    <c:forEach var="i" begin="1" end="${emptyStars}">
                                        <i class="fa fa-star-o" style="color: #ffc107;"></i>
                                    </c:forEach>
                                </div>
                                <span class="review-count">(${averageRating} Reviews)</span>

                            </div>

                            <div class="price">
                                <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${price}" type="currency"/></span></ins>
                            </div>

                        </div>
                        <div class="action-form">
                            <div class="quantity-box">
                                <span class="title">Quantity:</span>
                                <div class="qty-input">
                                    <input type="text" 
                                           id="quantity" 
                                           name="quantity" 
                                           value="1" 
                                           data-max_value="${detail.stock}" 
                                           data-min_value="1" 
                                           data-step="1"
                                           oninput="validateQuantity()">
                                    <a  class="qty-btn btn-up" onclick="event.preventDefault();
                                            var q = document.getElementById('quantity');
                                            if (parseInt(q.value) < ${detail.stock})
                                                q.value++;
                                            else
                                                alert('Số lượng vượt quá hàng tồn kho! (Còn ${detail.stock} sản phẩm)');"><i class="fa fa-caret-up" aria-hidden="true"></i>
                                    </a>
                                    <a  class="qty-btn btn-down" onclick="event.preventDefault();
                                            var q = document.getElementById('quantity');
                                            if (q.value > 1)
                                                q.value--;"><i class="fa fa-caret-down" aria-hidden="true"></i></a>
                                </div>
                                <p class="stock-info">Còn lại: ${detail.stock} sản phẩm</p>
                            </div>

                            <div class="buttons">
                                <a onclick="addToCart('${detail.id}', document.getElementById('quantity').value)" class="btn add-to-cart-btn">
                                    <i class="fa fa-cart-plus"></i> Add to cart
                                </a>
                            </div>

                            <div class="social-media">
                                <ul class="social-list">
                                    <li><a href="#" class="social-link"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                                    <li><a href="#" class="social-link"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                                    <li><a href="#" class="social-link"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                                    <li><a href="#" class="social-link"><i class="fa fa-share-alt" aria-hidden="true"></i></a></li>
                                    <li><a href="#" class="social-link"><i class="fa fa-instagram" aria-hidden="true"></i></a></li>
                                </ul>
                            </div>
                            <div class="acepted-payment-methods">
                                <ul class="payment-methods">
                                    <li><img src="assets/images/card1.jpg" alt="" width="51" height="36"></li>
                                    <li><img src="assets/images/card2.jpg" alt="" width="51" height="36"></li>
                                    <li><img src="assets/images/card3.jpg" alt="" width="51" height="36"></li>
                                    <li><img src="assets/images/card4.jpg" alt="" width="51" height="36"></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- Tab info -->
                    <div class="container mt-5">
                        <button id="toggle3dBtn" type="button" class="btn btn-success">
                            View 3D Model
                        </button>

                        <div id="viewerContainer" style="display: none; margin-top: 20px; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
                            <c:choose>
                                <c:when test="${not empty product3D}">
                                    <model-viewer
                                        src="${product3D}"
                                        alt="${productName}"
                                        camera-controls
                                        auto-rotate
                                        shadow-intensity="1"
                                        style="width: 100%; height: 300px;">
                                    </model-viewer>
                                </c:when>
                                <c:otherwise>
                                    <p style="color: red; font-weight: bold;">Model not available</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <!-- Tab info -->
                    <div class="product-tabs single-layout biolife-tab-contain" style="margin-top: 10px">
                        <div class="tab-head">
                            <ul class="tabs">
                                <li class="tab-element active"><a href="#tab_1st" class="tab-link">Products Descriptions</a></li>
                                <li class="tab-element" ><a href="#tab_4th" class="tab-link">Customer Reviews <sup>${averageRating}</sup></a></li>
                            </ul>
                        </div>
                        <div class="tab-content">
                            <div id="tab_1st" class="tab-contain desc-tab active">
                                <p class="desc">${description}</p>
                                <div class="desc-expand">

                                </div>
                            </div>

                            <div id="tab_4th" class="tab-contain review-tab">
                                <div class="container">
                                    <div class="row">
                                        <div class="col-lg-5 col-md-5 col-sm-6 col-xs-12">
                                            <div class="rating-info">
                                                <!-- Debug output to see what's being passed -->
                                                <!-- Debug: ${averageRating} -->
                                                <p class="index">
                                                    <strong class="rating">
                                                        <c:choose>
                                                            <c:when test="${averageRating != null}">
                                                                <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/>
                                                            </c:when>
                                                            <c:otherwise>0.0</c:otherwise>
                                                        </c:choose>
                                                    </strong> out of 5
                                                </p>
                                                <div class="star-rating">
                                                    <c:set var="fullStars" value="${averageRating != null ? averageRating - (averageRating % 1) : 0}" />
                                                    <c:set var="halfStar" value="${averageRating != null && (averageRating % 1) >= 0.5 ? 1 : 0}" />
                                                    <c:set var="emptyStars" value="${5 - fullStars - halfStar}" />
                                                    <c:forEach var="i" begin="1" end="${fullStars}">
                                                        <i class="fa fa-star" style="color: #ffc107;"></i>
                                                    </c:forEach>
                                                    <c:if test="${halfStar == 1}">
                                                        <i class="fa fa-star-half-o" style="color: #ffc107;"></i>
                                                    </c:if>
                                                    <c:forEach var="i" begin="1" end="${emptyStars}">
                                                        <i class="fa fa-star-o" style="color: #ffc107;"></i>
                                                    </c:forEach>
                                                </div>
                                                <p class="see-all">See all <c:out value="${reviewCount > 0 ? reviewCount : 0}"/> reviews</p>
                                                <ul class="options">
                                                    <c:set var="total" value="${reviewCount}" />
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <c:set var="percent" value="${total > 0 ? (ratingDistribution[5 - i] * 100.0) / total : 0}" />
                                                        <fmt:formatNumber var="percentRounded" value="${percent}" maxFractionDigits="0" />
                                                        <li>
                                                            <div class="detail-for" style="display: flex; align-items: center; gap: 8px;">
                                                                <span class="option-name" style="width: 50px;">${6 - i} star<c:if test="${6 - i > 1}">s</c:if></span>
                                                                    <div class="rating-bar" style="width: 130px; height: 8px; background: #eee; border-radius: 3px; overflow: hidden;">
                                                                        <div class="bar-fill"
                                                                             style="height: 100%; background: #ffc107; border-radius: 3px; transition: width 0.4s; width: ${percentRounded}%;"></div>
                                                                </div>
                                                                <span class="number" style="width: 24px; text-align: right;">${ratingDistribution[5 - i]}</span>
                                                            </div>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12">
                                            <div id="comments">
                                                <h3 class="comment-title">${reviewCount} Reviews for ${productName}</h3>
                                                <ol class="commentlist">
                                                    <c:if test="${reviews.size() == 0}">
                                                        <li class="no-reviews">
                                                            <p>No reviews yet. Be the first to review this product!</p>
                                                        </li>
                                                    </c:if>
                                                    <c:forEach var="review" items="${reviews}">
                                                        <div class="comment-container">
                                                            <div class="row">
                                                                <div class="comment-content col-lg-8 col-md-9 col-sm-8 col-xs-12">
                                                                    <p class="comment-in">
                                                                        <span class="post-name">${review.reviewText}</span>
                                                                        <span class="post-date">
                                                                            <fmt:formatDate pattern="dd/MM/yyyy" value="${review.reviewDate}" />
                                                                        </span>
                                                                    </p>
                                                                    <div class="rating">
                                                                        <p class="star-rating">
                                                                            <span class="width-${review.rating * 20}percent"></span>
                                                                        </p>
                                                                    </div>
                                                                    <p class="author">by: <b>${review.userName}</b></p>

                                                                    <!-- Admin Response Section -->
                                                                    <c:choose>
                                                                        <c:when test="${not empty review.response}">
                                                                            <div class="review-response" style="background: #f7f7f7; padding: 10px; margin-top: 10px; border-left: 3px solid #4CAF50;">
                                                                                <strong>Admin Response:</strong>
                                                                                <p style="margin:0;">${review.response}</p>
                                                                                <c:if test="${not empty review.responseDate}">
                                                                                    <small style="color: #666;">
                                                                                        <fmt:formatDate pattern="dd/MM/yyyy HH:mm" value="${review.responseDate}" />
                                                                                    </small>
                                                                                </c:if>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="review-response" style="background: #f9f9f9; padding: 10px; margin-top: 10px; border-left: 3px solid #ccc; color: #666;">
                                                                                <strong>Admin Response:</strong>
                                                                                <p style="margin:0; font-style: italic;">No response from admin yet.</p>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </ol>

                                                <!-- PHÂN TRANG REVIEW -->
                                                <c:if test="${totalPages > 1}">
                                                    <div class="biolife-panigations-block version-2">
                                                        <ul class="panigation-contain">
                                                            <c:if test="${currentPage > 1}">
                                                                <li><a href="detail?pid=${detail.id}&page=${currentPage - 1}#tab_4th" class="link-page prev">&lt;</a></li>
                                                                </c:if>
                                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                                <li>
                                                                    <c:choose>
                                                                        <c:when test="${i == currentPage}">
                                                                            <span class="current-page">${i}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="detail?pid=${detail.id}&page=${i}#tab_4th" class="link-page">${i}</a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </li>
                                                            </c:forEach>
                                                            <c:if test="${currentPage < totalPages}">
                                                                <li><a href="detail?pid=${detail.id}&page=${currentPage + 1}#tab_4th" class="link-page next">&gt;</a></li>
                                                                </c:if>
                                                        </ul>
                                                        <div class="result-count">
                                                            <p class="txt-count">
                                                                <b>${(currentPage-1)*2+1}</b> -
                                                                <b>${(currentPage*2 > reviewCount) ? reviewCount : currentPage*2}</b>
                                                                of <b>${reviewCount}</b> reviews
                                                            </p>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- related products -->
                    <div class="product-related-box single-layout">
                        <div class="biolife-title-box lg-margin-bottom-26px-im">
                            <span class="subtitle">All the best item for You</span>
                            <h3 class="main-title">Related Products</h3>
                        </div>
                        <ul class="products-list biolife-carousel nav-center-02 nav-none-on-mobile" data-slick='{"rows":1,"arrows":true,"dots":false,"infinite":false,"speed":400,"slidesMargin":0,"slidesToShow":5, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 4}},{"breakpoint":992, "settings":{ "slidesToShow": 3, "slidesMargin":20 }},{"breakpoint":768, "settings":{ "slidesToShow": 2, "slidesMargin":10}}]}'>
                            <c:forEach var="p" items="${listPP}">
                                <li class="product-item">
                                    <div class="contain-product layout-default">
                                        <div class="product-thumb">
                                            <a href="detail?pid=${p.id}" class="link-to-product">
                                                <figure style="
                                                        margin: 0;
                                                        padding: 0;
                                                        width: 100%;
                                                        height: 270px;
                                                        overflow: hidden;
                                                        position: relative;
                                                        border-radius: 8px;
                                                        background-color: #f8f8f8;">
                                                        <img src="${p.img}" alt="dd" class="product-thumnail" style="
                                                            width: 100%;
                                                            height: 100%;
                                                            object-fit: cover;
                                                            transition: transform 0.3s ease;">
                                                    </figure>
                                            </a>
                                        </div>
                                        <div class="info">
                                            <!-- Related products -->
                                            <c:if test="${not empty listCC}">
                                                <c:forEach var="cat" items="${listCC}">
                                                    <c:if test="${cat.categoryID == p.cateID}">
                                                        <b class="category-label">${cat.categoryName}</b>
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                            <h4 class="product-title"><a href="detail?pid=${p.id}" class="pr-name">${p.name}</a></h4>
                                            <div class="price">
                                                <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${p.price}" type="currency"/></span></ins>
                                            </div>
                                            <div class="slide-down-box">

                                                <div class="buttons">

                                                    <a onclick="addToCart('${p.id}', 1)" class="btn add-to-cart-btn">
                                                        <i class="fa fa-cart-plus"></i> Add to cart
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </c:forEach>


                        </ul>
                    </div>

                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <jsp:include page="Footer.jsp"></jsp:include>



        <!--Footer For Mobile-->
        <div class="mobile-footer">
            <div class="mobile-footer-inner">
                <div class="mobile-block block-menu-main">
                    <a class="menu-bar menu-toggle btn-toggle" data-object="open-mobile-menu" href="javascript:void(0)">
                        <span class="fa fa-bars"></span>
                        <span class="text">Menu</span>
                    </a>
                </div>
                <div class="mobile-block block-sidebar">
                    <a class="menu-bar filter-toggle btn-toggle" data-object="open-mobile-filter" href="javascript:void(0)">
                        <i class="fa fa-sliders" aria-hidden="true"></i>
                        <span class="text">Sidebar</span>
                    </a>
                </div>
                <div class="mobile-block block-minicart">
                    <a class="link-to-cart" href="#">
                        <span class="fa fa-shopping-bag" aria-hidden="true"></span>
                        <span class="text">Cart</span>
                    </a>
                </div>
                <div class="mobile-block block-global">
                    <a class="menu-bar myaccount-toggle btn-toggle" data-object="global-panel-opened" href="javascript:void(0)">
                        <span class="fa fa-globe"></span>
                        <span class="text">Global</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="mobile-block-global">
            <div class="biolife-mobile-panels">
                <span class="biolife-current-panel-title">Global</span>
                <a class="biolife-close-btn" data-object="global-panel-opened" href="#">&times;</a>
            </div>
            <div class="block-global-contain">
                <div class="glb-item my-account">
                    <b class="title">My Account</b>
                    <ul class="list">
                        <li class="list-item"><a href="#">Login/register</a></li>
                        <li class="list-item"><a href="#">Wishlist <span class="index">(8)</span></a></li>
                        <li class="list-item"><a href="#">Checkout</a></li>
                    </ul>
                </div>
                <div class="glb-item currency">
                    <b class="title">Currency</b>
                    <ul class="list">
                        <li class="list-item"><a href="#">€ EUR (Euro)</a></li>
                        <li class="list-item"><a href="#">$ USD (Dollar)</a></li>
                        <li class="list-item"><a href="#">£ GBP (Pound)</a></li>
                        <li class="list-item"><a href="#">¥ JPY (Yen)</a></li>
                    </ul>
                </div>
                <div class="glb-item languages">
                    <b class="title">Language</b>
                    <ul class="list inline">
                        <li class="list-item"><a href="#"><img src="assets/images/languages/us.jpg" alt="flag" width="24" height="18"></a></li>
                        <li class="list-item"><a href="#"><img src="assets/images/languages/fr.jpg" alt="flag" width="24" height="18"></a></li>
                        <li class="list-item"><a href="#"><img src="assets/images/languages/ger.jpg" alt="flag" width="24" height="18"></a></li>
                        <li class="list-item"><a href="#"><img src="assets/images/languages/jap.jpg" alt="flag" width="24" height="18"></a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Scroll Top Button -->
        <a class="btn-scroll-top"><i class="biolife-icon icon-left-arrow"></i></a>

        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.countdown.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/jquery.nicescroll.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>

        <script>
                                                        $(document).ready(function () {
                                                            const ratingBtns = document.querySelectorAll('.btn-rating');
                                                            const ratingInput = document.getElementById('selected-rating');

                                                            ratingBtns.forEach((btn, index) => {
                                                                btn.addEventListener('click', function (e) {
                                                                    e.preventDefault();

                                                                    // Set the rating value (index + 1 because stars are 1-based)
                                                                    const ratingValue = index + 1;
                                                                    ratingInput.value = ratingValue;

                                                                    // Update the visual appearance
                                                                    ratingBtns.forEach((b, i) => {
                                                                        const star = b.querySelector('i');
                                                                        if (i <= index) {
                                                                            star.className = 'fa fa-star';
                                                                        } else {
                                                                            star.className = 'fa fa-star-o';
                                                                        }
                                                                    });
                                                                });
                                                            });

                                                            // Check if hash contains tab=reviews to activate the reviews tab
                                                            if (window.location.hash === '#tab_4th' || window.location.search.includes('tab=reviews')) {
                                                                // Find the review tab link and trigger a click
                                                                const reviewTabLink = document.querySelector('a[href="#tab_4th"]');
                                                                if (reviewTabLink) {
                                                                    setTimeout(() => {
                                                                        reviewTabLink.click();
                                                                    }, 100);
                                                                }
                                                            }
                                                        });
                                                        $(document).ready(function () {
                                                            const ratingBtns = document.querySelectorAll('.btn-rating');
                                                            const ratingInput = document.getElementById('selected-rating');

                                                            // Hiển thị mặc định 5 sao khi trang được tải
                                                            function initRating() {
                                                                const defaultRating = ratingInput.value || 5;
                                                                updateStarsDisplay(defaultRating);
                                                            }

                                                            // Cập nhật hiển thị sao dựa trên giá trị đánh giá
                                                            function updateStarsDisplay(rating) {
                                                                ratingBtns.forEach((btn, i) => {
                                                                    const star = btn.querySelector('i');
                                                                    if (i < rating) {
                                                                        star.className = 'fa fa-star'; // Sao đầy đủ
                                                                    } else {
                                                                        star.className = 'fa fa-star-o'; // Sao rỗng
                                                                    }
                                                                });
                                                            }

                                                            // Sự kiện click cho các nút sao
                                                            ratingBtns.forEach((btn, index) => {
                                                                btn.addEventListener('click', function (e) {
                                                                    e.preventDefault();

                                                                    // Set the rating value (index + 1 because stars are 1-based)
                                                                    const ratingValue = index + 1;
                                                                    ratingInput.value = ratingValue;

                                                                    // Update the visual appearance
                                                                    updateStarsDisplay(ratingValue);
                                                                });

                                                                // Thêm hiệu ứng hover
                                                                btn.addEventListener('mouseenter', function () {
                                                                    // Hiển thị sao khi hover
                                                                    ratingBtns.forEach((b, i) => {
                                                                        const star = b.querySelector('i');
                                                                        if (i <= index) {
                                                                            star.className = 'fa fa-star';
                                                                        } else {
                                                                            star.className = 'fa fa-star-o';
                                                                        }
                                                                    });
                                                                });
                                                            });

                                                            // Xử lý sự kiện khi chuột rời khỏi vùng sao
                                                            const starsContainer = document.querySelector('.stars');
                                                            if (starsContainer) {
                                                                starsContainer.addEventListener('mouseleave', function () {
                                                                    // Khôi phục trạng thái sao dựa trên giá trị đã chọn
                                                                    const currentRating = parseInt(ratingInput.value) || 5;
                                                                    updateStarsDisplay(currentRating);
                                                                });
                                                            }

                                                            // Khởi tạo sao khi trang tải
                                                            initRating();

                                                            // Check if hash contains tab=reviews to activate the reviews tab
                                                            if (window.location.hash === '#tab_4th' || window.location.search.includes('tab=reviews')) {
                                                                // Find the review tab link and trigger a click
                                                                const reviewTabLink = document.querySelector('a[href="#tab_4th"]');
                                                                if (reviewTabLink) {
                                                                    setTimeout(() => {
                                                                        reviewTabLink.click();
                                                                    }, 100);
                                                                }
                                                            }
                                                        });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var btn = document.getElementById('toggle3dBtn');
                var viewerContainer = document.getElementById('viewerContainer');
                var isVisible = false;

                btn.addEventListener('click', function () {
                    isVisible = !isVisible;
                    if (isVisible) {
                        viewerContainer.style.display = 'block';
                        btn.textContent = 'Hide 3D Model';
                    } else {
                        viewerContainer.style.display = 'none';
                        btn.textContent = 'View 3D Model';
                    }
                });
            });
        </script>
    </body>
</html>