package DAO;

import context.DBContext;
import entity.Product.Product;
import entity.CraftVillage.CraftVillage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * DAO for seller-specific product operations
 */
public class SellerProductDAO {
    private static final Logger LOGGER = Logger.getLogger(SellerProductDAO.class.getName());
    
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.warning("Error closing resources: " + e.getMessage());
        }
    }
    
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("pid"),
                rs.getString("name"),
                rs.getBigDecimal("price"),
                rs.getString("description"),
                rs.getInt("stock"),
                rs.getInt("status"),
                rs.getInt("villageID"),
                rs.getInt("categoryID"),
                rs.getInt("craftTypeID"),
                rs.getString("mainImageUrl"),
                rs.getInt("clickCount"),
                rs.getTimestamp("lastClicked"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate"),
                rs.getString("sku"),
                rs.getBigDecimal("weight"),
                rs.getString("dimensions"),
                rs.getString("materials"),
                rs.getString("careInstructions"),
                rs.getString("warranty"),
                rs.getBigDecimal("averageRating"),
                rs.getInt("totalReviews"),
                rs.getString("modelFile")
        );
    }
    
    /**
     * Get products by seller with filtering and pagination
     * Filters products by seller through village ownership relationship
     */
    public static void main(String[] args) {
        System.out.println(new SellerProductDAO().getProductsBySeller(6, 1, 4, 0, null, null, 1, 10).size());
    }
    public List<Product> getProductsBySeller(int sellerId, int status, int villageId, int categoryId, 
                                           String searchQuery, String sortBy, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            StringBuilder sql = new StringBuilder();
            
            // Filter products by seller through village ownership
            sql.append("SELECT p.* FROM Product p ");
            sql.append("INNER JOIN CraftVillage cv ON p.villageID = cv.villageID ");
            sql.append("WHERE cv.sellerId = ? ");
            
            // Add additional filters
            if (status >= 0) {
                sql.append("AND p.status = ? ");
            }
            if (villageId > 0) {
                sql.append("AND p.villageID = ? ");
            }
            if (categoryId > 0) {
                sql.append("AND p.categoryID = ? ");
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql.append("AND (p.name LIKE ? OR p.description LIKE ?) ");
            }
            
            // Add sorting
            if (sortBy != null) {
                switch (sortBy) {
                    case "name_asc":
                        sql.append("ORDER BY p.name ASC ");
                        break;
                    case "name_desc":
                        sql.append("ORDER BY p.name DESC ");
                        break;
                    case "price_asc":
                        sql.append("ORDER BY p.price ASC ");
                        break;
                    case "price_desc":
                        sql.append("ORDER BY p.price DESC ");
                        break;
                    case "stock_asc":
                        sql.append("ORDER BY p.stock ASC ");
                        break;
                    case "stock_desc":
                        sql.append("ORDER BY p.stock DESC ");
                        break;
                    case "created_asc":
                        sql.append("ORDER BY p.createdDate ASC ");
                        break;
                    default:
                        sql.append("ORDER BY p.createdDate DESC ");
                        break;
                }
            } else {
                sql.append("ORDER BY p.createdDate DESC ");
            }
            
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
            ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            // Set sellerId parameter first (required for JOIN)
            ps.setInt(paramIndex++, sellerId);
            
            // Set additional filter parameters
            if (status >= 0) {
                ps.setInt(paramIndex++, status);
            }
            if (villageId > 0) {
                ps.setInt(paramIndex++, villageId);
            }
            if (categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String search = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, search);
                ps.setString(paramIndex++, search);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return products;
    }
    
    /**
     * Get total count of products by seller
     * Counts products by seller through village ownership relationship
     */
    public int getTotalProductsBySeller(int sellerId, int status, int villageId, int categoryId, String searchQuery) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = DBContext.getConnection();
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM Product p ");
            sql.append("INNER JOIN CraftVillage cv ON p.villageID = cv.villageID ");
            sql.append("WHERE cv.sellerId = ? ");
            
            // Add additional filters
            if (status >= 0) {
                sql.append("AND p.status = ? ");
            }
            if (villageId > 0) {
                sql.append("AND p.villageID = ? ");
            }
            if (categoryId > 0) {
                sql.append("AND p.categoryID = ? ");
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql.append("AND (p.name LIKE ? OR p.description LIKE ?) ");
            }
            
            ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            // Set sellerId parameter first (required for JOIN in count query)
            ps.setInt(paramIndex++, sellerId);
            
            // Set additional filter parameters
            if (status >= 0) {
                ps.setInt(paramIndex++, status);
            }
            if (villageId > 0) {
                ps.setInt(paramIndex++, villageId);
            }
            if (categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String search = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, search);
                ps.setString(paramIndex++, search);
            }
            
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return total;
    }
    
    /**
     * Get villages owned by seller
     */
    public List<CraftVillage> getVillagesBySeller(int sellerId) {
        List<CraftVillage> villages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT * FROM CraftVillage WHERE sellerId = ? AND status = 1";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                CraftVillage village = new CraftVillage();
                village.setVillageID(rs.getInt("villageID"));
                village.setVillageName(rs.getString("villageName"));
                village.setDescription(rs.getString("description"));
                village.setHistory(rs.getString("history"));
                village.setAddress(rs.getString("address"));
                village.setMainImageUrl(rs.getString("mainImageUrl"));
                village.setStatus(rs.getInt("status"));
                village.setCreatedDate(rs.getTimestamp("createdDate"));
                village.setUpdatedDate(rs.getTimestamp("updatedDate"));
                village.setSellerId(rs.getInt("sellerId"));
                villages.add(village);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return villages;
    }
    
    /**
     * Create new product for seller
     */
    public int createProductBySeller(Product product) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int productId = 0;
        
        try {
            conn = DBContext.getConnection();
            String sql = "INSERT INTO Product (name, price, description, stock, status, villageID, categoryID, " +
                        "mainImageUrl, sku, createdDate, updatedDate) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
            
            ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getName());
            ps.setBigDecimal(2, product.getPrice());
            ps.setString(3, product.getDescription());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getStatus());
            ps.setInt(6, product.getVillageID());
            ps.setInt(7, product.getCategoryID());
            ps.setString(8, product.getMainImageUrl());
            ps.setString(9, product.getSku());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    productId = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new Exception("Error creating product: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return productId;
    }
    
    /**
     * Update product by seller
     */
    public boolean updateProductBySeller(Product product, int sellerId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBContext.getConnection();
            String sql = "UPDATE Product SET name = ?, price = ?, description = ?, stock = ?, status = ?, " +
                        "categoryID = ?, mainImageUrl = ?, sku = ?, updatedDate = GETDATE() " +
                        "WHERE pid = ? AND villageID IN (SELECT villageID FROM CraftVillage WHERE sellerId = ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, product.getName());
            ps.setBigDecimal(2, product.getPrice());
            ps.setString(3, product.getDescription());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getStatus());
            ps.setInt(6, product.getCategoryID());
            ps.setString(7, product.getMainImageUrl());
            ps.setString(8, product.getSku());
            ps.setInt(9, product.getPid());
            ps.setInt(10, sellerId);
            
            int affectedRows = ps.executeUpdate();
            success = affectedRows > 0;
        } catch (Exception e) {
            throw new Exception("Error updating product: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }
    
    /**
     * Delete/deactivate product by seller
     */
    public boolean deleteProductBySeller(int productId, int sellerId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBContext.getConnection();
            String sql = "UPDATE Product SET status = 0, updatedDate = GETDATE() " +
                        "WHERE pid = ? AND villageID IN (SELECT villageID FROM CraftVillage WHERE sellerId = ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, sellerId);
            
            int affectedRows = ps.executeUpdate();
            success = affectedRows > 0;
        } catch (Exception e) {
            throw new Exception("Error deleting product: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }
    
    /**
     * Change product status by seller
     */
    public boolean changeProductStatus(int productId, int status, int sellerId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBContext.getConnection();
            String sql = "UPDATE Product SET status = ?, updatedDate = GETDATE() " +
                        "WHERE pid = ? AND villageID IN (SELECT villageID FROM CraftVillage WHERE sellerId = ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, productId);
            ps.setInt(3, sellerId);
            
            int affectedRows = ps.executeUpdate();
            success = affectedRows > 0;
        } catch (Exception e) {
            throw new Exception("Error changing product status: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }
    
    /**
     * Bulk operations for products
     */
    public boolean bulkUpdateProductStatus(List<Integer> productIds, int status, int sellerId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBContext.getConnection();
            StringBuilder sql = new StringBuilder();
            sql.append("UPDATE Product SET status = ?, updatedDate = GETDATE() ");
            sql.append("WHERE pid IN (");
            for (int i = 0; i < productIds.size(); i++) {
                if (i > 0) sql.append(",");
                sql.append("?");
            }
            sql.append(") AND villageID IN (SELECT villageID FROM CraftVillage WHERE sellerId = ?)");
            
            ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, status);
            
            for (int i = 0; i < productIds.size(); i++) {
                ps.setInt(i + 2, productIds.get(i));
            }
            ps.setInt(productIds.size() + 2, sellerId);
            
            int affectedRows = ps.executeUpdate();
            success = affectedRows > 0;
        } catch (Exception e) {
            throw new Exception("Error bulk updating products: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }
    
    /**
     * Get product statistics for seller dashboard
     */
    public Map<String, Object> getSellerProductStats(int sellerId) {
        Map<String, Object> stats = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            
            // Total products
            String sql1 = "SELECT COUNT(*) as total FROM Product p " +
                         "INNER JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                         "WHERE cv.sellerId = ? AND p.status != 0";
            ps = conn.prepareStatement(sql1);
            ps.setInt(1, sellerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalProducts", rs.getInt("total"));
            }
            rs.close(); ps.close();
            
            // Active products
            String sql2 = "SELECT COUNT(*) as active FROM Product p " +
                         "INNER JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                         "WHERE cv.sellerId = ? AND p.status = 1";
            ps = conn.prepareStatement(sql2);
            ps.setInt(1, sellerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("activeProducts", rs.getInt("active"));
            }
            rs.close(); ps.close();
            
            // Low stock products (less than 10)
            String sql3 = "SELECT COUNT(*) as lowStock FROM Product p " +
                         "INNER JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                         "WHERE cv.sellerId = ? AND p.status = 1 AND p.stock < 10";
            ps = conn.prepareStatement(sql3);
            ps.setInt(1, sellerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("lowStockProducts", rs.getInt("lowStock"));
            }
            rs.close(); ps.close();
            
            // Pending products
            String sql4 = "SELECT COUNT(*) as pending FROM Product p " +
                         "INNER JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                         "WHERE cv.sellerId = ? AND p.status = 3";
            ps = conn.prepareStatement(sql4);
            ps.setInt(1, sellerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("pendingProducts", rs.getInt("pending"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return stats;
    }
    
    /**
     * Get low stock products for seller
     */
    public List<Product> getLowStockProducts(int sellerId, int threshold) {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT p.* FROM Product p " +
                        "INNER JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                        "WHERE cv.sellerId = ? AND p.status = 1 AND p.stock <= ? " +
                        "ORDER BY p.stock ASC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, sellerId);
            ps.setInt(2, threshold);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return products;
    }
    
    /**
     * Check if seller owns the product
     */
    public boolean isProductOwnedBySeller(int productId, int sellerId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean owned = false;
        
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT COUNT(*) FROM Product p " +
                        "INNER JOIN CraftVillage cv ON p.villageID = cv.villageID " +
                        "WHERE p.pid = ? AND cv.sellerId = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, sellerId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                owned = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return owned;
    }

    /**
     * Add a new product image
     */
    public boolean addProductImage(entity.Product.ProductImage productImage) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "INSERT INTO ProductImage (productID, imageUrl, isMain, altText, displayOrder, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, productImage.getProductID());
            ps.setString(2, productImage.getImageUrl());
            ps.setBoolean(3, productImage.isIsMain());
            ps.setString(4, productImage.getAltText());
            ps.setInt(5, productImage.getDisplayOrder());
            ps.setInt(6, productImage.getStatus());
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Update product image
     */
    public boolean updateProductImage(entity.Product.ProductImage productImage) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "UPDATE ProductImage SET imageUrl = ?, isMain = ?, altText = ?, " +
                        "displayOrder = ?, status = ?, updatedDate = CURRENT_TIMESTAMP " +
                        "WHERE imageID = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, productImage.getImageUrl());
            ps.setBoolean(2, productImage.isIsMain());
            ps.setString(3, productImage.getAltText());
            ps.setInt(4, productImage.getDisplayOrder());
            ps.setInt(5, productImage.getStatus());
            ps.setInt(6, productImage.getImageID());
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Delete product image
     */
    public boolean deleteProductImage(int imageId) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            String sql = "DELETE FROM ProductImage WHERE imageID = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, imageId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }
}