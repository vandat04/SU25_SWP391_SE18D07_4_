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

            /* Enhanced Ticket Details Styles */
            .ticket-details-section {
                margin-top: 40px;
            }

            .tabs-container {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .tab-head .tabs {
                display: flex;
                flex-wrap: wrap;
                gap: 5px;
                background: #f8f9fa;
                padding: 0;
                margin: 0;
                border-bottom: 1px solid #e0e0e0;
            }

            .tab-head .tab-element {
                flex: 1;
                min-width: 150px;
            }

            .tab-head .tab-link {
                padding: 15px 20px;
                font-size: 14px;
                font-weight: 500;
                color: #666;
                text-decoration: none;
                display: block;
                text-align: center;
                transition: all 0.3s ease;
                border-bottom: 3px solid transparent;
            }

            .tab-head .tab-link:hover {
                background: #e9ecef;
                color: #4CAF50;
            }

            .tab-head .tab-element.active .tab-link {
                background: white;
                color: #4CAF50;
                border-bottom-color: #4CAF50;
            }

            .tab-content {
                padding: 30px;
            }

            .tab-contain {
                display: none;
            }

            .tab-contain.active {
                display: block;
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

            /* Seller Information Styles */
            .seller-info-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
                margin-top: 20px;
            }

            .seller-profile {
                background: #f9f9f9;
                padding: 25px;
                border-radius: 8px;
                border: 1px solid #e0e0e0;
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .seller-avatar {
                flex-shrink: 0;
            }

            .seller-details h4 {
                color: #4CAF50;
                margin-bottom: 15px;
                font-size: 20px;
            }

            .seller-details p {
                margin: 8px 0;
                color: #666;
            }

            .seller-details strong {
                color: #333;
            }

            .seller-contact {
                background: #f9f9f9;
                padding: 25px;
                border-radius: 8px;
                border: 1px solid #e0e0e0;
            }

            .seller-contact h4 {
                color: #4CAF50;
                margin-bottom: 20px;
                text-align: center;
            }

            .contact-buttons {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .contact-buttons .btn {
                padding: 12px 20px;
                border-radius: 6px;
                text-decoration: none;
                text-align: center;
                font-weight: 500;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }

            .contact-buttons .btn-primary {
                background: #007bff;
                color: white;
            }

            .contact-buttons .btn-primary:hover {
                background: #0056b3;
            }

            .contact-buttons .btn-success {
                background: #28a745;
                color: white;
            }

            .contact-buttons .btn-success:hover {
                background: #1e7e34;
            }

            .contact-buttons .btn-info {
                background: #17a2b8;
                color: white;
            }

            .contact-buttons .btn-info:hover {
                background: #117a8b;
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
                                <div class="rating">
                                    <p class="star-rating"><span class="width-${village.averageRating != null ? (village.averageRating.doubleValue() * 20) : 0}percent"></span></p>
                                    <span class="review-count">(${village.totalReviews != null ? village.totalReviews : 0} Reviews)</span>
                                    <b class="category">Village: ${village.villageName}</b>
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

                    <!-- Complete Ticket Information Section -->
                    <div class="ticket-details-section single-layout">
                        <div class="tabs-container">
                            <div class="tab-head">
                                <ul class="tabs">
                                    <li class="tab-element active"><a href="#tab_village" class="tab-link">Village Information</a></li>
                                    <li class="tab-element"><a href="#tab_ticket" class="tab-link">Ticket Details</a></li>
                                    <li class="tab-element"><a href="#tab_seller" class="tab-link">Seller Information</a></li>
                                    <li class="tab-element"><a href="#tab_reviews" class="tab-link">Customer Reviews <sup>(${village.totalReviews != null ? village.totalReviews : 0})</sup></a></li>
                                </ul>
                            </div>
                            <div class="tab-content">
                                <!-- Village Information Tab -->
                                <div id="tab_village" class="tab-contain active">
                                    <h3>Complete Village Information</h3>
                                    <div class="village-details-grid">
                                        <div class="detail-section">
                                            <h4>Basic Information</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Village ID:</strong></td>
                                                    <td>${completeVillageInfo.villageID}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Village Name:</strong></td>
                                                    <td>${completeVillageInfo.villageName}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Craft Type:</strong></td>
                                                    <td>${completeVillageInfo.craftTypeName}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Status:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${completeVillageInfo.status == 1}">
                                                                <span class="status-active">Active</span>
                                                            </c:when>
                                                            <c:when test="${completeVillageInfo.status == 0}">
                                                                <span class="status-hidden">Hidden</span>
                                                            </c:when>
                                                            <c:when test="${completeVillageInfo.status == 2}">
                                                                <span class="status-pending">Pending Approval</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-unknown">Unknown</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <div class="detail-section">
                                            <h4>Location & Contact</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Address:</strong></td>
                                                    <td>${completeVillageInfo.address}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Phone:</strong></td>
                                                    <td>${completeVillageInfo.contactPhone}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Email:</strong></td>
                                                    <td>${completeVillageInfo.contactEmail}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Opening Hours:</strong></td>
                                                    <td>${completeVillageInfo.openingHours}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Closing Days:</strong></td>
                                                    <td>${completeVillageInfo.closingDays}</td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <div class="detail-section">
                                            <h4>Village Statistics</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Average Rating:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${completeVillageInfo.averageRating != null and completeVillageInfo.averageRating > 0}">
                                                                <fmt:formatNumber value="${completeVillageInfo.averageRating}" pattern="0.0"/> / 5.0
                                                            </c:when>
                                                            <c:otherwise>
                                                                No ratings yet
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Total Reviews:</strong></td>
                                                    <td>${completeVillageInfo.totalReviews}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Click Count:</strong></td>
                                                    <td>${completeVillageInfo.clickCount}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Created Date:</strong></td>
                                                    <td><fmt:formatDate pattern="dd/MM/yyyy HH:mm" value="${completeVillageInfo.createdDate}" /></td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <div class="detail-section">
                                            <h4>Cultural Information</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>History:</strong></td>
                                                    <td>${completeVillageInfo.history}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Special Features:</strong></td>
                                                    <td>${completeVillageInfo.specialFeatures}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Famous Products:</strong></td>
                                                    <td>${completeVillageInfo.famousProducts}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Cultural Events:</strong></td>
                                                    <td>${completeVillageInfo.culturalEvents}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Craft Process:</strong></td>
                                                    <td>${completeVillageInfo.craftProcess}</td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <div class="detail-section">
                                            <h4>Travel Information</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Travel Tips:</strong></td>
                                                    <td>${completeVillageInfo.travelTips}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Virtual Tour:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty completeVillageInfo.virtualTourUrl}">
                                                                <a href="${completeVillageInfo.virtualTourUrl}" target="_blank">View Virtual Tour</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Not available
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Map Embed:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty completeVillageInfo.mapEmbedUrl}">
                                                                <a href="${completeVillageInfo.mapEmbedUrl}" target="_blank">View on Map</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Not available
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Ticket Details Tab -->
                                <div id="tab_ticket" class="tab-contain">
                                    <h3>Complete Ticket Information</h3>
                                    <div class="ticket-details-grid">
                                        <div class="detail-section">
                                            <h4>Ticket Information</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Ticket ID:</strong></td>
                                                    <td>${completeTicketInfo.ticketID}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Ticket Type:</strong></td>
                                                    <td>${completeTicketInfo.ticketTypeName}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Type Description:</strong></td>
                                                    <td>${completeTicketInfo.ticketTypeDescription}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Age Range:</strong></td>
                                                    <td>${completeTicketInfo.ageRange}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Price:</strong></td>
                                                    <td><fmt:formatNumber value="${completeTicketInfo.price}" type="currency"/></td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Status:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${completeTicketInfo.ticketStatus == 1}">
                                                                <span class="status-active">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-hidden">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <div class="detail-section">
                                            <h4>Village Information</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Village Name:</strong></td>
                                                    <td>${completeTicketInfo.villageName}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Village Description:</strong></td>
                                                    <td>${completeTicketInfo.villageDescription}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Village Address:</strong></td>
                                                    <td>${completeTicketInfo.villageAddress}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Village Phone:</strong></td>
                                                    <td>${completeTicketInfo.villagePhone}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Village Email:</strong></td>
                                                    <td>${completeTicketInfo.villageEmail}</td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <div class="detail-section">
                                            <h4>Village Statistics</h4>
                                            <table class="detail-table">
                                                <tr>
                                                    <td><strong>Village Rating:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${completeTicketInfo.villageRating != null and completeTicketInfo.villageRating > 0}">
                                                                <fmt:formatNumber value="${completeTicketInfo.villageRating}" pattern="0.0"/> / 5.0
                                                            </c:when>
                                                            <c:otherwise>
                                                                No ratings yet
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Total Reviews:</strong></td>
                                                    <td>${completeTicketInfo.villageTotalReviews}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Opening Hours:</strong></td>
                                                    <td>${completeTicketInfo.openingHours}</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Closing Days:</strong></td>
                                                    <td>${completeTicketInfo.closingDays}</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Seller Information Tab -->
                                <div id="tab_seller" class="tab-contain">
                                    <h3>Seller Information</h3>
                                    <div class="seller-info-container">
                                        <div class="seller-profile">
                                            <div class="seller-avatar">
                                                <i class="fa fa-user-circle" style="font-size: 80px; color: #4CAF50;"></i>
                                            </div>
                                            <div class="seller-details">
                                                <h4>${completeVillageInfo.sellerName}</h4>
                                                <p><strong>Email:</strong> ${completeVillageInfo.sellerEmail}</p>
                                                <p><strong>Phone:</strong> ${completeVillageInfo.sellerPhone}</p>
                                                <p><strong>Address:</strong> ${completeVillageInfo.sellerAddress}</p>
                                                <p><strong>Village:</strong> ${completeVillageInfo.villageName}</p>
                                            </div>
                                        </div>
                                        <div class="seller-contact">
                                            <h4>Contact Seller</h4>
                                            <div class="contact-buttons">
                                                <a href="mailto:${completeVillageInfo.sellerEmail}" class="btn btn-primary">
                                                    <i class="fa fa-envelope"></i> Send Email
                                                </a>
                                                <a href="tel:${completeVillageInfo.sellerPhone}" class="btn btn-success">
                                                    <i class="fa fa-phone"></i> Call Seller
                                                </a>
                                                <a href="village-details?villageID=${completeVillageInfo.villageID}" class="btn btn-info">
                                                    <i class="fa fa-map-marker"></i> Visit Village
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Reviews Tab -->
                                <div id="tab_reviews" class="tab-contain">
                                    <div class="container">
                                        <div class="row">
                                            <div class="col-lg-5 col-md-5 col-sm-6 col-xs-12">
                                                <div class="rating-info">
                                                    <p class="index"><strong class="rating"><c:choose><c:when test="${village.averageRating != null and village.averageRating > 0}"><fmt:formatNumber value="${village.averageRating}" pattern="0.0"/></c:when><c:otherwise>0.0</c:otherwise></c:choose></strong>out of 5</p>
                                                    <div class="rating">
                                                        <p class="star-rating"><span class="width-<c:choose><c:when test="${village.averageRating != null and village.averageRating > 0}">${village.averageRating.doubleValue() * 20}</c:when><c:otherwise>0</c:otherwise></c:choose>percent"></span></p>
                                                    </div>
                                                    <p class="see-all">See all <c:choose><c:when test="${village.totalReviews > 0}">${village.totalReviews}</c:when><c:otherwise>0</c:otherwise></c:choose> reviews</p>
                                                    
                                                    <!-- Rating Distribution -->
                                                    <ul class="options">
                                                        <c:forEach var="i" begin="0" end="4">
                                                            <li>
                                                                <div class="detail-for">
                                                                    <span class="option-name">${5 - i} stars</span>
                                                                    <span class="progres">
                                                                        <span class="line-100percent">
                                                                            <span class="percent width-${totalReviews > 0 ? (ratingDistribution[4 - i] * 100 / totalReviews) : 0}percent"></span>
                                                                        </span>
                                                                    </span>
                                                                    <span class="number">${ratingDistribution[4 - i]}</span>
                                                                </div>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12">
                                                <div class="review-form-wrapper">
                                                    <span class="title">Add your review</span>
                                                    <form action="TicketDetailControl" method="post">
                                                        <input type="hidden" name="villageID" value="${villageID}" />
                                                        <c:choose>
                                                            <c:when test="${not empty sessionScope.acc}">
                                                                <c:choose>
                                                                    <c:when test="${canUserReviewVillage}">
                                                                        <label>1. Đánh giá của bạn về làng nghề:</label>
                                                                        <input type="number" name="rating" min="1" max="5" required />
                                                                        <textarea name="content" placeholder="Viết đánh giá của bạn..." required></textarea>
                                                                        <button type="submit">Gửi đánh giá</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="review-warning">
                                                                            <span>${reviewMessageVillage}</span>
                                                                            <ul>
                                                                                <li>✓ Đã đặt vé tham quan làng nghề này</li>
                                                                                <li>✓ Vé đã sử dụng và thanh toán thành công</li>
                                                                            </ul>
                                                                            <a href="ticket-history">Kiểm tra vé của bạn</a>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="review-warning">
                                                                    Vui lòng <a href="login.jsp">đăng nhập</a> để viết đánh giá.
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </div>

                                                <!-- Display Reviews -->
                                                <div class="review-list">
                                                    <!-- Debug info -->
                                                    <div style="background: #f0f0f0; padding: 5px; margin: 5px 0; font-size: 12px;">
                                                        Debug: villageReviews=${villageReviews != null ? 'NOT NULL' : 'NULL'}, 
                                                        size=${villageReviews != null ? villageReviews.size() : 'N/A'}
                                                    </div>
                                                    <c:if test="${not empty villageReviews}">
                                                        <div>Test: ${villageReviews.size()}</div>
                                                        <c:forEach var="review" items="${villageReviews}">
                                                        <div class="review-item">
                                                            <div class="reviewer-info">
                                                                <h4>${review.userName}</h4>
                                                                <div class="rating">
                                                                    <p class="star-rating">
                                                                        <span class="width-${review.rating * 20}percent"></span>
                                                                    </p>
                                                                </div>
                                                                <span class="review-date">
                                                                    <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                            </div>
                                                            <div class="review-content">
                                                                <p>${review.reviewText}</p>
                                                                
                                                                <!-- Admin Response Section -->
                                                                <c:choose>
                                                                    <c:when test="${not empty review.response}">
                                                                        <div class="review-response" style="background: #f7f7f7; padding: 10px; margin-top: 10px; border-left: 3px solid #4CAF50;">
                                                                            <strong>Admin Response:</strong>
                                                                            <p style="margin:0;">${review.response}</p>
                                                                            <small style="color: #666;">
                                                                                <fmt:formatDate pattern="dd/MM/yyyy HH:mm" value="${review.responseDate}" />
                                                                            </small>
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
                                                        </c:forEach>
                                                    </c:if>
                                                    <c:if test="${empty villageReviews}">
                                                        <p>No reviews yet. Be the first to review this village!</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
document.addEventListener('DOMContentLoaded', function () {
    // Tab click handler
    document.querySelectorAll('.tab-link').forEach(function(tabLink) {
        tabLink.addEventListener('click', function(e) {
            e.preventDefault();
            // Xóa active ở tất cả tab
            document.querySelectorAll('.tab-element').forEach(function(tab) {
                tab.classList.remove('active');
            });
            document.querySelectorAll('.tab-contain').forEach(function(tabContent) {
                tabContent.classList.remove('active');
            });
            // Thêm active cho tab được chọn
            this.parentElement.classList.add('active');
            var target = this.getAttribute('href');
            document.querySelector(target).classList.add('active');
        });
    });

    // Nếu có hash trên URL (ví dụ #tab_reviews), tự động mở tab đó
    if(window.location.hash) {
        var hash = window.location.hash;
        var tabLink = document.querySelector('.tab-link[href="' + hash + '"]');
        if(tabLink) {
            tabLink.click();
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
