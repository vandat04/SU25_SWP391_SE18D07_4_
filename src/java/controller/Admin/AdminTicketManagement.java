/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import entity.Account.Account;
import entity.Ticket.Ticket;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import service.TicketService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "AdminTicketManagement", urlPatterns = {"/admin-ticket-management"})
public class AdminTicketManagement extends HttpServlet {

    List<Ticket> listTicket;
    TicketService tService = new TicketService();

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

        // Check if user is logged in and is a seller
        if (account == null || account.getRole() != 3) {
            response.sendRedirect("login");
            return;
        }
        
        String error = request.getParameter("error");
        String statusStr = request.getParameter("status");
        String searchIDStr = request.getParameter("searchID");
        String searchContent = request.getParameter("contentSearch") != null ? request.getParameter("contentSearch") : "";
        int searchID = 0;
        int status = 1;
        
        int page = 1;
int pageSize = 10;

String pageStr = request.getParameter("page");
if (pageStr != null) {
    try {
        page = Integer.parseInt(pageStr);
    } catch (NumberFormatException e) {
        page = 1;
    }
}
        try {
            searchID = Integer.parseInt(searchIDStr);
        } catch (Exception e) {
        }
        try {
            status = Integer.parseInt(statusStr);
        } catch (Exception e) {
        }
        int offset = (page - 1) * pageSize;
listTicket = tService.searchTicketByAdmin(status, searchID, searchContent, offset, pageSize);

// Lấy tổng số ticket để tính số trang
int totalTicket = tService.countTotalTicketByAdmin(status, searchID, searchContent);
int totalPage = (int) Math.ceil((double) totalTicket / pageSize);

request.setAttribute("listTicket", listTicket);
request.setAttribute("totalPage", totalPage);
request.setAttribute("currentPage", page);
        if (error != null){
            if (error.equals("1")){
                request.setAttribute("error", error);
                request.setAttribute("message", "Load success");
            } else {
                request.setAttribute("error", error);
                request.setAttribute("message", "Load fail");
            }
        }
        request.setAttribute("status", status);
        request.setAttribute("listTicket", listTicket);
        request.getRequestDispatcher("admin-ticket-management.jsp").forward(request, response);
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

        String typeName = request.getParameter("typeName");

        String ticketID = request.getParameter("ticketID");
        String villageID = request.getParameter("villageID");
        String typeID = request.getParameter("typeID");
        String price = request.getParameter("price");
        String status = request.getParameter("status");
        String statusTicket = request.getParameter("statusTicket");
        boolean result = false;
        int error = 0;
        switch (typeName) {

            case "updateTicket":
                try {
                    Ticket ticket = new Ticket(Integer.parseInt(ticketID), BigDecimal.valueOf(Double.parseDouble(price)), Integer.parseInt(statusTicket));
                    result = tService.updateTicketByAdmin(ticket);
                } catch (Exception e) {
                }
                break;
            case "createTicket":
                try {
                    Ticket ticket = new Ticket(Integer.parseInt(villageID), Integer.parseInt(typeID), BigDecimal.valueOf(Double.parseDouble(price)), Integer.parseInt(status));
                    result = tService.createTicketByAdmin(ticket);
                } catch (Exception e) {
                }
                break;
            case "deleteTicket":
                try {
                    result = tService.deleteTicketByAdmin(Integer.parseInt(ticketID));
                } catch (Exception e) {
                }
                break;

            default:
                throw new AssertionError();
        }
        if (result) {
            error = 1;
        }
        response.sendRedirect("admin-ticket-management?status=" + status + "&error=" + error);

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
