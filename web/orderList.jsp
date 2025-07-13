<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - ${sessionScope.acc.userName}</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <%-- Đường dẫn tới CSS chung cho seller dashboard --%>
    <link rel="stylesheet" href="<c:url value='/css/sellerDashboard.css'/>">
    <style>
        :root {
            --background-color: #fdfaf6;
            --sidebar-bg: #ffffff;
            --primary-text: #3d3d3d;
            --secondary-text: #888;
            --accent-color: #8c6d46;
            --accent-hover: #7a5c35;
            --border-color: #e0d9cf;
            --shadow-color: rgba(0, 0, 0, 0.05);
            --font-heading: 'Playfair Display', serif;
            --font-body: 'Montserrat', sans-serif;
            --error-bg: #fdeaea;
            --error-border: #f8c9c9;
            --error-text: #a82a2a;
            --success-bg: #e9f7ef;
            --success-border: #b8e9d1;
            --success-text: #1e6641;

            /* Thêm màu sắc cho trạng thái đơn hàng nếu cần */
            --status-pending-text: #f0ad4e; /* Orange */
            --status-confirmed-text: #5bc0de; /* Light Blue */
            --status-shipped-text: #337ab7; /* Blue */
            --status-delivered-text: #5cb85c; /* Green */
            --status-cancelled-text: #d9534f; /* Red */
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-body);
            background-color: var(--background-color);
            color: var(--primary-text);
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
        }

        .sidebar-logo {
            padding: 1.5rem 2rem;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
        }

        .sidebar-logo img {
            max-width: 80%;
            height: auto;
        }

        .sidebar-profile {
            text-align: center;
            padding: 2rem 1rem;
        }

        .sidebar-profile .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--accent-color);
            margin-bottom: 1rem;
        }

        .sidebar-profile h3 {
            font-family: var(--font-heading);
            font-size: 1.2rem;
            margin-bottom: 0.25rem;
        }

        .sidebar-profile p {
            font-size: 0.9rem;
            color: #999;
        }

        .sidebar-nav {
            list-style-type: none;
            flex-grow: 1;
            margin-top: 1rem;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 1rem 2rem;
            color: var(--primary-text);
            text-decoration: none;
            font-weight: 500;
            border-left: 4px solid transparent;
            transition: background-color 0.2s, color 0.2s;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background-color: var(--background-color);
            color: var(--accent-color);
            border-left-color: var(--accent-color);
        }

        .sidebar-nav a i {
            width: 25px;
            margin-right: 1rem;
            font-size: 1.1rem;
            text-align: center;
        }

        .sidebar-logout {
            padding: 1rem 0;
            border-top: 1px solid var(--border-color);
        }

        .sidebar-logout a {
            text-decoration: none;
            color: var(--primary-text);
        }

        .main-content {
            flex-grow: 1;
            padding: 2rem 3rem;
            overflow-y: auto;
        }

        .main-header {
            margin-bottom: 2rem;
        }

        .main-header h1 {
            font-family: var(--font-heading);
            font-size: 2.5rem;
            font-weight: 700;
        }

        .main-header p {
            color: var(--secondary-text);
            font-size: 1rem;
        }

        .panel {
            background-color: #fff;
            padding: 2rem;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 15px var(--shadow-color);
        }

        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
        }

        .panel-title {
            font-family: var(--font-heading);
            font-size: 1.5rem;
        }

        .primary-action-btn {
            background: var(--accent-color);
            color: #fff;
            text-decoration: none;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            font-weight: 500;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .primary-action-btn:hover {
            background: var(--accent-hover);
        }

        .secondary-action-btn {
            background: #fff;
            color: var(--primary-text);
            text-decoration: none;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            font-weight: 500;
            transition: background-color 0.3s, box-shadow 0.3s;
            border: 1px solid var(--border-color);
            cursor: pointer;
        }

        .secondary-action-btn:hover {
            background-color: var(--background-color);
        }

        .product-table { /* Đổi tên thành .order-table nếu muốn chuyên biệt hơn */
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
        }

        .product-table th,
        .product-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
            vertical-align: middle;
        }

        .product-table thead th {
            font-weight: 500;
            color: var(--secondary-text);
            text-transform: uppercase;
            font-size: 0.85rem;
        }

        .product-table tbody tr:hover {
            background-color: var(--background-color);
        }

        .product-table img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
        }

        .action-buttons button,
        .action-buttons a {
            background: none;
            border: none;
            cursor: pointer;
            margin: 0 8px;
            text-decoration: none;
            color: var(--secondary-text);
            font-size: 1.1rem;
            transition: color 0.2s;
        }

        .action-buttons button:hover,
        .action-buttons a:hover {
            color: var(--accent-color);
        }

        .alert {
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            border-radius: 8px;
            border: 1px solid transparent;
            font-weight: 500;
        }

        .alert-error {
            background-color: var(--error-bg);
            border-color: var(--error-border);
            color: var(--error-text);
        }

        .alert-success {
            background-color: var(--success-bg);
            border-color: var(--success-border);
            color: var(--success-text);
        }

        .search-filter-box {
            padding: 1.5rem 0;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            gap: 1.5rem;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .filter-group label {
            font-weight: 500;
            font-size: 0.9rem;
            color: var(--secondary-text);
        }

        .filter-group input[type="text"],
        .filter-group input[type="number"],
        .filter-group input[type="date"],
        .filter-group select { /* Thêm select cho filter trạng thái */
            padding: 0.7rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-family: var(--font-body);
            background-color: var(--background-color);
            transition: border-color 0.2s, box-shadow 0.2s;
            min-width: 150px; /* Adjust as needed */
        }

        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(140, 109, 70, 0.2);
        }
        
        /* Styles for order status */
        .status-badge {
            display: inline-block;
            padding: 0.3em 0.6em;
            border-radius: 5px;
            font-size: 0.8em;
            font-weight: 600;
            text-align: center;
            vertical-align: middle;
        }

        .status-pending {
            background-color: #ffe0b2; /* Light orange background */
            color: var(--status-pending-text);
        }
        .status-confirmed {
            background-color: #b3e5fc; /* Light blue background */
            color: var(--status-confirmed-text);
        }
        .status-shipped {
            background-color: #bbdefb; /* Blue background */
            color: var(--status-shipped-text);
        }
        .status-delivered {
            background-color: #c8e6c9; /* Light green background */
            color: var(--status-delivered-text);
        }
        .status-cancelled {
            background-color: #ffcdd2; /* Light red background */
            color: var(--status-cancelled-text);
        }

    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-logo">
            <a href="<c:url value='/home'/>">
                <img src="<c:url value='/hinhanh/Logo/logocraft.png'/>" alt="Craft Village Logo">
            </a>
        </div>
        <c:if test="${not empty sessionScope.acc}">
            <div class="sidebar-profile">
                <img src="${not empty sessionScope.acc.avatarUrl ? sessionScope.acc.avatarUrl : 'https://i.pravatar.cc/150?u='}${sessionScope.acc.userID}" alt="Avatar" class="avatar">
                <h3>${sessionScope.acc.userName}</h3>
                <p>Administrator</p>
            </div>
        </c:if>
        <ul class="sidebar-nav">
            <li><a href="seller" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="manageProduct"><i class="fas fa-palette"></i> Product Management</a></li>
            <li><a href="manage-villages"><i class="fas fa-landmark"></i> Village Management</a></li>
            <li><a href="order-management"><i class="fas fa-receipt"></i> Order Management</a></li>
            <li><a href="feedback-management"><i class="fas fa-comments"></i> Feedback Management</a></li>
            <li><a href="statistics"><i class="fas fa-chart-pie"></i> Statistics</a></li>
            <li><a href="contact"><i class="fas fa-headset"></i> Contact & Support</a></li>
        </ul>
        <div class="sidebar-logout">
            <a href="<c:url value='/logout'/>" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Order Management</h1>
            <p>View and manage customer orders.</p>
        </header>

        <section class="panel">
            <div class="panel-header">
                <h2 class="panel-title">Order List</h2>
                <%-- Có thể thêm nút "Add New Order" nếu có tính năng tạo đơn hàng thủ công --%>
                <%-- <a href="<c:url value='/manage-orders?action=add'/>" class="primary-action-btn">
                    <i class="fas fa-plus"></i> Add New Order
                </a> --%>
            </div>

            <c:if test="${not empty requestScope.successMessage}">
                <div class="alert alert-success">${requestScope.successMessage}</div>
            </c:if>
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert alert-error">${requestScope.errorMessage}</div>
            </c:if>

            <div class="search-filter-box">
                <form action="<c:url value='/manage-orders'/>" method="get" class="filter-form">
                    <input type="hidden" name="action" value="search">
                    <div class="filter-group">
                        <label for="orderId">Order ID</label>
                        <input type="text" id="orderId" name="orderId" value="${param.orderId}" placeholder="Enter Order ID...">
                    </div>
                    <div class="filter-group">
                        <label for="customerName">Customer Name</label>
                        <input type="text" id="customerName" name="customerName" value="${param.customerName}" placeholder="Enter Customer Name...">
                    </div>
                    <div class="filter-group">
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="">All Statuses</option>
                            <option value="0" ${param.status == '0' ? 'selected' : ''}>Pending</option>
                            <option value="1" ${param.status == '1' ? 'selected' : ''}>Confirmed</option>
                            <option value="2" ${param.status == '2' ? 'selected' : ''}>Shipped</option>
                            <option value="3" ${param.status == '3' ? 'selected' : ''}>Delivered</option>
                            <option value="4" ${param.status == '4' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="startDate">Order Date (From)</label>
                        <input type="date" id="startDate" name="startDate" value="${param.startDate}">
                    </div>
                    <div class="filter-group">
                        <label for="endDate">Order Date (To)</label>
                        <input type="date" id="endDate" name="endDate" value="${param.endDate}">
                    </div>
                    <div class="filter-group">
                        <label>&nbsp;</label>
                        <div style="display: flex; gap: 0.75rem;">
                            <button type="submit" class="primary-action-btn"><i class="fas fa-filter"></i> Filter</button>
                            <a href="<c:url value='/manage-orders'/>" class="secondary-action-btn">Clear Filter</a>
                        </div>
                    </div>
                </form>
            </div>

            <table class="product-table"> <%-- Giữ tên lớp .product-table để tái sử dụng CSS --%>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Order Date</th>
                        <th>Customer Name</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty ORDER_LIST}">
                        <tr><td colspan="6" style="text-align: center; padding: 3rem;">No orders found.</td></tr>
                    </c:if>
                    <c:forEach var="order" items="${ORDER_LIST}">
                        <tr>
                            <td>${order.orderID}</td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td><c:out value="${order.customerName}"/></td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 0}">
                                        <span class="status-badge status-pending">Pending</span>
                                    </c:when>
                                    <c:when test="${order.status == 1}">
                                        <span class="status-badge status-confirmed">Confirmed</span>
                                    </c:when>
                                    <c:when test="${order.status == 2}">
                                        <span class="status-badge status-shipped">Shipped</span>
                                    </c:when>
                                    <c:when test="${order.status == 3}">
                                        <span class="status-badge status-delivered">Delivered</span>
                                    </c:when>
                                    <c:when test="${order.status == 4}">
                                        <span class="status-badge status-cancelled">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge">Unknown</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-buttons">
                                <a href="<c:url value='/manage-orders?action=viewDetails&id=${order.orderID}'/>" title="View Details">
                                    <i class="fas fa-info-circle"></i>
                                </a>
                                <%-- Các nút hành động khác như "Update Status", "Cancel Order" có thể thêm vào đây --%>
                                <%-- Ví dụ: Nút để thay đổi trạng thái (chỉ cho phép nếu trạng thái chưa phải Delivered/Cancelled) --%>
                                <c:if test="${order.status != 3 && order.status != 4}">
                                    <a href="<c:url value='/manage-orders?action=updateStatus&id=${order.orderID}'/>" title="Update Status">
                                        <i class="fas fa-sync-alt"></i>
                                    </a>
                                </c:if>
                                <%-- Nút hủy đơn hàng (chỉ cho phép nếu trạng thái chưa phải Delivered/Cancelled) --%>
                                <c:if test="${order.status != 3 && order.status != 4}">
                                    <form action="<c:url value='/manage-orders'/>" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this order?');">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="id" value="${order.orderID}">
                                        <button type="submit" title="Cancel Order">
                                            <i class="fas fa-times-circle"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </section>
    </main>
</body>
</html>