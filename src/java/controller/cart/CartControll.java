/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.cart;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entity.CartWishList.Cart;
import entity.CartWishList.CartItem;
import entity.CartWishList.CartTicket;
import java.util.ArrayList;
import entity.Account.Account;
import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;
import service.ProductService;
import service.CartService;
import service.ICartService;
import service.CartTicketService;
import service.ICartTicketService;
import entity.CartWishList.CartWithValidationInfo;

/**
 *
 * @author Pc
 */
@WebServlet(name="CartControll", urlPatterns={"/cart"})
public class CartControll extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // ✅ ONLY SERVICE LAYER INJECTION - NO DAO INJECTION
    private ProductService productService = new ProductService();
    private ICartService cartService = new CartService();
    private ICartTicketService cartTicketService = new CartTicketService();
    // ❌ REMOVED: private CartDAO cartDAO = new CartDAO();
    // ❌ REMOVED: private CartTicketDAO cartTicketDAO = new CartTicketDAO();

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Add cache control headers to prevent browser caching
        setCacheControlHeaders(response);
        
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("acc");

            String action = request.getParameter("action");
            if (action == null) {
                action = "view"; // Default action
            }

            System.out.println("[DEBUG] CartControll doGet action: " + action);
            
            if (account != null) {
                switch (action) {
                    case "view":
                        viewCart(request, response);
                        break;
                    case "remove":
                        removeFromCart(request, response);
                        break;
                    case "clear":
                        clearCart(request, response);
                        break;
                    case "applyDiscount":
                        applyDiscount(request, response);
                        break;
                    default:
                        viewCart(request, response);
                        break;
                }
            } else {
                // User not logged in, redirect to login
                response.sendRedirect("login");
            }
        } catch (Exception e) {
            handleException(e, response, "Exception in doGet");
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        setCacheControlHeaders(response);
        
        Account account = validateUserAuthentication(request, response);
        if (account == null) return; // Response already handled
        
        String action = request.getParameter("action");
        logDebugInfo("doPost received action", action);
        
        if (action == null) {
            logDebugInfo("No action specified", "redirecting to view");
            response.sendRedirect("cart?action=view");
            return;
        }

        try {
            handleCartAction(action, request, response);
        } catch (Exception e) {
            handleException(e, response, "Exception in doPost");
        }
    }

    /**
     * ✅ REFACTORED: Add product to cart - Only calls Service layer
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("id");
        int quantity = parseIntParameter(request, "quantity", 1);

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            System.out.println("[DEBUG] User not logged in during addToCart");
            response.setContentType("text/plain");
            response.getWriter().write("login");
            return;
        }

        if (productId == null || productId.trim().isEmpty()) {
            System.out.println("[ERROR] Product ID is null or empty");
            response.setContentType("text/plain");
            response.getWriter().write("error");
            return;
        }

        try {
            // ✅ ONLY SERVICE CALLS - NO DAO CALLS
            int productIdInt = Integer.parseInt(productId);
            boolean success = cartService.addProductToCart(account.getUserID(), productIdInt, quantity);
            
            if (success) {
                // ✅ Get updated cart through Service
                Cart updatedCart = cartService.getCartByUser(account.getUserID());
                session.setAttribute("cart", updatedCart);
                System.out.println("[DEBUG] Updated cart in session: " + updatedCart);
                
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } else {
                response.setContentType("text/plain");
                response.getWriter().write("error");
            }
        } catch (NumberFormatException e) {
            System.out.println("[ERROR] Invalid product ID format: " + productId);
            response.setContentType("text/plain");
            response.getWriter().write("error");
        } catch (Exception e) {
            System.out.println("[ERROR] Exception in addToCart: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().write("error");
        }
    }

    /**
     * ✅ REFACTORED: Remove product from cart - Only calls Service layer
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        String productId = request.getParameter("id");
        
        if (account == null) {
            response.setContentType("text/plain");
            response.getWriter().write("login");
            return;
        }
        
        try {
            if (productId != null && !productId.trim().isEmpty()) {
                // ✅ ONLY SERVICE CALL - NO DAO CALL
                boolean success = cartService.removeCartItemByUser(account.getUserID(), Integer.parseInt(productId));
                
                if (success) {
                    // ✅ Get updated cart through Service
                    Cart updatedCart = cartService.getCartByUser(account.getUserID());
                    session.setAttribute("cart", updatedCart);
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Error parsing product ID: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Error removing product from cart: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("cart?action=view");
    }

    /**
     * ✅ REFACTORED: Update cart item quantity - Only calls Service layer
     */
    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[DEBUG] === updateCart method called ===");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        int productId = parseIntParameter(request, "id");
        int quantity = parseIntParameter(request, "quantity", 1);
        System.out.println("[DEBUG] productId=" + productId + ", quantity=" + quantity);

        if (account == null) {
            System.out.println("[DEBUG] User not logged in");
            response.setContentType("text/plain");
            response.getWriter().write("login");
            return;
        }

        // Validate quantity
        if (quantity < 0) {
            System.out.println("[DEBUG] Invalid quantity: " + quantity);
            response.setContentType("text/plain");
            response.getWriter().write("invalid_quantity");
            return;
        }

        try {
            // ✅ ONLY SERVICE CALL - NO DAO CALL
            boolean success = cartService.updateCartItemQuantity(account.getUserID(), productId, quantity);
            
            if (success) {
                // ✅ Get updated cart through Service
                Cart updatedCart = cartService.getCartByUser(account.getUserID());
                session.setAttribute("cart", updatedCart);
                System.out.println("[DEBUG] Cart refreshed and updated in session");
            }
            
            // Always redirect back to cart page, whether success or not
            response.sendRedirect("cart?action=view");

        } catch (Exception e) {
            System.out.println("[ERROR] Exception in updateCart: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("cart?action=view");
            return;
        }
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // ✅ ONLY SERVICE CALL
            cartService.clearCart(account.getUserID());
            session.removeAttribute("cart");
        } catch (Exception e) {
            System.out.println("Error clearing cart: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("cart?action=view");
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // ✅ NEW: Get cart with comprehensive validation (both products and tickets)
            CartWithValidationInfo cartWithValidationInfo = cartService.getCartWithComprehensiveValidation(account.getUserID());
            Cart cart = cartWithValidationInfo.getCart();
            
            session.setAttribute("cart", cart);
            
            // ✅ NEW: Handle comprehensive validation results
            if (cartWithValidationInfo.hasAnyIssues()) {
                // Get the action parameter to determine what to do with issues
                String stockAction = request.getParameter("stockAction");
                
                if ("removeOutOfStock".equals(stockAction)) {
                    // Remove out-of-stock products and sold-out tickets
                    boolean productChanges = cartService.removeOutOfStockItems(account.getUserID());
                    boolean ticketChanges = cartService.removeSoldOutTickets(account.getUserID());
                    
                    if (productChanges || ticketChanges) {
                        // Refresh cart after removal
                        cartWithValidationInfo = cartService.getCartWithComprehensiveValidation(account.getUserID());
                        cart = cartWithValidationInfo.getCart();
                        session.setAttribute("cart", cart);
                        
                        // Add success message
                        String message = "Đã xóa ";
                        if (productChanges && ticketChanges) {
                            message += "sản phẩm hết hàng và vé đã hết khỏi giỏ hàng";
                        } else if (productChanges) {
                            message += "sản phẩm hết hàng khỏi giỏ hàng";
                        } else {
                            message += "vé đã hết khỏi giỏ hàng";
                        }
                        request.setAttribute("stockMessage", message);
                        request.setAttribute("stockMessageType", "success");
                    }
                } else if ("adjustQuantities".equals(stockAction)) {
                    // Auto-adjust quantities for both products and tickets
                    boolean productChanges = cartService.autoAdjustQuantities(account.getUserID());
                    boolean ticketChanges = cartService.autoAdjustTicketQuantities(account.getUserID());
                    
                    if (productChanges || ticketChanges) {
                        // Refresh cart after adjustment
                        cartWithValidationInfo = cartService.getCartWithComprehensiveValidation(account.getUserID());
                        cart = cartWithValidationInfo.getCart();
                        session.setAttribute("cart", cart);
                        
                        // Add success message
                        String message = "Đã điều chỉnh số lượng ";
                        if (productChanges && ticketChanges) {
                            message += "sản phẩm và vé theo tình trạng có sẵn";
                        } else if (productChanges) {
                            message += "sản phẩm theo tồn kho";
                        } else {
                            message += "vé theo tình trạng có sẵn";
                        }
                        request.setAttribute("stockMessage", message);
                        request.setAttribute("stockMessageType", "success");
                    }
                }
            }
            
            // Set attributes cho JSP
            if (cart != null) {
                List<CartItem> items = cart.getItems();
                List<CartTicket> tickets = cart.getTickets();
                
                request.setAttribute("cartItems", items != null ? items : new ArrayList<>());
                request.setAttribute("cartTickets", tickets != null ? tickets : new ArrayList<>());
                request.setAttribute("grandTotal", cart.getTotalAmount());
                
                System.out.println("[DEBUG] Cart loaded - Items: " + (items != null ? items.size() : 0) + 
                                 ", Tickets: " + (tickets != null ? tickets.size() : 0) + 
                                 ", Total: " + cart.getTotalAmount());
                
                // ✅ DEBUG: Print actual ticket details being set to JSP
                if (tickets != null && !tickets.isEmpty()) {
                    System.out.println("[DEBUG] Setting cartTickets attribute with " + tickets.size() + " tickets:");
                    for (CartTicket ticket : tickets) {
                        System.out.println("  - CartTicketId: " + ticket.getCartTicketId() + 
                                         ", TicketId: " + ticket.getTicketId() + 
                                         ", Date: " + ticket.getFormattedTicketDate() + 
                                         ", Quantity: " + ticket.getQuantity());
                    }
                } else {
                    System.out.println("[DEBUG] cartTickets is null or empty - will show 'Không có vé trong giỏ hàng'");
                }
            } else {
                request.setAttribute("cartItems", new java.util.ArrayList<>());
                request.setAttribute("cartTickets", new java.util.ArrayList<>());
                request.setAttribute("grandTotal", 0.0);
                System.out.println("[DEBUG] No cart found for user: " + account.getUserID());
            }
            
            // ✅ NEW: Add comprehensive validation information to request
            request.setAttribute("stockValidation", cartWithValidationInfo.getStockValidation());
            request.setAttribute("ticketValidation", cartWithValidationInfo.getTicketValidation());
            request.setAttribute("hasStockIssues", cartWithValidationInfo.hasProductStockIssues());
            request.setAttribute("hasTicketIssues", cartWithValidationInfo.hasTicketAvailabilityIssues());
            request.setAttribute("hasAnyIssues", cartWithValidationInfo.hasAnyIssues());
            request.setAttribute("stockValidationSummary", cartWithValidationInfo.getComprehensiveValidationSummary());
            request.setAttribute("issuePriority", cartWithValidationInfo.getIssuePriority());
            request.setAttribute("canCheckout", cartWithValidationInfo.canProceedToCheckout());
            
            // ✅ NEW: Add detailed validation info for each item type
            if (cartWithValidationInfo.getStockValidation() != null) {
                request.setAttribute("invalidItems", cartWithValidationInfo.getStockValidation().getInvalidItems());
                request.setAttribute("validItems", cartWithValidationInfo.getStockValidation().getValidItems());
            }
            
            if (cartWithValidationInfo.getTicketValidation() != null) {
                var ticketValidation = cartWithValidationInfo.getTicketValidation();
                request.setAttribute("invalidTickets", ticketValidation.getInvalidTickets());
                request.setAttribute("validTickets", ticketValidation.getValidTickets());
                
                // ✅ DEBUG: Print ticket validation details
                System.out.println("[DEBUG] Ticket validation details:");
                System.out.println("  - Invalid tickets: " + ticketValidation.getInvalidTickets().size());
                System.out.println("  - Valid tickets: " + ticketValidation.getValidTickets().size());
                System.out.println("  - Has issues: " + ticketValidation.hasAnyTicketIssues());
                
                for (var invalidTicket : ticketValidation.getInvalidTickets()) {
                    System.out.println("  - Invalid ticket: CartTicketId=" + invalidTicket.getTicket().getCartTicketId() + 
                                     ", Message=" + invalidTicket.getResult().getMessage() + 
                                     ", AvailableSlots=" + invalidTicket.getResult().getAvailableSlots() + 
                                     ", RequestedQuantity=" + invalidTicket.getTicket().getQuantity());
                }
            } else {
                System.out.println("[DEBUG] No ticket validation found");
            }
            
            // Forward to JSP only if no errors occurred
            request.getRequestDispatcher("ShoppingCart.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error viewing cart: " + e.getMessage());
            e.printStackTrace();
            
            // Handle error without redirect since response might be committed
            request.setAttribute("error", "Lỗi khi tải giỏ hàng: " + e.getMessage());
            request.setAttribute("cartItems", new java.util.ArrayList<>());
            request.setAttribute("cartTickets", new java.util.ArrayList<>());
            request.setAttribute("grandTotal", 0.0);
            
            // Try to forward to cart page with error message
            try {
                request.getRequestDispatcher("ShoppingCart.jsp").forward(request, response);
            } catch (Exception forwardException) {
                // If forward fails, try to write directly to response
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cart loading error");
                }
            }
        }
    }

    private Cart getOrCreateCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            return null;
        }
        
        // ✅ ONLY SERVICE CALL - NO DAO CALL
        return cartService.getOrCreateCart(account.getUserID());
    }

    private void applyDiscount(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        // Implementation for discount application
        String discountCode = request.getParameter("discountCode");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart != null && discountCode != null) {
            cartService.applyDiscount(cart, discountCode);
        }
        
        response.sendRedirect("cart?action=view");
    }

    private int parseIntParameter(HttpServletRequest request, String paramName) {
        return parseIntParameter(request, paramName, -1);
    }

    private int parseIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String value = request.getParameter(paramName);
        if (value != null && !value.trim().isEmpty()) {
            try {
                return Integer.parseInt(value.trim());
            } catch (NumberFormatException e) {
                System.out.println("Error parsing parameter " + paramName + ": " + value);
            }
        }
        return defaultValue;
    }

    /**
     * ✅ REFACTORED: Add ticket to cart - Only calls Service layer, no validation exceptions
     */
    private void addTicketToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            response.setContentType("text/plain");
            response.getWriter().write("login");
            return;
        }
        
        try {
            int ticketId = parseIntParameter(request, "ticketId");
            int quantity = parseIntParameter(request, "quantity", 1);
            String ticketDateStr = request.getParameter("ticketDate");
            
            if (ticketId == -1 || ticketDateStr == null || ticketDateStr.trim().isEmpty()) {
                response.setContentType("text/plain");
                response.getWriter().write("invalid_parameters");
                return;
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date ticketDate = sdf.parse(ticketDateStr);
            
            // ✅ ONLY SERVICE CALL - NO DAO CALL - No validation exceptions thrown
            boolean success = cartService.addTicketToCartByUser(account.getUserID(), ticketId, ticketDate, quantity);
            
            if (success) {
                // ✅ Get updated cart through Service
                Cart updatedCart = cartService.getCartByUser(account.getUserID());
                session.setAttribute("cart", updatedCart);
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } else {
                response.setContentType("text/plain");
                response.getWriter().write("error");
            }
            
        } catch (Exception e) {
            System.out.println("Error adding ticket to cart: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().write("error");
        }
    }

    /**
     * ✅ REFACTORED: Remove ticket from cart - Only calls Service layer
     */
    private void removeTicketFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            response.setContentType("text/plain");
            response.getWriter().write("login");
            return;
        }
        
        try {
            int itemId = parseIntParameter(request, "itemId");
            
            if (itemId != -1) {
                // ✅ ONLY SERVICE CALL - NO DAO CALL
                boolean success = cartService.removeTicketByUser(account.getUserID(), itemId);
                
                if (success) {
                    // ✅ Get updated cart through Service
                    Cart updatedCart = cartService.getCartByUser(account.getUserID());
                    session.setAttribute("cart", updatedCart);
                }
            }
        } catch (Exception e) {
            System.out.println("Error removing ticket from cart: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("cart?action=view");
    }

    /**
     * ✅ REFACTORED: Update ticket quantity in cart - Only calls Service layer
     */
    private void updateTicketInCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            response.setContentType("text/plain");
            response.getWriter().write("login");
            return;
        }
        
        try {
            int itemId = parseIntParameter(request, "itemId");
            int quantity = parseIntParameter(request, "quantity", 1);
            
            if (itemId != -1) {
                // ✅ ONLY SERVICE CALL - NO DAO CALL  
                boolean success = cartService.updateTicketQuantityByUser(account.getUserID(), itemId, quantity);
                
                if (success) {
                    // ✅ Get updated cart through Service
                    Cart updatedCart = cartService.getCartByUser(account.getUserID());
                    session.setAttribute("cart", updatedCart);
                }
            }
        } catch (Exception e) {
            System.out.println("Error updating ticket in cart: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("cart?action=view");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Cart Controller Servlet";
    }// </editor-fold>
    
    // ===== HELPER METHODS FOR CLEAN CODE =====
    
    /**
     * Set cache control headers to prevent browser caching
     */
    private void setCacheControlHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
    
    /**
     * Validate user authentication and return account or null if not authenticated
     */
    private Account validateUserAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null) {
            logDebugInfo("User not logged in", "");
            response.setContentType("text/plain");
            response.getWriter().write("login");
        }
        
        return account;
    }
    
    /**
     * Centralized debug logging method
     */
    private void logDebugInfo(String message, String detail) {
        System.out.println("[DEBUG] " + message + (detail != null && !detail.isEmpty() ? ": " + detail : ""));
    }
    
    /**
     * Handle cart actions with clean switch statement
     */
    private void handleCartAction(String action, HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        switch (action) {
            case "add":
                addToCart(request, response);
                break;
            case "remove":
                removeFromCart(request, response);
                break;
            case "clear":
                clearCart(request, response);
                break;
            case "update":
                updateCart(request, response);
                break;
            case "addTicket":
                addTicketToCart(request, response);
                break;
            case "removeTicket":
                removeTicketFromCart(request, response);
                break;
            case "updateTicket":
                updateTicketInCart(request, response);
                break;
            case "view":
                logDebugInfo("View action in POST", "redirecting to GET");
                response.sendRedirect("cart?action=view");
                break;
            default:
                logDebugInfo("Unknown action", action);
                response.sendRedirect("cart?action=view");
                break;
        }
    }
    
    /**
     * Centralized exception handling
     */
    private void handleException(Exception e, HttpServletResponse response, String context) 
            throws IOException {
        System.out.println("[ERROR] " + context + ": " + e.getMessage());
        e.printStackTrace();
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<h1>Error: " + e.getMessage() + "</h1>");
    }

}