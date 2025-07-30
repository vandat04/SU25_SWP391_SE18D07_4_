<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Khai báo các biến để tránh lỗi JSP compilation
    Boolean generateForProduct = (Boolean) request.getAttribute("generateForProduct");
    Boolean uploadForProduct = (Boolean) request.getAttribute("uploadForProduct");
    String productId = (String) request.getAttribute("productId");
    String productName = (String) request.getAttribute("productName");
    String message = (String) request.getAttribute("message");
    Boolean productUpdated = (Boolean) request.getAttribute("productUpdated");
    String error = (String) request.getAttribute("error");
    String warning = (String) request.getAttribute("warning");
    String modelUrl = (String) request.getAttribute("modelUrl");
    Boolean demoMode = (Boolean) request.getAttribute("demoMode");
    
    // API-related variables
    String apiKeyTestResult = (String) request.getAttribute("apiKeyTestResult");
    String currentApiKey = (String) request.getAttribute("currentApiKey");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tạo mô hình 3D từ hình ảnh</title>
    <!-- Tích hợp Tailwind CSS thông qua CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // Hàm JavaScript để validation và chuyển tab
        function validateFiles(input) {
            const files = input.files;
            if (files.length !== 1) {
                alert('Vui lòng chọn 1 hình ảnh!');
                input.value = '';
                return;
            }
            
            // Hiển thị ảnh xem trước
            const file = files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('imagePreview');
                    if (preview) {
                        preview.src = e.target.result;
                        preview.classList.remove('hidden');
                    }
                };
                reader.readAsDataURL(file);
            }
        }

        function validateModelFile(input) {
            const files = input.files;
            if (files.length !== 1) {
                alert('Vui lòng chọn 1 file 3D model!');
                input.value = '';
                return;
            }
            
            const file = files[0];
            const maxSize = 10 * 1024 * 1024; // 10MB
            
            if (file.size > maxSize) {
                alert('File quá lớn! Kích thước tối đa là 10MB.');
                input.value = '';
                return;
            }
            
            const allowedTypes = ['.glb', '.gltf'];
            const fileName = file.name.toLowerCase();
            const isValidType = allowedTypes.some(type => fileName.endsWith(type));
            
            if (!isValidType) {
                alert('Chỉ chấp nhận file GLB hoặc GLTF!');
                input.value = '';
                return;
            }
            
            // Hiển thị thông tin file
            const fileInfo = document.getElementById('fileInfo');
            if (fileInfo) {
                const fileSizeMB = (file.size / 1024 / 1024).toFixed(2);
                fileInfo.innerHTML = '<div class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg mt-4">' +
                    '<strong>File đã chọn:</strong> ' + file.name + '<br>' +
                    '<strong>Kích thước:</strong> ' + fileSizeMB + ' MB' +
                    '</div>';
                fileInfo.classList.remove('hidden');
            }
        }
        
        // Chức năng chuyển đổi tab
        function switchTab(tabName) {
            document.getElementById('upload-content').classList.add('hidden');
            document.getElementById('generate-content').classList.add('hidden');
            document.getElementById(tabName + '-content').classList.remove('hidden');
            
            document.querySelectorAll('.tab-button').forEach(tab => {
                tab.classList.remove('bg-blue-600', 'text-white');
                tab.classList.add('bg-gray-100', 'text-gray-700', 'hover:bg-gray-200');
            });
            
            document.getElementById(tabName + '-tab').classList.add('bg-blue-600', 'text-white');
            document.getElementById(tabName + '-tab').classList.remove('bg-gray-100', 'text-gray-700', 'hover:bg-gray-200');
        }
        
        // Hiển thị spinner khi submit form
        window.addEventListener('DOMContentLoaded', function() {
            var forms = document.querySelectorAll('form[enctype="multipart/form-data"]');
            forms.forEach(function(form) {
                form.addEventListener('submit', function() {
                    var spinner = document.getElementById('spinnerOverlay');
                    if (spinner) spinner.classList.remove('hidden');
                });
            });

            // Mặc định chọn tab dựa trên hành động
            <% if (uploadForProduct != null && uploadForProduct) { %>
                switchTab('upload');
            <% } else { %>
                switchTab('generate');
            <% } %>
        });
    </script>
