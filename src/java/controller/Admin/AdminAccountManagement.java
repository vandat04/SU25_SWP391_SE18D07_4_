/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import entity.Account.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.AccountService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "AdminAccountManagement", urlPatterns = {"/admin-account-management"})
public class AdminAccountManagement extends HttpServlet {

    private static final int PAGE_SIZE = 16;

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
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        String statusStr = request.getParameter("status");
        String searchIDStr = request.getParameter("searchID");
        String contentSearch = request.getParameter("contentSearch");

        AccountService aService = new AccountService();
        List<Account> listAccount;
        int totalAccounts;
        int totalPages;

        if (statusStr != null && searchIDStr != null && contentSearch != null) {
            // Search mode with pagination (assuming AccountService has been modified to support pagination)
            int status = Integer.parseInt(statusStr);
            int searchID = Integer.parseInt(searchIDStr);
            int offset = (currentPage - 1) * PAGE_SIZE;
            listAccount = aService.getSearchAccount(status, searchID, contentSearch, offset, PAGE_SIZE);
            totalAccounts = aService.getTotalSearchAccounts(status, searchID, contentSearch); // New method needed in AccountService
            totalPages = (int) Math.ceil((double) totalAccounts / PAGE_SIZE);

            // Set search params for pagination links in JSP
            request.setAttribute("statusSearch", statusStr);
            request.setAttribute("searchIDSearch", searchIDStr);
            request.setAttribute("contentSearchSearch", contentSearch);
        } else {
            // All accounts with pagination (assuming AccountService has been modified to support pagination)
            int offset = (currentPage - 1) * PAGE_SIZE;
            listAccount = aService.getAllAccounts(offset, PAGE_SIZE); // Modified method in AccountService
            totalAccounts = aService.getTotalAccounts(); // New method needed in AccountService
            totalPages = (int) Math.ceil((double) totalAccounts / PAGE_SIZE);
        }

        request.setAttribute("listAccount", listAccount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("admin-account-management.jsp").forward(request, response);
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
        AccountService aService = new AccountService();
        String typeName = request.getParameter("typeName");
        String userID = request.getParameter("userID");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String roleID = request.getParameter("roleID");
        String status = request.getParameter("status");
        String searchID = request.getParameter("searchID");
        String contentSearch = request.getParameter("contentSearch");

        switch (typeName) {
            case "updateProfile":
                try {
                    Account account = new Account(Integer.parseInt(userID), userName, password, email, address, phoneNumber, Integer.parseInt(status), Integer.parseInt(roleID), fullName);
                    boolean result = aService.updateProfile(account);
                    if (result) {
                        request.setAttribute("error", "1");
                        request.setAttribute("message", "Update Success");
                    } else {
                        request.setAttribute("error", "0");
                        request.setAttribute("message", "Update error Email or phone number already exists");
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "0");
                    request.setAttribute("message", "Update Fail");
                }
                break;
            case "addAccount":
                try {
                    Account account = new Account(userName, password, email, address, phoneNumber, Integer.parseInt(status), Integer.parseInt(roleID), fullName);
                    boolean result = aService.addNewAccountFull(account);
                    if (result) {
                        request.setAttribute("error", "1");
                        request.setAttribute("message", "Add Success");
                    } else {
                        request.setAttribute("error", "0");
                        request.setAttribute("message", "Add error Email or phone number already exists");
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "0");
                    request.setAttribute("message", "Add Fail");
                }
                break;
            case "searchAccount":
                // Redirect to GET with search params for pagination support
                String redirectUrl = "admin-account-management?status=" + status + "&searchID=" + searchID + "&contentSearch=" + contentSearch;
                response.sendRedirect(redirectUrl);
                return; // Stop further execution
            default:
                throw new AssertionError();
        }
        // For update/add, continue to processRequest to reload the list
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