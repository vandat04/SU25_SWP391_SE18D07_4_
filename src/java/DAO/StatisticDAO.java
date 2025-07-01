package DAO;

import context.DBContext;
import entity.Statistic.MonthlyRevenue;
import entity.Statistic.StatisticSummary;
import entity.Statistic.TopSellingProduct;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StatisticDAO {

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy các chỉ số thống kê tổng quan cho một nghệ nhân.
     * @param sellerId ID của tài khoản nghệ nhân.
     * @return một đối tượng StatisticSummary.
     */
    public StatisticSummary getSummaryMetrics(int sellerId) {
        StatisticSummary summary = new StatisticSummary();
        // Câu lệnh SQL JOIN các bảng để tính toán dựa trên các đơn hàng đã hoàn thành (status = 1)
        String sql = "SELECT " +
                     "   ISNULL(SUM(od.quantity * od.price), 0) AS totalRevenue, " +
                     "   COUNT(DISTINCT o.id) AS totalOrders, " +
                     "   ISNULL(SUM(od.quantity), 0) AS totalProductsSold " +
                     "FROM OrderDetail od " +
                     "JOIN Orders o ON od.order_id = o.id " +
                     "JOIN Product p ON od.product_id = p.pid " +
                     "JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                     "WHERE cv.sellerId = ? AND o.status = 1"; // Chỉ tính các đơn hàng đã thanh toán
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.setTotalRevenue(rs.getBigDecimal("totalRevenue"));
                    summary.setTotalOrders(rs.getInt("totalOrders"));
                    summary.setTotalProductsSold(rs.getInt("totalProductsSold"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }

    /**
     * Lấy dữ liệu doanh thu hàng tháng trong 12 tháng gần nhất.
     * @param sellerId ID của tài khoản nghệ nhân.
     * @return Danh sách doanh thu theo tháng.
     */
    public List<MonthlyRevenue> getMonthlyRevenue(int sellerId) {
        List<MonthlyRevenue> list = new ArrayList<>();
        // Câu lệnh SQL này sử dụng FORMAT, yêu cầu SQL Server 2012 trở lên.
        String sql = "SELECT " +
                     "   FORMAT(o.createdDate, 'yyyy-MM') AS month, " +
                     "   SUM(od.quantity * od.price) AS monthlyRevenue " +
                     "FROM OrderDetail od " +
                     "JOIN Orders o ON od.order_id = o.id " +
                     "JOIN Product p ON od.product_id = p.pid " +
                     "JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                     "WHERE cv.sellerId = ? AND o.status = 1 AND o.createdDate >= DATEADD(year, -1, GETDATE()) " +
                     "GROUP BY FORMAT(o.createdDate, 'yyyy-MM') " +
                     "ORDER BY month ASC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MonthlyRevenue mr = new MonthlyRevenue();
                    mr.setMonth(rs.getString("month"));
                    mr.setRevenue(rs.getBigDecimal("monthlyRevenue"));
                    list.add(mr);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách 5 sản phẩm bán chạy nhất.
     * @param sellerId ID của tài khoản nghệ nhân.
     * @return Danh sách các sản phẩm bán chạy.
     */
    public List<TopSellingProduct> getTopSellingProducts(int sellerId) {
        List<TopSellingProduct> list = new ArrayList<>();
        String sql = "SELECT TOP 5 " +
                     "   p.name AS productName, " +
                     "   SUM(od.quantity) AS totalQuantitySold " +
                     "FROM OrderDetail od " +
                     "JOIN Product p ON od.product_id = p.pid " +
                     "JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                     "WHERE cv.sellerId = ? " +
                     "GROUP BY p.pid, p.name " +
                     "ORDER BY totalQuantitySold DESC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TopSellingProduct tsp = new TopSellingProduct();
                    tsp.setProductName(rs.getString("productName"));
                    tsp.setTotalQuantitySold(rs.getInt("totalQuantitySold"));
                    list.add(tsp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
