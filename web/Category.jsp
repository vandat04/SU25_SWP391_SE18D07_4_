<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <link rel="shortcut icon" type="image/x-icon" href="hinh anh/Logo/cropped-Favicon-1-32x32.png" />
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        <script>
    function addToCart(productId, quantity) {
        fetch("cart?action=add&id=" + productId + "&quantity=" + quantity, {
            method: "POST",
            credentials: 'same-origin'
        })
        .then(async response => {
            let data = {};
            let text = await response.text();
            try { data = JSON.parse(text); } catch (e) {}
            // Kiểm tra nếu response chứa 'login' (giống Detail.jsp)
            if (text && text.toLowerCase().includes("login")) {
                showErrorMessage("Please login to add products to cart!");
                setTimeout(function() { window.location.href = 'Login.jsp'; }, 1500);
                return;
            }
            if (response.status === 401 || (data && data.success === false)) {
                showErrorMessage(data.message || "Please login to add products to cart!");
                setTimeout(function() { window.location.href = 'Login.jsp'; }, 1500);
                return;
            }
            if (response.ok && data.success !== false) {
                showSuccessMessage();
            } else {
                showErrorMessage(data.message || "An error occurred, please try again!");
            }
        })
        .catch(error => {
            showErrorMessage("Server connection error!");
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
        <div class="success-message" id="successMessage" style="display:none;"><i class="fa fa-circle-check"></i> Added to cart successfully!</div>
        <div class="success-message" id="errorMessage" style="background: #e74c3c; z-index: 1003; display:none;"></div>


            <!--Hero Section-->
            <div class="hero-section hero-background">
                <h1 class="page-title">Product</h1>
            </div>

            <!--Navigation section-->
        <div class="page-contain category-page left-sidebar">
            <div class="container">
                <div class="row">
                    
                    <!-- Main content -->
                    
                    <div id="main-content" class="main-content col-lg-9 col-md-8 col-sm-12 col-xs-12">
                        <div class="block-item recently-products-cat md-margin-bottom-39">

                            <</div>

                        <div class="product-category list-style">
                            
                            
<!--                            <div id="top-functions-area" class="top-functions-area">
                                <div class="flt-item to-left group-on-mobile">
                                    <span class="flt-title">Refine</span>
                                    <a href="#" class="icon-for-mobile">
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                    </a>
                                    <div class="wrap-selectors">
                                        <form id="filterForm" name="frm-refine" method="get" action="category">
                                            <input type="hidden" name="action" value="${param.action}">
                                            <input type="hidden" name="cid" value="${cid}">
                                            <input type="hidden" name="txt" value="${param.txt}">
                                            <span class="title-for-mobile">Refine Products By</span>
                                            <div data-title="Price:" class="selector-item">
                                                <select name="price" class="selector" onchange="submitForm()">
                                                    <option value="all" ${selectedPrice == 'all' ? 'selected' : ''}>All Prices</option>
                                                    <option value="0-100" ${selectedPrice == '0-100' ? 'selected' : ''}>Less than 100k</option>
                                                    <option value="100-150" ${selectedPrice == '100-150' ? 'selected' : ''}>100k - 150k</option>
                                                    <option value="150-max" ${selectedPrice == '150-max' ? 'selected' : ''}>More than 150k</option>
                                                </select>
                                            </div>
                                             Các phần tử khác nếu cần 
                                            <div class="flt-item to-right" style="padding-left: 100px">
                                                <span class="flt-title">Sort</span>
                                                <div class="wrap-selectors">
                                                    <div class="selector-item orderby-selector">
                                                        <select name="orderby" class="orderby" aria-label="Shop order" onchange="submitForm()">
                                                            <option value="menu_order" ${param.orderby == 'menu_order' ? 'selected' : ''}>Default</option>
                                                            <option value="date" ${param.orderby == 'date' ? 'selected' : ''}>Latest</option>
                                                            <option value="price" ${param.orderby == 'price' ? 'selected' : ''}>Price: Low to High</option>
                                                            <option value="price-desc" ${param.orderby == 'price-desc' ? 'selected' : ''}>Price: High to Low</option>
                                                        </select>
                                                    </div>
                                                     Các phần tử khác nếu cần 
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>-->


                                                                           <c:set var="pageSize" value="6"/>
                                                <c:set var="currentPage" value="${param.page != null ? param.page : 1}"/>
                                                <c:set var="start" value="${(currentPage - 1) * pageSize}"/>
                                                <c:set var="end" value="${start + pageSize}"/>
                                                <c:set var="totalProducts" value="${listP.size()}"/>
                                                <c:set var="totalPages" value="${(totalProducts % pageSize == 0) ? (totalProducts / pageSize) : (totalProducts / pageSize + 1)}"/>

                                                <div class="row">
                                                    <c:forEach var="o" items="${listP}" varStatus="status">
                                                        <c:if test="${status.index >= start && status.index < end && (empty cid || o.cateID == cid)}">
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
                                                                            <!--<a class="lookup btn_call_quickview" href="#"><i class="biolife-icon icon-search"></i></a>-->
                                                                        </div>
                                                                        <div class="info">
                                                                            <c:if test="${not empty listCC}">
                                                                                <c:forEach var="cat" items="${listCC}">
                                                                                    <c:if test="${cat.cid == o.cateID}">
                                                                                        <b class="category-label">${cat.cname}</b>
                                                                                    </c:if>
                                                                                </c:forEach>
                                                                            </c:if>
                                                                            <h4 class="product-title"><a href="detail?pid=${o.id}" class="pr-name">${o.name}</a></h4>
                                                                            <div class="price">
                                                                                <ins><span class="price-amount"><span class="currencySymbol"></span> <fmt:formatNumber value="${o.price}" type="currency"/></span></ins>
                                                                            </div>
                                                                            <div class="slide-down-box">
                                                                                
                                                                                <style>
                                                                                    .slide-down-box {
                                                                                        display: flex;
                                                                                        flex-direction: column;
                                                                                        align-items: center;
                                                                                        justify-content: center;
                                                                                        text-align: center;
                                                                                    }

                                                                                    .slide-down-box .message {
                                                                                        font-size: 14px;
                                                                                        color: #666666;
                                                                                        line-height: 17px;
                                                                                        text-align: center;
                                                                                        padding: 0 15px;
                                                                                    }
                                                                                    .category-label {
                                                                                    display: block;
                                                                                    text-align: center;
                                                                                    margin-bottom: 5px;
                                                                                    font-size: 13px;
                                                                                    text-transform: uppercase;
                                                                                }
                                                                                </style>
                                                                                <div class="buttons">
                                                                                <button type="button" class="btn wishlist-btn" onclick="addToWishlist('${o.id}')">
                                                                                    <i class="fa fa-heart" aria-hidden="true"></i>
                                                                                </button>
                                                                                <a onclick="addToCart('${o.id}', 1)" class="btn add-to-cart-btn">
                                                                                    <i class="fa fa-cart-arrow-down" aria-hidden="true"></i> add to cart
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

                            <div class="biolife-panigations-block">
                                <ul class="panigation-contain">
                                    <c:if test="${currentPage > 1}">
                                        <li><a href="product?page=${currentPage - 1}" class="link-page prev">«</a></li>
                                    </c:if>
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li>
                                            <a href="product?page=${i}" class="link-page ${i == currentPage ? 'current-page' : ''}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li><a href="product?page=${currentPage + 1}" class="link-page next">»</a></li>
                                    </c:if>
                                </ul>
                            </div>

                        </div>
                        </div>
                
                    <!-- Sidebar -->
                    
                    <aside id="sidebar" class="sidebar col-lg-3 col-md-4 col-sm-12 col-xs-12">
                                    <div class="container">
                <nav class="biolife-nav">
                    <ul>
                        <li class="nav-item"><a href="home" class="permal-link">Home</a></li>
                        <c:choose>
    <c:when test="${not empty cid}">
        <c:forEach var="cat" items="${listCC}">
            <c:if test="${cat.cid == cid}">
                <li class="nav-item"><a href="category?cid=${cat.cid}" class="permal-link">${cat.cname}</a></li>
            </c:if>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <li class="nav-item"><a href="category" class="permal-link">Category</a></li>
    </c:otherwise>
</c:choose>
                </ul>
            </nav>
        </div>
                        <div class="biolife-mobile-panels">
                            <span class="biolife-current-panel-title">Sidebar</span>
                            <a class="biolife-close-btn" href="#" data-object="open-mobile-filter">&times;</a>
                        </div>
                        <div class="sidebar-contain">
                            <div class="widget biolife-filter">
                                <h4 class="wgt-title">Departements</h4>
                                <div class="wgt-content">
                                    <div class="wgt-content">
                                        <ul class="cat-list">
                                            <c:forEach var="category" items="${listCC}">
                                                <li class="cat-list-item ${category.cid == param.cid ? 'selected' : ''}">
                                                    <a href="category?cid=${category.cid}" class="cat-link">${category.cname}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                        <style>
                                            .cat-list-item.selected .cat-link {
                                                font-weight: bolder;
                                            }
                                        </style>
                                    </div>
                                </div>
                            </div>




                            <div class="widget biolife-filter">
                                <h4 class="wgt-title">Newest</h4>
                                <div class="wgt-content">
                                    <ul class="products">
                                        <c:forEach var="p" items="${list5}">
                                            <li class="pr-item">
                                                <div class="contain-product style-widget">
                                                    <div class="product-thumb">
                                                        <a href="detail?pid=${p.id}" class="link-to-product" tabindex="0">
                                                            <img src="${p.img}" alt="dd" width="270" height="270" class="product-thumnail" style="object-fit: cover; width: 100%; height: 100%;">
                                                        </a>
                                                    </div>
                                                    <div class="info">
                                                      
                                                        <h4 class="product-title"><a href="detail?pid=${p.id}" class="pr-name" tabindex="0">${p.name}</a></h4>
                                                        <div class="price">
                                                            <ins><span class="price-amount"><span class="currencySymbol"></span><fmt:formatNumber value="${p.price}" type="currency"/></span></ins>
                                                            <!--<del><span class="price-amount"><span class="currencySymbol">£</span>95.00</span></del>-->
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </c:forEach>

                                    </ul>
                                </div>
                            </div>

                        </div>

                    </aside>
                </div>
            </div>
        </div>



        <!-- FOOTER -->
        <jsp:include page="Footer.jsp"></jsp:include>



        <!-- Scroll Top Button -->
        <a class="btn-scroll-top"><i class="biolife-icon icon-left-arrow"></i></a>

        <script src="assets/js/jquery-3.4.1.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.countdown.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/jquery.nicescroll.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>
        <script>
                                                            function submitForm() {
                                                                document.getElementById("filterForm").submit();
                                                            }
        </script>
        <script>
         
            function addToWishlist(productId) {
                fetch('wishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=add&productID=' + encodeURIComponent(productId),
                    credentials: 'same-origin'
                })
                .then(async response => {
                    let text = await response.text();
                    let data = {};
                    try { data = JSON.parse(text); } catch (e) {}
                    if (response.status === 401) {
                        showErrorMessage('Please login to add to wishlist!');
                        setTimeout(function() { window.location.href = 'Login.jsp'; }, 1500);
                        return;
                    }
                    if (response.status === 409 || (data && data.message && data.message.toLowerCase().includes('has been in'))) {
                        showErrorMessage(data.message || 'Product is already in wishlist!');
                        return;
                    }
                    if (response.ok && data && data.status === 'success') {
                        showSuccessMessage(data.message || 'Added to wishlist!');
                    } else if (data && data.message) {
                        showErrorMessage(data.message);
                    } else {
                        showErrorMessage('An error occurred, please try again!');
                    }
                })
                .catch(error => {
                    showErrorMessage('Server connection error!');
                    console.error('Lỗi:', error);
                });
            }
        </script>
        <style>
/* Đảm bảo ảnh trong .wgt-content (sidebar Newest) luôn full ô */
.wgt-content .product-thumb,
.wgt-content .product-thumb a.link-to-product {
    width: 100%;
    height: 80px;
    display: block;
    background: #f8f8f8;
    border-radius: 8px;
    overflow: hidden;
}
.wgt-content .product-thumnail {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
    border-radius: 8px;
    background: #f8f8f8;
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
/* Style cho product card, slide-down-box, button, category-label giống product.jsp */
.slide-down-box {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
}
.slide-down-box .message {
    font-size: 14px;
    color: #666666;
    line-height: 17px;
    text-align: center;
    padding: 0 15px;
}
.category-label {
    display: block;
    text-align: center;
    margin-bottom: 5px;
    font-size: 13px;
    text-transform: uppercase;
}
.product-thumnail {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
    border-radius: 8px;
    background: #f8f8f8;
}
.wishlist-btn {
    background: none;
    border: none;
    color: #e74c3c;
    font-size: 20px;
    cursor: pointer;
    margin-right: 8px;
    transition: color 0.2s;
}
.wishlist-btn:hover {
    color: #c0392b;
}
.add-to-cart-btn {
    background: #27ae60;
    color: #fff;
    border: none;
    border-radius: 4px;
    padding: 8px 16px;
    font-size: 15px;
    cursor: pointer;
    transition: background 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.add-to-cart-btn:hover {
    background: #219150;
}
    /* Đảm bảo các nút hiển thị đẹp khi nằm cạnh nhau */
.slide-down-box .buttons {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    padding: 10px 15px;
}
        </style>

    </body>

</html>