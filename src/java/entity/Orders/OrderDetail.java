/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Orders;

import entity.Product.Product;
import java.math.BigDecimal;
import java.util.Date;

public class OrderDetail {

    private int id;
    private int orderId;
    private int subOrderId;
    private int productId;
    private int quantity;
    private BigDecimal price;
    private BigDecimal subtotal; // Computed column in DB
    private Integer villageId;
    private String productName;
    private int reviewStatus;
    private Product product; // Added for seller management
    
    // Fields from database
    private int status;
    private String paymentMethod;
    private int paymentStatus;
    private String cancelReason;
    private Date cancelDate;
    private BigDecimal refundAmount;
    private Date refundDate;
    private String refundReason;
    private Date createdDate;
    private Date updatedDate;
    private int points;
    
    // Additional fields from joins for seller management
    private String shippingAddress;
    private String shippingPhone;
    private String shippingName;
    private String email;
    private String userName;
    private String fullName;
    private String productImage;
    private Date orderCreatedDate;

    // Constructors
    public OrderDetail() {
    }

    public OrderDetail(int id, int orderId, int subOrderId, int productId, int quantity, BigDecimal price, BigDecimal subtotal, Integer villageId, int reviewStatus) {
        this.id = id;
        this.orderId = orderId;
        this.subOrderId = subOrderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.villageId = villageId;
        this.reviewStatus = reviewStatus;
    }

    public OrderDetail(int id, int orderId, int subOrderId, int productId, int quantity, BigDecimal price, BigDecimal subtotal, Integer villageId, String productName, int reviewStatus) {
        this.id = id;
        this.orderId = orderId;
        this.subOrderId = subOrderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.villageId = villageId;
        this.productName = productName;
        this.reviewStatus = reviewStatus;
    }
    
    

    public OrderDetail(int id, int orderId, int subOrderId, int productId, int quantity,
            BigDecimal price, BigDecimal subtotal, Integer villageId, String productName) {
        this.id = id;
        this.orderId = orderId;
        this.subOrderId = subOrderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.productName = productName;
    }

    public OrderDetail(int id, int orderId, int subOrderId, int productId, int quantity, BigDecimal price, BigDecimal subtotal, Integer villageId) {
        this.id = id;
        this.orderId = orderId;
        this.subOrderId = subOrderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.villageId = villageId;
    }

    public OrderDetail(int orderId, int subOrderId, int productId, int quantity, BigDecimal price, Integer villageId) {
        this.orderId = orderId;
        this.subOrderId = subOrderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.villageId = villageId;
    }

    public int getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(int reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getSubOrderId() {
        return subOrderId;
    }

    public void setSubOrderId(int subOrderId) {
        this.subOrderId = subOrderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
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

    public Integer getVillageId() {
        return villageId;
    }

    public void setVillageId(Integer villageId) {
        this.villageId = villageId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    // Getters and setters for new fields
    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
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

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public Date getOrderCreatedDate() {
        return orderCreatedDate;
    }

    public void setOrderCreatedDate(Date orderCreatedDate) {
        this.orderCreatedDate = orderCreatedDate;
    }

    public Integer getVillageID() {
        return villageId;
    }

    public void setVillageID(Integer villageId) {
        this.villageId = villageId;
    }

    @Override
    public String toString() {
        return "OrderDetail{" + "id=" + id + ", orderId=" + orderId + ", subOrderId=" + subOrderId + ", productId=" + productId + ", quantity=" + quantity + ", price=" + price + ", subtotal=" + subtotal + ", villageId=" + villageId + ", productName=" + productName + ", reviewStatus=" + reviewStatus + '}';
    }

 
}
