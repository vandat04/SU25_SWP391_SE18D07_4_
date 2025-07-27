/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import entity.Orders.SubOrder;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.OrderService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "AdminOrderManagement", urlPatterns = {"/admin-order-management"})
public class AdminOrderManagement extends HttpServlet {

    private OrderService oService = new OrderService();

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

        // Pagination parameters
        int pageSize = 10; // 10 orders per page
        int page = 1; // Default to page 1
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1; // Fallback to page 1 if invalid
            }
        }

        // Search parameters
        String statusStr = request.getParameter("status");
        String searchIDStr = request.getParameter("searchID");
        String searchContent = request.getParameter("contentSearch") != null ? request.getParameter("contentSearch") : "";
        
        int status = statusStr != null && !statusStr.isEmpty() ? Integer.parseInt(statusStr) : 7; // Default to 7 (All Status)
        int searchID = searchIDStr != null && !searchIDStr.isEmpty() ? Integer.parseInt(searchIDStr) : 0; // Default to 0 (All Village)

        // Calculate total orders and pages first
        int totalOrders = oService.getTotalSubOrders(status, searchID, searchContent);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        if (totalPages == 0) {
            totalPages = 1; // Show page 1 even if empty
        }

        // Adjust page to valid range
        if (page < 1) {
            page = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        // Fetch paginated orders
        List<SubOrder> subOrder = oService.getSearchSubOrderByAdmin(status, searchID, searchContent, page, pageSize);

        // Set attributes for JSP
        request.setAttribute("subOrder", subOrder);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("searchID", searchID);
        request.setAttribute("searchContent", searchContent);

        request.getRequestDispatcher("admin-order-management.jsp").forward(request, response);
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
        return "Admin Order Management Servlet with Pagination";
    }// </editor-fold>

}