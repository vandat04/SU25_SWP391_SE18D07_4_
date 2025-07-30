package entity.CraftVillage;

import java.sql.Timestamp;

public class Panorama {
    private int panoramaID;
    private int tourID;
    private String panoramaName;
    private String imageUrl;
    private String description;
    private int orderIndex;
    private boolean isStartPoint;
    private int status;
    private Timestamp createdDate;
    private Timestamp updatedDate;

    // Constructor
    public Panorama() {}

    public Panorama(int panoramaID, int tourID, String panoramaName, String imageUrl, String description, int orderIndex, boolean isStartPoint, int status, Timestamp createdDate, Timestamp updatedDate) {
        this.panoramaID = panoramaID;
        this.tourID = tourID;
        this.panoramaName = panoramaName;
        this.imageUrl = imageUrl;
        this.description = description;
        this.orderIndex = orderIndex;
        this.isStartPoint = isStartPoint;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Getters and Setters
    public int getPanoramaID() {
        return panoramaID;
    }

    public void setPanoramaID(int panoramaID) {
        this.panoramaID = panoramaID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public String getPanoramaName() {
        return panoramaName;
    }

    public void setPanoramaName(String panoramaName) {
        this.panoramaName = panoramaName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public boolean isStartPoint() {
        return isStartPoint;
    }

    public void setStartPoint(boolean startPoint) {
        isStartPoint = startPoint;
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

    @Override
    public String toString() {
        return "Panorama{" + "panoramaID=" + panoramaID + ", tourID=" + tourID + ", panoramaName=" + panoramaName + ", imageUrl=" + imageUrl + ", description=" + description + ", orderIndex=" + orderIndex + ", isStartPoint=" + isStartPoint + ", status=" + status + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + '}';
    }

   
}