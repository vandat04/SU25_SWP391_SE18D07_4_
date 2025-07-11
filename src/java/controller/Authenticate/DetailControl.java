/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Authenticate;

import entity.Product.Product;
import entity.Product.ProductCategory;
import entity.Account.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.ProductService;
import service.ReviewService;
import service.OrderService;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 *
 * @author ACER
 */
@WebServlet(name = "DetailControl", urlPatterns = {"/detail"})
public class DetailControl extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(DetailControl.class.getName());

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductService productService = new ProductService();
        
        // Validate and get product
        String id = request.getParameter("pid");
        Product product = validateAndGetProduct(id, productService, response);
        if (product == null) return; // Response already handled
        
        // Set basic product attributes
        setProductAttributes(request, product);
        
        // Handle review eligibility
        handleReviewEligibility(request, product, id);
        
        // Set additional product data
        setAdditionalProductData(request, productService, product);
        
        request.getRequestDispatcher("Detail.jsp").forward(request, response);
    }
    
    /**
     * Validate product ID and get product details
     */
    private Product validateAndGetProduct(String id, ProductService productService, HttpServletResponse response) 
            throws IOException {
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("home");
            return null;
        }

        Product product = productService.getProductByID(id);
        if (product == null) {
            response.sendRedirect("home");
            return null;
        }
        
        return product;
    }
    
    /**
     * Set basic product attributes in request
     */
    private void setProductAttributes(HttpServletRequest request, Product product) {
        request.setAttribute("detail", product);
        request.setAttribute("cid", product.getCategoryID());
        request.setAttribute("productName", product.getName());
        request.setAttribute("price", product.getPrice());
        request.setAttribute("description", product.getDescription());
        request.setAttribute("img", product.getMainImageUrl());
    }
    
    /**
     * Handle review eligibility logic
     */
    private void handleReviewEligibility(HttpServletRequest request, Product product, String productId) {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        if (user == null) {
            setDefaultReviewAttributes(request, "Please log in to leave a review.");
            return;
        }
        
        try {
            int productIdInt = Integer.parseInt(productId);
            ReviewEligibilityResult result = checkReviewEligibility(user.getUserID(), productIdInt);
            
            request.setAttribute("canUserReviewProduct", result.canReview);
            if (result.canReview) {
                request.setAttribute("orderIDForReview", result.eligibleOrderId);
            } else {
                request.setAttribute("reviewMessage", result.message);
            }
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid product ID format: " + productId, e);
            setDefaultReviewAttributes(request, "Invalid product ID.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking review eligibility for product " + productId, e);
            setDefaultReviewAttributes(request, "Unable to check review eligibility at this time.");
        }
    }
    
    /**
     * Check if user can review the product
     */
    private ReviewEligibilityResult checkReviewEligibility(int userId, int productId) {
        OrderService orderService = new OrderService();
        ReviewService reviewService = new ReviewService();
        
        List<entity.Orders.Order> userOrders = orderService.getOrdersByUserId(userId);
        
        // Check for eligible orders
        for (entity.Orders.Order order : userOrders) {
            if (order.isEligibleForReview() && orderContainsProduct(order, productId, orderService)) {
                boolean alreadyReviewed = reviewService.hasUserReviewedProduct(userId, productId, order.getOrderID());
                if (!alreadyReviewed) {
                    return new ReviewEligibilityResult(true, order.getOrderID(), "");
                }
            }
        }
        
        // Determine why user cannot review
        String message = determineReviewIneligibilityMessage(userOrders, productId, userId, orderService, reviewService);
        return new ReviewEligibilityResult(false, -1, message);
    }
    
    /**
     * Check if an order contains the specified product
     */
    private boolean orderContainsProduct(entity.Orders.Order order, int productId, OrderService orderService) {
        List<entity.Orders.OrderDetail> orderDetails = order.getOrderDetails();
        if (orderDetails == null || orderDetails.isEmpty()) {
            orderDetails = orderService.getOrderDetailsByOrderId(order.getOrderID());
        }
        
        return orderDetails.stream()
                .anyMatch(detail -> detail.getProductID() == productId);
    }
    
    /**
     * Determine why user cannot review the product
     */
    private String determineReviewIneligibilityMessage(List<entity.Orders.Order> userOrders, int productId, 
            int userId, OrderService orderService, ReviewService reviewService) {
        
        boolean hasAnyOrderWithProduct = false;
        boolean hasDeliveredPaidOrder = false;
        boolean alreadyReviewedAll = false;
        
        for (entity.Orders.Order order : userOrders) {
            if (orderContainsProduct(order, productId, orderService)) {
                hasAnyOrderWithProduct = true;
                
                if (order.isEligibleForReview()) {
                    hasDeliveredPaidOrder = true;
                    if (reviewService.hasUserReviewedProduct(userId, productId, order.getOrderID())) {
                        alreadyReviewedAll = true;
                    }
                }
            }
        }
        
        if (!hasAnyOrderWithProduct) {
            return "You need to purchase this product before you can review it.";
        } else if (!hasDeliveredPaidOrder) {
            return "You can only review products from orders that have been delivered and paid.";
        } else if (alreadyReviewedAll) {
            return "You have already reviewed this product.";
        } else {
            return "You cannot review this product at this time.";
        }
    }
    
    /**
     * Set default review attributes when user cannot review
     */
    private void setDefaultReviewAttributes(HttpServletRequest request, String message) {
        request.setAttribute("canUserReviewProduct", false);
        request.setAttribute("reviewMessage", message);
    }
    
    /**
     * Set additional product data like categories and related products
     */
    private void setAdditionalProductData(HttpServletRequest request, ProductService productService, Product product) {
        // Get all products
        List<Product> listP = productService.getAllProducts();
        request.setAttribute("listP", listP);

        // Get products in same category
        List<Product> listPP = productService.getProductByCategoryID(String.valueOf(product.getCategoryID()));
        request.setAttribute("listPP", listPP);

        // Get all categories and find current category name
        List<ProductCategory> listC = productService.getAllCategory();
        request.setAttribute("listCC", listC);
        
        String categoryName = findCategoryName(listC, product.getCategoryID());
        request.setAttribute("categoryName", categoryName);

        // Get top 5 newest products
        List<Product> list5 = productService.getTop5NewestProducts();
        request.setAttribute("list5", list5);
    }
    
    /**
     * Find category name by ID
     */
    private String findCategoryName(List<ProductCategory> categories, int categoryId) {
        return categories.stream()
                .filter(c -> c.getCategoryID() == categoryId)
                .map(ProductCategory::getCategoryName)
                .findFirst()
                .orElse("");
    }
    
    /**
     * Helper class to hold review eligibility results
     */
    private static class ReviewEligibilityResult {
        final boolean canReview;
        final int eligibleOrderId;
        final String message;
        
        ReviewEligibilityResult(boolean canReview, int eligibleOrderId, String message) {
            this.canReview = canReview;
            this.eligibleOrderId = eligibleOrderId;
            this.message = message;
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

} 