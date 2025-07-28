package controller.Seller;

import entity.Account.Account;
import entity.Orders.Order;
import entity.Orders.OrderDetail;
import entity.Product.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.OrderService;
import service.ProductService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "SellerOrderDetail", urlPatterns = {"/seller-order-detail"})
public class SellerOrderDetail extends HttpServlet {

    private OrderService orderService = new OrderService();
    private VillageService villageService = new VillageService();
    private ProductService productService = new ProductService();

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
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null || account.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        String orderDetailIdStr = request.getParameter("id");
        
        if (orderDetailIdStr == null || orderDetailIdStr.isEmpty()) {
            response.sendRedirect("seller-order-management");
            return;
        }
        
        try {
            int orderDetailId = Integer.parseInt(orderDetailIdStr);
            OrderDetail orderDetail = orderService.getOrderDetailById(orderDetailId);
            
            if (orderDetail == null) {
                response.sendRedirect("seller-order-management");
                return;
            }
            
            // Verify that this order belongs to seller's village
            int sellerId = account.getUserID();
            int sellerVillageId = villageService.getVillageIdBySellerId(sellerId);
            
            if (orderDetail.getVillageID() != sellerVillageId) {
                response.sendRedirect("seller-order-management");
                return;
            }
            
            // Get main order information
            Order mainOrder = orderService.getOrderById(orderDetail.getOrderId());
            
            // Get product information
            Product product = productService.getProductByID(String.valueOf(orderDetail.getProductId()));
            orderDetail.setProduct(product);
            
            // Get customer information
            Account customer = orderService.getCustomerByOrderId(orderDetail.getOrderId());
            
            // Set attributes
            request.setAttribute("orderDetail", orderDetail);
            request.setAttribute("mainOrder", mainOrder);
            request.setAttribute("customer", customer);
            
            request.getRequestDispatcher("seller-order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("seller-order-management");
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
        return "Seller Order Detail Servlet";
    }// </editor-fold>

}
