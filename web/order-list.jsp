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
        <title>Processing Order List - Da Nang Craft Village</title>

        <!-- CSS Links -->
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">

        <style>
            .order-card {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 25px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .order-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
                margin-bottom: 15px;
            }
            .order-header .sub-name {
                font-size: 1.2rem;
                font-weight: 600;
                color: #333;
            }
            .status {
                font-weight: 600;
                padding: 5px 12px;
                border-radius: 15px;
                color: white;
            }
            .status-processing {
                background-color: #ff9800;
            }
            .status-delivering {
                background-color: #2196F3;
            }
            .status-received {
                background-color: #4CAF50;
            }
            .status-canceled {
                background-color: #f44336;
            }
            .status-refunded {
                background-color: #607d8b;
            }
            .status-refunding {
                background-color: #9c27b0;
            }
            .item-list {
                flex-grow: 1;
            }
            .order-item {
                margin-bottom: 10px;
                border: 1px dashed #ccc;
                padding: 10px;
                border-radius: 6px;
            }
            .item-details p {
                margin: 0;
            }
            .toggle-details {
                cursor: pointer;
                color: #2196F3;
                margin-top: 10px;
                display: inline-block;
            }
            .order-summary {
                text-align: right;
                min-width: 200px;
            }
            .total-price {
                font-size: 1.5rem;
                font-weight: 700;
                color: #4CAF50;
            }
            .order-actions {
                margin-top: 15px;
            }
            .btn {
                border-radius: 20px;
                font-weight: 600;
                margin-left: 10px;
            }
            .btn-view-more {
                background-color: #757575;
                color: white;
            }
            .btn-cancel {
                background-color: #f44336;
                color: white;
            }
            .btn-review {
                background-color: #FFC107;
                color: #333;
            }
            .shipping-info {
                background: #fafafa;
                padding: 10px;
                border: 1px solid #eee;
                margin-top: 10px;
                border-radius: 6px;
            }
            .shipping-info th {
                width: 160px;
                background-color: #f1f1f1;
                color: #333;
            }
            .shipping-info td {
                color: #555;
            }
        </style>  <style>
            .order-actions {
                display: flex;
                justify-content: flex-end; /* Đưa nút về bên phải */
                gap: 10px;                 /* Khoảng cách giữa các nút */
                flex-wrap: wrap;
            }
        </style>
        <style>
            .center-button {
                text-align: center;
                margin-top: 10px;
            }
            .shipping-info {
                background: #fdfdfd;
                padding: 15px;
                border: 1px solid #ddd;
                margin-top: 15px;
                border-radius: 6px;
                font-size: 1.15rem;
                line-height: 1.6;
            }

            .shipping-info .row > div {
                padding-bottom: 6px;
            }
        </style>
        <style>
    .page-contain {
        background-color: #f8f9fa; /* nền sáng nhẹ */
        padding: 30px 15px;
    }

    .biolife-nav ul {
        padding: 0;
        margin-bottom: 25px;
        list-style: none;
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }

    .biolife-nav ul li {
        display: inline-block;
    }

    .biolife-nav ul li a,
    .biolife-nav ul li span {
        color: #4a4a4a;
        font-weight: 500;
        text-decoration: none;
        background-color: #e3e3e3;
        padding: 8px 14px;
        border-radius: 20px;
        transition: all 0.3s ease;
        display: inline-block;
    }

    .biolife-nav ul li a:hover {
        background-color: #ff9800;
        color: white;
    }

    .main-content .container {
        max-width: 1200px;
        margin: 0 auto;
    }

    .text-center.mt-5 {
        font-size: 1.1rem;
        color: #777;
    }

    h2.mt-4 {
        margin-top: 30px !important;
        margin-bottom: 15px;
        font-size: 1.8rem;
        border-bottom: 2px solid #4CAF50;
        padding-bottom: 8px;
    }

    .pagination {
        margin-top: 30px;
    }

    .pagination .page-link {
        color: #4CAF50;
        font-weight: 500;
    }

    .pagination .page-item.active .page-link {
        background-color: #4CAF50;
        border-color: #4CAF50;
        color: white;
    }

    .btn {
        padding: 6px 14px;
        font-size: 0.95rem;
    }
    .order-card {
    border: 2px solid #bdbdbd; /* Tăng độ dày viền và đổi màu xám đậm hơn */
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 25px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08); /* Đổ bóng nhẹ để nổi bật */
    background-color: #ffffff;
    transition: box-shadow 0.3s ease;
}
.order-card:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.12); /* Hover nổi rõ hơn */
}
.order-summary {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 10px;
    font-size: 1.2rem;
    margin-top: 10px;
}

.order-summary .total-price {
    font-size: 1.5rem;
    font-weight: 700;
    color: #4CAF50;
    margin: 0; /* Xoá khoảng trắng mặc định */
}

