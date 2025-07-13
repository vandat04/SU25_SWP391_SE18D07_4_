/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Seller;

import DAO.ReportDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.Map;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entity.Account.Account; // Assuming you have an Account model
import entity.SalesReport.SalesReport; // Import the newly defined SalesReport

@WebServlet(name = "StatisticsServlet", urlPatterns = {"/statistics"})
public class StatisticsServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Account loggedInAccount = (Account) session.getAttribute("acc"); // Assuming 'acc' stores the logged-in user

        // Check if user is logged in and has the seller role (RoleID 2)
        if (loggedInAccount == null || loggedInAccount.getRoleID() != 2) {
            response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login if not logged in or not a seller
            return;
        }

        ReportDAO reportDAO = new ReportDAO();
        int sellerId = loggedInAccount.getUserID(); // Assuming userID is the sellerID

        try {
            // --- System-Wide Statistics (as available in the current ReportDAO) ---
            // These methods from ReportDAO are for overall system reports, not filtered by sellerId.
            // If you need seller-specific statistics, you will need to add new methods to ReportDAO
            // that take 'sellerId' as a parameter and query the database accordingly (e.g., join with Orders/TicketOrder
            // and filter by the seller's product/ticket).

            // Example: Get Monthly Account Registrations for the current year (system-wide)
            int currentYear = LocalDate.now().getYear();
            Map<Integer, Integer> monthlyAccountRegistrations = reportDAO.getRegistrationSummaryByMonthYear(currentYear);
            request.setAttribute("monthlyAccountRegistrations", monthlyAccountRegistrations);

            // Example: Get Order Status Summary (system-wide)
            Map<Integer, Integer> orderStatusSummary = reportDAO.getOrderStatusSummary();
            request.setAttribute("orderStatusSummary", orderStatusSummary);

            // Example: Get overall revenue (system-wide, for the current month)
            LocalDate today = LocalDate.now();
            int currentMonth = today.getMonthValue();
            int currentDay = today.getDayOfMonth();
            BigDecimal dailyRevenueSystem = reportDAO.getRevenueByDayMonthYear(currentDay, currentMonth, currentYear);
            request.setAttribute("dailyRevenueSystem", dailyRevenueSystem);

            // --- Placeholder for Seller-Specific Statistics ---
            // The following are conceptual and would require modifications to ReportDAO
            // or creation of a new SellerReportDAO.

            // 1. Get Seller's Order Counts by Status (conceptual: needs DAO method)
            // Example: A new method in ReportDAO like: Map<Integer, Integer> getSellerOrderCountsByStatus(int sellerId);
            // For now, we'll just pass a placeholder or implement a mock if needed for testing.
            // Map<Integer, Integer> sellerOrderCounts = reportDAO.getSellerOrderCountsByStatus(sellerId);
            // request.setAttribute("sellerOrderCounts", sellerOrderCounts);
            request.setAttribute("sellerOrderCounts", Map.of(1, 10, 2, 5, 3, 2)); // Mock data

            // 2. Get Seller's Daily Revenue (conceptual: needs DAO method)
            // Example: A new method in ReportDAO like: BigDecimal getSellerDailyRevenue(int sellerId, LocalDate date);
            // double sellerDailyRevenue = reportDAO.getSellerDailyRevenue(sellerId, today);
            // request.setAttribute("sellerDailyRevenue", sellerDailyRevenue);
            request.setAttribute("sellerDailyRevenue", new BigDecimal("1500.75")); // Mock data

            // 3. Get Seller's Monthly Sales Reports (conceptual: needs DAO method)
            // This would fetch data from the SalesReport table where sellerID matches.
            // Example: A new method in ReportDAO like: List<SalesReport> getMonthlySalesReportsBySeller(int sellerId);
            // For this, you would need to implement a method in ReportDAO to map the SalesReport table
            // into a List<SalesReport> based on sellerId.
            List<SalesReport> monthlySalesReports = reportDAO.getMonthlySalesReportsBySeller(sellerId) ;
            // Mock data for SalesReport
            

            request.setAttribute("monthlyReports", monthlySalesReports);


            // Forward to the JSP page
            request.getRequestDispatcher("statistics.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // Log the exception for debugging
            request.setAttribute("errorMessage", "Error fetching statistics: " + e.getMessage());
            request.getRequestDispatcher("/views/seller/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

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
        return "Servlet for seller statistics.";
    }
}