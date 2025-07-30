package entity.CraftVillage;

import java.sql.Timestamp;

public class TourSetting {
    private int settingID;
    private int tourID;
    private String settingKey;
    private String settingValue;
    private String settingType;
    private String description;
    private Timestamp createdDate;
    private Timestamp updatedDate;

    // Constructor
    public TourSetting() {}

    public TourSetting(int settingID, int tourID, String settingKey, String settingValue, String settingType, String description, Timestamp createdDate, Timestamp updatedDate) {
        this.settingID = settingID;
        this.tourID = tourID;
        this.settingKey = settingKey;
        this.settingValue = settingValue;
        this.settingType = settingType;
        this.description = description;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Getters and Setters
    public int getSettingID() {
        return settingID;
    }

    public void setSettingID(int settingID) {
        this.settingID = settingID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }

    public String getSettingType() {
        return settingType;
    }

    public void setSettingType(String settingType) {
        this.settingType = settingType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    // Helper methods for different setting types
    public boolean getBooleanValue() {
        return "true".equalsIgnoreCase(settingValue);
    }

    public int getIntValue() {
        try {
            return Integer.parseInt(settingValue);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public double getDoubleValue() {
        try {
            return Double.parseDouble(settingValue);
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    @Override
    public String toString() {
        return "TourSetting{" + "settingID=" + settingID + ", tourID=" + tourID + ", settingKey=" + settingKey + ", settingValue=" + settingValue + ", settingType=" + settingType + ", description=" + description + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + '}';
    }

}
