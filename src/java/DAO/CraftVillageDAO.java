/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.CraftVillage.CraftType;
import entity.CraftVillage.CraftVillage;
import context.DBContext;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;

/**
 *
 * @author ACER
 */
public class CraftVillageDAO {

    private static final Logger LOGGER = Logger.getLogger(CraftVillageDAO.class.getName());

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

    public String getVillageNameByID(int villageID) {
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

    public String getCraftTypeNameByID(int typeID) {
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

    public boolean updateCraftVillageByAdmin(CraftVillage village) {
        String sql = "{CALL UpdateVillageFullByAdmin(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, village.getVillageID());
            cs.setString(2, village.getVillageName());
            cs.setInt(3, village.getTypeID());
            cs.setString(4, village.getDescription());
            cs.setString(5, village.getAddress());
            cs.setDouble(6, village.getLatitude());
            cs.setDouble(7, village.getLongitude());
            cs.setString(8, village.getContactPhone());
            cs.setString(9, village.getContactEmail());
            cs.setInt(10, village.getStatus());
            cs.setInt(11, village.getSellerId());
            cs.setString(12, village.getOpeningHours());
            cs.setString(13, village.getClosingDays());
            cs.setString(14, village.getMapEmbedUrl());
            cs.setString(15, village.getVirtualTourUrl());
            cs.setString(16, village.getHistory());
            cs.setString(17, village.getSpecialFeatures());
            cs.setString(18, village.getFamousProducts());
            cs.setString(19, village.getCulturalEvents());
            cs.setString(20, village.getCraftProcess());
            cs.setString(21, village.getVideoDescriptionUrl());
            cs.setString(22, village.getTravelTips());
            cs.setString(23, village.getMainImageUrl());

            // Output parameter
            cs.registerOutParameter(24, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(24);
            return result == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteVillageByAdmin(int villageID) {
        String sql = "{CALL DeleteVillageByAdmin(?, ?)}";

        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, villageID);
            cs.registerOutParameter(2, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(2);

            if (result == 1) {
                System.out.println("Village deleted permanently.");
                return true;
            } else if (result == 2) {
                System.out.println("Village references found → related records set inactive.");
                return true;
            } else {
                System.out.println("Delete village failed or unknown result.");
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addNewVillageByAdmin(CraftVillage village) {
        String query = "{CALL AddVillageFullByAdmin(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);

            // Set all input parameters
            cs.setString(1, village.getVillageName());
            cs.setInt(2, village.getTypeID());
            cs.setString(3, village.getDescription());
            cs.setString(4, village.getAddress());
            cs.setDouble(5, village.getLatitude());
            cs.setDouble(6, village.getLongitude());
            cs.setString(7, village.getContactPhone());
            cs.setString(8, village.getContactEmail());
            cs.setInt(9, village.getStatus());
            cs.setInt(10, village.getSellerId());
            cs.setString(11, village.getOpeningHours());
            cs.setString(12, village.getClosingDays());
            cs.setString(13, village.getMapEmbedUrl());
            cs.setString(14, village.getVirtualTourUrl());
            cs.setString(15, village.getHistory());
            cs.setString(16, village.getSpecialFeatures());
            cs.setString(17, village.getFamousProducts());
            cs.setString(18, village.getCulturalEvents());
            cs.setString(19, village.getCraftProcess());
            cs.setString(20, village.getVideoDescriptionUrl());
            cs.setString(21, village.getTravelTips());
            cs.setString(22, village.getMainImageUrl());

            // Output parameter
            cs.registerOutParameter(23, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(23);

            LOGGER.log(Level.INFO, "AddVillageFullByAdmin result code: {0}", result);

            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding new village: " + village.getVillageName(), e);
        } finally {
            closeResources(conn, cs, null);
        }
        return false;
    }

    public List<CraftVillage> getSearchVillageByAdmin(int status, int searchID, String contentSearch) {
        if (contentSearch == null) {
            contentSearch = "";
        } else {
            contentSearch = contentSearch.trim();
        }

        String query;
        switch (searchID) {
            case 1:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND CAST(typeID AS NVARCHAR) LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 2:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND villageName COLLATE Latin1_General_CI_AI LIKE ? ORDER BY villageName ASC";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 3:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND villageName COLLATE Latin1_General_CI_AI LIKE ? ORDER BY villageName DESC";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 4:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND villageName COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 5:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND CAST(villageID AS NVARCHAR) LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 6:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND address COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 7:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND CONVERT(date, createdDate) = CONVERT(date, GETDATE())";
                break;
            default:
                query = "SELECT * FROM CraftVillage WHERE status = ? AND villageName COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
        }

        List<CraftVillage> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, status);

            if (query.contains("? AND") || query.contains("LIKE")) {
                ps.setString(2, contentSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCraftVillage(rs));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, e);
        }
        return list;
    }

    public List<CraftVillage> getTopRatedByAdmin() {
        List<CraftVillage> list = new ArrayList<>();
        String query = "SELECT * FROM CraftVillage WHERE averageRating >= 4.5 and averageRating <= 5 AND status = 1 ORDER BY averageRating DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCraftVillage(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return list;
    }

    public List<CraftVillage> getVillageByCategory(int typeID) {
        List<CraftVillage> list = new ArrayList<>();
        String sql = "SELECT * FROM CraftVillage WHERE typeID = ? AND status = 1";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, typeID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCraftVillage(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getVillageNameByTypeID(Integer typeID) {
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
        //System.out.println(new CraftVillageDAO().updateCraftVillageByAdmin(new CraftVillage(1, "B", 1, "A", "A", 1, 1, "A", "A", 1, 1, "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A")));
        System.out.println(new CraftVillageDAO().getVillageNameByTypeID(1));
    }

}
