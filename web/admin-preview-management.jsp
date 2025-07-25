<%-- 
    Document   : admin-preview-management
    Created on : Jul 8, 2025, 10:49:28 PM
    Author     : ACER
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Craft Review Page</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function toggleResponseForm(id) {
                const form = document.getElementById('responseForm-' + id);
                if (form) {
                    form.classList.toggle('hidden');
                }
            }

            function confirmDeleteReview(id) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    text: "Are you sure you want to delete this review?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#aaa',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("deleteReviewID").value = id;
                        document.getElementById("deleteForm").submit();
                    }
                });
            }
        </script>
    </head>
    <body>
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
                         ${error == '1' || error == '3' || error =='5' ? 'bg-green-500' : 'bg-red-500'}">
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

                <!-- Title, Back, and Search -->
                <div class="flex flex-col md:flex-row md:items-center md:justify-between w-full mb-6 gap-4">
                    <!-- Left side -->
                    <div class="flex items-center gap-4">
                        <a href="admin-product-management"
                           class="text-gray-500 hover:text-gray-700 underline text-sm">
                            ← Back
                        </a>
                        <h1 class="text-2xl font-bold">${name} Review List (New: ${listReviewToday.size()})</h1>
                    </div>
                </div>

                <!-- Review Table -->
                <div class="overflow-x-auto">
                    <table class="w-full table-auto border border-gray-300 text-sm">
                        <thead class="bg-gray-200 text-center">
                            <tr>
                                <th class="p-2 border">No.</th>
                                <th class="p-2 border">User ID</th>

                                <th class="p-3 border w-48 bg-[#e4e6e9]">
                                    <div class="relative inline-flex items-center space-x-1">
                                        <span class="text-sm font-semibold text-black">Rating</span>
                                        <button onclick="toggleMenu('ratingMenu')"
                                                class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                            ▼
                                        </button>

                                        <!-- Dropdown menu -->
                                        <div id="ratingMenu"
                                             class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                            <a href="admin-preview-management?pid=${pid}&searchID=1"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                Sort Low - High
                                            </a>
                                            <a href="admin-preview-management?pid=${pid}&searchID=2"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                Sort High - Low
                                            </a>
                                        </div>
                                    </div>
                                </th>

                                <th class="p-2 border">Text</th>
                                <th class="p-2 border">Image</th>
                                <th class="p-3 border w-48 bg-[#e4e6e9]">
                                    <div class="relative inline-flex items-center space-x-1">
                                        <span class="text-sm font-semibold text-black">Date</span>
                                        <button onclick="toggleMenu('dateMenu')"
                                                class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                            ▼
                                        </button>

                                        <!-- Dropdown menu -->
                                        <div id="dateMenu"
                                             class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                            <a href="admin-preview-management?pid=${pid}&searchID=3"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                Sort Early → Late
                                            </a>
                                            <a href="admin-preview-management?pid=${pid}&searchID=4"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                Sort Late → Early
                                            </a>
                                        </div>
                                    </div>
                                </th>

                                <th class="p-2 border">Response</th>
                                <th class="p-2 border">Response Date</th>
                                <th class="p-2 border">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${listPReview}" varStatus="loop">
                                <tr class="bg-white border text-center align-top">
                                    <td class="p-3 border">${loop.index + 1}</td> <!-- Số thứ tự -->
                                    <td class="p-2 border">${r.userID}</td>
                                    <td class="p-2 border">${r.rating} ⭐</td>
                                    <td class="p-2 border whitespace-pre-line text-left">${r.reviewText}</td>
                                    <td class="p-3 border">
                                        <img src="${r.pictureUrl}" alt="Image" class="w-20 h-20 object-cover mx-auto rounded" />
                                    </td>
                                    <td class="p-2 border">${r.reviewDate}</td>
                                    <td class="p-2 border whitespace-pre-line text-left text-green-700">${r.response}</td>
                                    <td class="p-2 border">${r.responseDate}</td>
                                    <td class="p-2 border">
                                        <div class="flex flex-col gap-1">
                                            <!-- Respond -->
                                            <button type="button"
                                                    class="bg-yellow-500 text-white px-2 py-1 rounded hover:bg-yellow-600"
                                                    onclick="toggleResponseForm('${r.reviewID}')">
                                                Respond
                                            </button>

                                            <!-- Delete -->
                                            <button type="button"
                                                    class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-700"
                                                    onclick="confirmDeleteReview('${r.reviewID}')">
                                                Delete
                                            </button>

                                            <!-- Respond Form -->
                                            <form id="responseForm-${r.reviewID}" method="post"
                                                  action="admin-preview-management" class="hidden mt-2 space-y-2">
                                                <input type="hidden" name="pid" value="${pid}"/>
                                                <input type="hidden" name="name" value="${name}"/>
                                                <input type="hidden" name="typeName" value="respondReview"/>
                                                <input type="hidden" name="reviewID" value="${r.reviewID}"/>
                                                <textarea name="responseText" placeholder="Enter response..."
                                                          class="w-full border rounded p-2 text-sm"></textarea>
                                                <button type="submit"
                                                        class="bg-blue-600 text-white px-2 py-1 rounded hover:bg-blue-800">
                                                    Submit
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                                               <!-- Pagination -->
<div class="mt-6 flex justify-center items-center gap-2">
    <c:if test="${currentPage > 1}">
        <a href="admin-preview-management?pid=${pid}&name=${name}&searchID=${searchID}&page=${currentPage - 1}"
           class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Previous</a>
    </c:if>

    <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="admin-preview-management?pid=${pid}&name=${name}&searchID=${searchID}&page=${i}"
           class="px-4 py-2 ${currentPage == i ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'} rounded hover:bg-gray-300">
            ${i}
        </a>
    </c:forEach>

    <c:if test="${currentPage < totalPages}">
        <a href="admin-preview-management?pid=${pid}&name=${name}&searchID=${searchID}&page=${currentPage + 1}"
           class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Next</a>
    </c:if>
