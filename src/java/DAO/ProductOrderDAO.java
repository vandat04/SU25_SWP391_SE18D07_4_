package DAO;

import context.DBContext; // Đảm bảo đúng package của DBContext
import entity.Orders.ProductOrder;
import entity.Orders.ProductOrderDetail; // Import ProductOrderDetail nếu cần
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger; 

public class ProductOrderDAO {

    private static final Logger LOGGER = Logger.getLogger(ProductOrderDAO.class.getName());

    // Helper method to map ResultSet to ProductOrder object
    private ProductOrder mapResultSetToProductOrder(ResultSet rs) throws SQLException {
        ProductOrder order = new ProductOrder();
        order.setId(rs.getInt("id"));
        order.setUserID(rs.getInt("userID"));
        order.setTotalPrice(rs.getBigDecimal("total_price"));
        order.setStatus(rs.getInt("status"));
        order.setShippingAddress(rs.getString("shippingAddress"));
        order.setShippingPhone(rs.getString("shippingPhone"));
        order.setShippingName(rs.getString("shippingName"));
        order.setPaymentMethod(rs.getString("paymentMethod"));
        order.setPaymentStatus(rs.getInt("paymentStatus"));
        order.setNote(rs.getString("note"));
        order.setCreatedDate(rs.getTimestamp("createdDate"));
        order.setUpdatedDate(rs.getTimestamp("updatedDate"));
        order.setTrackingNumber(rs.getString("trackingNumber"));
        order.setEstimatedDeliveryDate(rs.getTimestamp("estimatedDeliveryDate"));
        order.setActualDeliveryDate(rs.getTimestamp("actualDeliveryDate"));
        order.setCancelReason(rs.getString("cancelReason"));
        order.setCancelDate(rs.getTimestamp("cancelDate"));
        order.setRefundAmount(rs.getBigDecimal("refundAmount"));
        order.setRefundDate(rs.getTimestamp("refundDate"));
        order.setRefundReason(rs.getString("refundReason"));
        return order;
    }
    
    // Helper method to map ResultSet to ProductOrderDetail object (if needed)
    private ProductOrderDetail mapResultSetToProductOrderDetail(ResultSet rs) throws SQLException {
        ProductOrderDetail detail = new ProductOrderDetail();
        detail.setId(rs.getInt("id"));
        detail.setOrderId(rs.getInt("orderId"));
        detail.setProductId(rs.getInt("productId"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPrice(rs.getBigDecimal("price"));
        detail.setSubtotal(rs.getBigDecimal("subtotal"));
        return detail;
    }

    // Reuse the closeResources method structure from ProductDAO
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
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
            LOGGER.log(Level.SEVERE, "Error closing resources", e);
        }
    }

    /**
     * Retrieves all orders from the database.
     * @return A list of ProductOrder objects.
     */
    public List<ProductOrder> getAllOrders() {
        List<ProductOrder> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM [CraftDB].[dbo].[Orders] ORDER BY createdDate DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToProductOrder(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all orders", e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return orders;
    }
    
    /**
     * Retrieves a specific order by its ID.
     * @param orderId The ID of the order to retrieve.
     * @return The ProductOrder object if found, null otherwise.
     */
    public ProductOrder getOrderById(int orderId) {
        ProductOrder order = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM [CraftDB].[dbo].[Orders] WHERE id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                order = mapResultSetToProductOrder(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting order by ID: " + orderId, e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return order;
    }

    /**
     * Searches for orders based on date range and/or user ID.
     * @param fromDate Start date for filtering (inclusive). Can be null.
     * @param toDate End date for filtering (inclusive). Can be null.
     * @param userID User ID for filtering. Can be null or 0 to ignore.
     * @return A list of ProductOrder objects matching the criteria.
     */
    public List<ProductOrder> searchOrders(Timestamp fromDate, Timestamp toDate, Integer userID) {
        List<ProductOrder> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        StringBuilder sql = new StringBuilder("SELECT * FROM [CraftDB].[dbo].[Orders] WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (fromDate != null) {
            sql.append(" AND createdDate >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND createdDate <= ?");
            params.add(toDate);
        }
        if (userID != null && userID > 0) {
            sql.append(" AND userID = ?");
            params.add(userID);
        }
        sql.append(" ORDER BY createdDate DESC"); // Order results

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToProductOrder(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching orders", e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return orders;
    }

    /**
     * Updates the status of an order.
     * @param orderId The ID of the order to update.
     * @param newStatus The new status value.
     * @return True if the update was successful, false otherwise.
     */
    public boolean updateOrderStatus(int orderId, int newStatus) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE [CraftDB].[dbo].[Orders] SET status = ?, updatedDate = GETDATE() WHERE id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, newStatus);
            ps.setInt(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating order status for ID: " + orderId, e);
            return false;
        } finally {
            closeResources(conn, ps, null); // No ResultSet for UPDATE
        }
    }
    
    /**
     * Retrieves all order details for a given order ID.
     * @param orderId The ID of the order.
     * @return A list of ProductOrderDetail objects.
     */
    public List<ProductOrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<ProductOrderDetail> details = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM [CraftDB].[dbo].[OrderDetails] WHERE orderId = ?"; // Replace with your actual OrderDetails table name
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                details.add(mapResultSetToProductOrderDetail(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting order details for order ID: " + orderId, e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return details;
    }
}