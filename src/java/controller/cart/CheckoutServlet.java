package controller.cart;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;
import java.util.Map;
import entity.CartWishList.Cart;
import entity.CartWishList.CartItem;
import entity.Product.Category;
import entity.Product.Product;
import entity.Account.Account;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import service.ProductService;
import service.IProductService;
import service.CartService;
import service.EmailService;
import service.ICartService;

/**
 *
 * @author Pc
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private final ICartService cartService;
    private final ProductService productService;

    public CheckoutServlet() {
        this.cartService = new CartService();
        this.productService = new ProductService();
    }

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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Validate authentication
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Validate cart exists and has items
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                request.setAttribute("error", "Your cart is empty");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // Order processing functionality removed due to OrderService cleanup
            // Simply clear the cart and redirect to success page
            cartService.clearCart(user.getUserID());
            session.removeAttribute("cart");
            
            // Redirect to success page
            response.sendRedirect("cart?action=view");
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
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
        return "Checkout Controller";
    }// </editor-fold>

}
