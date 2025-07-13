package entity.Orders; 

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {

    private int paymentID;
    private Integer sellerID;
    private Integer orderID;
    private Integer ticketOrderID;
    private BigDecimal amount;
    private String paymentMethod;
    private int paymentStatus;
    private String transactionID;
    private Timestamp paymentDate;
    private Timestamp updatedDate;

    public Payment() {
    }

    public Payment(int paymentID, Integer sellerID, Integer orderID, Integer ticketOrderID,
                   BigDecimal amount, String paymentMethod, int paymentStatus,
                   String transactionID, Timestamp paymentDate, Timestamp updatedDate) {
        this.paymentID = paymentID;
        this.sellerID = sellerID;
        this.orderID = orderID;
        this.ticketOrderID = ticketOrderID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionID = transactionID;
        this.paymentDate = paymentDate;
        this.updatedDate = updatedDate;
    }

    public Payment(Integer sellerID, Integer orderID, Integer ticketOrderID, BigDecimal amount, String paymentMethod, int paymentStatus) {
        this.sellerID = sellerID;
        this.orderID = orderID;
        this.ticketOrderID = ticketOrderID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public Integer getSellerID() {
        return sellerID;
    }

    public void setSellerID(Integer sellerID) {
        this.sellerID = sellerID;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Integer getTicketOrderID() {
        return ticketOrderID;
    }

    public void setTicketOrderID(Integer ticketOrderID) {
        this.ticketOrderID = ticketOrderID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
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

    public String getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(String transactionID) {
        this.transactionID = transactionID;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return "Payment{" + "paymentID=" + paymentID + ", sellerID=" + sellerID + ", orderID=" + orderID + ", ticketOrderID=" + ticketOrderID + ", amount=" + amount + ", paymentMethod=" + paymentMethod + ", paymentStatus=" + paymentStatus + ", transactionID=" + transactionID + ", paymentDate=" + paymentDate + ", updatedDate=" + updatedDate + '}';
    }
}