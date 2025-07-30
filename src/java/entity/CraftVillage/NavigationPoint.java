package entity.CraftVillage;

import java.sql.Timestamp;

public class NavigationPoint {
    private int navigationID;
    private int panoramaID;
    private int targetPanoramaID;
    private float x;
    private float y;
    private Float yaw;
    private Float pitch;
    private String description;
    private String navigationType;
    private String targetUrl;
    private String iconClass;
    private int status;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    
    // Additional fields for display purposes
    private String sourcePanoramaName;
    private String targetPanoramaName;
    
    // Constructor
    public NavigationPoint() {}
    
    public NavigationPoint(int navigationID, int panoramaID, int targetPanoramaID, float x, float y, Float yaw, Float pitch, String description, String navigationType, String targetUrl, String iconClass, int status, Timestamp createdDate, Timestamp updatedDate) {
        this.navigationID = navigationID;
        this.panoramaID = panoramaID;
        this.targetPanoramaID = targetPanoramaID;
        this.x = x;
        this.y = y;
        this.yaw = yaw;
        this.pitch = pitch;
        this.description = description;
        this.navigationType = navigationType;
        this.targetUrl = targetUrl;
        this.iconClass = iconClass;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }
    
    // Getters and Setters
    public int getNavigationID() {
        return navigationID;
    }
    
    public void setNavigationID(int navigationID) {
        this.navigationID = navigationID;
    }
    
    public int getPanoramaID() {
        return panoramaID;
    }
    
    public void setPanoramaID(int panoramaID) {
        this.panoramaID = panoramaID;
    }
    
    public int getTargetPanoramaID() {
        return targetPanoramaID;
    }
    
    public void setTargetPanoramaID(int targetPanoramaID) {
        this.targetPanoramaID = targetPanoramaID;
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
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getNavigationType() {
        return navigationType;
    }
    
    public void setNavigationType(String navigationType) {
        this.navigationType = navigationType;
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
    
    public String getSourcePanoramaName() {
        return sourcePanoramaName;
    }
    
    public void setSourcePanoramaName(String sourcePanoramaName) {
        this.sourcePanoramaName = sourcePanoramaName;
    }
    
    public String getTargetPanoramaName() {
        return targetPanoramaName;
    }
    
    public void setTargetPanoramaName(String targetPanoramaName) {
        this.targetPanoramaName = targetPanoramaName;
    }
    
    @Override
    public String toString() {
        return "NavigationPoint{" +
                "navigationID=" + navigationID +
                ", panoramaID=" + panoramaID +
                ", targetPanoramaID=" + targetPanoramaID +
                ", x=" + x +
                ", y=" + y +
                ", yaw=" + yaw +
                ", pitch=" + pitch +
                ", description='" + description + '\'' +
                ", navigationType='" + navigationType + '\'' +
                ", targetUrl='" + targetUrl + '\'' +
                ", iconClass='" + iconClass + '\'' +
                ", status=" + status +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                ", sourcePanoramaName='" + sourcePanoramaName + '\'' +
                ", targetPanoramaName='" + targetPanoramaName + '\'' +
                '}';
    }
} 