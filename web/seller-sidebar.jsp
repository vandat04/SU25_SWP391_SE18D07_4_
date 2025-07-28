<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- Seller Sidebar -->
<div class="seller-sidebar" id="sellerSidebar">
    <!-- Sidebar Header -->
    <div class="seller-sidebar-header">
        <a href="seller" class="seller-sidebar-logo">
            <img src="hinhanh/Logo/logocraft.png" alt="CraftVillage Logo" />
            <span>Seller Panel</span>
        </a>
        <!-- Close button for mobile -->
        <button type="button" class="seller-sidebar-close d-lg-none" id="sidebarClose">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <!-- Sidebar Navigation -->
    <nav class="seller-sidebar-nav">
        <ul>
            <!-- Dashboard -->
            <li>
                <a href="seller" class="sidebar-link">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <!-- Product Management -->
            <li>
                <a href="seller-product-management" class="sidebar-link">
                    <i class="fas fa-box"></i>
                    <span>Product Management</span>
                </a>
            </li>

            <!-- Add New Product -->
            <li>
                <a href="seller-product-management?action=add" class="sidebar-link">
                    <i class="fas fa-plus-circle"></i>
                    <span>Add New Product</span>
                </a>
            </li>

            <!-- Village Management -->
            <li>
                <a href="seller-village-management" class="sidebar-link" title="View and manage your craft village information">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>Village Management</span>
                </a>
            </li>

            <!-- Order Management -->
            <li>
                <a href="seller-order-management" class="sidebar-link">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Order Management</span>
                </a>
            </li>

            <!-- Reviews Management -->
            <li>
                <a href="seller-feedback-management" class="sidebar-link">
                    <i class="fas fa-star"></i>
                    <span>Reviews Management</span>
                </a>
            </li>

            <!-- Inventory Management -->
            <li>
                <a href="seller-inventory-management" class="sidebar-link">
                    <i class="fas fa-warehouse"></i>
                    <span>Inventory Management</span>
                </a>
            </li>

            <!-- Sales Reports -->
            <li>
                <a href="seller-reports" class="sidebar-link">
                    <i class="fas fa-chart-bar"></i>
                    <span>Sales Reports</span>
                </a>
            </li>

            <!-- Messages -->
            <li>
                <a href="seller-messages" class="sidebar-link">
                    <i class="fas fa-envelope"></i>
                    <span>Customer Messages</span>
                    <c:if test="${not empty unreadMessages && unreadMessages > 0}">
                        <span class="badge badge-danger">${unreadMessages}</span>
                    </c:if>
                </a>
            </li>

            <!-- Profile Settings -->
            <li>
                <a href="seller-profile" class="sidebar-link">
                    <i class="fas fa-user-cog"></i>
                    <span>Account Settings</span>
                </a>
            </li>

            <!-- Divider -->
            <li class="sidebar-divider">
                <hr>
            </li>

            <!-- Quick Actions -->
            <li class="sidebar-section-title">
                <span>Quick Actions</span>
            </li>

            <!-- View Public Profile -->
            <li>
                <a href="village?id=${sessionScope.acc.userID}" target="_blank" class="sidebar-link">
                    <i class="fas fa-external-link-alt"></i>
                    <span>View Public Profile</span>
                </a>
            </li>

            <!-- Export Data -->
            <li>
                <a href="seller-export" class="sidebar-link">
                    <i class="fas fa-download"></i>
                    <span>Export Data</span>
                </a>
            </li>

            <!-- Help & Support -->
            <li>
                <a href="seller-support" class="sidebar-link">
                    <i class="fas fa-question-circle"></i>
                    <span>Support</span>
                </a>
            </li>

            <!-- Divider -->
            <li class="sidebar-divider">
                <hr>
            </li>

            <!-- Back to Main Site -->
            <li>
                <a href="home" class="sidebar-link">
                    <i class="fas fa-arrow-left"></i>
                    <span>Back to Home</span>
                </a>
            </li>

            <!-- Logout -->
            <li>
                <a href="logout" class="sidebar-link text-danger" data-confirm="Are you sure you want to log out?">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Log Out</span>
                </a>
            </li>
        </ul>
    </nav>

    <!-- Sidebar Footer -->
    <div class="seller-sidebar-footer" style="padding: 1rem; border-top: 1px solid rgba(255,255,255,0.1); margin-top: auto;">
        <div class="seller-info">
            <div class="seller-avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.acc.avatarUrl}">
                        <img src="${sessionScope.acc.avatarUrl}" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background: #4F46E5; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                            ${fn:substring(sessionScope.acc.fullName, 0, 1)}
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="seller-details" style="margin-left: 0.75rem; flex: 1; min-width: 0;">
                <div style="font-weight: 600; color: white; font-size: 0.875rem; line-height: 1.2; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                    ${sessionScope.acc.fullName}
                </div>
                <div style="font-size: 0.75rem; color: rgba(255,255,255,0.7); line-height: 1.2; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                    ${sessionScope.acc.email}
                </div>
                <div style="font-size: 0.75rem; color: rgba(255,255,255,0.5); line-height: 1.2;">
                    Seller ID: #${sessionScope.acc.userID}
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Sidebar Overlay for mobile -->
<div class="seller-sidebar-overlay" id="sidebarOverlay" style="
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    z-index: 999;
"></div>

