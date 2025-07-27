package controller.CraftVillage;

import entity.Account.Account;
import entity.CraftVillage.CraftReview;
import service.ReviewService;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * VillageReviewController handles all village review-related operations
 * Supports village reviews with ticket order validation
 */
@WebServlet(name = "VillageReviewController", urlPatterns = {"/village-review"})
public class VillageReviewController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(VillageReviewController.class.getName());
    private ReviewService reviewService;
    
    @Override
    public void init() throws ServletException {
        reviewService = new ReviewService();
    }
    
    /**
     * Handles GET requests - Display review forms and review lists
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "form":
                    showReviewForm(request, response);
                    break;
                case "check":
                    checkReviewEligibility(request, response);
                    break;
                case "list":
                    listReviews(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet: " + e.getMessage(), e);
            request.setAttribute("error", "An error occurred while processing your request");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - Submit reviews
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "submit";
        }
        
        try {
            switch (action) {
                case "submit":
                    submitReview(request, response);
                    break;
                case "submit-from-order":
                    submitReviewFromOrder(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doPost: " + e.getMessage(), e);
            request.setAttribute("error", "An error occurred while submitting your review");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Show review form for a specific village
     */
    private void showReviewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            int villageID = Integer.parseInt(request.getParameter("villageID"));
            String orderParam = request.getParameter("orderID");
            
            request.setAttribute("villageID", villageID);
            
            if (orderParam != null && !orderParam.isEmpty()) {
                int orderID = Integer.parseInt(orderParam);
                
                // Check if user can review this village from this ticket order
                Integer villageIDFromOrder = reviewService.getVillageIdByOrderId(orderID);
                if (villageIDFromOrder == null) {
                    request.setAttribute("reason", "Không tìm thấy làng nghề cho order này");
                } else {
                    boolean orderEligible = reviewService.isTicketOrderEligibleForReview(villageIDFromOrder, user.getUserID());
                    
                    request.setAttribute("orderID", orderID);
                    request.setAttribute("canReview", orderEligible);
                    
                    if (!orderEligible) {
                        request.setAttribute("reason", "Ticket order must be completed and paid before you can leave a review");
                    }
                }
            } else {
                // Allow basic review without order validation
                request.setAttribute("canReview", true);
            }
            
            request.getRequestDispatcher("village-review-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid village or order ID");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Check if user can review village from a ticket order (AJAX endpoint)
     */
    private void checkReviewEligibility(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        response.setContentType("application/json;charset=UTF-8");
        
        if (user == null) {
            response.getWriter().write("{\"error\": \"User not logged in\"}");
            return;
        }
        
        try {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            Integer villageID = reviewService.getVillageIdByOrderId(orderID);
            if (villageID == null) {
                response.getWriter().write("{\"error\": \"Không tìm thấy làng nghề cho order này\"}");
                return;
            }
            boolean orderEligible = reviewService.isTicketOrderEligibleForReview(villageID, user.getUserID());
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"orderEligible\": ").append(orderEligible);
            json.append("}");
            
            response.getWriter().write(json.toString());
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"error\": \"Invalid order ID\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking review eligibility: " + e.getMessage(), e);
            response.getWriter().write("{\"error\": \"Server error\"}");
        }
    }
    
    /**
     * Submit a basic village review (without order validation)
     */
    private void submitReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            int villageID = Integer.parseInt(request.getParameter("villageID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String reviewText = request.getParameter("reviewText");
            
            // Validate input
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Rating must be between 1 and 5 stars");
                showReviewForm(request, response);
                return;
            }
            
            if (reviewText == null || reviewText.trim().isEmpty()) {
                request.setAttribute("error", "Review text cannot be empty");
                showReviewForm(request, response);
                return;
            }
            
            // Create review object
            CraftReview review = new CraftReview();
            review.setVillageID(villageID);
            review.setUserID(user.getUserID());
            review.setRating(rating);
            review.setReviewText(reviewText.trim());
            
            // Submit review
            boolean success = reviewService.addVillageReview(review);
            
            if (success) {
                request.setAttribute("message", "Your review has been submitted successfully!");
                response.sendRedirect("village-details?villageID=" + villageID + "&reviewSuccess=true");
            } else {
                request.setAttribute("error", "Failed to submit review. Please try again.");
                showReviewForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input data");
            showReviewForm(request, response);
        }
    }
    
    /**
     * Submit village review with ticket order validation
     */
    private void submitReviewFromOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            int villageID = Integer.parseInt(request.getParameter("villageID"));
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String reviewText = request.getParameter("reviewText");
            
            // Validate input
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Rating must be between 1 and 5 stars");
                showReviewForm(request, response);
                return;
            }
            
            if (reviewText == null || reviewText.trim().isEmpty()) {
                request.setAttribute("error", "Review text cannot be empty");
                showReviewForm(request, response);
                return;
            }
            
            // Create review object
            CraftReview review = new CraftReview();
            review.setVillageID(villageID);
            review.setUserID(user.getUserID());
            review.setRating(rating);
            review.setReviewText(reviewText.trim());
            
            // Submit review with order validation
            boolean success = reviewService.addVillageReviewFromOrder(review, orderID);
            
            if (success) {
                request.setAttribute("message", "Your review has been submitted successfully!");
                response.sendRedirect("ticket-order-history?orderID=" + orderID + "&reviewSuccess=true");
            } else {
                request.setAttribute("error", "Failed to submit review. You may not have permission to review this village or have already reviewed it.");
                showReviewForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input data");
            showReviewForm(request, response);
        }
    }
    
    /**
     * List reviews for a village
     */
    private void listReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int villageID = Integer.parseInt(request.getParameter("villageID"));
            
            List<CraftReview> reviews = reviewService.getVillageReviews(villageID);
            double averageRating = reviewService.getAverageVillageRating(villageID);
            
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("villageID", villageID);
            
            request.getRequestDispatcher("village-reviews.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid village ID");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
} 