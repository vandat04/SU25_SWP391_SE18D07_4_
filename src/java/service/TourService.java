package service;

import DAO.TourDAO;
import entity.CraftVillage.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TourService {
    private static final Logger LOGGER = Logger.getLogger(TourService.class.getName());
    private TourDAO tourDAO;
    
    public TourService() {
        this.tourDAO = new TourDAO();
    }
    
    // Lấy tour mặc định của làng
    public Tour getDefaultTourByVillage(int villageID) {
        try {
            return tourDAO.getDefaultTourByVillage(villageID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting default tour for village " + villageID, e);
            return null;
        }
    }
    
    // Lấy thông tin tour hoàn chỉnh
    public Map<String, Object> getCompleteTourInfo(int tourID) {
        try {
            return tourDAO.getCompleteTourInfo(tourID);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting complete tour info for tour " + tourID, e);
            return new HashMap<>();
        }
    }
    
    // Tạo tour mới
    public int createTour(Tour tour) {
        try {
            // Validation
            if (tour.getTourName() == null || tour.getTourName().trim().isEmpty()) {
                LOGGER.warning("Tour name cannot be empty");
                return -1;
            }
            
            if (tour.getVillageID() <= 0) {
                LOGGER.warning("Invalid village ID");
                return -1;
            }
            
            return tourDAO.createTour(tour);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating tour", e);
            return -1;
        }
    }
    
    // Thêm panorama vào tour
    public int addPanorama(Panorama panorama) {
        try {
            // Validation
            if (panorama.getPanoramaName() == null || panorama.getPanoramaName().trim().isEmpty()) {
                LOGGER.warning("Panorama name cannot be empty");
                return -1;
            }
            
            if (panorama.getImageUrl() == null || panorama.getImageUrl().trim().isEmpty()) {
                LOGGER.warning("Image URL cannot be empty");
                return -1;
            }
            
            if (panorama.getTourID() <= 0) {
                LOGGER.warning("Invalid tour ID");
                return -1;
            }
            
            return tourDAO.addPanorama(panorama);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding panorama", e);
            return -1;
        }
    }
    
    // Thêm navigation point
    public int addNavigationPoint(NavigationPoint navigationPoint) {
        try {
            // Validation
            if (navigationPoint.getPanoramaID() <= 0) {
                LOGGER.warning("Invalid panorama ID");
                return -1;
            }
            
            if (navigationPoint.getTargetPanoramaID() <= 0) {
                LOGGER.warning("Invalid target panorama ID");
                return -1;
            }
            
            if (navigationPoint.getX() < 0 || navigationPoint.getX() > 1) {
                LOGGER.warning("X coordinate must be between 0 and 1");
                return -1;
            }
            
            if (navigationPoint.getY() < 0 || navigationPoint.getY() > 1) {
                LOGGER.warning("Y coordinate must be between 0 and 1");
                return -1;
            }
            
            return tourDAO.addNavigationPoint(navigationPoint);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding navigation point", e);
            return -1;
        }
    }
    
    // Thêm hotspot
    public int addTourHotspot(TourHotspot hotspot) {
        try {
            // Validation
            if (hotspot.getPanoramaID() <= 0) {
                LOGGER.warning("Invalid panorama ID");
                return -1;
            }
            
            if (hotspot.getTitle() == null || hotspot.getTitle().trim().isEmpty()) {
                LOGGER.warning("Hotspot title cannot be empty");
                return -1;
            }
            
            if (hotspot.getX() < 0 || hotspot.getX() > 1) {
                LOGGER.warning("X coordinate must be between 0 and 1");
                return -1;
            }
            
            if (hotspot.getY() < 0 || hotspot.getY() > 1) {
                LOGGER.warning("Y coordinate must be between 0 and 1");
                return -1;
            }
            
            return tourDAO.addTourHotspot(hotspot);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding tour hotspot", e);
            return -1;
        }
    }
    
    // Lấy danh sách panorama của tour
    @SuppressWarnings("unchecked")
    public List<Panorama> getPanoramasByTour(int tourID) {
        try {
            Map<String, Object> tourInfo = tourDAO.getCompleteTourInfo(tourID);
            return (List<Panorama>) tourInfo.getOrDefault("panoramas", new ArrayList<>());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting panoramas for tour " + tourID, e);
            return new ArrayList<>();
        }
    }
    
    // Lấy danh sách navigation points của tour
    @SuppressWarnings("unchecked")
    public List<NavigationPoint> getNavigationPointsByTour(int tourID) {
        try {
            Map<String, Object> tourInfo = tourDAO.getCompleteTourInfo(tourID);
            return (List<NavigationPoint>) tourInfo.getOrDefault("navigationPoints", new ArrayList<>());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting navigation points for tour " + tourID, e);
            return new ArrayList<>();
        }
    }
    
    // Lấy danh sách hotspots của tour
    @SuppressWarnings("unchecked")
    public List<TourHotspot> getHotspotsByTour(int tourID) {
        try {
            Map<String, Object> tourInfo = tourDAO.getCompleteTourInfo(tourID);
            return (List<TourHotspot>) tourInfo.getOrDefault("hotspots", new ArrayList<>());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting hotspots for tour " + tourID, e);
            return new ArrayList<>();
        }
    }
    
    // Lấy cài đặt tour
    @SuppressWarnings("unchecked")
    public List<TourSetting> getTourSettings(int tourID) {
        try {
            Map<String, Object> tourInfo = tourDAO.getCompleteTourInfo(tourID);
            return (List<TourSetting>) tourInfo.getOrDefault("settings", new ArrayList<>());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting tour settings for tour " + tourID, e);
            return new ArrayList<>();
        }
    }
    
    // Lấy giá trị cài đặt cụ thể
    public String getTourSettingValue(int tourID, String settingKey) {
        try {
            List<TourSetting> settings = getTourSettings(tourID);
            for (TourSetting setting : settings) {
                if (settingKey.equals(setting.getSettingKey())) {
                    return setting.getSettingValue();
                }
            }
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting tour setting value", e);
            return null;
        }
    }
    
    // Lấy giá trị boolean của cài đặt
    public boolean getTourSettingBoolean(int tourID, String settingKey) {
        String value = getTourSettingValue(tourID, settingKey);
        return "true".equalsIgnoreCase(value);
    }
    
    // Lấy giá trị số của cài đặt
    public int getTourSettingInt(int tourID, String settingKey) {
        try {
            String value = getTourSettingValue(tourID, settingKey);
            return value != null ? Integer.parseInt(value) : 0;
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid integer value for setting " + settingKey);
            return 0;
        }
    }
    
    // Lấy giá trị double của cài đặt
    public double getTourSettingDouble(int tourID, String settingKey) {
        try {
            String value = getTourSettingValue(tourID, settingKey);
            return value != null ? Double.parseDouble(value) : 0.0;
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid double value for setting " + settingKey);
            return 0.0;
        }
    }
    
    // Tạo tour mẫu cho làng
    public int createSampleTour(int villageID, String villageName) {
        try {
            // Tạo tour
            Tour tour = new Tour();
            tour.setVillageID(villageID);
            tour.setTourName("Tour 360° " + villageName);
            tour.setDescription("Khám phá " + villageName + " qua công nghệ 360°");
            tour.setCreatedBy(1); // Admin user
            
            int tourID = createTour(tour);
            if (tourID <= 0) {
                return -1;
            }
            
            // Tạo panorama mẫu
            Panorama panorama1 = new Panorama();
            panorama1.setTourID(tourID);
            panorama1.setPanoramaName("Cổng làng " + villageName);
            panorama1.setImageUrl("/CraftVillage/hinhanh/panorama/" + villageID + "_1.jpg");
            panorama1.setDescription("Cổng làng truyền thống " + villageName);
            panorama1.setOrderIndex(0);
            panorama1.setStartPoint(true);
            
            int panorama1ID = addPanorama(panorama1);
            if (panorama1ID <= 0) {
                return -1;
            }
            
            Panorama panorama2 = new Panorama();
            panorama2.setTourID(tourID);
            panorama2.setPanoramaName("Xưởng sản xuất");
            panorama2.setImageUrl("/CraftVillage/hinhanh/panorama/" + villageID + "_2.jpg");
            panorama2.setDescription("Xưởng sản xuất truyền thống");
            panorama2.setOrderIndex(1);
            panorama2.setStartPoint(false);
            
            int panorama2ID = addPanorama(panorama2);
            if (panorama2ID <= 0) {
                return -1;
            }
            
            // Tạo navigation points
            NavigationPoint nav1 = new NavigationPoint();
            nav1.setPanoramaID(panorama1ID);
            nav1.setTargetPanoramaID(panorama2ID);
            nav1.setX(0.5f);
            nav1.setY(0.5f);
            nav1.setDescription("Chuyển đến xưởng sản xuất");
            nav1.setNavigationType("scene");
            nav1.setIconClass("fa-arrow-right");
            
            addNavigationPoint(nav1);
            
            NavigationPoint nav2 = new NavigationPoint();
            nav2.setPanoramaID(panorama2ID);
            nav2.setTargetPanoramaID(panorama1ID);
            nav2.setX(0.5f);
            nav2.setY(0.5f);
            nav2.setDescription("Quay lại cổng làng");
            nav2.setNavigationType("scene");
            nav2.setIconClass("fa-arrow-left");
            
            addNavigationPoint(nav2);
            
            // Tạo hotspots
            TourHotspot hotspot1 = new TourHotspot();
            hotspot1.setPanoramaID(panorama1ID);
            hotspot1.setX(0.3f);
            hotspot1.setY(0.4f);
            hotspot1.setTitle("Lịch sử " + villageName);
            hotspot1.setDescription("Lịch sử hình thành và phát triển của " + villageName);
            hotspot1.setHotspotType("info");
            hotspot1.setIconClass("fa-info-circle");
            
            addTourHotspot(hotspot1);
            
            TourHotspot hotspot2 = new TourHotspot();
            hotspot2.setPanoramaID(panorama2ID);
            hotspot2.setX(0.7f);
            hotspot2.setY(0.6f);
            hotspot2.setTitle("Cửa hàng");
            hotspot2.setDescription("Xem và mua sản phẩm của " + villageName);
            hotspot2.setHotspotType("shop");
            hotspot2.setIconClass("fa-shopping-cart");
            
            addTourHotspot(hotspot2);
            
            return tourID;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating sample tour for village " + villageID, e);
            return -1;
        }
    }
} 
