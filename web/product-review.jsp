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
        <title>User Profile - Da Nang Craft Village</title>

        <!-- Fonts and Styles -->
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&display=swap" rel="stylesheet">
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
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/style.css">

        <style>
            .review-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 20px;
                background-color: #fff;
            }
            .rating-row {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-top: 8px;
            }
            .rating-row label {
                display: flex;
                align-items: center;
                gap: 4px;
                cursor: pointer;
            }
            .rating-row input[type="radio"] {
                accent-color: gold;
            }
            .comment-inline-group {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 10px;
            }
            .comment-inline-group label {
                min-width: 70px;
                font-weight: bold;
            }
            .comment-inline-group textarea {
                width: 100%;
                max-width: 400px;
                resize: vertical;
            }
            .btn-update {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
            }
            h5.experience-note {
                color: #4CAF50;
                font-weight: 600;
                margin-top: 10px;
            }
            .back-button {
                padding: 6px 12px;
                background-color: #4caf50;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-weight: bold;
                font-size: 14px;
                transition: background-color 0.3s ease;
            }

            .back-button:hover {
                background-color: #388e3c;
            }
        </style>
    </head>

    <body class="biolife-body">
        <jsp:include page="Menu.jsp"></jsp:include>
            <!--Hero Section-->
            <div class="hero-section hero-background">
                <h1 class="page-title">Review</h1>
            </div>
            <!-- Notification -->
        <c:if test="${not empty message}">
        </c:if>
        <!-- Page Contain -->
        <div class="page-contain">
            <div id="main-content" class="main-content">
                <!--Navigation section-->
                <div class="container">
                    <nav class="biolife-nav">
                        <ul>
                            <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                            <li class="nav-item"><a href="order?userID=${sessionScope.acc.userID}&cas=2" class="permal-link">Order List</a></li>
                            <li class="nav-item"><span class="contac"><strong>Review for: ${subOrder.subName}</strong></span></li>
                        </ul>
                    </nav>
                </div>
                <div class="container">

                    <div class="chat-header">
                        <a href="order?userID=${sessionScope.acc.userID}&cas=" class="back-button">← Back</a> 
                    </div>

                    <c:if test="${empty orderList && empty ticketOrderList}">
                        <p class="text-center mt-5">No orders found in this category.</p>
                    </c:if>

                    <c:forEach var="detail" items="${orderList}">
                        <div class="row text-center align-items-center review-card">
                            <div class="col-md-2"><strong>${detail.productName}</strong></div>
                            <div class="col-md-2">Quantity: ${detail.quantity}</div>
                            <div class="col-md-2">Total: <fmt:formatNumber value="${detail.subtotal}" type="currency" /></div>
                            <div class="col-md-2"><a href="detail?pid=${detail.productId}">View Product</a></div>

                            <div class="col-md-4">
                                <form action="review-control" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="subOrderId" value="${subOrder.subOrderId}" />
                                    <input type="hidden" name="productID" value="${detail.productId}" />
                                    <input type="hidden" name="type" value="product" />

                                    <div class="rating-row">
                                        <span><strong>Rating:</strong></span>
                                        <c:forEach var="i" begin="1" end="5">
                                            <label for="rate${i}-${detail.productId}">
                                                <input type="radio" 
                                                       name="rate" 
                                                       id="rate${i}-${detail.productId}" 
                                                       value="${i}" 
                                                       <c:if test="${i == 5}">checked</c:if> required>
                                                ${i} <span style="color: gold;">★</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                    <div class="mb-3">
                                        <label for="pictureUrl" class="block mb-2">Picture:</label>
                                        <input type="file" id="pictureUrl" name="pictureUrl" accept="image/*" class="form-control" />
                                    </div>

                                    <div class="comment-inline-group">
                                        <label for="comment-${detail.productId}">Comment:</label>
                                        <textarea name="comment" id="comment-${detail.productId}" class="form-control" rows="2" required></textarea>
                                        <button type="submit" class="btn-update">Submit</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>

                    <c:forEach var="ticket" items="${ticketOrderList}">
                        <div class="row text-center align-items-center review-card">
                            <div class="col-md-2">${ticket.villageName}</div>
                            <div class="col-md-2">Quantity: ${ticket.quantity}</div>
                            <div class="col-md-2">Total: <fmt:formatNumber value="${ticket.subtotal}" type="currency" /></div>
                            <div class="col-md-2">Code: ${ticket.ticketCode}</div>
                            <div class="col-md-2"><a href="ticket-detail?ticketId=${ticket.ticketID}">View Ticket</a></div>

                            <div class="col-md-4">
                                <form action="review-control" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="subOrderId" value="${subOrder.subOrderId}" />
                                    <input type="hidden" name="ticketID" value="${ticket.ticketID}" />
                                    <input type="hidden" name="type" value="village" />

                                    <h5 class="experience-note">You have experienced before submitting a review</h5>

                                    <div class="rating-row">
                                        <span><strong>Rating:</strong></span>
                                        <c:forEach var="i" begin="1" end="5">
                                            <label for="rate${i}-${ticket.ticketID}">
                                                <input type="radio" 
                                                       name="rate" 
                                                       id="rate${i}-${ticket.ticketID}" 
                                                       value="${i}" 
                                                       <c:if test="${i == 5}">checked</c:if> required>
                                                ${i} <span style="color: gold;">★</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                    <div class="mb-3">
                                        <label for="pictureUrl" class="block mb-2">Picture: </label>
                                        <input type="file" id="pictureUrl" name="pictureUrl" accept="image/*" class="form-control" required/>
                                    </div>

                                    <div class="comment-inline-group">
                                        <label for="comment-${ticket.ticketID}">Comment:</label>
                                        <textarea name="comment" id="comment-${ticket.ticketID}" class="form-control" rows="2" required></textarea>
                                        <button type="submit" class="btn-update">Submit</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <jsp:include page="Footer.jsp" />
        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>
