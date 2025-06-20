//package DAO;
//
//import context.DBContext;
//import entity.User;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class UserDAO1 {
//    private static final Logger LOGGER = Logger.getLogger(UserDAO1.class.getName());
//
//    private static final String SELECT_ALL_USERS = "SELECT * FROM [User] WHERE status = 1";
//    private static final String SELECT_USER_BY_ID = "SELECT * FROM [User] WHERE userId = ?";
//    private static final String SELECT_USER_BY_USERNAME = "SELECT * FROM [User] WHERE username = ?";
//    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM [User] WHERE email = ?";
//    private static final String INSERT_USER = "INSERT INTO [User] (username, password, email, fullName, phoneNumber, " +
//            "address, avatar, role, status, createdDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
//    private static final String UPDATE_USER = "UPDATE [User] SET email = ?, fullName = ?, phoneNumber = ?, " +
//            "address = ?, avatar = ?, role = ?, status = ?, updatedDate = GETDATE() WHERE userId = ?";
//    private static final String UPDATE_PASSWORD = "UPDATE [User] SET password = ?, updatedDate = GETDATE() WHERE userId = ?";
//    private static final String DELETE_USER = "UPDATE [User] SET status = 0, updatedDate = GETDATE() WHERE userId = ?";
//    private static final String UPDATE_LAST_LOGIN = "UPDATE [User] SET lastLogin = GETDATE() WHERE userId = ?";
//    private static final String SEARCH_USERS = "SELECT * FROM [User] WHERE status = 1 AND (username LIKE ? OR " +
//            "email LIKE ? OR fullName LIKE ? OR phoneNumber LIKE ?)";
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
//    public List<User> getAllUsers() {
//        List<User> users = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_ALL_USERS);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                users.add(mapResultSetToUser(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all users", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return users;
//    }
//
//    public User getUserById(int userId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_USER_BY_ID);
//            ps.setInt(1, userId);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return mapResultSetToUser(rs);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting user with ID: " + userId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    public User getUserByUsername(String username) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_USER_BY_USERNAME);
//            ps.setString(1, username);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return mapResultSetToUser(rs);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting user with username: " + username, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    public User getUserByEmail(String email) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_USER_BY_EMAIL);
//            ps.setString(1, email);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return mapResultSetToUser(rs);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting user with email: " + email, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    public int addUser(User user) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        int userId = -1;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(INSERT_USER, PreparedStatement.RETURN_GENERATED_KEYS);
//            ps.setString(1, user.getUsername());
//            ps.setString(2, user.getPassword());
//            ps.setString(3, user.getEmail());
//            ps.setString(4, user.getFullName());
//            ps.setString(5, user.getPhoneNumber());
//            ps.setString(6, user.getAddress());
//            ps.setString(7, user.getAvatar());
//            ps.setInt(8, user.getRole());
//            ps.setInt(9, user.getStatus());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                rs = ps.getGeneratedKeys();
//                if (rs.next()) {
//                    userId = rs.getInt(1);
//                    LOGGER.log(Level.INFO, "User added successfully with ID: {0}", userId);
//                }
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error adding user", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return userId;
//    }
//
//    public boolean updateUser(User user) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_USER);
//            ps.setString(1, user.getEmail());
//            ps.setString(2, user.getFullName());
//            ps.setString(3, user.getPhoneNumber());
//            ps.setString(4, user.getAddress());
//            ps.setString(5, user.getAvatar());
//            ps.setInt(6, user.getRole());
//            ps.setInt(7, user.getStatus());
//            ps.setInt(8, user.getUserId());
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "User updated successfully for ID: {0}", user.getUserId());
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No user found to update with ID: {0}", user.getUserId());
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating user with ID: " + user.getUserId(), e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean updatePassword(int userId, String newPassword) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_PASSWORD);
//            ps.setString(1, newPassword);
//            ps.setInt(2, userId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Password updated successfully for user ID: {0}", userId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No user found to update password with ID: {0}", userId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating password for user ID: " + userId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean deleteUser(int userId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(DELETE_USER);
//            ps.setInt(1, userId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "User deleted successfully for ID: {0}", userId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No user found to delete with ID: {0}", userId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error deleting user with ID: " + userId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean updateLastLogin(int userId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_LAST_LOGIN);
//            ps.setInt(1, userId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Last login updated successfully for user ID: {0}", userId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No user found to update last login with ID: {0}", userId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating last login for user ID: " + userId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public List<User> searchUsers(String keyword) {
//        List<User> users = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SEARCH_USERS);
//            String searchPattern = "%" + keyword + "%";
//            ps.setString(1, searchPattern);
//            ps.setString(2, searchPattern);
//            ps.setString(3, searchPattern);
//            ps.setString(4, searchPattern);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                users.add(mapResultSetToUser(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error searching users with keyword: " + keyword, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return users;
//    }
//
//    private User mapResultSetToUser(ResultSet rs) throws SQLException {
//        return new User(
//            rs.getInt("userId"),
//            rs.getString("username"),
//            rs.getString("password"),
//            rs.getString("email"),
//            rs.getString("fullName"),
//            rs.getString("phoneNumber"),
//            rs.getString("address"),
//            rs.getString("avatar"),
//            rs.getInt("role"),
//            rs.getInt("status"),
//            rs.getTimestamp("createdDate"),
//            rs.getTimestamp("updatedDate"),
//            rs.getTimestamp("lastLogin")
//        );
//    }
//} 