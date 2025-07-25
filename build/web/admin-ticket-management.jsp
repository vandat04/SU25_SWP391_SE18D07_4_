<%-- 
    Document   : admin-ticket-management
    Created on : Jul 7, 2025, 9:03:52 PM
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
        <title>Admin - Ticket Management</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>.hidden {
                display: none;
            }</style>

        <script>
            function showTicketDetail(ticketID, villageID, typeID, price, status, createdDate, updatedDate) {
                const form = document.getElementById('detailForm');
                form.ticketID.value = ticketID;
                form.villageID.value = villageID;
                form.typeID.value = typeID;
                form.price.value = price;
                form.status.value = status;
                form.createdDate.value = createdDate;
                form.updatedDate.value = updatedDate;
                document.getElementById('modal').classList.remove('hidden');
            }

            function openAddTicketModal() {
                document.getElementById("ticketModal").classList.remove("hidden");
                document.getElementById("addTicketForm").reset();
            }

            function closeModal() {
                document.getElementById("modal").classList.add("hidden");
                document.getElementById("ticketModal").classList.add("hidden");
            }

            function confirmDelete(ticketID) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    text: "Are you sure you want to delete this ticket?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#aaa',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("deleteTicketID").value = ticketID;
                        document.getElementById("deleteForm").submit();
                    }
                });
            }
            function toggleExportMenu() {
                const menu = document.getElementById('exportMenu');
                menu.classList.toggle('hidden');
            }
        </script>
    </head>
    <body class="bg-gray-100">
        <!-- Loading Spinner Overlay -->
        <div id="loadingOverlay"
             class="fixed inset-0 z-[999] bg-black bg-opacity-30 flex items-center justify-center hidden">
            <div class="w-12 h-12 border-4 border-white border-t-transparent rounded-full animate-spin"></div>
        </div>
        <div class="flex min-h-screen">
            <jsp:include page="admin-sidebar.jsp"/>
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

                <!-- Tabs -->
                <div class="mb-4 flex gap-4">
                    <button  class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">                       
                        <a href="admin-product-management"> Products Management</a>
                    </button>
                    <button  class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
                        <a href="admin-ticket-management">  Tickets Management</a>
                    </button>
                </div>


                <div class="mb-6 flex flex-col md:flex-row md:items-center gap-4">
                    <h1 class="text-2xl font-bold mb-6">Ticket List</h1>

                    <div class="flex flex-wrap gap-2 ml-auto">
                        <!-- Filter + Search -->
                        <div class="flex justify-center mb-6">
                            <form action="admin-ticket-management" method="get" class="flex gap-2 items-center">
                                <!-- Dropdown Status -->
                                <select name="status"
                                        class="h-[42px] w-[120px] border border-gray-300 rounded px-3 py-2 text-sm">
                                    <option value="1" ${status == '1' ? 'selected' : ''}>Active</option>
                                    <option value="0" ${status == '0' ? 'selected' : ''}>Inactive</option>
                                </select>

                                <!-- Search Button -->
                                <button type="submit"
                                        class="h-[42px] w-[42px] bg-blue-600 text-white rounded hover:bg-blue-700 flex items-center justify-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                         viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"
                                         class="w-5 h-5">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                          d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 1011.5 3a7.5 7.5 0 005.15 13.65z" />
                                    </svg>
                                </button>
                            </form>
                        </div>

                        <!-- Export Button -->
                        <div class="relative inline-block">
                            <button onclick="toggleExportMenu()"
                                    class="h-[42px] w-[120px] bg-blue-600 text-white rounded hover:bg-blue-700 text-sm">
                                Export
                            </button>
                            <div id="exportMenu" class="hidden absolute z-10 mt-2 w-48 bg-white border rounded shadow-lg">
                                <a href="export-ticket-pdf?cas=1"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Ticket</a>
                                <a href="export-ticket-pdf?cas=2"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">By Ticket Type</a>
                                <a href="export-ticket-pdf?cas=3"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Inactive Ticket</a>
                            </div>
                        </div>

                        <!-- Add Ticket Button -->
                        <button onclick="openAddTicketModal()"
                                class="h-[42px] w-[120px] bg-orange-600 text-white rounded hover:bg-orange-700 text-sm">
                            Add Ticket
                        </button>
                    </div>


                </div>

                <!-- Ticket Table -->
                <table class="w-full table-auto border border-gray-300 text-sm">
                    <thead class="bg-gray-200 text-center">
                        <tr>
                            <th class="p-2 border">No. </th>

                            <!-- Ví dụ cho cột Village Name -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Village Name</span>
                                    <button data-menu-target="nameMenu" class="toggle-menu-btn text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="nameMenu" class="dropdown-menu hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-ticket-management?status=${status}&searchID=2" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Village</a>
                                        <c:forEach var="v" items="${listAllVillage}">
                                            <a href="admin-ticket-management?status=${status}&searchID=1&contentSearch=${v.villageID}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">${v.villageName}</a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </th>

                            <!-- Tương tự cho các cột Type Ticket, Price, Created Date -->
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Type Ticket</span>
                                    <button data-menu-target="typeTicketMenu" class="toggle-menu-btn text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="typeTicketMenu" class="dropdown-menu hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-ticket-management?status=${status}&searchID=4" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Ticket Type</a>
                                        <c:forEach var="t" items="${listTicketType}">
                                            <a href="admin-ticket-management?status=${status}&searchID=3&contentSearch=${t.typeID}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">${t.typeName}</a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Price</span>
                                    <button data-menu-target="priceMenu" class="toggle-menu-btn text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="priceMenu" class="dropdown-menu hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-ticket-management?status=${status}&searchID=5" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort Low - High</a>
                                        <a href="admin-ticket-management?status=${status}&searchID=6" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort High - Low</a>
                                    </div>
                                </div>
                            </th>
                            <th class="p-2 border">Status</th>
                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Created Date</span>
                                    <button data-menu-target="dateMenu" class="toggle-menu-btn text-black text-sm hover:text-blue-600 focus:outline-none">▼</button>
                                    <div id="dateMenu" class="dropdown-menu hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-ticket-management?status=${status}&searchID=7" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort Early → Late</a>
                                        <a href="admin-ticket-management?status=${status}&searchID=8" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Sort Late → Early</a>
                                    </div>
                                </div>
                            </th>

                            <th class="p-2 border">Updated Date</th>
                            <th class="p-2 border">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ticket" items="${listTicket}" varStatus="loop">
                            <tr class="bg-white border text-center">
                                <td class="p-3 border">${loop.index + 1}</td> <!-- Số thứ tự -->
                                <td class="p-2 border">
                                    <c:forEach var="v" items="${listAllVillage}">
                                        <c:if test="${v.villageID == ticket.villageID}">
                                            ${v.villageName}
                                        </c:if>
                                    </c:forEach>
                                </td>

                                <td class="p-2 border">
                                    <c:forEach var="t" items="${listTicketType}">
                                        <c:if test="${t.typeID == ticket.typeID}">
                                            ${t.typeName}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td class="p-2 border">
                                    <fmt:formatNumber value="${ticket.price}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                </td>
                                <td class="p-2 border">
                                    <c:choose>
                                        <c:when test="${ticket.status == 1}">Active</c:when>
                                        <c:otherwise>Inactive</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="p-2 border">${ticket.createdDate}</td>
                                <td class="p-2 border">${ticket.updatedDate}</td>
                                <td class="p-2 border">
                                    <button class="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-700"
                                            onclick="showTicketDetail(
                                                            '${ticket.ticketID}',
                                                            '${ticket.villageID}',
                                                            '${ticket.typeID}',
                                                            '${ticket.price}',
                                                            '${ticket.status}',
                                                            '${ticket.createdDate}',
                                                            '${ticket.updatedDate}')">
                                        View Details
                                    </button>
                                    <c:if test="${ticket.status == 1}">
                                        <button class="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-700"
                                                onclick="confirmDelete('${ticket.ticketID}')">
                                            Delete
                                        </button>
                                    </c:if>
                                    <form id="deleteForm" method="post" action="admin-ticket-management" style="display:none;">
                                        <input type="hidden" name="typeName" value="deleteTicket">
                                        <input type="hidden" name="ticketID" id="deleteTicketID">
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <!-- Pagination -->
                <div class="mt-4 flex justify-center gap-2">
                    <c:forEach begin="1" end="${totalPage}" var="i">
                        <a href="admin-ticket-management?status=${status}&page=${i}"
                           class="px-3 py-1 border rounded ${i == currentPage ? 'bg-blue-600 text-white' : 'bg-white text-black'} hover:bg-blue-500 hover:text-white">
                            ${i}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Modal: Ticket Details -->
        <div id="modal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-xl relative text-black">
                <h2 class="text-xl font-semibold mb-4">Ticket Details</h2>
                <form id="detailForm" action="admin-ticket-management" method="post" class="space-y-4">
                    <input type="hidden" name="status" value="${status}"/>
                    <input type="hidden" name="typeName" value="updateTicket"/>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label>Ticket ID</label>
                            <input type="text" name="ticketID" class="w-full border p-2 bg-gray-100" readonly/>
                        </div>
                        <div>
                            <label>Village</label>
                            <select name="villageID" class="w-full border p-2 bg-gray-100" id="villageID"  disabled>
                                <c:forEach var="village" items="${listAllVillage}">
                                    <option value="${village.villageID}">${village.villageName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label>Type</label>
                            <select name="typeID" class="w-full border p-2 bg-gray-100" id="typeID"  disabled >
                                <c:forEach var="type" items="${listTicketType}">
                                    <option value="${type.typeID}">${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>  
                        <div>
                            <label>Price (d)</label>
                            <input type="currency" name="price" class="w-full border p-2" step="0.01" min="0" required/>
                        </div>
                        <div>
                            <label>Status</label>
                            <select name="statusTicket" class="w-full border rounded p-2">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                        <div>
                            <label>Created Date</label>
                            <input type="text" name="createdDate" class="w-full border p-2 bg-gray-100" readonly/>
                        </div>
                        <div>
                            <label>Updated Date</label>
                            <input type="text" name="updatedDate" class="w-full border p-2 bg-gray-100" readonly/>
                        </div>
                    </div>
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" onclick="closeModal()"
                                class="bg-gray-500 text-white px-4 py-2 rounded">Close
                        </button>
                        <button type="submit"
                                class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal: Add Ticket -->
        <div id="ticketModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" onclick="closeModal()">
            <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-xl relative text-black" onclick="event.stopPropagation()">
                <h2 class="text-xl font-semibold mb-4">Add New Ticket</h2>
                <form id="addTicketForm" action="admin-ticket-management" method="post" class="space-y-4">
                    <input type="hidden" name="status" value="${status}"/>
                    <input type="hidden" name="typeName" value="createTicket"/>
                    <div class="grid grid-cols-2 gap-4">            
                        <div>
                            <label>Village</label>
                            <select name="villageID" class="w-full border p-2" id="villageID" required>
                                <c:forEach var="village" items="${listAllVillage}">
                                    <option value="${village.villageID}">${village.villageName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label>Type</label>
                            <select name="typeID" class="w-full border p-2" id="typeID" required>
                                <c:forEach var="type" items="${listTicketType}">
                                    <option value="${type.typeID}">${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label>Price (đ)</label>
                            <input type="currency" name="price" class="w-full border p-2" step="0.01" min="0" required/>
                        </div>
                        <div>
                            <label>Status</label>
                            <select name="status" class="w-full border p-2" required>
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="flex justify-end gap-2 pt-4">
                        <button type="button" onclick="closeModal()"
                                class="bg-gray-500 text-white px-4 py-2 rounded">Close
                        </button>
                        <button type="submit"
                                class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Create
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <!-- Ticket Modal -->
        <div id="ticketModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden">
            <div class="bg-white p-6 rounded shadow-md w-full max-w-lg">
                <!-- Nội dung modal -->
                <p>Ticket content here...</p>
                <button onclick="closeTicketModal()" class="mt-4 px-4 py-2 bg-gray-500 text-white rounded">Close</button>
            </div>
        </div>
        <script>
            // Toggle menu logic for all dropdowns
            document.querySelectorAll('.toggle-menu-btn').forEach(button => {
                button.addEventListener('click', function (e) {
                    e.stopPropagation(); // Ngăn sự kiện nổi bọt
                    const targetId = this.getAttribute('data-menu-target');
                    const menu = document.getElementById(targetId);

                    // Đóng các menu khác
                    document.querySelectorAll('.dropdown-menu').forEach(m => {
                        if (m !== menu)
                            m.classList.add('hidden');
                    });

                    // Toggle menu hiện tại
                    if (menu)
                        menu.classList.toggle('hidden');
                });
            });

            // Đóng menu khi click ra ngoài
            window.addEventListener('click', function () {
                document.querySelectorAll('.dropdown-menu').forEach(menu => menu.classList.add('hidden'));
            });
        </script>

        <script>
            document.querySelectorAll("form").forEach(form => {
                form.addEventListener("submit", () => {
                    document.getElementById("loadingOverlay").classList.remove("hidden");
                });
            });

            // Cũng có thể áp dụng khi click vào link có href (ví dụ đổi trang, export PDF…)
            document.querySelectorAll("a").forEach(link => {
                link.addEventListener("click", e => {
                    const href = link.getAttribute("href");
                    if (href && !href.startsWith("#") && !href.startsWith("javascript") &&  !href.includes("export-ticket-pdf")) {
                        document.getElementById("loadingOverlay").classList.remove("hidden");
                    }
                });
            });
        </script>
        <script>
            // Đóng modal khi click ra ngoài nội dung của modal
            function setupModalClose(modalId, closeFunction) {
                const modal = document.getElementById(modalId);
                if (modal) {
                    modal.addEventListener('click', function (event) {
                        // Nếu click đúng vào phần nền đen (chính modal), thì đóng
                        if (event.target === modal) {
                            closeFunction();
                        }
                    });
                }
            }

            // Hàm đóng modal chỉnh sửa village
            function closeEditVillageModal() {
                document.getElementById('ticketModal').classList.add('hidden');
            }

            // Hàm đóng modal thêm village
            function closeAddVillageModal() {
                document.getElementById('modal').classList.add('hidden');
            }

            // Gán sự kiện đóng cho từng modal
            setupModalClose('ticketModal', closeEditVillageModal);
            setupModalClose('modal', closeAddVillageModal);
        </script>

    </body>
</html>