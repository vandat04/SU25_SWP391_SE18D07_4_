/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Seller;

import entity.Account.Account;
import entity.CraftVillage.CraftVillage;
import entity.Product.Product;
import entity.Orders.SubOrder;
import service.VillageService;
import service.ProductService;
import service.OrderService;
import service.ReportService;
import service.SellerService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Seller Dashboard Controller - Handles seller management functionality
 * @author ACER
 */
@WebServlet(name = "SellerControl", urlPatterns = {"/seller"})
public class SellerControl extends HttpServlet {
    
    private VillageService villageService = new VillageService();
    private ProductService productService = new ProductService();
    private OrderService orderService = new OrderService();
    private ReportService reportService = new ReportService();

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
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");
        
        // Check if user is logged in and is a seller
        if (seller == null || seller.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Get seller's villages
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            
            // Get seller's products count
            int totalProducts = 0;
            int activeProducts = 0;
            
            if (sellerVillages != null && !sellerVillages.isEmpty()) {
                for (CraftVillage village : sellerVillages) {
                    try {
                        List<Product> villageProducts = productService.getProductsByVillage(village.getVillageID());
                        if (villageProducts != null) {
                            totalProducts += villageProducts.size();
                            activeProducts += (int) villageProducts.stream().filter(p -> p.getStatus() == 1).count();
                        }
                    } catch (Exception e) {
                        System.err.println("Error getting products for village " + village.getVillageID() + ": " + e.getMessage());
                    }
                }
            }
            
            // Get recent orders for seller
            List<SubOrder> recentOrders = null;
            try {
                recentOrders = orderService.getSellerRecentOrders(seller.getUserID(), 5);
            } catch (Exception e) {
                System.err.println("Error getting recent orders: " + e.getMessage());
                recentOrders = new java.util.ArrayList<>();
            }
            
            // Get monthly revenue data (current month and previous months for chart)
            java.util.Calendar cal = java.util.Calendar.getInstance();
            int currentMonth = cal.get(java.util.Calendar.MONTH) + 1;
            int currentYear = cal.get(java.util.Calendar.YEAR);
            
            // Prepare revenue data for chart (last 6 months)
            Map<String, BigDecimal> revenueData = new java.util.HashMap<>();
            
            // Get revenue for last 6 months (including current month)
            for (int i = 5; i >= 0; i--) {
                try {
                    java.util.Calendar tempCal = java.util.Calendar.getInstance();
                    tempCal.add(java.util.Calendar.MONTH, -i);
                    int month = tempCal.get(java.util.Calendar.MONTH) + 1;
                    int year = tempCal.get(java.util.Calendar.YEAR);
                    BigDecimal revenue = reportService.getSellerMonthlyRevenue(seller.getUserID(), month, year);
                    revenueData.put("month" + (6-i), revenue != null ? revenue : BigDecimal.ZERO);
                } catch (Exception e) {
                    System.err.println("Error getting revenue for month " + (6-i) + ": " + e.getMessage());
                    revenueData.put("month" + (6-i), BigDecimal.ZERO);
                }
            }
            
            // Current month revenue for stats card
            try {
                BigDecimal currentMonthRevenue = reportService.getSellerMonthlyRevenue(seller.getUserID(), currentMonth, currentYear);
                revenueData.put("currentMonth", currentMonthRevenue != null ? currentMonthRevenue : BigDecimal.ZERO);
            } catch (Exception e) {
                System.err.println("Error getting current month revenue: " + e.getMessage());
                revenueData.put("currentMonth", BigDecimal.ZERO);
            }
            
            // Set attributes for JSP
            request.setAttribute("seller", seller);
            request.setAttribute("sellerVillages", sellerVillages != null ? sellerVillages : new java.util.ArrayList<>());
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("recentOrders", recentOrders != null ? recentOrders : new java.util.ArrayList<>());
            request.setAttribute("revenueData", revenueData);
            
        } catch (Exception e) {
            // Log error and set default values
            System.err.println("Error in seller dashboard: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values in case of error
            request.setAttribute("seller", seller);
            request.setAttribute("sellerVillages", new java.util.ArrayList<>());
            request.setAttribute("totalProducts", 0);
            request.setAttribute("activeProducts", 0);
            request.setAttribute("recentOrders", new java.util.ArrayList<>());
            
            Map<String, BigDecimal> defaultRevenueData = new java.util.HashMap<>();
            for (int i = 1; i <= 6; i++) {
                defaultRevenueData.put("month" + i, BigDecimal.ZERO);
            }
            defaultRevenueData.put("currentMonth", BigDecimal.ZERO);
            request.setAttribute("revenueData", defaultRevenueData);
            
            // Set error message for user
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu dashboard. Vui lòng thử lại sau.");
        }
        
        // Forward to seller dashboard
        request.getRequestDispatcher("seller-dashboard.jsp").forward(request, response);
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
        return "Seller Dashboard Controller";
    }// </editor-fold>

}
