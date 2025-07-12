/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.cart;

import entity.CartWishList.Cart;
import entity.CartWishList.CartItem;
import entity.Account.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.CartService;
import service.ICartService;
import entity.CartWishList.CartWithStockInfo;
import entity.CartWishList.CartStockValidation;

/**
 *
 * @author DELL
 */
@WebServlet(name = "CheckoutBefor", urlPatterns = {"/checkoutBefor"})
public class CheckoutBefor extends HttpServlet {
    private final ICartService cartService;

    public CheckoutBefor() {
        this.cartService = new CartService();
    }

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
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // ✅ NEW: Get cart with stock validation instead of just cart from session
            CartWithStockInfo cartWithStockInfo = cartService.getCartWithStockValidation(user.getUserID());
            Cart cart = cartWithStockInfo.getCart();
            
            if (cart == null || cart.getItems().isEmpty()) {
                request.setAttribute("error", "Giỏ hàng của bạn đang trống");
                request.getRequestDispatcher("cart?action=view").forward(request, response);
                return;
            }

            // ✅ NEW: Check for stock issues before allowing checkout
            if (cartWithStockInfo.hasStockIssues()) {
                CartStockValidation stockValidation = cartWithStockInfo.getStockValidation();
                
                // Set error message with details
                String errorMessage = "Không thể thanh toán! Giỏ hàng có vấn đề: " + 
                                    stockValidation.getValidationSummary() + 
                                    ". Vui lòng xử lý các vấn đề này trước khi thanh toán.";
                
                request.setAttribute("error", errorMessage);
                request.setAttribute("stockValidation", stockValidation);
                request.setAttribute("hasStockIssues", true);
                request.setAttribute("stockValidationSummary", stockValidation.getValidationSummary());
                
                // Redirect back to cart with error message
                response.sendRedirect("cart?action=view&error=" + 
                                    java.net.URLEncoder.encode(errorMessage, "UTF-8"));
                return;
            }

            // ✅ NEW: Final stock validation before proceeding 
            // (in case stock changed between cart view and checkout)
            boolean stockValid = true;
            StringBuilder stockIssues = new StringBuilder();
            
            for (CartItem item : cart.getItems()) {
                if (!cartService.isProductAvailable(item.getProductID())) {
                    stockValid = false;
                    stockIssues.append("- ").append(item.getProductName()).append(" đã hết hàng\n");
                } else {
                    int currentStock = cartService.getCurrentStock(item.getProductID());
                    if (currentStock < item.getQuantity()) {
                        stockValid = false;
                        stockIssues.append("- ").append(item.getProductName())
                                  .append(" chỉ còn ").append(currentStock).append(" sản phẩm\n");
                    }
                }
            }
            
            if (!stockValid) {
                String errorMessage = "Không thể thanh toán! Một số sản phẩm có vấn đề:\n" + 
                                    stockIssues.toString() + 
                                    "Vui lòng cập nhật giỏ hàng và thử lại.";
                
                request.setAttribute("error", errorMessage);
                response.sendRedirect("cart?action=view&error=" + 
                                    java.net.URLEncoder.encode(errorMessage, "UTF-8"));
                return;
            }

            // Tính toán tổng tiền và các thông tin cần thiết
            double totalPrice = cartService.calculateTotalWithDiscount(cart);
            int totalItems = cart.getItems().size();
            
            // Lưu thông tin vào request để hiển thị trên trang checkout
            request.setAttribute("cart", cart);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("user", user);
            
            // ✅ NEW: Add stock validation info to checkout page
            request.setAttribute("stockValidation", cartWithStockInfo.getStockValidation());
            request.setAttribute("isStockValid", cartWithStockInfo.isCartValid());
            
            // Chuyển hướng đến trang checkout
            request.getRequestDispatcher("Checkout.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in CheckoutBefor: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
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
        processRequest(request, response);
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
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Checkout Before Controller with Stock Validation";
    }// </editor-fold>

}