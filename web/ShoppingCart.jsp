<%-- ShoppingCart.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0">
        <title>Da Nang Craft Village</title>
        <!-- Fonts & Favicon -->
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&amp;display=swap" rel="stylesheet">
        <link rel="shortcut icon" type="image/x-icon" href="hinh anh/Logo/cropped-Favicon-1-32x32.png" />
        <!-- Stylesheets -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        <style>
            /* Remove button styling */
            .btn-remove {
                background: none;
                border: none;
                color: #666;
                cursor: pointer;
                font-size: 16px;
                padding: 5px 8px;
                border-radius: 3px;
                transition: all 0.3s ease;
            }
            .btn-remove:hover {
                color: #e74c3c;
                background-color: #f8f9fa;
            }
            .fa-times {
                font-size: 18px;
            }

            /* Table styling for both products and tickets */
            .shop_table.cart-form {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }

            .shop_table.cart-form th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #333;
                padding: 15px 10px;
                border-bottom: 2px solid #dee2e6;
                text-align: left;
            }

            .shop_table.cart-form td {
                padding: 15px 10px;
                vertical-align: middle;
                border-bottom: 1px solid #dee2e6;
            }

            /* Product table specific styling */
            .price-total-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            /* Ticket table specific styling */
            .ticket-type-cell {
                font-weight: 500;
                color: #333;
            }

            .ticket-village-cell {
                color: #666;
                font-size: 14px;
            }

            .ticket-date-cell {
                color: #999;
                font-size: 13px;
            }

            .ticket-action-cell {
                text-align: center;
                width: 60px;
            }

            /* Quantity form styling */
            .quantity-box.type1 .qty-input form,
            .ticket-quantity-cell form {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            input[type="number"] {
                height: 35px;
                padding: 0 10px;
                border: 1px solid #e6e6e6;
                border-radius: 4px;
                text-align: center;
            }

            .quantity-box.type1 .qty-input input[type="number"] {
                width: 80px;
            }

            .ticket-quantity-cell input[type="number"] {
                width: 60px;
            }

            .btn.btn-info {
                padding: 5px 10px;
                font-size: 12px;
                border-radius: 4px;
                background-color: #17a2b8;
                border-color: #17a2b8;
                color: white;
            }

            .btn.btn-info:hover {
                background-color: #138496;
                border-color: #117a8b;
            }

            /* Price styling consistency */
            .price.price-contain {
                margin: 0;
            }

            .price-amount {
                font-weight: 500;
                color: #7FAF51;
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

        <!-- Toast Messages -->
        <div class="success-message" id="successMessage" style="display:none;"><i class="fa fa-circle-check"></i> Thao tác thành công!</div>
        <div class="success-message" id="errorMessage" style="background: #e74c3c; z-index: 1003; display:none;"></div>

        <!-- Custom Popup Modal -->
        <div id="customPopup" class="custom-popup" style="display:none;">
            <div class="popup-content">
                <div class="popup-header">
                    <h3 id="popupTitle">Xác nhận</h3>
                    <button class="popup-close" onclick="closePopup()">&times;</button>
                </div>
                <div class="popup-body">
                    <p id="popupMessage">Bạn có chắc chắn muốn thực hiện hành động này?</p>
                </div>
                <div class="popup-footer">
                    <button class="btn btn-secondary" onclick="closePopup()">Hủy</button>
                    <button class="btn btn-primary" id="popupConfirmBtn" onclick="confirmPopupAction()">Xác nhận</button>
                </div>
            </div>
        </div>

            <!-- Hero Section -->
            <div class="hero-section hero-background">
                <h1 class="page-title">Cart</h1>
            </div>

            <!-- Navigation section -->
            <div class="container">
                <nav class="biolife-nav">
                    <ul>
                        <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                        <li class="nav-item"><span class="current-page">ShoppingCart</span></li>
                    </ul>
                </nav>
            </div>

            <!-- Main content -->
            <div class="page-contain shopping-cart">
                <div id="main-content" class="main-content">
                    <div class="container">
                        <div class="shopping-cart-container">
                            <div class="row">
                                <div class="col-lg-9 col-md-12 col-sm-12 col-xs-12">

                                    <!-- ✅ NEW: Stock Validation Messages -->
                                <c:if test="${not empty stockMessage}">
                                    <div class="alert alert-${stockMessageType} alert-dismissible fade show" role="alert" style="margin-bottom: 20px;">
                                        <i class="fa ${stockMessageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle'}"></i>
                                        <strong>${stockMessage}</strong>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <!-- ✅ NEW: Comprehensive Issues Warning -->
                                <c:if test="${hasAnyIssues}">
                                    <div class="alert alert-${issuePriority == 'high' ? 'danger' : (issuePriority == 'medium' ? 'warning' : 'info')}" role="alert" style="margin-bottom: 20px;">
                                        <h4 class="alert-heading">
                                            <i class="fa ${issuePriority == 'high' ? 'fa-exclamation-circle' : 'fa-warning'}"></i> 
                                            ${issuePriority == 'high' ? 'Vấn đề nghiêm trọng!' : 'Cần kiểm tra!'}
                                        </h4>
                                        <p class="mb-3"><strong>${stockValidationSummary}</strong></p>
                                        <p class="mb-3">Your shopping cart has some issues that need to be resolved before checkout:</p>

                                        <!-- Show specific issues -->
                                        <c:if test="${hasStockIssues}">
                                            <div class="issue-detail">
                                                <i class="fa fa-box"></i> <strong>Product:</strong> ${stockValidation.validationSummary}
                                            </div>
                                        </c:if>

                                        <c:if test="${hasTicketIssues}">
                                            <div class="issue-detail">
                                                <i class="fa fa-ticket"></i> <strong>Ticket:</strong> ${ticketValidation.ticketValidationSummary}
                                            </div>
                                        </c:if>

                                        <div class="d-flex gap-2 mt-3">
                                            <button onclick="confirmRemoveOutOfStock()" class="btn btn-danger btn-sm">
                                                <i class="fa fa-trash"></i> Delete out of stock items completely
                                            </button>
                                            <button onclick="confirmAdjustQuantities()" class="btn btn-warning btn-sm">
                                                <i class="fa fa-edit"></i> Adjust quantity according to inventory
                                            </button>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Cart Products Table -->
                                <h3 class="box-title">Your cart items (Products)</h3>
                                <div class="shopping-cart-container">
                                    <table class="shop_table cart-form">
                                        <thead>
                                            <tr>
                                                <th class="product-name">Product Name</th>
                                                <th class="product-price">Price</th>
                                                <th class="product-quantity">Quantity</th>
                                                <th class="product-subtotal">Total</th>
                                                <th class="product-status">Stock Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty cartItems}">
                                                    <tr>
                                                        <td colspan="5" class="text-center">
                                                            <div class="empty-cart-container" style="padding: 30px; text-align: center;">
                                                                <h3 style="color: #666; margin-bottom: 15px;">Your cart is empty</h3>
                                                                <p style="color: #999; margin-bottom: 20px;">Add products to cart to continue shopping</p>
                                                                <a href="home" class="btn btn-primary">Continue shopping</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${cartItems}" var="item" varStatus="status">
                                                        <!-- ✅ NEW: Find validation result for current item -->
                                                        <c:set var="itemValidation" value="" />
                                                        <c:set var="isOutOfStock" value="false" />
                                                        <c:set var="hasInsufficientStock" value="false" />
                                                        <c:set var="availableStock" value="0" />
                                                        <c:set var="stockMessage" value="" />

                                                        <c:if test="${not empty invalidItems}">
                                                            <c:forEach items="${invalidItems}" var="invalidItem">
                                                                <c:if test="${invalidItem.item.productID == item.productID}">
                                                                    <c:set var="itemValidation" value="${invalidItem.result}" />
                                                                    <c:set var="isOutOfStock" value="${invalidItem.result.availableStock == 0}" />
                                                                    <c:set var="hasInsufficientStock" value="${invalidItem.result.availableStock > 0 && invalidItem.result.availableStock < item.quantity}" />
                                                                    <c:set var="availableStock" value="${invalidItem.result.availableStock}" />
                                                                    <c:set var="stockMessage" value="${invalidItem.result.message}" />
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:if>

                                                        <tr class="cart_item ${isOutOfStock ? 'out-of-stock-item' : (hasInsufficientStock ? 'insufficient-stock-item' : '')}">
                                                            <td class="product-thumbnail" data-title="Product Name">
                                                                <a class="prd-thumb" href="#">
                                                                    <figure><img width="113" height="113" src="${item.imageUrl}" alt="shipping cart"></figure>
                                                                </a>
                                                                <a class="prd-name ${isOutOfStock ? 'out-of-stock-text' : ''}" href="#">${item.productName}</a>
                                                            </td>
                                                            <td class="product-price" data-title="Price">
                                                                <div class="price price-contain">
                                                                    <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${item.price}" type="currency"/></span></ins>
                                                                </div>
                                                            </td>
                                                            <td class="product-quantity" data-title="Quantity">
                                                                <div class="quantity-box type1">
                                                                    <div class="qty-input">
                                                                        <c:choose>
                                                                            <c:when test="${isOutOfStock}">
                                                                                <div class="out-of-stock-notice" style="padding: 10px; background-color: #ffcdd2; border-radius: 4px; text-align: center;">
                                                                                    <strong style="color: #d32f2f;">OUT OF STOCK</strong>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <form action="cart" method="POST" style="display:flex;align-items:center;" onsubmit="return handleQuantityUpdate(this, 'product')">
                                                                                    <input type="hidden" name="action" value="update">
                                                                                    <input type="hidden" name="id" value="${item.productID}">
                                                                                    <input type="hidden" name="timestamp" value="<%= System.currentTimeMillis()%>">
                                                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" 
                                                                                           class="quantity-input ${hasInsufficientStock ? 'insufficient-stock-input' : ''}"
                                                                                           oninput="this.value = Math.abs(this.value || 1)">
                                                                                    <button type="submit" class="btn btn-info" style="padding:5px 10px; margin-left:10px;">
                                                                                        <i class="fa fa-refresh"></i> Update
                                                                                    </button>
                                                                                </form>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td class="product-subtotal" data-title="Total">
                                                                <div class="price-total-container" style="display: flex; justify-content: space-between; align-items: center;">
                                                                    <div class="price price-contain">
                                                                        <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${item.price * item.quantity}" type="currency"/></span></ins>
                                                                    </div>
                                                                    <form action="cart" method="POST" style="display: inline;" onsubmit="return handleRemoveItem(this, 'product')">
                                                                        <input type="hidden" name="action" value="remove">
                                                                        <input type="hidden" name="id" value="${item.productID}">
                                                                        <input type="hidden" name="timestamp" value="<%= System.currentTimeMillis()%>">
                                                                        <button type="submit" class="btn-remove">
                                                                            <i class="fa fa-times" aria-hidden="true"></i>
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                            <td class="product-status" data-title="Stock Status">
                                                                <c:choose>
                                                                    <c:when test="${isOutOfStock}">
                                                                        <span class="badge badge-danger" style="background-color: #d32f2f; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-times-circle"></i> Out of stock
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${hasInsufficientStock}">
                                                                        <span class="badge badge-warning" style="background-color: #ff9800; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-warning"></i> Only ${availableStock} left 
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-success" style="background-color: #4caf50; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-check-circle"></i> Available
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <c:if test="${not empty stockMessage}">
                                                                    <div class="stock-message" style="font-size: 12px; color: #666; margin-top: 5px;">
                                                                        ${stockMessage}
                                                                    </div>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- ✅ FIXED: Cart Tickets Table - Always show like Products -->
                                <h3 class="box-title" style="margin-top: 30px;">Your cart items (Tickets)</h3>
                                <div class="shopping-cart-container">
                                    <table class="shop_table cart-form">
                                        <thead>
                                            <tr>
                                                <th>Ticket Type</th>
                                                <th>Village</th>
                                                <th>Date</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Total</th>
                                                <th>Availability Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty cartTickets}">
                                                    <tr>
                                                        <td colspan="8" class="text-center">
                                                            <div class="empty-cart-container" style="padding: 30px; text-align: center;">
                                                                <h3 style="color: #666; margin-bottom: 15px;">There are no tickets in your cart.</h3>
                                                                <p style="color: #999; margin-bottom: 20px;">Please add tickets to cart to continue booking tour</p>
                                                                <a href="home" class="btn btn-primary">See available tours</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- ✅ Declare current date once for all tickets --%>
                                                    <jsp:useBean id="currentDateForTickets" class="java.util.Date" />
                                                    <c:forEach items="${cartTickets}" var="ticket" varStatus="status">
                                                        <!-- ✅ NEW: Find ticket validation result -->
                                                        <c:set var="ticketValidation" value="" />
                                                        <c:set var="isSoldOut" value="false" />
                                                        <c:set var="hasLimitedAvailability" value="false" />
                                                        <c:set var="hasDateIssue" value="false" />
                                                        <c:set var="availableSlots" value="0" />
                                                        <c:set var="validationMessage" value="" />

                                                        <%-- ✅ Always check date validation for ALL tickets --%>
                                                        <c:if test="${ticket.ticketDate.time < currentDateForTickets.time}">
                                                            <c:set var="hasDateIssue" value="true" />
                                                            <c:set var="validationMessage" value="Ngày vé đã qua (${ticket.formattedTicketDate})" />
                                                        </c:if>
                                                        <c:if test="${ticket.ticketDate.time > currentDateForTickets.time + (365 * 24 * 60 * 60 * 1000)}">
                                                            <c:set var="hasDateIssue" value="true" />
                                                            <c:set var="validationMessage" value="Ngày vé quá xa trong tương lai (${ticket.formattedTicketDate})" />
                                                        </c:if>

                                                        <c:if test="${not empty invalidTickets}">
                                                            <c:forEach items="${invalidTickets}" var="invalidTicket">
                                                                <c:if test="${invalidTicket.ticket.cartTicketId == ticket.cartTicketId}">
                                                                    <c:set var="ticketValidation" value="${invalidTicket.result}" />
                                                                    <c:set var="isSoldOut" value="${invalidTicket.result.fullyBooked}" />
                                                                    <c:set var="hasLimitedAvailability" value="${invalidTicket.result.availableSlots > 0 && invalidTicket.result.availableSlots < ticket.quantity}" />
                                                                    <c:set var="hasDateIssue" value="${invalidTicket.result.message.contains('date') || invalidTicket.result.message.contains('ngày') || invalidTicket.result.message.contains('quá khứ') || invalidTicket.result.message.contains('quá xa')}" />
                                                                    <c:set var="availableSlots" value="${invalidTicket.result.availableSlots}" />
                                                                    <c:set var="validationMessage" value="${invalidTicket.result.message}" />


                                                                </c:if>
                                                            </c:forEach>
                                                        </c:if>

                                                        <tr class="cart_ticket_item ${isSoldOut ? 'sold-out-ticket' : (hasLimitedAvailability ? 'limited-availability-ticket' : (hasDateIssue ? 'date-issue-ticket' : ''))}">

                                                            <td class="ticket-type-cell">
                                                                <span class="${isSoldOut ? 'sold-out-text' : (hasLimitedAvailability ? 'limited-availability-text' : (hasDateIssue ? 'date-issue-text' : ''))}">${ticket.ticketTypeName}</span>
                                                            </td>
                                                            <td class="ticket-village-cell">
                                                                <span class="${isSoldOut || hasLimitedAvailability || hasDateIssue ? 'dimmed-text' : ''}">${ticket.villageName}</span>
                                                            </td>
                                                            <td class="ticket-date-cell">
                                                                <span class="${hasDateIssue ? 'date-issue-date' : (isSoldOut || hasLimitedAvailability ? 'dimmed-text' : '')}">${ticket.formattedTicketDate}</span>
                                                            </td>
                                                            <td class="ticket-price-cell">
                                                                <div class="price price-contain ${isSoldOut || hasLimitedAvailability || hasDateIssue ? 'dimmed-price' : ''}">
                                                                    <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${ticket.price}" type="currency"/></span></ins>
                                                                </div>
                                                            </td>
                                                            <td class="ticket-quantity-cell">
                                                                <div class="quantity-box type1">
                                                                    <div class="qty-input">
                                                                        <c:choose>
                                                                            <c:when test="${isSoldOut}">
                                                                                <div class="ticket-issue-notice" style="padding: 10px; background-color: #ffcdd2; border-radius: 4px; text-align: center;">
                                                                                    <strong style="color: #d32f2f;">SOLD OUT</strong>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <form action="cart" method="POST" style="display:flex;align-items:center;" onsubmit="return handleQuantityUpdate(this, 'ticket')">
                                                                                    <input type="hidden" name="action" value="updateTicket">
                                                                                    <input type="hidden" name="itemId" value="${ticket.cartTicketId}">
                                                                                    <input type="hidden" name="timestamp" value="<%= System.currentTimeMillis()%>">
                                                                                    <input type="number" name="quantity" value="${ticket.quantity}" min="1" 
                                                                                           class="ticket-quantity-input ${hasLimitedAvailability ? 'limited-availability-input' : (hasDateIssue ? 'date-issue-input' : '')}"
                                                                                           oninput="this.value = Math.abs(this.value || 1)">
                                                                                    <button type="submit" class="btn btn-info" style="padding:5px 10px; margin-left:10px;">
                                                                                        <i class="fa fa-refresh"></i> Update
                                                                                    </button>
                                                                                </form>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td class="ticket-total-cell">
                                                                <div class="price price-contain">
                                                                    <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${ticket.price * ticket.quantity}" type="currency"/></span></ins>
                                                                </div>
                                                            </td>
                                                            <td class="ticket-availability-cell">
                                                                <c:choose>
                                                                    <c:when test="${isSoldOut}">
                                                                        <span class="badge badge-danger" style="background-color: #d32f2f; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-times-circle"></i> Hết vé
                                                                        </span>
                                                                        <div class="availability-message" style="font-size: 12px; color: #d32f2f; margin-top: 5px; font-weight: bold;">
                                                                            ⚠️ Vé đã bán hết hoàn toàn!
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${hasDateIssue}">
                                                                        <span class="badge badge-warning" style="background-color: #e91e63; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-calendar-times"></i> Vấn đề ngày
                                                                        </span>
                                                                        <div class="availability-message" style="font-size: 12px; color: #e91e63; margin-top: 5px; font-weight: bold;">
                                                                            ⚠️ Ngày không hợp lệ!
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${hasLimitedAvailability}">
                                                                        <span class="badge badge-warning" style="background-color: #ff9800; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-warning"></i> Chỉ còn ${availableSlots} vé
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-success" style="background-color: #4caf50; color: white; padding: 5px 10px; border-radius: 12px;">
                                                                            <i class="fa fa-check-circle"></i> Có sẵn
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <c:if test="${not empty validationMessage}">
                                                                    <div class="availability-message" style="font-size: 12px; color: #666; margin-top: 5px;">
                                                                        ${validationMessage}
                                                                    </div>
                                                                </c:if>
                                                            </td>
                                                            <td class="ticket-action-cell">
                                                                <form action="cart" method="POST" style="display: inline;" onsubmit="return handleRemoveItem(this, 'ticket')">
                                                                    <input type="hidden" name="action" value="removeTicket">
                                                                    <input type="hidden" name="itemId" value="${ticket.cartTicketId}">
                                                                    <input type="hidden" name="timestamp" value="<%= System.currentTimeMillis()%>">
                                                                    <button type="submit" class="btn-remove">
                                                                        <i class="fa fa-times" aria-hidden="true"></i>
                                                                    </button>
                                                                </form>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Tổng tiền và các nút điều khiển -->
                                <p style="font-size: 24px; color: #7FAF51; font-weight: bold;">
                                    Total: <fmt:formatNumber value="${grandTotal}" type="currency"/>
                                </p>
                                <div class="wrap-btn-control" style="margin-bottom: 30px;">
                                    <a href="home" class="btn back-to-shop">Back to Shop</a>
                                    <form action="cart" method="post" style="display: inline;" onsubmit="return handleClearCart(this)">
                                        <input type="hidden" name="action" value="clear">
                                        <input type="hidden" name="timestamp" value="<%= System.currentTimeMillis()%>">
                                        <button type="submit" class="btn btn-clear">Clear Cart</button>
                                    </form>
                                    <a href="checkout-before?grandTotal=${grandTotal}" class="btn btn-update">Checkout</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="Footer.jsp"></jsp:include>

        <!-- Mobile Footer & Global Panel -->
        <!-- ... (giữ nguyên như cũ, không cần thay đổi) ... -->

        <!-- Scripts -->
        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.countdown.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/jquery.nicescroll.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>

        <!-- ✅ NEW: Stock Validation Styles -->
        <style>
            .out-of-stock-item {
                border-left: 4px solid #d32f2f !important;
            }

            .insufficient-stock-item {
                border-left: 4px solid #ff9800 !important;
            }

            .stock-warning-banner {
                background: linear-gradient(45deg, #ffecb3, #fff3e0);
                border: 1px solid #ff9800;
                border-radius: 8px;
                padding: 15px;
                margin: 15px 0;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    box-shadow: 0 0 0 0 rgba(255, 152, 0, 0.4);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(255, 152, 0, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(255, 152, 0, 0);
                }
            }

            .stock-status-column {
                min-width: 120px;
                text-align: center;
            }

            .out-of-stock-notice {
                font-weight: bold;
                text-align: center;
                padding: 8px;
                background-color: #ffcdd2;
                border-radius: 4px;
                color: #d32f2f;
            }

            .stock-actions {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }

            .stock-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
            }

            .stock-badge.available {
                background-color: #4caf50;
                color: white;
            }

            .stock-badge.insufficient {
                background-color: #ff9800;
                color: white;
            }

            .stock-badge.out-of-stock {
                background-color: #d32f2f;
                color: white;
            }

            .cart-item-highlight {
                transition: all 0.3s ease;
            }

            .cart-item-highlight:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .alert-custom {
                border-radius: 8px;
                border: none;
                padding: 15px 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .alert-custom .alert-heading {
                margin-bottom: 10px;
                font-weight: bold;
            }

            .btn-stock-action {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .btn-stock-action:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .btn-stock-action.danger {
                background-color: #d32f2f;
                color: white;
            }

            .btn-stock-action.warning {
                background-color: #ff9800;
                color: white;
            }

            .quantity-input-warning {
                border-color: #ff9800 !important;
                background-color: #fff3e0 !important;
            }

            .quantity-input-error {
                border-color: #d32f2f !important;
                background-color: #ffebee !important;
            }
        </style>

        <script>
                                        // Notification functions (exactly matching product.jsp)
                                        function showSuccessMessage() {
                                            const message = document.getElementById('successMessage');
                                            message.style.display = 'block';
                                            setTimeout(() => {
                                                message.style.display = 'none';
                                            }, 3000);
                                        }
                                        
                                        function showErrorMessage(msg) {
                                            let message = document.getElementById('errorMessage');
                                            if (!message) {
                                                message = document.createElement('div');
                                                message.id = 'errorMessage';
                                                message.className = 'success-message';
                                                message.style.background = '#e74c3c';
                                                message.style.zIndex = 1003;
                                                document.body.appendChild(message);
                                            }
                                            message.innerHTML = '<i class="fa fa-circle-xmark"></i> ' + msg;
                                            message.style.display = 'block';
                                            setTimeout(() => {
                                                message.style.display = 'none';
                                            }, 3500);
                                        }

                                        $(document).ready(function () {
                                            // Prevent browser caching
                                            window.history.replaceState(null, null, window.location.href);

                                            // Force refresh input values to prevent cached values
                                            $('input[type="number"]').each(function () {
                                                var currentValue = $(this).val();
                                                $(this).val('');
                                                $(this).val(currentValue);
                                            });

                                            // Add cache-busting timestamp to all forms
                                            $('form[action="cart"]').each(function() {
                                                if (!$(this).find('input[name="timestamp"]').length) {
                                                    $(this).append('<input type="hidden" name="timestamp" value="' + Date.now() + '">');
                                                }
                                            });

                                            // Handle quantity input changes to ensure fresh values
                                            $('input[name="quantity"]').on('focus', function () {
                                                // Clear any cached value and set to current value
                                                var currentValue = $(this).val();
                                                $(this).val('');
                                                $(this).val(currentValue);
                                                $(this).select(); // Select all text for easy editing
                                            });

                                            // Prevent form resubmission on page reload
                                            if (window.history.replaceState) {
                                                window.history.replaceState(null, null, window.location.href);
                                            }

                                            // Clear any pending form data
                                            if (typeof (Storage) !== "undefined") {
                                                sessionStorage.removeItem('formData');
                                            }

                                            // ✅ NEW: Stock validation enhancements

                                            // Auto-dismiss alerts after 5 seconds
                                            setTimeout(function () {
                                                $('.alert').fadeOut('slow');
                                            }, 5000);

                                            // Add animation to out-of-stock items
                                            $('.out-of-stock-item').each(function () {
                                                $(this).addClass('cart-item-highlight');
                                            });

                                            // Add hover effects to stock badges
                                            $('.stock-badge').hover(
                                                    function () {
                                                        $(this).css('transform', 'scale(1.05)');
                                                    },
                                                    function () {
                                                        $(this).css('transform', 'scale(1)');
                                                    }
                                            );

                                            // Validate quantity input for items with stock issues
                                            $('input[name="quantity"]').on('input', function () {
                                                var $input = $(this);
                                                var maxStock = parseInt($input.attr('max') || 999);
                                                var currentValue = parseInt($input.val());

                                                // Remove existing warning classes
                                                $input.removeClass('quantity-input-warning quantity-input-error');

                                                if (currentValue > maxStock) {
                                                    $input.addClass('quantity-input-error');
                                                    $input.val(maxStock);
                                                } else if (currentValue === maxStock) {
                                                    $input.addClass('quantity-input-warning');
                                                }
                                            });

                                            // Confirmation for stock actions
                                            $('.btn-stock-action').click(function (e) {
                                                var actionText = $(this).text().trim();
                                                var confirmMessage = 'Bạn có chắc muốn ' + actionText.toLowerCase() + '?';

                                                if (!confirm(confirmMessage)) {
                                                    e.preventDefault();
                                                }
                                            });

                                            // Highlight stock issues on page load
                                            if ($('.out-of-stock-item').length > 0 || $('.insufficient-stock-item').length > 0) {
                                                $('html, body').animate({
                                                    scrollTop: $('.stock-warning-banner').offset().top - 100
                                                }, 1000);
                                            }

                                            // Close popup when clicking outside
                                            $('#customPopup').click(function(e) {
                                                if (e.target === this) {
                                                    closePopup();
                                                }
                                            });

                                            // Close popup with Escape key
                                            $(document).keydown(function(e) {
                                                if (e.key === 'Escape' && $('#customPopup').is(':visible')) {
                                                    closePopup();
                                                }
                                            });


                                        });

                                        // Function to force form refresh
                                        function refreshFormValues() {
                                            $('input[type="number"]').each(function () {
                                                $(this).val($(this).val());
                                            });
                                        }

                                        // ✅ NEW: Stock validation functions

                                        // Function to handle stock action confirmations
                                        function handleStockAction(action, message) {
                                            if (confirm(message)) {
                                                window.location.href = 'cart?action=view&stockAction=' + action;
                                            }
                                        }

                                        // ✅ NEW: Confirmation functions for the buttons
                                        function confirmRemoveOutOfStock() {
                                            var message = "⚠️ WARNING: Are you sure you want to DELETE ALL products/tickets that are completely OUT OF STOCK?\n\n" +
                                                    "Note: Only items that are completely OUT OF STOCK (0 remaining) will be deleted.\n" +
                                                    "Items that are only missing quantity will NOT be deleted.\n\n" +
                                                    "Do you want to continue?";

                                            if (confirm(message)) {
                                                window.location.href = 'cart?action=view&stockAction=removeOutOfStock';
                                            }
                                        }

                                        function confirmAdjustQuantities() {
                                            var message = "⚠️ WARNING: Are you sure you want to AUTOMATICALLY ADJUST the quantity?\n\n" +
                                                    "This action will:\n" +
                                                    "• Reduce the quantity of the product/ticket to the available quantity\n" +
                                                    "• FOR EXAMPLE: If you have 20 tickets but only have 15 left, it will be reduced to 15\n" +
                                                    "• The product/ticket will NOT be deleted, only the quantity will be changed\n\n" +
                                                    "Do you want to continue?";

                                            if (confirm(message)) {
                                                window.location.href = 'cart?action=view&stockAction=adjustQuantities';
                                            }
                                        }

                                        // Function to check if cart has stock issues
                                        function hasStockIssues() {
                                            return $('.out-of-stock-item').length > 0 || $('.insufficient-stock-item').length > 0;
                                        }

                                        // Function to get stock issue summary
                                        function getStockIssueSummary() {
                                            var outOfStockCount = $('.out-of-stock-item').length;
                                            var insufficientStockCount = $('.insufficient-stock-item').length;

                                            var summary = '';
                                            if (outOfStockCount > 0) {
                                                summary += outOfStockCount + ' sản phẩm hết hàng';
                                            }
                                            if (insufficientStockCount > 0) {
                                                if (summary)
                                                    summary += ', ';
                                                summary += insufficientStockCount + ' sản phẩm không đủ số lượng';
                                            }

                                            return summary;
                                        }

                                        // Function to handle checkout validation with custom popup
                                        function validateCheckout() {
                                            if (hasStockIssues()) {
                                                var summary = getStockIssueSummary();
                                                const title = 'Không thể thanh toán';
                                                const message = 'Giỏ hàng có vấn đề: ' + summary + '. Vui lòng xử lý các vấn đề này trước khi thanh toán.';
                                                
                                                showPopup(title, message, null, 'error');
                                                return false;
                                            }
                                            return true;
                                        }

                                        // Function to handle quantity updates with notifications
                                        function handleQuantityUpdate(form, type) {
                                            const formData = new FormData(form);
                                            const action = formData.get('action');
                                            const quantity = formData.get('quantity');
                                            
                                            if (!quantity || quantity < 1) {
                                                showErrorMessage('Please enter a valid quantity!');
                                                return false;
                                            }

                                            // Show success message for quantity update
                                            showSuccessMessage('Đã cập nhật số lượng!');
                                            
                                            return true;
                                        }

                                        // Global variables for popup
                                        let currentForm = null;
                                        let currentAction = null;

                                        // Function to show custom popup
                                        function showPopup(title, message, form, action) {
                                            document.getElementById('popupTitle').textContent = title;
                                            document.getElementById('popupMessage').textContent = message;
                                            currentForm = form;
                                            currentAction = action;
                                            document.getElementById('customPopup').style.display = 'flex';
                                        }

                                        // Function to show success message with custom text
                                        function showSuccessMessage(customMessage) {
                                            const message = document.getElementById('successMessage');
                                            if (customMessage) {
                                                message.innerHTML = '<i class="fa fa-circle-check"></i> ' + customMessage;
                                            } else {
                                                message.innerHTML = '<i class="fa fa-circle-check"></i> Thao tác thành công!';
                                            }
                                            message.style.display = 'block';
                                            setTimeout(() => {
                                                message.style.display = 'none';
                                            }, 3000);
                                        }

                                        // Function to close popup
                                        function closePopup() {
                                            document.getElementById('customPopup').style.display = 'none';
                                            currentForm = null;
                                            currentAction = null;
                                        }

                                        // Function to confirm popup action
                                        function confirmPopupAction() {
                                            if (currentForm && currentAction) {
                                                if (currentAction === 'error') {
                                                    // Just close for error messages
                                                    closePopup();
                                                } else {
                                                    // Show appropriate success message based on action
                                                    if (currentAction === 'remove') {
                                                        showSuccessMessage('Đã xóa khỏi giỏ hàng!');
                                                    } else if (currentAction === 'clear') {
                                                        showSuccessMessage('Đã xóa toàn bộ giỏ hàng!');
                                                    } else {
                                                        showSuccessMessage();
                                                    }
                                                    
                                                    // Submit the form
                                                    currentForm.submit();
                                                }
                                            }
                                            closePopup();
                                        }

                                        // Function to handle item removal with custom popup
                                        function handleRemoveItem(form, type) {
                                            const itemType = type === 'product' ? 'sản phẩm' : 'vé';
                                            const title = 'Xác nhận xóa';
                                            const message = `Bạn có chắc chắn muốn xóa ${itemType} này khỏi giỏ hàng?`;
                                            
                                            showPopup(title, message, form, 'remove');
                                            return false; // Prevent form submission
                                        }

                                        // Function to handle clear cart with custom popup
                                        function handleClearCart(form) {
                                            const title = 'Xác nhận xóa giỏ hàng';
                                            const message = 'Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?';
                                            
                                            showPopup(title, message, form, 'clear');
                                            return false; // Prevent form submission
                                        }

                                        // Prevent checkout if there are stock issues
                                        $(document).ready(function () {
                                            $('a[href*="checkout"]').click(function (e) {
                                                if (!validateCheckout()) {
                                                    e.preventDefault();
                                                }
                                            });
                                        });


        </script>

        <!-- ✅ ENHANCED: Comprehensive Validation Styles -->
        <style>
            /* Product validation styles */
            .out-of-stock-item {
                border-left: 4px solid #d32f2f !important;
            }

            .insufficient-stock-item {
                border-left: 4px solid #ff9800 !important;
            }

            /* Ticket validation styles */
            .sold-out-ticket {
                border-left: 4px solid #d32f2f !important;
                background-color: #ffebee !important;
                opacity: 0.7;
            }

            .limited-availability-ticket {
                border-left: 4px solid #ff9800 !important;
                background-color: #fff3e0 !important;
            }

            .date-issue-ticket {
                border-left: 4px solid #e91e63 !important;
                background-color: #f3e5f5 !important;
            }

            /* Issue detail styles */
            .issue-detail {
                margin: 8px 0;
                padding: 8px 12px;
                background-color: rgba(255, 255, 255, 0.3);
                border-radius: 4px;
                font-size: 14px;
            }

            .issue-detail i {
                margin-right: 8px;
                color: #666;
            }

            /* Priority-based alert styling */
            .alert[class*="alert-danger"] {
                border-color: #d32f2f;
                background-color: #ffebee;
                color: #b71c1c;
            }

            .alert[class*="alert-warning"] {
                border-color: #ff9800;
                background-color: #fff3e0;
                color: #e65100;
            }

            .alert[class*="alert-info"] {
                border-color: #2196f3;
                background-color: #e3f2fd;
                color: #0d47a1;
            }

            /* Stock/ticket status styling */
            .stock-warning-banner {
                background: linear-gradient(45deg, #ffecb3, #fff3e0);
                border: 1px solid #ff9800;
                border-radius: 8px;
                padding: 15px;
                margin: 15px 0;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    box-shadow: 0 0 0 0 rgba(255, 152, 0, 0.4);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(255, 152, 0, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(255, 152, 0, 0);
                }
            }

            .stock-status-column, .ticket-availability-cell {
                min-width: 120px;
                text-align: center;
            }

            .out-of-stock-notice, .ticket-issue-notice {
                font-weight: bold;
                text-align: center;
                padding: 8px;
                border-radius: 4px;
                color: #d32f2f;
            }

            .out-of-stock-notice {
                background-color: #ffcdd2;
            }

            .ticket-issue-notice {
                background-color: #ffcdd2;
            }

            /* Availability message styling */
            .availability-message {
                font-size: 12px !important;
                color: #666 !important;
                margin-top: 5px !important;
                line-height: 1.2;
            }

            /* Badge styling for status indicators */
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
                border: none;
            }

            .badge.badge-success {
                background-color: #4caf50 !important;
                color: white !important;
            }

            .badge.badge-warning {
                background-color: #ff9800 !important;
                color: white !important;
            }

            .badge.badge-danger {
                background-color: #d32f2f !important;
                color: white !important;
            }

            /* Enhanced table styling */
            .cart_item, .cart_ticket_item {
                transition: all 0.3s ease;
            }

            .cart_item:hover, .cart_ticket_item:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            /* Input validation styling */
            .quantity-input-warning {
                border-color: #ff9800 !important;
                background-color: #fff3e0 !important;
            }

            .quantity-input-error {
                border-color: #d32f2f !important;
                background-color: #ffebee !important;
            }

            /* Button styling enhancements */
            .btn-stock-action {
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                text-decoration: none;
            }

            .btn-stock-action:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                text-decoration: none;
            }

            .btn-stock-action.btn-danger {
                background-color: #d32f2f;
                color: white;
            }

            .btn-stock-action.btn-warning {
                background-color: #ff9800;
                color: white;
            }

            /* Comprehensive issues banner */
            .comprehensive-issues-banner {
                border-radius: 8px;
                border: none;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .comprehensive-issues-banner .alert-heading {
                margin-bottom: 15px;
                font-weight: bold;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* Ticket table specific styling */
            .cart-ticket-table {
                margin-top: 30px;
            }

            .cart-ticket-table .shop_table {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                overflow: hidden;
            }

            .cart-ticket-table th {
                background-color: #f5f5f5;
                color: #333;
                font-weight: 600;
                text-align: center;
                padding: 12px 8px;
                border-bottom: 2px solid #e0e0e0;
            }

            .cart-ticket-table td {
                padding: 12px 8px;
                vertical-align: middle;
                border-bottom: 1px solid #f0f0f0;
            }

            /* Responsive design for smaller screens */
            @media (max-width: 768px) {
                .issue-detail {
                    font-size: 12px;
                    margin: 4px 0;
                    padding: 6px 10px;
                }

                .btn-stock-action {
                    font-size: 10px;
                    padding: 6px 12px;
                }

                .badge {
                    font-size: 10px;
                    padding: 4px 8px;
                }

                .availability-message {
                    font-size: 10px !important;
                }
            }

            /* Animation for highlighting issues */
            .highlight-issue {
                animation: highlightPulse 3s ease-in-out;
            }

            @keyframes highlightPulse {
                0%, 100% {
                    background-color: transparent;
                }
                50% {
                    background-color: rgba(255, 152, 0, 0.1);
                }
            }

            /* Product styling classes */
            .out-of-stock-item {
                background-color: #ffebee !important;
                opacity: 0.7 !important;
            }

            .insufficient-stock-item {
                background-color: #fff3e0 !important;
            }

            .out-of-stock-text {
                color: #666 !important;
                text-decoration: line-through !important;
            }

            .quantity-input {
                width: 80px;
                height: 35px;
                padding: 0 10px;
                border: 1px solid #e6e6e6;
            }

            .insufficient-stock-input {
                border-color: #ff9800 !important;
            }

            /* Ticket styling classes */
            .sold-out-ticket {
                background-color: #ffebee !important;
                opacity: 0.7 !important;
            }

            .limited-availability-ticket {
                background-color: #fff3e0 !important;
                opacity: 0.8 !important;
            }

            .date-issue-ticket {
                background-color: #f3e5f5 !important;
                opacity: 0.8 !important;
            }

            .ticket-quantity-input {
                width: 60px;
                height: 35px;
                padding: 0 10px;
                border: 1px solid #e6e6e6;
                text-align: center;
            }

            .limited-availability-input {
                border-color: #ff9800 !important;
            }

            .date-issue-input {
                border-color: #e91e63 !important;
            }

            /* Additional ticket text styling classes */
            .sold-out-text {
                color: #666 !important;
                text-decoration: line-through !important;
            }

            .limited-availability-text {
                color: #666 !important;
                font-style: italic !important;
            }

            .date-issue-text {
                color: #666 !important;
                font-style: italic !important;
            }

            .dimmed-text {
                color: #666 !important;
            }

            .date-issue-date {
                color: #e91e63 !important;
                font-weight: bold !important;
            }

            .dimmed-price {
                opacity: 0.7 !important;
            }

            /* Toast notification styling (exactly matching product.jsp) */
            .success-message {
                position: fixed;
                top: 30px;
                right: 30px;
                min-width: 260px;
                max-width: 350px;
                background: #27ae60;
                color: #fff;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.15);
                font-size: 16px;
                z-index: 1002;
                display: flex;
                align-items: center;
                gap: 10px;
                opacity: 0.97;
                transition: all 0.3s;
            }
            .success-message i.fa-circle-check {
                color: #fff;
                font-size: 22px;
                margin-right: 8px;
            }
            .success-message i.fa-circle-xmark {
                color: #fff;
                font-size: 22px;
                margin-right: 8px;
            }

            /* Custom Popup Modal Styling */
            .custom-popup {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1004;
                backdrop-filter: blur(5px);
            }

            .popup-content {
                background: white;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                max-width: 400px;
                width: 90%;
                animation: popupSlideIn 0.3s ease-out;
            }

            @keyframes popupSlideIn {
                from {
                    opacity: 0;
                    transform: translateY(-50px) scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .popup-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 24px 0 24px;
                border-bottom: 1px solid #e0e0e0;
            }

            .popup-header h3 {
                margin: 0;
                color: #333;
                font-size: 18px;
                font-weight: 600;
            }

            .popup-close {
                background: none;
                border: none;
                font-size: 24px;
                color: #999;
                cursor: pointer;
                padding: 0;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                transition: all 0.2s;
            }

            .popup-close:hover {
                background-color: #f5f5f5;
                color: #666;
            }

            .popup-body {
                padding: 20px 24px;
            }

            .popup-body p {
                margin: 0;
                color: #666;
                font-size: 16px;
                line-height: 1.5;
            }

            .popup-footer {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                padding: 0 24px 20px 24px;
            }

            .popup-footer .btn {
                padding: 10px 20px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                border: none;
                cursor: pointer;
                transition: all 0.2s;
            }

            .popup-footer .btn-secondary {
                background-color: #f8f9fa;
                color: #666;
                border: 1px solid #dee2e6;
            }

            .popup-footer .btn-secondary:hover {
                background-color: #e9ecef;
                color: #495057;
            }

            .popup-footer .btn-primary {
                background-color: #007bff;
                color: white;
            }

            .popup-footer .btn-primary:hover {
                background-color: #0056b3;
            }
        </style>

    </body>
</html>