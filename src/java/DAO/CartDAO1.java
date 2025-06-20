//package DAO;
//
//import context.DBContext;
//import entity.CartWishList.Cart;
//import entity.CartItem;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class CartDAO1 {
//    private static final Logger LOGGER = Logger.getLogger(CartDAO1.class.getName());
//
//    private static final String SELECT_CART_BY_USER = "SELECT c.*, ci.*, p.name as productName, p.price, p.imageUrl " +
//            "FROM Cart c " +
//            "LEFT JOIN CartItem ci ON c.cartID = ci.cartID " +
//            "LEFT JOIN Product p ON ci.productID = p.pid " +
//            "WHERE c.userID = ? AND c.status = 'active'";
//    private static final String INSERT_CART = "INSERT INTO Cart (userID, totalAmount, status, createdDate) VALUES (?, ?, ?, GETDATE())";
//    private static final String UPDATE_CART = "UPDATE Cart SET totalAmount = ?, status = ?, updatedDate = GETDATE() WHERE cartID = ?";
//    private static final String DELETE_CART = "UPDATE Cart SET status = 'inactive', updatedDate = GETDATE() WHERE cartID = ?";
//    private static final String INSERT_CART_ITEM = "INSERT INTO CartItem (cartID, productID, quantity) VALUES (?, ?, ?)";
//    private static final String UPDATE_CART_ITEM = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
//    private static final String DELETE_CART_ITEM = "DELETE FROM CartItem WHERE cartItemID = ?";
//    private static final String SELECT_CART_ITEM = "SELECT ci.*, p.name as productName, p.price, p.imageUrl " +
//            "FROM CartItem ci " +
//            "JOIN Product p ON ci.productID = p.pid " +
//            "WHERE ci.cartItemID = ?";
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
//    public Cart getCartByUser(int userId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        Cart cart = null;
//        List<CartItem> items = new ArrayList<>();
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_CART_BY_USER);
//            ps.setInt(1, userId);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                if (cart == null) {
//                    cart = new Cart(
//                        rs.getInt("cartID"),
//                        rs.getInt("userID"),
//                        items,
//                        rs.getDouble("totalAmount"),
//                        rs.getString("status"),
//                        rs.getTimestamp("createdDate"),
//                        rs.getTimestamp("updatedDate")
//                    );
//                }
//
//                if (rs.getInt("productID") > 0) {
//                    CartItem item = new CartItem(
//                        rs.getInt("cartItemID"),
//                        rs.getInt("cartID"),
//                        rs.getInt("productID"),
//                        rs.getString("productName"),
//                        rs.getDouble("price"),
//                        rs.getInt("quantity"),
//                        rs.getString("imageUrl")
//                    );
//                    items.add(item);
//                }
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting cart for user ID: " + userId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return cart;
//    }
//
//    public int createCart(Cart cart) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        int cartId = -1;
//
//        try {
//            conn = new DBContext().getConnection();
//            conn.setAutoCommit(false);
//
//            // Insert cart
//            ps = conn.prepareStatement(INSERT_CART, PreparedStatement.RETURN_GENERATED_KEYS);
//            ps.setInt(1, cart.getUserID());
//            ps.setDouble(2, cart.getTotalAmount());
//            ps.setString(3, cart.getStatus());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                rs = ps.getGeneratedKeys();
//                if (rs.next()) {
//                    cartId = rs.getInt(1);
//                    cart.setCartID(cartId);
//
//                    // Insert cart items
//                    if (!cart.getItems().isEmpty()) {
//                        ps = conn.prepareStatement(INSERT_CART_ITEM);
//                        for (CartItem item : cart.getItems()) {
//                            ps.setInt(1, cartId);
//                            ps.setInt(2, item.getProductID());
//                            ps.setInt(3, item.getQuantity());
//                            ps.addBatch();
//                        }
//                        ps.executeBatch();
//                    }
//                }
//            }
//
//            conn.commit();
//            LOGGER.log(Level.INFO, "Cart created successfully with ID: {0}", cartId);
//        } catch (Exception e) {
//            try {
//                if (conn != null) conn.rollback();
//            } catch (SQLException ex) {
//                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
//            }
//            LOGGER.log(Level.SEVERE, "Error creating cart", e);
//        } finally {
//            try {
//                if (conn != null) conn.setAutoCommit(true);
//            } catch (SQLException e) {
//                LOGGER.log(Level.SEVERE, "Error resetting auto-commit", e);
//            }
//            closeResources(conn, ps, rs);
//        }
//        return cartId;
//    }
//
//    public boolean updateCart(Cart cart) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            conn.setAutoCommit(false);
//
//            // Update cart total amount
//            String updateSql = "UPDATE Cart SET totalAmount = ?, status = ?, updatedDate = GETDATE() WHERE cartID = ?";
//            ps = conn.prepareStatement(updateSql);
//            ps.setDouble(1, cart.getTotalAmount());
//            ps.setString(2, cart.getStatus());
//            ps.setInt(3, cart.getCartID());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                conn.commit();
//                LOGGER.log(Level.INFO, "Cart updated successfully for ID: {0}", cart.getCartID());
//                return true;
//            } else {
//                conn.rollback();
//                LOGGER.log(Level.WARNING, "No cart found to update with ID: {0}", cart.getCartID());
//                return false;
//            }
//        } catch (Exception e) {
//            try {
//                if (conn != null) conn.rollback();
//            } catch (SQLException ex) {
//                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
//            }
//            LOGGER.log(Level.SEVERE, "Error updating cart with ID: " + cart.getCartID(), e);
//            return false;
//        } finally {
//            try {
//                if (conn != null) conn.setAutoCommit(true);
//            } catch (SQLException e) {
//                LOGGER.log(Level.SEVERE, "Error resetting auto-commit", e);
//            }
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean deleteCart(int cartId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(DELETE_CART);
//            ps.setInt(1, cartId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Cart deleted successfully for ID: {0}", cartId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No cart found to delete with ID: {0}", cartId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error deleting cart with ID: " + cartId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean addCartItem(CartItem item) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            conn.setAutoCommit(false);
//
//            // Check if item already exists
//            String checkSql = "SELECT cartItemID, quantity FROM CartItem WHERE cartID = ? AND productID = ?";
//            ps = conn.prepareStatement(checkSql);
//            ps.setInt(1, item.getCartID());
//            ps.setInt(2, item.getProductID());
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                // Item exists, update quantity
//                int existingId = rs.getInt("cartItemID");
//                int existingQty = rs.getInt("quantity");
//                String updateSql = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
//                ps = conn.prepareStatement(updateSql);
//                ps.setInt(1, existingQty + item.getQuantity());
//                ps.setInt(2, existingId);
//            } else {
//                // Item doesn't exist, insert new
//                String insertSql = "INSERT INTO CartItem (cartID, productID, quantity) VALUES (?, ?, ?)";
//                ps = conn.prepareStatement(insertSql);
//                ps.setInt(1, item.getCartID());
//                ps.setInt(2, item.getProductID());
//                ps.setInt(3, item.getQuantity());
//            }
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                conn.commit();
//                LOGGER.log(Level.INFO, "Cart item added/updated successfully for cart ID: {0}", item.getCartID());
//                return true;
//            } else {
//                conn.rollback();
//                LOGGER.log(Level.WARNING, "Failed to add/update cart item for cart ID: {0}", item.getCartID());
//                return false;
//            }
//        } catch (Exception e) {
//            try {
//                if (conn != null) conn.rollback();
//            } catch (SQLException ex) {
//                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
//            }
//            LOGGER.log(Level.SEVERE, "Error adding/updating cart item for cart ID: " + item.getCartID(), e);
//            return false;
//        } finally {
//            try {
//                if (conn != null) conn.setAutoCommit(true);
//            } catch (SQLException e) {
//                LOGGER.log(Level.SEVERE, "Error resetting auto-commit", e);
//            }
//            closeResources(conn, ps, rs);
//        }
//    }
//
//    public boolean updateCartItem(CartItem item) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_CART_ITEM);
//            ps.setInt(1, item.getQuantity());
//            ps.setInt(2, item.getCartItemID());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Cart item updated successfully for ID: {0}", item.getCartItemID());
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No cart item found to update with ID: {0}", item.getCartItemID());
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating cart item with ID: " + item.getCartItemID(), e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean deleteCartItem(int cartItemId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(DELETE_CART_ITEM);
//            ps.setInt(1, cartItemId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Cart item deleted successfully for ID: {0}", cartItemId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No cart item found to delete with ID: {0}", cartItemId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error deleting cart item with ID: " + cartItemId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public CartItem getCartItem(int cartItemId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_CART_ITEM);
//            ps.setInt(1, cartItemId);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return new CartItem(
//                    rs.getInt("cartItemID"),
//                    rs.getInt("cartID"),
//                    rs.getInt("productID"),
//                    rs.getString("productName"),
//                    rs.getDouble("price"),
//                    rs.getInt("quantity"),
//                    rs.getString("imageUrl")
//                );
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting cart item with ID: " + cartItemId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//} 