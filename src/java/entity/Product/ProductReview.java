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
public class ProductReview {
    private int reviewID;
    private int productID;
    private int userID;
    private int rating;
    private String reviewText;
    private Timestamp reviewDate;
    private String response;
    private Timestamp responseDate;
    private String userName; // Thêm thuộc tính userName
    
    // Constructors-------------------------------------------------------------
    public ProductReview() {}

    public ProductReview(int reviewID, int productID, int userID, int rating, String reviewText, Timestamp reviewDate, String response, Timestamp responseDate) {
        this.reviewID = reviewID;
        this.productID = productID;
        this.userID = userID;
        this.rating = rating;
        this.reviewText = reviewText;
        this.reviewDate = reviewDate;
        this.response = response;
        this.responseDate = responseDate;
    }

    public ProductReview(int productID, int userID, int rating, String reviewText) {
        this.productID = productID;
        this.userID = userID;
        this.rating = rating;
        this.reviewText = reviewText;
    }
    
    
    //--------------------------------------------------------------------------
    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public Timestamp getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Timestamp responseDate) {
        this.responseDate = responseDate;
    }

    // Thêm getter và setter cho userName
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "ProductReview{" + "reviewID=" + reviewID + ", productID=" + productID + ", userID=" + userID + ", rating=" + rating + ", reviewText=" + reviewText + ", reviewDate=" + reviewDate + ", response=" + response + ", responseDate=" + responseDate + ", userName=" + userName + '}';
    }
    
}
