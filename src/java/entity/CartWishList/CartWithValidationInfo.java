package entity.CartWishList;

/**
 * Combines cart information with both product stock and ticket availability validation results
 */
public class CartWithValidationInfo {
    private Cart cart;
    private CartStockValidation stockValidation;
    private CartTicketValidation ticketValidation;
    
    public CartWithValidationInfo(Cart cart, CartStockValidation stockValidation, CartTicketValidation ticketValidation) {
        this.cart = cart;
        this.stockValidation = stockValidation;
        this.ticketValidation = ticketValidation;
    }
    
    public Cart getCart() {
        return cart;
    }
    
    public void setCart(Cart cart) {
        this.cart = cart;
    }
    
    public CartStockValidation getStockValidation() {
        return stockValidation;
    }
    
    public void setStockValidation(CartStockValidation stockValidation) {
        this.stockValidation = stockValidation;
    }
    
    public CartTicketValidation getTicketValidation() {
        return ticketValidation;
    }
    
    public void setTicketValidation(CartTicketValidation ticketValidation) {
        this.ticketValidation = ticketValidation;
    }
    
    public boolean hasCart() {
        return cart != null;
    }
    
    public boolean hasProductStockIssues() {
        return stockValidation != null && stockValidation.hasAnyStockIssues();
    }
    
    public boolean hasTicketAvailabilityIssues() {
        return ticketValidation != null && ticketValidation.hasAnyTicketIssues();
    }
    
    public boolean hasAnyIssues() {
        return hasProductStockIssues() || hasTicketAvailabilityIssues();
    }
    
    public boolean isCartFullyValid() {
        boolean stockValid = stockValidation == null || stockValidation.isCartValid();
        boolean ticketValid = ticketValidation == null || ticketValidation.isCartTicketsValid();
        return stockValid && ticketValid;
    }
    
    public String getComprehensiveValidationSummary() {
        if (isCartFullyValid()) {
            return "Giỏ hàng không có vấn đề gì";
        }
        
        StringBuilder summary = new StringBuilder();
        
        if (hasProductStockIssues()) {
            summary.append("Sản phẩm: ").append(stockValidation.getValidationSummary());
        }
        
        if (hasTicketAvailabilityIssues()) {
            if (summary.length() > 0) {
                summary.append(" | ");
            }
            summary.append("Vé: ").append(ticketValidation.getTicketValidationSummary());
        }
        
        return summary.toString();
    }
    
    public int getTotalIssueCount() {
        int stockIssues = stockValidation != null ? stockValidation.getInvalidItems().size() : 0;
        int ticketIssues = ticketValidation != null ? ticketValidation.getInvalidTickets().size() : 0;
        return stockIssues + ticketIssues;
    }
    
    public boolean canProceedToCheckout() {
        return isCartFullyValid();
    }
    
    public String getCheckoutBlockingReason() {
        if (canProceedToCheckout()) {
            return null;
        }
        
        StringBuilder reason = new StringBuilder("Không thể thanh toán do: ");
        reason.append(getComprehensiveValidationSummary());
        return reason.toString();
    }
    
    /**
     * Get priority level of issues (for UI display)
     * @return "high", "medium", "low", or "none"
     */
    public String getIssuePriority() {
        if (isCartFullyValid()) {
            return "none";
        }
        
        boolean hasOutOfStock = stockValidation != null && stockValidation.hasOutOfStockItems();
        boolean hasSoldOut = ticketValidation != null && ticketValidation.hasSoldOutTickets();
        boolean hasDateIssues = ticketValidation != null && ticketValidation.hasDateIssues();
        
        if (hasOutOfStock || hasSoldOut || hasDateIssues) {
            return "high";
        }
        
        boolean hasInsufficientStock = stockValidation != null && stockValidation.hasInsufficientStockItems();
        boolean hasLimitedTickets = ticketValidation != null && ticketValidation.hasLimitedAvailabilityTickets();
        
        if (hasInsufficientStock || hasLimitedTickets) {
            return "medium";
        }
        
        return "low";
    }
    
    @Override
    public String toString() {
        return "CartWithValidationInfo{" +
                "cart=" + (cart != null ? cart.getCartID() : "null") +
                ", hasProductIssues=" + hasProductStockIssues() +
                ", hasTicketIssues=" + hasTicketAvailabilityIssues() +
                ", totalIssues=" + getTotalIssueCount() +
                ", canCheckout=" + canProceedToCheckout() +
                ", priority=" + getIssuePriority() +
                '}';
    }
} 