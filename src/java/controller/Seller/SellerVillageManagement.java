package controller.Seller;

import entity.Account.Account;
import entity.CraftVillage.CraftVillage;
import entity.CraftVillage.CraftType;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.VillageService;

/**
 * Servlet for managing seller's craft villages
 * @author ACER
 */
@WebServlet(name = "SellerVillageManagement", urlPatterns = {"/seller-village-management"})
public class SellerVillageManagement extends HttpServlet {

    private VillageService villageService;

    @Override
    public void init() throws ServletException {
        villageService = new VillageService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        // Check if user is logged in and is a seller
        if (account == null || account.getRole() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        int sellerId = account.getUserID();
        
        // Get seller's villages
        List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(sellerId);
        
        // Get all craft types for reference
        List<CraftType> craftTypes = villageService.getAllActiveCraftTypes();
        
        // Calculate statistics
        int totalVillages = sellerVillages != null ? sellerVillages.size() : 0;
        int activeVillages = 0;
        int totalReviews = 0;
        int totalViews = 0;
        
        if (sellerVillages != null) {
            for (CraftVillage village : sellerVillages) {
                if (village.getStatus() == 1) {
                    activeVillages++;
                }
                totalReviews += village.getTotalReviews();
                totalViews += village.getClickCount();
            }
        }
        
        // Set attributes for JSP
        request.setAttribute("sellerVillages", sellerVillages);
        request.setAttribute("craftTypes", craftTypes);
        request.setAttribute("sellerId", sellerId);
        request.setAttribute("totalVillages", totalVillages);
        request.setAttribute("activeVillages", activeVillages);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("totalViews", totalViews);
        
        // Forward to JSP page
        request.getRequestDispatcher("seller-village-management.jsp").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Servlet for managing seller's craft villages";
    }
}
