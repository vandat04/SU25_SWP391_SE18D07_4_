package DAO;

import entity.CraftVillage.*;
import context.DBContext;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TourDAO {
    private static final Logger LOGGER = Logger.getLogger(TourDAO.class.getName());
    
    // Lấy tour mặc định của làng
    public Tour getDefaultTourByVillage(int villageID) {
        String sql = "SELECT TOP 1 t.* FROM Tours t " +
                    "INNER JOIN CraftVillage cv ON t.villageID = cv.villageID " +
                    "WHERE cv.villageID = ? AND t.status = 1 " +
                    "ORDER BY CAST(t.isDefault AS INT) DESC, t.createdDate ASC";
        
        LOGGER.info("Getting default tour for village: " + villageID);
        LOGGER.info("SQL: " + sql);
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, villageID);
            ResultSet rs = ps.executeQuery();
            
            LOGGER.info("Query executed, checking for results...");
            
            if (rs.next()) {
                LOGGER.info("Found tour in ResultSet, mapping...");
                Tour tour = mapResultSetToTour(rs);
                LOGGER.info("Tour mapped successfully: " + (tour != null ? tour.getTourID() : "null"));
                return tour;
            } else {
                LOGGER.info("No tour found in ResultSet");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting default tour for village " + villageID, e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error getting default tour for village " + villageID, e);
        }
        return null;
    }
    
    // Lấy thông tin tour hoàn chỉnh
    public Map<String, Object> getCompleteTourInfo(int tourID) {
        Map<String, Object> result = new HashMap<>();
        
        try (Connection conn = DBContext.getConnection()) {
            // Lấy thông tin tour
            String tourSql = "SELECT t.*, cv.villageID, cv.villageName, cv.description AS villageDescription, " +
                           "cv.address, cv.mainImageUrl AS villageImageUrl " +
                           "FROM Tours t " +
                           "INNER JOIN CraftVillage cv ON t.villageID = cv.villageID " +
                           "WHERE t.tourID = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(tourSql)) {
                ps.setInt(1, tourID);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    Tour tour = mapResultSetToTour(rs);
                    result.put("tour", tour);
                    result.put("villageID", rs.getInt("villageID"));
                    result.put("villageName", rs.getString("villageName"));
                    result.put("villageDescription", rs.getString("villageDescription"));
                    result.put("address", rs.getString("address"));
                    result.put("villageImageUrl", rs.getString("villageImageUrl"));
                }
            }
            
            // Lấy danh sách panorama
            String panoramaSql = "SELECT * FROM Panoramas WHERE tourID = ? ORDER BY orderIndex";
            List<Panorama> panoramas = new ArrayList<>();
            
            try (PreparedStatement ps = conn.prepareStatement(panoramaSql)) {
                ps.setInt(1, tourID);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    panoramas.add(mapResultSetToPanorama(rs));
                }
            }
            result.put("panoramas", panoramas);
            
            // Lấy danh sách navigation points
            String navSql = "SELECT np.*, p1.panoramaName AS sourcePanoramaName, p2.panoramaName AS targetPanoramaName " +
                          "FROM NavigationPoints np " +
                          "INNER JOIN Panoramas p1 ON np.panoramaID = p1.panoramaID " +
                          "INNER JOIN Panoramas p2 ON np.targetPanoramaID = p2.panoramaID " +
                          "WHERE p1.tourID = ? ORDER BY p1.orderIndex, np.x";
            List<NavigationPoint> navigationPoints = new ArrayList<>();
            
            try (PreparedStatement ps = conn.prepareStatement(navSql)) {
                ps.setInt(1, tourID);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    navigationPoints.add(mapResultSetToNavigationPoint(rs));
                }
            }
            result.put("navigationPoints", navigationPoints);
            
            // Lấy danh sách hotspots
            String hotspotSql = "SELECT th.*, p.name AS productName, p.price AS productPrice, p.mainImageUrl AS productImageUrl " +
                              "FROM TourHotspots th " +
                              "LEFT JOIN Product p ON th.productID = p.pid " +
                              "INNER JOIN Panoramas pan ON th.panoramaID = pan.panoramaID " +
                              "WHERE pan.tourID = ? ORDER BY pan.orderIndex, th.x";
            List<TourHotspot> hotspots = new ArrayList<>();
            
            try (PreparedStatement ps = conn.prepareStatement(hotspotSql)) {
                ps.setInt(1, tourID);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    hotspots.add(mapResultSetToTourHotspot(rs));
                }
            }
            result.put("hotspots", hotspots);
            
            // Lấy cài đặt tour
            String settingSql = "SELECT * FROM TourSettings WHERE tourID = ?";
            List<TourSetting> settings = new ArrayList<>();
            
            try (PreparedStatement ps = conn.prepareStatement(settingSql)) {
                ps.setInt(1, tourID);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    settings.add(mapResultSetToTourSetting(rs));
                }
            }
            result.put("settings", settings);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting complete tour info for tour " + tourID, e);
        }
        
        return result;
    }
    
    // Tạo tour mới
    public int createTour(Tour tour) {
        String sql = "INSERT INTO Tours (villageID, tourName, description, createdBy) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, tour.getVillageID());
            ps.setString(2, tour.getTourName());
            ps.setString(3, tour.getDescription());
            ps.setObject(4, tour.getCreatedBy());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int tourID = rs.getInt(1);
                    
                    // Nếu đây là tour đầu tiên của làng, đặt làm tour mặc định
                    String checkSql = "SELECT COUNT(*) FROM Tours WHERE villageID = ? AND tourID != ?";
                    try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                        checkPs.setInt(1, tour.getVillageID());
                        checkPs.setInt(2, tourID);
                        ResultSet checkRs = checkPs.executeQuery();
                        
                        if (checkRs.next() && checkRs.getInt(1) == 0) {
                            // Đây là tour đầu tiên, đặt làm mặc định
                            String updateSql = "UPDATE Tours SET isDefault = 1 WHERE tourID = ?";
                            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                                updatePs.setInt(1, tourID);
                                updatePs.executeUpdate();
                            }
                            
                            // Cập nhật CraftVillage
                            String villageSql = "UPDATE CraftVillage SET defaultTourID = ? WHERE villageID = ?";
                            try (PreparedStatement villagePs = conn.prepareStatement(villageSql)) {
                                villagePs.setInt(1, tourID);
                                villagePs.setInt(2, tour.getVillageID());
                                villagePs.executeUpdate();
                            }
                        }
                    }
                    
                    return tourID;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating tour", e);
        }
        return -1;
    }
    
    // Thêm panorama vào tour
    public int addPanorama(Panorama panorama) {
        String sql = "INSERT INTO Panoramas (tourID, panoramaName, imageUrl, description, orderIndex, isStartPoint) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Nếu không chỉ định orderIndex, tự động tính
            if (panorama.getOrderIndex() == 0) {
                String maxSql = "SELECT ISNULL(MAX(orderIndex), -1) + 1 FROM Panoramas WHERE tourID = ?";
                try (PreparedStatement maxPs = conn.prepareStatement(maxSql)) {
                    maxPs.setInt(1, panorama.getTourID());
                    ResultSet maxRs = maxPs.executeQuery();
                    if (maxRs.next()) {
                        panorama.setOrderIndex(maxRs.getInt(1));
                    }
                }
            }
            
            // Nếu đây là panorama đầu tiên, đặt làm điểm bắt đầu
            String checkSql = "SELECT COUNT(*) FROM Panoramas WHERE tourID = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, panorama.getTourID());
                ResultSet checkRs = checkPs.executeQuery();
                if (checkRs.next() && checkRs.getInt(1) == 0) {
                    panorama.setStartPoint(true);
                }
            }
            
            ps.setInt(1, panorama.getTourID());
            ps.setString(2, panorama.getPanoramaName());
            ps.setString(3, panorama.getImageUrl());
            ps.setString(4, panorama.getDescription());
            ps.setInt(5, panorama.getOrderIndex());
            ps.setBoolean(6, panorama.isStartPoint());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding panorama", e);
        }
        return -1;
    }
    
    // Thêm navigation point
    public int addNavigationPoint(NavigationPoint navigationPoint) {
        String sql = "INSERT INTO NavigationPoints (panoramaID, targetPanoramaID, x, y, yaw, pitch, description, navigationType, targetUrl, iconClass) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, navigationPoint.getPanoramaID());
            ps.setInt(2, navigationPoint.getTargetPanoramaID());
            ps.setFloat(3, navigationPoint.getX());
            ps.setFloat(4, navigationPoint.getY());
            ps.setObject(5, navigationPoint.getYaw());
            ps.setObject(6, navigationPoint.getPitch());
            ps.setString(7, navigationPoint.getDescription());
            ps.setString(8, navigationPoint.getNavigationType());
            ps.setString(9, navigationPoint.getTargetUrl());
            ps.setString(10, navigationPoint.getIconClass());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding navigation point", e);
        }
        return -1;
    }
    
    // Thêm hotspot
    public int addTourHotspot(TourHotspot hotspot) {
        String sql = "INSERT INTO TourHotspots (panoramaID, x, y, yaw, pitch, title, description, hotspotType, targetUrl, iconClass, productID) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, hotspot.getPanoramaID());
            ps.setFloat(2, hotspot.getX());
            ps.setFloat(3, hotspot.getY());
            ps.setObject(4, hotspot.getYaw());
            ps.setObject(5, hotspot.getPitch());
            ps.setString(6, hotspot.getTitle());
            ps.setString(7, hotspot.getDescription());
            ps.setString(8, hotspot.getHotspotType());
            ps.setString(9, hotspot.getTargetUrl());
            ps.setString(10, hotspot.getIconClass());
            ps.setObject(11, hotspot.getProductID());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding tour hotspot", e);
        }
        return -1;
    }
    
    // Mapping methods
    private Tour mapResultSetToTour(ResultSet rs) throws SQLException {
        try {
            Tour tour = new Tour();
            tour.setTourID(rs.getInt("tourID"));
            tour.setVillageID(rs.getInt("villageID"));
            tour.setTourName(rs.getString("tourName"));
            tour.setDescription(rs.getString("description"));
            tour.setStatus(rs.getInt("status"));
            tour.setDefault(rs.getBoolean("isDefault"));
            tour.setCreatedDate(rs.getTimestamp("createdDate"));
            tour.setUpdatedDate(rs.getTimestamp("updatedDate"));
            
            // Fix for SQL Server compatibility
            Object createdByObj = rs.getObject("createdBy");
            if (createdByObj != null) {
                tour.setCreatedBy((Integer) createdByObj);
            } else {
                tour.setCreatedBy(null);
            }
            
            LOGGER.info("Successfully mapped tour: " + tour.getTourID() + " - " + tour.getTourName());
            return tour;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error mapping ResultSet to Tour", e);
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error mapping ResultSet to Tour", e);
            throw new SQLException("Error mapping tour data", e);
        }
    }
    
    private Panorama mapResultSetToPanorama(ResultSet rs) throws SQLException {
        Panorama panorama = new Panorama();
        panorama.setPanoramaID(rs.getInt("panoramaID"));
        panorama.setTourID(rs.getInt("tourID"));
        panorama.setPanoramaName(rs.getString("panoramaName"));
        panorama.setImageUrl(rs.getString("imageUrl"));
        panorama.setDescription(rs.getString("description"));
        panorama.setOrderIndex(rs.getInt("orderIndex"));
        panorama.setStartPoint(rs.getBoolean("isStartPoint"));
        panorama.setStatus(rs.getInt("status"));
        panorama.setCreatedDate(rs.getTimestamp("createdDate"));
        panorama.setUpdatedDate(rs.getTimestamp("updatedDate"));
        return panorama;
    }
    
    private NavigationPoint mapResultSetToNavigationPoint(ResultSet rs) throws SQLException {
        NavigationPoint nav = new NavigationPoint();
        nav.setNavigationID(rs.getInt("navigationID"));
        nav.setPanoramaID(rs.getInt("panoramaID"));
        nav.setTargetPanoramaID(rs.getInt("targetPanoramaID"));
        nav.setX(rs.getFloat("x"));
        nav.setY(rs.getFloat("y"));
        
        // Fix for SQL Server compatibility
        Object yawObj = rs.getObject("yaw");
        if (yawObj != null) {
            if (yawObj instanceof Double) {
                nav.setYaw(((Double) yawObj).floatValue());
            } else {
                nav.setYaw((Float) yawObj);
            }
        } else {
            nav.setYaw(null);
        }
        
        Object pitchObj = rs.getObject("pitch");
        if (pitchObj != null) {
            if (pitchObj instanceof Double) {
                nav.setPitch(((Double) pitchObj).floatValue());
            } else {
                nav.setPitch((Float) pitchObj);
            }
        } else {
            nav.setPitch(null);
        }
        
        nav.setDescription(rs.getString("description"));
        nav.setNavigationType(rs.getString("navigationType"));
        nav.setTargetUrl(rs.getString("targetUrl"));
        nav.setIconClass(rs.getString("iconClass"));
        nav.setStatus(rs.getInt("status"));
        nav.setCreatedDate(rs.getTimestamp("createdDate"));
        nav.setUpdatedDate(rs.getTimestamp("updatedDate"));
        nav.setSourcePanoramaName(rs.getString("sourcePanoramaName"));
        nav.setTargetPanoramaName(rs.getString("targetPanoramaName"));
        return nav;
    }
    
    private TourHotspot mapResultSetToTourHotspot(ResultSet rs) throws SQLException {
        TourHotspot hotspot = new TourHotspot();
        hotspot.setHotspotID(rs.getInt("hotspotID"));
        hotspot.setPanoramaID(rs.getInt("panoramaID"));
        hotspot.setX(rs.getFloat("x"));
        hotspot.setY(rs.getFloat("y"));
        
        // Fix for SQL Server compatibility
        Object yawObj = rs.getObject("yaw");
        if (yawObj != null) {
            if (yawObj instanceof Double) {
                hotspot.setYaw(((Double) yawObj).floatValue());
            } else {
                hotspot.setYaw((Float) yawObj);
            }
        } else {
            hotspot.setYaw(null);
        }
        
        Object pitchObj = rs.getObject("pitch");
        if (pitchObj != null) {
            if (pitchObj instanceof Double) {
                hotspot.setPitch(((Double) pitchObj).floatValue());
            } else {
                hotspot.setPitch((Float) pitchObj);
            }
        } else {
            hotspot.setPitch(null);
        }
        
        hotspot.setTitle(rs.getString("title"));
        hotspot.setDescription(rs.getString("description"));
        hotspot.setHotspotType(rs.getString("hotspotType"));
        hotspot.setTargetUrl(rs.getString("targetUrl"));
        hotspot.setIconClass(rs.getString("iconClass"));
        
        Object productIDObj = rs.getObject("productID");
        if (productIDObj != null) {
            hotspot.setProductID((Integer) productIDObj);
        } else {
            hotspot.setProductID(null);
        }
        
        hotspot.setStatus(rs.getInt("status"));
        hotspot.setCreatedDate(rs.getTimestamp("createdDate"));
        hotspot.setUpdatedDate(rs.getTimestamp("updatedDate"));
        hotspot.setProductName(rs.getString("productName"));
        
        Object productPriceObj = rs.getObject("productPrice");
        if (productPriceObj != null) {
            hotspot.setProductPrice((Double) productPriceObj);
        } else {
            hotspot.setProductPrice(null);
        }
        
        hotspot.setProductImageUrl(rs.getString("productImageUrl"));
        return hotspot;
    }
    
    private TourSetting mapResultSetToTourSetting(ResultSet rs) throws SQLException {
        TourSetting setting = new TourSetting();
        setting.setSettingID(rs.getInt("settingID"));
        setting.setTourID(rs.getInt("tourID"));
        setting.setSettingKey(rs.getString("settingKey"));
        setting.setSettingValue(rs.getString("settingValue"));
        setting.setSettingType(rs.getString("settingType"));
        setting.setDescription(rs.getString("description"));
        setting.setCreatedDate(rs.getTimestamp("createdDate"));
        setting.setUpdatedDate(rs.getTimestamp("updatedDate"));
        return setting;
    }
} 