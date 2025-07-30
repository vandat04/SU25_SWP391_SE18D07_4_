<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3D Model Viewer - ${param.productName}</title>
    
    <!-- Google Model Viewer -->
    <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .viewer-container {
            position: relative;
            width: 100vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .product-image {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            object-fit: cover;
            border: 2px solid #e0e0e0;
        }
        
        .product-details h2 {
            margin: 0;
            font-size: 1.5rem;
            color: #333;
            font-weight: 600;
        }
        
        .product-details p {
            margin: 5px 0 0 0;
            color: #666;
            font-size: 0.9rem;
        }
        
        .controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .btn-control {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-1px);
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #1e7e34;
            transform: translateY(-1px);
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-1px);
        }
        
        .viewer-main {
            flex: 1;
            position: relative;
            background: #f8f9fa;
        }
        
        .model-viewer-container {
            width: 100%;
            height: 100%;
            position: relative;
        }
        
        model-viewer {
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #f0f0f0 25%, transparent 25%), 
                        linear-gradient(-45deg, #f0f0f0 25%, transparent 25%), 
                        linear-gradient(45deg, transparent 75%, #f0f0f0 75%), 
                        linear-gradient(-45deg, transparent 75%, #f0f0f0 75%);
            background-size: 20px 20px;
            background-position: 0 0, 0 10px, 10px -10px, -10px 0px;
        }
        
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 100;
        }
        
        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #007bff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .error-message {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(220, 53, 69, 0.9);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            max-width: 400px;
        }
        
        .info-panel {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            max-width: 300px;
            z-index: 1000;
        }
        
        .info-panel h4 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.1rem;
        }
        
        .info-panel ul {
            margin: 0;
            padding-left: 20px;
            color: #666;
            font-size: 0.9rem;
        }
        
        .info-panel li {
            margin-bottom: 5px;
        }
        
        .fullscreen-btn {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 1000;
        }
        
        .fullscreen-btn:hover {
            background: rgba(0, 0, 0, 0.9);
            transform: scale(1.1);
        }
        
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 15px;
            }
            
            .controls {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .product-info {
                flex-direction: column;
                text-align: center;
            }
            
            .info-panel {
                position: relative;
                top: auto;
                right: auto;
                margin: 20px;
                max-width: none;
            }
        }
    </style>
