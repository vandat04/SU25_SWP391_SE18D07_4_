<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Craft Village Management</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/@popperjs/core@2"></script>
        <script src="https://unpkg.com/tippy.js@6"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function confirmDelete(villageID) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    text: "Are you sure you want to delete this village?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#aaa',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("deleteVillageID").value = villageID;
                        document.getElementById("deleteForm").submit();
                    }
                });
            }

            function toggleExportMenu() {
                const menu = document.getElementById('exportMenu');
                menu.classList.toggle('hidden');
            }

            // Hide all menus when clicking outside (except for export)
            window.addEventListener('click', function (e) {
                const isMenuButton = e.target.closest('button')?.getAttribute("onclick")?.includes("toggleMenu") ||
                        e.target.id === 'exportButton';
                const insideMenu = e.target.closest('.absolute.z-10') || e.target.closest('#exportMenu');
                if (!isMenuButton && !insideMenu) {
                    document.querySelectorAll('.absolute.z-10').forEach(menu => menu.classList.add('hidden'));
                }
            });
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

                <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <h1 class="text-2xl font-bold mb-6">
                        Village List 
                    </h1>

                    <div class="flex justify-center mb-6">
                        <form action="admin-village-management" method="get" class="flex gap-2 items-center">
                            <!-- Dropdown Status -->
                            <select name="status"
                                    class="h-[42px] border border-gray-300 rounded px-3 py-2 text-sm">
                                <option value="1" ${status == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${status == '0' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <!-- Input Search -->
                            <input type="text" name="contentSearch"
                                   placeholder="Search by Name"
                                   class="h-[42px] border border-gray-300 rounded px-3 text-sm w-64" />

                            <!-- Button Icon Search -->
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

                    <div class="flex flex-col md:flex-row items-center gap-2">
                        <i id="tooltip-icon" class="bi bi-exclamation-circle-fill text-warning"></i>

                        <c:set var="tooltipContent" value=""/>
                        <c:forEach var="c" items="${listVillages}">
                            <c:set var="tooltipContent" value="${tooltipContent}${c.typeID} - ${c.typeName}<br/>"/>
                        </c:forEach>

                        <script>
                            var tooltipContent = <c:out value="${tooltipContent}" escapeXml="false"/>;
                            tippy('#tooltip-icon', {
                                content: tooltipContent,
                                allowHTML: true,
                                theme: 'light',
                            });
                        </script>



                        <div class="relative inline-block">
                            <button id="exportButton"
                                    onclick="toggleMenu('exportMenu')"
                                    class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm w-32">
                                Export
                            </button>
                            <div id="exportMenu"
                                 class="hidden absolute z-10 mt-2 w-48 bg-white border rounded shadow-lg">
                                <a href="export-village-pdf?cas=1"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Village</a>
                                <a href="export-village-pdf?cas=2"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">By Category</a>
                                <a href="export-village-pdf?cas=3"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Inactive Village</a>
                                <a href="export-village-pdf?cas=4"
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Top Rated Products</a>
                            </div>
                        </div>

                        <button onclick="openAddVillageModal()"
                                class="bg-orange-600 text-white px-4 py-2 rounded hover:bg-orange-700 text-sm">
                            Add Village
                        </button>
                    </div>
                </div>

                <!-- Village Table -->
                <table class="w-full table-auto border border-gray-300 text-sm">
                    <thead class="bg-gray-200 text-center">
                        <tr>
                            <th class="p-3 border">No. </th>
                            <th class="p-3 border">Image</th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Village Name</span>
                                    <button onclick="toggleMenu('villageMenu')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                        ▼
                                    </button>

                                    <!-- Dropdown menu -->
                                    <div id="villageMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-village-management?status=${status}&searchID=7"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            All Village
                                        </a>
                                        <c:forEach var="v" items="${listAllVillage}">
                                            <a href="admin-village-management?status=${status}&searchID=2&contentSearch=${v.villageName}"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                ${v.villageName}
                                            </a>
                                        </c:forEach>

                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Type Name</span>
                                    <button onclick="toggleMenu('ratingMenu')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                        ▼
                                    </button>

                                    <!-- Dropdown menu -->
                                    <div id="ratingMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-village-management?status=${status}&searchID=3"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            All Type
                                        </a>
                                        <c:forEach var="c" items="${listVillages}">
                                            <a href="admin-village-management?status=${status}&searchID=4&contentSearch=${c.typeID}"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                ${c.typeName}
                                            </a>
                                        </c:forEach>

                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border">Description</th>
                            <th class="p-3 border">Address</th>
                            <th class="p-3 border">Status</th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Created Date</span>
                                    <button onclick="toggleMenu('dateMenu')"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                        ▼
                                    </button>

                                    <!-- Dropdown menu -->
                                    <div id="dateMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-village-management?status=${status}&searchID=5"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort Early → Late
                                        </a>
                                        <a href="admin-village-management?status=${status}&searchID=6"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort Late → Early
                                        </a>
                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${listAllVillages}" varStatus="loop">
                            <c:set var="villageTypeName" value="" />
                            <c:forEach var="type" items="${listVillages}">
                                <c:if test="${type.typeID == v.typeID}">
                                    <c:set var="villageTypeName" value="${type.typeName}" />
                                </c:if>
                            </c:forEach>
                            <tr class="text-center border hover:bg-gray-50">
                                <td class="p-3 border">${loop.index + 1}</td> <!-- Số thứ tự -->
                                <td class="p-3 border">
                                    <img src="${v.mainImageUrl}" alt="Image"
                                         class="w-16 h-16 object-cover mx-auto rounded"/>
                                </td>

                                <td class="p-3 border">${v.villageName}</td>
                                <td class="p-3 border">${villageTypeName}</td>
                                <td class="p-3 border text-left max-w-xs truncate">${v.description}</td>
                                <td class="p-3 border">${v.address}</td>
                                <td class="p-3 border">
                                    <c:choose>
                                        <c:when test="${v.status == 1}">
                                            <span class="text-green-600 font-semibold">Active</span>
                                        </c:when>
                                        <c:when test="${v.status == 0}">
                                            <span class="text-gray-500">Hidden</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-yellow-600">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="p-3 border">${v.createdDate}</td>
                                <td class="p-3 border">
                                    <div class="flex gap-1 justify-center flex-wrap">
                                        <button onclick="editVillage(this)"
                                                class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 text-sm"
                                                data-village-id="${fn:escapeXml(v.villageID)}"
                                                data-type-name="${fn:escapeXml(villageTypeName)}"
                                                data-village-name="${v.villageName}"
                                                data-description="${fn:escapeXml(v.description)}"
                                                data-address="${fn:escapeXml(v.address)}"
                                                data-latitude="${v.latitude}"
                                                data-longitude="${v.longitude}"
                                                data-contact-phone="${v.contactPhone}"
                                                data-contact-email="${v.contactEmail}"
                                                data-status="${v.status}"
                                                data-click-count="${v.clickCount}"
                                                data-last-clicked="${v.lastClicked}"
                                                data-created-date="${v.createdDate}"
                                                data-updated-date="${v.updatedDate}"
                                                data-seller-id="${v.sellerId}"
                                                data-opening-hours="${fn:escapeXml(v.openingHours)}"
                                                data-closing-days="${fn:escapeXml(v.closingDays)}"
                                                data-average-rating="${v.averageRating}"
                                                data-total-reviews="${v.totalReviews}"
                                                data-map-embed-url="${fn:escapeXml(v.mapEmbedUrl)}"
                                                data-virtual-tour-url="${fn:escapeXml(v.virtualTourUrl)}"
                                                data-history="${fn:escapeXml(v.history)}"
                                                data-special-features="${fn:escapeXml(v.specialFeatures)}"
                                                data-famous-products="${fn:escapeXml(v.famousProducts)}"
                                                data-cultural-events="${fn:escapeXml(v.culturalEvents)}"
                                                data-craft-process="${fn:escapeXml(v.craftProcess)}"
                                                data-video-description-url="${fn:escapeXml(v.videoDescriptionUrl)}"
                                                data-travel-tips="${fn:escapeXml(v.travelTips)}"
                                                data-main-image-url="${fn:escapeXml(v.mainImageUrl)}">
                                            View
                                        </button>
                                        <a href="admin-vreview-management?villageID=${v.villageID}&villageName=${v.villageName}"
                                           class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 text-sm">Review</a>
                                        <!-- Delete -->
                                        <button class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-700 text-sm"
                                                onclick="confirmDelete('${v.villageID}')">
                                            Delete
                                        </button>

                                        <!-- Hidden form for delete -->
                                        <form id="deleteForm" method="post" action="<c:url value='/admin-village-management'/>" style="display:none;">
                                            <input type="hidden" name="action" value="deleteVillage">
                                            <input type="hidden" name="villageID" id="deleteVillageID">
                                        </form>
                                    </div>
                                </td>
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
                <c:if test="${not empty contentSearch}">
                    <c:set var="queryParams" value="${queryParams}&contentSearch=${fn:escapeXml(contentSearch)}" />
                </c:if>

                <div class="mt-6 flex justify-center items-center gap-2">
                    <c:if test="${currentPage > 1}">
                        <a href="admin-village-management?page=${currentPage - 1}${queryParams}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Previous</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="admin-village-management?page=${i}${queryParams}" class="px-4 py-2 ${currentPage == i ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'} rounded hover:bg-gray-300">${i}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="admin-village-management?page=${currentPage + 1}${queryParams}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Next</a>
                    </c:if>
                </div>

                <!-- Modal Add Village -->
                <div id="villageAddModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-4xl relative text-black overflow-y-auto max-h-[90vh]">
                        <h2 class="text-xl font-semibold mb-4">Add Village</h2>
                        <form id="villageAddForm" action="admin-village-management" method="post" enctype="multipart/form-data" class="space-y-4">
                            <input type="hidden" name="action" id="action" value="addVillage">
                            <div><input type="hidden" name="status" value="${status}"/></div>
                            <!-- fields giống edit nhưng không có ID -->
                            <div class="grid grid-cols-2 gap-4">
                                <div><label>Village Name</label><input type="text" name="villageName" class="w-full border p-2" required/></div>
                                <div>
                                    <label>Type Name</label>
                                    <select name="typeName" id="typeName" class="w-full border p-2" required>
                                        <c:forEach var="typeCC" items="${listVillages}">
                                            <option value="${typeCC.typeID}">${typeCC.typeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-span-2"><label>Description</label><textarea name="description" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Address</label><input type="text" name="address" class="w-full border p-2" required/></div>
                                <div><input type="hidden" name="latitude" class="w-full border p-2"/></div>
                                <div><input type="hidden" name="longitude" class="w-full border p-2"/></div>

                                <div><label>Phone</label><input type="text" name="contactPhone" class="w-full border p-2" pattern="^\d{10}$" title="Phone number must be exactly 10 digits"/></div>
                                <div><label>Email</label><input type="text" name="contactEmail" class="w-full border p-2"/></div>
                                <div><label>Status</label>
                                    <select name="statusVillage" class="w-full border p-2">
                                        <option value="1">Active</option>
                                        <option value="0">Hidden</option>
                                    </select>
                                </div>
                                <div><label>Seller ID</label><input type="text" name="sellerId" class="w-full border p-2" required/></div>
                                <div><label>Opening Hours</label><input type="text" name="openingHours" class="w-full border p-2"/></div>
                                <div><label>Closing Days</label><input type="text" name="closingDays" class="w-full border p-2"/></div>
                                <div class="col-span-2"><label>Map Embed URL</label><input type="text" name="mapEmbedUrl" class="w-full border p-2"/></div>
                                <div class="col-span-2"><label>Virtual Tour URL</label><input type="text" name="virtualTourUrl" class="w-full border p-2"/></div>
                                <div class="col-span-2"><label>History</label><textarea name="history" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Special Features</label><textarea name="specialFeatures" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Famous Products</label><textarea name="famousProducts" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Cultural Events</label><textarea name="culturalEvents" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Craft Process</label><textarea name="craftProcess" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Video Description URL</label><input type="text" name="videoDescriptionUrl" class="w-full border p-2"/></div>
                                <div class="col-span-2"><label>Travel Tips</label><textarea name="travelTips" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Main Image</label><input type="file" name="mainImageUrl" class="w-full border p-2" accept="image/*"/></div>
                            </div>

                            <div class="flex justify-end gap-2">
                                <button type="button" onclick="closeAddVillageModal()" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-800">Create</button>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- Modal Edit Village -->
                <div id="villageModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-4xl relative text-black overflow-y-auto max-h-[90vh]">
                        <h2 class="text-xl font-semibold mb-4">Edit Village</h2>
                        <form id="villageForm" action="admin-village-management" method="post" enctype="multipart/form-data" class="space-y-4">
                            <input type="hidden" name="action" value="updateVillage">
                            <input type="hidden" name="villageID" id="villageID" />
                            <div><input type="hidden" name="status" value="${status}"/></div>

                            <div class="grid grid-cols-2 gap-4">
                                <div><label>Village Name</label><input type="text" name="villageName" id="villageName" class="w-full border p-2" required /></div>
                                <div>
                                    <label>Type Name</label>
                                    <select name="typeName" id="typeName" class="w-full border p-2" required>
                                        <c:forEach var="typeCC" items="${listVillages}">
                                            <option value="${typeCC.typeID}">${typeCC.typeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-span-2"><label>Description</label><textarea name="description" id="description" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Address</label><input type="text" name="address" id="address" class="w-full border p-2" required /></div>
                                <div><input type="hidden" name="latitude" id="latitude" class="w-full border p-2" /></div>
                                <div><input type="hidden" name="longitude" id="longitude" class="w-full border p-2" /></div>
                                <div><label>Phone</label><input type="text" name="contactPhone" id="contactPhone" class="w-full border p-2" pattern="^\d{10}$" title="Phone number must be exactly 10 digits"/></div>
                                <div><label>Email</label><input type="text" name="contactEmail" id="contactEmail" class="w-full border p-2" /></div>
                                <div><label>Status</label>
                                    <select name="statusVillage" id="status" class="w-full border p-2">
                                        <option value="1">Active</option>
                                        <option value="0">Hidden</option>
                                    </select>
                                </div>
                                <div><label>Click Count</label><input type="number" name="clickCount" id="clickCount" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Last Clicked</label><input type="text" name="lastClicked" id="lastClicked" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Created Date</label><input type="text" name="createdDate" id="createdDate" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Updated Date</label><input type="text" name="updatedDate" id="updatedDate" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Seller ID</label><input type="text" name="sellerId" id="sellerId" class="w-full border p-2" required /></div>
                                <div><label>Opening Hours</label><input type="text" name="openingHours" id="openingHours" class="w-full border p-2" /></div>
                                <div><label>Closing Days</label><input type="text" name="closingDays" id="closingDays" class="w-full border p-2" /></div>
                                <div><label>Average Rating</label><input type="text" name="averageRating" id="averageRating" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Total Reviews</label><input type="number" name="totalReviews" id="totalReviews" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div class="col-span-2"><label>Map Embed URL</label><input type="text" name="mapEmbedUrl" id="mapEmbedUrl" class="w-full border p-2" /></div>
                                <div class="col-span-2"><label>Virtual Tour URL</label><input type="text" name="virtualTourUrl" id="virtualTourUrl" class="w-full border p-2" /></div>
                                <div class="col-span-2"><label>History</label><textarea name="history" id="history" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Special Features</label><textarea name="specialFeatures" id="specialFeatures" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Famous Products</label><textarea name="famousProducts" id="famousProducts" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Cultural Events</label><textarea name="culturalEvents" id="culturalEvents" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Craft Process</label><textarea name="craftProcess" id="craftProcess" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Video Description URL</label><input type="text" name="videoDescriptionUrl" id="videoDescriptionUrl" class="w-full border p-2" /></div>
                                <div class="col-span-2"><label>Travel Tips</label><textarea name="travelTips" id="travelTips" class="w-full border p-2"></textarea></div>
                                <div class="col-span-2"><label>Main Image</label><input type="file" name="mainImageUrl" class="w-full border p-2" accept="image/*"/></div>
                                <div class="col-span-2"><label>Current Image URL (if no new file)</label><input type="text" name="existingMainImageUrl" id="existingMainImageUrl" class="w-full border p-2 bg-gray-100" readonly /></div>
                            </div>

                            <div class="flex justify-end gap-2">
                                <button type="button" onclick="closeVillageModal()" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-800">Save</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <script>

            function openAddVillageModal() {
                const form = document.getElementById('villageAddForm');
                form.reset();
                form.querySelector('[name="action"]').value = "addVillage";
                document.getElementById('villageAddModal').classList.remove('hidden');
            }
            function closeAddVillageModal() {
                document.getElementById('villageAddModal').classList.add('hidden');
            }

            function closeVillageModal() {
                document.getElementById('villageModal').classList.add('hidden');
            }

            function editVillage(button) {
                document.getElementById('villageID').value = button.dataset.villageId || "";
                document.getElementById('villageName').value = button.dataset.villageName || "";
                document.getElementById('typeName').value = button.dataset.typeName || "";
                document.getElementById('description').value = button.dataset.description || "";
                document.getElementById('address').value = button.dataset.address || "";
                document.getElementById('latitude').value = button.dataset.latitude || "";
                document.getElementById('longitude').value = button.dataset.longitude || "";
                document.getElementById('contactPhone').value = button.dataset.contactPhone || "";
                document.getElementById('contactEmail').value = button.dataset.contactEmail || "";
                document.getElementById('status').value = button.dataset.status || "";
                document.getElementById('clickCount').value = button.dataset.clickCount || "";
                document.getElementById('lastClicked').value = button.dataset.lastClicked || "";
                document.getElementById('createdDate').value = button.dataset.createdDate || "";
                document.getElementById('updatedDate').value = button.dataset.updatedDate || "";
                document.getElementById('sellerId').value = button.dataset.sellerId || "";
                document.getElementById('openingHours').value = button.dataset.openingHours || "";
                document.getElementById('closingDays').value = button.dataset.closingDays || "";
                document.getElementById('averageRating').value = button.dataset.averageRating || "";
                document.getElementById('totalReviews').value = button.dataset.totalReviews || "";
                document.getElementById('mapEmbedUrl').value = button.dataset.mapEmbedUrl || "";
                document.getElementById('virtualTourUrl').value = button.dataset.virtualTourUrl || "";
                document.getElementById('history').value = button.dataset.history || "";
                document.getElementById('specialFeatures').value = button.dataset.specialFeatures || "";
                document.getElementById('famousProducts').value = button.dataset.famousProducts || "";
                document.getElementById('culturalEvents').value = button.dataset.culturalEvents || "";
                document.getElementById('craftProcess').value = button.dataset.craftProcess || "";
                document.getElementById('videoDescriptionUrl').value = button.dataset.videoDescriptionUrl || "";
                document.getElementById('travelTips').value = button.dataset.travelTips || "";
                document.getElementById('existingMainImageUrl').value = button.dataset.mainImageUrl || "";

                document.getElementById('villageModal').classList.remove('hidden');
            }
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
    // Hiển thị loading overlay khi submit form
    document.querySelectorAll("form").forEach(form => {
        form.addEventListener("submit", () => {
            document.getElementById("loadingOverlay").classList.remove("hidden");
        });
    });

    // Hiển thị loading overlay khi click vào link, trừ các link đặc biệt
    document.querySelectorAll("a").forEach(link => {
        link.addEventListener("click", e => {
            const href = link.getAttribute("href");
            if (
                href &&
                !href.startsWith("#") &&
                !href.startsWith("javascript") &&
                !href.includes("export-village-pdf")
            ) {
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
                document.getElementById('villageModal').classList.add('hidden');
            }

            // Hàm đóng modal thêm village
            function closeAddVillageModal() {
                document.getElementById('villageAddModal').classList.add('hidden');
            }

            // Gán sự kiện đóng cho từng modal
            setupModalClose('villageModal', closeEditVillageModal);
            setupModalClose('villageAddModal', closeAddVillageModal);
        </script>

    </body>
</html>