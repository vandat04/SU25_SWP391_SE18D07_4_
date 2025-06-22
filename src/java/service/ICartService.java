package service;

/**
 *
 * @author Pc
 */

import entity.CartWishList.Cart;
import entity.Product.Product;

public interface ICartService {
    void addToCart(Cart cart, Product product, int quantity);
    void updateCartItem(Cart cart, int productId, int quantity);
    void removeCartItem(Cart cart, int productId);
    double getTotalPrice(Cart cart);
    double calculateTotalWithDiscount(Cart cart);
    double calculateTotalDiscount(Cart cart);
    void applyDiscount(Cart cart, String discountCode);
    void clearCart(int userId);
}