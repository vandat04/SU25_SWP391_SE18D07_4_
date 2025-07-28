/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Orders.Order;
import context.DBContext;
import entity.Account.Account;
import entity.CartWishList.CartItem;
import entity.CraftVillage.CraftReview;
import entity.CraftVillage.CraftVillage;
import entity.Orders.OrderDetail;
import entity.Orders.SubOrder;
import entity.Orders.TicketOrderDetail;
import entity.Product.Product;
import entity.Product.ProductReview;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;
import service.ProductService;
import service.VillageService;

/**
 *
 * @author ACER
 */
public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setId(rs.getInt("id"));
        order.setUserID(rs.getInt("userID"));
        order.setTotalPrice(rs.getBigDecimal("total_price"));
        order.setShippingAddress(rs.getString("shippingAddress"));
        order.setShippingPhone(rs.getString("shippingPhone"));
        order.setShippingName(rs.getString("shippingName")); // ✅ thêm dòng này
        order.setPaymentMethod(rs.getString("paymentMethod"));
        order.setEmail(rs.getString("email"));
        order.setCreatedDate(rs.getTimestamp("createdDate"));

        return order;
    }

    private SubOrder mapResultSetToSubOrder(ResultSet rs) throws SQLException {
        SubOrder subOrder = new SubOrder();

        subOrder.setSubOrderId(rs.getInt("subOrderId"));
        subOrder.setOrderId(rs.getInt("orderId"));
        subOrder.setVillageId(rs.getInt("villageId"));
        subOrder.setTotalPrice(rs.getBigDecimal("total_price"));
        subOrder.setPoints(rs.getObject("points") != null ? rs.getInt("points") : null);
        subOrder.setPaymentMethod(rs.getString("paymentMethod"));
        subOrder.setPaymentStatus(rs.getInt("paymentStatus"));
        subOrder.setOrderStatus(rs.getObject("orderStatus") != null ? rs.getInt("orderStatus") : null);
        subOrder.setNote(rs.getString("note"));
        subOrder.setReviewStatus(rs.getInt("reviewStatus"));

        // Cancel / Refund
        subOrder.setCancelReason(rs.getString("cancelReason"));
        subOrder.setCancelDate(rs.getTimestamp("cancelDate"));
        subOrder.setRefundAmount(rs.getBigDecimal("refundAmount"));
        subOrder.setRefundDate(rs.getTimestamp("refundDate"));
        subOrder.setRefundReason(rs.getString("refundReason"));

        // GHN Shipping Info
        subOrder.setShippingPartner(rs.getString("shippingPartner"));
        subOrder.setShippingOrderCode(rs.getString("shippingOrderCode"));
        subOrder.setShippingStatus(rs.getString("shippingStatus"));
        subOrder.setShippingFee(rs.getBigDecimal("shippingFee"));
        subOrder.setEstimatedDeliveryDate(rs.getDate("estimatedDeliveryDate"));
        subOrder.setShippingCreatedAt(rs.getTimestamp("shippingCreatedAt"));
        subOrder.setShippingUpdatedAt(rs.getTimestamp("shippingUpdatedAt"));
        subOrder.setLabelUrl(rs.getString("labelUrl"));
        subOrder.setTrackingUrl(rs.getString("trackingUrl"));
        subOrder.setShippingToken(rs.getString("shippingToken"));

        subOrder.setCreatedDate(rs.getTimestamp("createdDate"));
        subOrder.setUpdatedDate(rs.getTimestamp("updatedDate"));

        return subOrder;
    }

    private OrderDetail mapResultSetToOrderDetail(ResultSet rs) throws SQLException {
        OrderDetail detail = new OrderDetail();

        detail.setId(rs.getInt("id"));
        detail.setOrderId(rs.getInt("order_id"));
        detail.setSubOrderId(rs.getInt("subOrderId"));
        detail.setProductId(rs.getInt("product_id"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPrice(rs.getBigDecimal("price"));
        detail.setSubtotal(rs.getBigDecimal("subtotal")); // Optional nếu SELECT có cột này
        detail.setVillageId(rs.getInt("villageID"));
        detail.setReviewStatus(rs.getInt("reviewStatus"));

        return detail;
    }

    private TicketOrderDetail mapResultSetToTicketOrderDetail(ResultSet rs) throws SQLException {
        TicketOrderDetail detail = new TicketOrderDetail();

        detail.setDetailID(rs.getInt("detailID"));
        detail.setOrderID(rs.getInt("orderID"));
        detail.setSubOrderId(rs.getInt("subOrderId"));
        detail.setTicketID(rs.getInt("ticketID"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPrice(rs.getBigDecimal("price"));
        detail.setSubtotal(rs.getBigDecimal("subtotal")); // computed column
        detail.setVillageID(rs.getInt("villageID"));
        detail.setReviewStatus(rs.getInt("reviewStatus"));
        detail.setTicketCode(rs.getString("TicketCode"));

        return detail;
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
        String query = "{CALL AddOrder(?, ?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);

            cs.setInt(1, order.getUserID());
            cs.setBigDecimal(2, order.getTotalPrice());
            cs.setString(3, order.getShippingAddress());
            cs.setString(4, order.getShippingPhone());
            cs.setString(5, order.getShippingName());
            cs.setString(6, order.getPaymentMethod());
            cs.setString(7, order.getEmail());

            cs.registerOutParameter(8, Types.INTEGER); // @orderIDnew

            cs.execute();

            int newOrderId = cs.getInt(8);
            LOGGER.log(Level.INFO, "AddOrder result - new Order ID: {0}", newOrderId);
            return newOrderId;
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error adding order for user ID: " + order.getUserID(), e);
        } finally {
            closeResources(conn, cs, null);
        }
        return 0;
    }

    public Integer addSubOrder(SubOrder subOrder) {
        String sql = "{CALL AddSubOrder(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        Integer newSubOrderId = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(sql);

            cs.setInt(1, subOrder.getOrderId());
            cs.setInt(2, subOrder.getVillageId());
            cs.setBigDecimal(3, subOrder.getTotalPrice());

            if (subOrder.getPoints() != null) {
                cs.setInt(4, subOrder.getPoints());
            } else {
                cs.setNull(4, java.sql.Types.INTEGER);
            }
            cs.setString(5, subOrder.getPaymentMethod());
            if (subOrder.getPaymentStatus() != 0) {
                cs.setInt(6, subOrder.getPaymentStatus());
            } else {
                cs.setInt(6, 0); // default: unpaid
            }
            if (subOrder.getOrderStatus() != null) {
                cs.setInt(7, subOrder.getOrderStatus());
            } else {
                cs.setInt(7, 0); // default: new
            }
            if (subOrder.getNote() != null) {
                cs.setString(8, subOrder.getNote());
            } else {
                cs.setNull(8, java.sql.Types.NVARCHAR);
            }
            cs.registerOutParameter(9, java.sql.Types.INTEGER); // @subOrderIdNew
            cs.execute();
            newSubOrderId = cs.getInt(9);
            System.out.println("[INFO] SubOrder added successfully. ID = " + newSubOrderId);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[ERROR] Failed to add SubOrder: " + e.getMessage());
        } finally {
            closeResources(conn, cs, null);
        }
        return newSubOrderId;
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

    public Integer addOrderDetail(OrderDetail orderDetail) {

        String sql = "{CALL AddOrderDetail(?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        Integer newDetailId = null;
        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(sql);
            cs.setInt(1, orderDetail.getOrderId());
            cs.setInt(2, orderDetail.getSubOrderId());
            cs.setInt(3, orderDetail.getProductId());
            cs.setInt(4, orderDetail.getQuantity());
            cs.setBigDecimal(5, orderDetail.getPrice());
            cs.setInt(6, orderDetail.getVillageId());
            // OUT parameter
            cs.registerOutParameter(7, java.sql.Types.INTEGER);
            cs.execute();
            newDetailId = cs.getInt(7);
            System.out.println("OrderDetail added successfully. New Detail ID: " + newDetailId);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[ERROR] Failed to add OrderDetail: " + e.getMessage());
        } finally {
            closeResources(conn, cs, null);
        }
        return newDetailId;
    }

    public Integer addTicketOrderDetail(TicketOrderDetail ticketOrderDetail) {
        String sql = "{CALL AddTicketOrderDetail(?, ?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        Integer newDetailId = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(sql);
            cs.setInt(1, ticketOrderDetail.getOrderID());
            cs.setInt(2, ticketOrderDetail.getSubOrderId());
            cs.setInt(3, ticketOrderDetail.getTicketID());
            cs.setInt(4, ticketOrderDetail.getQuantity());
            cs.setBigDecimal(5, ticketOrderDetail.getPrice());
            cs.setInt(6, ticketOrderDetail.getVillageID());
            cs.setString(7, ticketOrderDetail.getTicketCode());
            // OUT parameter: TicketOrderDetailID
            cs.registerOutParameter(8, java.sql.Types.INTEGER);
            cs.execute();

            newDetailId = cs.getInt(8); // Get output value
            System.out.println("[INFO] TicketOrderDetail created successfully. New ID = " + newDetailId);

        } catch (Exception e) {
            System.err.println("[ERROR] Failed to add TicketOrderDetail: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, cs, null); // Assumes you have a method to close JDBC resources
        }
        return newDetailId;
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
        System.out.println(new OrderDAO().getSubOrderByVillageID(1));
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

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getAllOrderByUserID(int userID) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public List<OrderDetail> getAllOrderDetailByUserId(int userID) {
        List<OrderDetail> list = new ArrayList<>();
        List<Order> listOrder = new OrderDAO().getAllOrderByUserID(userID);
        String sql = "SELECT * FROM OrderDetail WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        for (Order o : listOrder) {
            try {
                conn = DBContext.getConnection(); // Hoặc connection pool của bạn
                ps = conn.prepareStatement(sql);
                ps.setInt(1, o.getId());
                rs = ps.executeQuery();

                while (rs.next()) {
                    OrderDetail od = mapResultSetToOrderDetail(rs);
                    Product p = new ProductService().getProductById(od.getProductId());
                    od.setProductName(p.getName());
                    list.add(od);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
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
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        return list;
    }

    public List<TicketOrderDetail> getAllTicketOrderDetailByUserId(int userID) {
        List<TicketOrderDetail> list = new ArrayList<>();
        List<Order> listOrder = new OrderDAO().getAllOrderByUserID(userID);
        String sql = "SELECT * FROM TicketOrderDetail WHERE orderID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        for (Order o : listOrder) {
            try {
                conn = DBContext.getConnection(); // Hoặc connection pool của bạn
                ps = conn.prepareStatement(sql);
                ps.setInt(1, o.getId());
                rs = ps.executeQuery();

                while (rs.next()) {
                    TicketOrderDetail od = mapResultSetToTicketOrderDetail(rs);
                    CraftVillage p = new VillageService().getVillageById(od.getVillageID());
                    od.setVillageName(p.getVillageName());
                    list.add(od);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
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
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        return list;
    }

    public OrderDetail getOrderDetail(int orderDetailID) {
        String sql = " SELECT * FROM OrderDetail WHERE id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderDetailID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrderDetail(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public TicketOrderDetail getTicketOrderDetail(int ticketOrderDetaiID) {
        String sql = " SELECT * FROM TicketOrderDetail WHERE detailID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ticketOrderDetaiID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTicketOrderDetail(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public SubOrder getSubOrderById(int subOrderId) {
        String query = "SELECT * FROM SubOrders WHERE subOrderId = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, subOrderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToSubOrder(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi khi lấy SubOrder với ID: " + subOrderId, e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return null;
    }

    public boolean refundSubOrderPayment(int subOrderId) {
        String query = "{? = call sp_RefundSubOrderPayment(?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            // Lấy thông tin SubOrder để hoàn tiền
            SubOrder subOrder = new OrderDAO().getSubOrderById(subOrderId); // ➤ bạn cần có hàm này
            int userID = new OrderDAO().getUserIDByOrderID(subOrder.getOrderId());
            int subtotal = (int) subOrder.getPoints();

            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);
            cs.registerOutParameter(1, java.sql.Types.INTEGER); // return value
            cs.setInt(2, subOrderId);

            cs.execute();
            int result = cs.getInt(1);

            LOGGER.log(Level.INFO, "RefundSubOrder result code: {0}", result);

            if (result == 1) {
                new OrderDAO().addPoints(userID, subtotal); // ➤ hoàn điểm nếu cần
                System.out.println(" Hoàn tiền thành công cho SubOrderID: " + subOrderId);
                return true;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, " Lỗi khi hoàn tiền SubOrderID: " + subOrderId, e);
        } finally {
            closeResources(conn, cs, null);
        }

        return false;
    }

    public Integer getSubOrderID(int orderID, int villageID) {
        String sql = "SELECT subOrderId FROM SubOrders WHERE orderId = ? AND villageId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ps.setInt(2, villageID); //  sửa index 2

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("subOrderId");
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting subOrderId for orderID=" + orderID + ", villageID=" + villageID, e);
        }

        return null; //  trả về null nếu không tìm thấy
    }

    public List<SubOrder> getSubOrderListByOrderID(int orderID) {
        List<SubOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM SubOrders WHERE orderID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderID);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToSubOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public List<OrderDetail> getAllOrderDetailByOrderID(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetail WHERE order_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail od = mapResultSetToOrderDetail(rs);
                od.setProductName(new ProductService().getProductById(od.getProductId()).getName());
                list.add(od);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public List<TicketOrderDetail> getAllTicketOrderDetailByOrderID(int orderId) {
        List<TicketOrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM TicketOrderDetail WHERE orderID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                TicketOrderDetail tod = mapResultSetToTicketOrderDetail(rs);
                tod.setVillageName(new VillageService().getVillageNameByID(tod.getVillageID()));

                list.add(tod);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                System.out.println(mapResultSetToOrder(rs));
                list.add(mapResultSetToOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public boolean cancelSubOrderDetail(int subOrderId, String reason) {
        String query = "{? = call sp_CancelSubOrder(?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);

            // Đăng ký RETURN value
            cs.registerOutParameter(1, java.sql.Types.INTEGER);

            // Set input parameters
            cs.setInt(2, subOrderId);
            cs.setString(3, reason);

            // Thực thi stored procedure
            cs.execute();

            int result = cs.getInt(1);
            LOGGER.log(Level.INFO, "sp_CancelOrder result subOrderId: {0}", result);

            return result == 1;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error cancelling subOrderId ID: " + subOrderId, e);
        } finally {
            closeResources(conn, cs, null);
        }
        return false;
    }

    public boolean confirmSubOrder(int subOrderId) {
        String sql = "UPDATE [CraftDB].[dbo].[SubOrders] "
                + "SET orderStatus = 2, "
                + "    paymentStatus = 1, "
                + "    updatedDate = GETDATE() "
                + "WHERE subOrderId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subOrderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error confirming order details for subOrderId: " + subOrderId, e);
        }
        return false;
    }

    public boolean refundSubOrder(int subOrderId, String reason) {
        String sql = "UPDATE [CraftDB].[dbo].[SubOrders] "
                + "SET orderStatus = 5, "
                + "    paymentStatus = 1, "
                + "    updatedDate = GETDATE(), "
                + "    refundReason = ?,"
                + "    refundDate = GETDATE()"
                + "WHERE subOrderId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reason);
            ps.setInt(2, subOrderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error confirming order details for subOrderId: " + subOrderId, e);
        }
        return false;
    }

    public void updateReviewStatus(int subOrderId) {
        String sql = "UPDATE [CraftDB].[dbo].[SubOrders] "
                + "SET reviewStatus = 1 "
                + "WHERE subOrderId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subOrderId);

            int rowsAffected = ps.executeUpdate();

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error confirming order details for subOrderId: " + subOrderId, e);
        }
    }

    public List<TicketOrderDetail> getTicketOrderDetailNonReview(int subOrderId) {
        List<TicketOrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM TicketOrderDetail WHERE  reviewStatus = 0 and subOrderId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, subOrderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                TicketOrderDetail tod = mapResultSetToTicketOrderDetail(rs);
                tod.setVillageName(new VillageService().getVillageNameByID(tod.getVillageID()));

                list.add(tod);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public List<OrderDetail> getOrderDetailNonReview(int subOrderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetail WHERE reviewStatus = 0 and subOrderId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, subOrderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail od = mapResultSetToOrderDetail(rs);
                od.setProductName(new ProductService().getProductById(od.getProductId()).getName());
                list.add(od);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public boolean addProductReviewByUser(ProductReview productReview) {
        String sql = "{call addProductReview(?, ?, ?, ?, ?, ?)}"; // 6 tham số (5 input + 1 output)

        try (Connection conn = DBContext.getConnection(); CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, productReview.getProductID());
            cs.setInt(2, productReview.getUserID());
            cs.setInt(3, productReview.getRating());
            cs.setString(4, productReview.getReviewText());
            cs.setString(5, productReview.getPictureUrl());

            // OUT parameter
            cs.registerOutParameter(6, java.sql.Types.INTEGER);

            cs.execute();

            int result = cs.getInt(6);
            return result == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void calculateProductReview(int rate, int productID) {
        String querySelect = "SELECT totalReviews, averageRating FROM Product WHERE pid = ?";
        String queryUpdate = "UPDATE Product SET totalReviews = ?, averageRating = ? WHERE pid = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement psSelect = conn.prepareStatement(querySelect); PreparedStatement psUpdate = conn.prepareStatement(queryUpdate)) {

            // Lấy dữ liệu cũ
            psSelect.setInt(1, productID);
            ResultSet rs = psSelect.executeQuery();

            if (rs.next()) {
                int totalReviews = rs.getInt("totalReviews");
                double averageRating = rs.getDouble("averageRating");

                // Tính lại trung bình mới
                int newTotal = totalReviews + 1;
                double newAverage = ((averageRating * totalReviews) + rate) / newTotal;

                // Cập nhật
                psUpdate.setInt(1, newTotal);
                psUpdate.setDouble(2, newAverage);
                psUpdate.setInt(3, productID);
                psUpdate.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateOrderDetailReviewStatus(int subOrderId, int productId) {
        String sql = "UPDATE OrderDetail SET reviewStatus = 1 WHERE subOrderId = ? and product_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subOrderId);
            ps.setInt(2, productId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean addVillageReviewByUser(CraftReview villageReview) {
        String sql = "{call addVillageReview(?, ?, ?, ?, ?, ?)}"; // 5 input + 1 output

        try (Connection conn = DBContext.getConnection(); CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, villageReview.getVillageID());
            cs.setInt(2, villageReview.getUserID());
            cs.setInt(3, villageReview.getRating());
            cs.setString(4, villageReview.getReviewText());
            cs.setString(5, villageReview.getPictureUrl());

            cs.registerOutParameter(6, java.sql.Types.INTEGER);

            cs.execute();

            int result = cs.getInt(6);
            return result == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void calculateVillageReview(int rate, int villageID) {
        String querySelect = "SELECT totalReviews, averageRating FROM CraftVillage WHERE villageID = ?";
        String queryUpdate = "UPDATE CraftVillage SET totalReviews = ?, averageRating = ? WHERE villageID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement psSelect = conn.prepareStatement(querySelect); PreparedStatement psUpdate = conn.prepareStatement(queryUpdate)) {

            // Lấy dữ liệu cũ
            psSelect.setInt(1, villageID);
            ResultSet rs = psSelect.executeQuery();

            if (rs.next()) {
                int totalReviews = rs.getInt("totalReviews");
                double averageRating = rs.getDouble("averageRating");

                // Tính lại trung bình mới
                int newTotal = totalReviews + 1;
                double newAverage = ((averageRating * totalReviews) + rate) / newTotal;

                // Cập nhật
                psUpdate.setInt(1, newTotal);
                psUpdate.setDouble(2, newAverage);
                psUpdate.setInt(3, villageID);
                psUpdate.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateTicketOrderDetailReviewStatus(int subOrderId, int ticketID) {
        String sql = "UPDATE TicketOrderDetail SET reviewStatus = 1 WHERE subOrderId = ? and ticketID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subOrderId);
            ps.setInt(2, ticketID);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkSubOrderReviewStatus(int subOrderId) {
        String countTotalQuery
                = "SELECT "
                + "    (SELECT COUNT(*) FROM OrderDetail WHERE subOrderId = ?) + "
                + "    (SELECT COUNT(*) FROM TicketOrderDetail WHERE subOrderId = ?) AS totalCount";

        String countReviewedQuery
                = "SELECT "
                + "    (SELECT COUNT(*) FROM OrderDetail WHERE subOrderId = ? AND reviewStatus = 1) + "
                + "    (SELECT COUNT(*) FROM TicketOrderDetail WHERE subOrderId = ? AND reviewStatus = 1) AS reviewedCount";

        String updateSubOrderQuery
                = "UPDATE SubOrders SET reviewStatus = 1 WHERE subOrderId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement psTotal = conn.prepareStatement(countTotalQuery); PreparedStatement psReviewed = conn.prepareStatement(countReviewedQuery)) {

            // Set parameters for both queries
            psTotal.setInt(1, subOrderId);
            psTotal.setInt(2, subOrderId);
            psReviewed.setInt(1, subOrderId);
            psReviewed.setInt(2, subOrderId);

            int total = 0;
            int reviewed = 0;

            try (ResultSet rsTotal = psTotal.executeQuery()) {
                if (rsTotal.next()) {
                    total = rsTotal.getInt("totalCount");
                }
            }

            try (ResultSet rsReviewed = psReviewed.executeQuery()) {
                if (rsReviewed.next()) {
                    reviewed = rsReviewed.getInt("reviewedCount");
                }
            }

            // Nếu tất cả mục đã review
            if (total > 0 && total == reviewed) {
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSubOrderQuery)) {
                    psUpdate.setInt(1, subOrderId);
                    psUpdate.executeUpdate();
                }
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<SubOrder> getSearchSubOrderByAdmin(int status, int searchID) {
        List<SubOrder> list = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM SubOrders WHERE 1=1");

        // Đếm tham số
        int paramIndex = 1;

        // Thêm điều kiện lọc nếu có
        if (status != 7) {
            query.append(" AND orderStatus = ?");
        }
        if (searchID != 0) {
            query.append(" AND villageId = ?");
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {

            // Gán giá trị theo thứ tự
            if (status != 7) {
                ps.setInt(paramIndex++, status);
            }
            if (searchID != 0) {
                ps.setInt(paramIndex++, searchID);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSubOrder(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<SubOrder> getSearchSubOrderByAdmin(int status, int searchID, String contentSearch, int page, int pageSize) {
        List<SubOrder> list = new ArrayList<>();
        String query = "";
        int paramIndex = 1;

        // Validate và chuẩn hóa input
        if (contentSearch == null) {
            contentSearch = "";
        }
        contentSearch = contentSearch.trim();
        if (page < 1) {
            page = 1;
        }
        if (pageSize <= 0) {
            pageSize = 10;
        }

        // Xác định có lọc theo orderStatus hay không
        boolean filterByStatus = (status != 7);

        // Xây dựng câu lệnh SQL tương ứng với searchID và status
        if (filterByStatus) {
            switch (searchID) {
                case 0:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? ORDER BY createdDate DESC";
                    break;
                case 1:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? AND villageId = ? ORDER BY createdDate DESC";
                    break;
                case 2:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? ORDER BY total_price ASC ";
                    break;
                case 3:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? ORDER BY total_price  DESC";
                    break;
                case 4:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? AND paymentMethod LIKE ? ORDER BY paymentMethod";
                    break;
                case 5:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? AND paymentStatus = ? ORDER BY paymentStatus";
                    break;
                case 6:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? ORDER BY orderStatus";
                    break;
                case 7:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? ORDER BY createdDate ASC";
                    break;
                case 8:
                    query = "SELECT * FROM SubOrders WHERE orderStatus = ? ORDER BY createdDate DESC ";
                    break;
                default:
                    throw new IllegalArgumentException("Invalid searchID: " + searchID);
            }
        } else {
            // Trường hợp không lọc theo orderStatus (status == 7)
            switch (searchID) {
                case 0:
                    query = "SELECT * FROM SubOrders ORDER BY createdDate DESC";
                    break;
                case 1:
                    query = "SELECT * FROM SubOrders WHERE villageId = ? ORDER BY createdDate DESC";
                    break;
                case 2:
                    query = "SELECT * FROM SubOrders ORDER BY total_price ASC";
                    break;
                case 3:
                    query = "SELECT * FROM SubOrders ORDER BY total_price DESC ";
                    break;
                case 4:
                    query = "SELECT * FROM SubOrders WHERE paymentMethod LIKE ? ORDER BY paymentMethod";
                    break;
                case 5:
                    query = "SELECT * FROM SubOrders WHERE paymentStatus = ? ORDER BY paymentStatus";
                    break;
                case 6:
                    query = "SELECT * FROM SubOrders ORDER BY orderStatus";
                    break;
                case 7:
                    query = "SELECT * FROM SubOrders ORDER BY createdDate ASC";
                    break;
                case 8:
                    query = "SELECT * FROM SubOrders ORDER BY createdDate DESC ";
                    break;
                default:
                    throw new IllegalArgumentException("Invalid searchID: " + searchID);
            }
        }

        // Thêm phân trang SQL Server
        query += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            // Nếu cần lọc theo orderStatus
            if (filterByStatus) {
                ps.setInt(paramIndex++, status);
            }

            // Nếu searchID có sử dụng LIKE
            if (searchID == 4) {
                ps.setString(paramIndex++, "%" + contentSearch + "%");
            } else if (searchID == 1 || searchID == 5) {
                ps.setInt(paramIndex++, Integer.parseInt(contentSearch));
            }

            // Phân trang
            int offset = Math.max((page - 1) * pageSize, 0);
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSubOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getTotalSubOrders(int status, int searchID, String contentSearch) {
        int total = 0;
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM SubOrders WHERE 1=1");

        boolean filterByStatus = (status != 7);
        if (filterByStatus) {
            query.append(" AND orderStatus = ?");
        }

        if (contentSearch == null) {
            contentSearch = "";
        }
        contentSearch = contentSearch.trim();

        // Xây dựng điều kiện tìm kiếm bổ sung
        switch (searchID) {
            case 1: // Village ID (LIKE)
                query.append(" AND villageId LIKE ?");
                break;
            case 4: // Payment method (LIKE)
                query.append(" AND paymentMethod LIKE ?");
                break;
            case 5: // Payment status (LIKE)
                query.append(" AND paymentStatus LIKE ?");
                break;
            case 6: // Order status (chỉ dùng nếu status == 7)
                if (!filterByStatus) {
                    query.append(" AND orderStatus = ?");
                }
                break;
            // Các searchID 0, 2, 3, 7, 8 không thêm điều kiện COUNT
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {

            int paramIndex = 1;

            // Trường hợp có lọc status != 7
            if (filterByStatus) {
                ps.setInt(paramIndex++, status);
            }

            // Gán tham số tìm kiếm
            switch (searchID) {
                case 1:
                case 4:
                case 5:
                    ps.setString(paramIndex++, "%" + contentSearch + "%");
                    break;
                case 6:
                    if (!filterByStatus) {
                        try {
                            ps.setInt(paramIndex++, Integer.parseInt(contentSearch));
                        } catch (NumberFormatException e) {
                            ps.setInt(paramIndex++, -1); // không tìm thấy
                        }
                    }
                    break;
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    public List<SubOrder> getSubOrderByVillageID(int villageID) {
        List<SubOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM SubOrders WHERE villageId = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection(); // Hoặc connection pool của bạn
            ps = conn.prepareStatement(sql);
            ps.setInt(1, villageID);
            rs = ps.executeQuery();

            while (rs.next()) {
                System.out.println(mapResultSetToSubOrder(rs));
                list.add(mapResultSetToSubOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public List<SubOrder> getSellerRecentOrders(int sellerId, int limit) {
        List<SubOrder> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            String sql = "SELECT TOP (?) so.*, cv.villageName "
                    + "FROM SubOrder so "
                    + "JOIN CraftVillage cv ON so.villageID = cv.villageID "
                    + "WHERE cv.sellerId = ? "
                    + "ORDER BY so.createdDate DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ps.setInt(2, sellerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToSubOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return orders;
    }

   public OrderDetail getOrderDetailById(int orderDetailId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        OrderDetail orderDetail = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT od.*, o.shippingAddress, o.shippingPhone, o.shippingName, " +
                        "o.paymentMethod as orderPaymentMethod, o.paymentStatus as orderPaymentStatus, " +
                        "o.createdDate as orderCreatedDate, o.email, " +
                        "a.userName, a.fullName, " +
                        "p.name as pname, p.mainImageUrl as pimage " +
                        "FROM OrderDetail od " +
                        "JOIN Orders o ON od.order_id = o.id " +
                        "JOIN Account a ON o.userID = a.userID " +
                        "JOIN Product p ON od.product_id = p.pid " +
                        "WHERE od.id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderDetailId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                orderDetail = new OrderDetail();
                orderDetail.setId(rs.getInt("id"));
                orderDetail.setOrderId(rs.getInt("order_id"));
                orderDetail.setProductId(rs.getInt("product_id"));
                orderDetail.setQuantity(rs.getInt("quantity"));
                orderDetail.setPrice(rs.getBigDecimal("price"));
                orderDetail.setSubtotal(rs.getBigDecimal("subtotal"));
                // Additional fields from joins
                orderDetail.setProductName(rs.getString("pname"));
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return orderDetail;
    }

    public Account getCustomerByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT a.* FROM Account a " +
                        "JOIN Orders o ON a.userID = o.userID " +
                        "WHERE o.id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                entity.Account.Account account = new entity.Account.Account();
                account.setUserID(rs.getInt("userID"));
                account.setUserName(rs.getString("userName"));
                account.setEmail(rs.getString("email"));
                account.setPhoneNumber(rs.getString("phoneNumber"));
                account.setAddress(rs.getString("address"));
                account.setFullName(rs.getString("fullName"));
                return account;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return null;
    }

    // Methods for seller order management using OrderDetail
    public List<OrderDetail> getOrderDetailsByVillageId(int villageId, int status, String searchKeyword, int page, int pageSize) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT od.*, o.shippingAddress, o.shippingPhone, o.shippingName, ")
               .append("o.paymentMethod as orderPaymentMethod, o.paymentStatus as orderPaymentStatus, ")
               .append("o.createdDate as orderCreatedDate, o.email, ")
               .append("a.userName, a.fullName, ")
               .append("p.name as pname, p.mainImageUrl as pimage ")
               .append("FROM OrderDetail od ")
               .append("JOIN Orders o ON od.order_id = o.id ")
               .append("JOIN Account a ON o.userID = a.userID ")
               .append("JOIN Product p ON od.product_id = p.pid ")
               .append("WHERE p.villageID = ? ");
            
            if (status >= 0) {
                sql.append("AND od.status = ? ");
            }
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                sql.append("AND (o.shippingName LIKE ? OR o.shippingPhone LIKE ? OR od.id LIKE ? OR o.id LIKE ?) ");
            }
            
            sql.append("ORDER BY od.createdDate DESC ")
               .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
            ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            ps.setInt(paramIndex++, villageId);
            
            if (status >= 0) {
                ps.setInt(paramIndex++, status);
            }
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }
            
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setId(rs.getInt("id"));
                orderDetail.setOrderId(rs.getInt("order_id"));
                orderDetail.setProductId(rs.getInt("product_id"));
                orderDetail.setQuantity(rs.getInt("quantity"));
                orderDetail.setPrice(rs.getBigDecimal("price"));
                orderDetail.setSubtotal(rs.getBigDecimal("subtotal"));
               
                orderDetail.setProductName(rs.getString("pname"));
                
                
                orderDetails.add(orderDetail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return orderDetails;
    }

    public int getTotalOrderDetailsByVillageId(int villageId, int status, String searchKeyword) {
        int total = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) as total ")
               .append("FROM OrderDetail od ")
               .append("JOIN Orders o ON od.order_id = o.id ")
               .append("WHERE od.villageID = ? ");
            
            if (status >= 0) {
                sql.append("AND od.status = ? ");
            }
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                sql.append("AND (o.shippingName LIKE ? OR o.shippingPhone LIKE ? OR od.id LIKE ? OR o.id LIKE ?) ");
            }
            
            ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            ps.setInt(paramIndex++, villageId);
            
            if (status >= 0) {
                ps.setInt(paramIndex++, status);
            }
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }
            
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return total;
    }

}
