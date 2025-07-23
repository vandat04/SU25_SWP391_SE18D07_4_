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

                        <form action="admin-order-management" method="get" class="flex flex-wrap gap-2 items-center">
                            <select name="status" class="border border-gray-300 rounded px-3 py-2 text-sm w-40">
                                <option value="7" ${status == 7 ? 'selected' : ''}>All Status</option>
                                <option value="0" ${status == 0 ? 'selected' : ''}>Processing</option>
                                <option value="1" ${status == 1 ? 'selected' : ''}>Delivering</option>
                                <option value="2" ${status == 2 ? 'selected' : ''}>Received</option>
                                <option value="3" ${status == 3 ? 'selected' : ''}>Canceled</option>
                                <option value="4" ${status == 4 ? 'selected' : ''}>Refunded</option>
                                <option value="5" ${status == 5 ? 'selected' : ''}>Refunding</option>
                            </select>

                            <select name="searchID" class="border border-gray-300 rounded px-3 py-2 text-sm w-40">
                                <option value="0" ${searchID == 0 ? 'selected' : ''}>All Village</option>
                                <c:forEach var="type" items="${listAllVillage}">
                                    <option value="${type.villageID}" ${searchID == type.villageID ? 'selected' : ''}>${type.villageName}</option>
                                </c:forEach>
                            </select>

                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                                Search
                            </button>
                        </form>

                        <div class="relative inline-block">
                            <!-- Export Button -->
                            <button onclick="toggleExportMenu()" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
                                Export
                            </button>
                            <!-- Dropdown Menu -->
                            <div id="exportMenu" class="hidden absolute z-10 mt-2 w-auto min-w-[12rem] max-w-md bg-white border rounded shadow-lg">
                                <!-- Summary Option -->
                                <a href="export-order-pdf?cas=0" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    Summary
                                </a>
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
                            <th class="p-3 border w-20">Order ID</th>
                            <th class="p-3 border w-24">Village</th>
                            <th class="p-3 border w-48">Total Price</th>
                            <th class="p-3 border w-32">Payment Method</th>
                            <th class="p-3 border w-24">Payment Status</th>
                            <th class="p-3 border w-56">Order Status</th>
                            <th class="p-3 border w-56">Created Date</th>
                            <th class="p-3 border w-56">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${subOrder}">
                            <tr class="bg-white border text-center align-middle hover:bg-gray-50">
                                <td class="p-3 border">${order.subOrderId}</td>
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
    </body>
</html>