</div>
                </div>

                <!-- Hidden Delete Form -->
                <form id="deleteForm" method="post" action="admin-preview-management" style="display: none;">
                    <input type="hidden" name="pid" value="${pid}"/>
                    <input type="hidden" name="name" value="${name}"/>
                    <input type="hidden" name="typeName" value="deleteReview"/>
                    <input type="hidden" name="reviewID" id="deleteReviewID"/>
                </form>
            </div>
        </div>
        <script>
            function toggleMenu(menuId) {
                const menus = document.querySelectorAll('.absolute.z-10');
                menus.forEach(menu => {
                    if (menu.id !== menuId) {
                        menu.classList.add('hidden');
                    }
                });
                const targetMenu = document.getElementById(menuId);
                if (targetMenu) {
                    targetMenu.classList.toggle('hidden');
                }
            }

            // Optional: Đóng menu nếu click ra ngoài
            window.addEventListener('click', function (e) {
                const ratingMenu = document.getElementById('ratingMenu');
                const button = e.target.closest('button');
                const insideMenu = e.target.closest('#ratingMenu');
                if (!insideMenu && (!button || !button.onclick?.toString().includes('toggleMenu'))) {
                    ratingMenu?.classList.add('hidden');
                }
            });
        </script>
        <script>
            function toggleMenu(menuId) {
                const menus = document.querySelectorAll('.absolute.z-10');
                menus.forEach(menu => {
                    if (menu.id !== menuId) {
                        menu.classList.add('hidden');
                    }
                });
                const targetMenu = document.getElementById(menuId);
                if (targetMenu) {
                    targetMenu.classList.toggle('hidden');
                }
            }

            // Đóng menu nếu click ra ngoài
            window.addEventListener('click', function (e) {
                const isMenuToggle = e.target.closest('button')?.onclick?.toString().includes('toggleMenu');
                const insideAnyMenu = e.target.closest('.absolute.z-10');
                if (!insideAnyMenu && !isMenuToggle) {
                    document.querySelectorAll('.absolute.z-10').forEach(menu => menu.classList.add('hidden'));
                }
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
                    if (href && !href.startsWith("#") && !href.startsWith("javascript")) {
                        document.getElementById("loadingOverlay").classList.remove("hidden");
                    }
                });
            });
        </script>

    </body>
</html>
