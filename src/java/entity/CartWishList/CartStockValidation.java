package entity.CartWishList;

import java.util.ArrayList;
import java.util.List;

/**
 * Manages stock validation results for an entire cart
 */
public class CartStockValidation {
    private List<CartItemValidation> validItems;
    private List<CartItemValidation> invalidItems;
    private boolean hasOutOfStockItems;
    private boolean hasInsufficientStockItems;
    
    public CartStockValidation() {
        this.validItems = new ArrayList<>();
        this.invalidItems = new ArrayList<>();
        this.hasOutOfStockItems = false;
        this.hasInsufficientStockItems = false;
    }
    
    public void addValidItem(CartItem item, StockValidationResult result) {
        validItems.add(new CartItemValidation(item, result));
    }
    
    public void addInvalidItem(CartItem item, StockValidationResult result) {
        invalidItems.add(new CartItemValidation(item, result));
        
        if (result.getAvailableStock() == 0) {
            hasOutOfStockItems = true;
        } else if (result.getAvailableStock() < item.getQuantity()) {
            hasInsufficientStockItems = true;
        }
    }
    
    public List<CartItemValidation> getValidItems() {
        return validItems;
    }
    
    public List<CartItemValidation> getInvalidItems() {
        return invalidItems;
    }
    
    public boolean hasOutOfStockItems() {
        return hasOutOfStockItems;
    }
    
    public boolean hasInsufficientStockItems() {
        return hasInsufficientStockItems;
    }
    
    public boolean hasAnyStockIssues() {
        return hasOutOfStockItems || hasInsufficientStockItems;
    }
    
    public boolean isCartValid() {
        return invalidItems.isEmpty();
    }
    
    public int getOutOfStockCount() {
        return (int) invalidItems.stream()
                .filter(item -> item.getResult().getAvailableStock() == 0)
                .count();
    }
    
    public int getInsufficientStockCount() {
        return (int) invalidItems.stream()
                .filter(item -> item.getResult().getAvailableStock() > 0 && 
                               item.getResult().getAvailableStock() < item.getItem().getQuantity())
                .count();
    }
    
    /**
     * Get summary message for stock validation
     */
    public String getValidationSummary() {
        if (isCartValid()) {
            return "Tất cả sản phẩm đều có sẵn";
        }
        
        StringBuilder summary = new StringBuilder();
        
        if (hasOutOfStockItems) {
            summary.append(getOutOfStockCount()).append(" sản phẩm đã hết hàng");
        }
        
        if (hasInsufficientStockItems) {
            if (summary.length() > 0) {
                summary.append(", ");
            }
            summary.append(getInsufficientStockCount()).append(" sản phẩm không đủ số lượng");
        }
        
        return summary.toString();
    }
    
    /**
     * Inner class to hold cart item and its validation result
     */
    public static class CartItemValidation {
        private CartItem item;
        private StockValidationResult result;
        
        public CartItemValidation(CartItem item, StockValidationResult result) {
            this.item = item;
            this.result = result;
        }
        
        public CartItem getItem() {
            return item;
        }
        
        public StockValidationResult getResult() {
            return result;
        }
    }
} 