/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import entity.CraftVillage.CraftReview;
import entity.Product.ProductReview;
import java.util.List;

/**
 *
 * @author ACER
 */
public interface IReviewService {

    boolean addProductReview(ProductReview review);

    boolean addVillageReview(CraftReview review);

    List<ProductReview> getProductReviews(int productId);

    List<CraftReview> getVillageReviews(int villageId);

    boolean respondToReview(int reviewId, String response, boolean isProductReview);

    double getAverageProductRating(int productId);

    double getAverageVillageRating(int villageId);

    List<CraftReview> getAllVillageReviewByAdmin(int villageID);

    List<ProductReview> getAllProductReviewByAdmin(int productID);

    boolean responseProductReviewByAdmin(int reviewID, String responseText);

    boolean responseVillageReviewByAdmin(int reviewID, String responseText);

    boolean deleteProductReviewByAdmin(int reviewID);

    boolean deleteVillageReviewByAdmin(int reviewID);

    List<ProductReview> searchProductReviewByAdmin(int userID);

    List<CraftReview> searchVillageReviewByAdmin(int userID);

    List<CraftReview> searchVillageReviewToday(int villageID);

    List<ProductReview> searchProductReviewToday(int productID);
    
    // NEW METHODS: Check review eligibility and prevent duplicates
    boolean canUserReviewProduct(int userID, int productID, int orderID);
    boolean hasUserReviewedProduct(int userID, int productID, int orderID);
    List<Integer> getReviewableProductsFromOrder(int userID, int orderID);
    boolean isOrderEligibleForReview(int orderID);
    
    // NEW METHODS: Add reviews with order validation and automatic rating updates
    boolean addProductReviewFromOrder(ProductReview review, int orderID);
    boolean addVillageReviewFromOrder(CraftReview review, int orderID);
    boolean isTicketOrderEligibleForReview(int villageID, int userID);
    
    // NEW METHODS: Seller-specific review retrieval
    List<CraftReview> getAllVillageReviewsBySeller(int sellerID);
    List<ProductReview> getAllProductReviewsBySeller(int sellerID);
    
    // NEW METHODS: Individual review retrieval
    CraftReview getVillageReviewById(int reviewID);
    ProductReview getProductReviewById(int reviewID);
    
    // NEW METHODS: Order ID to entity ID mapping
    Integer getProductIdByOrderId(int orderID);
    Integer getVillageIdByOrderId(int orderID);
    
    // ENHANCED METHODS: Complete information retrieval for review display
    java.util.Map<String, Object> getCompleteProductInfo(int productID);
    java.util.Map<String, Object> getCompleteVillageInfo(int villageID);
    java.util.Map<String, Object> getCompleteTicketInfo(int ticketID);
    
    // ENHANCED METHODS: User reviewable items
    List<java.util.Map<String, Object>> getUserReviewableProducts(int userID);
    List<java.util.Map<String, Object>> getUserReviewableVillages(int userID);
    
    // ENHANCED METHODS: Updated validation with status=2 condition
    boolean canUserReviewProduct_v2(int userID, int productID, int orderID);
    boolean canUserReviewVillage_v2(int userID, int villageID, int orderID);
    boolean addProductReviewFromOrder_v2(ProductReview review, int orderID);
    boolean addVillageReviewFromOrder_v2(CraftReview review, int orderID);
}
