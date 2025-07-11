<%-- 
    Document   : newjsp
    Created on : Jul 11, 2025, 4:43:59 PM
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
        <title>Checkout - Da Nang Craft Village</title>
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
            a.btn-change-password {
                background-color: #2196F3;
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                text-decoration: none;
                display: inline-block;
                margin-top: 10px;
                transition: background-color 0.3s ease;
            }
            a.btn-change-password:hover {
                background-color: #0b7dda;
                color: #fff;
                text-decoration: none;
            }
        </style>
        <style>
            .form-section {
                border: 1px solid #ddd;
                padding: 20px;
                margin-bottom: 30px;
                border-radius: 5px;
                background: #fff;
            }
            .form-section legend {
                font-size: 1.3rem;
                font-weight: bold;
                color: #7FAF51;
                width: auto;
                padding: 0 10px;
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
                <h1 class="page-title">Checkout</h1>
            </div>

            <!-- Page Contain -->
            <div class="page-contain">
                <div id="main-content" class="main-content">
                    <!-- Navigation section -->
                    <div class="container">
                        <nav class="biolife-nav">
                            <ul>
                                <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                                <li class="nav-item"><span class="curent-page"><strong>Checkout</strong></span></li>
                            </ul>
                        </nav>
                    </div>
                    <div class="container">
                        <div class="contact-container">
                            <div class="profile-header">
                                <h2>Your Order Summary</h2>
                            </div>

                            <form action="checkout-before" method="post">

                                <!-- Recipient Information -->
                                <fieldset class="form-section">
                                    <legend>Recipient Information</legend>

                                    <input type="hidden" name="userID" value="${user.userID}">

                                <div class="form-group row">
                                    <label for="fullName" class="col-sm-3 col-form-label">Full Name</label>
                                    <div class="col-sm-9">
                                        <input type="text" readonly class="form-control-plaintext" id="fullName" name="fullName" value="${user.fullName}">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="email" class="col-sm-3 col-form-label">Email</label>
                                    <div class="col-sm-9">
                                        <input type="text" readonly class="form-control-plaintext" id="email" name="email" value="${user.email}">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="address" class="col-sm-3 col-form-label">Address</label>
                                    <div class="col-sm-9">
                                        <input type="text" readonly class="form-control-plaintext" id="address" name="address" value="${user.address}">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="phoneNumber" class="col-sm-3 col-form-label">Phone Number</label>
                                    <div class="col-sm-9">
                                        <input type="text" readonly class="form-control-plaintext" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
                                    </div>
                                </div>

                                <a href="userprofile" class="btn-change-password">Change Info</a>
                            </fieldset>

                            <!-- Products -->
                            <c:if test="${not empty cartItems}">
                                <fieldset class="form-section">
                                    <legend>Products</legend>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Product Name</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${cartItems}" var="item">
                                                <tr>
                                                    <td>${item.productName}</td>
                                                    <td><fmt:formatNumber value="${item.price}" type="currency"/></td>
                                                    <td>${item.quantity}</td>
                                                    <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </fieldset>
                            </c:if>

                            <!-- Tickets -->
                            <c:if test="${not empty cartTickets}">
                                <fieldset class="form-section">
                                    <legend>Tickets</legend>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Ticket Type</th>
                                                <th>Village</th>
                                                <th>Date</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${cartTickets}" var="ticket">
                                                <tr>
                                                    <td>${ticket.ticketTypeName}</td>
                                                    <td>${ticket.villageName}</td>
                                                    <td>${ticket.formattedTicketDate}</td>
                                                    <td><fmt:formatNumber value="${ticket.price}" type="currency"/></td>
                                                    <td>${ticket.quantity}</td>
                                                    <td><fmt:formatNumber value="${ticket.price * ticket.quantity}" type="currency"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </fieldset>
                            </c:if>

                            <!-- Payment Method -->
                            <fieldset class="form-section">
                                <legend>Payment Method </legend>
                                <div class="form-check">
                                    <c:choose>
                                        <c:when test="${point >= totalPrice}">
                                            <!-- Radio button cho phép chọn -->
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="payByPoints" value="points" required>
                                                <label class="form-check-label" for="payByPoints">
                                                    Pay by Points (<c:out value="${point}" default="0"/>)
                                                </label>
                                                <input type="hidden" name="points" value="${point}">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Radio button disabled -->
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="payByPoints" value="points" disabled>
                                                <label class="form-check-label text-muted" for="payByPoints">
                                                    Pay by Points (<c:out value="${point}" default="0"/>) - Not enough points
                                                </label>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="bankTransfer" value="bankTransfer">
                                    <label class="form-check-label" for="bankTransfer">
                                        Bank Transfer - Get rewards (${totalPrice * 1 / 100} poins)
                                    </label>
                                    <input type="hidden" name="points" value="${totalPrice * 1 / 100}">
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="cod">
                                    <label class="form-check-label" for="cod">
                                        Cash on Delivery - Get rewards (${totalPrice * 1 / 100} poins)
                                    </label>
                                    <input type="hidden" name="points" value="${totalPrice * 1 / 100}">
                                </div>
                            </fieldset>

                            <!-- Total & Buttons -->
                            <fieldset class="form-section">
                                <legend>Order Summary</legend>
                                <h3>Grand Total: 
                                    <fmt:formatNumber value="${totalPrice}" type="currency"/>
                                </h3>
                                <input type="hidden" name="totalPrice" value="${totalPrice}">
                                <button type="submit" class="btn btn-success">Confirm Order</button>
                                <a href="cart" class="btn btn-warning">Back to Cart</a>
                            </fieldset>

                        </form>

                    </div>
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
