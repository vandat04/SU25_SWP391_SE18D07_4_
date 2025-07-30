<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin - 3D Product Management</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/@popperjs/core@2"></script>
        <script src="https://unpkg.com/tippy.js@6"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function confirmDelete(pid) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    text: "Are you sure you want to delete this 3D model?",
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

            function open3DViewer(modelUrl, productName, productImage) {
                if (!modelUrl || modelUrl.trim() === '') {
                    Swal.fire({
                        title: 'No 3D Model',
                        text: 'This product does not have a 3D model yet.',
                        icon: 'info'
                    });
                    return;
                }
                
                // Open 3D viewer in new window
                const viewerUrl = '3DViewer.jsp?modelUrl=' + encodeURIComponent(modelUrl) + 
                                '&productName=' + encodeURIComponent(productName) +
                                (productImage ? '&productImage=' + encodeURIComponent(productImage) : '');
                window.open(viewerUrl, '_blank', 'width=1200,height=800');
            }

            function generate3DModel(pid, productName) {
                Swal.fire({
                    title: 'Generate 3D Model',
                    text: 'Do you want to generate a 3D model for "' + productName + '"?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, generate!',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Redirect to 3D generation page with product info
                        window.location.href = 'ImageTo3DServlet?action=generateForProduct&productId=' + pid + '&productName=' + encodeURIComponent(productName);
                    }
                });
            }

                    function upload3DModel(pid, productName) {
            console.log('upload3DModel called with pid:', pid, 'productName:', productName);
            Swal.fire({
                title: 'Upload 3D Model',
                text: 'Do you want to upload a 3D model file for "' + productName + '"?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, upload!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Redirect to 3D upload page with product info
                    var url = 'ImageTo3DServlet?action=uploadForProduct&productId=' + pid + '&productName=' + encodeURIComponent(productName);
                    console.log('Redirecting to:', url);
                    window.location.href = url;
                }
            });
        }
        </script>
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Tippy.js CSS -->
        <link href="https://unpkg.com/tippy.js@6/themes/light.css" rel="stylesheet" />
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
                    
                <!-- Tabs -->
                <div class="mb-4 flex gap-4">
                    <button class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">                       
                        <a href="admin-product-management"> Products Management</a>
                    </button>
                    <button class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
                        <a href="admin-ticket-management">  Tickets Management</a>
                    </button>
                    <button class="px-4 py-2 bg-purple-600 text-white rounded hover:bg-purple-700">                       
                        <a href="admin-3d-product-management">3D Product Management</a>
                    </button>
                </div>

                <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <h1 class="text-2xl font-bold mb-6">3D Product Management</h1>

                    <div class="flex flex-col md:flex-row items-center gap-2">
                        <!-- Search and Filter -->
                        <form action="admin-3d-product-management" method="get" class="flex flex-wrap gap-2 items-center">
                            <select name="status" class="border border-gray-300 rounded px-3 py-2 text-sm w-40">
                                <option value="1" ${status == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${status == '0' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <select name="searchID" class="border border-gray-300 rounded px-3 py-2 text-sm w-40">
                                <option value="0" ${searchID == '0' ? 'selected' : ''}>All Products</option>
                                <option value="1" ${searchID == '1' ? 'selected' : ''}>Has 3D Model</option>
                                <option value="2" ${searchID == '2' ? 'selected' : ''}>No 3D Model</option>
                                <option value="3" ${searchID == '3' ? 'selected' : ''}>Sort A - Z</option>
                                <option value="4" ${searchID == '4' ? 'selected' : ''}>Sort Z - A</option>
                                <option value="5" ${searchID == '5' ? 'selected' : ''}>Product Name</option>
                                <option value="6" ${searchID == '6' ? 'selected' : ''}>Product ID</option>
                            </select>

                            <input type="text" name="contentSearch" value="${fn:escapeXml(contentSearch)}" placeholder="Search by Name, ID"
                                   class="border border-gray-300 rounded px-3 py-2 text-sm w-64" />

                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                                Search
                            </button>
                        </form>

                    </div>
                </div>

                <!-- 3D Product Table -->
                <table class="w-full table-auto border border-gray-300 text-sm">
                    <thead class="bg-gray-200 text-center">
                        <tr>
                            <th class="p-3 border w-20">Product ID</th>
                            <th class="p-3 border w-24">Image</th>
                            <th class="p-3 border w-48">Name</th>
                            <th class="p-3 border w-32">3D Model</th>
                            <th class="p-3 border w-56">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${listProduct}">
                            <tr class="bg-white border text-center align-middle hover:bg-gray-50">
                                <td class="p-3 border">${product.pid}</td>
                                <td class="p-3 border">
                                    <img src="${product.mainImageUrl}" alt="Image" class="w-20 h-20 object-cover mx-auto rounded" />
                                </td>
                                <td class="p-3 border">${product.name}</td>
                                <td class="p-3 border">
                                    <c:choose>
                                        <c:when test="${not empty product.modelFile}">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i class="bi bi-check-circle-fill text-green-500 mr-1"></i>
                                                Available
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                <i class="bi bi-x-circle-fill text-red-500 mr-1"></i>
                                                Not Available
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="p-3 border">
                                    <div class="flex flex-col md:flex-row md:justify-center gap-2">
                                        <!-- View 3D Model Button -->
                                        <c:if test="${not empty product.modelFile}">
                                            <button class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-700 text-sm"
                                                    onclick="open3DViewer('${fn:escapeXml(product.modelFile)}', '${fn:escapeXml(product.name)}', '${fn:escapeXml(product.mainImageUrl)}')"
                                                    title="View 3D Model">
                                                <i class="bi bi-eye"></i> View 3D
                                            </button>
                                        </c:if>
                                        
                                        <!-- Generate 3D Model Button -->
                                        <c:if test="${empty product.modelFile}">
                                            <button class="bg-purple-500 text-white px-3 py-1 rounded hover:bg-purple-700 text-sm"
                                                    onclick="generate3DModel('${product.pid}', '${product.name}')"
                                                    title="Generate 3D Model">
                                                <i class="bi bi-magic"></i> Generate 3D
                                            </button>
                                            
                                            <!-- Upload 3D Model Button -->
                                            <button class="bg-orange-500 text-white px-3 py-1 rounded hover:bg-orange-700 text-sm"
                                                    onclick="upload3DModel('${product.pid}', '${product.name}')"
                                                    title="Upload 3D Model">
                                                <i class="bi bi-upload"></i> Upload 3D
                                            </button>
                                        </c:if>
                                        
                                        <!-- Delete 3D Model Button -->
                                        <c:if test="${not empty product.modelFile}">
                                            <button class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-700 text-sm"
                                                    onclick="confirmDelete('${product.pid}')"
                                                    title="Delete 3D Model">
                                                <i class="bi bi-trash"></i> Delete 3D
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="mt-6 flex justify-center">
                        <nav class="flex items-center space-x-2">
                            <c:if test="${currentPage > 1}">
                                <a href="admin-3d-product-management?page=${currentPage - 1}&status=${status}&searchID=${searchID}&contentSearch=${fn:escapeXml(contentSearch)}"
                                   class="px-3 py-2 text-sm border rounded hover:bg-gray-50">
                                    Previous
                                </a>
                            </c:if>
                            
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="px-3 py-2 text-sm bg-blue-600 text-white rounded">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="admin-3d-product-management?page=${i}&status=${status}&searchID=${searchID}&contentSearch=${fn:escapeXml(contentSearch)}"
                                           class="px-3 py-2 text-sm border rounded hover:bg-gray-50">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="admin-3d-product-management?page=${currentPage + 1}&status=${status}&searchID=${searchID}&contentSearch=${fn:escapeXml(contentSearch)}"
                                   class="px-3 py-2 text-sm border rounded hover:bg-gray-50">
                                    Next
                                </a>
                            </c:if>
                        </nav>
                    </div>
                </c:if>

                <!-- Hidden form for delete -->
                <form id="deleteForm" action="admin-3d-product-management" method="post" style="display: none;">
                    <input type="hidden" name="action" value="delete3DModel">
                    <input type="hidden" id="deletePid" name="pid" value="">
                </form>

                <!-- Statistics -->
                <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-white p-6 rounded-lg shadow">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                                <i class="bi bi-box text-2xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Total Products</p>
                                <p class="text-2xl font-semibold text-gray-900">${totalProducts}</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-lg shadow">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 text-green-600">
                                <i class="bi bi-check-circle text-2xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">With 3D Models</p>
                                <p class="text-2xl font-semibold text-gray-900">${productsWith3D}</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-lg shadow">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-red-100 text-red-600">
                                <i class="bi bi-x-circle text-2xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Without 3D Models</p>
                                <p class="text-2xl font-semibold text-gray-900">${productsWithout3D}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html> 