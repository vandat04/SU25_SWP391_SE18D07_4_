
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

        <jsp:include page="Menu.jsp"></jsp:include>
            <div class="hero-section hero-background">
                <h1 class="page-title">Contact</h1>
            </div>
            <div class="page-contain">
                <div id="main-content" class="main-content">
                    <div class="container">
                        <nav class="biolife-nav">
                            <ul>
                                <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                                <%-- SỬA CHỮA CHỦ YẾU Ở ĐÂY: Dùng thẻ <a> và không truyền userID nếu Servlet lấy từ session --%>
                                <li class="nav-item"><a href="<c:url value='/contact'/>" class="permal-link"><strong>Contact</strong></a></li>
                                <%--
                                    Nếu bạn vẫn muốn truyền userID qua URL (ít khuyến khích cho thông tin nhạy cảm của người dùng),
                                    thì sửa thành:
                                    <li class="nav-item">
                                        <a href="<c:url value='/contact'>
                                                 <c:param name='userID' value='${sessionScope.acc.userID}'/>
                                               </c:url>" class="permal-link"><strong>Contact</strong></a>
                                    </li>
                                --%>
                            </ul>
                        </nav>
                    </div>
                    <div class="container">
                        <div class="contact-container">
                            <div class="profile-header">
                                <h4>Your Message Threads</h4>
                            </div>

                            <%-- Hiển thị thông báo lỗi/thành công nếu có --%>
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" role="alert">
                                    ${errorMessage}
                                </div>
                            </c:if>
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success" role="alert">
                                    ${successMessage}
                                </div>
                            </c:if>

                            <c:choose>
                                <c:when test="${not empty listMessageThread}">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Thread ID</th>
                                                <th>Message Name</th>
                                                <th>Seller ID</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="thread" items="${listMessageThread}">
                                                <tr>
                                                    <td>${thread.threadID}</td>
                                                    <td>${thread.messageName}</td>
                                                    <td>${thread.sellerID}</td>
                                                    <td>
                                                        <%-- Liên kết xem chi tiết chat --%>
                                                        <a href="<c:url value='/contact-artist'>
                                                                 <c:param name='threadID' value='${thread.threadID}'/>
                                                                 <c:param name='userID' value='${thread.userID}'/>
                                                                 <c:param name='sellerID' value='${thread.sellerID}'/>
                                                               </c:url>"
                                                           class="btn btn-success btn-sm">
                                                            View Chat
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <p>No message threads found.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

        <jsp:include page="Footer.jsp"></jsp:include>

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