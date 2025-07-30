package entity.CraftVillage;

import java.sql.Timestamp;

public class Tour {
    private int tourID;
    private int villageID;
    private String tourName;
    private String description;
    private int status;
    private boolean isDefault;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private Integer createdBy;

    // Constructor
    public Tour() {}

    public Tour(int tourID, int villageID, String tourName, String description, int status, boolean isDefault, Timestamp createdDate, Timestamp updatedDate, Integer createdBy) {
        this.tourID = tourID;
        this.villageID = villageID;
        this.tourName = tourName;
        this.description = description;
        this.status = status;
        this.isDefault = isDefault;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.createdBy = createdBy;
    }

    // Getters and Setters
    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getVillageID() {
        return villageID;
    }

    public void setVillageID(int villageID) {
        this.villageID = villageID;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
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

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "Tour{" + "tourID=" + tourID + ", villageID=" + villageID + ", tourName=" + tourName + ", description=" + description + ", status=" + status + ", isDefault=" + isDefault + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + ", createdBy=" + createdBy + '}';
    }

  
}