</head>
<body class="bg-gray-100 min-h-screen">
    <!-- Spinner Overlay -->
    <div id="spinnerOverlay" class="hidden fixed inset-0 bg-white bg-opacity-80 z-50 flex flex-col items-center justify-center">
        <div class="animate-spin rounded-full h-16 w-16 border-b-4 border-blue-600"></div>
        <div class="mt-6 text-lg font-semibold text-blue-700">Đang xử lý, vui lòng chờ...</div>
        <p class="text-gray-600 mt-2">Quá trình tạo mô hình 3D có thể mất vài phút.</p>
    </div>

    <!-- Main Container -->
    <div class="max-w-6xl mx-auto p-4 sm:p-6">
        <!-- Header -->
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h1 class="text-3xl font-bold text-gray-800 mb-2">🎨 Tạo hoặc Upload mô hình 3D</h1>
            <p class="text-gray-600">Sử dụng AI Meshy để tạo mới hoặc upload mô hình 3D có sẵn cho sản phẩm.</p>
        </div>
        
        <!-- Nút quay lại -->
        <% if ((generateForProduct != null && generateForProduct) || (uploadForProduct != null && uploadForProduct)) { %>
        <div class="mb-6">
            <a href="admin-3d-product-management" class="inline-flex items-center px-4 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition-colors duration-200 shadow">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                Quay lại Quản lý Sản phẩm 3D
            </a>
        </div>
        <% } %>
        
        <!-- Thông tin sản phẩm -->
        <% if (productName != null) { %>
            <div class="bg-blue-50 border-l-4 border-blue-500 p-6 rounded-r-lg mb-6 shadow">
                <h3 class="text-xl font-semibold text-blue-800 mb-3">📦 Thao tác cho sản phẩm</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <p class="text-sm text-gray-600">Product ID</p>
                        <p class="font-mono text-gray-800"><%= productId %></p>
                    </div>
                    <div>
                        <p class="text-sm text-gray-600">Tên sản phẩm</p>
                        <p class="font-semibold text-gray-800"><%= productName %></p>
                    </div>
                </div>
            </div>
        <% } %>
        
        <!-- Trạng thái API -->
        <% if (apiKeyTestResult != null) { %>
            <div class="bg-yellow-50 border-2 border-yellow-400 rounded-lg shadow-md p-6 mb-6">
                <h3 class="text-xl font-semibold text-yellow-800 mb-4">⚠️ Kết quả chẩn đoán API</h3>
                <div class="mb-4">
                    <p class="text-sm text-gray-600">Trạng thái</p>
                    <p class="font-semibold text-yellow-700">🔧 Meshy API có thể đã thay đổi cấu trúc.</p>
                </div>
                <div class="bg-yellow-100 border border-yellow-300 text-yellow-900 px-4 py-3 rounded-lg mb-4">
                    <strong>📢 THÔNG BÁO:</strong>
                    <p class="mt-1">Endpoint Meshy API v1 không phản hồi. Chức năng tạo 3D bằng AI có thể không hoạt động.</p>
                    <p class="mt-2"><strong>Giải pháp:</strong> Upload file GLB có sẵn hoặc sử dụng Chế độ Demo.</p>
                </div>
                <div class="bg-gray-900 text-green-400 p-4 rounded-lg font-mono text-xs max-h-60 overflow-y-auto whitespace-pre-wrap">
                    <%= apiKeyTestResult %>
                </div>
            </div>
        <% } %>

        <!-- Giao diện Tab -->
        <div class="bg-white rounded-lg shadow-md">
            <div class="border-b border-gray-200">
                <nav class="flex -mb-px" aria-label="Tabs">
                    <button id="generate-tab" onclick="switchTab('generate')" class="tab-button w-1/2 text-center py-4 px-1 border-b-2 font-medium text-sm">
                        🚀 Tạo 3D từ ảnh (AI)
                    </button>
                    <button id="upload-tab" onclick="switchTab('upload')" class="tab-button w-1/2 text-center py-4 px-1 border-b-2 font-medium text-sm">
                        📤 Upload File 3D
                    </button>
                </nav>
            </div>
            
            <div class="p-6">
                <!-- Tab Tạo 3D từ ảnh -->
                <div id="generate-content" class="tab-content hidden">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Tạo mô hình 3D bằng AI Meshy</h3>
                    <p class="text-gray-600 mb-6">Upload một hình ảnh rõ nét để AI tự động tạo ra mô hình 3D tương ứng.</p>
                    <form action="ImageTo3DServlet" method="post" enctype="multipart/form-data">
                        <% if (productName != null) { %>
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <input type="hidden" name="action" value="generateForProduct">
                        <% } %>
                        <div class="border-2 border-dashed border-green-300 rounded-lg p-6 text-center hover:border-green-500 transition-colors duration-200 bg-green-50">
                            <input type="file" name="images" accept="image/*" required onchange="validateFiles(this)" class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-100 file:text-green-700 hover:file:bg-green-200 cursor-pointer">
                            <p class="mt-2 text-gray-600 text-sm">Chọn 1 ảnh (JPG, PNG) - Nền đơn giản cho kết quả tốt nhất.</p>
                        </div>
                        <img id="imagePreview" class="hidden max-w-xs max-h-48 mx-auto mt-4 rounded-lg shadow-md border">
                        <div class="mt-6 text-center">
                            <button type="submit" class="inline-flex items-center px-8 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition-colors duration-200 text-lg shadow-md">
                                🚀 Bắt đầu tạo 3D
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Tab Upload File -->
                <div id="upload-content" class="tab-content hidden">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Upload File Model 3D có sẵn</h3>
                    <p class="text-gray-600 mb-6">Nếu bạn đã có sẵn file .GLB hoặc .GLTF, hãy upload trực tiếp tại đây.</p>
                    <form action="ImageTo3DServlet" method="post" enctype="multipart/form-data">
                        <% if (productName != null) { %>
                            <input type="hidden" name="productId" value="<%= productId %>">
                        <% } %>
                        <input type="hidden" name="action" value="uploadForProduct">
                        <div class="border-2 border-dashed border-blue-300 rounded-lg p-6 text-center hover:border-blue-500 transition-colors duration-200 bg-blue-50">
                            <input type="file" name="modelFile" accept=".glb,.gltf" required onchange="validateModelFile(this)" class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-100 file:text-blue-700 hover:file:bg-blue-200 cursor-pointer">
                            <p class="mt-2 text-gray-600 text-sm">Chọn file 3D (GLB, GLTF) - Tối đa 50MB.</p>
                        </div>
                        <div id="fileInfo" class="hidden"></div>
                        <div class="mt-6 text-center">
                            <button type="submit" class="inline-flex items-center px-8 py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition-colors duration-200 text-lg shadow-md">
                                📤 Upload Model
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Vùng hiển thị thông báo -->
        <div class="mt-6 space-y-4">
            <% if (error != null) { %>
                <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-r-lg shadow" role="alert">
                    <p class="font-bold">❌ Lỗi</p>
                    <p class="whitespace-pre-wrap"><%= error %></p>
                </div>
            <% } %>
            <% if (warning != null) { %>
                <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 rounded-r-lg shadow" role="alert">
                    <p class="font-bold">⚠️ Cảnh báo</p>
                    <p><%= warning %></p>
                </div>
            <% } %>
            <% if (message != null) { %>
                <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded-r-lg shadow" role="alert">
                    <p class="font-bold">✅ Thành công</p>
                    <p><%= message %></p>
                    <% if (productUpdated != null && productUpdated) { %>
                        <a href="admin-3d-product-management" class="mt-3 inline-block bg-green-600 text-white font-bold py-2 px-4 rounded hover:bg-green-700">
                            Xem lại trong Quản lý
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
        
        <!-- Kết quả mô hình 3D -->
        <% if (modelUrl != null) { %>
            <div class="bg-white rounded-lg shadow-md p-6 mt-6">
                <h3 class="text-2xl font-bold text-gray-800 mb-4">🎨 Kết quả Mô hình 3D</h3>
                <div class="bg-gray-200 rounded-lg p-2 mb-4 border">
                    <model-viewer src="<%= modelUrl %>" 
                                 auto-rotate 
                                 camera-controls 
                                 shadow-intensity="1"
                                 environment-image="neutral"
                                 class="w-full h-96 rounded-lg">
                        <div class="text-center text-gray-600 py-8">Đang tải mô hình 3D...</div>
                    </model-viewer>
                </div>
                <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
                <div class="text-center">
                    <a href="<%= modelUrl %>" download="generated_model.glb" class="inline-flex items-center px-6 py-3 bg-gray-800 text-white font-semibold rounded-lg hover:bg-black transition-colors duration-200 shadow-md">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                        Tải xuống file .glb
                    </a>
                </div>
            </div>
        <% } %>
        
        <!-- Thông tin kỹ thuật -->
        <div class="bg-white rounded-lg shadow-md p-6 mt-6">
            <h4 class="text-lg font-semibold text-gray-800 mb-4">ℹ️ Thông tin kỹ thuật</h4>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4 text-center">
                <div class="bg-gray-50 p-3 rounded-lg border">
                    <p class="text-sm text-gray-600">Framework</p>
                    <p class="font-semibold text-gray-800">Java Servlet/JSP</p>
                </div>
                <div class="bg-gray-50 p-3 rounded-lg border">
                    <p class="text-sm text-gray-600">3D Viewer</p>
                    <p class="font-semibold text-gray-800">Google Model-Viewer</p>
                </div>
                <div class="bg-gray-50 p-3 rounded-lg border">
                    <p class="text-sm text-gray-600">AI Engine</p>
                    <p class="font-semibold text-gray-800">Meshy.ai API</p>
                </div>
                <div class="bg-gray-50 p-3 rounded-lg border">
                    <p class="text-sm text-gray-600">File Format</p>
                    <p class="font-semibold text-gray-800">GLB/GLTF</p>
                </div>
                <div class="bg-gray-50 p-3 rounded-lg border">
                    <p class="text-sm text-gray-600">Styling</p>
                    <p class="font-semibold text-gray-800">Tailwind CSS</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
