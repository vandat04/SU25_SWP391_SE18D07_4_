/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Orders;

/**
 *
 * @author ACER
 */
import java.math.BigDecimal;
import java.util.Date;

public class SubOrder {

    private int subOrderId;
    private int orderId;
    private int villageId;
    private BigDecimal totalPrice;
    private Integer points;
    private String paymentMethod;
    private int paymentStatus;
    private Integer orderStatus;
    private String note;
    private String subName;
    private int reviewStatus;

    // Cancel/Refund
    private String cancelReason;
    private Date cancelDate;
    private BigDecimal refundAmount;
    private Date refundDate;
    private String refundReason;

    // GHN Shipping Info
    private String shippingPartner;
    private String shippingOrderCode;
    private String shippingStatus;
    private BigDecimal shippingFee;
    private Date estimatedDeliveryDate;
    private Date shippingCreatedAt;
    private Date shippingUpdatedAt;
    private String labelUrl;
    private String trackingUrl;
    private String shippingToken;

    private Date createdDate;
    private Date updatedDate;

    // Constructors
    public SubOrder() {
    }

    public SubOrder(int subOrderId, int orderId, int villageId, BigDecimal totalPrice, Integer points, String paymentMethod, int paymentStatus, Integer orderStatus, String note, String subName, int reviewStatus, String cancelReason, Date cancelDate, BigDecimal refundAmount, Date refundDate, String refundReason, String shippingPartner, String shippingOrderCode, String shippingStatus, BigDecimal shippingFee, Date estimatedDeliveryDate, Date shippingCreatedAt, Date shippingUpdatedAt, String labelUrl, String trackingUrl, String shippingToken, Date createdDate, Date updatedDate) {
        this.subOrderId = subOrderId;
        this.orderId = orderId;
        this.villageId = villageId;
        this.totalPrice = totalPrice;
        this.points = points;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
        this.note = note;
        this.subName = subName;
        this.reviewStatus = reviewStatus;
        this.cancelReason = cancelReason;
        this.cancelDate = cancelDate;
        this.refundAmount = refundAmount;
        this.refundDate = refundDate;
        this.refundReason = refundReason;
        this.shippingPartner = shippingPartner;
        this.shippingOrderCode = shippingOrderCode;
        this.shippingStatus = shippingStatus;
        this.shippingFee = shippingFee;
        this.estimatedDeliveryDate = estimatedDeliveryDate;
        this.shippingCreatedAt = shippingCreatedAt;
        this.shippingUpdatedAt = shippingUpdatedAt;
        this.labelUrl = labelUrl;
        this.trackingUrl = trackingUrl;
        this.shippingToken = shippingToken;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    public SubOrder(int orderId, int villageId, BigDecimal totalPrice, Integer points, String paymentMethod, int paymentStatus, Integer orderStatus, String note) {
        this.orderId = orderId;
        this.villageId = villageId;
        this.totalPrice = totalPrice;
        this.points = points;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
        this.note = note;
    }

    public SubOrder(int orderId, int villageId, BigDecimal totalPrice, Integer points, String paymentMethod, int paymentStatus, Integer orderStatus, String note, String subName) {
        this.orderId = orderId;
        this.villageId = villageId;
        this.totalPrice = totalPrice;
        this.points = points;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
        this.note = note;
        this.subName = subName;
    }

    public int getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(int reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public String getSubName() {
        return subName;
    }

    public void setSubName(String subName) {
        this.subName = subName;
    }

    public int getSubOrderId() {
        return subOrderId;
    }

    public void setSubOrderId(int subOrderId) {
        this.subOrderId = subOrderId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getVillageId() {
        return villageId;
    }

    public void setVillageId(int villageId) {
        this.villageId = villageId;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
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

    public Integer getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(Integer orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public Date getCancelDate() {
        return cancelDate;
    }

    public void setCancelDate(Date cancelDate) {
        this.cancelDate = cancelDate;
    }

    public BigDecimal getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(BigDecimal refundAmount) {
        this.refundAmount = refundAmount;
    }

    public Date getRefundDate() {
        return refundDate;
    }

    public void setRefundDate(Date refundDate) {
        this.refundDate = refundDate;
    }

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
    }

    public String getShippingPartner() {
        return shippingPartner;
    }

    public void setShippingPartner(String shippingPartner) {
        this.shippingPartner = shippingPartner;
    }

    public String getShippingOrderCode() {
        return shippingOrderCode;
    }

    public void setShippingOrderCode(String shippingOrderCode) {
        this.shippingOrderCode = shippingOrderCode;
    }

    public String getShippingStatus() {
        return shippingStatus;
    }

    public void setShippingStatus(String shippingStatus) {
        this.shippingStatus = shippingStatus;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public Date getEstimatedDeliveryDate() {
        return estimatedDeliveryDate;
    }

    public void setEstimatedDeliveryDate(Date estimatedDeliveryDate) {
        this.estimatedDeliveryDate = estimatedDeliveryDate;
    }

    public Date getShippingCreatedAt() {
        return shippingCreatedAt;
    }

    public void setShippingCreatedAt(Date shippingCreatedAt) {
        this.shippingCreatedAt = shippingCreatedAt;
    }

    public Date getShippingUpdatedAt() {
        return shippingUpdatedAt;
    }

    public void setShippingUpdatedAt(Date shippingUpdatedAt) {
        this.shippingUpdatedAt = shippingUpdatedAt;
    }

    public String getLabelUrl() {
        return labelUrl;
    }

    public void setLabelUrl(String labelUrl) {
        this.labelUrl = labelUrl;
    }

    public String getTrackingUrl() {
        return trackingUrl;
    }

    public void setTrackingUrl(String trackingUrl) {
        this.trackingUrl = trackingUrl;
    }

    public String getShippingToken() {
        return shippingToken;
    }

    public void setShippingToken(String shippingToken) {
        this.shippingToken = shippingToken;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return "SubOrder{" + "subOrderId=" + subOrderId + ", orderId=" + orderId + ", villageId=" + villageId + ", totalPrice=" + totalPrice + ", points=" + points + ", paymentMethod=" + paymentMethod + ", paymentStatus=" + paymentStatus + ", orderStatus=" + orderStatus + ", note=" + note + ", subName=" + subName + ", reviewStatus=" + reviewStatus + ", cancelReason=" + cancelReason + ", cancelDate=" + cancelDate + ", refundAmount=" + refundAmount + ", refundDate=" + refundDate + ", refundReason=" + refundReason + ", shippingPartner=" + shippingPartner + ", shippingOrderCode=" + shippingOrderCode + ", shippingStatus=" + shippingStatus + ", shippingFee=" + shippingFee + ", estimatedDeliveryDate=" + estimatedDeliveryDate + ", shippingCreatedAt=" + shippingCreatedAt + ", shippingUpdatedAt=" + shippingUpdatedAt + ", labelUrl=" + labelUrl + ", trackingUrl=" + trackingUrl + ", shippingToken=" + shippingToken + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + '}';
    }

}