.order-summary .text-muted {
    color: #555;
    font-weight: 500;
}
</style>


    </head>
    <body class="biolife-body">
        <jsp:include page="Menu.jsp" />

        <div class="hero-section hero-background">
            <h1 class="page-title">Order List</h1>
        </div>

        <div class="page-contain">
            <div id="main-content" class="main-content">
                <div class="container">
                    <nav class="biolife-nav">
                        <ul>
                            <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                            <li class="nav-item"><span>Orders History</span></li>
                        </ul>
                    </nav>

                    <c:set var="cas" value="${empty param.cas ? 0 : param.cas}" />
                    <div class="d-flex flex-wrap gap-2 mt-3">
                        <c:forEach var="i" begin="0" end="4">
                            <a href="order?userID=${sessionScope.acc.userID}&cas=${i}" class="btn"
                               style="background-color: ${cas == i ? 'orange' : 'gray'}; color: white;">
                                <c:choose>
                                    <c:when test="${i == 0}">Processing</c:when>
                                    <c:when test="${i == 1}">Delivering</c:when>
                                    <c:when test="${i == 2}">Received</c:when>
                                    <c:when test="${i == 3}">Canceled</c:when>
                                    <c:when test="${i == 4 || i == 5}">Refunded</c:when>
                                </c:choose>
                            </a>
                        </c:forEach>
                    </div>

                    <h2 class="mt-4" style="color: #4CAF50;">Order Details</h2>
                    <c:if test="${empty subOrderList}">
                        <p class="text-center mt-5">No orders found in this category.</p>
                    </c:if>

                    <c:forEach var="subOrder" items="${subOrderList}">
                        <div class="order-card">
                            <div class="order-header">
                                <span class="sub-name">${subOrder.subName}</span>
                                <c:choose>
                                    <c:when test="${subOrder.orderStatus == 0}"><span class="status status-processing">Processing</span></c:when>
                                    <c:when test="${subOrder.orderStatus == 1}"><span class="status status-delivering">Delivering</span></c:when>
                                    <c:when test="${subOrder.orderStatus == 2}"><span class="status status-received">Received</span></c:when>
                                    <c:when test="${subOrder.orderStatus == 3}"><span class="status status-canceled">Canceled</span></c:when>
                                    <c:when test="${subOrder.orderStatus == 4}"><span class="status status-refunded">Refunded</span></c:when>
                                    <c:when test="${subOrder.orderStatus == 5}"><span class="status status-refunding">Refunding</span></c:when>
                                </c:choose>
                            </div>

                            <div class="shipping-info mt-2 mb-3 px-3 py-2 border rounded bg-light">
                                <c:forEach var="order" items="${orderList}">
                                    <c:if test="${order.id == subOrder.orderId}">
                                        <div class="row">
                                            <div class="col-md-6 mb-2">
                                                <strong>Recipient:</strong> ${order.shippingName}
                                            </div>
                                            <div class="col-md-6 mb-2">
                                                <strong>Phone:</strong> ${order.shippingPhone}
                                            </div>
                                            <div class="col-md-6 mb-2">
                                                <strong>Address:</strong> ${order.shippingAddress}
                                            </div>
                                            <div class="col-md-6 mb-2">
                                                <strong>Email:</strong> ${order.email}
                                            </div>
                                            <div class="col-md-6 mb-2">
                                                <strong>Payment Method:</strong> ${order.paymentMethod}
                                            </div>
                                            <div class="col-md-6 mb-2">
                                                <strong>Created Date:</strong>
                                                <fmt:formatDate value="${order.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>

                            <div class="item-list" id="items-${subOrder.subOrderId}">
                                <c:set var="count" value="0" />
                                <c:forEach var="detail" items="${orderDetailsList}">
                                    <c:if test="${detail.subOrderId == subOrder.subOrderId}">
                                        <div class="order-item" style="display: ${count lt 1 ? 'block' : 'none'}" data-toggle="items-${subOrder.subOrderId}">
                                            <div class="row text-center align-items-center" style="padding: 10px 0;">
                                                <div class="col-md-3">${detail.productName}</div>
                                                <div class="col-md-3">Quantity: ${detail.quantity}</div>
                                                <div class="col-md-3">
                                                    Total: <fmt:formatNumber value="${detail.subtotal}" type="currency" /> 
                                                </div>
                                                <div class="col-md-3">  <a href="detail?pid=${detail.productId}">View Product</a></div>
                                            </div>
                                        </div>
                                        <c:set var="count" value="${count + 1}" />
                                    </c:if>
                                </c:forEach>
                                <c:forEach var="ticket" items="${ticketOrderDetailsList}">
                                    <c:if test="${ticket.subOrderId == subOrder.subOrderId}">
                                        <div class="order-item" style="display: ${count lt 1 ? 'block' : 'none'}" data-toggle="items-${subOrder.subOrderId}">
                                            <div class="row text-center align-items-center" style="padding: 10px 0;">
                                                <div class="col-md-2">${ticket.villageName}</div>
                                                <div class="col-md-2">Quantity: ${ticket.quantity}</div>
                                                <div class="col-md-2">
                                                    Total: <fmt:formatNumber value="${ticket.subtotal}" type="currency" /> 
                                                </div>
                                                <div class="col-md-2">Ticket Code: ${ticket.ticketCode}</div>
                                                <div class="col-md-2">  <a href="ticket-detail?ticketId=${ticket.ticketID}">View Ticket</a></div>
                                            </div>
                                        </div>
                                        <c:set var="count" value="${count + 1}" />
                                    </c:if>
                                </c:forEach>

                                <c:if test="${count > 1}">
                                    <div class="center-button">
                                        <a href="javascript:void(0);" onclick="toggleAll('items-${subOrder.subOrderId}')" class="toggle-details">
                                            <span class="toggle-text">View more</span>
                                            <i class="fa fa-chevron-down"></i>
                                        </a>
                                    </div>
                                </c:if>
                            </div>

                            <div class="order-summary">
                                <span class="text-muted">Total Amount</span>
                                <p class="total-price"><fmt:formatNumber value="${subOrder.totalPrice}" type="currency" /></p>
                            </div>



                            <div class="order-actions">
                                <c:if test="${subOrder.orderStatus eq 0}">
                                    <a href="javascript:void(0);" onclick="toggleReason('cancel-${subOrder.subOrderId}')" class="btn btn-sm btn-cancel">Cancel</a>
                                </c:if>
                                <c:if test="${subOrder.orderStatus eq 1}">
                                    <a href="update-order-list?subOrderId=${subOrder.subOrderId}&cas=confirmOrder&userID=${sessionScope.acc.userID}" class="btn btn-sm btn-cancel">Confirm</a>
                                </c:if>
                                <c:if test="${subOrder.orderStatus eq 2 and subOrder.reviewStatus == 0}">
                                    <a href="review-control?subOrderId=${subOrder.subOrderId}" class="btn btn-sm btn-review">Review</a>
                                </c:if>
                                <c:if test="${subOrder.orderStatus eq 2}">
                                    <a href="javascript:void(0);" onclick="toggleReason('refund-${subOrder.subOrderId}')" class="btn btn-sm btn-cancel">Refund</a>
                                </c:if>
                            </div>

                            <c:if test="${subOrder.orderStatus eq 0}">
                                <div id="cancel-${subOrder.subOrderId}" style="display: none; margin-top: 10px;">
                                    <form action="update-order-list" method="post">
                                        <input type="hidden" name="userID" value="${sessionScope.acc.userID}">
                                        <input type="hidden" name="subOrderId" value="${subOrder.subOrderId}">
                                        <input type="hidden" name="cas" value="cancelOrder">
                                        <div class="form-group">
                                            <label for="reason-cancel-${subOrder.subOrderId}">Reason for cancellation:</label>
                                            <textarea class="form-control" id="reason-cancel-${subOrder.subOrderId}" name="reason" rows="3" required></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Submit</button>
                                    </form>
                                </div>
                            </c:if>

                            <c:if test="${subOrder.orderStatus eq 2}">
                                <div id="refund-${subOrder.subOrderId}" style="display: none; margin-top: 10px;">
                                    <form action="update-order-list" method="post">
                                        <input type="hidden" name="userID" value="${sessionScope.acc.userID}">
                                        <input type="hidden" name="subOrderId" value="${subOrder.subOrderId}">
                                        <input type="hidden" name="cas" value="refundOrder">
                                        <div class="form-group">
                                            <label for="reason-refund-${subOrder.subOrderId}">Reason for refund:</label>
                                            <textarea class="form-control" id="reason-refund-${subOrder.subOrderId}" name="reason" rows="3" required></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Submit</button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>

                    <c:if test="${totalPages > 1}">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item"><a class="page-link" href="order?userID=${userID}&cas=${cas}&page=${currentPage - 1}">Previous</a></li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="order?userID=${userID}&cas=${cas}&page=${i}">${i}</a></li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                <li class="page-item"><a class="page-link" href="order?userID=${userID}&cas=${cas}&page=${currentPage + 1}">Next</a></li>
                                </c:if>
                        </ul>
                    </c:if>
                </div>
            </div>
        </div>

        <jsp:include page="Footer.jsp" />

        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>

        <script>
                                        function toggleAll(containerId) {
                                            const container = document.getElementById(containerId);
                                            const items = container.querySelectorAll('[data-toggle="' + containerId + '"]');
                                            const hidden = Array.from(items).some(item => item.style.display === 'none');

                                            items.forEach(item => {
                                                item.style.display = hidden ? 'block' : 'none';
                                            });

                                            const toggleText = container.querySelector('.toggle-text');
                                            const icon = container.querySelector('i');

                                            if (hidden) {
                                                toggleText.innerText = 'Hide';
                                                icon.classList.remove('fa-chevron-down');
                                                icon.classList.add('fa-chevron-up');
                                            } else {
                                                toggleText.innerText = 'View more';
                                                icon.classList.remove('fa-chevron-up');
                                                icon.classList.add('fa-chevron-down');
                                            }
                                        }

                                        function toggleReason(id) {
                                            var element = document.getElementById(id);
                                            if (element.style.display === 'none') {
                                                element.style.display = 'block';
                                            } else {
                                                element.style.display = 'none';
                                            }
                                        }
        </script>

    </body>
</html>