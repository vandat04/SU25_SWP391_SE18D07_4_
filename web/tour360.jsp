<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="service.TourService" %>
<%@ page import="service.ProductService" %>
<%@ page import="entity.CraftVillage.*" %>
<%@ page import="entity.Product.Product" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>360° Virtual Tours - Craft Village</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet">
        
        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="hinhanh/Logo/cropped-Favicon-1-32x32.png" />
        
        <!-- CSS -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        
        <style>
            body { 
                margin: 0; 
                font-family: 'Poppins', sans-serif;
                background: #f9f9f9;
            }

            /* ==========================================================================
               VILLAGE CARD STYLING (from craftVillage.jsp)
               ========================================================================== */
            
            /* --- Village Card Container --- */
            .village-card {
                background-color: #fff;
                border: 1px solid #e9ecef;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.06);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            /* --- Card Hover Effect --- */
            .village-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            }

            /* --- Image Wrapper & Image --- */
            .village-card-img-wrapper {
                height: 220px;
                overflow: hidden;
                position: relative;
            }
            
            .village-card-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.4s ease;
            }

            .village-card:hover .village-card-img {
                transform: scale(1.05);
            }

            /* --- Card Body & Content --- */
            .village-card .card-body {
                padding: 20px;
                display: flex;
                flex-direction: column;
                flex-grow: 1;
            }

            .village-card .card-title {
                font-family: 'Poppins', sans-serif;
                font-size: 1.2rem;
                font-weight: 600;
                color: #34495e;
                margin-bottom: 10px;
            }
            
            .village-card .card-description {
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 15px;
                flex-grow: 1;
            }
            
            /* --- Button Styling --- */
            .village-card .btn {
                margin-top: auto;
                border-radius: 50px;
                padding: 10px 25px;
                font-weight: 600;
                transition: background-color 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-orange {
                background-color: #e5a134;
                color: #fff;
                border: none;
            }

            .btn-orange:hover {
                background-color: #d48f2e;
                color: #fff;
                text-decoration: none;
            }
            
            /* --- "No Results" Message --- */
            .no-results-message {
                text-align: center;
                padding: 50px 20px;
                background-color: #fff;
                border-radius: 15px;
                border: 1px solid #e9ecef;
                box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            }
            .no-results-message p {
                font-size: 1.1rem;
                color: #555;
                margin: 0;
            }

            /* ==========================================================================
               SECTION STYLING (from Home.jsp 360° TOUR SECTION)
               ========================================================================== */
            
            .tour-section {
                padding: 60px 0;
                background: #f9f9f9;
                margin-top: 30px;
            }

            .biolife-service.type01 {
                text-align: center;
                margin-bottom: 40px;
            }

            .txt-show-01 {
                display: block;
                font-size: 2.5rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .txt-show-02 {
                display: block;
                font-size: 1.2rem;
                color: #7f8c8d;
                font-style: italic;
            }

            /* ==========================================================================
               RESPONSIVE DESIGN
               ========================================================================== */
            
            @media (max-width: 768px) {
                .txt-show-01 {
                    font-size: 2rem;
                }
                
                .txt-show-02 {
                    font-size: 1rem;
                }
                
                .village-card-img-wrapper {
                    height: 180px;
                }
            }

            @media (max-width: 480px) {
                .txt-show-01 {
                    font-size: 1.8rem;
                }
                
                .village-card-img-wrapper {
                    height: 160px;
                }
            }
        </style>
    </head>
    <body class="biolife-body">
        <!-- HEADER/MENU -->
        <jsp:include page="Menu.jsp"/>

        <%
        // Khởi tạo services
        TourService tourService = new TourService();
        ProductService productService = new ProductService();
        
        // Lấy tất cả villages có tour
        List<CraftVillage> villages = new ArrayList<>();
        
        // Lấy tất cả villages từ database (giả sử có 9 villages)
        for (int i = 1; i <= 9; i++) {
            Tour defaultTour = tourService.getDefaultTourByVillage(i);
            if (defaultTour != null) {
                // Tạo CraftVillage object với thông tin cơ bản
                CraftVillage village = new CraftVillage();
                village.setVillageID(i);
                
                // Set tên village dựa trên ID
                switch (i) {
                    case 1:
                        village.setVillageName("Thanh Ha Pottery Village");
                        village.setMainImageUrl("hinhanh/village/thanh-ha.jpg");
                        village.setDescription("Discover the art of traditional pottery through a 360° tour");
                        break;
                    case 2:
                        village.setVillageName("Ma Chau Embroidery Village");
                        village.setMainImageUrl("hinhanh/village/ma-chau.jpg");
                        village.setDescription("Experience traditional embroidery through 360° tour");
                        break;
                    case 3:
                        village.setVillageName("Kim Bong Carpentry Village");
                        village.setMainImageUrl("hinhanh/village/kim-bong.jpg");
                        village.setDescription("Explore traditional carpentry through a 360° tour");
                        break;
                    case 4:
                        village.setVillageName("Phuoc Kieu Bronze Casting Village");
                        village.setMainImageUrl("hinhanh/village/phuoc-kieu.jpg");
                        village.setDescription("Discover bronze casting techniques through 360° tour");
                        break;
                    case 5:
                        village.setVillageName("Nam O Fish Sauce Village");
                        village.setMainImageUrl("hinhanh/village/nam-o.jpg");
                        village.setDescription("Learn about traditional fish sauce making through 360° tour");
                        break;
                    case 6:
                        village.setVillageName("Non Nuoc Stone Village");
                        village.setMainImageUrl("hinhanh/village/non-nuoc.jpg");
                        village.setDescription("Explore the art of stone carving through a 360° tour");
                        break;
                    case 7:
                        village.setVillageName("Tra Que Vegetable Village");
                        village.setMainImageUrl("hinhanh/village/tra-que.jpg");
                        village.setDescription("Experience organic farming through 360° tour");
                        break;
                    case 8:
                        village.setVillageName("Ban Thach Mat Weaving Village");
                        village.setMainImageUrl("hinhanh/village/ban-thach.jpg");
                        village.setDescription("Discover traditional mat weaving through 360° tour");
                        break;
                    case 9:
                        village.setVillageName("Hoi An Lantern Village");
                        village.setMainImageUrl("hinhanh/village/hoi-an-lantern.jpg");
                        village.setDescription("Explore lantern making through a 360° tour");
                        break;
                }
                
                villages.add(village);
            }
        }
        %>

        <div class="page-contain" style="padding: 10px 0; background: #f9f9f9; margin-top: 30px;">
            <div class="container">
                <!-- Section Title (from Home.jsp 360° TOUR SECTION) -->
                <div class="biolife-service type01 biolife-service__type01 sm-margin-top-0 xs-margin-top-45px">
                    <b class="txt-show-01">Tour 360°</b>
                    <i class="txt-show-02">Experience Traditional Crafts in 360°</i>
                    <i class="txt-show-02">Experience Traditional Crafts in 360°</i>                              
                </div>

                <!-- Village Cards Grid -->
                <div class="row" style="margin-top: 40px;">
                    <% if (!villages.isEmpty()) { %>
                        <% for (CraftVillage village : villages) { %>
                            <div class="col-12 col-sm-6 col-lg-4 mb-4">
                                <div class="village-card">
                                    <div class="village-card-img-wrapper">
                                        <img src="<%= village.getMainImageUrl() %>" class="village-card-img" alt="<%= village.getVillageName() %>">
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title"><%= village.getVillageName() %></h5>
                                        <p class="card-description"><%= village.getDescription() %></p>
                                        <a href="tour360-final.jsp?villageID=<%= village.getVillageID() %>" class="btn btn-orange">Take a tour</a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="col-12">
                            <div class="no-results-message">
                                <p>No 360° tours are currently available.</p>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Additional Info Section -->
                <div class="row mt-5">
                    <div class="col-12">
                        <div class="text-center">
                            <h4 style="color: #2c3e50; margin-bottom: 20px;">How to Use 360° Tours</h4>
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="text-center mb-4">
                                        <i class="fa fa-mouse-pointer fa-3x" style="color: #e5a134; margin-bottom: 15px;"></i>
                                        <h5>Click & Explore</h5>
                                        <p>Click on hotspots to navigate between scenes and learn about different areas</p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-center mb-4">
                                        <i class="fa fa-shopping-cart fa-3x" style="color: #e5a134; margin-bottom: 15px;"></i>
                                        <h5>Shop Products</h5>
                                        <p>Visit virtual shops to browse and purchase authentic craft products</p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-center mb-4">
                                        <i class="fa fa-info-circle fa-3x" style="color: #e5a134; margin-bottom: 15px;"></i>
                                        <h5>Learn History</h5>
                                        <p>Discover the rich history and cultural significance of each craft village</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <jsp:include page="Footer.jsp"/>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.countdown.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/jquery.nicescroll.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>
    </body>
</html> 
