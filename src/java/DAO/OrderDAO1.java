//package DAO;
//
//import entity.Order;
//import entity.OrderDetail;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.util.ArrayList;
//import java.util.List;
//import context.DBContext;
//import java.sql.SQLException;
//import java.util.HashMap;
//import java.util.LinkedHashMap;
//import java.util.Map;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class OrderDAO1 {
//
//    private static final Logger LOGGER = Logger.getLogger(OrderDAO1.class.getName());
//
//    private static final String SELECT_ALL_ORDERS = "SELECT * FROM Orders ORDER BY orderDate DESC";
//    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM Orders WHERE orderID = ?";
//    private static final String SELECT_ORDERS_BY_USER_ID = "SELECT * FROM Orders WHERE userID = ? ORDER BY orderDate DESC";
//    private static final String INSERT_ORDER = "INSERT INTO Orders (userID, orderDate, totalAmount, status, shippingAddress, phoneNumber, email, paymentMethod, paymentStatus, createdDate) VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?, ?, GETDATE())";
//    private static final String UPDATE_ORDER_STATUS = "UPDATE Orders SET status = ?, updatedDate = GETDATE() WHERE orderID = ?";
//    private static final String UPDATE_PAYMENT_STATUS = "UPDATE Orders SET paymentStatus = ?, updatedDate = GETDATE() WHERE orderID = ?";
//    private static final String DELETE_ORDER = "UPDATE Orders SET status = 'cancelled', updatedDate = GETDATE() WHERE orderID = ?";
//    private static final String SELECT_ORDER_DETAILS = "SELECT * FROM OrderDetail WHERE orderID = ?";
//    private static final String INSERT_ORDER_DETAIL = "INSERT INTO OrderDetail (orderID, productID, quantity, price) VALUES (?, ?, ?, ?)";
//    private static final String GET_ORDERS_BY_STATUS = "SELECT * FROM Orders WHERE status = ? ORDER BY orderDate DESC";
//    private static final String GET_ORDERS_BY_DATE_RANGE = "SELECT * FROM Orders WHERE orderDate BETWEEN ? AND ? ORDER BY orderDate DESC";
//
//    private Connection conn = null;
//    private PreparedStatement ps = null;
//    private ResultSet rs = null;
//    //----------------------------------------------------------------------------------------------------------------
//
//    public int getnewOrderId() throws SQLException {
//        String sql = "SELECT TOP 1 id FROM Orders ORDER BY id DESC";
//        int newId = 1;
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
//
//            if (rs.next()) {
//                newId = rs.getInt("id") + 1;
//            }
//
//        } catch (SQLException e) {
//            throw new SQLException("Lỗi khi lấy ID đơn hàng mới nhất: " + e.getMessage());
//        }
//
//        return newId;
//    }
//
//    public void addOrderDetail(int orderId, int productId, int quantity, double price) throws SQLException {
//        String sql = "INSERT INTO OrderDetail (order_id, product_id, quantity, price, subtotall) VALUES (?, ?, ?, ?, ?)";
//
//        double subtotal = quantity * price;
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, orderId);
//            stmt.setInt(2, productId);
//            stmt.setInt(3, quantity);
//            stmt.setDouble(4, price);
//            stmt.setDouble(5, subtotal);
//
//            int affectedRows = stmt.executeUpdate();
//            if (affectedRows == 0) {
//                throw new SQLException("Thêm chi tiết đơn hàng thất bại, không có dòng nào được thêm.");
//            }
//        } catch (SQLException e) {
//            throw new SQLException("Lỗi khi thêm chi tiết đơn hàng: " + e.getMessage(), e);
//        }
//    }
//
//    public int createOrder(Order order) throws SQLException {
//        String sql = "INSERT INTO Orders (userID, total_price, status) VALUES (?, ?, ?)"; // Bỏ orderDate
//        int orderId = -1;
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
//
//            stmt.setInt(1, order.getUserID());
//            stmt.setDouble(2, order.getTotalAmount().doubleValue());
//            stmt.setString(3, order.getStatus());
//
//            int affectedRows = stmt.executeUpdate();
//            if (affectedRows == 0) {
//                throw new SQLException("Tạo đơn hàng thất bại, không có dòng nào được thêm.");
//            }
//
//            try (ResultSet rs = stmt.getGeneratedKeys()) {
//                if (rs.next()) {
//                    orderId = rs.getInt(1);
//                } else {
//                    throw new SQLException("Tạo đơn hàng thất bại, không lấy được ID.");
//                }
//            }
//        } catch (SQLException e) {
//            throw new SQLException("Lỗi khi tạo đơn hàng: " + e.getMessage(), e);
//        }
//
//        return orderId;
//    }
//
//    //------------------------------------------------------------------------------------------------------------
//    // Lấy danh sách đơn hàng của người dùng
//    public List<Order> getOrdersByUserId(int userId) {
//        List<Order> list = new ArrayList<>();
//        String query = "SELECT * FROM Orders WHERE userID = ?";
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
//
//            ps.setInt(1, userId);
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) { // Lặp qua từng dòng kết quả
//                    list.add(new Order(
//                            rs.getInt("id"),
//                            rs.getInt("userID"),
//                            rs.getString("orderDate"),
//                            rs.getDouble("total_price"),
//                            rs.getString("status")
//                    ));
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    // Lấy danh sách đơn hàng của seller (dựa vào sản phẩm thuộc về seller)
//    public List<Order> getOrdersBySellerId(int sellerId) {
//        List<Order> list = new ArrayList<>();
//        String query = "SELECT DISTINCT o.* FROM Orders o "
//                + "JOIN OrderDetail od ON o.id = od.order_id "
//                + "JOIN Product p ON od.product_id = p.pid "
//                + "WHERE p.sell_id = ?";
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setInt(1, sellerId);
//            rs = ps.executeQuery();
//            while (rs.next()) {
//                Order order = Order.fromResultSet(rs);
//                list.add(order);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    // Lấy tất cả đơn hàng (cho admin)
//    public List<Order> getAllOrders() {
//        List<Order> orders = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement("SELECT * FROM Orders");
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                Order order = mapResultSetToOrderv2(rs);
//                order.setOrderDetails(getOrderDetails(order.getOrderID()));
//                orders.add(order);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all orders", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return orders;
//    }
//
//    // Cập nhật trạng thái đơn hàng
//    public boolean updateOrderStatus(int orderId, String status) {
//        String query = "UPDATE Orders SET status = ? WHERE id = ?";
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setString(1, status);
//            ps.setInt(2, orderId);
//            int rowsAffected = ps.executeUpdate();
//            return rowsAffected > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // Lấy đơn hàng theo ID
//    public Order getOrderById(int orderId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_ORDER_BY_ID);
//            ps.setInt(1, orderId);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                Order order = mapResultSetToOrder(rs);
//                order.setOrderDetails(getOrderDetails(order.getOrderID()));
//                return order;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting order by ID: " + orderId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    public boolean cancelOrder(int orderId) {
//        String query = "UPDATE Orders SET status = 'cancelled' WHERE id = ? AND status = 'pending'";
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setInt(1, orderId);
//            int rowsAffected = ps.executeUpdate();
//            return rowsAffected > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // Lấy doanh thu theo tháng
//    public Map<String, Double> getRevenueByMonth() {
//        Map<String, Double> revenueByMonth = new LinkedHashMap<>();
//        String query = "SELECT FORMAT(o.orderDate, 'yyyy-MM') AS month, SUM(od.subtotall) AS revenue "
//                + "FROM OrderDetail od "
//                + "JOIN Orders o ON od.order_id = o.id "
//                + "GROUP BY FORMAT(o.orderDate, 'yyyy-MM') "
//                + "ORDER BY month";
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                revenueByMonth.put(rs.getString("month"), rs.getDouble("revenue"));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return revenueByMonth;
//    }
//
//    // Lấy doanh thu theo năm
//    public Map<String, Double> getRevenueByYear() {
//        Map<String, Double> revenueByYear = new LinkedHashMap<>();
//        String query = "SELECT YEAR(o.orderDate) AS year, SUM(od.subtotall) AS revenue "
//                + "FROM OrderDetail od "
//                + "JOIN Orders o ON od.order_id = o.id "
//                + "GROUP BY YEAR(o.orderDate) "
//                + "ORDER BY year";
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                revenueByYear.put(rs.getString("year"), rs.getDouble("revenue"));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return revenueByYear;
//    }
//
//    // Lấy sản phẩm bán chạy nhất
//    public List<Map<String, Object>> getTopSellingProducts() {
//        List<Map<String, Object>> products = new ArrayList<>();
//        String query = "SELECT TOP 3 p.name, SUM(od.quantity) AS total_sold, SUM(od.subtotall) AS total_revenue "
//                + "FROM OrderDetail od "
//                + "JOIN Product p ON od.product_id = p.pid "
//                + "GROUP BY p.name "
//                + "ORDER BY total_sold DESC";
//
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Map<String, Object> product = new LinkedHashMap<>();
//                product.put("name", rs.getString("name"));
//                product.put("sold", rs.getInt("total_sold"));
//                product.put("revenue", rs.getDouble("total_revenue"));
//                products.add(product);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return products;
//    }
//
//    // Helper method to close resources
//    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
//        try {
//            if (rs != null) {
//                rs.close();
//            }
//            if (ps != null) {
//                ps.close();
//            }
//            if (conn != null) {
//                conn.close();
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
//        }
//    }
//
//    private List<OrderDetail> getOrderDetails(int orderId) {
//        List<OrderDetail> details = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_ORDER_DETAILS);
//            ps.setInt(1, orderId);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                details.add(new OrderDetail(
//                        rs.getInt("orderID"),
//                        rs.getInt("productID"),
//                        rs.getInt("quantity"),
//                        rs.getBigDecimal("price")
//                ));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting order details for order ID: " + orderId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return details;
//    }
//
//    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
//        return new Order(
//                rs.getInt("orderID"),
//                rs.getInt("userID"),
//                rs.getTimestamp("createDate"),
//                rs.getBigDecimal("totalAmount"),
//                rs.getString("status"),
//                rs.getString("shippingAddress"),
//                rs.getString("phoneNumber"),
//                rs.getString("email"),
//                rs.getString("paymentMethod"),
//                rs.getString("paymentStatus"),
//                rs.getTimestamp("createdDate"),
//                rs.getTimestamp("updatedDate")
//        );
//    }
//
//    public static void main(String[] args) {
//        OrderDAO1 dao = new OrderDAO1();
//        System.out.println(dao.getProductOrderCount());
//
//    }
////------------------------------------------------------------------------------
//
//    public Map<String, Integer> getProductOrderCount() {
//        Map<String, Integer> result = new HashMap<>();
//
//        String sql = """
//            SELECT p.name, SUM(od.quantity) AS total_quantity
//            FROM OrderDetail od
//            JOIN Orders o ON od.order_id = o.id
//            JOIN Product p ON od.product_id = p.pid
//            WHERE o.paymentStatus = 'Paid'
//            GROUP BY p.name
//        """;
//
//        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                String productName = rs.getString("name");
//                int quantity = rs.getInt("total_quantity");
//                result.put(productName, quantity);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return result;
//    }
//
//    public List<Order> getAllOrdersByAdmin() {
//        List<Order> orders = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement("SELECT * FROM Orders");
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                Order order = mapResultSetToOrderv2(rs);
//                order.setOrderDetails(getOrderDetailsByAdmin(order.getOrderID()));
//                orders.add(order);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all orders", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return orders;
//    }
//
//    private List<OrderDetail> getOrderDetailsByAdmin(int orderId) {
//        List<OrderDetail> details = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement("SELECT * FROM OrderDetail WHERE order_id = ?");
//            ps.setInt(1, orderId);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                details.add(new OrderDetail(
//                        rs.getInt("order_id"),
//                        rs.getInt("order_id"),
//                        rs.getInt("quantity"),
//                        rs.getDouble("price"), (int) rs.getDouble("subtotal")));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting order details for order ID: " + orderId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return details;
//    }
//
//    private Order mapResultSetToOrderv2(ResultSet rs) throws SQLException {
//        return new Order(
//                rs.getInt("id"),
//                rs.getInt("userID"),
//                rs.getBigDecimal("total_price"),
//                rs.getString("shippingAddress"),
//                rs.getString("shippingPhone"),
//                rs.getString("paymentMethod"),
//                rs.getString("paymentStatus"),
//                rs.getTimestamp("createDate"),
//                rs.getTimestamp("updatedDate"),
//                rs.getString("shippingName"),
//                rs.getInt("status"),
//                rs.getString("note")
//        );
//    }
//}
