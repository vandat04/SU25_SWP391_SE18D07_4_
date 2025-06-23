/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.Account.Account;
import entity.Orders.Payment;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.Types;


/**
 *
 * @author ACER
 */
public class ReportDAO {

    private static final Logger LOGGER = Logger.getLogger(AccountDAO.class.getName());

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        return new Payment(
                rs.getInt("paymentID"),
                rs.getInt("orderID"),
                rs.getInt("tourBookingID"),
                rs.getBigDecimal("amount"),
                rs.getString("paymentMethod"),
                rs.getTimestamp("paymentDate")
        );
    }

    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        return new Account(
                rs.getInt("userID"),
                rs.getString("userName"),
                "********",
                rs.getString("email"),
                rs.getString("address"),
                rs.getString("phoneNumber"),
                rs.getInt("roleID"),
                rs.getInt("status"),
                rs.getString("createdDate"),
                rs.getString("updatedDate"),
                rs.getString("fullName")
        );
    }

    private void closeResources(java.sql.Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
        }
    }

//------ Account Report
    public Map<Integer, Integer> getMonthlyAccountRegistrations(int month, int year) {
        String query = "SELECT DAY(createdDate) AS day, COUNT(*) AS total "
                + "FROM Account "
                + "WHERE MONTH(createdDate) = ? AND YEAR(createdDate) = ? "
                + "GROUP BY DAY(createdDate) "
                + "ORDER BY day ASC";

        Map<Integer, Integer> dailyRegistrations = new LinkedHashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, month); // tháng 1 = 1
            ps.setInt(2, year);
            rs = ps.executeQuery();

            while (rs.next()) {
                int day = rs.getInt("day"); // 1–31
                int total = rs.getInt("total");
                dailyRegistrations.put(day, total);
            }

            // Đảm bảo đủ các ngày trong tháng (ví dụ: 1–30)
            YearMonth ym = YearMonth.of(year, month);
            int daysInMonth = ym.lengthOfMonth();
            for (int d = 1; d <= daysInMonth; d++) {
                dailyRegistrations.putIfAbsent(d, 0);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return dailyRegistrations;
    }

    public List<Account> getAccountsByFilter(int filter) {
        String query;
        switch (filter) {
            case 1:
                query = "SELECT * FROM Account WHERE roleID = 1";
                break;
            case 2:
                query = "SELECT * FROM Account WHERE roleID = 2";
                break;
            case 3:
                query = "SELECT * FROM Account WHERE roleID = 3";
                break;
            case 4:
                query = "SELECT * FROM Account WHERE status = 1 ORDER BY userName ASC";
                break;
            case 5:
                query = "SELECT * FROM Account WHERE status = 1 ORDER BY userName DESC";
                break;
            case 6:
                query = "SELECT * FROM Account WHERE status = 0";
                break;
            default:
                query = "SELECT * FROM Account WHERE status = 1";
                break;
        }
        List<Account> list = new ArrayList<>();
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            cs = conn.prepareCall(query);

            rs = cs.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToAccount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In rõ lỗi ra console
        } finally {
            if (cs != null) {
                try {
                    cs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            closeResources(conn, null, rs);
        }
        return list;
    }

    public boolean addNewAccountFull(Account account) {
        String query = "{CALL AddAccountFull(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);

            // Set input parameters
            cs.setString(1, account.getUserName());
            cs.setString(2, account.getPassword());
            cs.setString(3, account.getEmail());
            cs.setString(4, account.getFullName());
            cs.setString(5, account.getPhoneNumber());
            cs.setString(6, account.getAddress());
            cs.setInt(7, account.getRoleID());
            cs.setInt(8, account.getStatus());

            // Register OUTPUT parameter
            cs.registerOutParameter(9, Types.INTEGER); // @result INT OUTPUT

            cs.execute();

            int result = cs.getInt(9); // get output value

            LOGGER.log(Level.INFO, "AddAccountFull result code: {0}", result);

            return result == 1; // only true if success
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error registering account for user: " + account.getUserName(), e);
        } finally {
            closeResources(conn, cs, null);
        }
        return false;
    }

    public List<Account> getSearchAccount(int searchID, String contentSearch) {
        String query;
        switch (searchID) {
            case 1:
                query = "SELECT * FROM Account WHERE username LIKE ?";
                contentSearch = "%" + contentSearch + "%"; // Cho phép tìm gần đúng
                break;
            case 2:
                query = "SELECT * FROM Account WHERE email = ?";
                break;
            case 3:
                query = "SELECT * FROM Account WHERE FullName LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            default:
                return new ArrayList<>(); // Tránh null nếu searchID không hợp lệ
        }

        List<Account> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, contentSearch);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAccount(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log tốt hơn
        }
        return list;
    }

