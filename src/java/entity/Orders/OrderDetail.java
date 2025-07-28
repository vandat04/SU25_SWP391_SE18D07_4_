/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Orders;

import entity.Product.Product;
import java.math.BigDecimal;

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

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
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

    @Override
    public String toString() {
        return "OrderDetail{" + "id=" + id + ", orderId=" + orderId + ", subOrderId=" + subOrderId + ", productId=" + productId + ", quantity=" + quantity + ", price=" + price + ", subtotal=" + subtotal + ", villageId=" + villageId + ", productName=" + productName + ", reviewStatus=" + reviewStatus + '}';
    }

 
}
