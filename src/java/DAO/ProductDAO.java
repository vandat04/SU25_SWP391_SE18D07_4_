/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.CartWishList.CartItem;
import entity.CartWishList.CartTicket;
import entity.Product.Product;
import entity.Product.ProductCategory;
import entity.Ticket.Ticket;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.sql.Types;
import java.sql.CallableStatement;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author ACER
 */
public class ProductDAO {

    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

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

    private ProductCategory mapResultSetToProductCategory(ResultSet rs) throws SQLException {
        return new ProductCategory(
                rs.getInt("categoryID"),
                rs.getString("categoryName"),
                rs.getString("description"),
                rs.getInt("status"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate")
        );
    }

    private Product mapResultSetToProduct1(ResultSet rs) throws SQLException {
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

    private Ticket mapResultSetToTicket(ResultSet rs) throws SQLException {
        return new Ticket(
                rs.getInt("ticketID"),
                rs.getInt("villageID"),
                rs.getInt("typeID"),
                rs.getBigDecimal("price"),
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
                list.add(mapResultSetToProduct1(rs));
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

    public List<Product> getAllProductActive() {
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
                list.add(mapResultSetToProduct1(rs));
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

    public List<Product> getAllProductActiveByAdmin() {
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
                list.add(mapResultSetToProduct1(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

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

    public List<Ticket> getAllTicketActive() {
        List<Ticket> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT * FROM VillageTicket WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTicket(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public boolean updateProductByAdmin(Product product) {
        String sql = "{CALL UpdateProductFull(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, product.getPid());
            cs.setString(2, product.getName());
            cs.setBigDecimal(3, product.getPrice());
            cs.setString(4, product.getDescription());
            cs.setInt(5, product.getStock());
            cs.setInt(6, product.getStockAdd());
            cs.setInt(7, product.getStatus());
            cs.setInt(8, product.getVillageID());
            cs.setInt(9, product.getCategoryID());
            cs.setString(10, product.getMainImageUrl());
            cs.setInt(11, product.getCraftTypeID());
            cs.setString(12, product.getSku());
            cs.setBigDecimal(13, product.getWeight());
            cs.setString(14, product.getDimensions());
            cs.setString(15, product.getMaterials());
            cs.setString(16, product.getCareInstructions());
            cs.setString(17, product.getWarranty());
            cs.setString(18, product.getModelFile());

            // Output param
            cs.registerOutParameter(19, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(19);
            return result == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createProductByAdmin(Product product) {
        String sql = "{CALL CreateProductFull( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, product.getName());
            cs.setBigDecimal(2, product.getPrice());
            cs.setString(3, product.getDescription());
            cs.setInt(4, product.getStock());
            cs.setInt(5, product.getStatus());
            cs.setInt(6, product.getVillageID());
            cs.setInt(7, product.getCategoryID());
            cs.setString(8, product.getMainImageUrl());
            cs.setInt(9, product.getCraftTypeID());
            cs.setString(10, product.getSku());
            cs.setBigDecimal(11, product.getWeight());
            cs.setString(12, product.getDimensions());
            cs.setString(13, product.getMaterials());
            cs.setString(14, product.getCareInstructions());
            cs.setString(15, product.getWarranty());
            cs.setString(16, product.getModelFile());

            // Output parameter
            cs.registerOutParameter(17, Types.INTEGER);

            cs.execute();

            int result = cs.getInt(17);

            switch (result) {
                case 1:
                    return true;
                case -1:
                    System.out.println("Tên sản phẩm đã tồn tại.");
                    break;
                case 0:
                default:
                    System.out.println("Đã xảy ra lỗi khi tạo sản phẩm.");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProductByAdmin(int productId) {
        String sql = "{CALL DeleteProductByAdmin( ?, ?)}";
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, productId);
            // Output parameter
            cs.registerOutParameter(2, Types.INTEGER);

            cs.execute();
            if (cs.getInt(2) == 1) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> getSearchProductByAdmin(int status, int searchID, String contentSearch) {
        String query;
        contentSearch = contentSearch.trim();
        switch (searchID) {
            case 1:
                query = "SELECT * FROM Product WHERE  status = ? and categoryID LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 2:
                query = "SELECT * FROM Product WHERE status = ? and name COLLATE Latin1_General_CI_AI LIKE ? ORDER BY name ASC ";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 3:
                query = "SELECT * FROM Product WHERE status = ? and name COLLATE Latin1_General_CI_AI LIKE ? ORDER BY name DESC ";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 4:
                query = "SELECT * FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 5:
                query = "SELECT * FROM Product WHERE status = ? and pid LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 6:
                query = "SELECT * FROM Product WHERE  status = ?  AND price BETWEEN ? AND ?";
                break;
            case 7:
                query = "SELECT *  FROM Product  WHERE status = ?  AND CONVERT(date, createdDate) = CONVERT(date, GETDATE())";
                break;
            default:
                query = "SELECT * FROM Product WHERE status = ? and name COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%"; // Cho phép tìm gần đúng
                break;
        }

        List<Product> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, status);
            if (searchID == 6) {
                double price = Double.parseDouble(contentSearch);
                ps.setDouble(2, price * 0.8);
                ps.setDouble(3, price * 1.2);
            } else if (searchID == 7) {
            } else {
                ps.setString(2, contentSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct1(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log tốt hơn
        }
        return list;
    }

    /**
     * Get products by name with price range and order filtering Advanced search
     * with filtering and sorting capabilities
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

    public List<Product> getProductByCategory(int categoryID) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM Product WHERE  categoryID = ? and status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct1(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log tốt hơn
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
                list.add(mapResultSetToProduct1(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<Product> getProductOutOfStockByAdmin() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM Product WHERE  stock = 0 and status = 1 ORDER BY categoryID";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct1(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log tốt hơn
        }
        return list;
    }

    public String getCategoryNameByCategoryID(int categoryID) {
        String query = "SELECT categoryName FROM ProductCategory WHERE categoryID = ? AND status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("categoryName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return "";
    }

    public List<Product> getTopRatedByAdmin() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM Product WHERE averageRating >= 4.5 and averageRating <= 5 AND status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct1(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
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

    public List<Product> getProductsByVillage(int villageId) {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            String sql = "SELECT * FROM Product WHERE villageID = ? AND status = 1";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, villageId);
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
     * Check if a product is owned by a specific seller
     *
     * @param productID The product ID
     * @param sellerID The seller ID
     * @return true if the product is owned by the seller
     */
    public boolean isProductOwnedBySeller(int productID, int sellerID) {
        String query = "SELECT COUNT(*) FROM Product p "
                + "JOIN CraftVillage cv ON p.villageID = cv.villageID "
                + "WHERE p.pid = ? AND cv.sellerId = ? AND p.status = 1 AND cv.status = 1";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productID);
            ps.setInt(2, sellerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error checking if product is owned by seller: " + e.getMessage());
        }

        return false;
    }

    public String getProduct3D(int productID) {
        String query = "SELECT modelFile FROM Product WHERE productID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("modelFile");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return "";
    }

    public int getVillageIDByProductID(int productID) {
        String query = "SELECT villageID FROM Product WHERE pid = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("villageID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return 0;
    }

    public String getModelFileByProductID(int productID) {
        String query = "SELECT modelFile FROM Product WHERE pid = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("modelFile");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return "";
    }

    public Integer getVillageIDByTicketID(int ticketId) {
        String query = "SELECT villageID FROM VillageTicket WHERE ticketID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("villageID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return 0;
    }

    public Map<Integer, BigDecimal> getSetVillage(List<CartItem> cartItem, List<CartTicket> cartTicket) {
        Map<Integer, BigDecimal> villageMap = new HashMap<>();
        ProductDAO productDAO = new ProductDAO();
        // Xử lý CartItem: cộng price * quantity theo villageID
        for (CartItem ci : cartItem) {
            int villageID = productDAO.getVillageIDByProductID(ci.getProductID());
            BigDecimal itemTotal = BigDecimal.valueOf(ci.getPrice()).multiply(BigDecimal.valueOf(ci.getQuantity()));

            villageMap.put(villageID, villageMap.getOrDefault(villageID, BigDecimal.ZERO).add(itemTotal));
        }
        // Xử lý CartTicket: cộng price * quantity theo villageID
        for (CartTicket ct : cartTicket) {
            int villageID = productDAO.getVillageIDByTicketID(ct.getTicketId());
            BigDecimal ticketTotal = BigDecimal.valueOf(ct.getPrice()).multiply(BigDecimal.valueOf(ct.getQuantity()));

            villageMap.put(villageID, villageMap.getOrDefault(villageID, BigDecimal.ZERO).add(ticketTotal));
        }
        return villageMap;

    }

    public int getTotalActiveProducts() {
        int count = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            String sql = "SELECT COUNT(*) FROM Product WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return count;
    }

    public List<Product> getSearchProductByAdmin(int status, int searchID, String contentSearch, int offset, int limit) {
        String query;
        contentSearch = contentSearch == null ? "" : contentSearch.trim();

        switch (searchID) {
            case 1:
                query = "SELECT * FROM Product WHERE status = ? AND categoryID LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 2:
                query = "SELECT * FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ? ORDER BY name ASC";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 3:
                query = "SELECT * FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ? ORDER BY name DESC";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 4:
                query = "SELECT * FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ? ORDER BY createdDate DESC";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 5:
                query = "SELECT * FROM Product WHERE status = ? AND pid LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 6:
                query = "SELECT * FROM Product WHERE status = ? ORDER BY price ASC";
                break;
            case 8:
                query = "SELECT * FROM Product WHERE status = ? ORDER BY price DESC";
                break;
            case 7:
                query = "SELECT * FROM Product WHERE status = ? AND CONVERT(date, createdDate) = CONVERT(date, GETDATE()) ORDER BY createdDate DESC";
                break;
            case 10: // stock low -> high
                query = "SELECT * FROM Product WHERE status = ? ORDER BY stock ASC";
                break;
            case 11: // stock high -> low
                query = "SELECT * FROM Product WHERE status = ? ORDER BY stock DESC";
                break;
            default:
                query = "SELECT * FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ? ORDER BY createdDate DESC";
                contentSearch = "%" + contentSearch + "%";
                break;
        }

        // Bổ sung phân trang nếu cần
        if (!query.toLowerCase().contains("order by")) {
            query += " ORDER BY pid ASC";
        }
        query += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Product> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, status);

            // Chỉ set contentSearch nếu query có LIKE
            if (searchID == 1 || searchID == 2 || searchID == 3 || searchID == 4 || searchID == 5 || searchID == -1 || searchID == 0 ) {
                ps.setString(paramIndex++, contentSearch);
            }

            // OFFSET + LIMIT
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct1(rs));
                }
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static void main(String[] args) {
        System.out.println(new ProductDAO().getSearchProductByAdmin(1, 0, "", 1, 10).size());
    }

    public int getTotalSearchProducts(int status, int searchID, String contentSearch) {
        String query;
        contentSearch = contentSearch != null ? contentSearch.trim() : "";
        int total = 0;

        switch (searchID) {
            case 1:
                query = "SELECT COUNT(*) FROM Product WHERE status = ? AND CAST(categoryID AS NVARCHAR) LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;

            case 2:
                query = "SELECT COUNT(*) FROM Product WHERE status = ? and name COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 3:
                query = "SELECT COUNT(*) FROM Product WHERE status = ? and name COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 4:
                query = "SELECT COUNT(*) FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;

            case 5:
                query = "SELECT COUNT(*) FROM Product WHERE status = ? AND CAST(pid AS NVARCHAR) LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
            case 11:
            case 10:
            case 6: // tìm theo khoảng giá (giá thấp đến cao)
            case 8: // sort theo price ASC
                query = "SELECT COUNT(*) FROM Product WHERE status = ?";
                break;

            case 7: // tạo hôm nay
                query = "SELECT COUNT(*) FROM Product WHERE status = ? AND CONVERT(date, createdDate) = CONVERT(date, GETDATE())";
                break;

            default:
                query = "SELECT COUNT(*) FROM Product WHERE status = ? AND name COLLATE Latin1_General_CI_AI LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                break;
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, status);

            // Chỉ set contentSearch nếu câu query có dấu ? thứ 2
            if (searchID == 1 || searchID == 2 || searchID == 3 || searchID == 4 || searchID == 5 || searchID == -1 || searchID == 0 ) {
                ps.setString(paramIndex++, contentSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    public List<Product> getAllProductActiveByAdmin(int offset, int limit) {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            // Sửa cú pháp thành SQL Server
            String sql = "SELECT * FROM Product WHERE status = 1 ORDER BY pid ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);  // OFFSET trước
            ps.setInt(2, limit);   // FETCH NEXT sau
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
}
