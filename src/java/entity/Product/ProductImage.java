/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Product;

import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 *
 * @author ACER
 */
public class ProductImage {
    private int imageID;
    private int productID;
    private String imageUrl;
    private boolean isMain;
    private Timestamp createdDate;
    
    // Constructors-------------------------------------------------------------
    public ProductImage() {}

    //--------------------------------------------------------------------------
    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isIsMain() {
        return isMain;
    }

    public void setIsMain(boolean isMain) {
        this.isMain = isMain;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "ProductImage{" + "imageID=" + imageID + ", productID=" + productID + ", imageUrl=" + imageUrl + ", isMain=" + isMain + ", createdDate=" + createdDate + '}';
    }
    
}
