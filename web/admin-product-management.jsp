<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Product Management</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/@popperjs/core@2"></script>
        <script src="https://unpkg.com/tippy.js@6"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="icon" type="image/png" href="hinhanh\Logo\cropped-Favicon-1-32x32.png">
        <script>
            function confirmDelete(pid) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    text: "Are you sure you want to delete this product?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#aaa',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("deletePid").value = pid;
                        document.getElementById("deleteForm").submit();
                    }
                });
            }

            function toggleExportMenu() {
                const menu = document.getElementById('exportMenu');
                menu.classList.toggle('hidden');
            }
        </script>
        <!-- Bootstrap Icons (nếu muốn dấu chấm than đẹp) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Tippy.js CSS -->
        <link href="https://unpkg.com/tippy.js@6/themes/light.css" rel="stylesheet" />
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

                <!-- Tabs -->
                <div class="mb-4 flex gap-4">
                    <button  class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">                       
                        <a href="admin-product-management"> Products Management</a>
                    </button>
                    <button  class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
                        <a href="admin-ticket-management">  Tickets Management</a>
                    </button>
                </div>

                <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <h1 class="text-2xl font-bold mb-6">Product List</h1>



                    <div class="flex justify-center mb-6">
                        <form action="admin-product-management" method="get" class="flex gap-2 items-center">
                            <!-- Dropdown Status -->
                            <select name="status"
                                    class="h-[42px] border border-gray-300 rounded px-3 py-2 text-sm">
                                <option value="1" ${status == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${status == '0' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <!-- Input Search -->
                            <input type="text" name="contentSearch" value="${fn:escapeXml(contentSearch)}"
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

                        <div class="relative inline-block">
                            <button onclick="toggleExportMenu()"
                                    class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
                                Export
                            </button>
                            <div id="exportMenu" class="hidden absolute z-10 mt-2 w-48 bg-white border rounded shadow-lg">
                                <a href="export-product-pdf?cas=1" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">All Products</a>
                                <a href="export-product-pdf?cas=2" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">By Category</a>
                                <a href="export-product-pdf?cas=3" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Out of Stock</a>
                                <a href="export-product-pdf?cas=4" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Inactive Products</a>
                                <a href="export-product-pdf?cas=5" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Top Rated Products</a>                                 
                            </div>
                        </div>

                        <button onclick="openAddProductModal()"
                                class="bg-orange-600 text-white px-4 py-2 rounded hover:bg-orange-700 text-sm">
                            Add Product
                        </button>
                    </div>
                </div>

                <!-- Product Table -->
                <table class="w-full table-auto border border-gray-300 text-sm">
                    <thead class="bg-gray-200 text-center">
                        <tr>
                            <th class="p-3 border w-20">No.</th>
                            <th class="p-3 border w-24">Image</th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Name</span>
                                    <button onclick="toggleNameMenu()"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                        ▼
                                    </button>
                                    <!-- Dropdown menu -->
                                    <div id="nameMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-product-management?status=${status}&searchID=2"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort A - Z
                                        </a>
                                        <a href="admin-product-management?status=${status}&searchID=3"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort Z - A
                                        </a>
                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Categories</span>
                                    <button onclick="toggleCategoryMenu()"
                                            class="text-black text-sm hover:text-blue-600">
                                        ▼
                                    </button>
                                    <!-- Dropdown menu -->
                                    <div id="categoryMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-product-management?status=${status}&searchID=1"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            All Categories
                                        </a>
                                        <c:forEach var="c" items="${listCC}">
                                            <a href="admin-product-management?status=${status}&searchID=1&contentSearch=${c.categoryID}"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                ${c.categoryName}
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Price</span>
                                    <button onclick="togglePriceMenu()"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                        ▼
                                    </button>
                                    <!-- Dropdown menu -->
                                    <div id="priceMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-product-management?status=${status}&searchID=6"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort Low - High
                                        </a>
                                        <a href="admin-product-management?status=${status}&searchID=8"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort High - Low
                                        </a>
                                    </div>
                                </div>
                            </th>


                            <th class="p-3 border w-48 bg-[#e4e6e9]">
                                <div class="relative inline-flex items-center space-x-1">
                                    <span class="text-sm font-semibold text-black">Stock</span>
                                    <button onclick="toggleStockMenu()"
                                            class="text-black text-sm hover:text-blue-600 focus:outline-none">
                                        ▼
                                    </button>
                                    <!-- Dropdown menu -->
                                    <div id="stockMenu"
                                         class="hidden absolute top-full left-0 z-10 mt-1 w-48 bg-white border rounded shadow-lg max-h-60 overflow-y-auto">
                                        <a href="admin-product-management?status=${status}&searchID=10"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort Low - High
                                        </a>
                                        <a href="admin-product-management?status=${status}&searchID=11"
                                           class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            Sort High - Low
                                        </a>
                                    </div>
                                </div>
                            </th>

                            <th class="p-3 border w-56">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${listProduct}" varStatus="loop">
                            <tr class="bg-white border text-center align-middle hover:bg-gray-50">
                                <td class="p-3 border">${loop.index + 1}</td> <!-- Số thứ tự -->
                                <td class="p-3 border">
                                    <img src="${product.mainImageUrl}" alt="Image" class="w-20 h-20 object-cover mx-auto rounded" />
                                </td>
                                <td class="p-3 border">${product.name}</td>

                                <td class="p-2 border">
                                    <c:forEach var="c" items="${listCC}">
                                        <c:if test="${c.categoryID == product.categoryID}">
                                            ${c.categoryName}
                                        </c:if>
                                    </c:forEach>
                                </td>

                                <td class="p-3 border">
                                    <fmt:formatNumber value="${product.price}" type="currency"/>
                                </td>
                                <td class="p-3 border">${product.stock}</td>
                                <td class="p-3 border">
                                    <div class="flex flex-col md:flex-row md:justify-center gap-2">
                                        <!-- View/Edit Button -->
                                        <button class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-700 text-sm"
                                                onclick="editProduct(this)"
                                                data-pid="${product.pid}"
                                                data-name="${fn:escapeXml(product.name)}"
                                                data-price="${product.price}"
                                                data-description="${fn:escapeXml(product.description)}"
                                                data-stock="${product.stock}"
                                                data-status="${product.status}"
                                                data-village-id="${product.villageID}"
                                                data-category-id="${product.categoryID}"
                                                data-craft-type-id="${product.craftTypeID}"
                                                data-main-image-url="${fn:escapeXml(product.mainImageUrl)}"
                                                data-click-count="${product.clickCount}"
                                                data-created-date="${product.createdDate}"
                                                data-updated-date="${product.updatedDate}"
                                                data-sku="${fn:escapeXml(product.sku)}"
                                                data-weight="${product.weight}"
                                                data-dimensions="${fn:escapeXml(product.dimensions)}"
                                                data-materials="${fn:escapeXml(product.materials)}"
                                                data-care-instructions="${fn:escapeXml(product.careInstructions)}"
                                                data-warranty="${fn:escapeXml(product.warranty)}"
                                                data-average-rating="${product.averageRating}"
                                                data-total-reviews="${product.totalReviews}"
                                                data-model-file="${fn:escapeXml(product.modelFile)}">
                                            View
                                        </button>

                                        <!-- Review -->
                                        <form method="get" action="<c:url value='/admin-preview-management'/>">
                                            <input type="hidden" name="pid" value="${product.pid}" />
                                            <input type="hidden" name="name" value="${product.name}" />
                                            <button type="submit"
                                                    class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-yellow-600 text-sm">
                                                Review
                                            </button>
                                        </form>

                                        <!-- Delete -->
                                        <button class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-red-700 text-sm"
                                                onclick="confirmDelete('${product.pid}')">
                                            Delete
                                        </button>
                                    </div>

                                    <!-- Hidden form for delete -->
                                    <form id="deleteForm" method="post" action="<c:url value='/admin-product-management'/>" style="display:none;">
                                        <input type="hidden" name="typeName" value="deleteProduct">
                                        <input type="hidden" name="pid" id="deletePid">
                                    </form>
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
                        <a href="admin-product-management?page=${currentPage - 1}${queryParams}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Previous</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="admin-product-management?page=${i}${queryParams}" class="px-4 py-2 ${currentPage == i ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-700'} rounded hover:bg-gray-300">${i}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="admin-product-management?page=${currentPage + 1}${queryParams}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">Next</a>
                    </c:if>
                </div>

                <!-- Modal Add Product -->
                <div id="productAddModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-3xl relative text-black overflow-y-auto max-h-[90vh]">
                        <h2 class="text-xl font-semibold mb-4">Add New Product</h2>
                        <form id="addProductForm" action="admin-product-management" method="post" class="space-y-4" enctype="multipart/form-data">
                            <input type="hidden" name="typeName" value="createProduct" />
                            <div class="grid grid-cols-2 gap-4">
                                <div><label>Name</label><input type="text" name="name" class="w-full border p-2" required/></div>
                                <div><label>Price</label><input type="currency" name="price" class="w-full border p-2" required step="0.01" min="0.01" required="" /></div>
                                <div class="col-span-2"><label>Description</label><textarea name="description" class="w-full border p-2"></textarea></div>
                                <div><label>Stock(unit)</label><input type="number" name="stock" class="w-full border p-2" min="0" required=""/></div>
                                <div><label>SKU</label><input type="text" name="sku" class="w-full border p-2" /></div>
                                <div><label>Status</label>
                                    <select name="statusProduct" class="w-full border rounded p-2">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                                <div>
                                    <label>Village</label>
                                    <select name="villageID" class="w-full border p-2">
                                        <c:forEach var="type" items="${listAllVillage}">
                                            <option value="${type.villageID}">${type.villageName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label>Category</label>
                                    <select name="categoryID" class="w-full border p-2">
                                        <c:forEach var="typeC" items="${listCC}">
                                            <option value="${typeC.categoryID}">${typeC.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label>Craft Type</label>
                                    <select name="craftTypeID" class="w-full border p-2">
                                        <c:forEach var="typeCC" items="${listVillages}">
                                            <option value="${typeCC.typeID}">${typeCC.typeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div><label>Main Image</label><input type="file" name="mainImageUrl" class="w-full border p-2" accept="image/*"/></div>
                                <div><label>Weight(kg)</label><input type="text" name="weight" class="w-full border p-2" required=""/></div>
                                <div><label>Dimensions</label><input type="text" name="dimensions" class="w-full border p-2" /></div>
                                <div><label>Materials</label><input type="text" name="materials" class="w-full border p-2" /></div>
                                <div><label>Care Instructions</label><input type="text" name="careInstructions" class="w-full border p-2" /></div>
                                <div><label>Warranty</label><input type="text" name="warranty" class="w-full border p-2" /></div>
                                <div><label>Model File</label><input type="file" name="modelFile" class="w-full border p-2"   accept=".glb" /></div>
                            </div>
                            <div class="flex justify-end gap-2 pt-4">
                                <button type="button" onclick="closeAddProductModal()" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-800">Create</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal Edit Product -->
                <div id="productEditModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-3xl relative text-black overflow-y-auto max-h-[90vh]">
                        <h2 class="text-xl font-semibold mb-4">Edit Product</h2>
                        <form id="editProductForm" action="admin-product-management" method="post" class="space-y-4" enctype="multipart/form-data">
                            <input type="hidden" name="typeName" value="updateProduct" />
                            <div class="grid grid-cols-2 gap-4">
                                <div><label>Product ID</label><input type="text" id="pid" name="pid" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Name</label><input type="text" id="name" name="name" class="w-full border p-2" required /></div>
                                <div><label>Price(đ)</label><input type="currency" id="price" name="price" class="w-full border p-2" min="0" step="1" required /></div>
                                <div class="col-span-2"><label>Description</label><textarea id="description" name="description" class="w-full border p-2"></textarea></div>
                                <div><label>Stock(unit)</label><input type="number" id="stock" name="stock" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Add Stock(unit)</label><input type="number" name="stockAdd" class="w-full border p-2" min="0" value="0" /></div>
                                <div><label>Status</label>
                                    <select id="status" name="statusProduct" class="w-full border rounded p-2" required>
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                                <div>
                                    <label>Village</label>
                                    <select id="villageID" name="villageID" class="w-full border p-2" required>
                                        <c:forEach var="type" items="${listAllVillage}">
                                            <option value="${type.villageID}">${type.villageName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label>Category</label>
                                    <select id="categoryID" name="categoryID" class="w-full border p-2" required>
                                        <c:forEach var="typeC" items="${listCC}">
                                            <option value="${typeC.categoryID}">${typeC.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label>Craft Type</label>
                                    <select id="craftTypeID" name="craftTypeID" class="w-full border p-2" required>
                                        <c:forEach var="typeCC" items="${listVillages}">
                                            <option value="${typeCC.typeID}">${typeCC.typeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div><label>Main Image</label><input type="file" name="mainImageUrl" class="w-full border p-2" accept="image/*"/></div>
                                <div><label>Click Count</label><input type="text" id="clickCount" name="clickCount" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Created Date</label><input type="text" id="createdDate" name="createdDate" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Updated Date</label><input type="text" id="updatedDate" name="updatedDate" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>SKU</label><input type="text" id="sku" name="sku" class="w-full border p-2" /></div>
                                <div><label>Weight(kg)</label><input type="text" id="weight" name="weight" class="w-full border p-2" required /></div>
                                <div><label>Dimensions</label><input type="text" id="dimensions" name="dimensions" class="w-full border p-2" /></div>
                                <div><label>Materials</label><input type="text" id="materials" name="materials" class="w-full border p-2" /></div>
                                <div><label>Care Instructions</label><input type="text" id="careInstructions" name="careInstructions" class="w-full border p-2" /></div>
                                <div><label>Warranty</label><input type="text" id="warranty" name="warranty" class="w-full border p-2" /></div>
                                <div><label>Average Rating</label><input type="number" id="averageRating" name="averageRating" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Total Reviews</label><input type="number" id="totalReviews" name="totalReviews" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div><label>Model File</label><input type="file" id="modelFile" name="modelFile" class="w-full border p-2" accept=".glb" /></div>
                                <div class="col-span-2"><label>Current Image URL (if no new file)</label><input type="text" id="existingMainImageUrl" name="existingMainImageUrl" class="w-full border p-2 bg-gray-100" readonly /></div>
                                <div class="col-span-2"><label>Model File URL (if no new file)</label><input type="text" id="existingModelFileUrl" name="existingModelFileUrl" class="w-full border p-2 bg-gray-100" readonly /></div>
                            </div>
                            <div class="flex justify-end gap-2">
                                <button type="button" onclick="closeEditProductModal()" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-800">Save</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <script>
            function openAddProductModal() {
                document.getElementById('addProductForm').reset();
                document.getElementById('productAddModal').classList.remove('hidden');
            }

            function closeAddProductModal() {
                document.getElementById('productAddModal').classList.add('hidden');
            }

            function closeEditProductModal() {
                document.getElementById('productEditModal').classList.add('hidden');
            }

            function editProduct(button) {
                document.getElementById('pid').value = button.dataset.pid || "";
                document.getElementById('name').value = button.dataset.name || "";
                document.getElementById('price').value = button.dataset.price || "";
                document.getElementById('description').value = button.dataset.description || "";
                document.getElementById('stock').value = button.dataset.stock || "";
                document.getElementById('status').value = button.dataset.status || "";
                document.getElementById('villageID').value = button.dataset.villageId || "";
                document.getElementById('categoryID').value = button.dataset.categoryId || "";
                document.getElementById('craftTypeID').value = button.dataset.craftTypeId || "";
                document.getElementById('clickCount').value = button.dataset.clickCount || "";
                document.getElementById('createdDate').value = button.dataset.createdDate || "";
                document.getElementById('updatedDate').value = button.dataset.updatedDate || "";
                document.getElementById('sku').value = button.dataset.sku || "";
                document.getElementById('weight').value = button.dataset.weight || "";
                document.getElementById('dimensions').value = button.dataset.dimensions || "";
                document.getElementById('materials').value = button.dataset.materials || "";
                document.getElementById('careInstructions').value = button.dataset.careInstructions || "";
                document.getElementById('warranty').value = button.dataset.warranty || "";
                document.getElementById('averageRating').value = button.dataset.averageRating || "";
                document.getElementById('totalReviews').value = button.dataset.totalReviews || "";
                document.getElementById('existingMainImageUrl').value = button.dataset.mainImageUrl || "";
                document.getElementById('existingModelFileUrl').value = button.dataset.modelFile || "";

                document.getElementById('productEditModal').classList.remove('hidden');


            }
            document.getElementById('productAddModal').addEventListener('click', function (event) {
                if (event.target.id === 'productAddModal') {
                    closeAddProductModal();
                }

            });
        </script>
        <script>
            // Đóng Edit Product Modal khi click ra ngoài nội dung
            document.getElementById('productEditModal').addEventListener('click', function (event) {
                if (event.target.id === 'productEditModal') {
                    closeEditProductModal();
                }
            });
        </script>
        <script>
            function toggleCategoryMenu() {
                const menu = document.getElementById("categoryMenu");
                menu.classList.toggle("hidden");
            }

            // Tùy chọn: Ẩn menu nếu click bên ngoài
            document.addEventListener("click", function (event) {
                const button = event.target.closest("button");
                const menu = document.getElementById("categoryMenu");

                if (!event.target.closest("#categoryMenu") && !button) {
                    menu?.classList.add("hidden");
                }
            });
        </script>
        <script>
            function toggleNameMenu() {
                const menu = document.getElementById("nameMenu");
                menu.classList.toggle("hidden");
            }

            // Tự động ẩn dropdown khi click ra ngoài
            document.addEventListener("click", function (event) {
                const isInside = event.target.closest("#nameMenu") ||
                        event.target.closest("button[onclick='toggleNameMenu()']");

                if (!isInside) {
                    document.getElementById("nameMenu")?.classList.add("hidden");
                }
            });
        </script>
        <script>
            function togglePriceMenu() {
                const menu = document.getElementById("priceMenu");
                menu.classList.toggle("hidden");
            }

            // Tự động đóng khi click ra ngoài
            document.addEventListener("click", function (event) {
                const isInside = event.target.closest("#priceMenu") ||
                        event.target.closest("button[onclick='togglePriceMenu()']");
                if (!isInside) {
                    document.getElementById("priceMenu")?.classList.add("hidden");
                }
            });
        </script>
        <script>
            function toggleStockMenu() {
                const menu = document.getElementById("stockMenu");
                menu.classList.toggle("hidden");
            }

            // Tự động ẩn khi click ra ngoài
            document.addEventListener("click", function (event) {
                const isInside = event.target.closest("#stockMenu") ||
                        event.target.closest("button[onclick='toggleStockMenu()']");
                if (!isInside) {
                    document.getElementById("stockMenu")?.classList.add("hidden");
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
                    if (href && !href.startsWith("#") && !href.startsWith("javascript") &&  !href.includes("export-product-pdf")) {
                        document.getElementById("loadingOverlay").classList.remove("hidden");
                    }
                });
            });
        </script>

    </body>
</html>