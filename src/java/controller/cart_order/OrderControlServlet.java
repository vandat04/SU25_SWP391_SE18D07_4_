/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.cart_order;

import entity.Orders.OrderDetail;
import entity.Orders.TicketOrderDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import service.OrderService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "OrderControlServlet", urlPatterns = {"/order"})
public class OrderControlServlet extends HttpServlet {

    OrderService oService = new OrderService();

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
        String cas = request.getParameter("cas");
        String userIDStr = request.getParameter("userID");
        int userID = Integer.parseInt(userIDStr);
        List<OrderDetail> orderDetail = new ArrayList<>();
        List<OrderDetail> processOrderDetail = new ArrayList<>();
        List<OrderDetail> deliveryOrderDetail = new ArrayList<>();
        List<OrderDetail> receiveOrderDetail = new ArrayList<>();
        List<OrderDetail> cancelOrderDetail = new ArrayList<>();
        List<OrderDetail> refundOrderDetail = new ArrayList<>();

        List<TicketOrderDetail> ticketOrderDetail = new ArrayList<>();
        List<TicketOrderDetail> processTicketOrderDetail = new ArrayList<>();
        List<TicketOrderDetail> deliveryTicketOrderDetail = new ArrayList<>();
        List<TicketOrderDetail> receiveTicketOrderDetail = new ArrayList<>();
        List<TicketOrderDetail> cancelTicketOrderDetail = new ArrayList<>();
        List<TicketOrderDetail> refundTicketOrderDetail = new ArrayList<>();

        orderDetail = oService.getAllOrderDetailByUserId(userID);
        ticketOrderDetail = oService.getAllTicketOrderDetailByUserId(userID);

        for (OrderDetail od : orderDetail) {
            int status = od.getStatus();
            if (status == 0) {
                processOrderDetail.add(0, od);
            } else if (status == 1) {
                deliveryOrderDetail.add(0, od);
            } else if (status == 2) {
                receiveOrderDetail.add(0, od);
            } else if (status == 3) {
                cancelOrderDetail.add(0, od);
            } else if (status == 4 || status == 5) {
                refundOrderDetail.add(0, od);
            }
        }

        for (TicketOrderDetail tod : ticketOrderDetail) {
            int status = tod.getStatus();
            if (status == 0) {
                processTicketOrderDetail.add(0, tod);
            } else if (status == 1) {
                deliveryTicketOrderDetail.add(0, tod);
            } else if (status == 2) {
                receiveTicketOrderDetail.add(0, tod);
            } else if (status == 3) {
                cancelTicketOrderDetail.add(0, tod);
            } else if (status == 4 || status == 5) {
                refundTicketOrderDetail.add(0, tod);
            }
        }

        switch (cas) {
            case "1":
                request.setAttribute("processOrderDetail", processOrderDetail);
                request.setAttribute("processTicketOrderDetail", processTicketOrderDetail);
                request.getRequestDispatcher("order-list-processing.jsp").forward(request, response);
                break;
            case "2":
                request.setAttribute("deliveryOrderDetail", deliveryOrderDetail);
                request.setAttribute("deliveryTicketOrderDetail", deliveryTicketOrderDetail);
                request.getRequestDispatcher("order-list-delivering.jsp").forward(request, response);
                break;
            case "3":
                request.setAttribute("receiveOrderDetail", receiveOrderDetail);
                request.setAttribute("receiveTicketOrderDetail", receiveTicketOrderDetail);
                request.getRequestDispatcher("order-list-received.jsp").forward(request, response);
                break;
            case "4":
                request.setAttribute("cancelOrderDetail", cancelOrderDetail);
                request.setAttribute("cancelTicketOrderDetail", cancelTicketOrderDetail);
                request.getRequestDispatcher("order-list-cancelled.jsp").forward(request, response);
                break;
            case "5":
                request.setAttribute("refundOrderDetail", refundOrderDetail);
                request.setAttribute("refundTicketOrderDetail", refundTicketOrderDetail);
                request.getRequestDispatcher("order-list-refunded.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("404Loi.jsp").forward(request, response);
                break;
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
