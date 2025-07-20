/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.cart_order;

import entity.Orders.Payment;
import entity.Orders.SubOrder;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.OrderService;
import service.ReportService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "UpdateOrderListServlet", urlPatterns = {"/update-order-list"})
public class UpdateOrderListServlet extends HttpServlet {

    private OrderService oService = new OrderService();
    private ReportService rService = new ReportService();

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
        String userID = request.getParameter("userID");
        String subOrderIdStr = request.getParameter("subOrderId");
        int subOrderId = Integer.parseInt(subOrderIdStr);
        SubOrder subOrder = oService.getSubOrderById(subOrderId);
        boolean result = false;
        result = oService.confirmSubOrder(subOrderId);
        if (subOrder.getPaymentMethod().equalsIgnoreCase("cod")) {
            rService.addPaymentManagement(new Payment(subOrderId, rService.getSellerIdByVillageId(subOrder.getVillageId()), subOrder.getTotalPrice(), subOrder.getPaymentMethod(), 1, ""), 1, 2);
        }
        if (subOrder.getPaymentMethod().equalsIgnoreCase("cod") || subOrder.getPaymentMethod().equalsIgnoreCase("bankTransfer")) {
            oService.addPoints(Integer.parseInt(userID), subOrder.getPoints());
        }
        response.sendRedirect("order?cas=1&userID=" + userID);
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
        String userID = request.getParameter("userID");
        String subOrderIdStr = request.getParameter("subOrderId");
        int subOrderId = Integer.parseInt(subOrderIdStr);
        String cas = request.getParameter("cas");
        String reason = request.getParameter("reason");
        SubOrder subOrder = oService.getSubOrderById(subOrderId);

        boolean result = false;

        switch (cas) {
            case "cancelOrder":
                result = oService.cancelSubOrderDetail(subOrderId, reason);
                if (subOrder.getPaymentMethod().equalsIgnoreCase("bankTransfer") && subOrder.getPaymentStatus() == 1) {
                    oService.refundSubOrderPayment(subOrderId);
                }
                response.sendRedirect("order?cas=0&userID=" + userID);
                break;
            case "refundOrder":
                result = oService.refundSubOrder(subOrderId, reason);
                response.sendRedirect("order?cas=2&userID=" + userID);
                break;
            default:
                throw new AssertionError();
        }
        request.getRequestDispatcher("newjsp.jsp").forward(request, response);
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
