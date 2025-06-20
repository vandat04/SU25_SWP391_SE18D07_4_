//package DAO;
//
//import context.DBContext;
//import entity.Account.Account;
//import java.sql.CallableStatement;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class AccountDAO1 {
//
//    private static final Logger LOGGER = Logger.getLogger(AccountDAO1.class.getName());
//
//    // Helper method to close connections
//    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
//        try {
//            if (rs != null) {
//                rs.close();
//            }
//            if (ps != null) {
//                ps.close();
//            }
//            if (conn != null) {
//                conn.close();
//            }
//        } catch (SQLException e) {
//            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
//        }
//    }
//
//    public int findUserIdByUsernameOrEmail(String input) {
//        String query = "SELECT userID FROM Account WHERE userName = ? OR email = ?";
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
//
//            ps.setString(1, input);
//            ps.setString(2, input);
//
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt("userID");
//            }
//
//        } catch (Exception e) {
//            return -1; // Return -1 if error occurs
//        }
//        return 0; // Return 0 if not found
//    }
//
//    public String getEmailByUserId(int userId) {
//        String query = "SELECT email FROM Account WHERE userID = ?";
//        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
//
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return rs.getString("email");
//            }
//
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting email for user ID: " + userId, e);
//        }
//        return null;
//    }
//
//    public boolean changePasswordByUserId(int userId, String newPassword) {
//        String query = "{CALL ChangePassword(?, ?)}";
//
//        try (Connection conn = new DBContext().getConnection(); CallableStatement cs = conn.prepareCall(query)) {
//
//            cs.setInt(1, userId);
//            cs.setString(2, newPassword);
//
//            return cs.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error changing password for userID: " + userId, e);
//            return false;
//        }
//    }
//
//    public Account loginByEmail(String email) {
//        String query = "{CALL LoginByEmail(?)}";
//        Connection conn = null;
//        CallableStatement cs = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            cs = conn.prepareCall(query);
//            cs.setString(1, email);
//            rs = cs.executeQuery();
//
//            if (rs.next()) {
//                return new Account(
//                        rs.getInt("userID"),
//                        rs.getString("userName"),
//                        "********",
//                        rs.getString("email"),
//                        rs.getString("address"),
//                        rs.getString("phoneNumber"),
//                        rs.getInt("roleID"),
//                        rs.getInt("status"),
//                        rs.getString("createdDate"),
//                        rs.getString("updatedDate")
//                );
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error during loginByEmail for email: " + email, e);
//        } finally {
//            closeResources(conn, cs, rs);
//        }
//        return null;
//    }
//
//    public boolean updateRole(int userID, String roleName) {
//        String query = "UPDATE Account SET roleName = ? WHERE userID = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setString(1, roleName);
//            ps.setInt(2, userID);
//
//            int rowsAffected = ps.executeUpdate();
//            return rowsAffected > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating role for account ID: " + userID, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public Account login(String user, String pass) {
//        String query = "{CALL LoginAccount(?, ?)}";
//        Connection conn = null;
//        CallableStatement cs = null;
//        ResultSet rs = null;
//
//        try {
//            LOGGER.log(Level.INFO, "Attempting login for: {0}", user);
//
//            conn = new DBContext().getConnection();
//            cs = conn.prepareCall(query);
//            cs.setString(1, user);
//            cs.setString(2, pass);
//
//            rs = cs.executeQuery();
//
//            if (rs.next()) {
//                LOGGER.log(Level.INFO, "Login successful for user: {0}", user);
//                return new Account(
//                        rs.getInt("userID"),
//                        rs.getString("userName"),
//                        "********",
//                        rs.getString("email"),
//                        rs.getString("address"),
//                        rs.getString("phoneNumber"),
//                        rs.getInt("roleID"),
//                        rs.getInt("status"),
//                        rs.getString("createdDate"),
//                        rs.getString("updatedDate")
//                );
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error during login for user: " + user, e);
//        } finally {
//            if (cs != null) {
//                try {
//                    cs.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing CallableStatement", e);
//                }
//            }
//            closeResources(conn, null, rs);
//        }
//        return null;
//    }
//
//    public boolean checkAccountExists(String email) {
//        String query = "SELECT COUNT(*) FROM Account WHERE email = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setString(1, email);
//            rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt(1) > 0;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error checking if account exists with email: " + email, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return false;
//    }
//
//    public boolean registerAccount(Account account) {
//        String query = "{CALL RegisterAccount(?, ?, ?, ?, ?, ?, ?)}";
//        Connection conn = null;
//        CallableStatement cs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            cs = conn.prepareCall(query);
//
//            cs.setString(1, account.getUserName());
//            cs.setString(2, account.getPassword());
//            cs.setString(3, account.getEmail());
//            cs.setString(4, account.getAddress());
//            cs.setString(5, account.getPhoneNumber());
//            cs.setInt(6, account.getRoleID());
//            cs.setInt(7, account.getStatus());
//
//            return cs.executeUpdate() > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error registering account for user: " + account.getUserName(), e);
//        } finally {
//            closeResources(conn, cs, null);
//        }
//        return false;
//    }
//
//    public int getTotalAccounts() {
//        String query = "SELECT COUNT(*) FROM Account";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt(1);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting total accounts", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return 0;
//    }
//
//    public List<Account> getAccountsWithPaging(int offset, int limit) {
//        List<Account> list = new ArrayList<>();
//        String query = "SELECT userID, userName, '********' AS password, "
//                + "email, address, phoneNumber, roleID, status, createdDate, updatedDate "
//                + "FROM Account ORDER BY userID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setInt(1, offset);
//            ps.setInt(2, limit);
//            rs = ps.executeQuery();
//            while (rs.next()) {
//                list.add(new Account(
//                        rs.getInt("userID"),
//                        rs.getString("userName"),
//                        rs.getString("password"),
//                        rs.getString("email"),
//                        rs.getString("address"),
//                        rs.getString("phoneNumber"),
//                        rs.getInt("roleID"),
//                        rs.getInt("status"),
//                        rs.getString("createdDate"),
//                        rs.getString("updatedDate")
//                ));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting accounts with paging", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    public Account getAccountById(int id) {
//        String query = "SELECT * FROM Account WHERE userID = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setInt(1, id);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return new Account(
//                        rs.getInt("userID"),
//                        rs.getString("userName"),
//                        "********",
//                        rs.getString("email"),
//                        rs.getString("address"),
//                        rs.getString("phoneNumber"),
//                        rs.getInt("roleID"),
//                        rs.getInt("status"),
//                        rs.getString("createdDate"),
//                        rs.getString("updatedDate")
//                );
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting account by ID: " + id, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    public boolean checkUsernameExists(String username) {
//        String query = "SELECT COUNT(*) FROM Account WHERE userName = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setString(1, username);
//            rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt(1) > 0;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error checking if username exists: " + username, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return false;
//    }
//
//    public boolean checkPhoneNumberExists(String phoneNumber) {
//        String query = "SELECT COUNT(*) FROM Account WHERE phoneNumber = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setString(1, phoneNumber);
//            rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getInt(1) > 0;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error checking if phone number exists: " + phoneNumber, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return false;
//    }
//
//    public boolean updateAccount(int accountID, String username, String password, String email,
//            String phoneNumber, String address, int roleID, int status) {
//        Connection conn = null;
//        CallableStatement cs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//
//            // Kiểm tra xem mật khẩu có phải là placeholder "********" hoặc rỗng không
//            boolean updatePassword = password != null && !password.trim().isEmpty() && !password.equals("********");
//
//            if (updatePassword) {
//                // Nếu có mật khẩu mới, sử dụng stored procedure để mã hóa mật khẩu
//                String query = "{CALL UpdateAccountFull(?, ?, ?, ?, ?, ?, ?, ?)}";
//                cs = conn.prepareCall(query);
//                cs.setInt(1, accountID);
//                cs.setString(2, username);
//                cs.setString(3, password);  // Mật khẩu gốc sẽ được mã hóa trong stored procedure
//                cs.setString(4, email);
//                cs.setString(5, phoneNumber);
//                cs.setString(6, address);
//                cs.setInt(7, roleID);
//                cs.setInt(8, status);
//
//                LOGGER.log(Level.INFO, "Updating account with password - ID: {0}, Username: {1}, Email: {2}",
//                        new Object[]{accountID, username, email});
//            } else {
//                // Nếu không có mật khẩu mới, chỉ cập nhật các thông tin khác
//                String query = "{CALL UpdateAccountWithoutPassword(?, ?, ?, ?, ?, ?, ?)}";
//                cs = conn.prepareCall(query);
//                cs.setInt(1, accountID);
//                cs.setString(2, username);
//                cs.setString(3, email);
//                cs.setString(4, phoneNumber);
//                cs.setString(5, address);
//                cs.setInt(6, roleID);
//                cs.setInt(7, status);
//
//                LOGGER.log(Level.INFO, "Updating account without password - ID: {0}, Username: {1}, Email: {2}",
//                        new Object[]{accountID, username, email});
//            }
//
//            int rowsAffected = cs.executeUpdate();
//
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Successfully updated account with ID: {0}", accountID);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No rows affected when updating account with ID: {0}", accountID);
//                return false;
//            }
//        } catch (SQLException e) {
//            LOGGER.log(Level.SEVERE, "SQL Error updating account with ID: " + accountID, e);
//            return false;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating account with ID: " + accountID, e);
//            return false;
//        } finally {
//            if (cs != null) {
//                try {
//                    cs.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing CallableStatement", e);
//                }
//            }
//            if (conn != null) {
//                try {
//                    conn.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing Connection", e);
//                }
//            }
//        }
//    }
//
//    public void updateAccountPassword(int id, String newPassword) {
//        String query = "{CALL ChangePassword(?, ?)}";
//        Connection conn = null;
//        CallableStatement cs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            cs = conn.prepareCall(query);
//            cs.setInt(1, id);
//            cs.setString(2, newPassword);
//            cs.execute();
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating password for account ID: " + id, e);
//        } finally {
//            if (cs != null) {
//                try {
//                    cs.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing CallableStatement", e);
//                }
//            }
//            if (conn != null) {
//                try {
//                    conn.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing Connection", e);
//                }
//            }
//        }
//    }
//
//    public boolean addAccount(String userName, String password, String email,
//            String phoneNumber, String address, int roleID, int status) {
//        String query = "{CALL AddAccount(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
//        Connection conn = null;
//        CallableStatement cs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            cs = conn.prepareCall(query);
//
//            cs.setString(1, userName);
//            cs.setString(2, password);
//            cs.setString(3, email);
//            cs.setString(4, phoneNumber);
//            cs.setString(5, address);
//            cs.setInt(6, roleID);
//            cs.setInt(7, status);
//            cs.registerOutParameter(8, java.sql.Types.BIT);
//            cs.registerOutParameter(9, java.sql.Types.NVARCHAR);
//
//            cs.execute();
//
//            boolean success = cs.getBoolean(8);
//            String message = cs.getString(9);
//
//            if (!success) {
//                LOGGER.log(Level.WARNING, "Adding account failed: {0}", message);
//            }
//
//            return success;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error adding account for user: " + userName, e);
//            return false;
//        } finally {
//            if (cs != null) {
//                try {
//                    cs.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing CallableStatement", e);
//                }
//            }
//            if (conn != null) {
//                try {
//                    conn.close();
//                } catch (SQLException e) {
//                    LOGGER.log(Level.WARNING, "Error closing Connection", e);
//                }
//            }
//        }
//    }
//
//    public Account getAccount(String userName) {
//        String query = "SELECT * FROM Account WHERE userName = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setString(1, userName);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return new Account(
//                        rs.getInt("userID"),
//                        rs.getString("userName"),
//                        "********",
//                        rs.getString("email"),
//                        rs.getString("address"),
//                        rs.getString("phoneNumber"),
//                        rs.getInt("roleID"),
//                        rs.getInt("status"),
//                        rs.getString("createdDate"),
//                        rs.getString("updatedDate")
//                );
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting account by username: " + userName, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
////-----------------------------------------------------------------------------------------
//
//    public boolean updateAccountStatus(int userID, int status) {
//        String query = "UPDATE Account SET status = ?, updatedDate = GETDATE() WHERE userID = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(query);
//            ps.setInt(1, status);
//            ps.setInt(2, userID);
//
//            int rowsAffected = ps.executeUpdate();
//            return rowsAffected > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating status for account ID: " + userID, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public List<Account> getAllAcountByFilter(int filter) {
//        List<Account> list = new ArrayList<>();
//        String sql;
//        switch (filter) {
//            case 0:
//                sql = "SELECT * FROM Account";
//                break;
//            case 1:
//                sql = "SELECT * FROM Account WHERE status = 1 ";
//                break;
//            case 2:
//                sql = "SELECT * FROM Account WHERE status = 0 ";
//                break;
//            case 3:
//                sql = "SELECT * FROM Account WHERE roleID = 3 ";
//                break;
//            case 4:
//                sql = "SELECT * FROM Account WHERE roleID = 2 ";
//                break;
//            case 5:
//                sql = "SELECT * FROM Account WHERE roleID = 1 ";
//                break;
//            case 6:
//                sql = "SELECT * FROM Account ORDER BY userName ASC ";
//                break;
//            case 7:
//                sql = "SELECT * FROM Account ORDER BY userName DESC";
//                break;
//            default:
//                throw new AssertionError();
//        }
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToAccount(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all account", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    public List<Account> searchAccountByUsernameEmail(String input) {
//        List<Account> list = new ArrayList<>();
//        String sql = "SELECT * FROM Account WHERE username LIKE ? OR email LIKE ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setString(1, "%" + input.trim() + "%");
//            ps.setString(2, "%" + input.trim() + "%");
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToAccount(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting account ");
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
//        return new Account(
//                rs.getInt("userID"),
//                rs.getString("userName"),
//                rs.getString("password"),
//                rs.getString("email"),
//                rs.getString("address"),
//                rs.getString("phoneNumber"),
//                rs.getInt("roleID"),
//                rs.getInt("status"),
//                rs.getString("createdDate"),
//                rs.getString("updatedDate")
//        );
//    }
//
//    public boolean updateAccountByAdmin(int accountID, String email,
//            String phoneNumber, String address, int roleID, int status) throws SQLException {
//        Connection conn = null;
//        CallableStatement cs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            String query = "{? = CALL UpdateAccountWithoutPassword(?,  ?, ?, ?, ?, ?)}";
//            cs = conn.prepareCall(query);
//            cs.registerOutParameter(1, java.sql.Types.INTEGER); // OUT parameter (RETURN value)
//            cs.setInt(2, accountID);
//            cs.setString(3, email);
//            cs.setString(4, phoneNumber);
//            cs.setString(5, address);
//            cs.setInt(6, roleID);
//            cs.setInt(7, status);
//
//            cs.execute();
//            int returnValue = cs.getInt(1);
//
//            return returnValue == 1;
//        } catch (SQLException e) {
//            return false;
//        }
//    }
//    
//    public static void main(String[] args) throws SQLException {
//        AccountDAO1 adao = new AccountDAO1();
//        System.out.println(adao.updateAccountStatus(14, 1));
//    }
//}
