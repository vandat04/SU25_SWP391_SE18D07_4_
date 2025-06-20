/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.Account.Account;
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

    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        return new Account(
                rs.getInt("userID"),
                rs.getString("userName"),
                rs.getString("email"),
                rs.getString("address"),
                rs.getString("phoneNumber"),
                rs.getInt("roleID"),
                rs.getInt("status"),
                rs.getString("createdDate"),
                rs.getString("updatedDate")
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
        java.sql.Connection conn = null;
        try {
            conn = DBContext.getConnection();
            String sql = "{CALL RegisterAccount(?, ?, ?, ?, ?,?)}";
            CallableStatement cs = conn.prepareCall(sql);
            cs.setString(1, account.getUserName());
            cs.setString(2, account.getPassword());
            cs.setString(3, account.getEmail());
            cs.setString(4, account.getAddress());
            cs.setString(5, account.getPhoneNumber());
            cs.registerOutParameter(6, java.sql.Types.INTEGER);
            cs.execute();

            int newUserId = cs.getInt(6);
            System.out.println("Tài khoản được tạo với ID = " + newUserId);
            return true;
        } catch (SQLException e) {
            e.printStackTrace(); // In rõ lỗi ra console
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

    public static void main(String[] args) {
        System.out.println(new AccountDAO().loginAccount("customer01", "123123").toString());
    }
}
