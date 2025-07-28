package DAO;

import context.DBContext;
import entity.Product.ProductReview;
import entity.CraftVillage.CraftReview;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeedbackDAO {
    private static final Logger LOGGER = Logger.getLogger(FeedbackDAO.class.getName());

    public List<CraftReview> getTop1000VillageReviews() {
        List<CraftReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = "SELECT TOP (1000) [reviewID], [villageID], [userID], [rating], " +
                       "[reviewText], [reviewDate], [response], [responseDate] " +
                       "FROM [CraftDB].[dbo].[VillageReview] ORDER BY [reviewDate] DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                CraftReview vr = new CraftReview();
                vr.setReviewID(rs.getInt("reviewID"));
                vr.setVillageID(rs.getInt("villageID"));
                vr.setUserID(rs.getInt("userID"));
                vr.setRating(rs.getInt("rating"));
                vr.setReviewText(rs.getString("reviewText"));
                vr.setReviewDate(rs.getTimestamp("reviewDate"));
                vr.setResponse(rs.getString("response"));
                vr.setResponseDate(rs.getTimestamp("responseDate"));
                list.add(vr);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception in getTop1000VillageReviews.", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "General Exception in getTop1000VillageReviews.", e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public boolean deleteVillageReview(int reviewID) {
        Connection conn = null;
        PreparedStatement ps = null;
        String query = "DELETE FROM [CraftDB].[dbo].[VillageReview] WHERE [reviewID] = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, reviewID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception in deleteVillageReview for reviewID: " + reviewID, e);
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "General Exception in deleteVillageReview for reviewID: " + reviewID, e);
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public boolean respondVillageReview(int reviewID, String responseText) {
        Connection conn = null;
        PreparedStatement ps = null;
        String query = "UPDATE [CraftDB].[dbo].[VillageReview] SET [response] = ?, [responseDate] = GETDATE() WHERE [reviewID] = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, responseText);
            ps.setInt(2, reviewID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception in respondVillageReview for reviewID: " + reviewID, e);
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "General Exception in respondVillageReview for reviewID: " + reviewID, e);
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public List<ProductReview> getTop1000ProductReviews() {
        List<ProductReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = "SELECT TOP (1000) [reviewID], [productID], [userID], [rating], " +
                       "[reviewText], [reviewDate], [response], [responseDate] " +
                       "FROM [CraftDB].[dbo].[ProductReview] ORDER BY [reviewDate] DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductReview pr = new ProductReview();
                pr.setReviewID(rs.getInt("reviewID"));
                pr.setProductID(rs.getInt("productID"));
                pr.setUserID(rs.getInt("userID"));
                pr.setRating(rs.getInt("rating"));
                pr.setReviewText(rs.getString("reviewText"));
                pr.setReviewDate(rs.getTimestamp("reviewDate"));
                pr.setResponse(rs.getString("response"));
                pr.setResponseDate(rs.getTimestamp("responseDate"));
                list.add(pr);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception in getTop1000ProductReviews.", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "General Exception in getTop1000ProductReviews.", e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public boolean deleteProductReview(int reviewID) {
        Connection conn = null;
        PreparedStatement ps = null;
        String query = "DELETE FROM [CraftDB].[dbo].[ProductReview] WHERE [reviewID] = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, reviewID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception in deleteProductReview for reviewID: " + reviewID, e);
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "General Exception in deleteProductReview for reviewID: " + reviewID, e);
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public boolean respondProductReview(int reviewID, String responseText) {
        Connection conn = null;
        PreparedStatement ps = null;
        String query = "UPDATE [CraftDB].[dbo].[ProductReview] SET [response] = ?, [responseDate] = GETDATE() WHERE [reviewID] = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, responseText);
            ps.setInt(2, reviewID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception in respondProductReview for reviewID: " + reviewID, e);
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "General Exception in respondProductReview for reviewID: " + reviewID, e);
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error closing database resources.", e);
        }
    }
}