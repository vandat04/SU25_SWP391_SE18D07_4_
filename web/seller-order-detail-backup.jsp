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
        <title>Chi tiết đơn hàng #${orderDetail.orderId} - Mã chi tiết #${orderDetail.id} - Seller Dashboard</title>

        <!-- CSS Links -->
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">

        <style>
            .seller-layout {
                display: flex;
                min-height: 100vh;
            }
            
            .seller-content {
                flex: 1;
                padding: 20px;
                background-color: #f8f9fa;
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
            
            .product-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            
            .product-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 15px;
            }
            
            .product-info {
                flex: 1;
            }
            
            .product-name {
                font-weight: 600;
                color: #333;
                font-size: 1.1rem;
                margin-bottom: 5px;
            }
            
            .product-details {
                color: #666;
                font-size: 0.9rem;
            }
            
            .product-price {
                text-align: right;
                font-weight: 600;
                color: #007bff;
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
                font-size: 1rem;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            
            .btn-confirm { background-color: #17a2b8; color: white; }
            .btn-package { background-color: #6f42c1; color: white; }
            .btn-prepare { background-color: #fd7e14; color: white; }
            .btn-ship { background-color: #007bff; color: white; }
            .btn-deliver { background-color: #28a745; color: white; }
            .btn-fail { background-color: #dc3545; color: white; }
            .btn-cancel { background-color: #6c757d; color: white; }
            .btn-back { background-color: #6c757d; color: white; }
            
            .btn-action:hover {
                opacity: 0.8;
                color: white;
                text-decoration: none;
            }
            
            .timeline {
                position: relative;
                padding-left: 30px;
            }
            
            .timeline::before {
                content: '';
                position: absolute;
                left: 15px;
                top: 0;
                bottom: 0;
                width: 2px;
                background: #dee2e6;
            }
            
            .timeline-item {
                position: relative;
                margin-bottom: 20px;
            }
            
            .timeline-item::before {
                content: '';
                position: absolute;
                left: -22px;
                top: 5px;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #007bff;
                border: 3px solid white;
                box-shadow: 0 0 0 2px #007bff;
            }
            
            .timeline-content {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #eee;
            }
            
            .timeline-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }
            
            .timeline-time {
                font-size: 0.85rem;
                color: #666;
            }
        </style>
    </head>
    <body>
        <div class="seller-layout">
            <!-- Include Seller Sidebar -->
            <jsp:include page="seller-sidebar.jsp" />
            
            <div class="seller-content">
                <div class="container-fluid">
                    <!-- Page Header -->
                    <div class="row">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2>Chi tiết đơn hàng #${subOrder.subOrderId}</h2>
                                <a href="seller-order-management" class="btn-action btn-back">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Order Status -->
                    <div class="order-detail-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4>Trạng thái đơn hàng</h4>
                            <div>
                                <c:choose>
                                    <c:when test="${subOrder.orderStatus == 0}">
                                        <span class="status-badge status-pending">Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 1}">
                                        <span class="status-badge status-confirmed">Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 2}">
                                        <span class="status-badge status-packaging">Đang đóng gói</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 3}">
                                        <span class="status-badge status-preparing">Chuẩn bị giao</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 4}">
                                        <span class="status-badge status-shipping">Đang giao</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 5}">
                                        <span class="status-badge status-delivered">Giao thành công</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 6}">
                                        <span class="status-badge status-failed">Giao thất bại</span>
                                    </c:when>
                                    <c:when test="${subOrder.orderStatus == 7}">
                                        <span class="status-badge status-cancelled">Đã hủy</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <c:choose>
                                <c:when test="${subOrder.orderStatus == 0}">
                                    <button type="button" class="btn-action btn-confirm" 
                                            onclick="updateOrderStatus(${subOrder.subOrderId}, 'confirm')">
                                        <i class="fa fa-check"></i> Xác nhận đơn hàng
                                    </button>
                                    <button type="button" class="btn-action btn-cancel" 
                                            onclick="showCancelModal(${subOrder.subOrderId})">
                                        <i class="fa fa-times"></i> Hủy đơn hàng
                                    </button>
                                </c:when>
                                
                                <c:when test="${subOrder.orderStatus == 1}">
                                    <button type="button" class="btn-action btn-package" 
                                            onclick="updateOrderStatus(${subOrder.subOrderId}, 'package')">
                                        <i class="fa fa-box"></i> Bắt đầu đóng gói
                                    </button>
                                    <button type="button" class="btn-action btn-cancel" 
                                            onclick="showCancelModal(${subOrder.subOrderId})">
                                        <i class="fa fa-times"></i> Hủy đơn hàng
                                    </button>
                                </c:when>
                                
                                <c:when test="${subOrder.orderStatus == 2}">
                                    <button type="button" class="btn-action btn-prepare" 
                                            onclick="updateOrderStatus(${subOrder.subOrderId}, 'prepare')">
                                        <i class="fa fa-truck"></i> Chuẩn bị giao hàng
                                    </button>
                                    <button type="button" class="btn-action btn-cancel" 
                                            onclick="showCancelModal(${subOrder.subOrderId})">
                                        <i class="fa fa-times"></i> Hủy đơn hàng
                                    </button>
                                </c:when>
                                
                                <c:when test="${subOrder.orderStatus == 3}">
                                    <button type="button" class="btn-action btn-ship" 
                                            onclick="updateOrderStatus(${subOrder.subOrderId}, 'shipping')">
                                        <i class="fa fa-shipping-fast"></i> Bắt đầu vận chuyển
                                    </button>
                                </c:when>
                                
                                <c:when test="${subOrder.orderStatus == 4}">
                                    <button type="button" class="btn-action btn-deliver" 
                                            onclick="updateOrderStatus(${subOrder.subOrderId}, 'delivered')">
                                        <i class="fa fa-check-circle"></i> Xác nhận giao thành công
                                    </button>
                                    <button type="button" class="btn-action btn-fail" 
                                            onclick="showFailureModal(${subOrder.subOrderId})">
                                        <i class="fa fa-exclamation-triangle"></i> Báo giao thất bại
                                    </button>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="row">
                        <!-- Order Information -->
                        <div class="col-md-6">
                            <div class="order-detail-card">
                                <div class="info-section">
                                    <h5><i class="fa fa-user"></i> Thông tin khách hàng</h5>
                                    <div class="info-row">
                                        <div class="info-label">Tên khách hàng:</div>
                                        <div class="info-value">${customer.fullName}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Email:</div>
                                        <div class="info-value">${customer.email}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Số điện thoại:</div>
                                        <div class="info-value">${customer.phoneNumber}</div>
                                    </div>
                                </div>
                                
                                <div class="info-section">
                                    <h5><i class="fa fa-shipping-fast"></i> Thông tin giao hàng</h5>
                                    <div class="info-row">
                                        <div class="info-label">Người nhận:</div>
                                        <div class="info-value">${mainOrder.shippingName}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">SĐT nhận hàng:</div>
                                        <div class="info-value">${mainOrder.shippingPhone}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Địa chỉ:</div>
                                        <div class="info-value">${mainOrder.shippingAddress}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Order Details -->
                        <div class="col-md-6">
                            <div class="order-detail-card">
                                <div class="info-section">
                                    <h5><i class="fa fa-info-circle"></i> Thông tin đơn hàng</h5>
                                    <div class="info-row">
                                        <div class="info-label">Mã đơn hàng:</div>
                                        <div class="info-value">#${subOrder.subOrderId}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Ngày đặt hàng:</div>
                                        <div class="info-value">
                                            <fmt:formatDate value="${subOrder.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Phương thức TT:</div>
                                        <div class="info-value">${subOrder.paymentMethod}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Trạng thái TT:</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${subOrder.paymentStatus == 1}">
                                                    <span class="badge badge-success">Đã thanh toán</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning">Chưa thanh toán</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <c:if test="${not empty subOrder.note}">
                                        <div class="info-row">
                                            <div class="info-label">Ghi chú:</div>
                                            <div class="info-value">${subOrder.note}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty subOrder.cancelReason}">
                                        <div class="info-row">
                                            <div class="info-label">Lý do hủy/thất bại:</div>
                                            <div class="info-value text-danger">${subOrder.cancelReason}</div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Order Items -->
                    <div class="order-detail-card">
                        <h4 class="mb-4"><i class="fa fa-shopping-cart"></i> Sản phẩm trong đơn hàng</h4>
                        
                        <!-- Products -->
                        <c:if test="${not empty orderDetails}">
                            <c:forEach var="detail" items="${orderDetails}">
                                <div class="product-item">
                                    <div class="product-header">
                                        <img src="${detail.product.mainImageUrl}" alt="${detail.product.name}" class="product-image">
                                        <div class="product-info">
                                            <div class="product-name">${detail.product.name}</div>
                                            <div class="product-details">
                                                Số lượng: ${detail.quantity} | 
                                                Đơn giá: <fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫"/>
                                            </div>
                                        </div>
                                        <div class="product-price">
                                            <fmt:formatNumber value="${detail.subtotal}" type="currency" currencySymbol="₫"/>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        
                        <!-- Tickets -->
                        <c:if test="${not empty ticketDetails}">
                            <c:forEach var="detail" items="${ticketDetails}">
                                <div class="product-item">
                                    <div class="product-header">
                                        <div class="product-info">
                                            <div class="product-name">Vé tham quan - ${detail.ticket.name}</div>
                                            <div class="product-details">
                                                Số lượng: ${detail.quantity} | 
                                                Đơn giá: <fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫"/>
                                            </div>
                                        </div>
                                        <div class="product-price">
                                            <fmt:formatNumber value="${detail.subtotal}" type="currency" currencySymbol="₫"/>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        
                        <!-- Total -->
                        <div class="row">
                            <div class="col-md-8"></div>
                            <div class="col-md-4">
                                <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded">
                                    <strong>Tổng cộng:</strong>
                                    <strong class="text-primary" style="font-size: 1.2rem;">
                                        <fmt:formatNumber value="${subOrder.totalPrice}" type="currency" currencySymbol="₫"/>
                                    </strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Cancel Order Modal -->
        <div class="modal fade" id="cancelModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Hủy đơn hàng</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <form id="cancelForm" action="seller-update-order-status" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="subOrderId" id="cancelSubOrderId">
                            <div class="form-group">
                                <label for="cancelReason">Lý do hủy đơn hàng:</label>
                                <textarea class="form-control" name="cancelReason" id="cancelReason" 
                                          rows="3" required placeholder="Vui lòng nhập lý do hủy đơn hàng..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Failure Order Modal -->
        <div class="modal fade" id="failureModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Giao hàng thất bại</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <form id="failureForm" action="seller-update-order-status" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="failed">
                            <input type="hidden" name="subOrderId" id="failureSubOrderId">
                            <div class="form-group">
                                <label for="failureReason">Lý do giao hàng thất bại:</label>
                                <textarea class="form-control" name="failureReason" id="failureReason" 
                                          rows="3" required placeholder="Vui lòng nhập lý do giao hàng thất bại..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="assets/js/jquery-3.6.0.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        
        <script>
            function updateOrderStatus(subOrderId, action) {
                if (confirm('Bạn có chắc chắn muốn thực hiện hành động này?')) {
                    window.location.href = 'seller-update-order-status?subOrderId=' + subOrderId + '&action=' + action;
                }
            }
            
            function showCancelModal(subOrderId) {
                document.getElementById('cancelSubOrderId').value = subOrderId;
                $('#cancelModal').modal('show');
            }
            
            function showFailureModal(subOrderId) {
                document.getElementById('failureSubOrderId').value = subOrderId;
                $('#failureModal').modal('show');
            }
        </script>
    </body>
</html>
