package entity.CraftVillage;

import java.sql.Timestamp;

public class TourHotspot {
    private int hotspotID;
    private int panoramaID;
    private float x;
    private float y;
    private Float yaw;
    private Float pitch;
    private String title;
    private String description;
    private String hotspotType;
    private String targetUrl;
    private String iconClass;
    private Integer productID;
    private int status;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    
    // Additional fields for display purposes
    private String productName;
    private Double productPrice;
    private String productImageUrl;
    
    // Constructor
    public TourHotspot() {}
    
    public TourHotspot(int hotspotID, int panoramaID, float x, float y, Float yaw, Float pitch, String title, String description, String hotspotType, String targetUrl, String iconClass, Integer productID, int status, Timestamp createdDate, Timestamp updatedDate) {
        this.hotspotID = hotspotID;
        this.panoramaID = panoramaID;
        this.x = x;
        this.y = y;
        this.yaw = yaw;
        this.pitch = pitch;
        this.title = title;
        this.description = description;
        this.hotspotType = hotspotType;
        this.targetUrl = targetUrl;
        this.iconClass = iconClass;
        this.productID = productID;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }
    
    // Getters and Setters
    public int getHotspotID() {
        return hotspotID;
    }
    
    public void setHotspotID(int hotspotID) {
        this.hotspotID = hotspotID;
    }
    
    public int getPanoramaID() {
        return panoramaID;
    }
    
    public void setPanoramaID(int panoramaID) {
        this.panoramaID = panoramaID;
    }
    
    public float getX() {
        return x;
    }
    
    public void setX(float x) {
        this.x = x;
    }
    
    public float getY() {
        return y;
    }
    
    public void setY(float y) {
        this.y = y;
    }
    
    public Float getYaw() {
        return yaw;
    }
    
    public void setYaw(Float yaw) {
        this.yaw = yaw;
    }
    
    public Float getPitch() {
        return pitch;
    }
    
    public void setPitch(Float pitch) {
        this.pitch = pitch;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getHotspotType() {
        return hotspotType;
    }
    
    public void setHotspotType(String hotspotType) {
        this.hotspotType = hotspotType;
    }
    
    public String getTargetUrl() {
        return targetUrl;
    }
    
    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }
    
    public String getIconClass() {
        return iconClass;
    }
    
    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }
    
    public Integer getProductID() {
        return productID;
    }
    
    public void setProductID(Integer productID) {
        this.productID = productID;
    }
    
    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
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
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public Double getProductPrice() {
        return productPrice;
    }
    
    public void setProductPrice(Double productPrice) {
        this.productPrice = productPrice;
    }
    
    public String getProductImageUrl() {
        return productImageUrl;
    }
    
    public void setProductImageUrl(String productImageUrl) {
        this.productImageUrl = productImageUrl;
    }
    
    @Override
    public String toString() {
        return "TourHotspot{" +
                "hotspotID=" + hotspotID +
                ", panoramaID=" + panoramaID +
                ", x=" + x +
                ", y=" + y +
                ", yaw=" + yaw +
                ", pitch=" + pitch +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", hotspotType='" + hotspotType + '\'' +
                ", targetUrl='" + targetUrl + '\'' +
                ", iconClass='" + iconClass + '\'' +
                ", productID=" + productID +
                ", status=" + status +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                ", productName='" + productName + '\'' +
                ", productPrice=" + productPrice +
                ", productImageUrl='" + productImageUrl + '\'' +
                '}';
    }
} 
