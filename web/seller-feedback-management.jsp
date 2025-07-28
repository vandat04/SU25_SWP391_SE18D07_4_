<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management - Seller Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            background-color: #f8fafc;
        }
        
        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            margin-left: 280px;
            transition: margin-left 0.3s ease;
        }
        
        .main-content.expanded {
            margin-left: 0;
        }
        
        .content-header {
            background: white;
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .content-body {
            padding: 2rem;
        }
        
        .feedback-card {
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .feedback-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .feedback-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #10b981;
            display: inline-block;
            transition: color 0.3s ease;
        }
        
        .feedback-title:hover {
            color: #3b82f6;
        }
        
        .feedback-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 0.75rem;
            overflow: hidden;
        }
        
        .feedback-table th, .feedback-table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
            text-align: left;
        }
        
        .feedback-table th {
            background: linear-gradient(90deg, #10b981 0%, #3b82f6 100%);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.875rem;
        }
        
        .feedback-table tr {
            background: white;
            transition: background 0.2s ease;
        }
        
        .feedback-table tr:hover {
            background: #f1f5f9;
        }
        
        .rating {
            color: #f59e0b;
            font-size: 1rem;
        }
        
        .response-form {
            margin-top: 1rem;
        }
        
        .response-form textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            resize: vertical;
            font-size: 0.875rem;
            transition: border-color 0.3s ease;
        }
        
        .response-form textarea:focus {
            border-color: #3b82f6;
            outline: none;
        }
        
        .response-form button {
            margin-top: 0.75rem;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            border-radius: 0.5rem;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        
        .response-form button:hover {
            transform: translateY(-2px);
            background-color: #059669;
        }
        
        .status-badge {
            padding: 0.3rem 1rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .status-responded {
            background: #10b981;
            color: white;
            border: 1px solid #059669;
        }
        
        .status-responded::before {
            content: "\f058"; /* Check icon */
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            font-size: 0.8rem;
        }
        
        .status-unresponded {
            background: #6b7280;
            color: white;
            border: 1px solid #4b5563;
        }
        
        .status-unresponded::before {
            content: "\f071"; /* Exclamation icon */
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            font-size: 0.8rem;
        }
        
        .breadcrumb {
            background: none;
            padding: 0;
            margin: 0;
            font-size: 0.875rem;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "/";
            color: #6b7280;
        }
        
        .breadcrumb-item a {
            color: #6b7280;
            text-decoration: none;
        }
        
        .breadcrumb-item a:hover {
            color: #3b82f6;
        }
        
        .breadcrumb-item.active {
            color: #374151;
            font-weight: 500;
        }
        
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <!-- Include Sidebar -->
        <jsp:include page="seller-sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="main-content" id="mainContent">
            <!-- Content Header -->
            <div class="content-header">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="seller-dashboard" class="text-decoration-none">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Feedback Management</li>
                    </ol>
                </nav>
                
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 mb-1">Feedback Management</h1>
                        <p class="text-muted mb-0">View, respond to, and delete feedback from customers</p>
                    </div>
                </div>
            </div>
            
            <!-- Content Body -->
            <div class="content-body">
                <!-- Alerts -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Feedback Sections -->
                <div class="feedback-card">
                    <h2 class="feedback-title">Craft Village Feedback</h2>
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
                                            <td>${review.reviewID}</td>
                                            <td>${review.villageID}</td>
                                            <td>${review.userID}</td>
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
                                            <td>${review.reviewText}</td>
                                            <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty review.response}">
                                                        <span class="status-badge status-responded">Responded</span>
                                                        <p class="mt-1">${review.response}</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-unresponded">Unresponded</span>
                                                        <form action="seller-feedback-management" method="post" class="response-form mt-2" onsubmit="return confirm('Are you sure you want to submit this response?');">
                                                            <input type="hidden" name="action" value="respondVillageReview"/>
                                                            <input type="hidden" name="reviewID" value="${review.reviewID}"/>
                                                            <textarea name="responseText" placeholder="Enter your response" rows="3" required></textarea>
                                                            <button type="submit" class="btn btn-primary btn-sm">
                                                                <i class="fas fa-reply me-1"></i>Respond
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${review.responseDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <form action="seller-feedback-management" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this review?');">
                                                    <input type="hidden" name="action" value="deleteVillageReview"/>
                                                    <input type="hidden" name="reviewID" value="${review.reviewID}"/>
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Delete review">
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
                            <div class="text-center py-5">
                                <div class="mb-4">
                                    <i class="fas fa-comments fa-4x text-muted"></i>
                                </div>
                                <h4 class="text-muted mb-3">No feedback yet</h4>
                                <p class="text-muted mb-4">There is currently no feedback from customers about craft villages.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="feedback-card">
                    <h2 class="feedback-title">Product Feedback</h2>
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
                                            <td>${review.reviewID}</td>
                                            <td>${review.productID}</td>
                                            <td>${review.userID}</td>
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
                                            <td>${review.reviewText}</td>
                                            <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty review.response}">
                                                        <span class="status-badge status-responded">Responded</span>
                                                        <p class="mt-1">${review.response}</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-unresponded">Unresponded</span>
                                                        <form action="seller-feedback-management" method="post" class="response-form mt-2" onsubmit="return confirm('Are you sure you want to submit this response?');">
                                                            <input type="hidden" name="action" value="respondProductReview"/>
                                                            <input type="hidden" name="reviewID" value="${review.reviewID}"/>
                                                            <textarea name="responseText" placeholder="Enter your response" rows="3" required></textarea>
                                                            <button type="submit" class="btn btn-primary btn-sm">
                                                                <i class="fas fa-reply me-1"></i>Respond
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${review.responseDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <form action="seller-feedback-management" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this review?');">
                                                    <input type="hidden" name="action" value="deleteProductReview"/>
                                                    <input type="hidden" name="reviewID" value="${review.reviewID}"/>
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Delete review">
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
                            <div class="text-center py-5">
                                <div class="mb-4">
                                    <i class="fas fa-comments fa-4x text-muted"></i>
                                </div>
                                <h4 class="text-muted mb-3">No feedback yet</h4>
                                <p class="text-muted mb-4">There is currently no feedback from customers about products.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>