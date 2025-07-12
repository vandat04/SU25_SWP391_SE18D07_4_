package entity.Orders;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Order entity class representing the Orders table in the database
 * @author ACER
 */
public class Order {
    private int id;
    private int userID;
    private BigDecimal totalPrice;
    private int status;  // 0: pending, 1: delivered, 2: cancelled
    private String shippingAddress;
    private String shippingPhone;
    private String shippingName;
    private String paymentMethod;
    private int paymentStatus;  // 0: unpaid, 1: paid
    private String note;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private String trackingNumber;
    private Timestamp estimatedDeliveryDate;
    private Timestamp actualDeliveryDate;
    private String cancelReason;
    private Timestamp cancelDate;
    private BigDecimal refundAmount;
    private Timestamp refundDate;
    private String refundReason;
    
    // Order details relationship (removed due to OrderDetail cleanup)
    // private List<OrderDetail> orderDetails;
    
    // Default constructor
    public Order() {
        // this.orderDetails = new ArrayList<>();
    }
    
    // Constructor with essential fields
    public Order(int userID, BigDecimal totalPrice, String shippingAddress, 
                String shippingPhone, String shippingName, String paymentMethod) {
        this();
        this.userID = userID;
        this.totalPrice = totalPrice;
        this.shippingAddress = shippingAddress;
        this.shippingPhone = shippingPhone;
        this.shippingName = shippingName;
        this.paymentMethod = paymentMethod;
        this.status = 0;  // Default: pending
        this.paymentStatus = 0;  // Default: unpaid
        this.createdDate = new Timestamp(System.currentTimeMillis());
    }
    
    // Full constructor
    public Order(int id, int userID, BigDecimal totalPrice, int status, 
                String shippingAddress, String shippingPhone, String shippingName,
                String paymentMethod, int paymentStatus, String note,
                Timestamp createdDate, Timestamp updatedDate, String trackingNumber,
                Timestamp estimatedDeliveryDate, Timestamp actualDeliveryDate,
                String cancelReason, Timestamp cancelDate, BigDecimal refundAmount,
                Timestamp refundDate, String refundReason) {
        this();
        this.id = id;
        this.userID = userID;
        this.totalPrice = totalPrice;
        this.status = status;
        this.shippingAddress = shippingAddress;
        this.shippingPhone = shippingPhone;
        this.shippingName = shippingName;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.note = note;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.trackingNumber = trackingNumber;
        this.estimatedDeliveryDate = estimatedDeliveryDate;
        this.actualDeliveryDate = actualDeliveryDate;
        this.cancelReason = cancelReason;
        this.cancelDate = cancelDate;
        this.refundAmount = refundAmount;
        this.refundDate = refundDate;
        this.refundReason = refundReason;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }
    
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
    
    public String getShippingPhone() {
        return shippingPhone;
    }
    
    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }
    
    public String getShippingName() {
        return shippingName;
    }
    
    public void setShippingName(String shippingName) {
        this.shippingName = shippingName;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public int getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(int paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getNote() {
        return note;
    }
    
    public void setNote(String note) {
        this.note = note;
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
    
    public String getTrackingNumber() {
        return trackingNumber;
    }
    
    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }
    
    public Timestamp getEstimatedDeliveryDate() {
        return estimatedDeliveryDate;
    }
    
    public void setEstimatedDeliveryDate(Timestamp estimatedDeliveryDate) {
        this.estimatedDeliveryDate = estimatedDeliveryDate;
    }
    
    public Timestamp getActualDeliveryDate() {
        return actualDeliveryDate;
    }
    
    public void setActualDeliveryDate(Timestamp actualDeliveryDate) {
        this.actualDeliveryDate = actualDeliveryDate;
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
    
    public BigDecimal getRefundAmount() {
        return refundAmount;
    }
    
    public void setRefundAmount(BigDecimal refundAmount) {
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
    
    // OrderDetail methods removed due to OrderDetail cleanup
    // public List<OrderDetail> getOrderDetails() {
    //     return orderDetails;
    // }
    
    // public void setOrderDetails(List<OrderDetail> orderDetails) {
    //     this.orderDetails = orderDetails;
    // }
    
    // public void addOrderDetail(OrderDetail orderDetail) {
    //     if (this.orderDetails == null) {
    //         this.orderDetails = new ArrayList<>();
    //     }
    //     this.orderDetails.add(orderDetail);
    // }
    
    // Utility methods
    public String getStatusString() {
        switch (status) {
            case 0: return "Pending";
            case 1: return "Delivered";
            case 2: return "Cancelled";
            default: return "Unknown";
        }
    }
    
    public String getPaymentStatusString() {
        return paymentStatus == 0 ? "Unpaid" : "Paid";
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userID=" + userID +
                ", totalPrice=" + totalPrice +
                ", status=" + status +
                ", shippingAddress='" + shippingAddress + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
} 