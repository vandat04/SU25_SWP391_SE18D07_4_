package entity.CartWishList;

/**
 * Represents the result of stock validation for a cart item
 */
public class StockValidationResult {
    private boolean valid;
    private int availableStock;
    private String message;
    
    public StockValidationResult(boolean valid, int availableStock, String message) {
        this.valid = valid;
        this.availableStock = availableStock;
        this.message = message;
    }
    
    public boolean isValid() {
        return valid;
    }
    
    public void setValid(boolean valid) {
        this.valid = valid;
    }
    
    public int getAvailableStock() {
        return availableStock;
    }
    
    public void setAvailableStock(int availableStock) {
        this.availableStock = availableStock;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    @Override
    public String toString() {
        return "StockValidationResult{" +
                "valid=" + valid +
                ", availableStock=" + availableStock +
                ", message='" + message + '\'' +
                '}';
    }
} 