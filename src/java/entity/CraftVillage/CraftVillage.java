package entity.CraftVillage;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class CraftVillage {
    private int villageID;
    private Integer typeID;
    private String villageName;
    private String description;
    private String address;
    private Double latitude;
    private Double longitude;
    private String contactPhone;
    private String contactEmail;
    private int status; // 0: ẩn, 1: hoạt động, 2: đang duyệt
    private int clickCount;
    private Timestamp lastClicked;
    private String mainImageUrl;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private Integer sellerId;
    private String openingHours;
    private String closingDays;
    private BigDecimal averageRating; // decimal(3,2)
    private int totalReviews;
    private String mapEmbedUrl;
    private String virtualTourUrl;
    private String history;
    private String specialFeatures;
    private String famousProducts;
    private String culturalEvents;
    private String craftProcess;
    private String videoDescriptionUrl;
    private String travelTips;

    //Constructor --------------------------------------------------------------
    public CraftVillage() {
    }
    
    
    //--------------------------------------------------------------------------

    public int getVillageID() {
        return villageID;
    }

    public void setVillageID(int villageID) {
        this.villageID = villageID;
    }

    public Integer getTypeID() {
        return typeID;
    }

    public void setTypeID(Integer typeID) {
        this.typeID = typeID;
    }

    public String getVillageName() {
        return villageName;
    }

    public void setVillageName(String villageName) {
        this.villageName = villageName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getClickCount() {
        return clickCount;
    }

    public void setClickCount(int clickCount) {
        this.clickCount = clickCount;
    }

    public Timestamp getLastClicked() {
        return lastClicked;
    }

    public void setLastClicked(Timestamp lastClicked) {
        this.lastClicked = lastClicked;
    }

    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    public Integer getSellerId() {
        return sellerId;
    }

    public void setSellerId(Integer sellerId) {
        this.sellerId = sellerId;
    }

    public String getOpeningHours() {
        return openingHours;
    }

    public void setOpeningHours(String openingHours) {
        this.openingHours = openingHours;
    }

    public String getClosingDays() {
        return closingDays;
    }

    public void setClosingDays(String closingDays) {
        this.closingDays = closingDays;
    }

    public BigDecimal getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(BigDecimal averageRating) {
        this.averageRating = averageRating;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public String getMapEmbedUrl() {
        return mapEmbedUrl;
    }

    public void setMapEmbedUrl(String mapEmbedUrl) {
        this.mapEmbedUrl = mapEmbedUrl;
    }

    public String getVirtualTourUrl() {
        return virtualTourUrl;
    }

    public void setVirtualTourUrl(String virtualTourUrl) {
        this.virtualTourUrl = virtualTourUrl;
    }

    public String getHistory() {
        return history;
    }

    public void setHistory(String history) {
        this.history = history;
    }

    public String getSpecialFeatures() {
        return specialFeatures;
    }

    public void setSpecialFeatures(String specialFeatures) {
        this.specialFeatures = specialFeatures;
    }

    public String getFamousProducts() {
        return famousProducts;
    }

    public void setFamousProducts(String famousProducts) {
        this.famousProducts = famousProducts;
    }

    public String getCulturalEvents() {
        return culturalEvents;
    }

    public void setCulturalEvents(String culturalEvents) {
        this.culturalEvents = culturalEvents;
    }

    public String getCraftProcess() {
        return craftProcess;
    }

    public void setCraftProcess(String craftProcess) {
        this.craftProcess = craftProcess;
    }

    public String getVideoDescriptionUrl() {
        return videoDescriptionUrl;
    }

    public void setVideoDescriptionUrl(String videoDescriptionUrl) {
        this.videoDescriptionUrl = videoDescriptionUrl;
    }

    public String getTravelTips() {
        return travelTips;
    }

    public void setTravelTips(String travelTips) {
        this.travelTips = travelTips;
    }

    @Override
    public String toString() {
        return "CraftVillage{" + "villageID=" + villageID + ", typeID=" + typeID + ", villageName=" + villageName + ", description=" + description + ", address=" + address + ", latitude=" + latitude + ", longitude=" + longitude + ", contactPhone=" + contactPhone + ", contactEmail=" + contactEmail + ", status=" + status + ", clickCount=" + clickCount + ", lastClicked=" + lastClicked + ", mainImageUrl=" + mainImageUrl + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + ", sellerId=" + sellerId + ", openingHours=" + openingHours + ", closingDays=" + closingDays + ", averageRating=" + averageRating + ", totalReviews=" + totalReviews + ", mapEmbedUrl=" + mapEmbedUrl + ", virtualTourUrl=" + virtualTourUrl + ", history=" + history + ", specialFeatures=" + specialFeatures + ", famousProducts=" + famousProducts + ", culturalEvents=" + culturalEvents + ", craftProcess=" + craftProcess + ", videoDescriptionUrl=" + videoDescriptionUrl + ", travelTips=" + travelTips + '}';
    }
    
    
} 