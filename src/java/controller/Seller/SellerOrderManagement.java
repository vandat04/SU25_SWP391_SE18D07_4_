/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Seller;

import entity.Account.Account;
import entity.Orders.Order;
import entity.Orders.OrderDetail;
import entity.Orders.TicketOrderDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.OrderService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "SellerOrderManagement", urlPatterns = {"/seller-order-management"})
public class SellerOrderManagement extends HttpServlet {

    private OrderService orderService = new OrderService();
    private VillageService villageService = new VillageService();

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
        
        // Get seller's village ID
        int sellerId = account.getUserID();
        int villageId = villageService.getVillageIdBySellerId(sellerId);
        
        // Debug logging
        System.out.println("DEBUG: Seller ID = " + sellerId);
        System.out.println("DEBUG: Village ID = " + villageId);
        
        if (villageId == 0) {
            request.setAttribute("error", "Bạn chưa có làng nghề để quản lý đơn hàng");
            request.getRequestDispatcher("seller-dashboard.jsp").forward(request, response);
            return;
        }
        
        // Pagination parameters
        int pageSize = 10;
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Filter parameters
        String statusStr = request.getParameter("status");
        int status = statusStr != null && !statusStr.isEmpty() ? Integer.parseInt(statusStr) : -1; // -1 = all
        
        String searchKeyword = request.getParameter("search");
        if (searchKeyword == null) searchKeyword = "";
        
        // Get order details for seller's village
        List<OrderDetail> orderDetails = orderService.getOrderDetailsByVillageId(villageId, status, searchKeyword, page, pageSize);
        int totalOrders = orderService.getTotalOrderDetailsByVillageId(villageId, status, searchKeyword);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        
        // Debug logging
        System.out.println("DEBUG: Found " + orderDetails.size() + " order details");
        System.out.println("DEBUG: Total orders = " + totalOrders);
        System.out.println("DEBUG: Status filter = " + status);
        System.out.println("DEBUG: Search keyword = '" + searchKeyword + "'");
        
        // Set attributes
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("status", status);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("villageId", villageId);
        
        request.getRequestDispatcher("seller-order-list.jsp").forward(request, response);
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
        return "Seller Order Management Servlet";
    }// </editor-fold>

}