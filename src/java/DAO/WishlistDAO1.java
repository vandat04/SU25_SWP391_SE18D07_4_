//package DAO;
//
//import static context.DBContext.getConnection;
//import entity.CartWishList.Wishlist;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class WishlistDAO1 {
//
//
//    private static final String SELECT_WISHLIST_BY_USER = 
//        "SELECT w.wishlistID, w.userID, w.productID, w.addedDate, p.name, p.img " +
//        "FROM Wishlist w " +
//        "JOIN Product p ON w.productID = p.pid " +
//        "WHERE w.userID = ?";
//
//
//
//public List<Wishlist> getWishlistByUser(int userID) {
//        List<Wishlist> wishlist = new ArrayList<>();
//        try (Connection connection = getConnection();
//             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_WISHLIST_BY_USER)) {
//            preparedStatement.setInt(1, userID);
//            ResultSet rs = preparedStatement.executeQuery();
//            while (rs.next()) {
//                int wishlistID = rs.getInt("wishlistID");
//                int productID = rs.getInt("productID");
//                Timestamp addedDate = rs.getTimestamp("addedDate");
//                String name = rs.getString("name"); // Lấy tên sản phẩm
//                String img = rs.getString("img");   // Lấy đường dẫn hình ảnh
//                Wishlist item = new Wishlist(wishlistID, userID, productID, addedDate, name, img);
//                wishlist.add(item);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return wishlist;
//    }
//
//    // Các phương thức khác như addToWishlist, removeFromWishlist giữ nguyên
//    public void addToWishlist(int userID, int productID) {
//        String INSERT_WISHLIST = "INSERT INTO Wishlist (userID, productID) VALUES (?, ?)";
//        try (Connection connection = getConnection();
//             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_WISHLIST)) {
//            preparedStatement.setInt(1, userID);
//            preparedStatement.setInt(2, productID);
//            preparedStatement.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//public boolean isProductInWishlist(int userId, int productId) {
//        String sql = "SELECT COUNT(*) FROM Wishlist WHERE userID = ? AND productID = ?";
//        try (Connection connection = getConnection();
//             PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ps.setInt(2, productId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt(1) > 0; // Trả về true nếu sản phẩm đã có trong wishlist
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//    public void removeFromWishlist(int wishlistID) {
//        String DELETE_WISHLIST = "DELETE FROM Wishlist WHERE wishlistID = ?";
//        try (Connection connection = getConnection();
//             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_WISHLIST)) {
//            preparedStatement.setInt(1, wishlistID);
//            preparedStatement.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//}
//
//
//
