<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty VILLAGE ? 'Add New Village' : 'Update Village'}</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <link rel="stylesheet" href="<c:url value='/css/sellerDashboard.css'/>">
    <style>
        /* sellerDashboard.css - standardized styling */

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

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: var(--font-body);
    background-color: var(--background-color);
    color: var(--primary-text);
    display: flex;
    min-height: 100vh;
}

.sidebar {
    width: 260px;
    background-color: var(--sidebar-bg);
    border-right: 1px solid var(--border-color);
    display: flex;
    flex-direction: column;
}

.sidebar-logo {
    padding: 1.5rem 2rem;
    text-align: center;
    border-bottom: 1px solid var(--border-color);
}

.sidebar-logo img {
    max-width: 80%;
    height: auto;
}

.sidebar-profile {
    text-align: center;
    padding: 2rem 1rem;
}

.sidebar-profile .avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid var(--accent-color);
    margin-bottom: 1rem;
}

.sidebar-profile h3 {
    font-family: var(--font-heading);
    font-size: 1.2rem;
    margin-bottom: 0.25rem;
}

.sidebar-profile p {
    font-size: 0.9rem;
    color: #999;
}

.sidebar-nav {
    list-style-type: none;
    flex-grow: 1;
    margin-top: 1rem;
}

.sidebar-nav a {
    display: flex;
    align-items: center;
    padding: 1rem 2rem;
    color: var(--primary-text);
    text-decoration: none;
    font-weight: 500;
    border-left: 4px solid transparent;
    transition: background-color 0.2s, color 0.2s;
}

.sidebar-nav a:hover,
.sidebar-nav a.active {
    background-color: var(--background-color);
    color: var(--accent-color);
    border-left-color: var(--accent-color);
}

.sidebar-nav a i {
    width: 25px;
    margin-right: 1rem;
    font-size: 1.1rem;
    text-align: center;
}

.sidebar-logout {
    padding: 1rem 0;
    border-top: 1px solid var(--border-color);
}

.sidebar-logout a {
    text-decoration: none;
    color: var(--primary-text);
}

.main-content {
    flex-grow: 1;
    padding: 2rem 3rem;
    overflow-y: auto;
}

.main-header {
    margin-bottom: 2rem;
}

.main-header h1 {
    font-family: var(--font-heading);
    font-size: 2.5rem;
    font-weight: 700;
}

.main-header p {
    color: var(--secondary-text);
    font-size: 1rem;
}

.panel {
    background-color: #fff;
    padding: 2rem;
    border-radius: 10px;
    border: 1px solid var(--border-color);
    box-shadow: 0 4px 15px var(--shadow-color);
}

.panel-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.5rem;
    border-bottom: 1px solid var(--border-color);
    padding-bottom: 1rem;
}

.panel-title {
    font-family: var(--font-heading);
    font-size: 1.5rem;
}

.primary-action-btn {
    background: var(--accent-color);
    color: #fff;
    text-decoration: none;
    padding: 0.7rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: background-color 0.3s;
    border: none;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
}

.primary-action-btn:hover {
    background: var(--accent-hover);
}

.secondary-action-btn {
    background: #fff;
    color: var(--primary-text);
    text-decoration: none;
    padding: 0.7rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: background-color 0.3s, box-shadow 0.3s;
    border: 1px solid var(--border-color);
    cursor: pointer;
}

.secondary-action-btn:hover {
    background-color: var(--background-color);
}

.product-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1.5rem;
}

.product-table th,
.product-table td {
    padding: 12px 15px;
    border-bottom: 1px solid var(--border-color);
    text-align: left;
    vertical-align: middle;
}

.product-table thead th {
    font-weight: 500;
    color: var(--secondary-text);
    text-transform: uppercase;
    font-size: 0.85rem;
}

.product-table tbody tr:hover {
    background-color: var(--background-color);
}

.product-table img {
    width: 70px;
    height: 70px;
    object-fit: cover;
    border-radius: 8px;
}

.action-buttons button,
.action-buttons a {
    background: none;
    border: none;
    cursor: pointer;
    margin: 0 8px;
    text-decoration: none;
    color: var(--secondary-text);
    font-size: 1.1rem;
    transition: color 0.2s;
}

.action-buttons button:hover,
.action-buttons a:hover {
    color: var(--accent-color);
}

.alert {
    padding: 1rem 1.5rem;
    margin-bottom: 1rem;
    border-radius: 8px;
    border: 1px solid transparent;
    font-weight: 500;
}

.alert-error {
    background-color: var(--error-bg);
    border-color: var(--error-border);
    color: var(--error-text);
}

.alert-success {
    background-color: var(--success-bg);
    border-color: var(--success-border);
    color: var(--success-text);
}

.search-filter-box {
    padding: 1.5rem 0;
    margin-bottom: 1.5rem;
    border-bottom: 1px solid var(--border-color);
}

.filter-form {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-end;
    gap: 1.5rem;
}

