package entity.Orders;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int id;
    private int userID;
    private BigDecimal totalPrice;
    private String shippingAddress;
    private String shippingPhone;
    private String shippingName;
    private String paymentMethod;
    private Timestamp createdDate;
    private String email;

    // Constructors
    public Order() {
    }

    public Order(int id, int userID, BigDecimal totalPrice, String shippingAddress, String shippingPhone,
                 String shippingName, String paymentMethod, Timestamp createdDate, String email) {
        this.id = id;
        this.userID = userID;
        this.totalPrice = totalPrice;
        this.shippingAddress = shippingAddress;
        this.shippingPhone = shippingPhone;
        this.shippingName = shippingName;
        this.paymentMethod = paymentMethod;
        this.createdDate = createdDate;
        this.email = email;
    }

    public Order(int userID, BigDecimal totalPrice, String shippingAddress, String shippingPhone, String shippingName, String paymentMethod, String email) {
        this.userID = userID;
        this.totalPrice = totalPrice;
        this.shippingAddress = shippingAddress;
        this.shippingPhone = shippingPhone;
        this.shippingName = shippingName;
        this.paymentMethod = paymentMethod;
        this.email = email;
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

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Order{" + "id=" + id + ", userID=" + userID + ", totalPrice=" + totalPrice + ", shippingAddress=" + shippingAddress + ", shippingPhone=" + shippingPhone + ", shippingName=" + shippingName + ", paymentMethod=" + paymentMethod + ", createdDate=" + createdDate + ", email=" + email + '}';
    }
    
}