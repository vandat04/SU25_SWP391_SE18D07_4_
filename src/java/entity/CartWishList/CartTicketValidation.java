package entity.CartWishList;

import java.util.ArrayList;
import java.util.List;

/**
 * Manages ticket availability validation results for an entire cart
 */
public class CartTicketValidation {
    private List<CartTicketItemValidation> validTickets;
    private List<CartTicketItemValidation> invalidTickets;
    private boolean hasSoldOutTickets;
    private boolean hasLimitedAvailabilityTickets;
    private boolean hasDateIssues;
    
    public CartTicketValidation() {
        this.validTickets = new ArrayList<>();
        this.invalidTickets = new ArrayList<>();
        this.hasSoldOutTickets = false;
        this.hasLimitedAvailabilityTickets = false;
        this.hasDateIssues = false;
    }
    
    public void addValidTicket(CartTicket ticket, TicketValidationResult result) {
        validTickets.add(new CartTicketItemValidation(ticket, result));
    }
    
    public void addInvalidTicket(CartTicket ticket, TicketValidationResult result) {
        invalidTickets.add(new CartTicketItemValidation(ticket, result));
        
        if (result.isFullyBooked()) {
            hasSoldOutTickets = true;
        } else if (result.getAvailableSlots() > 0 && result.getAvailableSlots() < ticket.getQuantity()) {
            // Fixed: Check availability vs quantity directly, not hasLimitedAvailability()
            hasLimitedAvailabilityTickets = true;
        }
        
        // Check for date-related issues (past dates, too far in future)
        if (result.getMessage() != null && result.getMessage().contains("date")) {
            hasDateIssues = true;
        }
    }
    
    public List<CartTicketItemValidation> getValidTickets() {
        return validTickets;
    }
    
    public List<CartTicketItemValidation> getInvalidTickets() {
        return invalidTickets;
    }
    
    public boolean hasSoldOutTickets() {
        return hasSoldOutTickets;
    }
    
    public boolean hasLimitedAvailabilityTickets() {
        return hasLimitedAvailabilityTickets;
    }
    
    public boolean hasDateIssues() {
        return hasDateIssues;
    }
    
    public boolean hasAnyTicketIssues() {
        return hasSoldOutTickets || hasLimitedAvailabilityTickets || hasDateIssues;
    }
    
    public boolean isCartTicketsValid() {
        return invalidTickets.isEmpty();
    }
    
    public int getSoldOutTicketCount() {
        return (int) invalidTickets.stream()
                .filter(ticket -> ticket.getResult().isFullyBooked())
                .count();
    }
    
    public int getLimitedAvailabilityTicketCount() {
        return (int) invalidTickets.stream()
                .filter(ticket -> ticket.getResult().getAvailableSlots() > 0 && 
                                 ticket.getResult().getAvailableSlots() < ticket.getTicket().getQuantity())
                .count();
    }
    
    public int getDateIssueTicketCount() {
        return (int) invalidTickets.stream()
                .filter(ticket -> ticket.getResult().getMessage() != null && 
                                 ticket.getResult().getMessage().contains("date"))
                .count();
    }
    
    /**
     * Get summary message for ticket validation
     */
    public String getTicketValidationSummary() {
        if (isCartTicketsValid()) {
            return "Tất cả vé đều có sẵn";
        }
        
        List<String> issues = new ArrayList<>();
        
        if (hasSoldOutTickets) {
            issues.add(getSoldOutTicketCount() + " loại vé đã hết");
        }
        
        if (hasLimitedAvailabilityTickets) {
            issues.add(getLimitedAvailabilityTicketCount() + " loại vé không đủ số lượng");
        }
        
        if (hasDateIssues) {
            issues.add(getDateIssueTicketCount() + " vé có vấn đề về ngày");
        }
        
        return String.join(", ", issues);
    }
    
    /**
     * Get detailed messages for each invalid ticket
     */
    public List<String> getDetailedIssues() {
        List<String> details = new ArrayList<>();
        
        for (CartTicketItemValidation invalid : invalidTickets) {
            CartTicket ticket = invalid.getTicket();
            TicketValidationResult result = invalid.getResult();
            
            String detail = String.format("Vé %s ngày %s: %s", 
                ticket.getTicketTypeName(), 
                ticket.getFormattedTicketDate(), 
                result.getMessage());
            details.add(detail);
        }
        
        return details;
    }
    
    /**
     * Calculate total affected ticket quantity
     */
    public int getTotalAffectedTicketQuantity() {
        return invalidTickets.stream()
                .mapToInt(item -> item.getTicket().getQuantity())
                .sum();
    }
    
    /**
     * Check if any tickets need quantity adjustment
     */
    public boolean hasTicketsNeedingAdjustment() {
        return invalidTickets.stream()
                .anyMatch(item -> item.getResult().getAvailableSlots() > 0 && 
                                 item.getResult().getAvailableSlots() < item.getTicket().getQuantity());
    }
    
    /**
     * Inner class to hold cart ticket and its validation result
     */
    public static class CartTicketItemValidation {
        private CartTicket ticket;
        private TicketValidationResult result;
        
        public CartTicketItemValidation(CartTicket ticket, TicketValidationResult result) {
            this.ticket = ticket;
            this.result = result;
        }
        
        public CartTicket getTicket() {
            return ticket;
        }
        
        public TicketValidationResult getResult() {
            return result;
        }
        
        public boolean canBeAdjusted() {
            return result.getAvailableSlots() > 0 && 
                   result.getAvailableSlots() < ticket.getQuantity();
        }
        
        public boolean shouldBeRemoved() {
            return result.isFullyBooked() || 
                   (result.getMessage() != null && result.getMessage().contains("date"));
        }
    }
} 