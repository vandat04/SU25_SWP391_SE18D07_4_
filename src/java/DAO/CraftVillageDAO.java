/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.CraftVillage.CraftType;
import entity.CraftVillage.CraftVillage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ACER
 */
public class CraftVillageDAO {

    private CraftVillage mapResultSetToCraftVillage(ResultSet rs) throws SQLException {
        return new CraftVillage(
                rs.getInt("villageID"),
                rs.getInt("typeID"),
                rs.getString("villageName"),
                rs.getString("description"),
                rs.getString("address"),
                rs.getDouble("latitude"),
                rs.getDouble("longitude"),
                rs.getString("contactPhone"),
                rs.getString("contactEmail"),
                rs.getInt("status"),
                rs.getInt("clickCount"),
                rs.getString("mainImageUrl"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate"),
                rs.getInt("sellerId"),
                rs.getString("openingHours"),
                rs.getString("closingDays"),
                rs.getBigDecimal("averageRating"),
                rs.getInt("totalReviews"),
                rs.getString("mapEmbedUrl"),
                rs.getString("virtualTourUrl"),
                rs.getString("history"),
                rs.getString("specialFeatures"),
                rs.getString("famousProducts"),
                rs.getString("culturalEvents"),
                rs.getString("craftProcess"),
                rs.getString("videoDescriptionUrl"),
                rs.getString("travelTips")
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

    public List<CraftType> getAllCraftType() {
        List<CraftType> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            // Query cho user - chỉ lấy sản phẩm active của seller
            String sql = "SELECT * FROM CraftType WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CraftType(rs.getInt("typeID"), rs.getString("typeName"), rs.getString("description")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<CraftVillage> getAllCraftVillageActive() {
        List<CraftVillage> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            // Query cho user - chỉ lấy sản phẩm active của seller
            String sql = "SELECT * FROM CraftVillage WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToCraftVillage(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }
    
    public String getVillageNameByID (int villageID){
        String query = "SELECT villageName FROM CraftVillage WHERE villageID = ? AND status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, villageID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("villageName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return "";
    }
    
    public String getCraftTypeNameByID (int typeID){
        String query = "SELECT typeName FROM CraftType WHERE typeID = ? AND status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, typeID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("typeName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return "";
    }
    
    public static void main(String[] args) {
        System.out.println(new CraftVillageDAO().getCraftTypeNameByID(1));
    }
}
