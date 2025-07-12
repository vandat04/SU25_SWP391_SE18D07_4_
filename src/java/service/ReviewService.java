/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.ReviewDAO;
import entity.CraftVillage.CraftReview;
import entity.Product.ProductReview;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.ArrayList;

/**
 *
 * @author ACER
 */
public class ReviewService implements IReviewService {

    private static final Logger LOGGER = Logger.getLogger(ReviewService.class.getName());
    ReviewDAO rDAO = new ReviewDAO();

    @Override
    public boolean addProductReview(ProductReview review) {
        try {
            // Validate input
            if (review == null || review.getUserID() <= 0 || review.getProductID() <= 0) {
                LOGGER.log(Level.WARNING, "Invalid review data provided");
                return false;
            }
            
            if (review.getRating() < 1 || review.getRating() > 5) {
                LOGGER.log(Level.WARNING, "Invalid rating: {0}. Must be between 1-5", review.getRating());
                return false;
            }
            
            if (review.getReviewText() == null || review.getReviewText().trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Review text cannot be empty");
                return false;
            }
            
            // Use new method that automatically updates averageRating and totalReviews
            return rDAO.addProductReview(review);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product review: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Add a product review with order validation
     * @param review The product review
     * @param orderID The order ID this review relates to
     * @return true if review was added successfully
     */
    public boolean addProductReviewFromOrder(ProductReview review, int orderID) {
        try {
            // Validate input
            if (review == null || review.getUserID() <= 0 || review.getProductID() <= 0 || orderID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid review data provided");
                return false;
            }
            
            if (review.getRating() < 1 || review.getRating() > 5) {
                LOGGER.log(Level.WARNING, "Invalid rating: {0}. Must be between 1-5", review.getRating());
                return false;
            }
            
            if (review.getReviewText() == null || review.getReviewText().trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Review text cannot be empty");
                return false;
            }
            
            // Use new method with order validation and automatic rating updates
            return rDAO.addProductReviewFromOrder(review, orderID);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product review from order: " + e.getMessage(), e);
            return false;
        }
    }

    @Override
    public boolean addVillageReview(CraftReview review) {
        try {
            // Validate input
            if (review == null || review.getUserID() <= 0 || review.getVillageID() <= 0) {
                LOGGER.log(Level.WARNING, "Invalid village review data provided");
                return false;
            }
            
            if (review.getRating() < 1 || review.getRating() > 5) {
                LOGGER.log(Level.WARNING, "Invalid rating: {0}. Must be between 1-5", review.getRating());
                return false;
            }
            
            if (review.getReviewText() == null || review.getReviewText().trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Review text cannot be empty");
                return false;
            }
            
            // Use existing method that already updates averageRating and totalReviews
            return rDAO.addVillageReview(review);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding village review: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Add a village review with ticket order validation
     * @param review The village review
     * @param orderID The ticket order ID this review relates to
     * @return true if review was added successfully
     */
    public boolean addVillageReviewFromOrder(CraftReview review, int orderID) {
        try {
            // Validate input
            if (review == null || review.getUserID() <= 0 || review.getVillageID() <= 0 || orderID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid village review data provided");
                return false;
            }
            
            if (review.getRating() < 1 || review.getRating() > 5) {
                LOGGER.log(Level.WARNING, "Invalid rating: {0}. Must be between 1-5", review.getRating());
                return false;
            }
            
            if (review.getReviewText() == null || review.getReviewText().trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Review text cannot be empty");
                return false;
            }
            
            // Use new method with order validation and automatic rating updates
            return rDAO.addVillageReviewFromOrder(review, orderID);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding village review from order: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Check if ticket order is eligible for review
     * @param orderID The ticket order ID to check
     * @return true if order is eligible for review
     */
    // public boolean isTicketOrderEligibleForReview(int villageID, int userID) {
    //     try {
    //         if (orderID <= 0) {
    //             LOGGER.log(Level.WARNING, "Invalid ticket order ID: {0}", orderID);
    //             return false;
    //         }
    //         return rDAO.isTicketOrderEligibleForReview(villageID, userID);
    //     } catch (Exception e) {
    //         LOGGER.log(Level.SEVERE, "Error checking ticket order eligibility: " + e.getMessage(), e);
    //         return false;
    //     }
    // }

    @Override
    public List<ProductReview> getProductReviews(int productId) {
        try {
            if (productId <= 0) {
                LOGGER.log(Level.WARNING, "Invalid product ID: {0}", productId);
                return null;
            }
            return rDAO.getAllProductReviewByAdmin(productId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting product reviews: " + e.getMessage(), e);
            return null;
        }
    }

    @Override
    public List<CraftReview> getVillageReviews(int villageId) {
        try {
            if (villageId <= 0) {
                LOGGER.log(Level.WARNING, "Invalid village ID: {0}", villageId);
                return null;
            }
            return rDAO.getAllVillageReviewByAdmin(villageId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting village reviews: " + e.getMessage(), e);
            return null;
        }
    }

    @Override
    public boolean respondToReview(int reviewId, String response, boolean isProductReview) {
        try {
            if (reviewId <= 0) {
                LOGGER.log(Level.WARNING, "Invalid review ID: {0}", reviewId);
                return false;
            }
            
            if (response == null || response.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Response text cannot be empty");
                return false;
            }
            
            if (isProductReview) {
                return rDAO.responseProductReviewByAdmin(reviewId, response);
            } else {
                return rDAO.responseVillageReviewByAdmin(reviewId, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error responding to review: " + e.getMessage(), e);
            return false;
        }
    }

    @Override
    public double getAverageProductRating(int productId) {
        try {
            if (productId <= 0) {
                LOGGER.log(Level.WARNING, "Invalid product ID: {0}", productId);
                return 0.0;
            }
            
            List<ProductReview> reviews = rDAO.getAllProductReviewByAdmin(productId);
            if (reviews == null || reviews.isEmpty()) {
                return 0.0;
            }
            
            double sum = 0.0;
            for (ProductReview review : reviews) {
                sum += review.getRating();
            }
            
            return sum / reviews.size();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error calculating average product rating: " + e.getMessage(), e);
            return 0.0;
        }
    }

    @Override
    public double getAverageVillageRating(int villageId) {
        try {
            if (villageId <= 0) {
                LOGGER.log(Level.WARNING, "Invalid village ID: {0}", villageId);
                return 0.0;
            }
            
            List<CraftReview> reviews = rDAO.getAllVillageReviewByAdmin(villageId);
            if (reviews == null || reviews.isEmpty()) {
                return 0.0;
            }
            
            double sum = 0.0;
            for (CraftReview review : reviews) {
                sum += review.getRating();
            }
            
            return sum / reviews.size();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error calculating average village rating: " + e.getMessage(), e);
            return 0.0;
        }
    }

    // NEW METHODS: Review eligibility checking
    @Override
    public boolean canUserReviewProduct(int userID, int productID, int orderID) {
        try {
            if (userID <= 0 || productID <= 0 || orderID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid parameters: userID={0}, productID={1}, orderID={2}", 
                          new Object[]{userID, productID, orderID});
                return false;
            }
            return rDAO.canUserReviewProduct(userID, productID, orderID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if user can review product: " + e.getMessage(), e);
            return false;
        }
    }

    @Override
    public boolean hasUserReviewedProduct(int userID, int productID, int orderID) {
        try {
            if (userID <= 0 || productID <= 0 || orderID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid parameters: userID={0}, productID={1}, orderID={2}", 
                          new Object[]{userID, productID, orderID});
                return false;
            }
            return rDAO.hasUserReviewedProduct(userID, productID, orderID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if user has reviewed product: " + e.getMessage(), e);
            return false;
        }
    }

    @Override
    public List<Integer> getReviewableProductsFromOrder(int userID, int orderID) {
        try {
            if (userID <= 0 || orderID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid parameters: userID={0}, orderID={1}", 
                          new Object[]{userID, orderID});
                return null;
            }
            return rDAO.getReviewableProductsFromOrder(userID, orderID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting reviewable products from order: " + e.getMessage(), e);
            return null;
        }
    }

    @Override
    public boolean isOrderEligibleForReview(int orderID) {
        try {
            if (orderID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid order ID: {0}", orderID);
                return false;
            }
            return rDAO.isOrderEligibleForReview(orderID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking order eligibility: " + e.getMessage(), e);
            return false;
        }
    }

    // Existing admin methods remain unchanged
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
    public List<CraftReview> searchVillageReviewToday(int villageID) {
        return rDAO.searchVillageReviewToday(villageID);
    }
    
    /**
     * Get all village reviews for a specific seller
     * @param sellerID The seller ID
     * @return List of village reviews for the seller's villages
     */
    public List<CraftReview> getAllVillageReviewsBySeller(int sellerID) {
        try {
            if (sellerID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid seller ID: {0}", sellerID);
                return new ArrayList<>();
            }
            return rDAO.getAllVillageReviewsBySeller(sellerID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting village reviews by seller: " + e.getMessage(), e);
            return new ArrayList<>();
        }
    }
    
    /**
     * Get all product reviews for a specific seller
     * @param sellerID The seller ID
     * @return List of product reviews for the seller's products
     */
    public List<ProductReview> getAllProductReviewsBySeller(int sellerID) {
        try {
            if (sellerID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid seller ID: {0}", sellerID);
                return new ArrayList<>();
            }
            return rDAO.getAllProductReviewsBySeller(sellerID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting product reviews by seller: " + e.getMessage(), e);
            return new ArrayList<>();
        }
    }
    
    /**
     * Get a village review by ID
     * @param reviewID The review ID
     * @return The village review or null if not found
     */
    public CraftReview getVillageReviewById(int reviewID) {
        try {
            if (reviewID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid review ID: {0}", reviewID);
                return null;
            }
            return rDAO.getVillageReviewById(reviewID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting village review by ID: " + e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * Get a product review by ID
     * @param reviewID The review ID
     * @return The product review or null if not found
     */
    public ProductReview getProductReviewById(int reviewID) {
        try {
            if (reviewID <= 0) {
                LOGGER.log(Level.WARNING, "Invalid review ID: {0}", reviewID);
                return null;
            }
            return rDAO.getProductReviewById(reviewID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting product review by ID: " + e.getMessage(), e);
            return null;
        }
    }

    @Override
    public List<ProductReview> searchProductReviewToday(int productID) {
        return rDAO.searchProductReviewToday(productID);
    }

    public boolean isTicketOrderEligibleForReview(int villageID, int userID) {
        return rDAO.isTicketOrderEligibleForReview(villageID, userID);
    }

    public boolean addVillageReviewFromTicket(int villageID, int userID, int rating, String content) {
        if (!isTicketOrderEligibleForReview(villageID, userID)) {
            return false;
        }
        return rDAO.addVillageReviewFromTicket(villageID, userID, rating, content);
    }

    public Integer getVillageIdByOrderId(int orderID) {
        return rDAO.getVillageIdByOrderId(orderID);
    }

    public Integer getProductIdByOrderId(int orderID) {
        return rDAO.getProductIdByOrderId(orderID);
    }

    public boolean isProductOrderEligibleForReview(int productID, int userID) {
        return rDAO.isProductOrderEligibleForReview(productID, userID);
    }
}
