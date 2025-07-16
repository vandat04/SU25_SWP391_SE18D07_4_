/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.cart_order;

import DAO.OrderDAO;
import entity.Orders.OrderDetail;
import entity.Orders.Payment;
import entity.Orders.TicketOrderDetail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateOrderListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateOrderListServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        String userID = request.getParameter("userID");
        String type = request.getParameter("type");
        String orderDetailID = request.getParameter("orderDetailID");
        String cancelReason = request.getParameter("cancelReason");
        String ticketOrderID = request.getParameter("ticketOrderID");
        String refundReason = request.getParameter("refundReason");
        boolean result = false;
        OrderDetail order = new OrderDetail();
        TicketOrderDetail ticketOrder = new TicketOrderDetail();

        switch (type) {
            case "cancelOrder":
                result = oService.cancelOrderDetail(Integer.parseInt(orderDetailID), cancelReason);
                order = oService.getOrderDetail(Integer.parseInt(orderDetailID));
                if (order.getPaymentMethod().equalsIgnoreCase("bankTransfer")) {
                    oService.refundPayment(Integer.parseInt(orderDetailID), 1);
                }
                response.sendRedirect("order?cas=1&userID=" + userID);
                break;
            case "cancelTicketOrder":
                result = oService.cancelTicketOrderDetail(Integer.parseInt(ticketOrderID), cancelReason);
                ticketOrder = oService.getTicketOrderDetail(Integer.parseInt(ticketOrderID));
                if (ticketOrder.getPaymentMethod().equalsIgnoreCase("bankTransfer")) {
                    oService.refundPayment(Integer.parseInt(ticketOrderID), 2);
                }
                response.sendRedirect("order?cas=1&userID=" + userID);
                break;
            case "confirmOrder":
                result = oService.confirmOrderDetail(Integer.parseInt(orderDetailID));
                order = oService.getOrderDetail(Integer.parseInt(orderDetailID));
                if (order.getPaymentMethod().equalsIgnoreCase("cod")|| order.getPaymentMethod().equalsIgnoreCase("bankTransfer")) {
                     rService.addPaymentManagement(new Payment(rService.getSellerIdByProductId(order.getProductID()), Integer.parseInt(orderDetailID), null, BigDecimal.valueOf(order.getQuantity() * order.getPrice()),order.getPaymentMethod(), 1), 1, 2);
                     new OrderDAO().addPoints(Integer.parseInt(userID), order.getPoints());
                }
                response.sendRedirect("order?cas=2&userID=" + userID);
                break;
            case "confirmTicketOrder":
                result = oService.confirmTicketOrderDetail(Integer.parseInt(ticketOrderID));
                ticketOrder = oService.getTicketOrderDetail(Integer.parseInt(ticketOrderID));
                if (ticketOrder.getPaymentMethod().equalsIgnoreCase("cod") || ticketOrder.getPaymentMethod().equalsIgnoreCase("bankTransfer")) {
                    rService.addPaymentManagement(new Payment(rService.getSellerIdByTicketId(ticketOrder.getTicketID()), null, Integer.parseInt(ticketOrderID), BigDecimal.valueOf(ticketOrder.getQuantity() * ticketOrder.getPrice().intValue()), ticketOrder.getPaymentMethod(), 1), 1, 2);
                    new OrderDAO().addPoints(Integer.parseInt(userID), ticketOrder.getPoints());
                }
                response.sendRedirect("order?cas=2&userID=" + userID);
                break;
            case "refundOrder":
                result = oService.refundOrderDetail(Integer.parseInt(orderDetailID), refundReason);
                response.sendRedirect("order?cas=3&userID=" + userID);
                break;
            case "refundTicketOrder":
                result = oService.refundTicketOrderDetail(Integer.parseInt(ticketOrderID), refundReason);
                response.sendRedirect("order?cas=3&userID=" + userID);
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
