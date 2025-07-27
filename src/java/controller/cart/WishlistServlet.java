package controller.cart;

import service.WishlistService;
import service.IWishlistService;
import service.CartService;
import service.ICartService;
import DAO.WishlistDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    
    // ✅ ONLY SERVICE LAYER INJECTION - NO DAO INJECTION
    private IWishlistService wishlistService;
    private ICartService cartService;
    // ❌ REMOVED: private WishlistDAO wishlistDAO;
    // ❌ REMOVED: private CartDAO cartDAO;

    public void init() {
        wishlistService = new WishlistService();
        cartService = new CartService();
        // ❌ REMOVED: wishlistDAO = new WishlistDAO();
        // ❌ REMOVED: cartDAO = new CartDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer sessionUserID = (Integer) session.getAttribute("userID");
        
        if (sessionUserID == null) {
            response.sendRedirect("Login.jsp?error=Please login to access wishlist");
            return;
        }

        String userIDParam = request.getParameter("userID");
        if (userIDParam == null || userIDParam.trim().isEmpty()) {
            userIDParam = sessionUserID.toString();
        }

        int userID;
        try {
            userID = Integer.parseInt(userIDParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("Login.jsp?error=Invalid user ID");
            return;
        }
        
        // Security check - users can only view their own wishlist
        if (userID != sessionUserID) {
            response.sendRedirect("wishlist?userID=" + sessionUserID + "&error=Access denied");
            return;
        }

        try {
            // ✅ ONLY SERVICE CALLS - NO DAO CALLS
            wishlistService.debugWishlistData(userID);
            
            // Get wishlist with product details
            List<WishlistDAO.WishlistWithProduct> wishlistWithProducts = 
                wishlistService.getWishlistWithProductDetails(userID);
            
            if (wishlistWithProducts == null) {
                wishlistWithProducts = new ArrayList<>();
            }

            int wishlistCount = wishlistWithProducts.size();
            session.setAttribute("wishlistCount", wishlistCount);
            
            System.out.println("[DEBUG] WishlistServlet - UserID: " + userID + ", Wishlist count: " + wishlistCount);

            request.setAttribute("wishlistWithProducts", wishlistWithProducts);
            request.setAttribute("userID", userID);
            request.getRequestDispatcher("wishlist.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("[ERROR] WishlistServlet.doGet - UserID: " + userID);
            e.printStackTrace();
            response.sendRedirect("home?error=Error loading wishlist");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // Không tạo session mới
        Integer sessionUserID = (session != null) ? (Integer) session.getAttribute("userID") : null;
        
        // ✅ THAY ĐỔI: Trả về JSON và mã lỗi 401 nếu chưa đăng nhập
        if (sessionUserID == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in\"}");
            return;
        }

        String action = request.getParameter("action");
        String userIDParam = request.getParameter("userID");
        
        if (userIDParam == null) {
            userIDParam = sessionUserID.toString();
        }
        
        int userID;
        try {
            userID = Integer.parseInt(userIDParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid user ID\"}");
            return;
        }
        
        // Security check
        if (userID != sessionUserID) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Access denied\"}");
            return;
        }

        try {
            if ("remove".equals(action)) {
                handleRemoveFromWishlist(request, response, userID);
            } else if ("addToCart".equals(action)) {
                handleAddToCart(request, response, userID);
            } else if ("moveAllToCart".equals(action)) {
                handleMoveAllToCart(request, response, userID);
            } else if ("add".equals(action)) {
                handleAddToWishlist(request, response, userID);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred\"}");
        }
    }
    
    /**
     * ✅ REFACTORED: Remove from wishlist - Only calls Service layer, always returns JSON
     */
    private void handleRemoveFromWishlist(HttpServletRequest request, HttpServletResponse response, int userID) 
            throws IOException {
        String wishlistIDParam = request.getParameter("wishlistID");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (wishlistIDParam == null || wishlistIDParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid wishlist item\"}");
            return;
        }
        try {
            int wishlistID = Integer.parseInt(wishlistIDParam);
            boolean success = wishlistService.deleteWishlist(wishlistID);
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Item removed from wishlist\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to remove item\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid wishlist item ID\"}");
        }
    }
    
    /**
     * ✅ REFACTORED: Add to cart from wishlist - Only calls Service layer, always returns JSON
     */
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, int userID) 
            throws IOException {
        String productIDParam = request.getParameter("productID");
        String wishlistIDParam = request.getParameter("wishlistID");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (productIDParam == null || productIDParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid product\"}");
            return;
        }
        try {
            int productID = Integer.parseInt(productIDParam);
            int wishlistID = -1;
            if (wishlistIDParam != null && !wishlistIDParam.trim().isEmpty()) {
                wishlistID = Integer.parseInt(wishlistIDParam);
            }
            boolean success = wishlistService.moveItemToCart(userID, productID, wishlistID);
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Item moved to cart\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to add item to cart\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid product ID\"}");
        }
    }
    
    /**
     * ✅ REFACTORED: Move all items to cart - Only calls Service layer, always returns JSON
     */
    private void handleMoveAllToCart(HttpServletRequest request, HttpServletResponse response, int userID) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            boolean success = wishlistService.moveAllItemsToCart(userID);
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\", \"message\": \"All items moved to cart\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Wishlist is empty\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to move items to cart\"}");
        }
    }
    
    /**
     * ✅ REFACTORED: Add product to wishlist - Only calls Service layer, always returns JSON
     */
    private void handleAddToWishlist(HttpServletRequest request, HttpServletResponse response, int userID) 
            throws IOException {
        String productIDParam = request.getParameter("productID");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (productIDParam == null || productIDParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Mã sản phẩm không hợp lệ.\"}");
            return;
        }
        try {
            int productID = Integer.parseInt(productIDParam);
            boolean success = wishlistService.addProductToWishlist(userID, productID);
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Đã thêm sản phẩm vào danh sách yêu thích!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Sản phẩm này đã có trong danh sách yêu thích.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Mã sản phẩm không hợp lệ.\"}");
        }
    }
}
