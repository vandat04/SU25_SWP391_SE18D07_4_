package entity.CartWishList;

/**
 * Combines cart information with stock validation results
 */
public class CartWithStockInfo {
    private Cart cart;
    private CartStockValidation stockValidation;
    
    public CartWithStockInfo(Cart cart, CartStockValidation stockValidation) {
        this.cart = cart;
        this.stockValidation = stockValidation;
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
    
    public boolean hasCart() {
        return cart != null;
    }
    
    public boolean hasStockIssues() {
        return stockValidation != null && stockValidation.hasAnyStockIssues();
    }
    
    public boolean isCartValid() {
        return stockValidation != null && stockValidation.isCartValid();
    }
    
    public String getStockValidationSummary() {
        return stockValidation != null ? stockValidation.getValidationSummary() : "Không có thông tin xác thực";
    }
    
    @Override
    public String toString() {
        return "CartWithStockInfo{" +
                "cart=" + (cart != null ? cart.getCartID() : "null") +
                ", hasStockIssues=" + hasStockIssues() +
                ", validationSummary='" + getStockValidationSummary() + '\'' +
                '}';
    }
} 