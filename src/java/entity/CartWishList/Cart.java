/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.CartWishList
        ;

import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 *
 * @author Pc
 */

public class Cart {
   private int cartID;
    private int userID;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    
     // Constructors------------------------------------------------------------
    public Cart() {
    }
    
    //--------------------------------------------------------------------------
    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
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
        return "Cart{" + "cartID=" + cartID + ", userID=" + userID + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + '}';
    }
}
