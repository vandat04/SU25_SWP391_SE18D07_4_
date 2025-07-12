/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import entity.CartWishList.Cart;
import entity.Product.Product;
import DAO.CartDAO;
import entity.CartWishList.CartItem;
import DAO.CartTicketDAO;
import entity.CartWishList.CartTicket;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import entity.CartWishList.StockValidationResult;
import entity.CartWishList.CartStockValidation;
import entity.CartWishList.CartWithStockInfo;
import entity.CartWishList.TicketValidationResult;
import entity.CartWishList.CartTicketValidation;
import entity.CartWishList.CartWithValidationInfo;
import entity.Ticket.TicketAvailability;

/**
 *
 * @author ACER
 */
public class CartService implements ICartService{
    private CartDAO cartDAO = new CartDAO();
    private CartTicketDAO cartTicketDAO = new CartTicketDAO();
    private ProductService productService = new ProductService();

    // ===== NEW METHODS FOR CONTROLLER LAYER =====
    
    @Override
    public Cart getCartByUser(int userId) {
        try {
            return cartDAO.getCartByUser(userId);
        } catch (Exception e) {
            System.err.println("Error getting cart for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public Cart getOrCreateCart(int userId) {
        try {
            Cart cart = cartDAO.getCartByUser(userId);
            if (cart == null) {
                cart = new Cart();
                cart.setUserID(userId);
                int cartId = cartDAO.createCart(cart);
                cart.setCartID(cartId);
                System.out.println("[DEBUG] Created new cart with ID: " + cartId + " for user: " + userId);
            }
            return cart;
        } catch (Exception e) {
            System.err.println("Error getting or creating cart for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    @Override
    public boolean addProductToCart(int userId, int productId, int quantity) {
        try {
            // Validate input
            if (userId <= 0 || productId <= 0 || quantity <= 0) {
                System.err.println("Invalid input: userId=" + userId + ", productId=" + productId + ", quantity=" + quantity);
                return false;
            }
            
            // Get product information
            Product product = productService.getProductByID(String.valueOf(productId));
            if (product == null) {
                System.err.println("Product not found with ID: " + productId);
                return false;
            }
            
            // Check stock availability
            if (product.getStock() < quantity) {
                System.err.println("Insufficient stock. Available: " + product.getStock() + ", Requested: " + quantity);
                return false;
            }
            
            // Check if product is active
            if (product.getStatus() != 1) {
                System.err.println("Product is not available. Status: " + product.getStatus());
                return false;
            }
            
            // Get or create cart
            Cart cart = getOrCreateCart(userId);
            if (cart == null) {
                System.err.println("Failed to get or create cart for user: " + userId);
                return false;
            }
            
            // Create cart item
            CartItem item = new CartItem();
            item.setCartID(cart.getCartID());
            item.setProductID(productId);
            item.setQuantity(quantity);
            item.setPrice(product.getPrice().doubleValue());
            item.setProductName(product.getName());
            item.setImageUrl(product.getMainImageUrl());
            
            // Add item to database
            boolean success = cartDAO.addCartItem(item);
            System.out.println("[DEBUG] Add item to cart result: " + success);
            
            return success;
        } catch (Exception e) {
            System.err.println("Error adding product to cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateCartItemQuantity(int userId, int productId, int quantity) {
        try {
            if (userId <= 0 || productId <= 0 || quantity < 0) {
                return false;
            }
            
            Cart cart = getCartByUser(userId);
            if (cart == null) {
                System.err.println("Cart not found for user: " + userId);
                return false;
            }
            
            // Check stock if quantity > 0
            if (quantity > 0) {
                Product product = productService.getProductByID(String.valueOf(productId));
                if (product != null && product.getStock() < quantity) {
                    System.err.println("Insufficient stock. Available: " + product.getStock() + ", Requested: " + quantity);
                    return false;
                }
            }
            
            if (quantity <= 0) {
                // Remove item from cart
                removeCartItem(cart, productId);
            } else {
                // Update item quantity
                updateCartItem(cart, productId, quantity);
            }
            
            return true;
        } catch (Exception e) {
            System.err.println("Error updating cart item quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean removeCartItemByUser(int userId, int productId) {
        try {
            if (userId <= 0 || productId <= 0) {
                return false;
            }
            
            Cart cart = getCartByUser(userId);
            if (cart != null) {
                removeCartItem(cart, productId);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error removing cart item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean addTicketToCartByUser(int userId, int ticketId, Date ticketDate, int quantity) {
        try {
            if (userId <= 0 || ticketId <= 0 || quantity <= 0 || ticketDate == null) {
                return false;
            }
            
            Cart cart = getOrCreateCart(userId);
            if (cart == null) {
                return false;
            }
            
            addTicketToCart(cart, ticketId, ticketDate, quantity);
            return true;
        } catch (Exception e) {
            System.err.println("Error adding ticket to cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateTicketQuantityByUser(int userId, int cartTicketId, int quantity) {
        try {
            if (userId <= 0 || cartTicketId <= 0 || quantity < 0) {
                return false;
            }
            
            Cart cart = getCartByUser(userId);
            if (cart == null) {
                return false;
            }
            
            if (quantity <= 0) {
                removeTicketFromCart(cart, cartTicketId);
            } else {
                updateTicketInCart(cart, cartTicketId, quantity);
            }
            
            return true;
        } catch (Exception e) {
            System.err.println("Error updating ticket quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean removeTicketByUser(int userId, int cartTicketId) {
        try {
            if (userId <= 0 || cartTicketId <= 0) {
                return false;
            }
            
            Cart cart = getCartByUser(userId);
            if (cart != null) {
                removeTicketFromCart(cart, cartTicketId);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error removing ticket from cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ===== EXISTING METHODS =====

    @Override
    public void addToCart(Cart cart, Product product, int quantity) {
        if (cart == null || product == null || quantity <= 0) return;
        CartItem item = new CartItem();
        item.setCartID(cart.getCartID());
        item.setProductID(product.getPid());
        item.setProductName(product.getName());
        item.setPrice(product.getPrice().doubleValue());
        item.setQuantity(quantity);
        item.setImageUrl(product.getMainImageUrl());
        cartDAO.addCartItem(item);
    }

    @Override
    public void updateCartItem(Cart cart, int productId, int quantity) {
        if (cart == null || cart.getItems() == null) return;
        for (CartItem item : cart.getItems()) {
            if (item.getProductID() == productId) {
                item.setQuantity(quantity);
                cartDAO.updateCartItem(item);
                break;
            }
        }
    }

    @Override
    public void removeCartItem(Cart cart, int productId) {
        if (cart == null || cart.getItems() == null) return;
        for (int i = 0; i < cart.getItems().size(); i++) {
            CartItem item = cart.getItems().get(i);
            if (item.getProductID() == productId) {
                cartDAO.deleteCartItem(item.getCartItemID());
                cart.getItems().remove(i);
                break;
            }
        }
    }

    @Override
    public double getTotalPrice(Cart cart) {
        if (cart == null) return 0.0;
        double total = 0.0;
        if (cart.getItems() != null) {
            for (CartItem item : cart.getItems()) {
                total += item.getPrice() * item.getQuantity();
            }
        }
        if (cart.getTickets() != null) {
            for (CartTicket ticket : cart.getTickets()) {
                total += ticket.getPrice() * ticket.getQuantity();
            }
        }
        return total;
    }

    @Override
    public double calculateTotalWithDiscount(Cart cart) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public double calculateTotalDiscount(Cart cart) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void applyDiscount(Cart cart, String discountCode) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void clearCart(int userId) {
        cartDAO.clearCart(userId);
    }

    // Ticket methods - simplified add to cart without validation (like products)
    public void addTicketToCart(Cart cart, int ticketId, Date ticketDate, int quantity) {
        if (cart == null || ticketId <= 0 || quantity <= 0 || ticketDate == null) return;
        
        try {
            // Just add to cart database without validation (validation happens in cart display)
            boolean added = cartTicketDAO.addTicketToCart(cart.getCartID(), ticketId, ticketDate, quantity);
            if (added) {
                // Refresh tickets in cart
                cart.setTickets(cartTicketDAO.getCartTicketsByCartId(cart.getCartID()));
                System.out.println("[DEBUG] Successfully added ticket to cart - ID: " + ticketId + 
                                 ", Date: " + ticketDate + ", Quantity: " + quantity);
            } else {
                System.err.println("[DEBUG] Failed to add ticket to cart - ID: " + ticketId + 
                                 ", Date: " + ticketDate + ", Quantity: " + quantity);
            }
        } catch (Exception e) {
            System.err.println("Error adding ticket to cart: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Get current quantity in cart for specific ticket and date
     */
    private int getCurrentCartQuantity(int cartId, int ticketId, Date ticketDate) {
        List<CartTicket> cartTickets = cartTicketDAO.getCartTicketsByCartId(cartId);
        return cartTickets.stream()
                .filter(ticket -> ticket.getTicketId() == ticketId && 
                                 isSameDate(ticket.getTicketDate(), ticketDate))
                .mapToInt(CartTicket::getQuantity)
                .sum();
    }
    
    /**
     * Helper method to compare dates (ignoring time)
     */
    private boolean isSameDate(Date date1, Date date2) {
        if (date1 == null || date2 == null) return false;
        
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal1.setTime(date1);
        cal2.setTime(date2);
        
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
               cal1.get(java.util.Calendar.DAY_OF_YEAR) == cal2.get(java.util.Calendar.DAY_OF_YEAR);
    }

    public void updateTicketInCart(Cart cart, int cartTicketId, int quantity) {
        if (cart == null || cartTicketId <= 0 || quantity < 0) return;
        
        try {
            // ✅ NEW: Get ticket info first to validate availability
            CartTicket ticketToUpdate = null;
            if (cart.getTickets() != null) {
                for (CartTicket ticket : cart.getTickets()) {
                    if (ticket.getCartTicketId() == cartTicketId) {
                        ticketToUpdate = ticket;
                        break;
                    }
                }
            }
            
            if (ticketToUpdate == null) {
                System.err.println("Cart ticket not found with ID: " + cartTicketId);
                return;
            }
            
            // ✅ NEW: Validate availability for the new quantity
            if (quantity > 0) {
                TicketAvailabilityService availabilityService = new TicketAvailabilityService();
                
                // Check if new quantity is available
                if (!availabilityService.checkAvailability(ticketToUpdate.getTicketId(), 
                                                          ticketToUpdate.getTicketDate(), quantity)) {
                    
                    // Get current available slots for better error message
                    int availableSlots = getCurrentAvailableSlots(ticketToUpdate.getTicketId(), 
                                                                 ticketToUpdate.getTicketDate());
                    
                    System.err.println("Cannot update ticket quantity. Requested: " + quantity + 
                                     ", Available: " + availableSlots + 
                                     " for ticket " + ticketToUpdate.getTicketId() + 
                                     " on " + ticketToUpdate.getFormattedTicketDate());
                    
                    throw new RuntimeException("Không thể cập nhật số lượng vé! Chỉ còn " + availableSlots + 
                                             " vé có sẵn cho ngày " + ticketToUpdate.getFormattedTicketDate());
                }
                
                // ✅ NEW: Check current cart quantity to avoid conflicts
                int currentCartQuantity = getCurrentCartQuantity(cart.getCartID(), 
                                                               ticketToUpdate.getTicketId(), 
                                                               ticketToUpdate.getTicketDate());
                
                // Subtract current ticket quantity to get other tickets quantity  
                int otherTicketsQuantity = currentCartQuantity - ticketToUpdate.getQuantity();
                int totalRequestedQuantity = otherTicketsQuantity + quantity;
                
                if (!availabilityService.checkAvailability(ticketToUpdate.getTicketId(), 
                                                          ticketToUpdate.getTicketDate(), 
                                                          totalRequestedQuantity)) {
                    throw new RuntimeException("Không thể cập nhật! Tổng số lượng vé trong giỏ hàng sẽ vượt quá số vé có sẵn.");
                }
            }
            
            // ✅ ENHANCED: Update with validation passed
            cartTicketDAO.updateTicketQuantity(cartTicketId, quantity);
            cart.setTickets(cartTicketDAO.getCartTicketsByCartId(cart.getCartID()));
            
            System.out.println("[DEBUG] Successfully updated ticket quantity to " + quantity + 
                             " for ticket " + ticketToUpdate.getTicketTypeName() + 
                             " on " + ticketToUpdate.getFormattedTicketDate());
            
        } catch (RuntimeException e) {
            // Re-throw runtime exceptions (validation errors)
            throw e;
        } catch (Exception e) {
            System.err.println("Error updating ticket in cart: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Có lỗi xảy ra khi cập nhật vé: " + e.getMessage());
        }
    }

    public void removeTicketFromCart(Cart cart, int cartTicketId) {
        if (cart == null || cartTicketId <= 0) return;
        
        // Simple remove without availability management
        cartTicketDAO.removeTicketFromCart(cartTicketId);
        cart.setTickets(cartTicketDAO.getCartTicketsByCartId(cart.getCartID()));
    }

    public List<CartTicket> getTickets(Cart cart) {
        if (cart == null) return null;
        return cartTicketDAO.getCartTicketsByCartId(cart.getCartID());
    }
    
    /**
     * Process ticket checkout with availability management
     * Note: Order creation functionality removed due to Order system cleanup
     */
    public int checkoutTickets(Cart cart, String customerName, String email, String phone, 
                              String paymentMethod, String visitDate, String notes) {
        if (cart == null || cart.getTickets() == null || cart.getTickets().isEmpty()) {
            throw new RuntimeException("Giỏ hàng vé trống!");
        }
        
        TicketAvailabilityService availabilityService = new TicketAvailabilityService();
        
        try {
            // Book all tickets (reduce availability)
            for (CartTicket cartTicket : cart.getTickets()) {
                availabilityService.bookTickets(cartTicket.getTicketId(), 
                                               cartTicket.getTicketDate(), 
                                               cartTicket.getQuantity());
            }
            
            // Clear cart tickets after successful checkout
            clearCartTickets(cart.getCartID());
            
            return 1; // Return success indicator (no actual order ID)
            
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi xử lý checkout: " + e.getMessage());
        }
    }
    
    private int getVillageIdFromTickets(List<CartTicket> tickets) {
        // Simplified: assume all tickets are from same village
        // In real app, you might need to handle multiple villages
        return 1; // Default village ID
    }
    
    private void clearCartTickets(int cartId) {
        cartTicketDAO.clearCartTickets(cartId);
    }

    /**
     * ✅ NEW: Get current stock level for a product
     */
    public int getCurrentStock(int productId) {
        try {
            Product product = productService.getProductByID(String.valueOf(productId));
            return product != null ? product.getStock() : 0;
        } catch (Exception e) {
            System.err.println("Error getting stock for product " + productId + ": " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * ✅ NEW: Check if product is currently available
     */
    public boolean isProductAvailable(int productId) {
        try {
            Product product = productService.getProductByID(String.valueOf(productId));
            return product != null && product.getStock() > 0 && product.getStatus() == 1;
        } catch (Exception e) {
            System.err.println("Error checking product availability " + productId + ": " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ✅ NEW: Validate stock for a specific cart item
     */
    public StockValidationResult validateCartItemStock(CartItem item) {
        try {
            Product product = productService.getProductByID(String.valueOf(item.getProductID()));
            
            if (product == null) {
                return new StockValidationResult(false, 0, "Sản phẩm không tồn tại");
            }
            
            if (product.getStatus() != 1) {
                return new StockValidationResult(false, 0, "Sản phẩm không còn được bán");
            }
            
            int currentStock = product.getStock();
            
            if (currentStock == 0) {
                return new StockValidationResult(false, 0, "Sản phẩm đã hết hàng");
            }
            
            if (currentStock < item.getQuantity()) {
                return new StockValidationResult(false, currentStock, 
                    "Chỉ còn " + currentStock + " sản phẩm trong kho");
            }
            
            return new StockValidationResult(true, currentStock, "Sản phẩm có sẵn");
            
        } catch (Exception e) {
            System.err.println("Error validating stock for cart item: " + e.getMessage());
            return new StockValidationResult(false, 0, "Không thể kiểm tra tồn kho");
        }
    }
    
    /**
     * ✅ NEW: Validate stock for all items in cart
     */
    public CartStockValidation validateCartStock(Cart cart) {
        CartStockValidation validation = new CartStockValidation();
        
        if (cart == null || cart.getItems() == null) {
            return validation;
        }
        
        for (CartItem item : cart.getItems()) {
            StockValidationResult result = validateCartItemStock(item);
            
            if (!result.isValid()) {
                validation.addInvalidItem(item, result);
            } else {
                validation.addValidItem(item, result);
            }
        }
        
        return validation;
    }
    
    /**
     * ✅ NEW: Get current available slots for a ticket on specific date
     */
    public int getCurrentAvailableSlots(int ticketId, Date ticketDate) {
        try {
            TicketAvailabilityService availabilityService = new TicketAvailabilityService();
            TicketAvailability availability = availabilityService.getAvailabilityByTicketAndDate(ticketId, ticketDate);
            return availability != null ? availability.getAvailableSlots() : 0;
        } catch (Exception e) {
            System.err.println("Error getting available slots for ticket " + ticketId + " on " + ticketDate + ": " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * ✅ NEW: Check if ticket is available on specific date
     */
    public boolean isTicketAvailable(int ticketId, Date ticketDate, int quantity) {
        try {
            TicketAvailabilityService availabilityService = new TicketAvailabilityService();
            return availabilityService.checkAvailability(ticketId, ticketDate, quantity);
        } catch (Exception e) {
            System.err.println("Error checking ticket availability " + ticketId + " on " + ticketDate + ": " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ✅ NEW: Validate availability for a specific cart ticket
     */
    public TicketValidationResult validateCartTicketAvailability(CartTicket ticket) {
        try {
            TicketAvailabilityService availabilityService = new TicketAvailabilityService();
            
            // Check date validity first
            if (!isValidTicketDate(ticket.getTicketDate())) {
                return new TicketValidationResult(false, 0, 0, "Ngày đặt vé không hợp lệ", 
                                                ticket.getTicketDate(), ticket.getTicketId());
            }
            
            TicketAvailability availability = availabilityService.getAvailabilityByTicketAndDate(
                ticket.getTicketId(), ticket.getTicketDate());
            
            if (availability == null) {
                return new TicketValidationResult(false, 0, 0, "Không có thông tin tình trạng vé",
                                                ticket.getTicketDate(), ticket.getTicketId());
            }
            
            int availableSlots = availability.getAvailableSlots();
            int totalSlots = availability.getTotalSlots();
            
            if (availableSlots == 0) {
                return new TicketValidationResult(false, 0, totalSlots, "Vé đã hết",
                                                ticket.getTicketDate(), ticket.getTicketId());
            }
            
            if (availableSlots < ticket.getQuantity()) {
                return new TicketValidationResult(false, availableSlots, totalSlots, 
                    "Chỉ còn " + availableSlots + " vé",
                    ticket.getTicketDate(), ticket.getTicketId());
            }
            
            return new TicketValidationResult(true, availableSlots, totalSlots, "Vé có sẵn",
                                            ticket.getTicketDate(), ticket.getTicketId());
            
        } catch (Exception e) {
            System.err.println("Error validating cart ticket: " + e.getMessage());
            return new TicketValidationResult(false, 0, 0, "Không thể kiểm tra tình trạng vé",
                                            ticket.getTicketDate(), ticket.getTicketId());
        }
    }
    
    /**
     * ✅ NEW: Validate availability for all tickets in cart
     */
    public CartTicketValidation validateCartTickets(Cart cart) {
        CartTicketValidation validation = new CartTicketValidation();
        
        if (cart == null || cart.getTickets() == null) {
            return validation;
        }
        
        for (CartTicket ticket : cart.getTickets()) {
            TicketValidationResult result = validateCartTicketAvailability(ticket);
            
            if (!result.isValid()) {
                validation.addInvalidTicket(ticket, result);
            } else {
                validation.addValidTicket(ticket, result);
            }
        }
        
        return validation;
    }
    
    /**
     * ✅ NEW: Get cart with comprehensive validation (both products and tickets)
     */
    public CartWithValidationInfo getCartWithComprehensiveValidation(int userId) {
        try {
            Cart cart = getCartByUser(userId);
            
            // ✅ DEBUG: Log cart content before validation
            if (cart != null) {
                System.out.println("[DEBUG] Cart loaded for user " + userId + 
                                 " - Products: " + (cart.getItems() != null ? cart.getItems().size() : 0) + 
                                 ", Tickets: " + (cart.getTickets() != null ? cart.getTickets().size() : 0));
                
                if (cart.getTickets() != null && !cart.getTickets().isEmpty()) {
                    System.out.println("[DEBUG] Tickets in cart:");
                    for (CartTicket ticket : cart.getTickets()) {
                        System.out.println("  - Ticket ID: " + ticket.getTicketId() + 
                                         ", Date: " + ticket.getFormattedTicketDate() + 
                                         ", Quantity: " + ticket.getQuantity() + 
                                         ", CartTicketId: " + ticket.getCartTicketId());
                    }
                }
            }
            
            CartStockValidation stockValidation = validateCartStock(cart);
            CartTicketValidation ticketValidation = validateCartTickets(cart);
            
            // ✅ DEBUG: Log validation results
            System.out.println("[DEBUG] Validation results - Stock issues: " + !stockValidation.getInvalidItems().isEmpty() + 
                             ", Ticket issues: " + !ticketValidation.getInvalidTickets().isEmpty());
            
            return new CartWithValidationInfo(cart, stockValidation, ticketValidation);
            
        } catch (Exception e) {
            System.err.println("Error getting cart with comprehensive validation: " + e.getMessage());
            e.printStackTrace();
            return new CartWithValidationInfo(null, new CartStockValidation(), new CartTicketValidation());
        }
    }
    
    /**
     * ✅ NEW: Get cart with stock validation
     */
    public CartWithStockInfo getCartWithStockValidation(int userId) {
        try {
            // For backward compatibility, still return CartWithStockInfo
            // But internally use comprehensive validation
            CartWithValidationInfo comprehensive = getCartWithComprehensiveValidation(userId);
            
            return new CartWithStockInfo(comprehensive.getCart(), comprehensive.getStockValidation());
            
        } catch (Exception e) {
            System.err.println("Error getting cart with stock validation: " + e.getMessage());
            return new CartWithStockInfo(null, new CartStockValidation());
        }
    }
    
    /**
     * ✅ NEW: Remove out-of-stock items from cart
     */
    public boolean removeOutOfStockItems(int userId) {
        try {
            Cart cart = getCartByUser(userId);
            if (cart == null || cart.getItems() == null) {
                return true;
            }
            
            boolean hasChanges = false;
            
            // Create a copy of items to avoid ConcurrentModificationException
            List<CartItem> itemsToCheck = new ArrayList<>(cart.getItems());
            
            for (CartItem item : itemsToCheck) {
                if (!isProductAvailable(item.getProductID())) {
                    cartDAO.deleteCartItem(item.getCartItemID());
                    cart.getItems().remove(item);
                    hasChanges = true;
                    System.out.println("[DEBUG] Removed out-of-stock item: " + item.getProductName());
                }
            }
            
            return hasChanges;
            
        } catch (Exception e) {
            System.err.println("Error removing out-of-stock items: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ✅ NEW: Auto-adjust quantities for items with insufficient stock
     */
    public boolean autoAdjustQuantities(int userId) {
        try {
            Cart cart = getCartByUser(userId);
            if (cart == null || cart.getItems() == null) {
                return true;
            }
            
            boolean hasChanges = false;
            
            for (CartItem item : cart.getItems()) {
                StockValidationResult result = validateCartItemStock(item);
                
                if (!result.isValid() && result.getAvailableStock() > 0) {
                    // Adjust quantity to available stock
                    item.setQuantity(result.getAvailableStock());
                    cartDAO.updateCartItem(item);
                    hasChanges = true;
                    System.out.println("[DEBUG] Adjusted quantity for " + item.getProductName() + 
                                     " to " + result.getAvailableStock());
                }
            }
            
            return hasChanges;
            
        } catch (Exception e) {
            System.err.println("Error auto-adjusting quantities: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ✅ FIXED: Remove sold-out tickets from cart
     * Only removes tickets when completely sold out (0 available slots)
     */
    public boolean removeSoldOutTickets(int userId) {
        try {
            Cart cart = getCartByUser(userId);
            if (cart == null || cart.getTickets() == null) {
                return true;
            }
            
            boolean hasChanges = false;
            
            // Create a copy to avoid ConcurrentModificationException
            List<CartTicket> ticketsToCheck = new ArrayList<>(cart.getTickets());
            
            for (CartTicket ticket : ticketsToCheck) {
                // ✅ FIXED: Check available slots directly instead of minimum quantity
                int availableSlots = getCurrentAvailableSlots(ticket.getTicketId(), ticket.getTicketDate());
                
                // Only remove if completely sold out (0 available slots)
                if (availableSlots == 0) {
                    cartTicketDAO.removeTicketFromCart(ticket.getCartTicketId());
                    cart.getTickets().remove(ticket);
                    hasChanges = true;
                    System.out.println("[DEBUG] Removed completely sold-out ticket: " + ticket.getTicketTypeName() + 
                                     " on " + ticket.getFormattedTicketDate() + " (0 slots available)");
                } else {
                    System.out.println("[DEBUG] Keeping ticket with insufficient quantity: " + ticket.getTicketTypeName() + 
                                     " - Current: " + ticket.getQuantity() + ", Available: " + availableSlots);
                }
            }
            
            return hasChanges;
            
        } catch (Exception e) {
            System.err.println("Error removing sold-out tickets: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ✅ FIXED: Auto-adjust ticket quantities to available slots
     * Only adjusts if there are still available slots, never removes tickets completely
     */
    public boolean autoAdjustTicketQuantities(int userId) {
        try {
            Cart cart = getCartByUser(userId);
            if (cart == null || cart.getTickets() == null) {
                return true;
            }
            
            boolean hasChanges = false;
            
            for (CartTicket ticket : cart.getTickets()) {
                TicketValidationResult result = validateCartTicketAvailability(ticket);
                
                // ✅ FIXED: Only adjust if there are available slots AND current quantity exceeds available
                if (!result.isValid() && result.getAvailableSlots() > 0 && ticket.getQuantity() > result.getAvailableSlots()) {
                    // Adjust quantity to available slots (never set to 0)
                    int newQuantity = Math.max(1, result.getAvailableSlots());
                    ticket.setQuantity(newQuantity);
                    cartTicketDAO.updateTicketQuantity(ticket.getCartTicketId(), newQuantity);
                    hasChanges = true;
                    System.out.println("[DEBUG] Adjusted ticket quantity for " + ticket.getTicketTypeName() + 
                                     " from " + ticket.getQuantity() + " to " + newQuantity + 
                                     " (available: " + result.getAvailableSlots() + ")");
                }
            }
            
            return hasChanges;
            
        } catch (Exception e) {
            System.err.println("Error auto-adjusting ticket quantities: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ✅ NEW: Check if ticket date is valid for booking
     */
    private boolean isValidTicketDate(Date ticketDate) {
        if (ticketDate == null) {
            return false;
        }
        
        Date today = new Date();
        long daysDiff = (ticketDate.getTime() - today.getTime()) / (24 * 60 * 60 * 1000);
        
        // Must be today or future, but not more than 30 days
        return daysDiff >= 0 && daysDiff <= 30;
    }
}