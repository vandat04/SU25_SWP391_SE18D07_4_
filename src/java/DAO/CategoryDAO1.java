//package DAO;
//
//import context.DBContext;
//import entity.Category;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//
//public class CategoryDAO1 extends DBContext {
//    
//    public List<Category> getAllCategories() {
//        List<Category> list = new ArrayList<>();
//        String sql = "SELECT * FROM Category";
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            
//            while (rs.next()) {
//                Category category = new Category();
//                category.setCid(rs.getInt("cid"));
//                category.setName(rs.getString("name"));
//                category.setDescription(rs.getString("description"));
//                category.setImageUrl(rs.getString("imageUrl"));
//                category.setStatus(rs.getInt("status"));
//                category.setCreatedDate(rs.getTimestamp("createdDate"));
//                category.setUpdatedDate(rs.getTimestamp("updatedDate"));
//                list.add(category);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//    
//    public boolean addCategory(Category category) {
//        String sql = "INSERT INTO Category (name, description, imageUrl, status, createdDate) VALUES (?, ?, ?, ?, ?)";
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setString(1, category.getName());
//            ps.setString(2, category.getDescription());
//            ps.setString(3, category.getImageUrl());
//            ps.setInt(4, category.getStatus());
//            ps.setTimestamp(5, category.getCreatedDate());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    public boolean updateCategory(Category category) {
//        String sql = "UPDATE Category SET name = ?, description = ?, imageUrl = ?, status = ?, updatedDate = ? WHERE cid = ?";
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setString(1, category.getName());
//            ps.setString(2, category.getDescription());
//            ps.setString(3, category.getImageUrl());
//            ps.setInt(4, category.getStatus());
//            ps.setTimestamp(5, category.getUpdatedDate());
//            ps.setInt(6, category.getCid());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    public boolean deleteCategory(int categoryID) {
//        String sql = "UPDATE Category SET status = 0 WHERE cid = ?";
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setInt(1, categoryID);
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    public Category getCategoryById(int categoryID) {
//        String sql = "SELECT * FROM Category WHERE cid = ?";
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            
//            ps.setInt(1, categoryID);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    Category category = new Category();
//                    category.setCid(rs.getInt("cid"));
//                    category.setName(rs.getString("name"));
//                    category.setDescription(rs.getString("description"));
//                    category.setImageUrl(rs.getString("imageUrl"));
//                    category.setStatus(rs.getInt("status"));
//                    category.setCreatedDate(rs.getTimestamp("createdDate"));
//                    category.setUpdatedDate(rs.getTimestamp("updatedDate"));
//                    return category;
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//} 