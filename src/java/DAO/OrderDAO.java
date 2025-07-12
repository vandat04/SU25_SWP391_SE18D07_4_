/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Orders.Order;
import java.util.logging.Logger;
import context.DBContext;
import entity.Account.Account;
import entity.Account.SellerVerification;
import entity.CartWishList.CartItem;
import entity.Orders.OrderDetail;
import entity.Orders.TicketOrderDetail;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;

/**
 *
 * @author ACER
 */
public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        return new Order(
                rs.getInt("id"),
                rs.getInt("userID"),
                rs.getBigDecimal("total_price"),
                rs.getString("shippingAddress"),
                rs.getString("shippingPhone"),
                rs.getString("email"),
                rs.getString("paymentMethod"),
                rs.getInt("paymentStatus"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate")
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

    public int addOrder(Order order) {
        String query = "{CALL AddOrder(?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);

            cs.setInt(1, order.getUserID());
            cs.setBigDecimal(2, order.getTotalAmount());
            cs.setString(3, order.getShippingAddress());
            cs.setString(4, order.getPhoneNumber());
            cs.setString(5, order.getEmail());
            cs.setString(6, order.getPaymentMethod());
            cs.setInt(7, order.getPaymentStatus());
            cs.setString(8, order.getNote());
            cs.setString(9, order.getFullName());
            cs.setInt(10, order.getPoints());

            cs.registerOutParameter(11, Types.INTEGER);

            cs.execute();

            int newOrderId = cs.getInt(11);
            LOGGER.log(Level.INFO, "AddOrder result code: {0}", newOrderId);
            return newOrderId;
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error adding order for user ID: " + order.getUserID(), e);
        } finally {
            closeResources(conn, cs, null);
        }
        return 0;
    }

    public void deleteCartItem(int cartID) {
        String sql = "DELETE FROM CartItem WHERE cartID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cartID);
            int rowsAffected = ps.executeUpdate();

            System.out.println("Deleted " + rowsAffected + " cart item(s) for cartID: " + cartID);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public void deleteCartTicket(int cartID) {
        String sql = "DELETE FROM CartTicket WHERE cartID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cartID);
            int rowsAffected = ps.executeUpdate();

            System.out.println("Deleted " + rowsAffected + " cart item(s) for cartID: " + cartID);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public int getCartIDByUserID(int userID) {
        String sql = "SELECT cartID FROM Cart WHERE userID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cartID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return -1; // trả về -1 nếu không tìm thấy
    }

    public void addOrderDetail(int orderId, int productId, int quantity, double price, int status, int villageID, String paymentMethod, int paymentStatus) {
        String sql = "{CALL AddOrderDetail(?, ?, ?, ?,? ,?,?,?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(sql);
            cs.setInt(1, orderId);
            cs.setInt(2, productId);
            cs.setInt(3, quantity);
            cs.setBigDecimal(4, BigDecimal.valueOf(price));
            cs.setInt(5, status);
            cs.setInt(6, villageID);
            cs.setString(7, paymentMethod);
            cs.setInt(8, paymentStatus);

            cs.execute();
            System.out.println("OrderDetail added successfully for order ID: " + orderId);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, cs, null);
        }
    }

    public void addTicketOrderDetail(int orderId, int ticketID, int quantity, double price, int status, int villageID, String paymentMethod, int paymentStatus) {
        String sql = "{CALL AddTicketOrderDetail(?, ?, ?, ?, ? ,? ,? ,?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(sql);
            cs.setInt(1, orderId);
            cs.setInt(2, ticketID);
            cs.setInt(3, quantity);
            cs.setBigDecimal(4, BigDecimal.valueOf(price));
            cs.setInt(5, status);
            cs.setInt(6, villageID);
            cs.setString(7, paymentMethod);
            cs.setInt(8, paymentStatus);

            cs.execute();
            System.out.println("OrderDetail added successfully for order ID: " + orderId);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, cs, null);
        }
    }

    public String checkItemStock(List<CartItem> listItem) {
        StringBuilder list = new StringBuilder();
        String sql = "SELECT name, stock FROM Product WHERE pid = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int size = 0;
        try {
            conn = new DBContext().getConnection();
            for (CartItem ci : listItem) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, ci.getProductID());
                rs = ps.executeQuery();
                if (rs.next()) {
                    int stock = rs.getInt("stock");
                    String name = rs.getString("name");
                    if (ci.getQuantity() > stock) {
                        size++;
                        list.append(size)
                                .append(". ")
                                .append(name)
                                .append(" (quantity: ")
                                .append(ci.getQuantity())
                                .append(" > stock: ")
                                .append(stock)
                                .append(")")
                                .append("\n");
                    }
                }
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list.toString();
    }

    public void payPoints(int userID, int points) {
        String sql = "{CALL PayPoints(?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(sql);
            cs.setInt(1, userID);
            cs.setInt(2, points);
            cs.execute();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, cs, null);
        }
    }

    public void updatePaymentStatus(int orderID, int status) {
        String sqlOrder = "UPDATE Orders SET paymentStatus = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement psOrder = conn.prepareStatement(sqlOrder)) {

            psOrder.setInt(1, status);
            psOrder.setInt(2, orderID);
            psOrder.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getUserIDByOrderID(int orderID) {
        String sql = "SELECT userID FROM Orders WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("userID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // return -1 nếu không tìm thấy
    }

    public static void main(String[] args) {
        System.out.println(new OrderDAO().getOrderById(78));
    }

    public double getOrderTotal(int orderID) {
        String sql = "SELECT total_price FROM Orders WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_price");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // return -1 nếu không tìm thấy
    }

    public void deletePendingOrdersOlderThan(int minutes) {
        String selectSQL = "SELECT orderID FROM Orders WHERE paymentStatus = bankTransfer and paymentStatus = 0 AND DATEDIFF(MINUTE, createdDate, GETDATE()) > ?";
        String deleteOrderDetailSQL = "DELETE FROM OrderDetail WHERE order_id = ?";
        String deleteTicketOrderDetailSQL = "DELETE FROM TicketOrderDetail WHERE orderID = ?";
        String deleteOrderSQL = "DELETE FROM Orders WHERE orderID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement psSelect = conn.prepareStatement(selectSQL); PreparedStatement psDeleteOrderDetail = conn.prepareStatement(deleteOrderDetailSQL); PreparedStatement psDeleteTicketOrderDetail = conn.prepareStatement(deleteTicketOrderDetailSQL); PreparedStatement psDeleteOrder = conn.prepareStatement(deleteOrderSQL)) {

            conn.setAutoCommit(false);

            psSelect.setInt(1, minutes);
            ResultSet rs = psSelect.executeQuery();

            while (rs.next()) {
                int orderID = rs.getInt("orderID");

                // Xóa OrderDetail
                psDeleteOrderDetail.setInt(1, orderID);
                psDeleteOrderDetail.executeUpdate();

                // Xóa TicketOrderDetail
                psDeleteTicketOrderDetail.setInt(1, orderID);
                psDeleteTicketOrderDetail.executeUpdate();

                // Xóa Order
                psDeleteOrder.setInt(1, orderID);
                psDeleteOrder.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Kiểm tra order có tồn tại không
     *
     * @param orderID ID của order cần kiểm tra
     * @return true nếu order tồn tại, false nếu không
     */
    public boolean orderExists(int orderID) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void addPoints(int userID, int points) {
        String checkSql = "SELECT COUNT(*) FROM AccountPoints WHERE userID = ?";
        String insertSql = "INSERT INTO AccountPoints (userID, points) VALUES (?, ?)";
        String updateSql = "UPDATE AccountPoints SET points = points + ? WHERE userID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement psCheck = conn.prepareStatement(checkSql)) {

            psCheck.setInt(1, userID);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Đã tồn tại → update
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setInt(1, points);
                        psUpdate.setInt(2, userID);
                        psUpdate.executeUpdate();
                    }
                } else {
                    // Chưa tồn tại → insert
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setInt(1, userID);
                        psInsert.setInt(2, points);
                        psInsert.executeUpdate();
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Order getOrderById(int orderId) {
    String sql = " SELECT * FROM Orders WHERE id = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("id"));
                order.setUserID(rs.getInt("userID"));
                order.setTotalAmount(rs.getBigDecimal("total_price"));
                order.setShippingAddress(rs.getString("shippingAddress"));
                order.setPhoneNumber(rs.getString("shippingPhone"));
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
                order.setEmail(rs.getString("email"));
                order.setPoints(rs.getInt("points"));
                return order;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

}
