/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.ProductDAO;
import entity.Product.Product;
import entity.Product.ProductCategory;
import entity.Product.ProductReview;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ACER
 */
public class ProductService implements IProductService{

    ProductDAO pDAO = new ProductDAO();
    
    @Override
    public int addProduct(Product product) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateProduct(Product product){
                throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
    public List<ProductCategory> getAllCategory() {
        return pDAO.getAllCategory();
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
    public boolean updateProductByAdmin(Product product){
        return pDAO.updateProductByAdmin(product);
    }
    
    @Override
    public boolean createProductByAdmin(Product product){
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
}
