package service;

import java.util.List;
import DAO.WishlistDAO;
import entity.CartWishList.Wishlist;

public class WishlistService implements IWishlistService {
    private WishlistDAO wDAO = new WishlistDAO();

    @Override
    public List<Wishlist> getAllWishlists() {
        // TODO: implement
        return null;
    }

    @Override
    public Wishlist getWishlistById(int id) {
        // TODO: implement
        return null;
    }

    @Override
    public boolean addWishlist(Wishlist wishlist) {
        // TODO: implement
        return false;
    }

    @Override
    public boolean updateWishlist(Wishlist wishlist) {
        // TODO: implement
        return false;
    }

    @Override
    public boolean deleteWishlist(int id) {
        // TODO: implement
        return false;
    }

    @Override
    public List<Wishlist> getWishlistsByUserId(int userId) {
        // TODO: implement
        return wDAO.getWishListByUserId(userId);
    }

    @Override
    public int getWishListCount(int userID) {
        return wDAO.getWishlistCount(userID);
    }

} 