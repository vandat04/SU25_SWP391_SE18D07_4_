<%-- 
    Document   : order-list
    Created on : Jul 13, 2025, 6:39:50 PM
    Author     : ACER
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>List of Refunded List - Da Nang Craft Village</title>
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
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        <style>
            .contact-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 30px;
                background-color: #f7f7f7;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .btn-update {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }
            .btn-update:hover {
                background-color: #45a049;
            }
            .profile-header {
                margin-bottom: 30px;
                text-align: center;
            }
            .alert {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .alert-success {
                background-color: #dff0d8;
                border-color: #d6e9c6;
                color: #3c763d;
            }
            .alert-danger {
                background-color: #f2dede;
                border-color: #ebccd1;
                color: #a94442;
            }
            .btn-change-password {
                background-color: #2196F3;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                text-decoration: none;
                display: inline-block;
                margin-top: 10px;
            }
            .btn-change-password:hover {
                background-color: #0b7dda;
            }
            .form-control[readonly] {
                background-color: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
            }
            .text-muted {
                color: #6c757d !important;
                font-size: 0.875rem;
                margin-top: 0.25rem;
            }
            .message-list {
                max-height: 400px;
                overflow-y: auto;
                margin-bottom: 20px;
            }

            .message-item {
                padding: 10px;
                border-radius: 8px;
                margin-bottom: 10px;
                width: fit-content;
                max-width: 70%;
                clear: both;
            }

            .message-sent {
                background-color: #d4edda;
                margin-left: auto;
                text-align: right;
            }

            .message-received {
                background-color: #f8d7da;
                margin-right: auto;
                text-align: left;
            }

            .message-content p {
                margin: 0;
                .message-list {
                    max-height: 400px;
                    overflow-y: auto;
                    margin-bottom: 20px;
                }

                .message-item {
                    padding: 10px;
                    border-radius: 8px;
                    margin-bottom: 10px;
                    width: fit-content;
                    max-width: 70%;
                    clear: both;
                }

                .message-sent {
                    background-color: #d4edda;
                    margin-left: auto;
                    text-align: right;
                }

                .message-received {
                    background-color: #f8d7da;
                    margin-right: auto;
                    text-align: left;
                }

                .message-content p {
                    margin: 0;
                }
                .message-list {
                    max-height: 400px;
                    overflow-y: auto;
                }
            }
        </style>
        <style>
            .btn {
                border-radius: 20px;
                font-weight: 600;
            }
        </style>
    </head>
    <body class="biolife-body">
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
                <h1 class="page-title">List of Refunded List</h1>
            </div>
            <!-- Page Contain -->
            <div class="page-contain">
                <div id="main-content" class="main-content">
                    <!--Navigation section-->
                    <div class="container">
                        <nav class="biolife-nav">
                            <ul>
                                <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                                <li class="nav-item"><span class="#">Refunded List</span></li>
                            </ul>
                        </nav>
                    </div>

                    <div class="container">
                        <div class="d-flex flex-wrap gap-2 mt-3">
                            <a href="order?userID=${sessionScope.acc.userID}&cas=1" class="btn btn-success">Processing List</a>
                        <a href="order?userID=${sessionScope.acc.userID}&cas=2" class="btn btn-primary">Delivering List</a>
                        <a href="order?userID=${sessionScope.acc.userID}&cas=3" class="btn btn-info">Received List</a>
                        <a href="order?userID=${sessionScope.acc.userID}&cas=4" class="btn btn-danger">Canceled List</a>
                        <a href="order?userID=${sessionScope.acc.userID}&cas=5" class="btn btn-warning">Refunded List</a>
                    </div>

                    <!-- PHẦN HIỂN THỊ DATA -->
                    <h2 class="mt-4" style="color: #4CAF50;">Order Details</h2>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Product ID</th>
                                <th>Product Name</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                                <th>Status</th>
                                <th>Payment Method</th>
                                <th>Created Date</th>
                                <th>Points</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="od" items="${refundOrderDetail}">
                                <tr>
                                    <td>${od.orderDetailID}</td>
                                    <td>${od.productID}</td>
                                    <td>${od.productName}</td>
                                    <td><fmt:formatNumber value="${od.price}" type="currency"/></td>
                                    <td>${od.quantity}</td>
                                    <td><fmt:formatNumber value="${od.subtotal}" type="currency"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${od.status == 4}">Refunded</c:when>
                                            <c:when test="${od.status == 5}">Refunding</c:when>
                                            <c:otherwise>Unknown</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${od.paymentMethod}</td>
                                    <td>
                                        <fmt:formatDate value="${od.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>
                                    <td>${od.points}</td>
                                    <td>
                                        <a href="detail?pid=${od.productID}" class="btn btn-primary btn-sm">View Product</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <h2 class="mt-5" style="color: #4CAF50;">Ticket Order Details</h2>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Ticket ID</th>
                                <th>Village Name</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Subtotal</th>
                                <th>Status</th>
                                <th>Payment Method</th>
                                <th>Created Date</th>
                                <th>Points</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tod" items="${refundTicketOrderDetail}">
                                <tr>
                                    <td>${tod.detailID}</td>
                                    <td>${tod.ticketID}</td>
                                    <td>${tod.villageName}</td>
                                    <td>${tod.quantity}</td>
                                    <td><fmt:formatNumber value="${tod.price}" type="currency"/></td>
                                    <td><fmt:formatNumber value="${tod.subtotal}" type="currency"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tod.status == 4}">Refunded</c:when>
                                            <c:when test="${tod.status == 5}">Refunding</c:when>
                                            <c:otherwise>Unknown</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${tod.paymentMethod}</td>
                                    <td>
                                        <fmt:formatDate value="${tod.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>
                                    <td>${tod.points}</td>
                                    <td>
                                        <a href="ticket-detail?ticketId=${tod.ticketID}" class="btn btn-primary btn-sm">View Ticket</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <jsp:include page="Footer.jsp"></jsp:include>

        <!-- Scripts -->
        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.countdown.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/jquery.nicescroll.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>
    </body>
</html> 
