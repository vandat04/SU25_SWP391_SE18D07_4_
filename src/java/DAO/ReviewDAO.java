package DAO;

import context.DBContext;
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
import entity.CraftVillage.CraftReview;

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

        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

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
    // NEW METHODS: Review eligibility checking

    /**
     * Check if order is eligible for review (delivered + paid)
     *
     * @param orderID The order ID to check
     * @return true if order status=1 (delivered) AND paymentStatus=1 (paid)
     */
    public boolean isOrderEligibleForReview(int orderID) {
        String query = "SELECT COUNT(*) FROM Orders WHERE id = ? AND status = 1 AND paymentStatus = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking order eligibility: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    /**
     * Check if user has already reviewed a specific product in a specific order
     *
     * @param userID The user ID
     * @param productID The product ID
     * @param orderID The order ID
     * @return true if user has already reviewed this product from this order
     */
    public boolean hasUserReviewedProduct(int userID, int productID, int orderID) {
        String query = "SELECT COUNT(*) FROM ProductReview pr "
                + "WHERE pr.userID = ? AND pr.productID = ? "
                + "AND EXISTS (SELECT 1 FROM OrderDetail od WHERE od.product_id = ? AND od.order_id = ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userID);
            ps.setInt(2, productID);
            ps.setInt(3, productID);
            ps.setInt(4, orderID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user reviewed product: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    /**
     * Get all products from an order that user can review
     *
     * @param userID The user ID
     * @param orderID The order ID
     * @return List of product IDs that can be reviewed
     */
    public List<Integer> getReviewableProductsFromOrder(int userID, int orderID) {
        List<Integer> reviewableProducts = new ArrayList<>();

        // First check if order is eligible for review
        if (!isOrderEligibleForReview(orderID)) {
            return reviewableProducts; // Empty list
        }

        String query = "SELECT DISTINCT od.product_id FROM OrderDetail od "
                + "JOIN Orders o ON od.order_id = o.id "
                + "WHERE o.id = ? AND o.userID = ? "
                + "AND NOT EXISTS (SELECT 1 FROM ProductReview pr WHERE pr.userID = ? AND pr.productID = od.product_id)";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderID);
            ps.setInt(2, userID);
            ps.setInt(3, userID);
            rs = ps.executeQuery();

            while (rs.next()) {
                reviewableProducts.add(rs.getInt("product_id"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting reviewable products: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return reviewableProducts;
    }

    /**
     * Check if user can review a specific product from a specific order
     *
     * @param userID The user ID
     * @param productID The product ID
     * @param orderID The order ID
     * @return true if user can review this product
     */
    public boolean canUserReviewProduct(int userID, int productID, int orderID) {
        // Check order eligibility first
        if (!isOrderEligibleForReview(orderID)) {
            return false;
        }

        // Check if user hasn't already reviewed this product
        if (hasUserReviewedProduct(userID, productID, orderID)) {
            return false;
        }

        // Check if this product exists in this order for this user
        String query = "SELECT COUNT(*) FROM OrderDetail od "
                + "JOIN Orders o ON od.order_id = o.id "
                + "WHERE o.id = ? AND o.userID = ? AND od.product_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, orderID);
            ps.setInt(2, userID);
            ps.setInt(3, productID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user can review product: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return false;
    }

    /**
     * Add a product review with order validation
     *
     * @param review The product review
     * @param orderID The order ID this review relates to
     * @return true if review was added successfully
     */
    public boolean addProductReviewFromOrder(ProductReview review, int orderID) {
        // Validate that user can review this product from this order
        if (!canUserReviewProduct(review.getUserID(), review.getProductID(), orderID)) {
            LOGGER.log(Level.WARNING, "User {0} cannot review product {1} from order {2}",
                    new Object[]{review.getUserID(), review.getProductID(), orderID});
            return false;
        }

        // Use stored procedure to add review with order validation
        String sql = "{call sp_addProductReviewWithOrderValidation(?, ?, ?, ?, ?, ?)}";

        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, review.getProductID());
            cs.setInt(2, review.getUserID());
            cs.setInt(3, orderID);
            cs.setString(4, review.getReviewText());
            cs.setInt(5, review.getRating());
            cs.registerOutParameter(6, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(6);
            if (result == 1) {
                return true;
            } else if (result == -1) {
                LOGGER.log(Level.WARNING, "Order {0} is not eligible for review", orderID);
                return false;
            } else if (result == -2) {
                LOGGER.log(Level.WARNING, "User {0} has already reviewed product {1}",
                        new Object[]{review.getUserID(), review.getProductID()});
                return false;
            } else {
                LOGGER.log(Level.WARNING, "Failed to add product review, result code: {0}", result);
                return false;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product review: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Add a simple product review without order validation
     *
     * @param review The product review
     * @return true if review was added successfully
     */
    public boolean addProductReview(ProductReview review) {
        String sql = "{call sp_addProductReview(?, ?, ?, ?, ?)}";

        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, review.getProductID());
            cs.setInt(2, review.getUserID());
            cs.setString(3, review.getReviewText());
            cs.setInt(4, review.getRating());
            cs.registerOutParameter(5, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(5);
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product review: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Add a village review with ticket order validation
     *
     * @param review The village review
     * @param orderID The ticket order ID this review relates to
     * @return true if review was added successfully
     */
    public boolean addVillageReviewFromOrder(CraftReview review, int orderID) {
        String sql = "{call sp_addVillageReviewWithOrderValidation(?, ?, ?, ?, ?, ?)}";

        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, review.getVillageID());
            cs.setInt(2, review.getUserID());
            cs.setInt(3, orderID);
            cs.setString(4, review.getReviewText());
            cs.setInt(5, review.getRating());
            cs.registerOutParameter(6, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(6);
            if (result == 1) {
                return true;
            } else if (result == -1) {
                LOGGER.log(Level.WARNING, "Ticket order {0} is not eligible for review", orderID);
                return false;
            } else if (result == -2) {
                LOGGER.log(Level.WARNING, "User {0} has already reviewed village {1}",
                        new Object[]{review.getUserID(), review.getVillageID()});
                return false;
            } else {
                LOGGER.log(Level.WARNING, "Failed to add village review, result code: {0}", result);
                return false;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding village review: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Check if ticket order is eligible for review (delivered + paid)
     *
     * @param orderID The ticket order ID to check
     * @return true if order status=1 (delivered) AND paymentStatus=1 (paid)
     */
    public boolean isTicketOrderEligibleForReview(int villageID, int userID) {
        String sql = "SELECT COUNT(*) FROM TicketOrder WHERE userID = ? AND villageID = ? AND status = 1 AND paymentStatus = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, villageID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm review làng nghề từ ticket
     *
     * @param villageID The village ID
     * @param userID The user ID
     * @param rating The rating
     * @param content The review text
     * @return true if review was added successfully
     */
    public boolean addVillageReviewFromTicket(int villageID, int userID, int rating, String content) {
        String sql = "INSERT INTO VillageReview (villageID, userID, rating, reviewText, reviewDate) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, villageID);
            ps.setInt(2, userID);
            ps.setInt(3, rating);
            ps.setString(4, content);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all village reviews for a specific seller
     *
     * @param sellerID The seller ID
     * @return List of village reviews for the seller's villages
     */
    public List<CraftReview> getAllVillageReviewsBySeller(int sellerID) {
        List<CraftReview> list = new ArrayList<>();
        String query = "SELECT vr.* FROM VillageReview vr "
                + "JOIN CraftVillage cv ON vr.villageID = cv.villageID "
                + "WHERE cv.sellerId = ? AND cv.status = 1 "
                + "ORDER BY vr.reviewDate DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, sellerID);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToCraftReview(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting village reviews by seller: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return list;
    }

    /**
     * Get all product reviews for a specific seller
     *
     * @param sellerID The seller ID
     * @return List of product reviews for the seller's products
     */
    public List<ProductReview> getAllProductReviewsBySeller(int sellerID) {
        List<ProductReview> list = new ArrayList<>();
        String query = "SELECT pr.* FROM ProductReview pr "
                + "JOIN Product p ON pr.productID = p.pid "
                + "JOIN CraftVillage cv ON p.villageID = cv.villageID "
                + "WHERE cv.sellerId = ? AND cv.status = 1 AND p.status = 1 "
                + "ORDER BY pr.reviewDate DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, sellerID);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProductReview(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting product reviews by seller: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return list;
    }

    /**
     * Get a village review by ID
     *
     * @param reviewID The review ID
     * @return The village review or null if not found
     */
    public CraftReview getVillageReviewById(int reviewID) {
        String query = "SELECT * FROM VillageReview WHERE reviewID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, reviewID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToCraftReview(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting village review by ID: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return null;
    }

    /**
     * Get a product review by ID
     *
     * @param reviewID The review ID
     * @return The product review or null if not found
     */
    public ProductReview getProductReviewById(int reviewID) {
        String query = "SELECT * FROM ProductReview WHERE reviewID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, reviewID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToProductReview(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting product review by ID: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }

        return null;
    }

    // Lấy productID từ orderID
    public Integer getProductIdByOrderId(int orderID) {
        String sql = "SELECT productID FROM Orders WHERE orderID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("productID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra điều kiện review cho product
    public boolean isProductOrderEligibleForReview(int productID, int userID) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE userID = ? AND productID = ? AND status = 1 AND paymentStatus = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        ReviewDAO dao = new ReviewDAO();
        System.out.println(new ReviewDAO().getVillageIdByOrderId(79));
    }

    public Integer getVillageIdByOrderId(int orderID) {
        String sql = "SELECT villageID FROM Orders WHERE orderID = ? ";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
