/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Payment;

import entity.CartWishList.Cart;
import entity.CartWishList.CartItem;
import entity.CartWishList.CartTicket;
import entity.Orders.Order;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.OrderService;
import service.ProductService;
import service.TicketService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "AddOrderByTranfer", urlPatterns = {"/add-order"})
public class AddOrderByTranfer extends HttpServlet {

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

        OrderService oService = new OrderService();
        ProductService pService = new ProductService();
        TicketService tService = new TicketService();

        String codeID = request.getParameter("vnp_TxnRef");
        int orderID = Integer.parseInt(codeID);
        Order order = oService.getOrderById(orderID);

        int userID = order.getUserID();
        // 3. Lấy trạng thái giao dịch
        String transactionStatus = request.getParameter("vnp_TransactionStatus");

        // 4. Kiểm tra nếu giao dịch thành công (vnp_TransactionStatus = "00")
        if ("00".equals(transactionStatus)) {

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                request.setAttribute("error", "Your cart is empty");
                request.getRequestDispatcher("cart").forward(request, response);
                return;
            }

            oService.updatePaymentStatus(orderID, 1);
            oService.addPoints(userID, order.getPoints());

            List<CartItem> listItem = cart.getItems();
            List<CartTicket> listTicket = cart.getTickets();

            for (CartItem p : listItem) {
                oService.addOrderDetail(orderID, p.getProductID(), p.getQuantity(), p.getPrice(),
                        0, pService.getVillageIDByProductID(p.getProductID()), "bankTranfer", 1);
            }

            for (CartTicket t : listTicket) {
                oService.addTicketOrderDetail(orderID, t.getTicketId(), t.getQuantity(), t.getPrice(),
                        0, tService.getVillageIDByTicketID(t.getTicketId()), "bankTranfer", 1);
            }

            int cartID = oService.getCartIDByUserID(userID);
            oService.deleteCartItem(cartID);
            oService.deleteCartTicket(cartID);

            request.setAttribute("error", 1);
            request.getRequestDispatcher("NotificationOrder.jsp").forward(request, response);
        } else {
            request.setAttribute("noti", "Transaction Fail");
            request.getRequestDispatcher("NotificationOrder.jsp").forward(request, response);

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
