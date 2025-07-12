<%-- 
    Document   : NotificationOrder
    Created on : Jul 12, 2025, 2:50:07 AM
    Author     : ACER
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Notification - Da Nang Craft Village</title>
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
                margin: 30px auto;
                padding: 30px;
                background-color: #f7f7f7;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .form-group label {
                font-weight: bold;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                margin-bottom: 30px;
            }
            table th, table td {
                border: 1px solid #ddd;
                padding: 10px;
            }
            table th {
                background-color: #7FAF51;
                color: #fff;
            }
            .btn-success {
                background-color: #4CAF50;
                color: #fff;
                border: none;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-success:hover {
                background-color: #45a049;
            }
            .btn-warning {
                background-color: #ffc107;
                color: #333;
                border: none;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 4px;
                text-decoration: none;
            }
            .btn-warning:hover {
                background-color: #e0a800;
                color: #fff;
            }
        </style>
        <style>
            .notification {
                padding: 20px;
                margin: 30px auto;
                width: 80%;
                border-radius: 5px;
                color: #fff;
                font-size: 16px;
                font-family: Arial, sans-serif;
                box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            }
            .error {
                background-color: #dc3545; /* Red */
            }
            .success {
                background-color: #28a745; /* Green */
            }
            .button-group {
                margin-top: 20px;
                display: flex;
                gap: 10px;
                justify-content: center;
            }
            .button-group a {
                text-decoration: none;
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                border-radius: 3px;
                transition: background-color 0.3s;
            }
            .button-group a:hover {
                background-color: #0056b3;
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

            <!-- Hero Section -->
            <div class="hero-section hero-background">
                <h1 class="page-title">Notification</h1>
            </div>

            <!-- Page Contain -->
            <div class="page-contain">
                <div id="main-content" class="main-content">
                    <!-- Navigation section -->
                    <div class="container">
                        <nav class="biolife-nav">
                            <ul>
                                <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                                <li class="nav-item"><span class="curent-page"><strong>Notification Order</strong></span></li>
                            </ul>
                        </nav>
                    </div>
                    <div class="container">
                    <c:choose>
                        <c:when test="${error == 1}">
                            <div class="notification success">
                                Your order has been placed successfully. Thank you very much.
                            </div>
                            <div class="button-group">
                                <a href="home">Home</a>
                                <a href="order-history">Order History</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="notification error">
                                <pre>${noti}</pre>
                            </div>
                            <div class="button-group">
                                <a href="home">Home</a>
                                <a href="cart">Back to Cart</a>
                                <a href="order-history">Order History</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

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

