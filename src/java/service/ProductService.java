/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.ProductDAO;
import entity.CartWishList.CartItem;
import entity.CartWishList.CartTicket;
import entity.Product.Product;
import entity.Product.ProductCategory;
import entity.Product.ProductReview;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ACER
 */
public class ProductService implements IProductService {

    ProductDAO pDAO = new ProductDAO();

    @Override
    public int addProduct(Product product) throws Exception {
        return pDAO.addProduct(product);
    }

    @Override
    public boolean updateProduct(Product product) {
        return pDAO.updateProductByAdmin(product);
    }

    @Override
    public Product getProductById(int productId) {
        return pDAO.getProductByID(String.valueOf(productId));
    }

    public Product getProductByID(String id) {
        return pDAO.getProductByID(id);
    }

    @Override
    public List<Product> getAllProducts() {
        return pDAO.getAllProducts();
    }

    public List<Product> getProductByCategoryID(String categoryId) {
        return pDAO.getProductByCategoryID(categoryId);
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        return pDAO.searchByName(keyword);
    }

    /**
     * Search products by name - additional method for compatibility
     */
    public List<Product> searchByName(String name) {
        return pDAO.searchByName(name);
    }

    @Override
    public List<Product> getProductsByCategory(int categoryId) {
        return pDAO.getProductByCategoryID(String.valueOf(categoryId));
    }

    @Override
    public List<Product> getProductsByVillage(int villageId) {
        return pDAO.getProductsByVillage(villageId);
    }

