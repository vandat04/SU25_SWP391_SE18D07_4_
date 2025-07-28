<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Seller Dashboard</title>
    
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
        
        .content-body {
            padding: 2rem;
        }
        
        .order-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 1rem;
            margin-bottom: 1rem;
        }
        
        .order-id {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
        }
        
        .status-badge {
            font-weight: 600;
            padding: 0.375rem 1rem;
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
        
        .customer-info {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1.25rem;
            margin-bottom: 1rem;
            border-left: 4px solid #3b82f6;
        }
        
        .customer-info h6 {
            color: #1e293b;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            font-size: 0.875rem;
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
        
        .btn-info {
            background: linear-gradient(135deg, #60a5fa, #3b82f6);
            color: white;
            padding: 0.75rem 1.25rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }
        
        .btn-info:hover {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .empty-state {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 3rem 2rem;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .empty-state:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .empty-state i {
            font-size: 3rem;
            color: #9ca3af;
            margin-bottom: 1.5rem;
        }
        
        .pagination {
            justify-content: center;
            margin-top: 2rem;
        }
        
        .page-link {
            border-radius: 0.5rem;
            margin: 0 0.25rem;
            border: 1px solid #e2e8f0;
            color: #475569;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .page-link:hover {
            background-color: #e0e7ff;
            border-color: #cbd5e1;
            color: #1e293b;
        }
        
        .page-item.active .page-link {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            border-color: #3b82f6;
            color: white;
        }
        
        .filter-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .filter-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb, #1e40af);
        }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <!-- Include Sidebar -->
        <jsp:include page="seller-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="main-content" id="mainContent">
            <!-- Content Header -->
            <div class="content-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 mb-1">Order Management</h1>
                        <p class="text-muted mb-0">Track and update order statuses</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="seller-toggle-sidebar btn btn-outline-primary d-lg-none">
                            <i class="fas fa-bars"></i>
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Content Body -->
            <div class="content-body">
                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
                
                <!-- Filter Section -->
                <div class="filter-card">
                    <form method="GET" action="seller-order-management">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label for="status" class="form-label">Status:</label>
                                <select name="status" id="status" class="form-select">
                                    <option value="-1" ${status == -1 ? 'selected' : ''}>All</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Pending</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Confirmed</option>
                                    <option value="2" ${status == 2 ? 'selected' : ''}>Packaging</option>
                                    <option value="3" ${status == 3 ? 'selected' : ''}>Preparing</option>
                                    <option value="4" ${status == 4 ? 'selected' : ''}>Shipping</option>
                                    <option value="5" ${status == 5 ? 'selected' : ''}>Delivered</option>
                                    <option value="6" ${status == 6 ? 'selected' : ''}>Failed</option>
                                    <option value="7" ${status == 7 ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="search" class="form-label">Search:</label>
                                <input type="text" name="search" id="search" class="form-control" 
                                       placeholder="Customer name, phone, order ID..." 
                                       value="${searchKeyword}">
                            </div>
                            
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search me-2"></i>Search
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Order List -->
                <c:choose>
                    <c:when test="${empty orderDetails}">
                        <div class="empty-state">
                            <i class="fas fa-shopping-cart"></i>
                            <h4 class="text-muted">No Orders Found</h4>
                            <p class="text-muted">No orders match the current search criteria.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="orderDetail" items="${orderDetails}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-id">
                                        Order #${orderDetail.orderId} - Detail #${orderDetail.id}
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
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="customer-info">
                                            <h6><i class="fas fa-user"></i> Customer Information</h6>
                                            <p class="mb-1"><strong>Name:</strong> ${orderDetail.shippingName}</p>
                                            <p class="mb-1"><strong>Phone:</strong> ${orderDetail.shippingPhone}</p>
                                            <p class="mb-0"><strong>Address:</strong> ${orderDetail.shippingAddress}</p>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <div class="customer-info">
                                            <h6><i class="fas fa-info-circle"></i> Order Information</h6>
                                            <p class="mb-1"><strong>Order Date:</strong> 
                                                <fmt:formatDate value="${orderDetail.orderCreatedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            <p class="mb-1"><strong>Product:</strong> ${orderDetail.productName}</p>
                                            <p class="mb-1"><strong>Quantity:</strong> ${orderDetail.quantity}</p>
                                            <p class="mb-1"><strong>Total:</strong> 
                                                <fmt:formatNumber value="${orderDetail.subtotal}" type="currency" currencySymbol="$"/>
                                            </p>
                                            <p class="mb-0"><strong>Payment Method:</strong> ${orderDetail.paymentMethod}</p>
                                            <c:if test="${not empty orderDetail.cancelReason}">
                                                <p class="mb-0"><strong>Reason for Cancellation/Failure:</strong> 
                                                    <span class="text-danger">${orderDetail.cancelReason}</span>
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <a href="seller-order-detail?id=${orderDetail.id}" 
                                       class="btn btn-info">
                                        <i class="fas fa-eye"></i> View Details
                                    </a>
                                    
                                    <!-- Status Update Buttons -->
                                    <c:choose>
                                        <c:when test="${orderDetail.status == 0}">
                                            <button type="button" class="btn-action btn-confirm" 
                                                    onclick="updateOrderStatus('${orderDetail.id}', 'confirm')">
                                                <i class="fas fa-check"></i> Confirm
                                            </button>
                                            <button type="button" class="btn-action btn-cancel" 
                                                    onclick="showCancelModal('${orderDetail.id}')">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </c:when>
                                        
                                        <c:when test="${orderDetail.status == 1}">
                                            <button type="button" class="btn-action btn-package" 
                                                    onclick="updateOrderStatus('${orderDetail.id}', 'package')">
                                                <i class="fas fa-box"></i> Package
                                            </button>
                                            <button type="button" class="btn-action btn-cancel" 
                                                    onclick="showCancelModal('${orderDetail.id}')">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </c:when>
                                        
                                        <c:when test="${orderDetail.status == 2}">
                                            <button type="button" class="btn-action btn-prepare" 
                                                    onclick="updateOrderStatus('${orderDetail.id}', 'prepare')">
                                                <i class="fas fa-truck"></i> Prepare
                                            </button>
                                            <button type="button" class="btn-action btn-cancel" 
                                                    onclick="showCancelModal('${orderDetail.id}')">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </c:when>
                                        
                                        <c:when test="${orderDetail.status == 3}">
                                            <button type="button" class="btn-action btn-ship" 
                                                    onclick="updateOrderStatus('${orderDetail.id}', 'shipping')">
                                                <i class="fas fa-shipping-fast"></i> Ship
                                            </button>
                                        </c:when>
                                        
                                        <c:when test="${orderDetail.status == 4}">
                                            <button type="button" class="btn-action btn-deliver" 
                                                    onclick="updateOrderStatus('${orderDetail.id}', 'delivered')">
                                                <i class="fas fa-check-circle"></i> Deliver
                                            </button>
                                            <button type="button" class="btn-action btn-fail" 
                                                    onclick="showFailureModal('${orderDetail.id}')">
                                                <i class="fas fa-exclamation-triangle"></i> Fail
                                            </button>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Page navigation">
                                <ul class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="seller-order-management?page=${currentPage - 1}&status=${status}&search=${searchKeyword}">
                                                <i class="fas fa-chevron-left"></i> Previous
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="seller-order-management?page=${i}&status=${status}&search=${searchKeyword}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="seller-order-management?page=${currentPage + 1}&status=${status}&search=${searchKeyword}">
                                                Next <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
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