//------ Payment Report
    public List<Payment> getAllPayments() {
        String query = "SELECT * FROM Payment WHERE paymentStatus = 1";
        List<Payment> list = new ArrayList<>();
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            cs = conn.prepareCall(query);

            rs = cs.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In rõ lỗi ra console
        } finally {
            if (cs != null) {
                try {
                    cs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            closeResources(conn, null, rs);
        }
        return list;
    }

    public BigDecimal getRevenueByDayMonthYear(int day, int month, int year) {
        String query = "SELECT SUM(amount) AS total "
                + "FROM Payment "
                + "WHERE paymentStatus = 1 "
                + "AND DAY(paymentDate) = ? "
                + "AND MONTH(paymentDate) = ? "
                + "AND YEAR(paymentDate) = ?";

        BigDecimal totalRevenue = BigDecimal.ZERO;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, day);
            ps.setInt(2, month);
            ps.setInt(3, year);

            rs = ps.executeQuery();
            if (rs.next()) {
                totalRevenue = rs.getBigDecimal("total");
                if (totalRevenue == null) {
                    totalRevenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return totalRevenue;
    }

    public Map<Date, BigDecimal> getRevenue() {
        String query = "SELECT CAST(paymentDate AS DATE) AS payDate, SUM(amount) AS total "
                + "FROM Payment "
                + "WHERE paymentStatus = 1 "
                + "GROUP BY CAST(paymentDate AS DATE) "
                + "ORDER BY payDate ASC";

        Map<Date, BigDecimal> revenueMap = new LinkedHashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Date date = rs.getDate("payDate"); // java.sql.Date
                BigDecimal total = rs.getBigDecimal("total");
                revenueMap.put(date, total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return revenueMap;
    }

    public Map<Integer, BigDecimal> getRevenueByYear(int year) {
        // Lấy toàn bộ doanh thu theo ngày
        Map<Date, BigDecimal> allRevenue = new ReportDAO().getRevenue();

        // Map mới: tổng doanh thu của mỗi tháng trong năm
        Map<Integer, BigDecimal> monthlyRevenue = new LinkedHashMap<>();

        Calendar calendar = Calendar.getInstance();

        for (Map.Entry<Date, BigDecimal> entry : allRevenue.entrySet()) {
            Date date = entry.getKey();
            BigDecimal amount = entry.getValue();

            calendar.setTime(date);
            int entryYear = calendar.get(Calendar.YEAR);
            int month = calendar.get(Calendar.MONTH); // 0 = Tháng 1, 11 = Tháng 12

            if (entryYear == year) {
                // Cộng dồn doanh thu theo tháng
                BigDecimal current = monthlyRevenue.getOrDefault(month, BigDecimal.ZERO);
                monthlyRevenue.put(month, current.add(amount));
            }
        }
        return monthlyRevenue;
    }

//---- Order Report
    public Map<Integer, Integer> getOrderStatusSummary() {
        String query = "SELECT status, COUNT(*) AS total "
                + "FROM ( "
                + "   SELECT status FROM Orders "
                + "   UNION ALL "
                + "   SELECT status FROM TicketOrder "
                + ") AS Combined "
                + "GROUP BY status "
                + "ORDER BY status";

        Map<Integer, Integer> statusMap = new LinkedHashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                int status = rs.getInt("status");
                int total = rs.getInt("total");
                statusMap.put(status, total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return statusMap;
    }

    public Map<Integer, Integer> getOrderStatusSummaryByMonthYear(int month, int year) {
        String query = "SELECT status, COUNT(*) AS total "
                + "FROM ( "
                + "   SELECT status FROM Orders "
                + "   WHERE MONTH(createdDate) = ? AND YEAR(createdDate) = ? "
                + "   UNION ALL "
                + "   SELECT status FROM TicketOrder "
                + "   WHERE MONTH(createdDate) = ? AND YEAR(createdDate) = ? "
                + ") AS Combined "
                + "GROUP BY status "
                + "ORDER BY status";

        Map<Integer, Integer> statusMap = new LinkedHashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            // Gán giá trị tham số
            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, month);
            ps.setInt(4, year);

            rs = ps.executeQuery();
            while (rs.next()) {
                int status = rs.getInt("status");
                int total = rs.getInt("total");
                statusMap.put(status, total);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return statusMap;

    }

//---- Product/Ticket Report
    public int getNumberProductPostByDayMonthYear(int day, int month, int year) {
        String query = "SELECT COUNT(*) AS total "
                + "FROM Product "
                + "WHERE status = 1 "
                + "AND DAY(createdDate) = ? "
                + "AND MONTH(createdDate) = ? "
                + "AND YEAR(createdDate) = ?";

        int totalPosts = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, day);
            ps.setInt(2, month);
            ps.setInt(3, year);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalPosts = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return totalPosts;
    }

    public int getNumberTicketPostByDayMonthYear(int day, int month, int year) {
        String query = "SELECT COUNT(*) AS total "
                + "FROM VillageTicket "
                + "WHERE status = 1 "
                + "AND DAY(createdDate) = ? "
                + "AND MONTH(createdDate) = ? "
                + "AND YEAR(createdDate) = ?";

        int totalPosts = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, day);
            ps.setInt(2, month);
            ps.setInt(3, year);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalPosts = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return totalPosts;
    }

//---- Craft Village Post
    public int getNumberCraftPostByDayMonthYear(int day, int month, int year) {
        String query = "SELECT COUNT(*) AS total "
                + "FROM CraftVillage "
                + "WHERE status = 1 "
                + "AND DAY(createdDate) = ? "
                + "AND MONTH(createdDate) = ? "
                + "AND YEAR(createdDate) = ?";

        int totalPosts = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, day);
            ps.setInt(2, month);
            ps.setInt(3, year);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalPosts = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return totalPosts;
    }


//----Main test    
    public static void main(String[] args) {
        System.out.println(new ReportDAO().getAccountsByFilter(4));
    }
}