.filter-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.filter-group label {
    font-weight: 500;
    font-size: 0.9rem;
    color: var(--secondary-text);
}

.filter-group input[type="text"],
.filter-group input[type="number"] {
    padding: 0.7rem;
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-family: var(--font-body);
    background-color: var(--background-color);
    transition: border-color 0.2s, box-shadow 0.2s;
}

.filter-group input:focus {
    outline: none;
    border-color: var(--accent-color);
    box-shadow: 0 0 0 3px rgba(140, 109, 70, 0.2);
}
.form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem 2rem; }
        .form-group { margin-bottom: 0; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { display: block; margin-bottom: 0.75rem; font-weight: 500; font-size: 0.9rem; color: var(--primary-text); }
        .form-control { width: 100%; padding: 0.85rem 1rem; font-size: 1rem; font-family: var(--font-body); border: 1px solid var(--border-color); border-radius: 8px; background-color: #fff; transition: border-color 0.2s, box-shadow 0.2s; }
        .form-control:focus { outline: none; border-color: var(--accent-color); box-shadow: 0 0 0 3px rgba(140, 109, 70, 0.15); }
        textarea.form-control { min-height: 120px; resize: vertical; }
        .form-actions { margin-top: 2.5rem; text-align: right; grid-column: 1 / -1; display: flex; justify-content: flex-end; align-items: center; gap: 1rem; }
        .action-button { background-color: var(--accent-color); color: #fff; border: none; padding: 0.8rem 2rem; border-radius: 8px; font-family: var(--font-body); font-weight: 700; font-size: 1rem; cursor: pointer; transition: background-color 0.3s, transform 0.2s; display: inline-flex; align-items: center; gap: 0.5rem;}
        .action-button:hover { background-color: var(--accent-hover); transform: translateY(-2px); }
        .secondary-action-btn { background: #fff; color: var(--primary-text); text-decoration: none; padding: 0.8rem 2rem; border-radius: 8px; font-weight: 700; border: 1px solid var(--border-color); cursor: pointer; transition: background-color 0.3s; }
        .alert { padding: 1rem 1.5rem; margin-bottom: 2rem; border-radius: 8px; border: 1px solid transparent; font-weight: 500; }
        .alert-error { background-color: var(--error-bg); border-color: var(--error-border); color: var(--error-text); }    

    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-logo"><a href="<c:url value='/home'/>"><img src="<c:url value='/hinhanh/Logo/logocraft.png'/>" alt="Craft Village Logo"></a></div>
        <c:if test="${not empty sessionScope.acc}">
            <div class="sidebar-profile">
                <img src="${not empty sessionScope.acc.avatarUrl ? sessionScope.acc.avatarUrl : 'https://i.pravatar.cc/150?u='}${sessionScope.acc.userID}" alt="Avatar" class="avatar">
                <h3>${sessionScope.acc.userName}</h3>
                <p>Administrator</p>
            </div>
        </c:if>
        <ul class="sidebar-nav">
            <li><a href="seller" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="manageProduct"><i class="fas fa-palette"></i> Product Management</a></li>
            <li><a href="manage-villages"><i class="fas fa-landmark"></i> Village Management</a></li>
            <li><a href="order-management"><i class="fas fa-receipt"></i> Order Management</a></li>
            <li><a href="feedback-management"><i class="fas fa-comments"></i> Feedback Management</a></li>
            <li><a href="statistics"><i class="fas fa-chart-pie"></i> Statistics</a></li>
            <li><a href="contact"><i class="fas fa-headset"></i> Contact & Support</a></li>
        </ul>
        <div class="sidebar-logout">
            <a href="<c:url value='/logout'/>" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>${empty VILLAGE ? 'Add New Village' : 'Update Village'}</h1>
            <p>Please provide the complete details for the craft village.</p>
        </header>

        <section class="panel">
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle" style="margin-right: 0.5rem;"></i>${requestScope.errorMessage}
                </div>
            </c:if>
            
            <form action="<c:url value='/manage-villages'/>" method="post">
                <input type="hidden" name="action" value="save">
                <c:if test="${not empty VILLAGE}"><input type="hidden" name="villageID" value="${VILLAGE.villageID}"></c:if>
                <c:if test="${not empty sessionScope.acc}"><input type="hidden" name="sellerId" value="${sessionScope.acc.userID}"></c:if>

                <div class="form-grid">
                    
                    <div class="form-group full-width">
                        <label for="villageName">Village Name *</label>
                        <input id="villageName" type="text" name="villageName" class="form-control" required placeholder="e.g., Bat Trang Pottery Village" value="${VILLAGE.villageName}">
                    </div>

                    <div class="form-group">
                        <label for="typeID">Category *</label>
                        <select id="typeID" name="typeID" class="form-control" required>
                            <option value="">-- Select a category --</option>
                            <c:forEach var="type" items="${CRAFT_TYPES}">
                                <option value="${type.typeID}" ${VILLAGE.typeID == type.typeID ? 'selected' : ''}>${type.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <input id="address" type="text" name="address" class="form-control" placeholder="e.g., Bat Trang, Gia Lam, Hanoi" value="${VILLAGE.address}">
                    </div>

                    <div class="form-group full-width">
                        <label for="description">General Description</label>
                        <textarea id="description" name="description" class="form-control" rows="3" placeholder="A brief introduction to the village...">${VILLAGE.description}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="contactPhone">Contact Phone</label>
                        <input id="contactPhone" type="tel" name="contactPhone" class="form-control" value="${VILLAGE.contactPhone}">
                    </div>

                    <div class="form-group">
                        <label for="contactEmail">Contact Email</label>
                        <input id="contactEmail" type="email" name="contactEmail" class="form-control" value="${VILLAGE.contactEmail}">
                    </div>

                     <div class="form-group">
                        <label for="openingHours">Opening Hours</label>
                        <input id="openingHours" type="text" name="openingHours" class="form-control" placeholder="e.g., 8:00 AM - 5:00 PM" value="${VILLAGE.openingHours}">
                    </div>
                    <div class="form-group">
                        <label for="closingDays">Closing Days</label>
                        <input id="closingDays" type="text" name="closingDays" class="form-control" placeholder="e.g., Mondays, Public Holidays" value="${VILLAGE.closingDays}">
                    </div>
                    
                    <div class="form-group">
                        <label for="latitude">Latitude</label>
                        <input id="latitude" type="number" step="any" name="latitude" class="form-control" placeholder="e.g., 16.0544" value="${VILLAGE.latitude}">
                    </div>
                     <div class="form-group">
                        <label for="longitude">Longitude</label>
                        <input id="longitude" type="number" step="any" name="longitude" class="form-control" placeholder="e.g., 108.2022" value="${VILLAGE.longitude}">
                    </div>

                    <div class="form-group full-width">
                        <label for="mainImageUrl">Main Image URL</label>
                        <input id="mainImageUrl" type="url" name="mainImageUrl" class="form-control" placeholder="https://example.com/image.jpg" value="${VILLAGE.mainImageUrl}">
                    </div>
                    <div class="form-group full-width">
                        <label for="mapEmbedUrl">Map Embed URL</label>
                        <input id="mapEmbedUrl" type="url" name="mapEmbedUrl" class="form-control" placeholder="URL from Google Maps embed" value="${VILLAGE.mapEmbedUrl}">
                    </div>
                     <div class="form-group full-width">
                        <label for="virtualTourUrl">Virtual Tour URL</label>
                        <input id="virtualTourUrl" type="url" name="virtualTourUrl" class="form-control" value="${VILLAGE.virtualTourUrl}">
                    </div>
                     <div class="form-group full-width">
                        <label for="videoDescriptionUrl">Video Description URL</label>
                        <input id="videoDescriptionUrl" type="url" name="videoDescriptionUrl" class="form-control" placeholder="URL from YouTube, Vimeo, etc." value="${VILLAGE.videoDescriptionUrl}">
                    </div>

                    <div class="form-group full-width">
                        <label for="history">History</label>
                        <textarea id="history" name="history" class="form-control" rows="5" placeholder="Tell the history of the village...">${VILLAGE.history}</textarea>
                    </div>
                    <div class="form-group full-width">
                        <label for="specialFeatures">Special Features</label>
                        <textarea id="specialFeatures" name="specialFeatures" class="form-control" rows="3" placeholder="What makes this village unique?">${VILLAGE.specialFeatures}</textarea>
                    </div>
                    <div class="form-group full-width">
                        <label for="famousProducts">Famous Products</label>
                        <textarea id="famousProducts" name="famousProducts" class="form-control" rows="3" placeholder="List some well-known products...">${VILLAGE.famousProducts}</textarea>
                    </div>
                    <div class="form-group full-width">
                        <label for="culturalEvents">Cultural Events</label>
                        <textarea id="culturalEvents" name="culturalEvents" class="form-control" rows="3" placeholder="Describe any festivals or cultural events...">${VILLAGE.culturalEvents}</textarea>
                    </div>
                    <div class="form-group full-width">
                        <label for="craftProcess">Crafting Process</label>
                        <textarea id="craftProcess" name="craftProcess" class="form-control" rows="5" placeholder="Explain the general process of making the crafts...">${VILLAGE.craftProcess}</textarea>
                    </div>
                    <div class="form-group full-width">
                        <label for="travelTips">Travel Tips</label>
                        <textarea id="travelTips" name="travelTips" class="form-control" rows="3" placeholder="Provide tips for visitors...">${VILLAGE.travelTips}</textarea>
                    </div>
                    
                    <div class="form-actions">
                        <a href="<c:url value='/manage-villages'/>" class="secondary-action-btn">Cancel</a>
                        <button type="submit" class="action-button">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </section>
    </main>
</body>
</html>