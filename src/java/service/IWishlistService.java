package service;

import entity.CartWishList.Wishlist;
import java.util.List;

public interface IWishlistService {
    List<Wishlist> getAllWishlists();
    Wishlist getWishlistById(int id);
    boolean addWishlist(Wishlist wishlist);
    boolean updateWishlist(Wishlist wishlist);
    boolean deleteWishlist(int id);
    List<Wishlist> getWishlistsByUserId(int userId);
    int getWishListCount(int userID);
} 