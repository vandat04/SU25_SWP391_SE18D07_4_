<%-- 
    Document   : admin-sidebar
    Created on : Jun 21, 2025, 11:55:30 PM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- admin-sidebar.jsp -->
<!-- Sidebar dọc chiếm 1/6 chiều ngang -->
<div class="w-1/6 bg-gray-800 text-white p-6">
    <h2 class="text-2xl font-bold mb-6"><img src="hinhanh/Logo/logocraft.png" alt="alt"/></h2>
    <ul class="space-y-6 text-xl">
        <li><a href="admin" class="hover:text-yellow-300 block">📋 Dashboard</a></li>
        <li><a href="admin-account-management" class="hover:text-yellow-300 block">📋 Account Management</a></li>
        <li><a href="admin-product-management?status=1&searchID=0&contentSearch= " class="hover:text-yellow-300 block">📋️ Product Management</a></li>
        <li><a href="admin-3d-product-management" class="hover:text-yellow-300 block">🎨 3D Product Management</a></li>
        <li><a href="admin-village-management?status=1&searchID=0&contentSearch= " class="hover:text-yellow-300 block">📋 Craft Village Management</a></li>
        <li><a href="admin-order-management?status=7&searchID=0" class="hover:text-yellow-300 block">📋️ Order Management</a></li>
        <li><a href="home" class="hover:text-yellow-300 block">📋 Back to Overview</a></li>
        <li><a href="logout" class="hover:text-yellow-300 block">📰 Logout(${sessionScope.acc.fullName})</a></li>
    </ul>
</div>

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