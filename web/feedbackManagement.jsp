<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management - ${sessionScope.acc.userName}</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-body); background-color: var(--background-color); color: var(--primary-text); display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; }
        .sidebar-logo { padding: 1.5rem 2rem; text-align: center; border-bottom: 1px solid var(--border-color); }
        .sidebar-logo img { max-width: 80%; height: auto; }
        .sidebar-profile { text-align: center; padding: 2rem 1rem; }
        .sidebar-profile .avatar { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid var(--accent-color); margin-bottom: 1rem; }
        .sidebar-profile h3 { font-family: var(--font-heading); font-size: 1.2rem; margin-bottom: 0.25rem; }
        .sidebar-profile p { font-size: 0.9rem; color: #999; }
        .sidebar-nav { list-style-type: none; flex-grow: 1; margin-top: 1rem; }
        .sidebar-nav a { display: flex; align-items: center; padding: 1rem 2rem; color: var(--primary-text); text-decoration: none; font-weight: 500; transition: background-color 0.2s, color 0.2s; border-left: 4px solid transparent; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background-color: var(--background-color); color: var(--accent-color); border-left-color: var(--accent-color); }
        .sidebar-nav a i { width: 25px; margin-right: 1rem; font-size: 1.1rem; text-align: center; }
        .sidebar-logout { padding: 1rem 0; border-top: 1px solid var(--border-color); }
        .sidebar-logout a { text-decoration: none; color: var(--primary-text); }
        .main-content { flex-grow: 1; padding: 2rem 3rem; overflow-y: auto; }
        .main-header { margin-bottom: 2rem; }
        .main-header h1 { font-family: var(--font-heading); font-size: 2.5rem; font-weight: 700; }
        .main-header p { color: var(--secondary-text); font-size: 1rem; }
        .panel { background-color: #fff; padding: 2rem; border-radius: 10px; border: 1px solid var(--border-color); box-shadow: 0 4px 15px var(--shadow-color); }
        .panel-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem; }
        .panel-title { font-family: var(--font-heading); font-size: 1.5rem; }
        .primary-action-btn { background: var(--accent-color); color: #fff; text-decoration: none; padding: 0.7rem 1.2rem; border-radius: 8px; font-weight: 500; transition: background-color 0.3s; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 0.5rem; }
        .primary-action-btn:hover { background: var(--accent-hover); }
        .product-table { width: 100%; border-collapse: collapse; margin-top: 1.5rem; } /* Using product-table style for consistency */
        .product-table th, .product-table td { padding: 12px 15px; border-bottom: 1px solid var(--border-color); text-align: left; vertical-align: middle; }
        .product-table thead th { font-weight: 500; color: var(--secondary-text); text-transform: uppercase; font-size: 0.85rem; }
        .product-table tbody tr:hover { background-color: var(--background-color); }
        .action-buttons button, .action-buttons a { background: none; border: none; cursor: pointer; margin: 0 8px; text-decoration: none; color: var(--secondary-text); font-size: 1.1rem; transition: color 0.2s; }
        .action-buttons button:hover, .action-buttons a:hover { color: var(--accent-color); }
        .alert { padding: 1rem 1.5rem; margin-bottom: 1rem; border-radius: 8px; border: 1px solid transparent; font-weight: 500; }
        .alert-error { background-color: var(--error-bg); border-color: var(--error-border); color: var(--error-text); }
        .alert-success { background-color: var(--success-bg); border-color: var(--success-border); color: var(--success-text); }
        .search-filter-box { padding: 1.5rem 0; margin-bottom: 1.5rem; border-bottom: 1px solid var(--border-color); }
        .filter-form { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 1.5rem; }
        .filter-group { display: flex; flex-direction: column; gap: 0.5rem; }
        .filter-group label { font-weight: 500; font-size: 0.9rem; color: var(--secondary-text); }
        .filter-group input[type="text"], .filter-group input[type="number"] { padding: 0.7rem; border: 1px solid var(--border-color); border-radius: 8px; font-family: var(--font-body); background-color: var(--background-color); transition: border-color 0.2s, box-shadow 0.2s; }
        .filter-group input:focus { outline: none; border-color: var(--accent-color); box-shadow: 0 0 0 3px rgba(140, 109, 70, 0.2); }
        .secondary-action-btn { background: #fff; color: var(--primary-text); text-decoration: none; padding: 0.7rem 1.2rem; border-radius: 8px; font-weight: 500; transition: background-color 0.3s, box-shadow 0.3s; border: 1px solid var(--border-color); cursor: pointer; }
        .secondary-action-btn:hover { background-color: var(--background-color); }

        /* Specific styles for Feedback Management */
        .feedback-table { /* Using specific class for feedback tables */
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
            margin-bottom: 2.5rem; /* Add some space between tables */
        }
        .feedback-table th, .feedback-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
            vertical-align: top; /* Align text to top for reviewText/response */
            word-wrap: break-word; /* Ensure long text wraps */
            max-width: 250px; /* Limit width of text columns if needed */
        }
        .feedback-table thead th {
            font-weight: 500;
            color: var(--secondary-text);
            text-transform: uppercase;
            font-size: 0.85rem;
        }
        .feedback-table tbody tr:hover {
            background-color: var(--background-color);
        }
        .delete-btn { /* Redefine delete button for consistency with action-buttons */
            background: none;
            border: none;
            cursor: pointer;
            color: var(--error-text); /* Use error color for delete */
            font-size: 1.1rem;
            transition: color 0.2s;
            padding: 0; /* Remove default padding for consistency */
        }
        .delete-btn:hover {
            color: #dc3545; /* Darker red on hover */
        }
        .rating {
            color: #ffc107; /* Star color */
        }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-logo"><a href="home"><img src="hinhanh/Logo/logocraft.png" alt="Craft Village Logo"></a></div>
        <c:if test="${not empty sessionScope.acc}">
            <div class="sidebar-profile">
                <img src="${not empty sessionScope.acc.avatarUrl ? sessionScope.acc.avatarUrl : 'https://i.pravatar.cc/150?u='}${sessionScope.acc.userID}" alt="Seller avatar" class="avatar">
                <h3>${sessionScope.acc.userName}</h3>
                <p>Admin</p>
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
            <a href="logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Logout</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Feedback Management</h1>
            <p>Here you can view and delete feedback for craft villages and products.</p>
        </header>

        <section class="panel">
            <%-- Message display area --%>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <h2 class="panel-title" style="margin-bottom: 1.5rem;">Village Feedback</h2>
            <c:choose>
                <c:when test="${not empty villageReviews}">
                    <table class="feedback-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Village ID</th>
                                <th>User ID</th>
                                <th>Rating</th>
                                <th>Content</th>
                                <th>Review Date</th>
                                <th>Response</th>
                                <th>Response Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="review" items="${villageReviews}">
                                <tr>
                                    <td><c:out value="${review.reviewID}"/></td>
                                    <td><c:out value="${review.villageID}"/></td>
                                    <td><c:out value="${review.userID}"/></td>
                                    <td>
                                        <span class="rating">
                                            <c:forEach begin="1" end="${review.rating}">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5">
                                                <i class="far fa-star"></i>
                                            </c:forEach>
                                        </span>
                                    </td>
                                    <td><c:out value="${review.reviewText}"/></td>
                                    <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><c:out value="${review.response}"/></td>
                                    <td><fmt:formatDate value="${review.responseDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="action-buttons">
                                        <form action="feedback-management" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this village review?');">
                                            <input type="hidden" name="action" value="deleteVillageReview"/>
                                            <input type="hidden" name="reviewID" value="${review.reviewID}"/>
                                            <button type="submit" class="delete-btn" title="Delete village review">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; padding: 2rem;">No village feedback found.</p>
                </c:otherwise>
            </c:choose>

            <h2 class="panel-title" style="margin-top: 2.5rem; margin-bottom: 1.5rem;">Product Feedback</h2>
            <c:choose>
                <c:when test="${not empty productReviews}">
                    <table class="feedback-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Product ID</th>
                                <th>User ID</th>
                                <th>Rating</th>
                                <th>Content</th>
                                <th>Review Date</th>
                                <th>Response</th>
                                <th>Response Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="review" items="${productReviews}">
                                <tr>
                                    <td><c:out value="${review.reviewID}"/></td>
                                    <td><c:out value="${review.productID}"/></td>
                                    <td><c:out value="${review.userID}"/></td>
                                    <td>
                                        <span class="rating">
                                            <c:forEach begin="1" end="${review.rating}">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5">
                                                <i class="far fa-star"></i>
                                            </c:forEach>
                                        </span>
                                    </td>
                                    <td><c:out value="${review.reviewText}"/></td>
                                    <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><c:out value="${review.response}"/></td>
                                    <td><fmt:formatDate value="${review.responseDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="action-buttons">
                                        <form action="feedback-management" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this product review?');">
                                            <input type="hidden" name="action" value="deleteProductReview"/>
                                            <input type="hidden" name="reviewID" value="${review.reviewID}"/>
                                            <button type="submit" class="delete-btn" title="Delete product review">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; padding: 2rem;">No product feedback found.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>