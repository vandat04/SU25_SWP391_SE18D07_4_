/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Orders;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author ACER
 */
public class TicketOrderDetail {

    private int detailID;
    private int orderID;
    private int ticketID;
    private int quantity;
    private BigDecimal price;
    private BigDecimal subtotal;
    private int status;
    private Integer villageID;
    private String paymentMethod;
    private Integer paymentStatus;
    private String cancelReason;
    private Timestamp cancelDate;
    private BigDecimal refundAmount;
    private Timestamp refundDate;
    private String refundReason;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private Integer points;

    // Constructors-------------------------------------------------------------
    public TicketOrderDetail() {
    }

    public TicketOrderDetail(int detailID, int orderID, int ticketID, int quantity, BigDecimal price, BigDecimal subtotal) {
        this.detailID = detailID;
        this.orderID = orderID;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
    }

    public TicketOrderDetail(int orderID, int ticketID, int quantity, BigDecimal price) {
        this.orderID = orderID;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
    }

    public TicketOrderDetail(int detailID, int orderID, int ticketID, int quantity,
            BigDecimal price, BigDecimal subtotal, int status,
            Integer villageID, String paymentMethod, Integer paymentStatus,
            String cancelReason, Timestamp cancelDate,
            BigDecimal refundAmount, Timestamp refundDate,
            String refundReason, Timestamp createdDate,
            Timestamp updatedDate, Integer points) {
        this.detailID = detailID;
        this.orderID = orderID;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
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
    }

    //--------------------------------------------------------------------------
    public int getDetailID() {
        return detailID;
    }

    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getTicketID() {
        return ticketID;
    }

    public void setTicketID(int ticketID) {
        this.ticketID = ticketID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
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

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    @Override
    public String toString() {
        return "TicketOrderDetail{" + "detailID=" + detailID + ", orderID=" + orderID + ", ticketID=" + ticketID + ", quantity=" + quantity + ", price=" + price + ", subtotal=" + subtotal + ", status=" + status + ", villageID=" + villageID + ", paymentMethod=" + paymentMethod + ", paymentStatus=" + paymentStatus + ", cancelReason=" + cancelReason + ", cancelDate=" + cancelDate + ", refundAmount=" + refundAmount + ", refundDate=" + refundDate + ", refundReason=" + refundReason + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + ", points=" + points + '}';
    }

}
