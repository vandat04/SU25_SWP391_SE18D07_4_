package entity.CartWishList;

import java.util.Date;

/**
 * Represents the result of ticket availability validation for a cart ticket item
 */
public class TicketValidationResult {
    private boolean valid;
    private int availableSlots;
    private int totalSlots;
    private String message;
    private Date ticketDate;
    private int ticketId;
    
    public TicketValidationResult(boolean valid, int availableSlots, int totalSlots, String message) {
        this.valid = valid;
        this.availableSlots = availableSlots;
        this.totalSlots = totalSlots;
        this.message = message;
    }
    
    public TicketValidationResult(boolean valid, int availableSlots, int totalSlots, String message, Date ticketDate, int ticketId) {
        this(valid, availableSlots, totalSlots, message);
        this.ticketDate = ticketDate;
        this.ticketId = ticketId;
    }
    
    public boolean isValid() {
        return valid;
    }
    
    public void setValid(boolean valid) {
        this.valid = valid;
    }
    
    public int getAvailableSlots() {
        return availableSlots;
    }
    
    public void setAvailableSlots(int availableSlots) {
        this.availableSlots = availableSlots;
    }
    
    public int getTotalSlots() {
        return totalSlots;
    }
    
    public void setTotalSlots(int totalSlots) {
        this.totalSlots = totalSlots;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Date getTicketDate() {
        return ticketDate;
    }
    
    public void setTicketDate(Date ticketDate) {
        this.ticketDate = ticketDate;
    }
    
    public int getTicketId() {
        return ticketId;
    }
    
    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }
    
    public boolean isFullyBooked() {
        return availableSlots == 0;
    }
    
    public boolean hasLimitedAvailability() {
        return availableSlots > 0 && availableSlots < totalSlots;
    }
    
    public double getOccupancyRate() {
        if (totalSlots <= 0) return 0.0;
        return ((double)(totalSlots - availableSlots) / totalSlots) * 100;
    }
    
    public String getAvailabilityStatus() {
        if (isFullyBooked()) {
            return "SOLD_OUT";
        } else if (availableSlots <= 5) {
            return "LIMITED";
        } else {
            return "AVAILABLE";
        }
    }
    
    @Override
    public String toString() {
        return "TicketValidationResult{" +
                "valid=" + valid +
                ", availableSlots=" + availableSlots +
                ", totalSlots=" + totalSlots +
                ", message='" + message + '\'' +
                ", ticketDate=" + ticketDate +
                ", ticketId=" + ticketId +
                ", occupancyRate=" + String.format("%.1f%%", getOccupancyRate()) +
                '}';
    }
} 