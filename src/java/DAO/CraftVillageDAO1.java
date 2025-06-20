//package DAO;
//
//import context.DBContext;
//import entity.CraftVillage.CraftVillage;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class CraftVillageDAO1 {
//    private static final Logger LOGGER = Logger.getLogger(CraftVillageDAO1.class.getName());
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
//    // Get all active villages with pagination
//    public List<CraftVillage> getAllCraftVillages(int offset, int limit) {
//        List<CraftVillage> list = new ArrayList<>();
//        String sql = "SELECT * FROM CraftVillage WHERE status = 1 ORDER BY villageID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, offset);
//            ps.setInt(2, limit);
//            rs = ps.executeQuery();
//            
//            while (rs.next()) {
//                CraftVillage v = new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//                list.add(v);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting paginated villages", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    // Get total count of active villages
//    public int getTotalCraftVillages() {
//        String sql = "SELECT COUNT(*) FROM CraftVillage WHERE status = 1";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return rs.getInt(1);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting total villages count", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return 0;
//    }
//
//    // Get all active villages
//    public List<CraftVillage> getAllVillages() {
//        List<CraftVillage> list = new ArrayList<>();
//        String sql = "SELECT * FROM CraftVillage WHERE status = 1";
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
//                CraftVillage v = new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//                list.add(v);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all villages", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    // Get village by ID
//    public CraftVillage getVillageById(int id) {
//        String sql = "SELECT * FROM CraftVillage WHERE villageID = ? AND status = 1";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, id);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting village by ID: " + id, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    // Get villages by seller ID
//    public List<CraftVillage> getVillagesBySellerId(int sellerId) {
//        List<CraftVillage> list = new ArrayList<>();
//        String sql = "SELECT * FROM CraftVillage WHERE sellerId = ? AND status = 1";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, sellerId);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                CraftVillage v = new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//                list.add(v);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting villages by seller ID: " + sellerId, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    // Add new village
//    public boolean addVillage(CraftVillage village) {
//        String sql = "INSERT INTO CraftVillage (villageName, description, address, latitude, longitude, " +
//                    "contactPhone, contactEmail, status, sellerId, mainImageUrl) " +
//                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setString(1, village.getVillageName());
//            ps.setString(2, village.getDescription());
//            ps.setString(3, village.getAddress());
//            ps.setFloat(4, village.getLatitude());
//            ps.setFloat(5, village.getLongitude());
//            ps.setString(6, village.getContactPhone());
//            ps.setString(7, village.getContactEmail());
//            ps.setInt(8, village.getStatus());
//            ps.setInt(9, village.getSellerId());
//            ps.setString(10, village.getMainImageUrl());
//
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error adding new village", e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    // Update village
//    public boolean updateVillage(CraftVillage village) {
//        String sql = "UPDATE CraftVillage SET villageName = ?, description = ?, address = ?, " +
//                    "latitude = ?, longitude = ?, contactPhone = ?, contactEmail = ?, " +
//                    "status = ?, mainImageUrl = ?, updatedDate = GETDATE() WHERE villageID = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setString(1, village.getVillageName());
//            ps.setString(2, village.getDescription());
//            ps.setString(3, village.getAddress());
//            ps.setFloat(4, village.getLatitude());
//            ps.setFloat(5, village.getLongitude());
//            ps.setString(6, village.getContactPhone());
//            ps.setString(7, village.getContactEmail());
//            ps.setInt(8, village.getStatus());
//            ps.setString(9, village.getMainImageUrl());
//            ps.setInt(10, village.getVillageID());
//
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating village ID: " + village.getVillageID(), e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    // Update click count
//    public boolean updateClickCount(int villageId) {
//        String sql = "UPDATE CraftVillage SET clickCount = clickCount + 1, " +
//                    "lastClicked = GETDATE() WHERE villageID = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, villageId);
//
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating click count for village ID: " + villageId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    // Get top villages by click count
//    public List<CraftVillage> getTopVillagesByClicks(int limit) {
//        List<CraftVillage> list = new ArrayList<>();
//        String sql = "SELECT TOP (?) * FROM CraftVillage WHERE status = 1 " +
//                    "ORDER BY clickCount DESC, lastClicked DESC";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, limit);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                CraftVillage v = new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//                list.add(v);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting top villages by clicks", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    // Search villages
//    public List<CraftVillage> searchVillages(String keyword) {
//        List<CraftVillage> list = new ArrayList<>();
//        String sql = "SELECT * FROM CraftVillage WHERE status = 1 AND " +
//                    "(villageName LIKE ? OR description LIKE ? OR address LIKE ?)";
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            String searchPattern = "%" + keyword + "%";
//            ps.setString(1, searchPattern);
//            ps.setString(2, searchPattern);
//            ps.setString(3, searchPattern);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                CraftVillage v = new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//                list.add(v);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error searching villages with keyword: " + keyword, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    // Update village status
//    public boolean updateVillageStatus(int villageId, int status) {
//        String sql = "UPDATE CraftVillage SET status = ?, updatedDate = GETDATE() WHERE villageID = ?";
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, status);
//            ps.setInt(2, villageId);
//
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating village status for ID: " + villageId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//    
////--------------------------------------------------------------------------------------    
//    public List<CraftVillage> getAllCraftVillagesByAdmin() {
//        List<CraftVillage> list = new ArrayList<>();
//        String sql = "SELECT * FROM CraftVillage";
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
//                list.add(mapResultSetToVillage(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all villages", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//    
//        private CraftVillage mapResultSetToVillage(ResultSet rs) throws SQLException {
//        return new CraftVillage(
//                    rs.getInt("villageID"),
//                    rs.getString("villageName"),
//                    rs.getString("description"),
//                    rs.getString("address"),
//                    rs.getFloat("latitude"),
//                    rs.getFloat("longitude"),
//                    rs.getString("contactPhone"),
//                    rs.getString("contactEmail"),
//                    rs.getInt("status"),
//                    rs.getTimestamp("createdDate"),
//                    rs.getTimestamp("updatedDate"),
//                    rs.getInt("sellerId"),
//                    rs.getInt("clickCount"),
//                    rs.getTimestamp("lastClicked"),
//                    rs.getString("mainImageUrl")
//                );
//    }
//    
//} 