/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.Account.Account;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author ACER
 */
public class AccountDAO {

    private static final Logger LOGGER = Logger.getLogger(AccountDAO.class.getName());

    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        return new Account(
                rs.getInt("userID"),
                rs.getString("userName"),
                "********",
                rs.getString("email"),
                rs.getString("address"),
                rs.getString("phoneNumber"),
                rs.getInt("roleID"),
                rs.getInt("status"),
                rs.getString("createdDate"),
                rs.getString("updatedDate"),
                rs.getString("fullName")
        );
    }

    private void closeResources(java.sql.Connection conn, PreparedStatement ps, ResultSet rs) {
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
        }
    }

    public boolean registerAccount(Account account) {
        String query = "{CALL RegisterAccount(?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        
        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);
            
            cs.setString(1, account.getUserName());
            cs.setString(2, account.getPassword());
            cs.setString(3, account.getEmail());
            cs.setString(4, account.getFullName());
            cs.setString(5, account.getAddress());
            cs.setString(6, account.getPhoneNumber());
            cs.registerOutParameter(7, java.sql.Types.INTEGER); // Register OUTPUT parameter
    
            cs.execute(); // Use execute() instead of executeUpdate() for procedures with OUTPUT parameters
            
            // Get the new user ID from the output parameter
            int newUserID = cs.getInt(7);
            LOGGER.log(Level.INFO, "Successfully registered user: {0} with ID: {1}", 
                      new Object[]{account.getUserName(), newUserID});
            
            return newUserID > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error registering account for user: " + account.getUserName(), e);
        } finally {
            closeResources(conn, cs, null);
        }
        return false;
    }

    public Account loginAccount(String user, String pass) {
        String query = "{CALL LoginAccount(?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            cs = conn.prepareCall(query);
            cs.setString(1, user);
            cs.setString(2, pass);

            rs = cs.executeQuery();

            if (rs.next()) {
                return mapResultSetToAccount(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In rõ lỗi ra console
        } finally {
            if (cs != null) {
                try {
                    cs.close();
                } catch (SQLException e) {
                    e.printStackTrace(); // In rõ lỗi ra console
                }
            }
            closeResources(conn, null, rs);
        }
        return null;
    }

    public boolean checkUsernameExists(String username) {
        String query = "SELECT COUNT(*) FROM Account WHERE userName = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if username exists: " + username, e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    public boolean checkEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM Account WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if username exists: " + email, e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    
    public boolean checkPhoneNumberExists(String phoneNumber) {
        String query = "SELECT COUNT(*) FROM Account WHERE phoneNumber = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, phoneNumber);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if phone number exists: " + phoneNumber, e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }
    
    public Account loginByEmail(String email) {
        // Use direct SQL query with REPLACE to remove line feeds and carriage returns
        String query = "SELECT userID, userName, email, fullName, address, phoneNumber, roleID, status, createdDate, updatedDate FROM Account WHERE REPLACE(REPLACE(LTRIM(RTRIM(email)), CHAR(10), ''), CHAR(13), '') = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            LOGGER.log(Level.INFO, "LoginByEmail called with email: " + email);

            conn = new DBContext().getConnection();
            LOGGER.log(Level.INFO, "Database connection successful");

            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            LOGGER.log(Level.INFO, "Executing query: " + query + " with email: " + email);

            rs = ps.executeQuery();

            if (rs.next()) {
                LOGGER.log(Level.INFO, "Found account for email: " + email + ", userName: " + rs.getString("userName"));
                return new Account(
                        rs.getInt("userID"),
                        rs.getString("userName"),
                        "********",
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getInt("roleID"),
                        rs.getInt("status"),
                        rs.getString("createdDate"),
                        rs.getString("updatedDate"),
                        rs.getString("fullName")
                );
            } else {
                LOGGER.log(Level.WARNING, "No account found for email: " + email);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during loginByEmail for email: " + email, e);
        } finally {
            closeResources(conn, ps, rs);
        }
        return null;
    }
    public static void main(String[] args) {
        System.out.println(new AccountDAO().registerAccount(new Account("dat17","123123", "d1@gmail.com", "1231331231","TVD")));
    }
}
