<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.time.LocalDate"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="entity.SalesReport.SalesReport"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="entity.Account.Account"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistics & Analysis</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: var(--font-body);
            background-color: var(--background-color);
            color: var(--primary-text);
            display: flex;
            min-height: 100vh;
        }

        /* --- Sidebar --- */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; }
        .sidebar-logo { padding: 1.5rem 2rem; text-align: center; border-bottom: 1px solid var(--border-color); }
        .sidebar-logo img { max-width: 80%; height: auto; }
        .sidebar-profile { text-align: center; padding: 2rem 1rem; }
        .sidebar-profile .avatar { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid var(--accent-color); margin-bottom: 1rem; }
        .sidebar-profile h3 { font-family: var(--font-heading); font-size: 1.2rem; margin-bottom: 0.25rem; }
        .sidebar-profile p { font-size: 0.9rem; color: #999; }
        .sidebar-nav { list-style-type: none; flex-grow: 1; margin-top: 1rem; }
        .sidebar-nav a { display: flex; align-items: center; padding: 1rem 2rem; color: var(--primary-text); text-decoration: none; font-weight: 500; transition: background-color 0.2s, color 0.2s; border-left: 4px solid transparent; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background-color: var(--background-color); color: var(--accent-color); border-left-color: var(--accent-color); }
        .sidebar-nav a i { width: 25px; margin-right: 1rem; font-size: 1.1rem; text-align: center; }
        .sidebar-logout { padding: 1rem 0; border-top: 1px solid var(--border-color); }
        .sidebar-logout a { text-decoration: none; color: var(--primary-text); }

        /* --- Main Content --- */
        .main-content { flex-grow: 1; padding: 2rem 3rem; overflow-y: auto; }
        .main-header { margin-bottom: 2rem; }
        .main-header h1 { font-family: var(--font-heading); font-size: 2.5rem; font-weight: 700; }
        .main-header p { color: var(--secondary-text); font-size: 1rem; } /* Added for header description */

        /* --- Statistics Cards --- */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2.5rem; }
        .stat-card { background: #fff; border: 1px solid var(--border-color); border-radius: 10px; padding: 1.5rem; display: flex; align-items: flex-start; gap: 1rem; }
        .stat-card .icon { font-size: 2rem; color: var(--accent-color); background: var(--background-color); padding: 0.8rem; border-radius: 50%; width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; }
        .stat-card .info .title { font-size: 0.9rem; color: var(--secondary-text); margin-bottom: 0.5rem; }
        .stat-card .info .value { font-size: 1.8rem; font-weight: 700; }

        /* --- Charts --- */
        .chart-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; }
        .chart-container { background: #fff; padding: 2rem; border-radius: 10px; border: 1px solid var(--border-color); }
        .chart-title { font-family: var(--font-heading); font-size: 1.4rem; margin-bottom: 1.5rem; }

        .top-products-list { list-style: none; }
        .top-products-list li { display: flex; justify-content: space-between; padding: 0.8rem 0; border-bottom: 1px solid #f0f0f0; }
        .top-products-list li:last-child { border-bottom: none; }
        .top-products-list .product-name { font-weight: 500; }
        .top-products-list .quantity { font-weight: 700; color: var(--accent-color); }

        /* General sections for other stats */
        .section { margin-bottom: 30px; border: 1px solid var(--border-color); padding: 15px; border-radius: 10px; background-color: #fff; }
        .section h2 { font-family: var(--font-heading); font-size: 1.8rem; margin-bottom: 1rem; }
        .section h3 { font-family: var(--font-body); font-size: 1.2rem; margin-top: 1.5rem; margin-bottom: 0.8rem; color: var(--accent-color); }
        .section p, .section ul { margin-bottom: 1rem; }
        .section ul { list-style-type: none; padding-left: 0; }
        .section ul li { padding: 0.3rem 0; }

        .error-message { color: var(--error-text); font-weight: bold; margin-bottom: 1rem; padding: 10px; border: 1px solid var(--error-border); background-color: var(--error-bg); border-radius: 5px; }
        .alert-success { background-color: var(--success-bg); border-color: var(--success-border); color: var(--success-text); padding: 1rem; border-radius: 8px; margin-bottom: 1rem; }
        .alert-error { background-color: var(--error-bg); border-color: var(--error-border); color: var(--error-text); padding: 1rem; border-radius: 8px; margin-bottom: 1rem; }

        /* Specific styles for tables within sections */
        .section table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .section th, .section td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .section th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-logo"><a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/hinhanh/Logo/logocraft.png" alt="Craft Village Logo"></a></div>
        <c:if test="${not empty sessionScope.acc}">
            <div class="sidebar-profile">
                <img src="https://i.pravatar.cc/150?u=${sessionScope.acc.userID}" alt="Artisan Avatar" class="avatar">
                <h3>${sessionScope.acc.userName}</h3>
                <p><c:choose>
                    <c:when test="${sessionScope.acc.roleID == 1}">Administrator</c:when>
                    <c:when test="${sessionScope.acc.roleID == 2}">Artisan</c:when>
                    <c:otherwise>User</c:otherwise>
                </c:choose></p>
            </div>
        </c:if>
        <ul class="sidebar-nav">
            <c:if test="${sessionScope.acc.roleID == 1}">
                <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/manageAccount"><i class="fas fa-users"></i> Account Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/managePost"><i class="fas fa-file-alt"></i> Post Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/manageOrder"><i class="fas fa-receipt"></i> Order Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/viewFeedbacks"><i class="fas fa-comments"></i> Feedback Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/approveAccount"><i class="fas fa-user-check"></i> Account Approval</a></li>
                <li><a href="${pageContext.request.contextPath}/statistics" class="active"><i class="fas fa-chart-pie"></i> Statistics</a></li> <%-- Set active for statistics page if admin --%>
            </c:if>
            <c:if test="${sessionScope.acc.roleID == 2}">
                <li><a href="seller" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="manageProduct"><i class="fas fa-palette"></i> Product Management</a></li>
                <li><a href="manage-villages"><i class="fas fa-landmark"></i> Village Management</a></li>
                <li><a href="order-management"><i class="fas fa-receipt"></i> Order Management</a></li>
                <li><a href="feedback-management"><i class="fas fa-comments"></i> Feedback Management</a></li>
                <li><a href="statistics"><i class="fas fa-chart-pie"></i> Statistics</a></li>
                <li><a href="contact"><i class="fas fa-headset"></i> Contact & Support</a></li>
            </c:if>
        </ul>
        <div class="sidebar-logout"><a href="${pageContext.request.contextPath}/logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Logout</a></div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Statistics & Analysis</h1>
            <p>Overview of your website's performance and seller data.</p>
        </header>

        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <div class="section">
            <h2>Overall Website Statistics</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                    <div class="info">
                        <div class="title">TOTAL REVENUE TODAY</div>
                        <div class="value"><fmt:formatNumber value="${todayTotalRevenue}" type="currency" currencyCode="VND" /></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="icon"><i class="fas fa-user-plus"></i></div>
                    <div class="info">
                        <div class="title">NEW REGISTRATIONS TODAY</div>
                        <%-- Assuming dailyRegistrations is Map<Integer, Integer> {dayOfMonth: count} --%>
                        <c:set var="todayDay" value="<%= LocalDate.now().getDayOfMonth() %>" />
                        <div class="value">${dailyRegistrations[todayDay] != null ? dailyRegistrations[todayDay] : 0}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="icon"><i class="fas fa-boxes"></i></div>
                    <div class="info">
                        <div class="title">NEW POSTS TODAY</div>
                        <%-- Summing up product, ticket, craft posts for today --%>
                        <div class="value">${productPostsToday + ticketPostsToday + craftPostsToday}</div>
                    </div>
                </div>
            </div>

            <div class="chart-grid" style="grid-template-columns: 1fr;"> <%-- Change to 1 column for full width charts --%>
                <div class="chart-container">
                    <h3 class="chart-title">Monthly Revenue (Year <c:out value="${currentYear}"/>)</h3>
                    <canvas id="monthlyRevenueChart"></canvas>
                </div>
                <div class="chart-container">
                    <h3 class="chart-title">Overall Order Status Summary</h3>
                    <canvas id="overallOrderStatusChart"></canvas>
                </div>
                <div class="chart-container">
                    <h3 class="chart-title">Monthly Account Registrations (<c:out value="${currentYear}"/>)</h3>
                    <canvas id="monthlyRegistrationChart"></canvas>
                </div>
            </div>
            <div class="section" style="margin-top: 2rem;">
                <h3 class="chart-title">Top 5 Best-Selling Products (System-wide)</h3>
                <ul class="top-products-list">
                    <c:forEach var="productArray" items="${topProducts}">
                        <li>
                            <span class="product-name">${productArray[0]}</span> <%-- Assuming productArray[0] is productName --%>
                            <span class="quantity">${productArray[1]} sold</span> <%-- Assuming productArray[1] is totalQuantitySold --%>
                        </li>
                    </c:forEach>
                    <c:if test="${empty topProducts}">
                        <li>No data available for best-selling products.</li>
                    </c:if>
                </ul>
            </div>
        </div>

        <c:if test="${sessionScope.acc.roleID == 2}">
            <div class="section" style="margin-top: 3rem;">
                <h2>Your Statistics (Artisan)</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                        <div class="info">
                            <div class="title">YOUR REVENUE TODAY</div>
                            <div class="value"><fmt:formatNumber value="${sellerDailyRevenue}" type="currency" currencyCode="VND" /></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-receipt"></i></div>
                        <div class="info">
                            <div class="title">YOUR TOTAL ORDERS</div>
                            <%-- Calculate total seller orders from Map --%>
                            <c:set var="totalSellerOrders" value="0"/>
                            <c:forEach items="${sellerOrderCounts}" var="entry">
                                <c:set var="totalSellerOrders" value="${totalSellerOrders + entry.value}"/>
                            </c:forEach>
                            <div class="value">${totalSellerOrders}</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="icon"><i class="fas fa-check-circle"></i></div>
                        <div class="info">
                            <div class="title">COMPLETED ORDERS</div>
                            <div class="value">${sellerOrderCounts['Hoàn thành'] != null ? sellerOrderCounts['Hoàn thành'] : 0}</div>
                        </div>
                    </div>
                </div>

                <div class="chart-grid" style="grid-template-columns: 1fr;">
                    <div class="chart-container">
                        <h3 class="chart-title">Your Monthly Revenue Report</h3>
                        <canvas id="sellerMonthlyRevenueChart"></canvas>
                    </div>
                    <div class="chart-container">
                        <h3 class="chart-title">Your Order Status</h3>
                        <canvas id="sellerOrderStatusChart"></canvas>
                    </div>
                </div>

                <div class="section" style="margin-top: 2rem;">
                    <h3>Your Detailed Revenue Reports</h3>
                    <c:if test="${not empty sellerMonthlySalesReports}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Report ID</th>
                                    <th>Month/Year</th>
                                    <th>Total Orders</th>
                                    <th>Total Revenue</th>
                                    <th>Commission</th>
                                    <th>Net Revenue</th>
                                    <th>Creation Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${sellerMonthlySalesReports}" var="report">
                                    <tr>
                                        <td><c:out value="${report.reportID}"/></td>
                                        <td><c:out value="${report.reportMonth}"/>/<c:out value="${report.reportYear}"/></td>
                                        <td><c:out value="${report.totalOrders}"/></td>
                                        <td><fmt:formatNumber value="${report.totalRevenue}" type="currency" currencyCode="VND" /></td>
                                        <td><fmt:formatNumber value="${report.commission}" type="currency" currencyCode="VND" /></td>
                                        <td><fmt:formatNumber value="${report.netRevenue}" type="currency" currencyCode="VND" /></td>
                                        <td><fmt:formatDate value="${report.generatedDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                    <c:if test="${empty sellerMonthlySalesReports}">
                        <p>No monthly revenue reports available for you.</p>
                    </c:if>
                </div>
            </div>
        </c:if>

    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Check for error message and display if present
            const errorMessageElement = document.querySelector('.error-message');
            if (errorMessageElement && errorMessageElement.textContent.trim() !== '') {
                console.error("Error on page: " + errorMessageElement.textContent.trim());
            }

            // --- Overall Website Statistics Charts ---

            // Monthly Revenue Chart (for the current year)
            const monthlyRevenueLabels = [];
            const monthlyRevenueValues = [];
            // Assuming monthlyRevenueCurrentYear is Map<Integer, BigDecimal>
            <c:forEach var="entry" items="${monthlyRevenueCurrentYear}">
                monthlyRevenueLabels.push('Month ' + ${entry.key}); // Month number
                monthlyRevenueValues.push(${entry.value});
            </c:forEach>

            const monthlyRevenueCtx = document.getElementById('monthlyRevenueChart').getContext('2d');
            new Chart(monthlyRevenueCtx, {
                type: 'bar',
                data: {
                    labels: monthlyRevenueLabels,
                    datasets: [{
                        label: 'Revenue',
                        data: monthlyRevenueValues,
                        backgroundColor: 'rgba(140, 109, 70, 0.7)',
                        borderColor: '#8c6d46',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value, index, values) {
                                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                                }
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });

            // Overall Order Status Chart (Doughnut Chart)
            const overallOrderStatusLabels = [];
            const overallOrderStatusValues = [];
            const orderStatusColors = {
                1: '#FF6384', // Pending Confirmation
                2: '#36A2EB', // Confirmed
                3: '#FFCD56', // Delivering
                4: '#4BC0C0', // Completed
                5: '#9966FF', // Cancelled
                6: '#FF9933'  // Returned
            };
            const orderStatusNames = {
                1: 'Pending Confirmation',
                2: 'Confirmed',
                3: 'Delivering',
                4: 'Completed',
                5: 'Cancelled',
                6: 'Returned'
            };

            // Assuming overallOrderStatusSummary is Map<Integer, Integer> {statusId: count}
            <c:forEach var="entry" items="${overallOrderStatusSummary}">
                overallOrderStatusLabels.push(orderStatusNames[${entry.key}] || 'Unknown Status ' + ${entry.key});
                overallOrderStatusValues.push(${entry.value});
            </c:forEach>

            const overallOrderStatusCtx = document.getElementById('overallOrderStatusChart').getContext('2d'); // Changed ID here
            new Chart(overallOrderStatusCtx, {
                type: 'doughnut',
                data: {
                    labels: overallOrderStatusLabels,
                    datasets: [{
                        data: overallOrderStatusValues,
                        backgroundColor: overallOrderStatusLabels.map(label => orderStatusColors[Object.keys(orderStatusNames).find(key => orderStatusNames[key] === label)] || '#CCCCCC'),
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed !== null) {
                                        label += context.parsed;
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });

            // Monthly Registration Chart
            const monthlyRegistrationLabels = [];
            const monthlyRegistrationValues = [];
            // Assuming monthlyRegistrationSummary is Map<Integer, Integer> {month: count}
            <c:forEach var="entry" items="${monthlyRegistrationSummary}">
                monthlyRegistrationLabels.push('Month ' + ${entry.key});
                monthlyRegistrationValues.push(${entry.value});
            </c:forEach>

            const monthlyRegistrationCtx = document.getElementById('monthlyRegistrationChart').getContext('2d');
            new Chart(monthlyRegistrationCtx, {
                type: 'bar',
                data: {
                    labels: monthlyRegistrationLabels,
                    datasets: [{
                        label: 'Number of Registrations',
                        data: monthlyRegistrationValues,
                        backgroundColor: 'rgba(75, 192, 192, 0.7)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0 // Ensure integer ticks
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });


            // --- Seller Specific Charts (if logged in as seller) ---
            <c:if test="${sessionScope.acc.roleID == 2}">
                // Seller Monthly Revenue Chart
                const sellerMonthlyRevenueLabels = [];
                const sellerMonthlyRevenueValues = [];
                // Assuming sellerMonthlySalesReports is List<SalesReport>
                <c:forEach var="report" items="${sellerMonthlySalesReports}">
                    sellerMonthlyRevenueLabels.push('Month ' + ${report.reportMonth} + '/' + ${report.reportYear});
                    sellerMonthlyRevenueValues.push(${report.netRevenue}); // Or totalRevenue, depending on what you want to chart
                </c:forEach>

                const sellerMonthlyRevenueCtx = document.getElementById('sellerMonthlyRevenueChart').getContext('2d');
                new Chart(sellerMonthlyRevenueCtx, {
                    type: 'line',
                    data: {
                        labels: sellerMonthlyRevenueLabels,
                        datasets: [{
                            label: 'Your Net Revenue',
                            data: sellerMonthlyRevenueValues,
                            borderColor: '#8c6d46',
                            backgroundColor: 'rgba(140, 109, 70, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value, index, values) {
                                        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed.y !== null) {
                                            label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });

                // Seller Order Status Chart (Doughnut Chart)
                const sellerOrderStatusLabels = [];
                const sellerOrderStatusValues = [];
                // Assuming sellerOrderCounts is Map<String, Integer>
                <c:forEach var="entry" items="${sellerOrderCounts}">
                    sellerOrderStatusLabels.push(entry.key); // 'Hoàn thành', 'Đang giao hàng', etc.
                    sellerOrderStatusValues.push(entry.value);
                </c:forEach>

                const sellerOrderStatusCtx = document.getElementById('sellerOrderStatusChart').getContext('2d');
                new Chart(sellerOrderStatusCtx, {
                    type: 'doughnut',
                    data: {
                        labels: sellerOrderStatusLabels,
                        datasets: [{
                            data: sellerOrderStatusValues,
                            backgroundColor: sellerOrderStatusLabels.map(label => {
                                // Map string status to a color. You might need a more robust mapping.
                                if (label === 'Chờ xác nhận') return '#FF6384'; // Pending Confirmation
                                if (label === 'Đã xác nhận') return '#36A2EB'; // Confirmed
                                if (label === 'Đang giao hàng') return '#FFCD56'; // Delivering
                                if (label === 'Hoàn thành') return '#4BC0C0'; // Completed
                                if (label === 'Đã hủy') return '#9966FF'; // Cancelled
                                if (label === 'Trả hàng') return '#FF9933'; // Returned
                                return '#CCCCCC'; // Default color
                            }),
                            hoverOffset: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        let label = context.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed !== null) {
                                            label += context.parsed;
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            </c:if>
        });
    </script>
</body>
</html>