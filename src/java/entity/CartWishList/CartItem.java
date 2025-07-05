/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.CartWishList;

import java.sql.Timestamp;

/**
 *
 * @author ACER
 */
public class CartItem {
    private int itemID;
    private int cartID;
    private int productID;
    private int quantity;
    private Timestamp createdDate;
    private Timestamp updatedDate;

    // Constructors-------------------------------------------------------------
    public CartItem() {}
    
    //--------------------------------------------------------------------------
    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    @Override
    public String toString() {
        return "CartItem{" + "itemID=" + itemID + ", cartID=" + cartID + ", productID=" + productID + ", quantity=" + quantity + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + '}';
    }
}
