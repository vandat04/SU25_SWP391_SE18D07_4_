<%-- 
    Document   : TicketDetail
    Created on : Jul 11, 2025, 10:17:00 PM
    Author     : ACER
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>

<!-- Remove debug info once everything is working -->
<c:if test="${param.debug == 'true'}">
    <div style="background: #ffe; border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
        <strong>Debug Info:</strong>
        ticket: ${ticket != null ? 'OK' : 'NULL'} |
        village: ${village != null ? 'OK' : 'NULL'} |
        availableDates: ${fn:length(availableDates)} |
        allTicketTypes: ${fn:length(allTicketTypes)}
    </div>
</c:if>

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
        <link rel="shortcut icon" type="image/x-icon" href="hinhanh/Logo/cropped-Favicon-1-32x32.png" />
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">

        <style>
            /* Calendar Styles */
            .calendar-container {
                max-width: 400px;
                margin: 20px 0;
                border: 1px solid #ddd;
                border-radius: 8px;
                overflow: hidden;
                font-family: Arial, sans-serif;
            }

            .calendar-header {
                background: #4CAF50;
                color: white;
                padding: 15px;
                text-align: center;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .calendar-nav {
                background: none;
                border: none;
                color: white;
                font-size: 18px;
                cursor: pointer;
                padding: 5px 10px;
                border-radius: 4px;
            }

            .calendar-nav:hover {
                background: rgba(255, 255, 255, 0.2);
            }

            .calendar-body {
                background: white;
            }

            .calendar-weekdays {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                background: #f5f5f5;
            }

            .weekday {
                padding: 10px;
                text-align: center;
                font-weight: bold;
                color: #666;
                font-size: 12px;
            }

            .calendar-days {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 1px;
                background: #e0e0e0;
            }

            .calendar-day {
                background: white;
                padding: 8px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                min-height: 35px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 14px;
                font-weight: 500;
            }

            .calendar-day:hover {
                background: #e8f5e8;
            }

            .calendar-day.disabled {
                color: #ccc;
                cursor: not-allowed;
                background: #f9f9f9;
            }

            .calendar-day.available {
                background: #e8f5e8;
                color: #2e7d32;
                font-weight: bold;
            }

            .calendar-day.selected {
                background: #4CAF50;
                color: white;
            }

            .calendar-day.unavailable {
                background: #ffebee;
                color: #c62828;
            }

            /* Ticket Type Selection */
            .ticket-type-selection {
                margin: 20px 0;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                background: #f9f9f9;
            }

            .ticket-type-dropdown {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 16px;
                background: white;
            }

            /* Price Display */
            .price-display {
                margin: 15px 0;
                padding: 15px;
                background: linear-gradient(135deg, #4CAF50, #45a049);
                color: white;
                border-radius: 8px;
                text-align: center;
            }

            .current-price {
                font-size: 28px;
                font-weight: bold;
                margin: 0;
            }

            .ticket-type-info {
                font-size: 14px;
                margin-top: 5px;
                opacity: 0.9;
            }

            /* Availability Info */
            .availability-info {
                background: #e3f2fd;
                border: 1px solid #2196f3;
                border-radius: 6px;
                padding: 10px;
                margin: 10px 0;
                text-align: center;
            }

            .availability-info.unavailable {
                background: #ffebee;
                border-color: #f44336;
                color: #c62828;
            }

            /* Village Info Styles */
            .village-info-card {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 20px;
                margin: 20px 0;
            }

            /* Add to Cart Button */
            .add-to-cart-btn.disabled {
                background: #ccc;
                color: #666;
                cursor: not-allowed;
                opacity: 0.6;
            }

            .validation-message {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
                padding: 10px;
                border-radius: 4px;
                margin: 10px 0;
                display: none;
            }

            .validation-message.error {
                background: #f8d7da;
                border-color: #f5c6cb;
                color: #721c24;
            }

            .validation-message.success {
                background: #d4edda;
                border-color: #c3e6cb;
                color: #155724;
            }

            /* Synchronized Tab Styles - Matching Product Detail */
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
            
            /* Override for ticket detail star rating to prevent conflicts */
            .product-attribute .star-rating {
                position: relative;
                display: inline-block;
            }
            
            .product-attribute .star-rating .fa-star,
            .product-attribute .star-rating .fa-star-half-o,
            .product-attribute .star-rating .fa-star-o {
                font-size: 16px;
                margin-right: 2px;
            }
            
            /* Hide CSS-based star rating in ticket detail */
            .product-attribute .star-rating .width-0percent,
            .product-attribute .star-rating .width-20percent,
            .product-attribute .star-rating .width-40percent,
            .product-attribute .star-rating .width-60percent,
            .product-attribute .star-rating .width-80percent,
            .product-attribute .star-rating .width-100percent {
                display: none !important;
            }
            
            /* Disable ::before pseudo-element for star-rating in ticket detail */
            .product-attribute .star-rating::before {
                display: none !important;
                content: none !important;
            }
            
            /* Disable ::after pseudo-element for star-rating in ticket detail */
            .product-attribute .star-rating::after {
                display: none !important;
                content: none !important;
            }
            
            /* Remove margin from rating div in ticket detail */
            .product-attribute .rating {
                margin: 0 !important;
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

            /* Enhanced Ticket Details Styles */
            .ticket-details-section {
                margin-top: 40px;
            }

            .village-details-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .ticket-details-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .detail-section {
                background: #f9f9f9;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e0e0e0;
            }

            .detail-section h4 {
                color: #4CAF50;
                margin-bottom: 15px;
                border-bottom: 2px solid #4CAF50;
                padding-bottom: 5px;
            }

            .detail-table {
                width: 100%;
                border-collapse: collapse;
            }

            .detail-table td {
                padding: 8px 12px;
                border-bottom: 1px solid #e0e0e0;
                vertical-align: top;
            }

            .detail-table td:first-child {
                font-weight: 600;
                color: #333;
                width: 40%;
            }

            .detail-table td:last-child {
                color: #666;
            }

            /* Status indicators */
            .status-active {
                color: #4CAF50;
                font-weight: bold;
            }

            .status-hidden {
                color: #f44336;
                font-weight: bold;
            }

            .status-pending {
                color: #ff9800;
                font-weight: bold;
            }

            .status-unknown {
                color: #9e9e9e;
                font-weight: bold;
            }

            /* Enhanced Review Styles */
            .review-response {
                margin-top: 15px;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .review-response:hover {
                transform: translateX(5px);
            }

            /* Review Warning Enhancement */
            .review-warning {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 6px;
                padding: 15px;
                margin: 15px 0;
            }

            .review-warning ul {
                margin: 10px 0;
                padding-left: 20px;
            }

            .review-warning li {
                color: #856404;
                margin: 5px 0;
            }

            .review-warning a {
                color: #4CAF50;
                text-decoration: none;
                font-weight: 500;
            }

            .review-warning a:hover {
                text-decoration: underline;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .village-details-grid,
                .ticket-details-grid {
                    grid-template-columns: 1fr;
                }

                .seller-info-container {
                    grid-template-columns: 1fr;
                }

                .seller-profile {
                    flex-direction: column;
                    text-align: center;
                }

                .contact-buttons {
                    flex-direction: column;
                }

                .tab-head .tabs {
                    flex-direction: column;
                }

                .tab-head .tab-element {
                    min-width: auto;
                }
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
                <h1 class="page-title">Ticket Details</h1>
            </div>

            <!--Navigation section-->
            <div class="container">
                <nav class="biolife-nav">
                    <ul>
                        <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                        <li class="nav-item"><a href="ticket-list" class="permal-link">tickets</a></li>
                        <li class="nav-item"><span class="current-page">${village.villageName}</span></li>
                </ul>
            </nav>
        </div>

        <div class="page-contain single-product">
            <div class="container">
                <!-- Main content -->
                <div id="main-content" class="main-content">
                    <!-- Summary info -->
                    <div class="sumary-product single-layout">
                        <div class="media">
                            <!-- Village Images -->
                            <c:if test="${not empty village}">
                                <ul class="biolife-carousel slider-for" data-slick='{"arrows":false,"dots":false,"slidesMargin":30,"slidesToShow":1,"slidesToScroll":1,"fade":true,"asNavFor":".slider-nav"}'>
                                    <li>
                                        <img src="${village.mainImageUrl != null ? village.mainImageUrl : 'hinhanh/village/default-village.jpg'}" 
                                             alt="${village.villageName}" 
                                             style="width: 400px; height: 350px; object-fit: cover; display: block; margin: 0 auto; border-radius: 8px; background-color: #f8f8f8; box-shadow: 0 2px 4px rgba(0,0,0,0.1); transition: transform 0.3s ease;"
                                             onmouseover="this.style.transform = 'scale(1.05)'" 
                                             onmouseout="this.style.transform = 'scale(1)'">
                                    </li>
                                </ul>

                                <!-- Additional village images can be added here if available -->
                                <ul class="biolife-carousel slider-nav" data-slick='{"arrows":false,"dots":false,"centerMode":false,"focusOnSelect":true,"slidesMargin":10,"slidesToShow":4,"slidesToScroll":1,"asNavFor":".slider-for"}'>
                                    <li>
                                        <img src="${village.mainImageUrl != null ? village.mainImageUrl : 'hinhanh/village/default-village.jpg'}" 
                                             alt="${village.villageName}"
                                             style="width: 88px; height: 88px; object-fit: cover; border-radius: 4px; border: 2px solid transparent; background-color: #f8f8f8; transition: all 0.3s ease; cursor: pointer;"
                                             onmouseover="this.style.borderColor = '#4CAF50'" 
                                             onmouseout="this.style.borderColor = 'transparent'">
                                    </li>
                                </ul>
                            </c:if>
                        </div>

                        <div class="product-attribute">
                            <c:if test="${not empty village}">
                                <h3 class="title">${village.villageName} - Village Ticket</h3>
                                <b class="category-label-left">Village: ${village.villageName}</b>
                                <div class="rating">
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
                                    <span class="review-count">(${totalReviews != null ? totalReviews : 0} Reviews)</span>

                                </div>
                            </c:if>

                            <!-- Ticket Type Selection -->
                            <div class="form-group">
                                <label for="ticketTypeSelect">Ticket Type:</label>
                                <select id="ticketTypeSelect" class="form-control" onchange="updatePrice()" style="width: 50%;">
                                    <option value="">-- Choose Ticket Type --</option>
                                    <c:forEach var="ticketType" items="${allTicketTypes}">
                                        <option value="${ticketType.ticketID}" 
                                                data-price="${ticketType.priceAsDouble}" 
                                                data-type="${ticketType.typeName}"
                                                data-description="${ticketType.typeDescription}"
                                                ${ticketType.ticketID == ticket.ticketID ? 'selected' : ''}>
                                            ${ticketType.typeName}
                                            <c:if test="${not empty ticketType.ageRange}"> - ${ticketType.ageRange}</c:if>
                                            - <fmt:formatNumber value="${ticketType.priceAsDouble}" type="number" groupingUsed="true"/> VNĐ
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Price Display -->
                            <div class="price">
                                <ins><span class="price-amount" id="currentPrice">
                                        <fmt:formatNumber value="${ticket.price}" type="currency"/>
                                    </span></ins>
                            </div>
                        </div>

                        <div class="action-form">
                            <!-- Date Selection Calendar -->
                            <div class="calendar-container">
                                <div class="calendar-header">
                                    <button type="button" class="calendar-nav" onclick="changeMonth(-1)">&lt;</button>
                                    <span id="currentMonthYear"></span>
                                    <button type="button" class="calendar-nav" onclick="changeMonth(1)">&gt;</button>
                                </div>
                                <div class="calendar-body">
                                    <div class="calendar-weekdays">
                                        <div class="weekday">CN</div>
                                        <div class="weekday">T2</div>
                                        <div class="weekday">T3</div>
                                        <div class="weekday">T4</div>
                                        <div class="weekday">T5</div>
                                        <div class="weekday">T6</div>
                                        <div class="weekday">T7</div>
                                    </div>
                                    <div class="calendar-days" id="calendarDays">
                                        <!-- Calendar days will be generated by JavaScript -->
                                    </div>
                                </div>
                            </div>

                            <!-- Availability Info -->
                            <div class="availability-info" id="availabilityInfo" style="display: none;">
                                <span id="availabilityText">Please select a date</span>
                            </div>

                            <!-- Quantity Selection -->
                            <div class="quantity-box">
                                <span class="title">Quantity:</span>
                                <div class="qty-input">
                                    <input type="text" 
                                           id="quantity" 
                                           name="quantity" 
                                           value="1" 
                                           data-max_value="10" 
                                           data-min_value="1" 
                                           data-step="1">
                                    <a class="qty-btn btn-up" onclick="increaseQuantity()">
                                        <i class="fa fa-caret-up" aria-hidden="true"></i>
                                    </a>
                                    <a class="qty-btn btn-down" onclick="decreaseQuantity()">
                                        <i class="fa fa-caret-down" aria-hidden="true"></i>
                                    </a>
                                </div>
                                <p class="stock-info" id="stockInfo">Select a date to see availability</p>
                            </div>

                            <!-- Validation Message -->
                            <div class="validation-message" id="validationMessage"></div>

                            <!-- Add to Cart Button -->
                            <div class="buttons">
                                <a onclick="addTicketToCart()" class="btn add-to-cart-btn disabled" id="addToCartBtn">
                                    <i class="fa fa-ticket"></i> Add Ticket to Cart
                                </a>

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
                    <div class="product-tabs single-layout biolife-tab-contain" style="margin-top: 10px">
                        <div class="tab-head">
                            <ul class="tabs">
                                <li class="tab-element active"><a href="#tab_1st" class="tab-link">Ticket Descriptions</a></li>
                                <li class="tab-element"><a href="#tab_4th" class="tab-link">Customer Reviews <sup>${totalReviews != null ? totalReviews : 0}</sup></a></li>
                            </ul>
                        </div>
                        <div class="tab-content">
                            <div id="tab_1st" class="tab-contain desc-tab active">
                                <div class="ticket-details-grid">
                                    <div class="detail-section">
                                        <h4>Thông tin Vé</h4>
                                        <table class="detail-table">
                                            <tr>
                                                <td><strong>ID Vé:</strong></td>
                                                <td>${completeTicketInfo.ticketID}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Loại Vé:</strong></td>
                                                <td>${completeTicketInfo.ticketTypeName}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Mô tả Loại vé:</strong></td>
                                                <td>${completeTicketInfo.ticketTypeDescription}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Độ tuổi áp dụng:</strong></td>
                                                <td>${completeTicketInfo.ageRange}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Giá:</strong></td>
                                                <td><fmt:formatNumber value="${completeTicketInfo.price}" type="currency"/></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Trạng thái:</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${completeTicketInfo.ticketStatus == 1}">
                                                            <span class="status-active">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-hidden">Không hoạt động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                                    <div class="detail-section">
                                        <h4>Thông tin Làng nghề</h4>
                                        <table class="detail-table">
                                            <tr>
                                                <td><strong>Tên Làng nghề:</strong></td>
                                                <td>${completeTicketInfo.villageName}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Mô tả Làng nghề:</strong></td>
                                                <td>${completeTicketInfo.villageDescription}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Địa chỉ Làng nghề:</strong></td>
                                                <td>${completeTicketInfo.villageAddress}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Điện thoại Làng nghề:</strong></td>
                                                <td>${completeTicketInfo.villagePhone}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Email Làng nghề:</strong></td>
                                                <td>${completeTicketInfo.villageEmail}</td>
                                            </tr>
                                        </table>
                                    </div>

                                    <div class="detail-section">
                                        <h4>Thống kê Làng nghề</h4>
                                        <table class="detail-table">
                                            <tr>
                                                <td><strong>Đánh giá Làng nghề:</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${completeTicketInfo.villageRating != null and completeTicketInfo.villageRating > 0}">
                                                            <fmt:formatNumber value="${completeTicketInfo.villageRating}" pattern="0.0"/> / 5.0
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa có đánh giá
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Tổng số đánh giá:</strong></td>
                                                <td>${completeTicketInfo.villageTotalReviews}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Giờ mở cửa:</strong></td>
                                                <td>${completeTicketInfo.openingHours}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Ngày đóng cửa:</strong></td>
                                                <td>${completeTicketInfo.closingDays}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div id="tab_4th" class="tab-contain review-tab">
                                <div class="container">
                                    <div class="row">
                                        <div class="col-lg-5 col-md-5 col-sm-6 col-xs-12">
                                            <div class="rating-info">
                                                <p class="index">
                                                    <strong class="rating">
                                                        <c:choose>
                                                            <c:when test="${averageRating != null and averageRating > 0}">
                                                                <fmt:formatNumber value="${averageRating}" pattern="0.0"/>
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
                                                <p class="see-all">See all <c:out value="${totalReviews > 0 ? totalReviews : 0}"/> reviews</p>
                                                <ul class="options">
                                                    <c:set var="total" value="${totalReviews}" />
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <c:set var="starCount" value="${6 - i}" />
                                                        <c:set var="percent" value="${total > 0 ? (ratingDistribution[starCount - 1] * 100.0) / total : 0}" />
                                                        <fmt:formatNumber var="percentRounded" value="${percent}" maxFractionDigits="0" />
                                                        <li>
                                                            <div class="detail-for" style="display: flex; align-items: center; gap: 8px;">
                                                                <span class="option-name" style="width: 50px;">${starCount} star<c:if test="${starCount > 1}">s</c:if></span>
                                                                    <div class="rating-bar" style="width: 130px; height: 8px; background: #eee; border-radius: 3px; overflow: hidden;">
                                                                        <div class="bar-fill"
                                                                             style="height: 100%; background: #ffc107; border-radius: 3px; transition: width 0.4s; width: ${percentRounded}%;"></div>
                                                                </div>
                                                                <span class="number" style="width: 24px; text-align: right;">${ratingDistribution[starCount - 1]}</span>
                                                            </div>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12">
                                            <div id="comments">
                                                <h3 class="comment-title">${totalReviews} Reviews for ${completeTicketInfo.villageName}</h3>
                                                <ol class="commentlist">
                                                    <c:if test="${empty villageReviews}">
                                                        <li class="no-reviews">
                                                            <p>No reviews yet. Be the first to review this village!</p>
                                                        </li>
                                                    </c:if>
                                                    <c:forEach var="review" items="${villageReviews}">
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
                                                                            <c:choose>
                                                                                <c:when test="${review.rating != null and review.rating > 0}">
                                                                                    <span class="width-${review.rating * 20}percent"></span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="width-0percent"></span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </p>
                                                                        <!-- Debug: Show actual rating value -->
                                                                        <c:if test="${param.debug == 'true'}">
                                                                            <small style="color: #999;">Debug: Rating=${review.rating}</small>
                                                                        </c:if>
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
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>s
                    </div>


                </div>
            </div>
        </div>

        <!-- Debug: Check data availability (only show if debug=true) -->
        <c:if test="${param.debug == 'true'}">
            <div id="debugInfo" style="display: block; background: #f0f0f0; padding: 10px; margin: 10px 0; border: 1px solid #ccc;">
                <p>Available Dates Count: ${fn:length(availableDates)}</p>
                <c:if test="${not empty availableDates}">
                    <c:forEach var="availability" items="${availableDates}" varStatus="status">
                        <p>Date ${status.index + 1}: ${availability.availableDate} - Slots: ${availability.availableSlots}</p>
                    </c:forEach>
                </c:if>
                
                <h4>Review Debug Info:</h4>
                <p>Total Reviews: ${totalReviews}</p>
                <p>Average Rating: ${averageRating}</p>
                <p>Rating Distribution: ${ratingDistribution[0]}, ${ratingDistribution[1]}, ${ratingDistribution[2]}, ${ratingDistribution[3]}, ${ratingDistribution[4]}</p>
                
                <c:if test="${not empty villageReviews}">
                    <h5>Individual Reviews:</h5>
                    <c:forEach var="review" items="${villageReviews}" varStatus="status">
                        <p>Review ${status.index + 1}: Rating=${review.rating}, Text="${review.reviewText}", User=${review.userName}</p>
                    </c:forEach>
                </c:if>
            </div>
        </c:if>

        <!-- Hidden data container for JSTL to JavaScript transfer -->
        <div id="availabilityData" style="display: none;">
            <c:choose>
                <c:when test="${not empty availableDates}">
                    <c:forEach var="availability" items="${availableDates}">
                        <c:set var="dateStr" value="${availability.availableDate}" />
                        <c:choose>
                            <c:when test="${not empty dateStr}">
                                <span class="availability-item" 
                                      data-date="${dateStr}"
                                      data-slots="${availability.availableSlots}"></span>
                            </c:when>
                            <c:otherwise>
                                <!-- Skip invalid date -->
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- No availability data, create sample data for testing -->
                    <%
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                    %>
                    <span class="availability-item" data-date="<%=sdf.format(cal.getTime())%>" data-slots="20"></span>
                    <%
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                    %>
                    <span class="availability-item" data-date="<%=sdf.format(cal.getTime())%>" data-slots="15"></span>
                    <%
                        cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                    %>
                    <span class="availability-item" data-date="<%=sdf.format(cal.getTime())%>" data-slots="18"></span>
                </c:otherwise>
            </c:choose>
        </div>
        <jsp:include page="Footer.jsp"></jsp:include>
        <!-- JavaScript for Calendar and Functionality -->
        <script type="text/javascript">
            // Global variables
            let currentDate = new Date();
            let selectedDate = null;
            let selectedTicketId = null;
            let availableDates = [];

            // Initialize calendar on page load
            document.addEventListener('DOMContentLoaded', function () {
                try {
                    // Debug: Show debug info temporarily
                    const debugInfo = document.getElementById('debugInfo');
                    if (debugInfo) {
                        console.log('Debug Info:', debugInfo.innerHTML);
                        // Show debug info on page
                        debugInfo.style.display = 'block';
                    }

                    // Load availability data from hidden div (MVC pattern)
                    const availabilityItems = document.querySelectorAll('#availabilityData .availability-item');
                    console.log('Found availability items:', availabilityItems.length);

                    availabilityItems.forEach(function (item) {
                        const dateStr = item.getAttribute('data-date');
                        const slots = parseInt(item.getAttribute('data-slots'));
                        console.log('Adding date:', dateStr, 'slots:', slots);
                        availableDates.push({
                            date: dateStr,
                            slots: slots
                        });
                    });

                    console.log('availableDates:', availableDates);
                    if (availableDates.length === 0) {
                        const warn = document.createElement('div');
                        warn.style.background = '#ffe0e0';
                        warn.style.color = '#b71c1c';
                        warn.style.padding = '10px';
                        warn.style.margin = '10px 0';
                        warn.style.border = '1px solid #b71c1c';
                        warn.textContent = '⚠️ Không có dữ liệu ngày vé từ backend! (availableDates rỗng)';
                        document.body.insertBefore(warn, document.body.firstChild);
                    }

                    // Generate calendar after data is loaded
                    generateCalendar(currentDate);

                } catch (error) {
                    console.error('Error initializing calendar:', error);
                    // Fallback: still try to generate calendar with empty data
                    generateCalendar(currentDate);
                }

                // Set default ticket type if only one available
                const ticketSelect = document.getElementById('ticketTypeSelect');
                if (ticketSelect.options.length === 2) {
                    ticketSelect.selectedIndex = 1;
                    updatePrice();
                }

                // Add event listener for ticket type dropdown
                if (ticketSelect) {
                    ticketSelect.addEventListener('change', function () {
                        updatePrice();
                    });
                }
            });

            // Calendar generation
            function generateCalendar(date) {
                try {
                    const calendarDays = document.getElementById('calendarDays');
                    const monthYear = document.getElementById('currentMonthYear');

                    if (!calendarDays || !monthYear) {
                        console.error('Calendar elements not found');
                        return;
                    }

                    const year = date.getFullYear();
                    const month = date.getMonth();

                    console.log('Generating calendar for:', year, month + 1);

                    // Set month/year display
                    const monthNames = [
                        'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                        'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
                    ];
                    monthYear.textContent = monthNames[month] + ' ' + year;

                    // Clear previous days
                    calendarDays.innerHTML = '';

                    // Get first day of month and number of days
                    const firstDay = new Date(year, month, 1);
                    const lastDay = new Date(year, month + 1, 0);
                    const daysInMonth = lastDay.getDate();
                    const startingDayOfWeek = firstDay.getDay();

                    // Add empty cells for days before month starts
                    for (let i = 0; i < startingDayOfWeek; i++) {
                        const emptyDay = document.createElement('div');
                        emptyDay.className = 'calendar-day disabled';
                        calendarDays.appendChild(emptyDay);
                    }

                    // Add days of the month
                    for (let day = 1; day <= daysInMonth; day++) {
                        const dayElement = document.createElement('div');
                        dayElement.className = 'calendar-day';
                        dayElement.textContent = day;

                        const currentDayDate = new Date(year, month, day);
                        const today = new Date();
                        today.setHours(0, 0, 0, 0);
                        const dateString = formatDateForComparison(currentDayDate);

                        // Check if day is in the past
                        if (currentDayDate < today) {
                            dayElement.classList.add('disabled');
                        } else {
                            // Check availability
                            const availableDate = availableDates.find(ad => ad.date === dateString);
                            if (availableDate) {
                                if (availableDate.slots > 0) {
                                    dayElement.classList.add('available');
                                    dayElement.onclick = function (event) {
                                        selectDate(event, currentDayDate, availableDate.slots);
                                        validateForm();
                                    };
                                } else {
                                    dayElement.classList.add('unavailable');
                                }
                            } else {
                                dayElement.classList.add('unavailable');
                            }
                        }

                        calendarDays.appendChild(dayElement);
                    }
                } catch (error) {
                    console.error('Error generating calendar:', error);
                    // Fallback: display error message
                    const calendarDays = document.getElementById('calendarDays');
                    if (calendarDays) {
                        calendarDays.innerHTML = '<div class="calendar-error">Error loading calendar</div>';
                    }
                }
            }

            // Change month
            function changeMonth(direction) {
                currentDate.setMonth(currentDate.getMonth() + direction);
                generateCalendar(currentDate);
            }

            // Select date
            function selectDate(event, date, availableSlots) {
                // Remove previous selection
                document.querySelectorAll('.calendar-day.selected').forEach(day => {
                    day.classList.remove('selected');
                });

                // Add selection to clicked day
                if (event && event.target) {
                    event.target.classList.add('selected');
                }

                selectedDate = date;
                console.log('Selected date:', selectedDate);

                // Update availability info
                const availabilityInfo = document.getElementById('availabilityInfo');
                const availabilityText = document.getElementById('availabilityText');
                const stockInfo = document.getElementById('stockInfo');

                if (availabilityInfo && availabilityText && stockInfo) {
                    availabilityInfo.style.display = 'block';
                    availabilityInfo.className = 'availability-info';

                    // Format date for display
                    const formattedDate = formatDate(date);

                    if (availableSlots > 0) {
                        availabilityText.textContent = availableSlots + ' tickets available for ' + formattedDate;
                        stockInfo.textContent = 'Available slots: ' + availableSlots + ' tickets';

                        // Update quantity max
                        const quantityInput = document.getElementById('quantity');
                        quantityInput.setAttribute('data-max_value', Math.min(10, availableSlots));
                        if (parseInt(quantityInput.value) > availableSlots) {
                            quantityInput.value = availableSlots;
                        }
                    } else {
                        availabilityInfo.classList.add('unavailable');
                        availabilityText.textContent = 'No tickets available for ' + formattedDate;
                        stockInfo.textContent = 'Sold out for selected date';
                    }
                }

                validateForm();
            }

            // Update price when ticket type changes
            function updatePrice() {
                const select = document.getElementById('ticketTypeSelect');
                const selectedOption = select.options[select.selectedIndex];
                const priceDisplay = document.getElementById('currentPrice');
                const typeInfo = document.getElementById('ticketTypeInfo');

                if (selectedOption && selectedOption.value) {
                    selectedTicketId = selectedOption.value;
                    const price = parseFloat(selectedOption.dataset.price);
                    const typeName = selectedOption.dataset.type;
                    const description = selectedOption.dataset.description;

                    // Format price in Vietnamese currency
                    priceDisplay.textContent = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(price);

                    if (typeInfo) {
                        typeInfo.textContent = typeName + (description ? ' - ' + description : '');
                    }
                } else {
                    selectedTicketId = null;
                    priceDisplay.textContent = 'Select ticket type';
                    if (typeInfo) {
                        typeInfo.textContent = 'Choose a ticket type to see pricing';
                    }
                }
                console.log('Selected ticketId:', selectedTicketId);

                // Always validate after updating
                setTimeout(function () {
                    validateForm();
                }, 100);
            }

            // Quantity controls
            function increaseQuantity() {
                const input = document.getElementById('quantity');
                const max = parseInt(input.getAttribute('data-max_value')) || 10;
                if (parseInt(input.value) < max) {
                    input.value = parseInt(input.value) + 1;
                }
                validateForm();
            }

            function decreaseQuantity() {
                const input = document.getElementById('quantity');
                if (parseInt(input.value) > 1) {
                    input.value = parseInt(input.value) - 1;
                }
                validateForm();
            }

            // Form validation
            function validateForm() {
                const addToCartBtn = document.getElementById('addToCartBtn');
                const validationMessage = document.getElementById('validationMessage');
                let isValid = true;
                let message = '';

                // Check ticket type selection
                const select = document.getElementById('ticketTypeSelect');
                const hasTicketType = select && select.value && select.value !== "";

                // Update global selectedTicketId to ensure sync
                if (hasTicketType) {
                    selectedTicketId = select.value;
                } else {
                    selectedTicketId = null;
                }

                // Form validation complete

                if (!hasTicketType) {
                    isValid = false;
                    message = 'Please select a ticket type';
                }
                // Check date selection
                else if (!selectedDate) {
                    isValid = false;
                    message = 'Please select a visit date';
                }
                // Check ngày có vé và số vé hợp lệ
                else {
                    const quantityInput = document.getElementById('quantity');
                    const quantity = quantityInput ? parseInt(quantityInput.value) : 0;
                    const ticketDate = selectedDate ? formatDateForDatabase(selectedDate) : null;
                    const found = availableDates.find(d => d.date === ticketDate);

                    if (!found) {
                        isValid = false;
                        message = 'Ngày này không có vé!';
                    } else if (found.slots <= 0) {
                        isValid = false;
                        message = 'Ngày này đã hết vé!';
                    } else if (quantity > found.slots) {
                        isValid = false;
                        message = 'Số lượng vượt quá số vé còn lại!';
                    } else if (quantity < 1) {
                        isValid = false;
                        message = 'Please select a valid quantity';
                    }
                }

                // Update button state
                if (isValid) {
                    addToCartBtn.classList.remove('disabled');
                    validationMessage.style.display = 'none';
                } else {
                    addToCartBtn.classList.add('disabled');
                    validationMessage.textContent = message;
                    validationMessage.className = 'validation-message error';
                    validationMessage.style.display = 'block';
                }
            }

            // Utility functions
            function formatDate(date) {
                return date.toLocaleDateString('vi-VN');
            }

            function formatDateForComparison(date) {
                return date.getFullYear() + '-' +
                        String(date.getMonth() + 1).padStart(2, '0') + '-' +
                        String(date.getDate()).padStart(2, '0');
            }

            function formatDateForDatabase(date) {
                return date.getFullYear() + '-' +
                        String(date.getMonth() + 1).padStart(2, '0') + '-' +
                        String(date.getDate()).padStart(2, '0');
            }

            // Note: Availability update function removed
            // With new logic, availability is only updated at checkout, not add-to-cart

            // Add to Cart Logic
            function addTicketToCart() {
                const addToCartBtn = document.getElementById('addToCartBtn');
                if (addToCartBtn.classList.contains('disabled')) {
                    console.log("Button is disabled - cannot add to cart");
                    return;
                }

                // Lấy giá trị trực tiếp từ DOM với validation
                const ticketSelect = document.getElementById('ticketTypeSelect');
                const quantityInput = document.getElementById('quantity');

                // Ensure elements exist before getting values
                if (!ticketSelect || !quantityInput) {
                    console.error("Required form elements not found");
                    alert("Form elements not found. Please reload the page.");
                    return;
                }

                const ticketId = ticketSelect.value;
                const quantity = quantityInput.value;
                const ticketDate = selectedDate ? formatDateForDatabase(selectedDate) : null;

                // Debug log for verification
                console.log("Adding to cart:", {ticketId, quantity, ticketDate});

                // Validation with detailed error messages
                if (!ticketId || ticketId === "") {
                    console.error("Ticket type not selected");
                    alert("Vui lòng chọn loại vé!");
                    return;
                }

                if (!quantity || quantity === "" || parseInt(quantity) < 1) {
                    console.error("Invalid quantity:", quantity);
                    alert("Vui lòng chọn số lượng hợp lệ!");
                    return;
                }

                if (!selectedDate || !ticketDate) {
                    console.error("Date not selected:", selectedDate);
                    alert("Vui lòng chọn ngày!");
                    return;
                }

                addToCartBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Adding...';
                addToCartBtn.classList.add('disabled');

                // Try both approaches for compatibility

                // Approach 1: FormData (modern)
                const formData = new FormData();
                formData.append('action', 'addTicket');
                formData.append('ticketId', ticketId);
                formData.append('quantity', quantity);
                formData.append('ticketDate', ticketDate);

                // Approach 2: URL-encoded (traditional servlet style)
                const urlEncodedData = new URLSearchParams();
                urlEncodedData.append('action', 'addTicket');
                urlEncodedData.append('ticketId', ticketId);
                urlEncodedData.append('quantity', quantity);
                urlEncodedData.append('ticketDate', ticketDate);

                // Send request with URL-encoded data

                fetch('cart', {
                    method: "POST",
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: urlEncodedData.toString(),
                    credentials: 'same-origin'
                })
                        .then(response => response.text())
                        .then(data => {
                            console.log("Server response:", data);
                            const validationMessage = document.getElementById('validationMessage');

                            if (data.includes('success')) {
                                validationMessage.textContent = 'Vé đã được thêm vào giỏ hàng thành công!';
                                validationMessage.className = 'validation-message success';
                                validationMessage.style.display = 'block';

                                // Don't update availability - it will be updated at checkout
                                // Just reset the form
                                document.getElementById('quantity').value = '1';

                                // Hide success message after a few seconds
                                setTimeout(() => {
                                    validationMessage.style.display = 'none';
                                }, 3000);

                            } else if (data.includes('login')) {
                                alert('Vui lòng đăng nhập để thêm vé vào giỏ hàng!');
                                window.location.href = 'Login.jsp';

                            } else if (data.includes('unavailable')) {
                                // Extract error message from response
                                const errorMsg = data.replace('unavailable: ', '');
                                validationMessage.textContent = errorMsg || 'Vé không còn đủ cho ngày đã chọn!';
                                validationMessage.className = 'validation-message error';
                                validationMessage.style.display = 'block';

                                // Special handling for cart quantity conflicts
                                if (errorMsg.includes('đã có') && errorMsg.includes('trong giỏ hàng')) {
                                    // Show additional help for cart conflicts
                                    const helpText = document.createElement('div');
                                    helpText.style.marginTop = '10px';
                                    helpText.style.fontSize = '14px';
                                    helpText.style.color = '#666';
                                    helpText.innerHTML = '💡 <strong>Gợi ý:</strong> <a href="cart.jsp" style="color: #007cba;">Kiểm tra giỏ hàng</a> để xem vé đã có hoặc giảm số lượng.';
                                    validationMessage.appendChild(helpText);
                                }

                                // Hide error message after a few seconds (no page reload needed)
                                setTimeout(() => {
                                    validationMessage.style.display = 'none';
                                    validationMessage.innerHTML = ''; // Clear any extra content
                                }, 8000); // Longer timeout for cart conflict messages

                            } else {
                                validationMessage.textContent = 'Không thể thêm vé vào giỏ hàng. Vui lòng thử lại!';
                                validationMessage.className = 'validation-message error';
                                validationMessage.style.display = 'block';
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            const validationMessage = document.getElementById('validationMessage');
                            validationMessage.textContent = 'An error occurred. Please try again.';
                            validationMessage.className = 'validation-message error';
                            validationMessage.style.display = 'block';
                        })
                        .finally(() => {
                            addToCartBtn.innerHTML = '<i class="fa fa-ticket"></i> Add Ticket to Cart';
                            addToCartBtn.classList.remove('disabled');
                            validateForm();
                        });
            }
        </script>

        <script>
            $(document).ready(function () {
                // Tab click handler - same as Product Detail
                $('.tab-link').on('click', function(e) {
                    e.preventDefault();
                    $('.tab-element').removeClass('active');
                    $('.tab-contain').removeClass('active');
                    $(this).parent().addClass('active');
                    $($(this).attr('href')).addClass('active');
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
        </script>

        <!-- Include JS files -->
        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>
    </body>
</html> 
