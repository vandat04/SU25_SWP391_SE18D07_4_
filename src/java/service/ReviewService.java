/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.ReviewDAO;
import entity.CraftVillage.CraftReview;
import entity.Product.ProductReview;
import java.util.List;

/**
 *
 * @author ACER
 */
public class ReviewService implements IReviewService {

    ReviewDAO rDAO = new ReviewDAO();

    @Override
    public boolean addProductReview(ProductReview review) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean addVillageReview(CraftReview review) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<ProductReview> getProductReviews(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftReview> getVillageReviews(int villageId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean respondToReview(int reviewId, String response, boolean isProductReview) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public double getAverageProductRating(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public double getAverageVillageRating(int villageId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftReview> getAllVillageReviewByAdmin(int villageID) {
        return rDAO.getAllVillageReviewByAdmin(villageID);
    }

    @Override
    public List<ProductReview> getAllProductReviewByAdmin(int productID) {
        return rDAO.getAllProductReviewByAdmin(productID);
    }

    public boolean responseProductReviewByAdmin(int reviewID, String responseText) {
        return rDAO.responseProductReviewByAdmin(reviewID, responseText);
    }

    public boolean responseVillageReviewByAdmin(int reviewID, String responseText) {
        return rDAO.responseVillageReviewByAdmin(reviewID, responseText);
    }

    public boolean deleteProductReviewByAdmin(int reviewID) {
        return rDAO.deleteProductReviewByAdmin(reviewID);
    }

    public boolean deleteVillageReviewByAdmin(int reviewID) {
        return rDAO.deleteVillageReviewByAdmin(reviewID);
    }

    @Override
    public List<ProductReview> searchProductReviewByAdmin(int userID) {
        return rDAO.searchProductReviewByAdmin(userID);
    }

    @Override
    public List<CraftReview> searchVillageReviewByAdmin(int userID) {
        return rDAO.searchVillageReviewByAdmin(userID);
    }

    @Override
    public List<ProductReview> searchProductReviewToday() {
        return rDAO.searchProductReviewToday();
    }

    @Override
    public List<CraftReview> searchVillageReviewToday() {
        return rDAO.searchVillageReviewToday();
    }
}
