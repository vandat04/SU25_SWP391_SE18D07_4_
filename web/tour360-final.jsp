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
        <title>Tour 360Â° - Craft Village</title>
        <script src="js/marzipano.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer">
        <style>
            body { 
                margin: 0; 
                overflow: hidden; 
                font-family: 'Poppins', sans-serif;
            }

            #hotspot {
                position: absolute;
                width: 40px; height: 40px;
                background: rgba(255,165,0,0.8);
                border-radius: 50%;
                left: 50%; top: 50%;
                transform: translate(-50%, -50%);
                z-index: 10;
                cursor: pointer;
                display: flex; align-items: center; justify-content: center;
                font-size: 24px; color: #fff; font-weight: bold;
                border: 2px solid #fff;
            }
            #hotspot:hover { background: orange; }

            /* Shop Popup Styles */
            .shop-popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: rgba(255, 255, 255, 0.95);
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                z-index: 1000;
                width: 90%;
                max-width: 1200px;
                max-height: 85vh;
                overflow-y: auto;
                backdrop-filter: blur(10px);
                animation: popupFadeIn 0.3s ease-out;
            }

            @keyframes popupFadeIn {
                from { 
                    opacity: 0;
                    transform: translate(-50%, -48%);
                }
                to { 
                    opacity: 1;
                    transform: translate(-50%, -50%);
                }
            }

            .shop-popup.active {
                display: block;
            }

            .shop-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.6);
                backdrop-filter: blur(5px);
                z-index: 999;
                animation: overlayFadeIn 0.3s ease-out;
            }

            @keyframes overlayFadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            .shop-overlay.active {
                display: block;
            }

            .shop-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0f0f0;
            }

            .shop-header h2 {
                margin: 0;
                color: #2c3e50;
                font-size: 28px;
                font-weight: 600;
            }

            .shop-close {
                cursor: pointer;
                font-size: 28px;
                color: #666;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                transition: all 0.3s ease;
            }

            .shop-close:hover {
                background: #f0f0f0;
                color: #e74c3c;
            }

            .shop-products {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 30px;
                padding: 20px 0;
            }

            .product-card {
                background: white;
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                transition: all 0.3s ease;
                border: 1px solid #eee;
                position: relative;
                overflow: hidden;
            }

            .product-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
                border-color: #4CAF50;
            }

            .product-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
                transform: translateX(-100%);
                transition: 0.5s;
            }

            .product-card:hover::before {
                transform: translateX(100%);
            }

            .product-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 15px;
                transition: transform 0.3s ease;
            }

            .product-card:hover .product-image {
                transform: scale(1.05);
            }

            .product-title {
                font-weight: 600;
                margin-bottom: 10px;
                color: #2c3e50;
                font-size: 18px;
            }

            .product-price {
                color: #e74c3c;
                font-weight: 600;
                font-size: 20px;
                margin-bottom: 15px;
            }

            .add-to-cart-btn {
                background: #4CAF50;
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                width: 100%;
                font-size: 16px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .add-to-cart-btn:hover {
                background: #45a049;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
            }

            .add-to-cart-btn:active {
                transform: translateY(0);
            }

            .view-cart-btn {
                background: #2196F3;
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 20px;
                width: 100%;
                font-size: 16px;
                font-weight: 500;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .view-cart-btn:hover {
                background: #1976D2;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
            }

            .view-cart-btn:active {
                transform: translateY(0);
            }

            .success-message {
                position: fixed;
                top: 20px;
                right: 20px;
                background: #4CAF50;
                color: white;
                padding: 15px 25px;
                border-radius: 10px;
                z-index: 1002;
                display: none;
                animation: slideIn 0.5s ease-out;
                box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
                font-weight: 500;
            }

            @keyframes slideIn {
                from { 
                    transform: translateX(100%);
                    opacity: 0;
                }
                to { 
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .shop-popup {
                    width: 95%;
                    padding: 20px;
                }

                .shop-header h2 {
                font-size: 24px;
                }

                .shop-products {
                    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                    gap: 20px;
                }

                .product-image {
                    height: 180px;
                }
            }

            @media (max-width: 480px) {
                .shop-popup {
                    padding: 15px;
                }

                .shop-header h2 {
                    font-size: 20px;
                }

                .shop-products {
                    grid-template-columns: 1fr;
                }

                .product-image {
                    height: 160px;
                }
            }

            /* Hotspot style for Marzipano */
            .hotspot {
                position: absolute;
                width: 70px; height: 70px;
                background: transparent;
                border-radius: 50%;
                display: flex; 
                align-items: center; 
                justify-content: center;
                font-size: 45px; color: #fff; font-weight: bold;
                border: none;
                cursor: pointer;
                z-index: 10;
                transition: all 0.3s ease;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
                /* Cá» Äá»nh hotspot Äá» khÃ´ng di chuyá»n khi xoay */
                transform-origin: center center;
                will-change: transform;
                /* Äáº£m báº£o hotspot á» trung tÃ¢m */
                left: 50%;
                top: 50%;
                transform: translate(-50%, -50%);
                /* Äáº£m báº£o icon á» trung tÃ¢m hoÃ n háº£o */
                text-align: center;
                line-height: 1;
            }
            .hotspot:hover { 
                background: rgba(255,255,255,0.1);
                transform: scale(1.1);
            }
            
            /* Font Awesome icon styles for hotspots */
            .hotspot i {
                font-size: 45px;
                color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                height: 100%;
                /* Äáº£m báº£o Font Awesome icons hiá»n thá» ÄÃºng */
                font-family: "Font Awesome 6 Free";
                font-weight: 900;
                /* Äáº£m báº£o icon á» trung tÃ¢m hoÃ n háº£o */
                text-align: center;
                line-height: 1;
            }
            
            /* Sá»­a lá»i ::before cho Font Awesome */
            .hotspot i::before {
                font-family: "Font Awesome 6 Free";
                font-weight: 900;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            /* Loading Screen */
            .loading-screen {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                z-index: 9999;
                transition: opacity 0.5s ease-out;
            }
            
            .loading-screen.hidden {
                opacity: 0;
                pointer-events: none;
            }
            
            .loading-spinner {
                width: 60px;
                height: 60px;
                border: 4px solid rgba(255, 255, 255, 0.3);
                border-top: 4px solid #fff;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-bottom: 20px;
            }
            
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            
            .loading-text {
                color: #fff;
                font-size: 18px;
                font-weight: 500;
                text-align: center;
                margin-bottom: 10px;
            }
            
            .loading-subtext {
                color: rgba(255, 255, 255, 0.8);
                font-size: 14px;
                text-align: center;
            }
            
            /* NÃºt Back to Home */
            .back-to-home-btn {
                position: fixed;
                top: 20px;
                right: 20px;
                background: rgba(255, 255, 255, 0.9);
                color: #333;
                border: none;
                padding: 12px 20px;
                border-radius: 25px;
                cursor: pointer;
                z-index: 1000;
                font-family: 'Poppins', sans-serif;
                font-size: 14px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
            }
            
            .back-to-home-btn:hover {
                background: rgba(255, 255, 255, 1);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.2);
            }
            
            .back-to-home-btn i {
                font-size: 16px;
            }
            
            /* Popup hiá»n thá» tá»a Äá» */
            #coord-popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: #fff;
                color: #222;
                border-radius: 12px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.18);
                padding: 32px 40px 24px 40px;
                z-index: 3000;
                font-size: 20px;
                font-weight: 600;
                min-width: 320px;
                text-align: center;
                animation: popupFadeIn 0.2s;
            }
            #coord-popup .close-btn {
                position: absolute;
                top: 10px;
                right: 18px;
                background: none;
                border: none;
                font-size: 26px;
                color: #888;
                cursor: pointer;
                font-weight: bold;
            }
            #coord-popup .close-btn:hover {
                color: #e74c3c;
            }
        </style>
    </head>
    <body>
        <!-- Loading Screen -->
        <div class="loading-screen" id="loadingScreen">
            <div class="loading-spinner"></div>
            <div class="loading-text">Loading Tour 360Â°</div>
            <div class="loading-subtext">Please wait while we prepare your virtual tour...</div>
        </div>
        
        <%
        // Load tour data
        String villageIdStr = request.getParameter("villageID");
        int villageId = 1; // Default
        if (villageIdStr != null && !villageIdStr.isEmpty()) {
            try {
                villageId = Integer.parseInt(villageIdStr);
            } catch (NumberFormatException e) {
                // Keep default value
            }
        }
        
        TourService tourService = new TourService();
        ProductService productService = new ProductService();
        Gson gson = new Gson();
        
        // Get tour data
        Tour defaultTour = tourService.getDefaultTourByVillage(villageId);
        Map<String, Object> tourInfo = new HashMap<>();
        List<Product> products = new ArrayList<>();
        
        // Initialize JSON variables
        String panoramasJson = "[]";
        String navigationPointsJson = "[]";
        String hotspotsJson = "[]";
        String tourSettingsJson = "[]";
        
        if (defaultTour != null) {
            tourInfo = tourService.getCompleteTourInfo(defaultTour.getTourID());
            products = productService.getActiveProductsBySellID(villageId);
            
            // Set data to request attributes
            request.setAttribute("tour", defaultTour);
            request.setAttribute("tourInfo", tourInfo);
            request.setAttribute("panoramas", tourInfo.get("panoramas"));
            request.setAttribute("navigationPoints", tourInfo.get("navigationPoints"));
            request.setAttribute("hotspots", tourInfo.get("hotspots"));
            request.setAttribute("tourSettings", tourInfo.get("settings"));
            request.setAttribute("products", products);
            
            // Convert to JSON for JavaScript
            if (tourInfo.get("panoramas") != null) {
                panoramasJson = gson.toJson(tourInfo.get("panoramas"));
            }
            if (tourInfo.get("navigationPoints") != null) {
                navigationPointsJson = gson.toJson(tourInfo.get("navigationPoints"));
            }
            if (tourInfo.get("hotspots") != null) {
                hotspotsJson = gson.toJson(tourInfo.get("hotspots"));
            }
            if (tourInfo.get("settings") != null) {
                tourSettingsJson = gson.toJson(tourInfo.get("settings"));
            }
        }
        %>
        
        <div id="hotspot" style="display:none;">â</div>
        
        <!-- Back to Home Button -->
        <button class="back-to-home-btn" onclick="goToHome()">
            <i class="fa fa-home"></i>
            Back to Home
        </button>
        
        <!-- Toast Messages -->
        <div class="success-message" id="successMessage" style="display:none;"><i class="fa fa-circle-check"></i> ÄÃ£ thÃªm vÃ o giá» hÃ ng thÃ nh cÃ´ng!</div>
        <div class="success-message" id="errorMessage" style="background: #e74c3c; z-index: 1003; display:none;"></div>

        <!-- Shop Popup -->
        <div class="shop-overlay" id="shopOverlay"></div>
        <div class="shop-popup" id="shopPopup">
            <div class="shop-header">
                <h2>Village Shop</h2>
                <span class="shop-close" onclick="closeShop()"><i class="fa fa-times"></i></span>
            </div>
            <div class="shop-products">
                <%-- Debug output --%>
                <c:if test="${empty products}">
                    <p style="color: red;">No products available</p>
                </c:if>
                <c:if test="${not empty products}">
                    <p style="color: green;">Number of products: ${products.size()}</p>
                </c:if>
                
                <c:forEach var="product" items="${products}">
                    <div class="product-card">
                        <img src="${product.mainImageUrl}" class="product-image" alt="${product.name}">
                        <div class="product-title">${product.name}</div>
                        <div class="product-price">${product.price}â«</div>
                        <button class="add-to-cart-btn"
                            data-id="${product.pid}"
                            data-title="${fn:escapeXml(product.name)}"
                            data-price="${product.price}"
                            data-image="${fn:escapeXml(product.mainImageUrl)}"
                            onclick="addToCart(this)">
                            <i class="fa fa-cart-shopping"></i> Add to Cart
                        </button>
                    </div>
                </c:forEach>
            </div>
            <button class="view-cart-btn" onclick="viewCart()">
                <i class="fa fa-bag-shopping"></i> View Cart on Website
            </button>
        </div>

        <!-- Hidden inputs for JSON data -->
        <input type="hidden" id="panoramasJson" value='<%= panoramasJson.replace("'", "\\'") %>'>
        <input type="hidden" id="navigationPointsJson" value='<%= navigationPointsJson.replace("'", "\\'") %>'>
        <input type="hidden" id="hotspotsJson" value='<%= hotspotsJson.replace("'", "\\'") %>'>
        <input type="hidden" id="tourSettingsJson" value='<%= tourSettingsJson.replace("'", "\\'") %>'>

        <!-- Marzipano viewer container -->
        <div id="pano" style="width: 100vw; height: 100vh;"></div>
        <!-- NÃºt báº­t/táº¯t láº¥y tá»a Äá» -->
        <button id="toggle-coord-btn" type="button">Báº­t láº¥y tá»a Äá»</button>
        <!-- Popup hiá»n thá» tá»a Äá» -->
        <div id="coord-popup">
            <button class="close-btn" onclick="document.getElementById('coord-popup').style.display='none'">Ã</button>
            <div id="coord-value">yaw: 0, pitch: 0</div>
        </div>

        <script>
        // Dá»¯ liá»u tour tá»« server - Sá»­ dá»¥ng hidden inputs
        var panoramasData = [];
        var navigationPointsData = [];
        var hotspotsData = [];
        var tourSettingsData = [];
        
        // Parse JSON data from hidden inputs
        try {
            var panoramasJsonElement = document.getElementById('panoramasJson');
            if (panoramasJsonElement && panoramasJsonElement.value) {
                panoramasData = JSON.parse(panoramasJsonElement.value);
            }
        } catch (e) {
            console.error('Error parsing panoramas JSON:', e);
        }
        
        try {
            var navigationPointsJsonElement = document.getElementById('navigationPointsJson');
            if (navigationPointsJsonElement && navigationPointsJsonElement.value) {
                navigationPointsData = JSON.parse(navigationPointsJsonElement.value);
            }
        } catch (e) {
            console.error('Error parsing navigation points JSON:', e);
        }
        
        try {
            var hotspotsJsonElement = document.getElementById('hotspotsJson');
            if (hotspotsJsonElement && hotspotsJsonElement.value) {
                hotspotsData = JSON.parse(hotspotsJsonElement.value);
            }
        } catch (e) {
            console.error('Error parsing hotspots JSON:', e);
        }
        
        try {
            var tourSettingsJsonElement = document.getElementById('tourSettingsJson');
            if (tourSettingsJsonElement && tourSettingsJsonElement.value) {
                tourSettingsData = JSON.parse(tourSettingsJsonElement.value);
            }
        } catch (e) {
            console.error('Error parsing tour settings JSON:', e);
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // Láº¥y dá»¯ liá»u tour tá»« server
            var tourData = {
                panoramas: panoramasData,
                navigationPoints: navigationPointsData,
                hotspots: hotspotsData,
                tourSettings: tourSettingsData
            };
            
            console.log('[DEBUG] Tour data loaded:', tourData);
            
            // Táº¡o danh sÃ¡ch panorama tá»« dá»¯ liá»u server
            var panoramas = {};
            var panoramaList = [];
            if (tourData.panoramas && tourData.panoramas.length > 0) {
                tourData.panoramas.forEach(function(panorama, index) {
                    panoramas[panorama.panoramaID] = panorama.imageUrl;
                    panoramaList.push(panorama);
                });
            } else {
                // Fallback náº¿u khÃ´ng cÃ³ dá»¯ liá»u tá»« server
                panoramas = {
                    1: "/CraftVillage/hinhanh/panorama/1_1.jpg",
                    2: "/CraftVillage/hinhanh/panorama/1_2.jpg"
                };
            }
            
            var currentPanorama = panoramaList.length > 0 ? panoramaList[0].panoramaID : 1;
            var viewer = new Marzipano.Viewer(document.getElementById('pano'));
            var sceneMap = {};

            function createScene(panoramaId) {
                var imageUrl = panoramas[panoramaId];
                if (!imageUrl) {
                    console.error('[ERROR] No image URL for panorama ID:', panoramaId);
                    return null;
                }
                
                var source = Marzipano.ImageUrlSource.fromString(imageUrl);
                var geometry = new Marzipano.EquirectGeometry([{ width: 1536 }]);
                var limiter = Marzipano.RectilinearView.limit.traditional(1024, 120*Math.PI/180);
                var view = new Marzipano.RectilinearView(null, limiter);
                var scene = viewer.createScene({
                    source: source,
                    geometry: geometry,
                    view: view,
                    pinFirstLevel: true
                });
                sceneMap[panoramaId] = scene;
                return scene;
            }

            // Táº¡o scene cho táº¥t cáº£ panorama
            panoramaList.forEach(function(panorama) {
                createScene(panorama.panoramaID);
            });

            // ThÃªm navigation points
            if (tourData.navigationPoints && tourData.navigationPoints.length > 0) {
                tourData.navigationPoints.forEach(function(navPoint) {
                    var scene = sceneMap[navPoint.panoramaID];
                    if (scene) {
                        var hotspot = document.createElement('div');
                        hotspot.className = 'hotspot';
                        
                        // Táº¡o icon vá»i fallback
                        var iconHtml = 'â'; // Fallback máº·c Äá»nh
                        if (navPoint.iconClass) {
                            if (navPoint.iconClass.includes('arrow-right')) {
                                iconHtml = '<i class="fa fa-arrow-right" aria-hidden="true"></i>';
                            } else if (navPoint.iconClass.includes('arrow-left')) {
                                iconHtml = '<i class="fa fa-arrow-left" aria-hidden="true"></i>';
                            } else {
                                iconHtml = '<i class="' + navPoint.iconClass + '" aria-hidden="true"></i>';
                            }
                        }
                        hotspot.innerHTML = iconHtml;
                        
                        hotspot.title = navPoint.description || 'Chuyá»n cáº£nh';
                        hotspot.onclick = function(e) {
                            e.stopPropagation();
                            switchToScene(navPoint.targetPanoramaID);
                        };
                        
                        // Sá»­ dá»¥ng tá»a Äá» cá» Äá»nh Äá» trÃ¡nh di chuyá»n khi xoay
                        var yaw = navPoint.yaw || 0;
                        var pitch = navPoint.pitch || 0;
                        
                        // Náº¿u khÃ´ng cÃ³ tá»a Äá», Äáº·t á» trung tÃ¢m
                        if (!navPoint.yaw && !navPoint.pitch) {
                            yaw = 0; // Trung tÃ¢m theo chiá»u ngang
                            pitch = 0; // Trung tÃ¢m theo chiá»u dá»c
                        }
                        
                        // Äáº£m báº£o tá»a Äá» trong khoáº£ng há»£p lá»
                        yaw = yaw % (2 * Math.PI);
                        pitch = Math.max(-Math.PI/2, Math.min(Math.PI/2, pitch));
                        
                        // Táº¡o hotspot vá»i tá»a Äá» cá» Äá»nh
                        var hotspotData = {
                            yaw: yaw,
                            pitch: pitch,
                            // ThÃªm thuá»c tÃ­nh Äá» cá» Äá»nh vá» trÃ­
                            perspective: 'equirectangular'
                        };
                        
                        scene.hotspotContainer().createHotspot(hotspot, hotspotData);
                    }
                });
            }

            // ThÃªm hotspots
            if (tourData.hotspots && tourData.hotspots.length > 0) {
                tourData.hotspots.forEach(function(hotspot) {
                    var scene = sceneMap[hotspot.panoramaID];
                    if (scene) {
                        var hotspotElement = document.createElement('div');
                        hotspotElement.className = 'hotspot';
                        
                        // Táº¡o icon vá»i fallback
                        var iconHtml = 'â¹'; // Fallback máº·c Äá»nh
                        if (hotspot.iconClass) {
                            if (hotspot.hotspotType === 'shop') {
                                iconHtml = '<i class="fa fa-shopping-cart" aria-hidden="true"></i>';
                            } else if (hotspot.iconClass.includes('info')) {
                                iconHtml = '<i class="fa fa-info-circle" aria-hidden="true"></i>';
                            } else {
                                iconHtml = '<i class="' + hotspot.iconClass + '" aria-hidden="true"></i>';
                            }
                        } else if (hotspot.hotspotType === 'shop') {
                            iconHtml = '<i class="fa fa-shopping-cart" aria-hidden="true"></i>';
                        }
                        
                        hotspotElement.innerHTML = iconHtml;
                        hotspotElement.title = hotspot.title || hotspot.description || 'ThÃ´ng tin';
                        hotspotElement.onclick = function(e) {
                            e.stopPropagation();
                            if (hotspot.hotspotType === 'shop') {
                                openShop();
                            } else if (hotspot.hotspotType === 'navigation') {
                                // TÃ¬m navigation point tÆ°Æ¡ng á»©ng Äá» chuyá»n cáº£nh
                                var navPoint = tourData.navigationPoints.find(function(np) {
                                    return np.panoramaID === hotspot.panoramaID && 
                                           np.description === hotspot.description;
                                });
                                if (navPoint) {
                                    console.log('[DEBUG] Switching to panorama:', navPoint.targetPanoramaID);
                                    switchToScene(navPoint.targetPanoramaID);
                                } else {
                                    console.error('[ERROR] No navigation point found for hotspot:', hotspot);
                                    alert('KhÃ´ng tÃ¬m tháº¥y Äiá»m chuyá»n cáº£nh');
                                }
                            } else {
                                // Hiá»n thá» thÃ´ng tin
                                alert(hotspot.description || hotspot.title);
                            }
                        };
                        
                        // Sá»­ dá»¥ng tá»a Äá» cá» Äá»nh Äá» trÃ¡nh di chuyá»n khi xoay
                        var yaw = hotspot.yaw || 0;
                        var pitch = hotspot.pitch || 0;
                        
                        // Náº¿u khÃ´ng cÃ³ tá»a Äá», Äáº·t á» trung tÃ¢m
                        if (!hotspot.yaw && !hotspot.pitch) {
                            yaw = 0; // Trung tÃ¢m theo chiá»u ngang
                            pitch = 0; // Trung tÃ¢m theo chiá»u dá»c
                        }
                        
                        // Äáº£m báº£o tá»a Äá» trong khoáº£ng há»£p lá»
                        yaw = yaw % (2 * Math.PI);
                        pitch = Math.max(-Math.PI/2, Math.min(Math.PI/2, pitch));
                        
                        // Táº¡o hotspot vá»i tá»a Äá» cá» Äá»nh
                        var hotspotData = {
                            yaw: yaw,
                            pitch: pitch,
                            // ThÃªm thuá»c tÃ­nh Äá» cá» Äá»nh vá» trÃ­
                            perspective: 'equirectangular'
                        };
                        
                        scene.hotspotContainer().createHotspot(hotspotElement, hotspotData);
                    }
                });
            }

            // HÃ m chuyá»n scene
            function switchToScene(panoramaId) {
                currentPanorama = panoramaId;
                var scene = sceneMap[panoramaId];
                if (scene) {
                    scene.switchTo();
                } else {
                    console.error('[ERROR] Scene not found for panorama ID:', panoramaId);
                }
            }

            // Hiá»n thá» scene Äáº§u tiÃªn (start point)
            var startPanorama = panoramaList.find(function(p) { return p.isStartPoint; });
            if (startPanorama) {
                switchToScene(startPanorama.panoramaID);
            } else if (panoramaList.length > 0) {
                switchToScene(panoramaList[0].panoramaID);
            }
            
            // áº¨n loading screen sau khi tour ÄÃ£ sáºµn sÃ ng
            setTimeout(function() {
                hideLoadingScreen();
            }, 1000);

            // ThÃªm tÃ­nh nÄng láº¥y tá»a Äá»
            var coordMode = false;
            var panoDom = viewer.stage().domElement();
            var holdTimeout = null;
            var isHolding = false;

            // Toggle coordinate mode
            document.getElementById('toggle-coord-btn').addEventListener('click', function() {
                coordMode = !coordMode;
                this.textContent = coordMode ? 'Táº¯t láº¥y tá»a Äá»' : 'Báº­t láº¥y tá»a Äá»';
                this.style.background = coordMode ? '#e74c3c' : '#4CAF50';
            });

            // Xá»­ lÃ½ giá»¯ chuá»t trÃ¡i 5s Äá» láº¥y tá»a Äá»
            panoDom.addEventListener('mousedown', function(event) {
                if (!coordMode) return;
                if (event.button !== 0) return; // Chá» xá»­ lÃ½ chuá»t trÃ¡i
                if (event.target.classList.contains('hotspot')) return;
                isHolding = true;
                var rect = panoDom.getBoundingClientRect();
                var x = event.clientX - rect.left;
                var y = event.clientY - rect.top;
                holdTimeout = setTimeout(function() {
                    if (isHolding) {
                        var coords = sceneMap[currentPanorama].view().screenToCoordinates({ x: x, y: y });
                        if (coords) {
                            var popup = document.getElementById('coord-popup');
                            var valueDiv = document.getElementById('coord-value');
                            valueDiv.textContent = 'yaw: ' + coords.yaw.toFixed(2) + ', pitch: ' + coords.pitch.toFixed(2);
                            popup.style.display = 'block';
                            console.log('Hold: Hiá»n popup tá»a Äá»', coords);
                        }
                    }
                }, 5000); // 5 giÃ¢y
            });

            panoDom.addEventListener('mouseup', function(event) {
                isHolding = false;
                if (holdTimeout) {
                    clearTimeout(holdTimeout);
                    holdTimeout = null;
                }
            });

            panoDom.addEventListener('mouseleave', function(event) {
                isHolding = false;
                if (holdTimeout) {
                    clearTimeout(holdTimeout);
                    holdTimeout = null;
                }
            });

            // Xá»­ lÃ½ click bÃ¬nh thÆ°á»ng (single click)
            panoDom.addEventListener('click', function(event) {
                if (!coordMode) return;
                if (event.button !== 0) return; // Chá» xá»­ lÃ½ chuá»t trÃ¡i
                if (event.target.classList.contains('hotspot')) return;
                // Náº¿u vá»«a hold thÃ¬ khÃ´ng xá»­ lÃ½ click
                if (isHolding) return;
                // Náº¿u lÃ  double click thÃ¬ bá» qua
                if (event.detail > 1) return;
                var rect = panoDom.getBoundingClientRect();
                var x = event.clientX - rect.left;
                var y = event.clientY - rect.top;
                var coords = sceneMap[currentPanorama].view().screenToCoordinates({ x: x, y: y });
                if (coords) {
                    var popup = document.getElementById('coord-popup');
                    var valueDiv = document.getElementById('coord-value');
                    valueDiv.textContent = 'yaw: ' + coords.yaw.toFixed(2) + ', pitch: ' + coords.pitch.toFixed(2);
                    popup.style.display = 'block';
                    console.log('Click: Hiá»n popup tá»a Äá»', coords);
                }
            });
        });

        // ThÃªm hÃ m má»/ÄÃ³ng shop
        function openShop() {
            document.getElementById('shopPopup').classList.add('active');
            document.getElementById('shopOverlay').classList.add('active');
        }

        function closeShop() {
            document.getElementById('shopPopup').classList.remove('active');
            document.getElementById('shopOverlay').classList.remove('active');
        }

        function addToCart(btn) {
            const id = btn.getAttribute('data-id');
            
            fetch("cart?action=add&id=" + id + "&quantity=1", {
                method: "POST",
                credentials: 'same-origin'
            })
            .then(async response => {
                let data = {};
                let text = await response.text();
                try { data = JSON.parse(text); } catch (e) {}
                // Kiá»m tra náº¿u response chá»©a 'login' (giá»ng Detail.jsp)
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
                console.error("Lá»i:", error);
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

        function viewCart() {
            // Chuyá»n hÆ°á»ng Äáº¿n trang giá» hÃ ng cá»§a website chÃ­nh
            window.open('http://localhost:8080/CraftVillage/cart', '_blank');
        }
        
        function goToHome() {
            // Chuyá»n vá» trang home
            window.location.href = 'home';
        }
        
        function hideLoadingScreen() {
            const loadingScreen = document.getElementById('loadingScreen');
            if (loadingScreen) {
                loadingScreen.classList.add('hidden');
                // XÃ³a loading screen khá»i DOM sau khi animation hoÃ n thÃ nh
                setTimeout(function() {
                    loadingScreen.remove();
                }, 500);
            }
        }
        </script>
    </body>
</html> 