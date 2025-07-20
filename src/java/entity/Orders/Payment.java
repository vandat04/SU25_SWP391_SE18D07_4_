package entity.Orders; 

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentID;
    private int subOrderId;
    private int sellerID;
    private BigDecimal amount;
    private String paymentMethod;
    private int paymentStatus;
    private String transactionID;
    private Timestamp paymentDate;
    private Timestamp updatedDate;

    // Constructors
    public Payment() {
    }

    public Payment(int paymentID, int subOrderId, int sellerID, BigDecimal amount, String paymentMethod,
                   int paymentStatus, String transactionID, Timestamp paymentDate, Timestamp updatedDate) {
        this.paymentID = paymentID;
        this.subOrderId = subOrderId;
        this.sellerID = sellerID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionID = transactionID;
        this.paymentDate = paymentDate;
        this.updatedDate = updatedDate;
    }

    public Payment(int subOrderId, int sellerID, BigDecimal amount, String paymentMethod, int paymentStatus, String transactionID, Timestamp paymentDate, Timestamp updatedDate) {
        this.subOrderId = subOrderId;
        this.sellerID = sellerID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionID = transactionID;
        this.paymentDate = paymentDate;
        this.updatedDate = updatedDate;
    }
    
    public Payment(int subOrderId, int sellerID, BigDecimal amount, String paymentMethod, int paymentStatus, String transactionID) {
        this.subOrderId = subOrderId;
        this.sellerID = sellerID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.transactionID = transactionID;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getSubOrderId() {
        return subOrderId;
    }

    public void setSubOrderId(int subOrderId) {
        this.subOrderId = subOrderId;
    }

    public int getSellerID() {
        return sellerID;
    }

    public void setSellerID(int sellerID) {
        this.sellerID = sellerID;
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
        return "Payment{" + "paymentID=" + paymentID + ", subOrderId=" + subOrderId + ", sellerID=" + sellerID + ", amount=" + amount + ", paymentMethod=" + paymentMethod + ", paymentStatus=" + paymentStatus + ", transactionID=" + transactionID + ", paymentDate=" + paymentDate + ", updatedDate=" + updatedDate + '}';
    }
    
}