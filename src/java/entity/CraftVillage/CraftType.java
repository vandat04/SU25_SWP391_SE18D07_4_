package entity.CraftVillage;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class CraftType {
    private int typeID;
    private String typeName;
    private String description;
    private int status; // 1: hoạt động, 0: ẩn
    private Timestamp createdDate;
    private Timestamp updatedDate;

    // Constructors-------------------------------------------------------------
    public CraftType() {}

    
    //--------------------------------------------------------------------------
    public int getTypeID() {
        return typeID;
    }

    public void setTypeID(int typeID) {
        this.typeID = typeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
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
        return "CraftType{" + "typeID=" + typeID + ", typeName=" + typeName + ", description=" + description + ", status=" + status + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + '}';
    }
} 