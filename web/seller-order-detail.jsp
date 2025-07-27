<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${orderDetail.orderId} - Mã chi tiết #${orderDetail.id} - Seller Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/seller.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="hinhanh/Logo/logocraft.png">

    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            margin-left: 280px;
            transition: margin-left 0.3s ease;
        }
        
        .main-content.expanded {
            margin-left: 0;
        }
        
        .content-header {
            background: white;
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .order-detail-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            background: white;
        }
        
        .status-badge {
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 20px;
            color: white;
            font-size: 1rem;
            display: inline-block;
        }
        
        .status-pending { background-color: #ffc107; }
        .status-confirmed { background-color: #17a2b8; }
        .status-packaging { background-color: #6f42c1; }
        .status-preparing { background-color: #fd7e14; }
        .status-shipping { background-color: #007bff; }
        .status-delivered { background-color: #28a745; }
        .status-failed { background-color: #dc3545; }
        .status-cancelled { background-color: #6c757d; }
        
        .info-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .info-section h5 {
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
            border-bottom: 2px solid #007bff;
            padding-bottom: 8px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .info-label {
            font-weight: 600;
            width: 150px;
            color: #555;
        }
        
        .info-value {
            flex: 1;
            color: #333;
        }
        
        .product-item {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .action-buttons {
            margin-top: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            text-decoration: none;
        }
        
        .btn-confirm { background: linear-gradient(135deg, #06b6d4, #0891b2); color: white; }
        .btn-package { background: linear-gradient(135deg, #8b5cf6, #7c3aed); color: white; }
        .btn-prepare { background: linear-gradient(135deg, #f97316, #ea580c); color: white; }
        .btn-ship { background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; }
        .btn-deliver { background: linear-gradient(135deg, #10b981, #059669); color: white; }
        .btn-fail { background: linear-gradient(135deg, #ef4444, #dc2626); color: white; }
        .btn-cancel { background: linear-gradient(135deg, #6b7280, #4b5563); color: white; }
        .btn-back { background: linear-gradient(135deg, #64748b, #475569); color: white; }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <!-- Include Sidebar -->
        <jsp:include page="seller-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 mb-0">Chi tiết đơn hàng</h1>
                        <p class="text-muted mb-0">Đơn hàng #${orderDetail.orderId} - Mã chi tiết #${orderDetail.id}</p>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${orderDetail.status == 0}">
                                <span class="status-badge status-pending">Chờ xác nhận</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 1}">
                                <span class="status-badge status-confirmed">Đã xác nhận</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 2}">
                                <span class="status-badge status-packaging">Đang đóng gói</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 3}">
                                <span class="status-badge status-preparing">Chuẩn bị giao</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 4}">
                                <span class="status-badge status-shipping">Đang giao</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 5}">
                                <span class="status-badge status-delivered">Giao thành công</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 6}">
                                <span class="status-badge status-failed">Giao thất bại</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 7}">
                                <span class="status-badge status-cancelled">Đã hủy</span>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="container-fluid py-4">
                <!-- Customer Information -->
                <div class="order-detail-card">
                    <div class="info-section">
                        <h5><i class="fas fa-user"></i> Thông tin khách hàng</h5>
                        <div class="info-row">
                            <div class="info-label">Tên khách hàng:</div>
                            <div class="info-value">${orderDetail.shippingName}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Số điện thoại:</div>
                            <div class="info-value">${orderDetail.shippingPhone}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email:</div>
                            <div class="info-value">${orderDetail.email}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Địa chỉ giao hàng:</div>
                            <div class="info-value">${orderDetail.shippingAddress}</div>
                        </div>
                    </div>
                </div>

                <!-- Order Information -->
                <div class="order-detail-card">
                    <div class="info-section">
                        <h5><i class="fas fa-shopping-cart"></i> Thông tin đơn hàng</h5>
                        <div class="info-row">
                            <div class="info-label">Mã đơn hàng:</div>
                            <div class="info-value">#${orderDetail.orderId}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Mã chi tiết:</div>
                            <div class="info-value">#${orderDetail.id}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Ngày đặt hàng:</div>
                            <div class="info-value">
                                <fmt:formatDate value="${orderDetail.orderCreatedDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Phương thức thanh toán:</div>
                            <div class="info-value">${orderDetail.paymentMethod}</div>
                        </div>
                        <c:if test="${not empty orderDetail.cancelReason}">
                            <div class="info-row">
                                <div class="info-label">Lý do hủy/thất bại:</div>
                                <div class="info-value text-danger">${orderDetail.cancelReason}</div>
                            </div>
                            <c:if test="${not empty orderDetail.cancelDate}">
                                <div class="info-row">
                                    <div class="info-label">Ngày hủy:</div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${orderDetail.cancelDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </div>
                                </div>
                            </c:if>
                        </c:if>
                    </div>
                </div>

                <!-- Product Information -->
                <div class="order-detail-card">
                    <div class="info-section">
                        <h5><i class="fas fa-box"></i> Thông tin sản phẩm</h5>
                        <div class="product-item">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <c:if test="${not empty orderDetail.productImage}">
                                        <img src="hinhanh/${orderDetail.productImage}" 
                                             alt="${orderDetail.productName}" 
                                             class="product-image">
                                    </c:if>
                                    <c:if test="${empty orderDetail.productImage}">
                                        <div class="product-image bg-light d-flex align-items-center justify-content-center">
                                            <i class="fas fa-image text-muted"></i>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <div class="product-name">${orderDetail.productName}</div>
                                    <div class="product-details">
                                        Mã sản phẩm: #${orderDetail.productId}
                                    </div>
                                </div>
                                <div class="col-md-2 text-center">
                                    <div class="fw-bold">Số lượng</div>
                                    <div>${orderDetail.quantity}</div>
                                </div>
                                <div class="col-md-2 text-end">
                                    <div class="fw-bold">Đơn giá</div>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${orderDetail.price}" type="currency" currencySymbol="₫"/>
                                    </div>
                                    <div class="fw-bold mt-2">Thành tiền</div>
                                    <div class="product-price text-primary">
                                        <fmt:formatNumber value="${orderDetail.subtotal}" type="currency" currencySymbol="₫"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="order-detail-card">
                    <div class="action-buttons">
                        <a href="seller-order-management" class="btn-action btn-back">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        
                        <!-- Status Update Buttons -->
                        <c:choose>
                            <c:when test="${orderDetail.status == 0}">
                                <button type="button" class="btn-action btn-confirm" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'confirm')">
                                    <i class="fas fa-check"></i> Xác nhận đơn hàng
                                </button>
                                <button type="button" class="btn-action btn-cancel" 
                                        onclick="showCancelModal('${orderDetail.id}')">
                                    <i class="fas fa-times"></i> Hủy đơn hàng
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 1}">
                                <button type="button" class="btn-action btn-package" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'package')">
                                    <i class="fas fa-box"></i> Bắt đầu đóng gói
                                </button>
                                <button type="button" class="btn-action btn-cancel" 
                                        onclick="showCancelModal('${orderDetail.id}')">
                                    <i class="fas fa-times"></i> Hủy đơn hàng
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 2}">
                                <button type="button" class="btn-action btn-prepare" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'prepare')">
                                    <i class="fas fa-truck"></i> Chuẩn bị giao hàng
                                </button>
                                <button type="button" class="btn-action btn-cancel" 
                                        onclick="showCancelModal('${orderDetail.id}')">
                                    <i class="fas fa-times"></i> Hủy đơn hàng
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 3}">
                                <button type="button" class="btn-action btn-ship" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'shipping')">
                                    <i class="fas fa-shipping-fast"></i> Bắt đầu vận chuyển
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 4}">
                                <button type="button" class="btn-action btn-deliver" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'delivered')">
                                    <i class="fas fa-check-circle"></i> Hoàn thành giao hàng
                                </button>
                                <button type="button" class="btn-action btn-fail" 
                                        onclick="showFailureModal('${orderDetail.id}')">
                                    <i class="fas fa-exclamation-triangle"></i> Giao hàng thất bại
                                </button>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelModalLabel">Hủy đơn hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="cancelForm" action="seller-update-order-status" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="orderDetailId" id="cancelOrderDetailId">
                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">Lý do hủy đơn hàng:</label>
                            <textarea class="form-control" name="cancelReason" id="cancelReason" 
                                      rows="3" required placeholder="Vui lòng nhập lý do hủy đơn hàng..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-danger">Xác nhận hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Failure Order Modal -->
    <div class="modal fade" id="failureModal" tabindex="-1" aria-labelledby="failureModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="failureModalLabel">Giao hàng thất bại</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="failureForm" action="seller-update-order-status" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="failed">
                        <input type="hidden" name="orderDetailId" id="failureOrderDetailId">
                        <div class="mb-3">
                            <label for="failureReason" class="form-label">Lý do giao hàng thất bại:</label>
                            <textarea class="form-control" name="failureReason" id="failureReason" 
                                      rows="3" required placeholder="Vui lòng nhập lý do giao hàng thất bại..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-danger">Xác nhận</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function updateOrderStatus(orderDetailId, action) {
            if (confirm('Bạn có chắc chắn muốn thực hiện hành động này?')) {
                window.location.href = 'seller-update-order-status?orderDetailId=' + orderDetailId + '&action=' + action;
            }
        }
        
        function showCancelModal(orderDetailId) {
            document.getElementById('cancelOrderDetailId').value = orderDetailId;
            const modal = new bootstrap.Modal(document.getElementById('cancelModal'));
            modal.show();
        }
        
        function showFailureModal(orderDetailId) {
            document.getElementById('failureOrderDetailId').value = orderDetailId;
            const modal = new bootstrap.Modal(document.getElementById('failureModal'));
            modal.show();
        }
    </script>
</body>
</html>
