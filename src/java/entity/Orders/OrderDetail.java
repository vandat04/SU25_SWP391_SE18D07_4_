package entity.Orders;

import java.sql.Timestamp;

public class OrderDetail {

    private int orderDetailID;      // maps to [id]
    private int orderID;            // maps to [order_id]
    private int productID;          // maps to [product_id]
    private String productName;
    private double price;           // maps to [price]
    private int quantity;           // maps to [quantity]
    private double subtotal;        // maps to [subtotal]
    private int status;             // maps to [status]
    private Integer villageID;      // maps to [villageID]
    private String paymentMethod;   // maps to [paymentMethod]
    private Integer paymentStatus;  // maps to [paymentStatus]
    private String cancelReason;    // maps to [cancelReason]
    private Timestamp cancelDate;   // maps to [cancelDate]
    private Double refundAmount;    // maps to [refundAmount]
    private Timestamp refundDate;   // maps to [refundDate]
    private String refundReason;    // maps to [refundReason]
    private Timestamp createdDate;  // maps to [createdDate]
    private Timestamp updatedDate;  // maps to [updatedDate]
    private Integer points;         // maps to [points]
    private String imageUrl;        // bổ sung (không có trong DB, dùng cho UI)

    public OrderDetail() {
        this.createdDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor đầy đủ
    public OrderDetail(int orderDetailID, int orderID, int productID, String productName,
            double price, int quantity, double subtotal, int status,
            Integer villageID, String paymentMethod, Integer paymentStatus,
            String cancelReason, Timestamp cancelDate, Double refundAmount,
            Timestamp refundDate, String refundReason, Timestamp createdDate,
            Timestamp updatedDate, Integer points, String imageUrl) {
        this.orderDetailID = orderDetailID;
        this.orderID = orderID;
        this.productID = productID;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.subtotal = subtotal;
        this.status = status;
        this.villageID = villageID;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.cancelReason = cancelReason;
        this.cancelDate = cancelDate;
        this.refundAmount = refundAmount;
        this.refundDate = refundDate;
        this.refundReason = refundReason;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.points = points;
        this.imageUrl = imageUrl;
    }

    public OrderDetail(int orderDetailID, int orderID, int productID, String productName,
            double price, int quantity, String imageUrl, Timestamp createdDate,
            Timestamp updatedDate) {
        this.orderDetailID = orderDetailID;
        this.orderID = orderID;
        this.productID = productID;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        calculateSubtotal();
    }

    public OrderDetail(int orderDetailID, int orderID, int productID, double price, int quantity) {
        this.orderDetailID = orderDetailID;
        this.orderID = orderID;
        this.productID = productID;
        this.price = price;
        this.quantity = quantity;
        calculateSubtotal();
        this.createdDate = new java.sql.Timestamp(System.currentTimeMillis());
    }

    public OrderDetail(int orderID, int productID, int quantity, java.math.BigDecimal price) {
        this.orderID = orderID;
        this.productID = productID;
        this.quantity = quantity;
        this.price = price.doubleValue();
        calculateSubtotal();
        this.createdDate = new java.sql.Timestamp(System.currentTimeMillis());
    }

    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
        calculateSubtotal();
    }

    // Overload for BigDecimal compatibility
    public void setPrice(java.math.BigDecimal price) {
        this.price = price.doubleValue();
        calculateSubtotal();
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        if (quantity > 0) {
            this.quantity = quantity;
            calculateSubtotal();
        }
    }

    public double getSubtotal() {
        return subtotal;
    }

    private void calculateSubtotal() {
        this.subtotal = this.price * this.quantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Integer getVillageID() {
        return villageID;
    }

    public void setVillageID(Integer villageID) {
        this.villageID = villageID;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Integer getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(Integer paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public Timestamp getCancelDate() {
        return cancelDate;
    }

    public void setCancelDate(Timestamp cancelDate) {
        this.cancelDate = cancelDate;
    }

    public Double getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(Double refundAmount) {
        this.refundAmount = refundAmount;
    }

    public Timestamp getRefundDate() {
        return refundDate;
    }

    public void setRefundDate(Timestamp refundDate) {
        this.refundDate = refundDate;
    }

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
    }

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }
    
    @Override
    public String toString() {
        return "OrderDetail{"
                + "orderDetailID=" + orderDetailID
                + ", orderID=" + orderID
                + ", productID=" + productID
                + ", productName='" + productName + '\''
                + ", price=" + price
                + ", quantity=" + quantity
                + ", subtotal=" + subtotal
                + ", status=" + status
                + ", villageID=" + villageID
                + ", paymentMethod='" + paymentMethod + '\''
                + ", paymentStatus=" + paymentStatus
                + ", cancelReason='" + cancelReason + '\''
                + ", cancelDate=" + cancelDate
                + ", refundAmount=" + refundAmount
                + ", refundDate=" + refundDate
                + ", refundReason='" + refundReason + '\''
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", points=" + points
                + ", imageUrl='" + imageUrl + '\''
                + '}';
    }

}