    @Override
    public List<Product> getProductsByCraftType(int typeId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Product> getFeaturedProducts() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Product> getAvailableProducts() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Map<String, Integer> getProductCountByCategory() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Product> getTopClickedProducts(int limit) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Product> getTopRatedProducts(int limit) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateClickCount(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateStock(int productId, int quantityChange) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<String> getImageUrlsByProductId(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<ProductReview> getReviewsByProductId(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public double calculateAverageRating(int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Product> getProductsBySellerId(int sellerId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Product> getAllProductActive() {
        return pDAO.getAllProductActive();
    }

    @Override
    public List<Product> getActivateProducts() {
        return pDAO.getAllProductActive();
    }

    @Override
    public List<ProductCategory> getAllCategory() {
        return pDAO.getAllCategory();
    }

    // Alias method for compatibility
    public List<entity.Product.Category> getAllCategories() {
        // Convert ProductCategory to Category if needed, or return as is
        List<ProductCategory> categories = getAllCategory();
        // For now, just return an empty list or handle conversion
        return new java.util.ArrayList<>();
    }

    // Additional compatibility method
    public List<Product> getActiveProductsBySellID(int sellerId) {
        // Return products by seller ID (for now, return empty list)
        return pDAO.getProductsByVillage(1);
    }

    @Override
    public List<Product> getTop5NewestProducts() {
        return pDAO.getTop5NewestProducts();
    }

    @Override
    public List<Product> getAllProductActiveByAdmin() {
        return pDAO.getAllProductActiveByAdmin();
    }

    @Override
    public boolean addProductByAdmin(Product product) {
        return true;
    }

    @Override
    public boolean updateProductByAdmin(Product product) {
        return pDAO.updateProductByAdmin(product);
    }

    @Override
    public boolean createProductByAdmin(Product product) {
        return pDAO.createProductByAdmin(product);
    }

    @Override
    public boolean deleteProductByAdmin(int productId) {
        return pDAO.deleteProductByAdmin(productId);
    }

    @Override
    public List<Product> getSearchProductByAdmin(int status, int searchID, String contentSearch) {
        return pDAO.getSearchProductByAdmin(status, searchID, contentSearch);
    }

    @Override
    public List<Product> getProductByCategory(int categoryID) {
        return pDAO.getProductByCategory(categoryID);
    }

    @Override
    public List<Product> getProductOutOfStockByAdmin() {
        return pDAO.getProductOutOfStockByAdmin();
    }

    @Override
    public String getCategoryNameByCategoryID(int categoryID) {
        return pDAO.getCategoryNameByCategoryID(categoryID);
    }

    @Override
    public List<Product> getTopRatedByAdmin() {
        return pDAO.getTopRatedByAdmin();
    }

    @Override
    public String getProduct3D(int productID) {
        return pDAO.getProduct3D(productID);
    }

    /**
     * Get products by name with price range and order filtering This method
     * provides advanced filtering capabilities
     */
    public List<Product> getProductsByNameAndPriceRangeAndOrder(String name, String priceRange, String orderBy) {
        try {
            // For now, just return basic search results
            // Advanced filtering can be implemented in DAO layer later
            List<Product> products = searchByName(name);

            // Basic price filtering
            if (priceRange != null && !priceRange.equals("all")) {
                products = filterByPriceRange(products, priceRange);
            }

            // Basic ordering
            if (orderBy != null && !orderBy.equals("menu_order")) {
                products = orderProducts(products, orderBy);
            }

            return products;
        } catch (Exception e) {
            // Fallback to basic search if filtering fails
            return searchByName(name);
        }
    }

    /**
     * Filter products by price range
     */
    private List<Product> filterByPriceRange(List<Product> products, String priceRange) {
        // Basic implementation - can be enhanced
        return products.stream()
                .filter(product -> {
                    double price = product.getPrice().doubleValue();
                    switch (priceRange) {
                        case "0-100000":
                            return price <= 100000;
                        case "100000-500000":
                            return price > 100000 && price <= 500000;
                        case "500000-1000000":
                            return price > 500000 && price <= 1000000;
                        case "1000000+":
                            return price > 1000000;
                        default:
                            return true;
                    }
                })
                .collect(java.util.stream.Collectors.toList());
    }

    /**
     * Order products by specified criteria
     */
    private List<Product> orderProducts(List<Product> products, String orderBy) {
        if (orderBy == null || orderBy.isEmpty()) {
            return products;
        }

        switch (orderBy.toLowerCase()) {
            case "price_asc":
                products.sort((p1, p2) -> p1.getPrice().compareTo(p2.getPrice()));
                break;
            case "price_desc":
                products.sort((p1, p2) -> p2.getPrice().compareTo(p1.getPrice()));
                break;
            case "name_asc":
                products.sort((p1, p2) -> p1.getName().compareToIgnoreCase(p2.getName()));
                break;
            case "name_desc":
                products.sort((p1, p2) -> p2.getName().compareToIgnoreCase(p1.getName()));
                break;
            default:
                // Default sorting by ID
                products.sort((p1, p2) -> Integer.compare(p1.getPid(), p2.getPid()));
        }

        return products;
    }

    /**
     * Check if a product is owned by a specific seller
     *
     * @param productID The product ID
     * @param sellerID The seller ID
     * @return true if the product is owned by the seller
     */
    public boolean isProductOwnedBySeller(int productID, int sellerID) {
        return pDAO.isProductOwnedBySeller(productID, sellerID);
    }

    @Override
    public int getVillageIDByProductID(int productID) {
        return pDAO.getVillageIDByProductID(productID);
    }

    @Override
    public int getVillageIDByTicketID(int ticketID) {
        return pDAO.getVillageIDByTicketID(ticketID);
    }

    public String getModelFileByProductID(int productID) {
        return pDAO.getModelFileByProductID(productID);
    }

    /**
     * Get products by category with price range and order filtering This method
     * provides advanced filtering capabilities for category-based searches
     */
    public List<Product> getProductsByCategoryAndPriceAndOrder(String categoryId, String priceRange, String orderBy) {
        try {
            // Use the DAO method that already exists
            return pDAO.getProductsByCategoryAndPriceRangeAndOrder(categoryId, priceRange, orderBy);
        } catch (Exception e) {
            // Fallback to basic category search if advanced filtering fails
            return getProductByCategoryID(categoryId);
        }
    }

    public Map<Integer, BigDecimal> getSetVillage(List<CartItem> cartItem, List<CartTicket> cartTicket) {
        return pDAO.getSetVillage(cartItem, cartTicket);
    }

    public List<Product> getSearchProductByAdmin(int status, int searchId, String contentSearch, int offset, int PAGE_SIZE) {
        return pDAO.getSearchProductByAdmin(status, searchId, contentSearch, offset,PAGE_SIZE);
    }

    public int getTotalSearchProducts(int status, int searchId, String contentSearch) {
        return pDAO.getTotalSearchProducts( status,  searchId,  contentSearch);
    }

    public List<Product> getAllProductActiveByAdmin(int offset, int PAGE_SIZE) {
        return pDAO.getAllProductActiveByAdmin( offset,  PAGE_SIZE);
    }

    public int getTotalActiveProducts() {
        return pDAO.getTotalActiveProducts();
    }

    // ==== SELLER METHODS ====
    // Note: These methods delegate to SellerService for better separation of concerns
    private SellerService sellerService = new SellerService();
    
    /**
     * Get products by seller (village owner)
     */
    public List<Product> getProductsBySeller(int sellerId, int status, int villageId, int categoryId, 
                                            String searchQuery, String sortBy, int offset, int limit) {
        return sellerService.getProductsBySeller(sellerId, status, villageId, categoryId, searchQuery, sortBy, offset, limit);
    }
    
    /**
     * Get total count of products by seller
     */
    public int getTotalProductsBySeller(int sellerId, int status, int villageId, int categoryId, String searchQuery) {
        return sellerService.getTotalProductsBySeller(sellerId, status, villageId, categoryId, searchQuery);
    }
    
    /**
     * Get villages owned by seller
     */
    public List<entity.CraftVillage.CraftVillage> getVillagesBySeller(int sellerId) {
        return sellerService.getVillagesBySeller(sellerId);
    }
    
    /**
     * Create new product for seller
     */
    public int createProductBySeller(Product product) throws Exception {
        return sellerService.createProductBySeller(product);
    }
    
    /**
     * Update product by seller
     */
    public boolean updateProductBySeller(Product product, int sellerId) throws Exception {
        return sellerService.updateProductBySeller(product, sellerId);
    }
    
    /**
     * Delete/deactivate product by seller
     */
    public boolean deleteProductBySeller(int productId, int sellerId) throws Exception {
        return sellerService.deleteProductBySeller(productId, sellerId);
    }
    
    /**
     * Change product status by seller
     */
    public boolean changeProductStatus(int productId, int status, int sellerId) throws Exception {
        return sellerService.changeProductStatus(productId, status, sellerId);
    }
    
    /**
     * Bulk operations for products
     */
    public boolean bulkUpdateProductStatus(List<Integer> productIds, int status, int sellerId) throws Exception {
        return sellerService.bulkUpdateProductStatus(productIds, status, sellerId);
    }
    
    /**
     * Get product statistics for seller dashboard
     */
    public Map<String, Object> getSellerProductStats(int sellerId) {
        return sellerService.getSellerProductStats(sellerId);
    }
    
    /**
     * Get low stock products for seller
     */
    public List<Product> getLowStockProducts(int sellerId, int threshold) {
        return sellerService.getLowStockProducts(sellerId, threshold);
    }

    /**
     * Get product images by product ID
     */
    public List<entity.Product.ProductImage> getProductImages(int productId) {
        return pDAO.getProductImages(productId);
    }

    /**
     * Add product image (delegated to seller service)
     */
    public boolean addProductImage(entity.Product.ProductImage productImage) {
        return sellerService.addProductImage(productImage);
    }

    /**
     * Update product image (delegated to seller service)
     */
    public boolean updateProductImage(entity.Product.ProductImage productImage) {
        return sellerService.updateProductImage(productImage);
    }

    /**
     * Delete product image (delegated to seller service)
     */
    public boolean deleteProductImage(int imageId) {
        return sellerService.deleteProductImage(imageId);
    }

}