<style>
.seller-sidebar {
    display: flex;
    flex-direction: column;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    width: 280px;
    background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
    color: white;
    z-index: 1000;
    transition: transform 0.3s ease;
    overflow-y: auto;
}

.seller-sidebar-header {
    padding: 1.5rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.seller-sidebar-logo {
    display: flex;
    align-items: center;
    font-size: 1.5rem;
    font-weight: bold;
    color: white;
    text-decoration: none;
}

.seller-sidebar-logo img {
    width: 40px;
    height: 40px;
    margin-right: 0.75rem;
}

.seller-sidebar-close {
    background: none;
    border: none;
    color: white;
    font-size: 1.25rem;
    cursor: pointer;
    padding: 0.5rem;
    border-radius: 0.25rem;
    transition: background-color 0.2s ease;
}

.seller-sidebar-close:hover {
    background: rgba(255, 255, 255, 0.1);
}

.seller-sidebar-nav {
    padding: 1rem 0;
    flex: 1;
}

.seller-sidebar-nav ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.seller-sidebar-nav li {
    margin-bottom: 0.25rem;
}

.sidebar-link {
    display: flex;
    align-items: center;
    padding: 0.75rem 1.5rem;
    color: rgba(255, 255, 255, 0.8);
    text-decoration: none;
    transition: all 0.2s ease;
    border-left: 3px solid transparent;
    position: relative;
    overflow: hidden;
}

.sidebar-link:hover,
.sidebar-link.active {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
    color: white;
    border-left-color: #3b82f6;
}

.sidebar-link i {
    width: 20px;
    margin-right: 0.75rem;
    text-align: center;
}

.seller-sidebar-footer {
    padding: 1rem;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: auto;
    background: linear-gradient(135deg, #1e293b 0%, #1e40af 100%);
}

.seller-info {
    display: flex;
    align-items: center;
    width: 100%;
}

.sidebar-divider {
    margin: 0.5rem 0;
}

.sidebar-divider hr {
    border: none;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin: 0;
}

.sidebar-section-title {
    padding: 0.5rem 1.5rem 0.25rem;
}

.sidebar-section-title span {
    font-size: 0.75rem;
    font-weight: 600;
    color: rgba(255,255,255,0.6);
    text-transform: uppercase;
    letter-spacing: 0.1em;
}

.badge {
    font-size: 0.625rem;
    padding: 0.125rem 0.375rem;
    border-radius: 9999px;
    margin-left: auto;
}

.badge-danger {
    background: linear-gradient(135deg, #dc2626, #b91c1c);
    color: white;
}

.text-danger {
    color: #fca5a5 !important;
}

.text-danger:hover {
    color: #f87171 !important;
}

/* Mobile responsive */
@media (max-width: 1024px) {
    .seller-sidebar {
        transform: translateX(-100%);
    }
    
    .seller-sidebar.active {
        transform: translateX(0);
    }
    
    .seller-sidebar-overlay.active {
        display: block !important;
    }
}

/* Animation for sidebar items */
.seller-sidebar-nav li {
    animation: slideInLeft 0.3s ease;
    animation-fill-mode: both;
}

.seller-sidebar-nav li:nth-child(1) { animation-delay: 0.1s; }
.seller-sidebar-nav li:nth-child(2) { animation-delay: 0.15s; }
.seller-sidebar-nav li:nth-child(3) { animation-delay: 0.2s; }
.seller-sidebar-nav li:nth-child(4) { animation-delay: 0.25s; }
.seller-sidebar-nav li:nth-child(5) { animation-delay: 0.3s; }
.seller-sidebar-nav li:nth-child(6) { animation-delay: 0.35s; }
.seller-sidebar-nav li:nth-child(7) { animation-delay: 0.4s; }
.seller-sidebar-nav li:nth-child(8) { animation-delay: 0.45s; }
.seller-sidebar-nav li:nth-child(9) { animation-delay: 0.5s; }

@keyframes slideInLeft {
    from {
        transform: translateX(-20px);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Set active menu item based on current page
    const currentPath = window.location.pathname;
    const sidebarLinks = document.querySelectorAll('.sidebar-link');
    
    sidebarLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href && (currentPath.includes(href) || 
            (href === 'seller' && currentPath.endsWith('/seller')))) {
            link.classList.add('active');
        }
    });
    
    // Mobile sidebar toggle functionality
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    const sidebar = document.getElementById('sellerSidebar');
    const sidebarClose = document.getElementById('sidebarClose');
    
    // Close sidebar when clicking overlay
    if (sidebarOverlay) {
        sidebarOverlay.addEventListener('click', function() {
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
        });
    }
    
    // Close sidebar when clicking close button
    if (sidebarClose) {
        sidebarClose.addEventListener('click', function() {
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
        });
    }
    
    // Auto-close sidebar on mobile when window is resized
    window.addEventListener('resize', function() {
        if (window.innerWidth > 1024) {
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
        }
    });
});
</script>