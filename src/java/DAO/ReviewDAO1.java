//package DAO;
//
//import context.DBContext;
//import entity.Review;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Timestamp;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class ReviewDAO1 {
//    private static final Logger LOGGER = Logger.getLogger(ReviewDAO1.class.getName());
//
//    private static final String SELECT_ALL_REVIEWS = "SELECT r.*, p.name as productName, u.username, u.avatar as userAvatar " +
//            "FROM Review r JOIN Product p ON r.productId = p.productId " +
//            "JOIN [User] u ON r.userId = u.userId WHERE r.status = 1";
//    private static final String SELECT_REVIEW_BY_ID = "SELECT r.*, p.name as productName, u.username, u.avatar as userAvatar " +
//            "FROM Review r JOIN Product p ON r.productId = p.productId " +
//            "JOIN [User] u ON r.userId = u.userId WHERE r.reviewId = ?";
//    private static final String SELECT_REVIEWS_BY_PRODUCT = "SELECT r.*, p.name as productName, u.username, u.avatar as userAvatar " +
//            "FROM Review r JOIN Product p ON r.productId = p.productId " +
//            "JOIN [User] u ON r.userId = u.userId WHERE r.productId = ? AND r.status = 1";
//    private static final String SELECT_REVIEWS_BY_USER = "SELECT r.*, p.name as productName, u.username, u.avatar as userAvatar " +
//            "FROM Review r JOIN Product p ON r.productId = p.productId " +
//            "JOIN [User] u ON r.userId = u.userId WHERE r.userId = ? AND r.status = 1";
//    private static final String INSERT_REVIEW = "INSERT INTO Review (productId, userId, rating, comment, imageUrl, " +
//            "status, createdDate) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
//    private static final String UPDATE_REVIEW = "UPDATE Review SET rating = ?, comment = ?, imageUrl = ?, " +
//            "status = ?, updatedDate = GETDATE() WHERE reviewId = ?";
//    private static final String DELETE_REVIEW = "UPDATE Review SET status = 0, updatedDate = GETDATE() WHERE reviewId = ?";
//    private static final String GET_PRODUCT_AVERAGE_RATING = "SELECT AVG(CAST(rating AS FLOAT)) as averageRating " +
//            "FROM Review WHERE productId = ? AND status = 1";
//
//    // Helper method to close resources
//    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
//        try {
//            if (rs != null) rs.close();
//            if (ps != null) ps.close();
//            if (conn != null) conn.close();
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
//        }
//    }
//
//    public List<Review> getAllReviews() {
//        List<Review> reviews = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_ALL_REVIEWS);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                reviews.add(mapResultSetToReview(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all reviews", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return reviews;
//    }
//
//    public Review getReviewById(int reviewId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_REVIEW_BY_ID);
//            ps.setInt(1, reviewId);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return mapResultSetToReview(rs);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting review with ID: " + reviewId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    public List<Review> getReviewsByProduct(int productId) {
//        List<Review> reviews = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_REVIEWS_BY_PRODUCT);
//            ps.setInt(1, productId);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                reviews.add(mapResultSetToReview(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting reviews for product ID: " + productId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return reviews;
//    }
//
//    public List<Review> getReviewsByUser(int userId) {
//        List<Review> reviews = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_REVIEWS_BY_USER);
//            ps.setInt(1, userId);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                reviews.add(mapResultSetToReview(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting reviews for user ID: " + userId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return reviews;
//    }
//
//    public int addReview(Review review) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        int reviewId = -1;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(INSERT_REVIEW, PreparedStatement.RETURN_GENERATED_KEYS);
//            ps.setInt(1, review.getProductId());
//            ps.setInt(2, review.getUserId());
//            ps.setInt(3, review.getRating());
//            ps.setString(4, review.getComment());
//            ps.setString(5, review.getImageUrl());
//            ps.setInt(6, review.getStatus());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                rs = ps.getGeneratedKeys();
//                if (rs.next()) {
//                    reviewId = rs.getInt(1);
//                    LOGGER.log(Level.INFO, "Review added successfully with ID: {0}", reviewId);
//                }
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error adding review", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return reviewId;
//    }
//
//    public boolean updateReview(Review review) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_REVIEW);
//            ps.setInt(1, review.getRating());
//            ps.setString(2, review.getComment());
//            ps.setString(3, review.getImageUrl());
//            ps.setInt(4, review.getStatus());
//            ps.setInt(5, review.getReviewId());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Review updated successfully for ID: {0}", review.getReviewId());
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No review found to update with ID: {0}", review.getReviewId());
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating review with ID: " + review.getReviewId(), e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean deleteReview(int reviewId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(DELETE_REVIEW);
//            ps.setInt(1, reviewId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Review deleted successfully for ID: {0}", reviewId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No review found to delete with ID: {0}", reviewId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error deleting review with ID: " + reviewId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public double getProductAverageRating(int productId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(GET_PRODUCT_AVERAGE_RATING);
//            ps.setInt(1, productId);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return rs.getDouble("averageRating");
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting average rating for product ID: " + productId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return 0.0;
//    }
//
//    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
//        return new Review(
//            rs.getInt("reviewId"),
//            rs.getInt("productId"),
//            rs.getString("productName"),
//            rs.getInt("userId"),
//            rs.getString("username"),
//            rs.getString("userAvatar"),
//            rs.getInt("rating"),
//            rs.getString("comment"),
//            rs.getString("imageUrl"),
//            rs.getInt("status"),
//            rs.getTimestamp("createdDate"),
//            rs.getTimestamp("updatedDate")
//        );
//    }
//
//    // Stub cho tương thích code cũ
//    public java.util.List<entity.ProductReview> getReviewsByProductId(int productId) { return new java.util.ArrayList<>(); }
//    public double getAverageRating(int productId) { return 0.0; }
//    public int getReviewCount(int productId) { return 0; }
//    public int[] getRatingDistribution(int productId) { return new int[5]; }
//}