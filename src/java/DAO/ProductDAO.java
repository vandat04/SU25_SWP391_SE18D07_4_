/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.Product.Product;
import entity.Product.ProductCategory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ACER
 */
public class ProductDAO {

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
                rs.getString("mainImageUrl"),
                rs.getInt("clickCount"),
                rs.getTimestamp("lastClicked"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate")
        );
    }

    private ProductCategory mapResultSetToProductCategary(ResultSet rs) throws SQLException {
        return new ProductCategory(
                rs.getInt("categoryID"),
                rs.getString("categoryName"),
                rs.getString("description"),
                rs.getInt("status"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate")
        );
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Product getProductByID(String id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT * FROM Product WHERE pid = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return null;
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT * FROM Product";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<Product> getProductByCategoryID(String categoryId) {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT * FROM Product WHERE categoryID = ? AND status = 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<Product> getActiveProducts() {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            // Query cho user - chỉ lấy sản phẩm active của seller
            String sql = "SELECT * FROM Product WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<Product> getTop5NewestProducts() {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            // Query cho user - chỉ lấy sản phẩm active của seller
            String sql = "SELECT TOP 5 * FROM Product WHERE status = 1 ORDER BY createdDate DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<ProductCategory> getAllCategory() {
        List<ProductCategory> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            // Query cho user - chỉ lấy sản phẩm active của seller
            String sql = "SELECT * FROM ProductCategory WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProductCategary(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    /**
     * Search products by name
     */
    public List<Product> searchByName(String name) {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT * FROM Product WHERE name LIKE ? AND status = 1";
            ps = conn.prepareStatement(sql);
            String searchPattern = "%" + name.trim() + "%";
            ps.setString(1, searchPattern);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    /**
     * Get products by name with price range and order filtering
     * Advanced search with filtering and sorting capabilities
     */
    public List<Product> getProductsByNameAndPriceRangeAndOrder(String name, String priceRange, String orderBy) {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE status = 1");
            
            // Add name filter if provided
            if (name != null && !name.trim().isEmpty()) {
                sql.append(" AND (name LIKE ? OR description LIKE ?)");
            }
            
            // Add price range filter if provided
            if (priceRange != null && !priceRange.equals("all")) {
                switch (priceRange) {
                    case "0-100000":
                        sql.append(" AND price <= 100000");
                        break;
                    case "100000-500000":
                        sql.append(" AND price > 100000 AND price <= 500000");
                        break;
                    case "500000-1000000":
                        sql.append(" AND price > 500000 AND price <= 1000000");
                        break;
                    case "1000000+":
                        sql.append(" AND price > 1000000");
                        break;
                }
            }
            
            // Add ordering
            if (orderBy != null && !orderBy.equals("menu_order")) {
                switch (orderBy) {
                    case "date":
                        sql.append(" ORDER BY createdDate DESC");
                        break;
                    case "price":
                        sql.append(" ORDER BY price ASC");
                        break;
                    case "price-desc":
                        sql.append(" ORDER BY price DESC");
                        break;
                    default:
                        sql.append(" ORDER BY createdDate DESC");
                        break;
                }
            } else {
                sql.append(" ORDER BY createdDate DESC");
            }
            
            ps = conn.prepareStatement(sql.toString());
            
            // Set parameters for name search if provided
            if (name != null && !name.trim().isEmpty()) {
                String searchParam = "%" + name.trim() + "%";
                ps.setString(1, searchParam);
                ps.setString(2, searchParam);
            }
            
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    /**
     * Get products by category with price range and order filtering
     */
    public List<Product> getProductsByCategoryAndPriceRangeAndOrder(String cateID, String priceRange, String orderBy) {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE status = 1 AND categoryID = ?");
            
            // Add price range filter if provided
            if (priceRange != null && !priceRange.equals("all")) {
                switch (priceRange) {
                    case "0-100000":
                        sql.append(" AND price <= 100000");
                        break;
                    case "100000-500000":
                        sql.append(" AND price > 100000 AND price <= 500000");
                        break;
                    case "500000-1000000":
                        sql.append(" AND price > 500000 AND price <= 1000000");
                        break;
                    case "1000000+":
                        sql.append(" AND price > 1000000");
                        break;
                }
            }
            
            // Add ordering
            if (orderBy != null && !orderBy.equals("menu_order")) {
                switch (orderBy) {
                    case "date":
                        sql.append(" ORDER BY createdDate DESC");
                        break;
                    case "price":
                        sql.append(" ORDER BY price ASC");
                        break;
                    case "price-desc":
                        sql.append(" ORDER BY price DESC");
                        break;
                    default:
                        sql.append(" ORDER BY createdDate DESC");
                        break;
                }
            } else {
                sql.append(" ORDER BY createdDate DESC");
            }
            
            ps = conn.prepareStatement(sql.toString());
            ps.setString(1, cateID);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    /**
     * Get most clicked products
     */
    public List<Product> getMostClickedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT TOP (?) * FROM Product WHERE status = 1 ORDER BY clickCount DESC, lastClicked DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public static void main(String[] args) {

    }
}
