package service;

import DAO.SellerProductDAO;
import entity.Product.Product;
import entity.CraftVillage.CraftVillage;
import entity.Product.ProductImage;
import java.util.List;
import java.util.Map;

/**
 * Service layer for seller-specific operations
 */
public class SellerService {
    
    private SellerProductDAO sellerProductDAO = new SellerProductDAO();
    
    /**
     * Get products by seller with filtering and pagination
     */
    public List<Product> getProductsBySeller(int sellerId, int status, int villageId, int categoryId, 
                                            String searchQuery, String sortBy, int offset, int limit) {
        return sellerProductDAO.getProductsBySeller(sellerId, status, villageId, categoryId, searchQuery, sortBy, offset, limit);
    }
    
    /**
     * Get total count of products by seller
     */
    public int getTotalProductsBySeller(int sellerId, int status, int villageId, int categoryId, String searchQuery) {
        return sellerProductDAO.getTotalProductsBySeller(sellerId, status, villageId, categoryId, searchQuery);
    }
    
    /**
     * Get villages owned by seller
     */
    public List<CraftVillage> getVillagesBySeller(int sellerId) {
        return sellerProductDAO.getVillagesBySeller(sellerId);
    }
    
    /**
     * Create new product for seller
     */
    public int createProductBySeller(Product product) throws Exception {
        return sellerProductDAO.createProductBySeller(product);
    }
    
    /**
     * Update product by seller
     */
    public boolean updateProductBySeller(Product product, int sellerId) throws Exception {
        return sellerProductDAO.updateProductBySeller(product, sellerId);
    }
    
    /**
     * Delete/deactivate product by seller
     */
    public boolean deleteProductBySeller(int productId, int sellerId) throws Exception {
        return sellerProductDAO.deleteProductBySeller(productId, sellerId);
    }
    
    /**
     * Change product status by seller
     */
    public boolean changeProductStatus(int productId, int status, int sellerId) throws Exception {
        return sellerProductDAO.changeProductStatus(productId, status, sellerId);
    }
    
    /**
     * Bulk operations for products
     */
    public boolean bulkUpdateProductStatus(List<Integer> productIds, int status, int sellerId) throws Exception {
        return sellerProductDAO.bulkUpdateProductStatus(productIds, status, sellerId);
    }
    
    /**
     * Get product statistics for seller dashboard
     */
    public Map<String, Object> getSellerProductStats(int sellerId) {
        return sellerProductDAO.getSellerProductStats(sellerId);
    }
    
    /**
     * Get low stock products for seller
     */
    public List<Product> getLowStockProducts(int sellerId, int threshold) {
        return sellerProductDAO.getLowStockProducts(sellerId, threshold);
    }
    
    /**
     * Check if seller owns the product
     */
    public boolean isProductOwnedBySeller(int productId, int sellerId) {
        return sellerProductDAO.isProductOwnedBySeller(productId, sellerId);
    }
    
    /**
     * Get product by ID if owned by seller
     */
    public Product getProductByIdForSeller(int productId, int sellerId) {
        if (isProductOwnedBySeller(productId, sellerId)) {
            ProductService productService = new ProductService();
            return productService.getProductById(productId);
        }
        return null;
    }
    
    /**
     * Calculate seller dashboard statistics
     */
    public Map<String, Object> getSellerDashboardStats(int sellerId) {
        Map<String, Object> stats = getSellerProductStats(sellerId);
        
        // Add revenue data (would need OrderDAO integration)
        stats.put("todayRevenue", 0.0);
        stats.put("monthRevenue", 0.0);
        stats.put("totalRevenue", 0.0);
        
        // Add order statistics (would need OrderDAO integration)
        stats.put("pendingOrders", 0);
        stats.put("completedOrders", 0);
        
        return stats;
    }

    /**
     * Add product image
     */
    public boolean addProductImage(ProductImage productImage) {
        return sellerProductDAO.addProductImage(productImage);
    }

    /**
     * Update product image
     */
    public boolean updateProductImage(ProductImage productImage) {
        return sellerProductDAO.updateProductImage(productImage);
    }

    /**
     * Delete product image
     */
    public boolean deleteProductImage(int imageId) {
        return sellerProductDAO.deleteProductImage(imageId);
    }
}