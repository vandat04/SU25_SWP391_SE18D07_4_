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
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        <script src="assets/js/music-player.js"></script>


        <script>
            function addToCart(productId, quantity) {
                fetch("cart?action=add&id=" + productId + "&quantity=" + quantity, {
                    method: "POST",
                    credentials: 'same-origin'
                })
                        .then(async response => {
                            let data = {};
                            let text = await response.text();
                            try {
                                data = JSON.parse(text);
                            } catch (e) {
                            }
                            // Kiểm tra nếu response chứa 'login' (giống Detail.jsp)
                            if (text && text.toLowerCase().includes("login")) {
                                showErrorMessage("Please login to add products to cart!");
                                setTimeout(function () {
                                    window.location.href = 'Login.jsp';
                                }, 1500);
                                return;
                            }
                            if (response.status === 401 || (data && data.success === false)) {
                                showErrorMessage(data.message || "Please login to add products to cart!");
                                setTimeout(function () {
                                    window.location.href = 'Login.jsp';
                                }, 1500);
                                return;
                            }
                            if (response.ok && data.success !== false) {
                                showSuccessMessage();
                            } else {
                                showErrorMessage(data.message || "An error occurred, please try again!");
                            }
                        })
                        .catch(error => {
                            showErrorMessage("Lỗi kết nối máy chủ!");
                            console.error("Lỗi:", error);
                        });
            }
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
        </script>
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

            <!-- Toast Messages -->
            <div class="success-message" id="successMessage" style="display:none;"><i class="fa fa-circle-check"></i> Đã thêm vào giỏ hàng thành công!</div>
            <div class="success-message" id="errorMessage" style="background: #e74c3c; z-index: 1003; display:none;"></div>

            <!-- Page Contain -->
            <div class="page-contain">
                <!-- Page Contain -->
                <div class="page-contain">

                    <!-- Main content -->
                    <div id="main-content" class="main-content">
                        <!-- Main content -->
                        <div id="main-content" class="main-content">

                            <!--Block 01: Main Slide-->
                            <!-- VIDEO SECTION -->
                            <div class="video-section" style="position: relative; width: 100%; height: 700px; overflow: hidden;">
                                <div class="video-container" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">
                                    <iframe style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 100vw; height: 80vw; min-height: 100%; min-width: 177.77vh;" 
                                            src="https://www.youtube.com/embed/dp_Ak9rtTVo?autoplay=1&mute=1&loop=1&playlist=dp_Ak9rtTVo&controls=0&showinfo=0&rel=0" 
                                            frameborder="0" 
                                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                            allowfullscreen>
                                    </iframe>
                                </div>
                                <div class="video-overlay" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); display: flex; justify-content: center; align-items: center;">

                                </div>
                            </div>

                            <!--Block 02: Banners-->
                            <div class="special-slide">
                                <div class="container">
                                    <ul class="biolife-carousel dots_ring_style" data-slick='{"arrows": false, "dots": true, "slidesMargin": 30, "slidesToShow": 1, "infinite": true, "speed": 800, "autoplay": true, "autoplaySpeed": 2000, "pauseOnHover": false, "responsive":[{"breakpoint":1200, "settings":{ "slidesToShow": 1}},{"breakpoint":768, "settings":{ "slidesToShow": 2, "slidesMargin":20, "dots": false}},{"breakpoint":480, "settings":{ "slidesToShow": 1}}]}' >
                                    <c:forEach var="p" items="${listTop5Newsest}">
                                        <li>
                                            <div class="slide-contain biolife-banner__special">
                                                <div class="banner-contain">
                                                    <div class="media">
                                                        <a href="detail?pid=${p.id}" class="bn-link">
                                                            <figure style="
                                                                    margin: 0;
                                                                    padding: 0;
                                                                    width: 616px;
                                                                    height: 500px;
                                                                    overflow: hidden;
                                                                    border-radius: 8px;
                                                                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                                                                    "><img style="
                                                                   width: 100%;
                                                                   height: 100%;
                                                                   object-fit: cover;
                                                                   display: block;
                                                                   transition: transform 0.3s ease;
                                                                   "
                                                                   onmouseover="this.style.transform = 'scale(1.05)'" 
                                                                   onmouseout="this.style.transform = 'scale(1)'"
                                                                   src="${p.img}"  alt="${p.name}"></figure>
                                                        </a>
                                                    </div>  
                                                    <div class="text-content">
                                                        <b class="first-line"></b>
                                                        <!--<span class="second-line">${p.name}</span>-->
                                                        <span class="third-line"><a href="detail?pid=${p.id}" class="bn-link"><i>${p.name}</i></a></span>
                                                        <h3>${p.description}</h3>
                                                        <div class="product-detail">

                                                            <h4 class="product-name"></h4>
                                                            <div class="price price-contain">
                                                                <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${p.price}" type="currency"/></span></ins>
                                                            </div>
                                                            <div class="buttons">
                                                                <a onclick="addToCart('${p.id}', 1)" class="btn add-to-cart-btn">add to cart</a>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                        </li>
                                    </c:forEach>
                                </ul>

                            </div>
                        </div>


                        <!-- 360° TOUR SECTION (can be hidden in minimal mode) -->
                        <c:if test="${minimal != true}">
                            <div class="tour-section" style="padding: 60px 0; background: #f9f9f9; margin-top: 100px;">
                                <div class="container">
                                    <div class="biolife-service type01 biolife-service__type01 sm-margin-top-0 xs-margin-top-45px">
                                        <b class="txt-show-01" >Tour 360°</b>
                                        <i class="txt-show-02" >CraftVillage</i>
                                        <i class="txt-show-02" >CraftVillage</i>                              
                                    </div>
                                    <div class="row" style="margin-top: 40px;">
                                        <div class="col-md-4">
                                            <div class="tour-item" style="background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 15px rgba(0,0,0,0.1);">
                                                <img src="hinhanh/village/thanh-ha.jpg" alt="Làng gốm Thanh Hà" style="width: 100%; height: 250px; object-fit: cover;">
                                                <div class="tour-content" style="padding: 25px;">
                                                    <h4>Thanh Ha Pottery Village</h4>
                                                    <p>Discover the art of traditional pottery through a 360° tour</p>
                                                    <a href="tour360?village=thanh-ha" class="btn btn-outline-primary">Take a tour</a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="tour-item" style="background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 15px rgba(0,0,0,0.1);">
                                                <img src="hinhanh/village/kim-bong.jpg" alt="Làng mộc Kim Bồng" style="width: 100%; height: 250px; object-fit: cover;">
                                                <div class="tour-content" style="padding: 25px;">
                                                    <h4>Kim Bong carpentry village</h4>
                                                    <p>Experience traditional carpentry through 360° tour</p>
                                                    <a href="tour360?village=kim-bong" class="btn btn-outline-primary">Take a tour</a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="tour-item" style="background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 15px rgba(0,0,0,0.1);">
                                                <img src="hinhanh/village/non-nuoc.jpg" alt="Làng đá Non Nước" style="width: 100%; height: 250px; object-fit: cover;">
                                                <div class="tour-content" style="padding: 25px;">
                                                    <h4>Non Nuoc Stone Village</h4>
                                                    <p>Explore the art of stone carving through a 360° tour</p>
                                                    <a href="tour360?village=non-nuoc" class="btn btn-outline-primary">Take a tour</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <!--Block 03: Product Tabs-->
                        <div class="product-tab z-index-20 sm-margin-top-180px xs-margin-top-10px" id="product-list">
                            <div class="container" >
                                <div class="biolife-title-box" >
                                    <div class="product-tab z-index-20 sm-margin-top-193px xs-margin-top-30px" id="product-list">
                                        <div class="container" >
                                            <div class="biolife-service type01 biolife-service__type01 sm-margin-top-0 xs-margin-top-30px">
                                                <b class="txt-show-01" >Craft Villages</b>
                                                <i class="txt-show-02" >Authentic Products</i>
                                                <i class="txt-show-02" >Authentic Products</i>                              
                                            </div>
                                            <div class="biolife-tab biolife-tab-contain sm-margin-top-10px">
                                                <div class="tab-head tab-head__icon-top-layout icon-top-layout">
                                                </div>

                                                <%-- Thiết lập thông tin phân trang --%>

                                                <c:set var="pageSize" value="6"/>
                                                <c:set var="currentPage" value="${param.page != null ? param.page : 1}"/>
                                                <c:set var="start" value="${(currentPage - 1) * pageSize}"/>
                                                <c:set var="end" value="${start + pageSize}"/>
                                                <c:set var="totalProducts" value="${listP.size()}"/>
                                                <c:set var="totalPages" value="${(totalProducts % pageSize == 0) ? (totalProducts / pageSize) : (totalProducts / pageSize + 1)}"/>

                                                <div class="row">
                                                    <c:forEach var="o" items="${listP}" varStatus="status">
                                                        <c:if test="${status.index >= start && status.index < end}">
                                                            <div class="col-12 col-md-6 col-lg-4">
                                                                <div class="product-item">
                                                                    <div class="contain-product layout-default">
                                                                        <div class="product-thumb">
                                                                            <a href="detail?pid=${o.id}" class="link-to-product">
                                                                                <figure style="
                                                                                        margin: 0;
                                                                                        padding: 0;
                                                                                        width: 100%;
                                                                                        height: 270px;
                                                                                        overflow: hidden;
                                                                                        position: relative;
                                                                                        border-radius: 8px;
                                                                                        background-color: #f8f8f8;
                                                                                        ">
                                                                                    <img src="${o.img}" alt="${o.name}"  class="product-thumnail" style="
                                                                                         width: 100%;
                                                                                         height: 100%;
                                                                                         object-fit: cover;
                                                                                         transition: transform 0.3s ease;
                                                                                         "> </figure>
                                                                            </a> 

                                                                        </div>
                                                                        <div class="info">
                                                                            <!-- Thêm hiển thị category cho từng sản phẩm -->
                                                                            <c:if test="${not empty listCC}">
                                                                                <c:forEach var="cat" items="${listCC}">
                                                                                    <c:if test="${cat.categoryID == o.cateID}">
                                                                                        <b class="category-label">${cat.categoryName}</b>
                                                                                    </c:if>
                                                                                </c:forEach>
                                                                            </c:if>
                                                                            <h4 class="product-title"><a href="detail?pid=${o.id}" class="pr-name">${o.name}</a></h4>
                                                                            <div class="price">
                                                                                <ins><span class="price-amount"><span class="currencySymbol"></span> <fmt:formatNumber value="${o.price}" type="currency"/></span></ins>
                                                                            </div>
                                                                            <div class="slide-down-box">

                                                                                <div class="buttons">
                                                                                    <button type="button" class="btn wishlist-btn add-to-wishlist" data-product-id="${o.id}">
                                                                                        <i class="fa fa-heart" aria-hidden="true"></i>
                                                                                    </button>
                                                                                    <a href="#" onclick="event.preventDefault();
                                                                                        addToCart('${o.id}', 1)" class="btn add-to-cart-btn">
                                                                                        <i class="fa fa-cart-arrow-down" aria-hidden="true"></i> Add to cart
                                                                                    </a>
                                                                                </div>

                                                                            </div>
                                                                        </div>

                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- FOOTER -->
                            <div style="margin-top: 80px;">
                                <jsp:include page="Footer.jsp"></jsp:include>
                            </div>

                            <!-- Scroll Top Button -->
                            <a class="btn-scroll-top" 
                               style="position: fixed;
                               left: 50px !important; /* Ghi đè lên CSS gốc nếu có */
                               ">
                                <i class="biolife-icon icon-left-arrow"></i>
                            </a>

                            <script src="assets/js/jquery-3.4.1.min.js"></script>
                            <script src="assets/js/bootstrap.min.js"></script>
                            <script src="assets/js/jquery.countdown.min.js"></script>
                            <script src="assets/js/jquery.nice-select.min.js"></script>
                            <script src="assets/js/jquery.nicescroll.min.js"></script>
                            <script src="assets/js/slick.min.js"></script>
                            <script src="assets/js/biolife.framework.js"></script>
                            <script src="assets/js/functions.js"></script>
                            <!-- Replace your entire chat widget implementation with this code -->
                            <style>
                                #chat-button {
                                    position: fixed;
                                    bottom: 20px;
                                    right: 20px;
                                    width: 60px;
                                    height: 60px;
                                    border-radius: 50%;
                                    background-color: #4CAF50;
                                    box-shadow: 0 3px 10px rgba(0,0,0,0.3);
                                    cursor: pointer;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    z-index: 9999;
                                    transition: transform 0.3s;
                                }

                                #chat-button:hover {
                                    transform: scale(1.05);
                                }

                                #chat-container {
                                    position: fixed;
                                    bottom: 90px;
                                    right: 20px;
                                    width: 350px;
                                    height: 500px;
                                    background-color: white;
                                    border-radius: 10px;
                                    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                                    z-index: 9998;
                                    display: none;
                                    overflow: hidden;
                                    flex-direction: column;
                                }

                                .chat-header {
                                    background: #4CAF50;
                                    color: white;
                                    padding: 15px;
                                    text-align: center;
                                    font-size: 18px;
                                    display: flex;
                                    justify-content: space-between;
                                }

                                .chat-close {
                                    cursor: pointer;
                                    font-weight: bold;
                                    font-size: 20px;
                                }

                                .chat-messages {
                                    padding: 15px;
                                    height: 380px;
                                    overflow-y: auto;
                                    display: flex;
                                    flex-direction: column;
                                }

                                .message {
                                    margin-bottom: 15px;
                                    clear: both;
                                    max-width: 80%;
                                }

                                .user-message {
                                    background: #e0e0e0;
                                    color: #333;
                                    padding: 10px 15px;
                                    border-radius: 18px;
                                    float: right;
                                    align-self: flex-end;
                                }

                                .bot-message {
                                    background: #4CAF50;
                                    color: white;
                                    padding: 10px 15px;
                                    border-radius: 18px;
                                    float: left;
                                    align-self: flex-start;
                                }

                                .chat-input {
                                    display: flex;
                                    padding: 10px;
                                    border-top: 1px solid #e0e0e0;
                                }

                                .chat-input input {
                                    flex: 1;
                                    padding: 10px;
                                    border: 1px solid #e0e0e0;
                                    border-radius: 4px;
                                    margin-right: 10px;
                                }

                                .chat-input button {
                                    background: #4CAF50;
                                    color: white;
                                    border: none;
                                    padding: 10px 15px;
                                    border-radius: 4px;
                                    cursor: pointer;
                                }
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
                            </style>

                            <!-- Chat Button -->
                            <div id="chat-button">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                                </svg>
                            </div>

                            <!-- Chat Container (Replaces iframe with direct interface) -->
                            <div id="chat-container">
                                <div class="chat-header">
                                    <span>Wiish - Support to buy advice on craft village information</span>
                                    <span class="chat-close" id="chat-close">&times;</span>
                                </div>
                                <div class="chat-messages" id="chat-messages">
                                    <!-- Messages will be added here dynamically -->
                                </div>
                                <div class="chat-input">
                                    <input type="text" id="user-input" placeholder="Enter your question...">
                                    <button id="send-button">Gửi</button>
                                </div>
                            </div>

                            <script>
                                                                                    document.addEventListener('DOMContentLoaded', function () {
                                                                                        const chatButton = document.getElementById('chat-button');
                                                                                        const chatContainer = document.getElementById('chat-container');
                                                                                        const chatClose = document.getElementById('chat-close');
                                                                                        const messagesContainer = document.getElementById('chat-messages');
                                                                                        const userInput = document.getElementById('user-input');
                                                                                        const sendButton = document.getElementById('send-button');

                                                                                        // Add welcome message when chat is first opened
                                                                                        let isFirstOpen = true;

                                                                                        // Open chat
                                                                                        chatButton.addEventListener('click', function () {
                                                                                            chatContainer.style.display = 'flex';

                                                                                            if (isFirstOpen) {
                                                                                                addBotMessage("Hello! I'm Wiish - a virtual assistant for craft villages. What support do you need?");
                                                                                                isFirstOpen = false;
                                                                                            }

                                                                                            userInput.focus();
                                                                                        });

                                                                                        // Close chat
                                                                                        chatClose.addEventListener('click', function () {
                                                                                            chatContainer.style.display = 'none';
                                                                                        });

                                                                                        // Send message
                                                                                        function sendMessage() {
                                                                                            const message = userInput.value.trim();
                                                                                            if (message === '')
                                                                                                return;

                                                                                            // Add user message to chat
                                                                                            addUserMessage(message);
                                                                                            userInput.value = '';

                                                                                            // Show typing indicator
                                                                                            const typingIndicator = document.createElement('div');
                                                                                            typingIndicator.className = 'message bot-message';
                                                                                            typingIndicator.id = 'typing-indicator';
                                                                                            typingIndicator.innerText = 'Replying...';
                                                                                            messagesContainer.appendChild(typingIndicator);
                                                                                            messagesContainer.scrollTop = messagesContainer.scrollHeight;

                                                                                            // Send request to Flask backend
                                                                                            fetch('http://localhost:5000/chat', {
                                                                                                method: 'POST',
                                                                                                headers: {
                                                                                                    'Content-Type': 'application/json'
                                                                                                },
                                                                                                body: JSON.stringify({message: message})
                                                                                            })
                                                                                                    .then(response => response.json())
                                                                                                    .then(data => {
                                                                                                        // Remove typing indicator
                                                                                                        const indicator = document.getElementById('typing-indicator');
                                                                                                        if (indicator)
                                                                                                            messagesContainer.removeChild(indicator);

                                                                                                        // Add bot response
                                                                                                        addBotMessage(data.response);
                                                                                                    })
                                                                                                    .catch(error => {
                                                                                                        // Remove typing indicator
                                                                                                        const indicator = document.getElementById('typing-indicator');
                                                                                                        if (indicator)
                                                                                                            messagesContainer.removeChild(indicator);

                                                                                                        // Show error message
                                                                                                        addBotMessage("Sorry, there was an error connecting to the server. Please try again later.");
                                                                                                        console.error('Error:', error);
                                                                                                    });
                                                                                        }

                                                                                        // Add event listeners for sending
                                                                                        sendButton.addEventListener('click', sendMessage);
                                                                                        userInput.addEventListener('keypress', function (e) {
                                                                                            if (e.key === 'Enter') {
                                                                                                sendMessage();
                                                                                            }
                                                                                        });

                                                                                        // Function to add user message to chat
                                                                                        function addUserMessage(message) {
                                                                                            const messageDiv = document.createElement('div');
                                                                                            messageDiv.className = 'message user-message';
                                                                                            messageDiv.innerText = message;
                                                                                            messagesContainer.appendChild(messageDiv);
                                                                                            messagesContainer.scrollTop = messagesContainer.scrollHeight;
                                                                                        }

                                                                                        // Function to add bot message to chat
                                                                                        function addBotMessage(message) {
                                                                                            const messageDiv = document.createElement('div');
                                                                                            messageDiv.className = 'message bot-message';

                                                                                            // Handle markdown-like formatting from Python
                                                                                            message = message.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
                                                                                            message = message.replace(/\n/g, '<br>');

                                                                                            messageDiv.innerHTML = message;
                                                                                            messagesContainer.appendChild(messageDiv);
                                                                                            messagesContainer.scrollTop = messagesContainer.scrollHeight;
                                                                                        }
                                                                                    });
                            </script>
                            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                            <script>
                                                                                    $(document).ready(function () {
                                                                                        $('.add-to-wishlist').click(function (e) {
                                                                                            e.preventDefault();
                                                                                            var productId = $(this).data('product-id');
                                                                                            $.ajax({
                                                                                                url: 'wishlist',
                                                                                                method: 'POST',
                                                                                                data: {action: 'add', productID: productId},
                                                                                                success: function (response) {
                                                                                                    if (typeof response === "string") {
                                                                                                        try {
                                                                                                            response = JSON.parse(response);
                                                                                                        } catch (e) {
                                                                                                        }
                                                                                                    }
                                                                                                    if (response && response.message) {
                                                                                                        showSuccessMessage(response.message);
                                                                                                    } else {
                                                                                                        showSuccessMessage('Added to wishlist!');
                                                                                                    }
                                                                                                },
                                                                                                error: function () {
                                                                                                    showErrorMessage('An error occurred, please try again!');
                                                                                                }
                                                                                            });
                                                                                        });
                                                                                    });
                            </script>
                            </body>

                            </html>