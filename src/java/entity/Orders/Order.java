package entity.Orders;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {

    private int orderID;
    private int userID;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private String shippingName;
    private String phoneNumber;
    private String email;
    private String paymentMethod;
    private int paymentStatus;
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
    private String fullName;
    private int points;

    public Order() {
    }

    // Full constructor
    public Order(int orderID, int userID, BigDecimal totalAmount, 
                 String shippingAddress, String shippingName, String phoneNumber, String email,
                 String paymentMethod, int paymentStatus, String note, Timestamp createdDate,
                 Timestamp updatedDate, String trackingNumber, Timestamp estimatedDeliveryDate,
                 Timestamp actualDeliveryDate, String cancelReason, Timestamp cancelDate,
                 BigDecimal refundAmount, Timestamp refundDate, String refundReason) {
        this.orderID = orderID;
        this.userID = userID;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.shippingName = shippingName;
        this.phoneNumber = phoneNumber;
        this.email = email;
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

    // Giữ nguyên constructor partial của bạn:
    public Order(int orderID, int userID, BigDecimal totalAmount,  String shippingAddress,
                 String phoneNumber, String email, String paymentMethod, int paymentStatus,
                 Timestamp createdDate, Timestamp updatedDate) {
        this.orderID = orderID;
        this.userID = userID;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    public Order(int userID, BigDecimal totalAmount, String shippingAddress,
                 String phoneNumber, String email, String paymentMethod, int paymentStatus, String note, String fullName, int points) {
        this.userID = userID;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.note = note;
        this.fullName = fullName;
        this.points = points;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

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

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    
    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingName() {
        return shippingName;
    }

    public void setShippingName(String shippingName) {
        this.shippingName = shippingName;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    @Override
    public String toString() {
        return "Order{" + "orderID=" + orderID + ", userID=" + userID + ", totalAmount=" + totalAmount + ", shippingAddress=" + shippingAddress + ", shippingName=" + shippingName + ", phoneNumber=" + phoneNumber + ", email=" + email + ", paymentMethod=" + paymentMethod + ", paymentStatus=" + paymentStatus + ", note=" + note + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + ", trackingNumber=" + trackingNumber + ", estimatedDeliveryDate=" + estimatedDeliveryDate + ", actualDeliveryDate=" + actualDeliveryDate + ", cancelReason=" + cancelReason + ", cancelDate=" + cancelDate + ", refundAmount=" + refundAmount + ", refundDate=" + refundDate + ", refundReason=" + refundReason + '}';
    }
    
    
}