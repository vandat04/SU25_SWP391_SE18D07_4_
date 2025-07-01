package entity.Statistic;

import DAO.StatisticDAO;
import entity.Account.Account;
import entity.Statistic.MonthlyRevenue;
import entity.Statistic.StatisticSummary;
import entity.Statistic.TopSellingProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StatisticServlet", urlPatterns = {"/statistics"})
public class StatisticServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");

        // Kiểm tra xem người dùng đã đăng nhập và có phải là Seller không
        if (acc == null || acc.getRoleID() != 2) { 
            response.sendRedirect("login");
            return;
        }

        try {
            StatisticDAO dao = new StatisticDAO();
            int sellerId = acc.getUserID();

            // 1. Lấy dữ liệu tổng quan (doanh thu, đơn hàng, sản phẩm đã bán)
            StatisticSummary summary = dao.getSummaryMetrics(sellerId);
            
            // 2. Lấy dữ liệu doanh thu hàng tháng cho biểu đồ
            List<MonthlyRevenue> monthlyRevenueData = dao.getMonthlyRevenue(sellerId);
            
            // 3. Lấy danh sách top sản phẩm bán chạy
            List<TopSellingProduct> topProducts = dao.getTopSellingProducts(sellerId);

            // 4. Đặt tất cả dữ liệu vào request để trang JSP có thể truy cập
            request.setAttribute("summary", summary);
            request.setAttribute("monthlyRevenueData", monthlyRevenueData);
            request.setAttribute("topProducts", topProducts);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi tải dữ liệu thống kê.");
        }
        
        // 5. Chuyển tiếp đến trang JSP để hiển thị giao diện
        request.getRequestDispatcher("statistics.jsp").forward(request, response);
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
}
