<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Detail #${orderDetail.orderId} - Detail #${orderDetail.id} - Seller Dashboard</title>
    
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
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .order-detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .status-badge {
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            color: white;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .status-pending { background: linear-gradient(135deg, #f59e0b, #d97706); }
        .status-confirmed { background: linear-gradient(135deg, #06b6d4, #0891b2); }
        .status-packaging { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }
        .status-preparing { background: linear-gradient(135deg, #f97316, #ea580c); }
        .status-shipping { background: linear-gradient(135deg, #3b82f6, #2563eb); }
        .status-delivered { background: linear-gradient(135deg, #10b981, #059669); }
        .status-failed { background: linear-gradient(135deg, #ef4444, #dc2626); }
        .status-cancelled { background: linear-gradient(135deg, #6b7280, #4b5563); }
        
        .info-section {
            background: #f8fafc;
            border-radius: 0.75rem;
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #3b82f6;
        }
        
        .info-section h5 {
            color: #1e293b;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-bottom: 2px solid #e0e7ff;
            padding-bottom: 0.5rem;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 0.75rem;
        }
        
        .info-label {
            font-weight: 500;
            width: 150px;
            color: #64748b;
        }
        
        .info-value {
            flex: 1;
            color: #1e293b;
        }
        
        .product-item {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1rem;
            margin-bottom: 1rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .product-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 0.5rem;
            border: 1px solid #e2e8f0;
        }
        
        .action-buttons {
            margin-top: 1.5rem;
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .btn-action {
            padding: 0.75rem 1.25rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            text-decoration: none;
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
                        <h1 class="h3 mb-0">Order Detail</h1>
                        <p class="text-muted mb-0">Order #${orderDetail.orderId} - Detail #${orderDetail.id}</p>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${orderDetail.status == 0}">
                                <span class="status-badge status-pending">Pending</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 1}">
                                <span class="status-badge status-confirmed">Confirmed</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 2}">
                                <span class="status-badge status-packaging">Packaging</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 3}">
                                <span class="status-badge status-preparing">Preparing</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 4}">
                                <span class="status-badge status-shipping">Shipping</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 5}">
                                <span class="status-badge status-delivered">Delivered</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 6}">
                                <span class="status-badge status-failed">Failed</span>
                            </c:when>
                            <c:when test="${orderDetail.status == 7}">
                                <span class="status-badge status-cancelled">Cancelled</span>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="container-fluid py-4">
                <!-- Customer Information -->
                <div class="order-detail-card">
                    <div class="info-section">
                        <h5><i class="fas fa-user"></i> Customer Information</h5>
                        <div class="info-row">
                            <div class="info-label">Customer Name:</div>
                            <div class="info-value">${orderDetail.shippingName}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Phone Number:</div>
                            <div class="info-value">${orderDetail.shippingPhone}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email:</div>
                            <div class="info-value">${orderDetail.email}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Shipping Address:</div>
                            <div class="info-value">${orderDetail.shippingAddress}</div>
                        </div>
                    </div>
                </div>

                <!-- Order Information -->
                <div class="order-detail-card">
                    <div class="info-section">
                        <h5><i class="fas fa-shopping-cart"></i> Order Information</h5>
                        <div class="info-row">
                            <div class="info-label">Order ID:</div>
                            <div class="info-value">#${orderDetail.orderId}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Detail ID:</div>
                            <div class="info-value">#${orderDetail.id}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Order Date:</div>
                            <div class="info-value">
                                <fmt:formatDate value="${orderDetail.orderCreatedDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Payment Method:</div>
                            <div class="info-value">${orderDetail.paymentMethod}</div>
                        </div>
                        <c:if test="${not empty orderDetail.cancelReason}">
                            <div class="info-row">
                                <div class="info-label">Reason for Cancellation/Failure:</div>
                                <div class="info-value text-danger">${orderDetail.cancelReason}</div>
                            </div>
                            <c:if test="${not empty orderDetail.cancelDate}">
                                <div class="info-row">
                                    <div class="info-label">Cancellation Date:</div>
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
                        <h5><i class="fas fa-box"></i> Product Information</h5>
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
                                        Product ID: #${orderDetail.productId}
                                    </div>
                                </div>
                                <div class="col-md-2 text-center">
                                    <div class="fw-bold">Quantity</div>
                                    <div>${orderDetail.quantity}</div>
                                </div>
                                <div class="col-md-2 text-end">
                                    <div class="fw-bold">Unit Price</div>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${orderDetail.price}" type="currency" currencySymbol="$"/>
                                    </div>
                                    <div class="fw-bold mt-2">Subtotal</div>
                                    <div class="product-price text-primary">
                                        <fmt:formatNumber value="${orderDetail.subtotal}" type="currency" currencySymbol="$"/>
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
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                        
                        <!-- Status Update Buttons -->
                        <c:choose>
                            <c:when test="${orderDetail.status == 0}">
                                <button type="button" class="btn-action btn-confirm" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'confirm')">
                                    <i class="fas fa-check"></i> Confirm Order
                                </button>
                                <button type="button" class="btn-action btn-cancel" 
                                        onclick="showCancelModal('${orderDetail.id}')">
                                    <i class="fas fa-times"></i> Cancel Order
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 1}">
                                <button type="button" class="btn-action btn-package" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'package')">
                                    <i class="fas fa-box"></i> Start Packaging
                                </button>
                                <button type="button" class="btn-action btn-cancel" 
                                        onclick="showCancelModal('${orderDetail.id}')">
                                    <i class="fas fa-times"></i> Cancel Order
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 2}">
                                <button type="button" class="btn-action btn-prepare" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'prepare')">
                                    <i class="fas fa-truck"></i> Prepare for Delivery
                                </button>
                                <button type="button" class="btn-action btn-cancel" 
                                        onclick="showCancelModal('${orderDetail.id}')">
                                    <i class="fas fa-times"></i> Cancel Order
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 3}">
                                <button type="button" class="btn-action btn-ship" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'shipping')">
                                    <i class="fas fa-shipping-fast"></i> Start Shipping
                                </button>
                            </c:when>
                            
                            <c:when test="${orderDetail.status == 4}">
                                <button type="button" class="btn-action btn-deliver" 
                                        onclick="updateOrderStatus('${orderDetail.id}', 'delivered')">
                                    <i class="fas fa-check-circle"></i> Complete Delivery
                                </button>
                                <button type="button" class="btn-action btn-fail" 
                                        onclick="showFailureModal('${orderDetail.id}')">
                                    <i class="fas fa-exclamation-triangle"></i> Delivery Failed
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
                    <h5 class="modal-title" id="cancelModalLabel">Cancel Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="cancelForm" action="seller-update-order-status" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="orderDetailId" id="cancelOrderDetailId">
                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">Reason for Cancellation:</label>
                            <textarea class="form-control" name="cancelReason" id="cancelReason" 
                                      rows="3" required placeholder="Please enter the reason for cancellation..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-danger">Confirm Cancellation</button>
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
                    <h5 class="modal-title" id="failureModalLabel">Delivery Failed</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="failureForm" action="seller-update-order-status" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="failed">
                        <input type="hidden" name="orderDetailId" id="failureOrderDetailId">
                        <div class="mb-3">
                            <label for="failureReason" class="form-label">Reason for Delivery Failure:</label>
                            <textarea class="form-control" name="failureReason" id="failureReason" 
                                      rows="3" required placeholder="Please enter the reason for delivery failure..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-danger">Confirm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function updateOrderStatus(orderDetailId, action) {
            if (confirm('Are you sure you want to perform this action?')) {
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