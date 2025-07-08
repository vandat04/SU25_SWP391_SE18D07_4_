package entity.Orders;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int orderID;
    private int userID;
    private Timestamp orderDate;
    private BigDecimal totalAmount;
    private String status;
    private String shippingAddress;
    private String phoneNumber;
    private String email;
    private String paymentMethod;
    private String paymentStatus;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private List<OrderDetail> orderDetails;

    public Order() {
        this.orderDetails = new ArrayList<>();
        this.status = "pending";
        this.paymentStatus = "pending";
        this.createdDate = new Timestamp(System.currentTimeMillis());
    }

    public Order(int orderID, int userID, Timestamp orderDate, BigDecimal totalAmount, 
                String status, String shippingAddress, String phoneNumber, String email,
                String paymentMethod, String paymentStatus, Timestamp createdDate, Timestamp updatedDate) {
        this.orderID = orderID;
        this.userID = userID;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.shippingAddress = shippingAddress;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.orderDetails = new ArrayList<>();
    }

    // Constructor tương thích code cũ
    public Order(int orderID, int userID, String orderDate, double totalAmount, String status) {
        this.orderID = orderID;
        this.userID = userID;
        this.orderDate = null; // Chuyển đổi String sang Timestamp nếu cần
        this.totalAmount = java.math.BigDecimal.valueOf(totalAmount);
        this.status = status;
        this.orderDetails = new java.util.ArrayList<>();
        this.createdDate = new java.sql.Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    // Chuẩn hóa cho generic DAO
    public int getId() {
        return orderID;
    }
    public void setId(int id) {
        this.orderID = id;
    }
    public String getName() {
        return shippingAddress; // hoặc trường phù hợp nhất, ở đây không có name nên dùng shippingAddress
    }
    public void setName(String name) {
        this.shippingAddress = name;
    }

    // Helper methods
    public boolean isPending() {
        return "pending".equalsIgnoreCase(status);
    }

    public boolean isProcessing() {
        return "processing".equalsIgnoreCase(status);
    }

    public boolean isShipped() {
        return "shipped".equalsIgnoreCase(status);
    }

    public boolean isDelivered() {
        return "delivered".equalsIgnoreCase(status);
    }

    public boolean isCancelled() {
        return "cancelled".equalsIgnoreCase(status);
    }

    public boolean isPaid() {
        return "paid".equalsIgnoreCase(paymentStatus);
    }

    public boolean isUnpaid() {
        return "unpaid".equalsIgnoreCase(paymentStatus) || "pending".equalsIgnoreCase(paymentStatus);
    }

    public void addOrderDetail(OrderDetail detail) {
        if (detail != null) {
            this.orderDetails.add(detail);
            recalculateTotalAmount();
        }
    }

    public void removeOrderDetail(OrderDetail detail) {
        if (detail != null && this.orderDetails.contains(detail)) {
            this.orderDetails.remove(detail);
            recalculateTotalAmount();
        }
    }

    private void recalculateTotalAmount() {
        BigDecimal total = BigDecimal.ZERO;
        for (OrderDetail detail : orderDetails) {
            total = total.add(BigDecimal.valueOf(detail.getSubtotal()));
        }
        this.totalAmount = total;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderID=" + orderID +
                ", userID=" + userID +
                ", orderDate=" + orderDate +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", shippingAddress='" + shippingAddress + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", email='" + email + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                ", orderDetailsCount=" + (orderDetails != null ? orderDetails.size() : 0) +
                '}';
    }

    public static Order fromResultSet(java.sql.ResultSet rs) throws java.sql.SQLException {
        Order order = new Order();
        order.setOrderID(rs.getInt("id"));
        order.setUserID(rs.getInt("userID"));
        order.setOrderDate(rs.getTimestamp("orderDate"));
        order.setTotalAmount(rs.getBigDecimal("total_price"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shippingAddress"));
        order.setPhoneNumber(rs.getString("shippingPhone"));
        order.setEmail(rs.getString("email"));
        order.setPaymentMethod(rs.getString("paymentMethod"));
        order.setPaymentStatus(rs.getString("paymentStatus"));
        order.setCreatedDate(rs.getTimestamp("createdDate"));
        order.setUpdatedDate(rs.getTimestamp("updatedDate"));
        return order;
    }
} 