package DAO;

import context.DBContext;
import entity.CraftVillage.CraftReview;
import entity.Product.ProductReview;
import java.util.logging.Level;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;
import java.util.logging.Logger;

public class ReviewDAO {

    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());

    // Map dữ liệu từ ResultSet thành đối tượng CraftReview (cho làng nghề)
    private CraftReview mapResultSetToCraftReview(ResultSet rs) throws SQLException {
        return new CraftReview(
                rs.getInt("reviewID"),
                rs.getInt("villageID"),
                rs.getInt("userID"),
                rs.getInt("rating"),
                rs.getString("reviewText"),
                rs.getTimestamp("reviewDate"),
                rs.getString("response"),
                rs.getTimestamp("responseDate")
        );
    }

    // Map dữ liệu từ ResultSet thành đối tượng ProductReview (cho sản phẩm)
    private ProductReview mapResultSetToProductReview(ResultSet rs) throws SQLException {
        return new ProductReview(
                rs.getInt("reviewID"),
                rs.getInt("productID"),
                rs.getInt("userID"),
                rs.getInt("rating"),
                rs.getString("reviewText"),
                rs.getTimestamp("reviewDate"),
                rs.getString("response"),
                rs.getTimestamp("responseDate")
        );
    }

    // Đóng kết nối và tài nguyên JDBC
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy tất cả đánh giá sản phẩm theo productID
    public List<ProductReview> getAllProductReviewByAdmin(int productID) {
        String query = "SELECT * FROM ProductReview WHERE productID = ? ORDER BY reviewDate DESC";
        List<ProductReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, productID);

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProductReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    // Lấy tất cả đánh giá làng nghề theo villageID
    public List<CraftReview> getAllVillageReviewByAdmin(int villageID) {
        String query = "SELECT * FROM VillageReview WHERE villageID = ? ORDER BY reviewDate DESC";
        List<CraftReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, villageID);

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToCraftReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public boolean responseProductReviewByAdmin(int reviewID, String responseText) {
        String sql = "{call sp_ResponseProductReviewByAdmin(?, ?, ?)}"; // Không dùng ?= call
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, reviewID);
            cs.setString(2, responseText);
            cs.registerOutParameter(3, Types.INTEGER); // OUTPUT param @result

            cs.execute();

            int result = cs.getInt(3); // Lấy giá trị từ OUTPUT param
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error responding to review: " + e.getMessage(), e);
        }
        return false;
    }

    public boolean deleteProductReviewByAdmin(int reviewID) {
        String sql = "{call sp_DeleteProductReviewByAdmin(?, ?)}"; // 1 input, 1 output
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, reviewID);
            cs.registerOutParameter(2, Types.INTEGER); // @result

            cs.execute();

            int result = cs.getInt(2); // lấy kết quả từ OUTPUT
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting review: " + e.getMessage(), e);
        }
        return false;
    }

    public boolean responseVillageReviewByAdmin(int reviewID, String responseText) {
        String sql = "{call sp_ResponseVillageReviewByAdmin(?, ?, ?)}"; // Không dùng ?= call
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, reviewID);
            cs.setString(2, responseText);
            cs.registerOutParameter(3, Types.INTEGER); // OUTPUT param @result

            cs.execute();

            int result = cs.getInt(3); // Lấy giá trị từ OUTPUT param
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error responding to review: " + e.getMessage(), e);
        }
        return false;
    }

    public boolean deleteVillageReviewByAdmin(int reviewID) {
        String sql = "{call sp_DeleteVillageReviewByAdmin(?, ?)}"; // 1 input, 1 output
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, reviewID);
            cs.registerOutParameter(2, Types.INTEGER); // @result

            cs.execute();

            int result = cs.getInt(2); // lấy kết quả từ OUTPUT
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting review: " + e.getMessage(), e);
        }
        return false;
    }

    public List<ProductReview> searchProductReviewByAdmin(int userID) {
        String query = "SELECT * FROM ProductReview WHERE userID = ?";
        List<ProductReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userID); // Gán giá trị cho tham số ?
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProductReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log lỗi nếu cần
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<CraftReview> searchVillageReviewByAdmin(int userID) {
        String query = "SELECT * FROM VillageReview WHERE userID = ?";
        List<CraftReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userID); // Gán giá trị cho tham số ?
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToCraftReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log lỗi nếu cần
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<CraftReview> searchVillageReviewToday(int villageID) {
        String query = "SELECT * FROM VillageReview WHERE villageID = ? and  CAST(reviewDate AS DATE) = CAST(GETDATE() AS DATE)";
        List<CraftReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, villageID); // Gán giá trị cho tham số ?
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToCraftReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log nếu cần
        } finally {
            closeResources(conn, ps, rs);
        }

        return list;
    }

    public List<ProductReview> searchProductReviewToday(int productID) {
        String query = "SELECT * FROM ProductReview WHERE productID = ?  and CAST(reviewDate AS DATE) = CAST(GETDATE() AS DATE)";
        List<ProductReview> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
             ps.setInt(1, productID); 
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProductReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log nếu cần
        } finally {
            closeResources(conn, ps, rs);
        }

        return list;
    }
    
    public boolean addVillageReview(CraftReview review) {
    String sql = "{call sp_addVillageReview(?, ?, ?, ?, ?)}";

    try (Connection con = DBContext.getConnection();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, review.getVillageID());
        cs.setInt(2, review.getUserID());
        cs.setString(3, review.getReviewText());
        cs.setInt(4, review.getRating());
        cs.registerOutParameter(5, Types.INTEGER);

        cs.execute();

        int result = cs.getInt(5);
        return result == 1;

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    
    // Test thử
    public static void main(String[] args) {
        ReviewDAO dao = new ReviewDAO();
        System.out.println(dao.addVillageReview(new CraftReview(6, 1, 2, "Huhu")));
    }
}

