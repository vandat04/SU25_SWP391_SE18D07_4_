package service;

/**
 *
 * @author Pc
 */

import entity.CartWishList.Cart;
import entity.Product.Product;
import java.util.Date;
import entity.CartWishList.StockValidationResult;
import entity.CartWishList.CartStockValidation;
import entity.CartWishList.CartWithStockInfo;
import entity.CartWishList.CartItem;
import entity.CartWishList.TicketValidationResult;
import entity.CartWishList.CartTicketValidation;
import entity.CartWishList.CartWithValidationInfo;
import entity.CartWishList.CartTicket;

public interface ICartService {
    // ===== PRODUCT CART METHODS =====
    void addToCart(Cart cart, Product product, int quantity);
    void updateCartItem(Cart cart, int productId, int quantity);
    void removeCartItem(Cart cart, int productId);
    double getTotalPrice(Cart cart);
    double calculateTotalWithDiscount(Cart cart);
    double calculateTotalDiscount(Cart cart);
    void applyDiscount(Cart cart, String discountCode);
    void clearCart(int userId);

    // ===== NEW METHODS FOR CONTROLLER LAYER =====
    /**
     * Get cart by user ID - replaces direct DAO call in Controller
     */
    Cart getCartByUser(int userId);
    
    /**
     * Get or create cart for user - handles cart creation logic
     */
    Cart getOrCreateCart(int userId);
    
    /**
     * Add product to cart using user ID and product ID
     */
    boolean addProductToCart(int userId, int productId, int quantity);
    
    /**
     * Update cart item quantity using user ID
     */
    boolean updateCartItemQuantity(int userId, int productId, int quantity);
    
    /**
     * Remove cart item using user ID
     */
    boolean removeCartItemByUser(int userId, int productId);

    // ===== STOCK VALIDATION METHODS =====
    /**
     * Get current stock level for a product
     */
    int getCurrentStock(int productId);
    
    /**
     * Check if product is currently available
     */
    boolean isProductAvailable(int productId);
    
    /**
     * Validate stock for a specific cart item
     */
    StockValidationResult validateCartItemStock(CartItem item);
    
    /**
     * Validate stock for all items in cart
     */
    CartStockValidation validateCartStock(Cart cart);
    
    /**
     * Get cart with stock validation
     */
    CartWithStockInfo getCartWithStockValidation(int userId);
    
    /**
     * Remove out-of-stock items from cart
     */
    boolean removeOutOfStockItems(int userId);
    
    /**
     * Auto-adjust quantities for items with insufficient stock
     */
    boolean autoAdjustQuantities(int userId);

    // ===== TICKET METHODS =====
    void addTicketToCart(Cart cart, int ticketId, Date ticketDate, int quantity);
    void updateTicketInCart(Cart cart, int cartTicketId, int quantity);
    void removeTicketFromCart(Cart cart, int cartTicketId);
    
    /**
     * Add ticket to cart using user ID
     */
    boolean addTicketToCartByUser(int userId, int ticketId, Date ticketDate, int quantity);
    
    /**
     * Update ticket in cart using user ID
     */
    boolean updateTicketQuantityByUser(int userId, int cartTicketId, int quantity);
    
    /**
     * Remove ticket from cart using user ID
     */
    boolean removeTicketByUser(int userId, int cartTicketId);

    // ===== TICKET VALIDATION METHODS =====
    /**
     * Get current available slots for a ticket on specific date
     */
    int getCurrentAvailableSlots(int ticketId, Date ticketDate);
    
    /**
     * Check if ticket is available on specific date
     */
    boolean isTicketAvailable(int ticketId, Date ticketDate, int quantity);
    
    /**
     * Validate availability for a specific cart ticket
     */
    TicketValidationResult validateCartTicketAvailability(CartTicket ticket);
    
    /**
     * Validate availability for all tickets in cart
     */
    CartTicketValidation validateCartTickets(Cart cart);
    
    /**
     * Get cart with comprehensive validation (both products and tickets)
     */
    CartWithValidationInfo getCartWithComprehensiveValidation(int userId);
    
    /**
     * Remove sold-out tickets from cart
     */
    boolean removeSoldOutTickets(int userId);
    
    /**
     * Auto-adjust ticket quantities to available slots
     */
    boolean autoAdjustTicketQuantities(int userId);
}