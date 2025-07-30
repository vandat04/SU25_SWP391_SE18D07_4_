<%-- 
    Document   : admin-order-management
    Created on : Jul 23, 2025, 4:12:31 AM
    Author     : ACER
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Order Management</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/@popperjs/core@2"></script>
        <script src="https://unpkg.com/tippy.js@6"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            function toggleExportMenu() {
                const menu = document.getElementById("exportMenu");
                menu.classList.toggle("hidden");
            }

            // Hide menu when clicking outside
            window.addEventListener("click", function (e) {
                const menu = document.getElementById("exportMenu");
                const btn = e.target.closest("button");
                if (!menu.contains(e.target) && (!btn || btn.textContent.trim() !== 'Export')) {
                    menu.classList.add("hidden");
                }
            });
        </script>

        <style>
            .search-start {
                margin-right: 100px;
            }
        </style>
    </head>
    <body class="bg-gray-100">
        <!-- Loading Spinner Overlay -->
        <div id="loadingOverlay"
             class="fixed inset-0 z-[999] bg-black bg-opacity-30 flex items-center justify-center hidden">
            <div class="w-12 h-12 border-4 border-white border-t-transparent rounded-full animate-spin"></div>
        </div>
        <div class="flex min-h-screen">
            <jsp:include page="admin-sidebar.jsp" />
            <div class="flex-1 p-6">
                <!-- Notification -->
                <c:if test="${not empty message}">
                    <div id="notification"
                         class="fixed top-5 right-5 z-50 px-4 py-3 rounded shadow-lg text-white transition-opacity duration-500
                         ${error == '1' ? 'bg-green-500' : 'bg-red-500'}">
                        ${message}
                    </div>
                    <script>
                        setTimeout(() => {
                            const noti = document.getElementById("notification");
                            if (noti) {
                                noti.style.opacity = '0';
                                setTimeout(() => noti.remove(), 500);
                            }
                        }, 4000);
                    </script>
                </c:if>
                <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <h1 class="text-2xl font-bold mb-6">Order List</h1>

                    <div class="flex flex-col md:flex-row items-start gap-2 search-start">
                        <!-- Icon -->
                        <i id="tooltip-icon" class="bi bi-exclamation-circle-fill text-warning"></i>
                        
                        <div class="relative inline-block">
                            <!-- Export Button -->
                            <button onclick="toggleExportMenu()" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
                                Export
                            </button>
                            <!-- Dropdown Menu -->
                            <div id="exportMenu" class="hidden absolute z-10 mt-2 w-auto min-w-[12rem] max-w-md bg-white border rounded shadow-lg">
                                <!-- Submenu Title -->
                                <div class="relative group">
                                    <button class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 focus:outline-none">
                                        By Village
                                        <svg class="inline-block w-4 h-4 float-right mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                                        </svg>
                                    </button>
                                    <!-- Submenu for Villages -->
                                    <div class="hidden absolute right-full top-0 mt-0 mr-1 w-60 bg-white border rounded shadow-lg group-hover:block z-50">
                                        <c:forEach items="${listAllVillage}" var="village">
                                            <a href="export-order-pdf?cas=${village.villageID}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                ${village.villageName}
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Order Table -->
                <table class="w-full table-auto border border-gray-300 text-sm">
                    <thead class="bg-gray-200 text-center">
                        <tr>
                            <th class="p-3 border w-20">No. </th>

                            <!-- VILLAGE NAME -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Village Name</span>
                                    <button onclick="toggleMenu('villageMenu')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="villageMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-order-management?status=${status}&searchID=0"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Village</a>
                                        <c:forEach var="v" items="${listAllVillage}">
                                            <a href="admin-order-management?status=${status}&searchID=1&contentSearch=${v.villageID}"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">${v.villageName}</a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </th>

                            <!-- TOTAL PRICE -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Total Price</span>
                                    <button onclick="toggleMenu('priceMenu')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="priceMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-order-management?status=${status}&searchID=2"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort Low - High</a>
                                        <a href="admin-order-management?status=${status}&searchID=3"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort High - Low</a>
                                    </div>
                                </div>
                            </th>

                            <!-- PAYMENT METHOD -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Payment Method</span>
                                    <button onclick="toggleMenu('paymentMethod')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="paymentMethod"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-order-management?status=${status}&searchID=4"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Payment Method</a>
                                        <a href="admin-order-management?status=${status}&searchID=4&contentSearch=cod"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Cash of Delivery</a>
                                        <a href="admin-order-management?status=${status}&searchID=4&contentSearch=points"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Points</a>
                                        <a href="admin-order-management?status=${status}&searchID=4&contentSearch=bankTransfer"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Bank Transfer</a>
                                    </div>
                                </div>
                            </th>

                            <!-- PAYMENT STATUS -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Payment Status</span>
                                    <button onclick="toggleMenu('paymentStatus')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="paymentStatus"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-order-management?status=${status}&searchID=5"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Payment Status</a>
                                        <a href="admin-order-management?status=${status}&searchID=5&contentSearch=1"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Paid</a>
                                        <a href="admin-order-management?status=${status}&searchID=5&contentSearch=0"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Unpaid</a>
                                    </div>
                                </div>
                            </th>

                            <!-- ORDER STATUS -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Order Status</span>
                                    <button onclick="toggleMenu('orderStatus')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="orderStatus"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-order-management?status=7&searchID=6"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Order Status</a>
                                        <a href="admin-order-management?status=0&searchID=6&contentSearch=0"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Processing</a>
                                        <a href="admin-order-management?status=1&searchID=6&contentSearch=1"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Delivering</a>
                                        <a href="admin-order-management?status=2&searchID=6&contentSearch=2"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Received</a>
                                        <a href="admin-order-management?status=3&searchID=6&contentSearch=3"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Canceled</a>
                                        <a href="admin-order-management?status=4&searchID=6&contentSearch=4"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Refunded</a>
                                        <a href="admin-order-management?status=5&searchID=6&contentSearch=5"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Refunding</a>
                                    </div>
                                </div>
                            </th>

                            <!-- CREATED DATE -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Created Date</span>
                                    <button onclick="toggleMenu('dateMenu')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="dateMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-order-management?status=${status}&searchID=7"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort Early → Late</a>
                                        <a href="admin-order-management?status=${status}&searchID=8"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort Late → Early</a>
                                    </div>
                                </div>
                            </th>


                            <th class="p-3 border w-56">Action</th>
                        </tr>
                    </thead>
                    <tbody>
    <c:choose>
        <c:when test="${empty subOrder}">
            <tr class="text-center">
                <td colspan="8" class="p-4 text-gray-500">No orders found.</td>
            </tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${subOrder}" varStatus="loop">
                <tr class="bg-white border text-center align-middle hover:bg-gray-50">
                    <td class="p-3 border">${(currentPage - 1) * 10 + loop.index + 1}</td>
                    <td class="p-3 border">
                        <c:forEach var="v" items="${listAllVillage}">
                            <c:if test="${v.villageID == order.villageId}">
                                ${v.villageName}
                            </c:if>
                        </c:forEach>
                    </td>
                    <td class="p-2 border">
                        <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                    </td>
                    <td class="p-3 border">${order.paymentMethod}</td>
                    <td class="p-2 border">
                        <c:choose>
                            <c:when test="${order.paymentStatus == 1}">Paid</c:when>
                            <c:otherwise>Unpaid</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="p-2 border">
                        <c:choose>
                            <c:when test="${order.orderStatus == 0}">Processing</c:when>
                            <c:when test="${order.orderStatus == 1}">Delivering</c:when>
                            <c:when test="${order.orderStatus == 2}">Received</c:when>
                            <c:when test="${order.orderStatus == 3}">Canceled</c:when>
                            <c:when test="${order.orderStatus == 4}">Refunded</c:when>
                            <c:when test="${order.orderStatus == 5}">Refunding</c:when>
                            <c:otherwise>Unknown</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="p-3 border">${order.createdDate}</td>
                    <td class="p-3 border"><a href="orderDetail?subOrderId=${order.subOrderId}">View Details</a></td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</tbody>
                </table>
                <!-- Pagination -->
                <c:set var="queryParams" value="" />
                <c:if test="${not empty status}">
                    <c:set var="queryParams" value="${queryParams}&status=${status}" />
                </c:if>
                <c:if test="${not empty searchID}">
                    <c:set var="queryParams" value="${queryParams}&searchID=${searchID}" />
                </c:if>

                <div class="mt-6 flex justify-center items-center gap-2">
                    <c:if test="${currentPage > 1}">
                        <a href="admin-order-management?page=${currentPage - 1}${queryParams}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Previous</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="admin-order-management?page=${i}${queryParams}" class="px-4 py-2 ${currentPage == i ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'} rounded hover:bg-gray-300">${i}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="admin-order-management?page=${currentPage + 1}${queryParams}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Next</a>
                    </c:if>
                </div>
            </div>
        </div>
        <script>
            let currentOpenMenu = null;

            function toggleMenu(id) {
                // Đóng menu cũ nếu đang mở
                if (currentOpenMenu && currentOpenMenu !== id) {
                    document.getElementById(currentOpenMenu).classList.add("hidden");
                }

                const menu = document.getElementById(id);
                if (menu.classList.contains("hidden")) {
                    menu.classList.remove("hidden");
                    currentOpenMenu = id;
                } else {
                    menu.classList.add("hidden");
                    currentOpenMenu = null;
                }
            }

            // Tự động đóng khi click ra ngoài
            window.addEventListener('click', function (e) {
                if (!e.target.closest('th')) {
                    if (currentOpenMenu) {
                        const open = document.getElementById(currentOpenMenu);
                        open?.classList.add('hidden');
                        currentOpenMenu = null;
                    }
                }
            });
        </script>
        <script>
            // Đóng Edit Product Modal khi click ra ngoài nội dung
            document.getElementById('villageAddModal').addEventListener('click', function (event) {
                if (event.target.id === 'villageAddModal') {
                    closeEditProductModal();
                }
            });
        </script>

    </body>
</html>