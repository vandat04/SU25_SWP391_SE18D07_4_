package controller.Seller;

import entity.Account.Account;
import entity.CraftVillage.CraftReview;
import entity.Product.ProductReview;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.ReviewService;
import service.VillageService;
import service.ProductService;

/**
 * SellerReviewManagement handles review management for sellers
 * Allows sellers to respond to reviews for their villages and products
 */
@WebServlet(name = "SellerReviewManagement", urlPatterns = {"/seller-review-management"})
public class SellerReviewManagement extends HttpServlet {

    ReviewService rService = new ReviewService();
    VillageService vService = new VillageService();
    ProductService pService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");
        
        if (seller == null || seller.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String type = request.getParameter("type");
        
        if (action == null) action = "list";
        if (type == null) type = "village";
        
        try {
            switch (action) {
                case "list":
                    if ("village".equals(type)) {
                        listVillageReviews(request, response, seller.getUserID());
                    } else if ("product".equals(type)) {
                        listProductReviews(request, response, seller.getUserID());
                    }
                    break;
                case "respond":
                    showResponseForm(request, response, seller.getUserID());
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");
        
        if (seller == null || seller.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String type = request.getParameter("type");
        
        try {
            switch (action) {
                case "respond":
                    if ("village".equals(type)) {
                        respondToVillageReview(request, response, seller.getUserID());
                    } else if ("product".equals(type)) {
                        respondToProductReview(request, response, seller.getUserID());
                    }
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }
    
    private void listVillageReviews(HttpServletRequest request, HttpServletResponse response, int sellerID) 
            throws ServletException, IOException {
        
        // Get all villages owned by this seller
        List<Integer> villageIDs = vService.getVillageIdsBySeller(sellerID);
        
        // Get all reviews for these villages
        List<CraftReview> allReviews = rService.getAllVillageReviewsBySeller(sellerID);
        
        request.setAttribute("reviews", allReviews);
        request.setAttribute("reviewType", "village");
        request.setAttribute("sellerID", sellerID);
        
        request.getRequestDispatcher("seller-review-management.jsp").forward(request, response);
    }
    
    private void listProductReviews(HttpServletRequest request, HttpServletResponse response, int sellerID) 
            throws ServletException, IOException {
        
        // Get all products in villages owned by this seller
        List<ProductReview> allReviews = rService.getAllProductReviewsBySeller(sellerID);
        
        request.setAttribute("reviews", allReviews);
        request.setAttribute("reviewType", "product");
        request.setAttribute("sellerID", sellerID);
        
        request.getRequestDispatcher("seller-review-management.jsp").forward(request, response);
    }
    
    private void showResponseForm(HttpServletRequest request, HttpServletResponse response, int sellerID) 
            throws ServletException, IOException {
        
        String reviewID = request.getParameter("reviewID");
        String type = request.getParameter("type");
        
        if (reviewID == null || type == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing review ID or type");
            return;
        }
        
        try {
            int id = Integer.parseInt(reviewID);
            
            if ("village".equals(type)) {
                // Verify seller owns this village
                CraftReview review = rService.getVillageReviewById(id);
                if (review != null && vService.isVillageOwnedBySeller(review.getVillageID(), sellerID)) {
                    request.setAttribute("review", review);
                    request.setAttribute("reviewType", "village");
                    request.getRequestDispatcher("seller-response-form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to respond to this review");
                }
            } else if ("product".equals(type)) {
                // Verify seller owns the village where this product is sold
                ProductReview review = rService.getProductReviewById(id);
                if (review != null && pService.isProductOwnedBySeller(review.getProductID(), sellerID)) {
                    request.setAttribute("review", review);
                    request.setAttribute("reviewType", "product");
                    request.getRequestDispatcher("seller-response-form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to respond to this review");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid review ID");
        }
    }
    
    private void respondToVillageReview(HttpServletRequest request, HttpServletResponse response, int sellerID) 
            throws ServletException, IOException {
        
        String reviewID = request.getParameter("reviewID");
        String responseText = request.getParameter("responseText");
        
        if (reviewID == null || responseText == null || responseText.trim().isEmpty()) {
            request.setAttribute("error", "Review ID and response text are required");
            showResponseForm(request, response, sellerID);
            return;
        }
        
        try {
            int id = Integer.parseInt(reviewID);
            
            // Verify seller owns this village
            CraftReview review = rService.getVillageReviewById(id);
            if (review == null || !vService.isVillageOwnedBySeller(review.getVillageID(), sellerID)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to respond to this review");
                return;
            }
            
            boolean success = rService.responseVillageReviewByAdmin(id, responseText.trim());
            
            if (success) {
                request.setAttribute("message", "Response submitted successfully!");
            } else {
                request.setAttribute("error", "Failed to submit response. Please try again.");
            }
            
            // Redirect back to village reviews list
            response.sendRedirect("seller-review-management?type=village&success=" + success);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid review ID");
            showResponseForm(request, response, sellerID);
        }
    }
    
    private void respondToProductReview(HttpServletRequest request, HttpServletResponse response, int sellerID) 
            throws ServletException, IOException {
        
        String reviewID = request.getParameter("reviewID");
        String responseText = request.getParameter("responseText");
        
        if (reviewID == null || responseText == null || responseText.trim().isEmpty()) {
            request.setAttribute("error", "Review ID and response text are required");
            showResponseForm(request, response, sellerID);
            return;
        }
        
        try {
            int id = Integer.parseInt(reviewID);
            
            // Verify seller owns the village where this product is sold
            ProductReview review = rService.getProductReviewById(id);
            if (review == null || !pService.isProductOwnedBySeller(review.getProductID(), sellerID)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to respond to this review");
                return;
            }
            
            boolean success = rService.responseProductReviewByAdmin(id, responseText.trim());
            
            if (success) {
                request.setAttribute("message", "Response submitted successfully!");
            } else {
                request.setAttribute("error", "Failed to submit response. Please try again.");
            }
            
            // Redirect back to product reviews list
            response.sendRedirect("seller-review-management?type=product&success=" + success);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid review ID");
            showResponseForm(request, response, sellerID);
        }
    }
} 