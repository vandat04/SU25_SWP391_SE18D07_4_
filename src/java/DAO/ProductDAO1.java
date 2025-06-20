///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package DAO;
//
//import context.DBContext;
//
//import entity.Product.Product;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//import service.IProductService;
//
///**
// *
// * @author DELL
// */
//public class ProductDAO1 implements IProductService {
//
//    private static final Logger LOGGER = Logger.getLogger(ProductDAO1.class.getName());
//
//    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM Product WHERE status = 1";
//    private static final String SELECT_PRODUCT_BY_ID = "SELECT * FROM Product WHERE pid = ?";
//    private static final String SELECT_PRODUCT_BY_CATE_ID = "SELECT * FROM Product WHERE categoryID = ?";
//    private static final String SELECT_PRODUCT_BY_VILLAGE_ID = "SELECT * FROM Product WHERE villageID = ? AND status = 1";
//    private static final String SELECT_ALL_CATEGORIES = "SELECT * FROM Category";
//    private static final String DELETE_PRODUCT = "UPDATE Product SET status = 0, updatedDate = GETDATE() WHERE pid = ?";
//    private static final String INSERT_PRODUCT = "INSERT INTO Product (name, price, description, stock, status, villageID, categoryID, mainImageUrl, createdDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
//    private static final String UPDATE_PRODUCT = "UPDATE Product SET name=?, price=?, description=?, stock=?, status=?, categoryID=?, mainImageUrl=?, updatedDate=GETDATE() WHERE pid=?";
//    private static final String SEARCH_BY_TEXT = "SELECT * FROM Product WHERE status = 1 AND (name LIKE ? OR description LIKE ?)";
//    private static final String TOP_5 = "SELECT TOP 5 * FROM Product WHERE status = 1 ORDER BY createdDate DESC";
//    private static final String UPDATE_STOCK = "UPDATE Product SET stock = ?, status = ?, updatedDate = GETDATE() WHERE pid = ?";
//    private static final String UPDATE_CLICK_COUNT = "UPDATE Product SET clickCount = clickCount + 1, lastClicked = GETDATE() WHERE pid = ?";
//    private static final String GET_TOP_PRODUCTS = "SELECT TOP (?) * FROM Product WHERE status = 1 ORDER BY clickCount DESC, lastClicked DESC";
//
//    public ProductDAO1() {
//    }
//
//    // Helper method to close resources
//    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
//        try {
//            if (rs != null) rs.close();
//            if (ps != null) ps.close();
//            if (conn != null) conn.close();
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error closing database resources", e);
//        }
//    }
//
//    @Override
//    public List<Product> getAllProduct() {
//        String sql = "SELECT * FROM Product";
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = DBContext.getConnection();
//            ps = conn.prepareStatement(sql);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all products", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public List<Product> getAllActiveProducts() {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            // Query cho user - chỉ lấy sản phẩm active
//            String sql = "SELECT * FROM Product WHERE status = 1";
//            ps = conn.prepareStatement(sql);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting active products", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public Product getProductByID(String id) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_PRODUCT_BY_ID);
//            ps.setString(1, id);
//            rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return mapResultSetToProduct(rs);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting product by ID: " + id, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return null;
//    }
//
//    @Override
//    public List<Product> getProductByCID(String cid) {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_PRODUCT_BY_CATE_ID);
//            ps.setString(1, cid);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting products by category ID: " + cid, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public List<Product> getProductBySellID(int id) {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            // Query cho admin/seller - lấy tất cả sản phẩm của seller
//            String sql = "SELECT * FROM Product WHERE villageID = ?";
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, id);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting products by village ID: " + id, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public List<Product> getActiveProductsBySellID(int id) {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            // Query cho user - chỉ lấy sản phẩm active của seller
//            String sql = "SELECT * FROM Product WHERE villageID = ? AND status = 1";
//            ps = conn.prepareStatement(sql);
//            ps.setInt(1, id);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting active products by village ID: " + id, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public List<Category> getAllCategory() {
//        List<Category> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SELECT_ALL_CATEGORIES);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                Category category = new Category();
//                category.setCid(rs.getInt("cid"));
//                category.setName(rs.getString("cname"));
//                list.add(category);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all categories", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public boolean deleteProduct(String pid) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//        boolean success = false;
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(DELETE_PRODUCT);
//            ps.setString(1, pid);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Product status updated successfully for ID: {0}", pid);
//                success = true;
//            } else {
//                LOGGER.log(Level.WARNING, "No product found to update with ID: {0}", pid);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error deleting product with ID: " + pid, e);
//        } finally {
//            closeResources(conn, ps, null);
//        }
//        return success;
//    }
//
//    @Override
//    public void insertProduct(String name, String image, String price, String description, String category, int sid, String stock, String status) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(INSERT_PRODUCT);
//
//            ps.setString(1, name);
//            ps.setBigDecimal(2, new java.math.BigDecimal(price));
//            ps.setString(3, description);
//            ps.setInt(4, Integer.parseInt(stock));
//            ps.setInt(5, Integer.parseInt(status));
//            ps.setInt(6, sid);
//            ps.setInt(7, Integer.parseInt(category));
//            ps.setString(8, image);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Product added successfully: {0}", name);
//            } else {
//                LOGGER.log(Level.WARNING, "Failed to add product: {0}", name);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error inserting product: " + name, e);
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    @Override
//    public void updateProduct(int id, String name, String image, double price, String description, int stock, int status, int category) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_PRODUCT);
//
//            ps.setString(1, name);
//            ps.setDouble(2, price);
//            ps.setString(3, description);
//            ps.setInt(4, stock);
//            ps.setInt(5, status);
//            ps.setInt(6, category);
//            ps.setString(7, image);
//            ps.setInt(8, id);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Product updated successfully for ID: {0}", id);
//            } else {
//                LOGGER.log(Level.WARNING, "No product found to update with ID: {0}", id);
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating product with ID: " + id, e);
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    @Override
//    public List<Product> getTop5NewestProducts() {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(TOP_5);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting top 5 newest products", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public List<Product> searchByName(String txtSearch) {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(SEARCH_BY_TEXT);
//            String searchPattern = "%" + txtSearch + "%";
//            ps.setString(1, searchPattern);
//            ps.setString(2, searchPattern);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error searching products with text: " + txtSearch, e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public boolean updateStock(int productId, int newStock) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_STOCK);
//
//            ps.setInt(1, newStock);
//            ps.setInt(2, newStock > 0 ? 1 : 0);
//            ps.setInt(3, productId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Stock updated successfully for product ID: {0}", productId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No product found to update stock with ID: {0}", productId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating stock for product ID: " + productId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public boolean updateClickCount(int productId) {
//        Connection conn = null;
//        PreparedStatement ps = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(UPDATE_CLICK_COUNT);
//            ps.setInt(1, productId);
//
//            int rowsAffected = ps.executeUpdate();
//            if (rowsAffected > 0) {
//                LOGGER.log(Level.INFO, "Click count updated for product ID: {0}", productId);
//                return true;
//            } else {
//                LOGGER.log(Level.WARNING, "No product found to update click count with ID: {0}", productId);
//                return false;
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error updating click count for product ID: " + productId, e);
//            return false;
//        } finally {
//            closeResources(conn, ps, null);
//        }
//    }
//
//    public List<Product> getTopProductsByClicks(int limit) {
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = new DBContext().getConnection();
//            ps = conn.prepareStatement(GET_TOP_PRODUCTS);
//            ps.setInt(1, limit);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting top products by clicks", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//
//    @Override
//    public List<Product> getProductsByCategoryAndPriceRangeAndOrder(String cateID, String priceRange, String orderBy) {
//        List<Product> list = new ArrayList<>();
//        StringBuilder query = new StringBuilder("SELECT * FROM Product WHERE status = 1");
//        
//        // Add category filter if specified
//        if (cateID != null && !cateID.isEmpty() && !cateID.equals("all")) {
//            query.append(" AND categoryID = ?");
//        }
//        
//        // Add price range filter
//        if (priceRange != null && !priceRange.isEmpty() && !priceRange.equals("all")) {
//            switch (priceRange) {
//                case "0-100":
//                    query.append(" AND price <= 100000");
//                    break;
//                case "100-150":
//                    query.append(" AND price > 100000 AND price <= 150000");
//                    break;
//                case "150-max":
//                    query.append(" AND price > 150000");
//                    break;
//            }
//        }
//        
//        // Add ordering
//        if (orderBy != null && !orderBy.isEmpty()) {
//            switch (orderBy) {
//                case "price":
//                    query.append(" ORDER BY price ASC");
//                    break;
//                case "price-desc":
//                    query.append(" ORDER BY price DESC");
//                    break;
//                case "date":
//                    query.append(" ORDER BY createdDate DESC");
//                    break;
//                default:
//                    query.append(" ORDER BY pid ASC");
//                    break;
//            }
//        }
//        
//        try (Connection conn = new DBContext().getConnection();
//             PreparedStatement ps = conn.prepareStatement(query.toString())) {
//            
//            int paramIndex = 1;
//            if (cateID != null && !cateID.isEmpty() && !cateID.equals("all")) {
//                ps.setString(paramIndex++, cateID);
//            }
//            
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting products by category and price range", e);
//        }
//        
//        return list;
//    }
//
//    @Override
//    public List<Product> getProductsByNameAndPriceRangeAndOrder(String searchText, String priceRange, String orderBy) {
//        List<Product> list = new ArrayList<>();
//        StringBuilder query = new StringBuilder("SELECT * FROM Product WHERE status = 1");
//        
//        // Add search text filter
//        if (searchText != null && !searchText.isEmpty()) {
//            query.append(" AND (name LIKE ? OR description LIKE ?)");
//        }
//        
//        // Add price range filter
//        if (priceRange != null && !priceRange.isEmpty() && !priceRange.equals("all")) {
//            switch (priceRange) {
//                case "0-100":
//                    query.append(" AND price <= 100000");
//                    break;
//                case "100-150":
//                    query.append(" AND price > 100000 AND price <= 150000");
//                    break;
//                case "150-max":
//                    query.append(" AND price > 150000");
//                    break;
//            }
//        }
//        
//        // Add ordering
//        if (orderBy != null && !orderBy.isEmpty()) {
//            switch (orderBy) {
//                case "price":
//                    query.append(" ORDER BY price ASC");
//                    break;
//                case "price-desc":
//                    query.append(" ORDER BY price DESC");
//                    break;
//                case "date":
//                    query.append(" ORDER BY createdDate DESC");
//                    break;
//                default:
//                    query.append(" ORDER BY pid ASC");
//                    break;
//            }
//        }
//        
//        try (Connection conn = new DBContext().getConnection();
//             PreparedStatement ps = conn.prepareStatement(query.toString())) {
//            
//            int paramIndex = 1;
//            if (searchText != null && !searchText.isEmpty()) {
//                String searchPattern = "%" + searchText + "%";
//                ps.setString(paramIndex++, searchPattern);
//                ps.setString(paramIndex++, searchPattern);
//            }
//            
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting products by name and price range", e);
//        }
//        
//        return list;
//    }
//
//    @Override
//    public List<Product> getAllProductUser() {
//        // TODO: implement logic
//        return new ArrayList<>();
//    }
//  
//
//    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
//        return new Product(
//            rs.getInt("pid"),
//            rs.getString("name"),
//            rs.getBigDecimal("price"),
//            rs.getString("description"),
//            rs.getInt("stock"),
//            rs.getInt("status"),
//            rs.getInt("villageID"),
//            rs.getInt("categoryID"),
//            rs.getString("mainImageUrl"),
//            rs.getInt("clickCount"),
//            rs.getTimestamp("lastClicked"),
//            rs.getTimestamp("createdDate"),
//            rs.getTimestamp("updatedDate")
//        );
//    }
////------------------------------------------------------------------------------
//    public List<Product> getAllProductByAdmin() {
//        String sql = "SELECT * FROM Product";
//        List<Product> list = new ArrayList<>();
//        Connection conn = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        try {
//            conn = DBContext.getConnection();
//            ps = conn.prepareStatement(sql);
//            rs = ps.executeQuery();
//
//            while (rs.next()) {
//                list.add(mapResultSetToProduct(rs));
//            }
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Error getting all products", e);
//        } finally {
//            closeResources(conn, ps, rs);
//        }
//        return list;
//    }
//    
//    public static void main(String[] args) {
//        ProductDAO1 pdao = new ProductDAO1();
//        System.out.println(pdao.getAllProductByAdmin());
//    }
//}
