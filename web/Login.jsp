<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <script>
function sendOTP() {
    const input = $('#emailInput').val();
    $.ajax({
        url: 'forgot-password',
        method: 'POST',
        data: {
            action: 'sendOTP',
            input: input
        },
        success: function(response) {
            alert(response.message);
            if(response.success) {
                $('#step1').hide();
                $('#step2').show();
            }
        }
    });
}

function verifyOTP() {
    const otp = $('#otpInput').val();
    $.ajax({
        url: 'forgot-password',
        method: 'POST',
        data: {
            action: 'verifyOTP',
            otp: otp
        },
        success: function(response) {
            alert(response.message);
            if(response.success) {
                $('#step2').hide();
                $('#step3').show();
            }
        }
    });
}

function resetPassword() {
    const password = $('#newPassword').val();
    $.ajax({
        url: 'forgot-password',
        method: 'POST',
        data: {
            action: 'resetPassword',
            newPassword: password
        },
        success: function(response) {
            alert(response.message);
            if(response.success) {
                $('#forgotPasswordModal').modal('hide');
                location.reload();
            }
        }
    });
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

            <!--Hero Section-->
            <div class="hero-section hero-background">
                <h1 class="page-title">Craft Villages</h1>
            </div>

            <!--Navigation section-->
            <div class="container">
                <nav class="biolife-nav">
                    <ul>
                        <li class="nav-item"><a href="index-2.html" class="permal-link">Home</a></li>
                        <li class="nav-item"><span class="current-page">Authentication</span></li>
                    </ul>
                </nav>
            </div>

            <div class="page-contain login-page">

                <!-- Main content -->

                <div id="main-content" class="main-content">

                    <div class="container">


                        <div class="row">

                        <%

                        String usernameCookieSaved="";

                        String passwordCookieSaved="";

                        Cookie[] cookieListFromBrowser = request.getCookies() ;

                        if(cookieListFromBrowser!= null){

                        for(Cookie c :cookieListFromBrowser){

                        if(c.getName().equals("COOKIE_USERNAME")){

                        usernameCookieSaved = c.getValue();

                        }

                        if(c.getName().equals("COOKIE_PASSWORD")){

                        passwordCookieSaved = c.getValue();
                    }
                    }
                    }
                %>
                    <!--Form Sign In-->
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="signin-container">
                            <form action="login" name="frm-login" method="post">
                                <p class="form-row">
                                    <label for="fid-name">Email Address:<span class="requite">*</span></label>
                                    <input type="text" id="fid-name" name="user" value="<%= usernameCookieSaved %>" class="txt-input">
                                </p>
                                <p class="form-row">
                                    <label for="fid-pass">Password:<span class="requite">*</span></label>
                                    <input type="password" id="fid-pass" name="pass" value="<%= passwordCookieSaved%>" class="txt-input">
                                </p>
                                   <p class="remember-me">
                    <input type="checkbox" name="rememberMe" id="rememberMe"  />
                    <label for="rememberMe">Remember me</label>
                    <br>
                    
                </p>

                                    <!-- Add error message display -->

                                    <c:if test="${not empty error}">

                                        <p class="form-row" style="color: red">

                                            ${error}

                                        </p>

                                    </c:if>

                                    <p class="form-row wrap-btn">

                                        <button class="btn btn-submit btn-bold" type="submit">sign in</button>

                                        <div class="form-row">
    <a href="#" class="link-to-help" data-toggle="modal" data-target="#forgotPasswordModal">
        Quên mật khẩu?
    </a>
</div>

                                    </p>

                                </form>

                            </div>

                        </div>

                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:8080/CraftVillage/login&response_type=code&client_id=599094914158-74a3ge5i54m4sukpj2op8ecs7n4fkf9s.apps.googleusercontent.com&approval_prompt=force">

                            Sign in with Google

                        </a>

                        <!--Go to Register form-->

                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">

                            <div class="register-in-container">

                                <div class="intro">

                                    <h4 class="box-title">New Customer?</h4>

                                    <p class="sub-title">Create an account with us and you'll be able to:</p>

                                    <ul class="lis">

                                        <li>Check out faster</li>

                                        <li>Save multiple shipping anddesses</li>

                                        <li>Access your order history</li>

                                        <li>Track new orders</li>

                                        <li>Save items to your Wishlist</li>

                                    </ul>

                                    <!-- Update link to registration page -->

                                    <a href="register" class="btn btn-bold">Create an account</a>

                                </div>

                            </div>

                        </div>


                    </div>


                </div>


            </div>


        </div>


        <!-- FOOTER -->

        <jsp:include page="Footer.jsp"></jsp:include>

        <!--    <footer id="footer" class="footer layout-03">
                <div class="footer-content background-footer-03">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-4 col-md-4 col-sm-9">
                                <section class="footer-item">
                                    <a href="Home.jsp" class="logo footer-logo"><img src="assets/images/organic-3.png" alt="biolife logo" width="135" height="34"></a>
                                    <div class="footer-phone-info">
                                        <i class="biolife-icon icon-head-phone"></i>
                                        <p class="r-info">
                                            <span>Got Questions ?</span>
                                            <span>(700)  9001-1909  (900) 689 -66</span>
                                        </p>
                                    </div>
                                    <div class="newsletter-block layout-01">
                                        <h4 class="title">Newsletter Signup</h4>
                                        <div class="form-content">
                                            <form action="#" name="new-letter-foter">
                                                <input type="email" class="input-text email" value="" placeholder="Your email here...">
                                                <button type="submit" class="bnt-submit" name="ok">Sign up</button>
                                            </form>
                                        </div>
                                    </div>
                                </section>
                            </div>
                            <div class="col-lg-4 col-md-4 col-sm-6 md-margin-top-5px sm-margin-top-50px xs-margin-top-40px">
                                <section class="footer-item">
                                    <h3 class="section-title">Useful Links</h3>
                                    <div class="row">
                                        <div class="col-lg-6 col-sm-6 col-xs-6">
                                            <div class="wrap-custom-menu vertical-menu-2">
                                                <ul class="menu">
                                                    <li><a href="#">About Us</a></li>
                                                    <li><a href="#">About Our Shop</a></li>
                                                    <li><a href="#">Secure Shopping</a></li>
                                                    <li><a href="#">Delivery infomation</a></li>
                                                    <li><a href="#">Privacy Policy</a></li>
                                                    <li><a href="#">Our Sitemap</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-sm-6 col-xs-6">
                                            <div class="wrap-custom-menu vertical-menu-2">
                                                <ul class="menu">
                                                    <li><a href="#">Who We Are</a></li>
                                                    <li><a href="#">Our Services</a></li>
                                                    <li><a href="#">Projects</a></li>
                                                    <li><a href="#">Contacts Us</a></li>
                                                    <li><a href="#">Innovation</a></li>
                                                    <li><a href="#">Testimonials</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                            </div>
                            <div class="col-lg-4 col-md-4 col-sm-6 md-margin-top-5px sm-margin-top-50px xs-margin-top-40px">
                                <section class="footer-item">
                                    <h3 class="section-title">Transport Offices</h3>
                                    <div class="contact-info-block footer-layout xs-padding-top-10px">
                                        <ul class="contact-lines">
                                            <li>
                                                <p class="info-item">
                                                    <i class="biolife-icon icon-location"></i>
                                                    <b class="desc">7563 St. Vicent Place, Glasgow, Greater Newyork NH7689, UK </b>
                                                </p>
                                            </li>
                                            <li>
                                                <p class="info-item">
                                                    <i class="biolife-icon icon-phone"></i>
                                                    <b class="desc">Phone: (+067) 234 789  (+068) 222 888</b>
                                                </p>
                                            </li>
                                            <li>
                                                <p class="info-item">
                                                    <i class="biolife-icon icon-letter"></i>
                                                    <b class="desc">Email:  contact@company.com</b>
                                                </p>
                                            </li>
                                            <li>
                                                <p class="info-item">
                                                    <i class="biolife-icon icon-clock"></i>
                                                    <b class="desc">Hours: 7 Days a week from 10:00 am</b>
                                                </p>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="biolife-social inline">
                                        <ul class="socials">
                                            <li><a href="#" title="twitter" class="socail-btn"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                                            <li><a href="#" title="facebook" class="socail-btn"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                                            <li><a href="#" title="pinterest" class="socail-btn"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                                            <li><a href="#" title="youtube" class="socail-btn"><i class="fa fa-youtube" aria-hidden="true"></i></a></li>
                                            <li><a href="#" title="instagram" class="socail-btn"><i class="fa fa-instagram" aria-hidden="true"></i></a></li>
                                        </ul>
                                    </div>
                                </section>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="separator sm-margin-top-70px xs-margin-top-40px"></div>
                            </div>
                            <div class="col-lg-6 col-sm-6 col-xs-12">
                                <div class="copy-right-text"><p><a href="templateshub.net">Templates Hub</a></p></div>
                            </div>
                            <div class="col-lg-6 col-sm-6 col-xs-12">
                                <div class="payment-methods">
                                    <ul>
                                        <li><a href="#" class="payment-link"><img src="assets/images/card1.jpg" width="51" height="36" alt=""></a></li>
                                        <li><a href="#" class="payment-link"><img src="assets/images/card2.jpg" width="51" height="36" alt=""></a></li>
                                        <li><a href="#" class="payment-link"><img src="assets/images/card3.jpg" width="51" height="36" alt=""></a></li>
                                        <li><a href="#" class="payment-link"><img src="assets/images/card4.jpg" width="51" height="36" alt=""></a></li>
                                        <li><a href="#" class="payment-link"><img src="assets/images/card5.jpg" width="51" height="36" alt=""></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </footer>-->

        <!--Footer For Mobile-->
        <div class="mobile-footer">
            <div class="mobile-footer-inner">
                <div class="mobile-block block-menu-main">
                    <a class="menu-bar menu-toggle btn-toggle" data-object="open-mobile-menu" href="javascript:void(0)">
                        <span class="fa fa-bars"></span>
                        <span class="text">Menu</span>
                    </a>
                </div>
                <div class="mobile-block block-sidebar">
                    <a class="menu-bar filter-toggle btn-toggle" data-object="open-mobile-filter" href="javascript:void(0)">
                        <i class="fa fa-sliders" aria-hidden="true"></i>
                        <span class="text">Sidebar</span>
                    </a>
                </div>
                <div class="mobile-block block-minicart">
                    <a class="link-to-cart" href="#">
                        <span class="fa fa-shopping-bag" aria-hidden="true"></span>
                        <span class="text">Cart</span>
                    </a>
                </div>
                <div class="mobile-block block-global">
                    <a class="menu-bar myaccount-toggle btn-toggle" data-object="global-panel-opened" href="javascript:void(0)">
                        <span class="fa fa-globe"></span>
                        <span class="text">Global</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="mobile-block-global">
            <div class="biolife-mobile-panels">
                <span class="biolife-current-panel-title">Global</span>
                <a class="biolife-close-btn" data-object="global-panel-opened" href="#">&times;</a>
            </div>
            <div class="block-global-contain">
                <div class="glb-item my-account">
                    <b class="title">My Account</b>
                    <ul class="list">
                        <li class="list-item"><a href="#">Login/register</a></li>
                        <li class="list-item"><a href="#">Wishlist <span class="index">(8)</span></a></li>
                        <li class="list-item"><a href="#">Checkout</a></li>
                    </ul>
                </div>
                <div class="glb-item currency">
                    <b class="title">Currency</b>
                    <ul class="list">
                        <li class="list-item"><a href="#">? EUR (Euro)</a></li>
                        <li class="list-item"><a href="#">$ USD (Dollar)</a></li>
                        <li class="list-item"><a href="#">£ GBP (Pound)</a></li>
                        <li class="list-item"><a href="#">¥ JPY (Yen)</a></li>
                    </ul>
                </div>
                <div class="glb-item languages">
                    <b class="title">Language</b>
                    <ul class="list inline">
                        <li class="list-item"><a href="#"><img src="assets/images/languages/us.jpg" alt="flag" width="24" height="18"></a></li>
                        <li class="list-item"><a href="#"><img src="assets/images/languages/fr.jpg" alt="flag" width="24" height="18"></a></li>
                        <li class="list-item"><a href="#"><img src="assets/images/languages/ger.jpg" alt="flag" width="24" height="18"></a></li>
                        <li class="list-item"><a href="#"><img src="assets/images/languages/jap.jpg" alt="flag" width="24" height="18"></a></li>
                    </ul>
                </div>
            </div>
        </div>

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
<!--        modal-->
<div class="modal fade" id="forgotPasswordModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Quên Mật Khẩu</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Bước 1: Nhập email -->
                <div id="step1">
                    <div class="form-group">
                        <label>Email hoặc tên đăng nhập</label>
                        <input type="text" class="form-control" id="emailInput">
                    </div>
                    <button class="btn btn-primary" onclick="sendOTP()">Gửi mã OTP</button>
                </div>

                <!-- Bước 2: Nhập OTP -->
                <div id="step2" style="display:none">
                    <div class="form-group">
                        <label>Nhập mã OTP</label>
                        <input type="text" class="form-control" id="otpInput">
                        <small class="text-muted">Mã OTP có hiệu lực trong 1 phút</small>
                    </div>
                    <button class="btn btn-primary" onclick="verifyOTP()">Xác nhận</button>
                </div>

                <!-- Bước 3: Đặt mật khẩu mới -->
                <div id="step3" style="display:none">
                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password" class="form-control" id="newPassword">
                    </div>
                    <button class="btn btn-primary" onclick="resetPassword()">Đổi mật khẩu</button>
                </div>
            </div>
        </div>
    </div>
</div>
    </body>

</html>