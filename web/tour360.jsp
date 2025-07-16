<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Simple 360° Viewer with Hotspot</title>
        <!-- Đảm bảo chỉ dùng script local, không dùng CDN -->
        <script src="js/marzipano.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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

            /* Cart Styles */
            .cart-icon {
                position: fixed;
                top: 20px;
                right: 20px;
                background: #4CAF50;
                color: white;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
                z-index: 1001;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .cart-count {
                background: white;
                color: #4CAF50;
                padding: 2px 8px;
                border-radius: 10px;
                font-weight: bold;
            }

            .cart-popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.3);
                z-index: 1000;
                width: 90%;
                max-width: 600px;
                max-height: 80vh;
                overflow-y: auto;
            }

            .cart-popup.active {
                display: block;
            }

            .cart-items {
                margin: 20px 0;
            }

            .cart-item {
                display: flex;
                align-items: center;
                padding: 10px;
                border-bottom: 1px solid #eee;
            }

            .cart-item-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 4px;
                margin-right: 15px;
            }

            .cart-item-details {
                flex-grow: 1;
            }

            .cart-item-title {
                font-weight: bold;
                margin-bottom: 5px;
            }

            .cart-item-price {
                color: #e44d26;
            }

            .cart-item-quantity {
                display: flex;
                align-items: center;
                gap: 10px;
                margin: 0 20px;
            }

            .quantity-btn {
                background: #f0f0f0;
                border: none;
                width: 25px;
                height: 25px;
                border-radius: 4px;
                cursor: pointer;
            }

            .remove-btn {
                color: #ff4444;
                background: none;
                border: none;
                cursor: pointer;
                padding: 5px;
            }

            .cart-total {
                text-align: right;
                font-size: 1.2em;
                font-weight: bold;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 2px solid #eee;
            }

            .checkout-btn {
                background: #4CAF50;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                float: right;
                margin-top: 10px;
            }

            .checkout-btn:hover {
                background: #45a049;
            }

            /* Hotspot style for Marzipano */
            .hotspot {
                position: absolute;
                width: 40px; height: 40px;
                background: rgba(255,165,0,0.8);
                border-radius: 50%;
                display: flex; align-items: center; justify-content: center;
                font-size: 24px; color: #fff; font-weight: bold;
                border: 2px solid #fff;
                cursor: pointer;
                z-index: 10;
                transition: background 0.2s;
            }
            .hotspot:hover { background: orange; }
            

            /* Popup hiển thị tọa độ */
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
        <div id="hotspot" style="display:none;">→</div>
        
        <!-- Success Message -->
        <div class="success-message" id="successMessage">
            <i class="fa fa-circle-check"></i> Added to cart successfully!
        </div>


        
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
                        <div class="product-price">${product.price}₫</div>
                        <button class="add-to-cart-btn"
                            data-id="${product.pid}"
                            data-title="${fn:escapeXml(product.name)}"
                            data-price="${product.price}"
                            data-image="${fn:escapeXml(product.mainImageUrl)}"
                            onclick="addToCartFromBtn(this)">
                            <i class="fa fa-cart-shopping"></i> Add to Cart
                        </button>
                    </div>
                </c:forEach>
            </div>
            <button class="view-cart-btn" onclick="viewCart()">
                <i class="fa fa-bag-shopping"></i> View Cart on Website
            </button>
        </div>

        <!-- Marzipano viewer container -->
        <div id="pano" style="width: 100vw; height: 100vh;"></div>
        <!-- Nút bật/tắt lấy tọa độ -->
        <button id="toggle-coord-btn" type="button">Bật lấy tọa độ</button>
        <!-- Popup hiển thị tọa độ -->
        <div id="coord-popup">
            <button class="close-btn" onclick="document.getElementById('coord-popup').style.display='none'">×</button>
            <div id="coord-value">yaw: 0, pitch: 0</div>
        </div>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Danh sách panorama
            var panoramas = {
                1: "/CraftVillage/hinhanh/panorama/1_1.jpg",
                2: "/CraftVillage/hinhanh/panorama/1_2.jpg"
            };
            var currentPanorama = 1;
            var viewer = new Marzipano.Viewer(document.getElementById('pano'));
            var sceneMap = {};

            function createScene(num) {
                var source = Marzipano.ImageUrlSource.fromString(panoramas[num]);
                var geometry = new Marzipano.EquirectGeometry([{ width: 1536 }]);
                var limiter = Marzipano.RectilinearView.limit.traditional(1024, 120*Math.PI/180);
                var view = new Marzipano.RectilinearView(null, limiter);
                var scene = viewer.createScene({
                    source: source,
                    geometry: geometry,
                    view: view,
                    pinFirstLevel: true
                });
                sceneMap[num] = scene;
                return scene;
            }

            // Tạo scene cho cả 2 panorama
            var scene1 = createScene(1);
            var scene2 = createScene(2);

            // Thêm hotspot cho panorama 1
            // Hotspot chuyển cảnh
            var hotspot1 = document.createElement('div');
            hotspot1.className = 'hotspot';
            hotspot1.innerHTML = 'Chuyển cảnh';
            hotspot1.title = 'Chuyển sang cảnh 2';
            hotspot1.onclick = function(e) {
                e.stopPropagation();
                switchToScene(2);
            };
            // Hotspot mở shop
            var hotspot2 = document.createElement('div');
            hotspot2.className = 'hotspot';
            hotspot2.innerHTML = 'Mở shop';
            hotspot2.title = 'Mở cửa hàng';
            hotspot2.onclick = function(e) {
                e.stopPropagation();
                openShop();
            };
            // Thêm hotspot vào scene1 (tọa độ dễ nhìn hơn)
            scene1.hotspotContainer().createHotspot(hotspot1, { yaw: 0.5, pitch: 0 }); // Giữa phía trước
            scene1.hotspotContainer().createHotspot(hotspot2, { yaw: -2, pitch: 0 }); // Sang phải

            // Thêm hotspot cho panorama 2 (quay lại panorama 1)
            var hotspotBack = document.createElement('div');
            hotspotBack.className = 'hotspot';
            hotspotBack.innerHTML = '⬅️';
            hotspotBack.title = 'Quay lại cảnh 1';
            hotspotBack.onclick = function(e) {
                e.stopPropagation();
                switchToScene(1);
            };
            scene2.hotspotContainer().createHotspot(hotspotBack, { yaw: 3.14, pitch: 0 }); // Giữa phía sau

            // Hàm chuyển scene
            function switchToScene(num) {
                currentPanorama = num;
                sceneMap[num].switchTo();
            }

            // Hiển thị scene đầu tiên
            scene1.switchTo();


            var panoDom = viewer.stage().domElement();
            var holdTimeout = null;
            var isHolding = false;

            // Xử lý giữ chuột trái 5s để lấy tọa độ
            panoDom.addEventListener('mousedown', function(event) {
                if (!coordMode) return;
                if (event.button !== 0) return; // Chỉ xử lý chuột trái
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
                            console.log('Hold: Hiện popup tọa độ', coords);
                        }
                    }
                }, 5000); // 5 giây
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

            // Xử lý click bình thường (single click)
            panoDom.addEventListener('click', function(event) {
                if (!coordMode) return;
                if (event.button !== 0) return; // Chỉ xử lý chuột trái
                if (event.target.classList.contains('hotspot')) return;
                // Nếu vừa hold thì không xử lý click
                if (isHolding) return;
                // Nếu là double click thì bỏ qua
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
                    console.log('Click: Hiện popup tọa độ', coords);
                }
            });
        });

        // Lấy villageID từ URL
        function getVillageID() {
            const params = new URLSearchParams(window.location.search);
            return params.get('villageID') || 1;
        }
        const villageID = getVillageID();

        // Danh sách sản phẩm động
        let products = [];

        // Thêm hàm mở/đóng shop
        function openShop() {
            document.getElementById('shopPopup').classList.add('active');
            document.getElementById('shopOverlay').classList.add('active');
        }

        function closeShop() {
            document.getElementById('shopPopup').classList.remove('active');
            document.getElementById('shopOverlay').classList.remove('active');
        }

        // Cart functionality
        let cart = [];

        function toggleCart() {
            const cartPopup = document.getElementById('cartPopup');
            cartPopup.classList.toggle('active');
            document.getElementById('shopOverlay').classList.toggle('active');
        }

        function addToCart(productId, title, price, image) {
            // Gọi API thêm vào giỏ hàng của website chính
            fetch('http://localhost:8080/CraftVillage/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    productId: productId,
                    quantity: 1,
                    price: price,
                    title: title,
                    image: image
                })
            })
            .then(response => {
                if (response.ok) {
                    showSuccessMessage();
                } else {
                    alert('Failed to add to cart. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error adding to cart:', error);
                alert('Error adding to cart. Please try again.');
            });
        }

        function removeFromCart(productId) {
            cart = cart.filter(item => item.id !== productId);
            updateCart();
        }

        function updateQuantity(productId, delta) {
            const item = cart.find(item => item.id === productId);
            if (item) {
                item.quantity += delta;
                if (item.quantity <= 0) {
                    removeFromCart(productId);
                } else {
                    updateCart();
                }
            }
        }

        function updateCart() {
            const cartItems = document.getElementById('cartItems');
            const cartCount = document.getElementById('cartCount');
            const cartTotal = document.getElementById('cartTotal');
            
            // Update cart count
            const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
            cartCount.textContent = totalItems;

            // Update cart items
            cartItems.innerHTML = cart.map(item => `
                <div class="cart-item">
                    <img src="${item.image}" class="cart-item-image" alt="${item.title}">
                    <div class="cart-item-details">
                        <div class="cart-item-title">${item.title}</div>
                        <div class="cart-item-price">$${item.price.toFixed(2)}</div>
                    </div>
                    <div class="cart-item-quantity">
                        <button class="quantity-btn" onclick="updateQuantity(${item.id}, -1)">-</button>
                        <span>${item.quantity}</span>
                        <button class="quantity-btn" onclick="updateQuantity(${item.id}, 1)">+</button>
                    </div>
                    <button class="remove-btn" onclick="removeFromCart(${item.id})"><i class="fa fa-trash"></i></button>
                </div>
            `).join('');

            // Update total
            const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
            cartTotal.textContent = total.toFixed(2);
        }

        function checkout() {
            if (cart.length === 0) {
                alert('Your cart is empty!');
                return;
            }
            alert('Thank you for your purchase! Total: $' + 
                cart.reduce((sum, item) => sum + (item.price * item.quantity), 0).toFixed(2));
            cart = [];
            updateCart();
            toggleCart();
        }

        function showSuccessMessage() {
            const message = document.getElementById('successMessage');
            message.style.display = 'block';
            setTimeout(() => {
                message.style.display = 'none';
            }, 3000);
        }

        function viewCart() {
            // Chuyển hướng đến trang giỏ hàng của website chính
            window.open('http://localhost:8080/CraftVillage/cart', '_blank');
        }

        function addToCartFromBtn(btn) {
            const id = btn.getAttribute('data-id');
            const title = btn.getAttribute('data-title');
            const price = btn.getAttribute('data-price');
            const image = btn.getAttribute('data-image');
            addToCart(id, title, price, image);
        }
        </script>
    </body>
</html> 