</head>
<body>
    <div class="viewer-container">
        <!-- Header -->
        <div class="header">
            <div class="header-content">
                <div class="product-info">
                    <c:if test="${not empty param.productImage}">
                        <img src="${param.productImage}" alt="Product" class="product-image">
                    </c:if>
                    <div class="product-details">
                        <h2>${param.productName}</h2>
                        <p>3D Model Viewer</p>
                    </div>
                </div>
                
                <div class="controls">
                    <button class="btn-control btn-secondary" onclick="resetView()">
                        <i class="bi bi-arrow-clockwise"></i> Reset View
                    </button>
                    <button class="btn-control btn-success" onclick="toggleAutoRotate()">
                        <i class="bi bi-arrow-repeat"></i> Auto Rotate
                    </button>
                    <button class="btn-control btn-primary" onclick="downloadModel()">
                        <i class="bi bi-download"></i> Download
                    </button>
                    <button class="btn-control btn-danger" onclick="closeViewer()">
                        <i class="bi bi-x-lg"></i> Close
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Main Viewer -->
        <div class="viewer-main">
            <div class="model-viewer-container">
                <c:choose>
                    <c:when test="${not empty param.modelUrl}">
                        <model-viewer
                            id="model-viewer"
                            src="${param.modelUrl}"
                            alt="${param.productName}"
                            camera-controls
                            auto-rotate
                            shadow-intensity="1"
                            environment-image="neutral"
                            exposure="1"
                            shadow-softness="0.5"
                            camera-orbit="0deg 75deg 105%"
                            min-camera-orbit="auto auto 50%"
                            max-camera-orbit="auto auto 200%"
                            field-of-view="30deg"
                            min-field-of-view="10deg"
                            max-field-of-view="90deg"
                            interaction-prompt="auto"
                            loading="eager"
                            reveal="auto"
                            ar
                            ar-modes="webxr scene-viewer quick-look"
                            camera-controls
                            touch-action="pan-y"
                            style="width: 100%; height: 100%;">
                            
                            <!-- Loading indicator -->
                            <div class="loading-overlay" id="loading-overlay">
                                <div class="spinner"></div>
                                <p>Loading 3D model...</p>
                            </div>
                            
                            <!-- Error fallback -->
                            <div class="error-message" id="error-message" style="display: none;">
                                <h3><i class="bi bi-exclamation-triangle"></i> Error Loading Model</h3>
                                <p>The 3D model could not be loaded. Please check the model URL or try again later.</p>
                            </div>
                        </model-viewer>
                    </c:when>
                    <c:otherwise>
                        <div class="error-message">
                            <h3><i class="bi bi-exclamation-triangle"></i> No Model Available</h3>
                            <p>No 3D model URL provided. Please check the product configuration.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Info Panel -->
            <div class="info-panel">
                <h4><i class="bi bi-info-circle"></i> Controls</h4>
                <ul>
                    <li><strong>Mouse:</strong> Drag to rotate, scroll to zoom</li>
                    <li><strong>Touch:</strong> Swipe to rotate, pinch to zoom</li>
                    <li><strong>Reset:</strong> Click reset button to return to default view</li>
                    <li><strong>Auto Rotate:</strong> Toggle automatic rotation</li>
                </ul>
            </div>
            
            <!-- Fullscreen Button -->
            <button class="fullscreen-btn" onclick="toggleFullscreen()" title="Toggle Fullscreen">
                <i class="bi bi-fullscreen" id="fullscreen-icon"></i>
            </button>
        </div>
    </div>

    <script>
        let modelViewer;
        let isAutoRotating = true;
        let isFullscreen = false;
        
        document.addEventListener('DOMContentLoaded', function() {
            modelViewer = document.getElementById('model-viewer');
            
            if (modelViewer) {
                // Hide loading overlay when model is loaded
                modelViewer.addEventListener('load', function() {
                    const loadingOverlay = document.getElementById('loading-overlay');
                    if (loadingOverlay) {
                        loadingOverlay.style.display = 'none';
                    }
                });
                
                // Show error message if model fails to load
                modelViewer.addEventListener('error', function() {
                    const loadingOverlay = document.getElementById('loading-overlay');
                    const errorMessage = document.getElementById('error-message');
                    
                    if (loadingOverlay) {
                        loadingOverlay.style.display = 'none';
                    }
                    if (errorMessage) {
                        errorMessage.style.display = 'block';
                    }
                });
                
                // Auto-hide info panel after 5 seconds
                setTimeout(() => {
                    const infoPanel = document.querySelector('.info-panel');
                    if (infoPanel) {
                        infoPanel.style.opacity = '0.3';
                        infoPanel.style.transition = 'opacity 0.5s ease';
                        
                        infoPanel.addEventListener('mouseenter', function() {
                            this.style.opacity = '1';
                        });
                        
                        infoPanel.addEventListener('mouseleave', function() {
                            this.style.opacity = '0.3';
                        });
                    }
                }, 5000);
            }
        });
        
        function resetView() {
            if (modelViewer) {
                modelViewer.cameraOrbit = '0deg 75deg 105%';
                modelViewer.fieldOfView = '30deg';
            }
        }
        
        function toggleAutoRotate() {
            if (modelViewer) {
                isAutoRotating = !isAutoRotating;
                modelViewer.autoRotate = isAutoRotating;
                
                const button = event.target.closest('button');
                if (button) {
                    const icon = button.querySelector('i');
                    if (isAutoRotating) {
                        icon.className = 'bi bi-arrow-repeat';
                        button.style.background = '#28a745';
                    } else {
                        icon.className = 'bi bi-pause';
                        button.style.background = '#6c757d';
                    }
                }
            }
        }
        
        function downloadModel() {
            const modelUrl = '${param.modelUrl}';
            if (modelUrl) {
                const link = document.createElement('a');
                link.href = modelUrl;
                link.download = '${param.productName}_3D_Model.glb';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            } else {
                alert('No model URL available for download.');
            }
        }
        
        function closeViewer() {
            if (window.opener) {
                window.close();
            } else {
                window.history.back();
            }
        }
        
        function toggleFullscreen() {
            const container = document.querySelector('.viewer-container');
            const icon = document.getElementById('fullscreen-icon');
            
            if (!isFullscreen) {
                if (container.requestFullscreen) {
                    container.requestFullscreen();
                } else if (container.webkitRequestFullscreen) {
                    container.webkitRequestFullscreen();
                } else if (container.msRequestFullscreen) {
                    container.msRequestFullscreen();
                }
                icon.className = 'bi bi-fullscreen-exit';
                isFullscreen = true;
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                } else if (document.webkitExitFullscreen) {
                    document.webkitExitFullscreen();
                } else if (document.msExitFullscreen) {
                    document.msExitFullscreen();
                }
                icon.className = 'bi bi-fullscreen';
                isFullscreen = false;
            }
        }
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(event) {
            switch(event.key) {
                case 'Escape':
                    if (isFullscreen) {
                        toggleFullscreen();
                    } else {
                        closeViewer();
                    }
                    break;
                case 'r':
                case 'R':
                    resetView();
                    break;
                case 'a':
                case 'A':
                    toggleAutoRotate();
                    break;
                case 'd':
                case 'D':
                    downloadModel();
                    break;
                case 'f':
                case 'F':
                    toggleFullscreen();
                    break;
            }
        });
        
        // Handle fullscreen change events
        document.addEventListener('fullscreenchange', function() {
            const icon = document.getElementById('fullscreen-icon');
            if (document.fullscreenElement) {
                icon.className = 'bi bi-fullscreen-exit';
                isFullscreen = true;
            } else {
                icon.className = 'bi bi-fullscreen';
                isFullscreen = false;
            }
        });
    </script>
</body>
</html> 