package controller.product;

import entity.Product.Product;
import entity.Product.ProductCategory;
import service.ProductService;
import service.CategoryService;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CategoryControl", urlPatterns = {"/category"})
public class CategoryControl extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CategoryControl.class.getName());
    private ProductService productService;
    private CategoryService categoryService;
    
    public CategoryControl() {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Get parameters - support both cid and categoryID for compatibility
            String cid = request.getParameter("cid");
            String categoryID = request.getParameter("categoryID");
            
            // Use categoryID if cid is not provided (for compatibility with Menu.jsp and Footer.jsp)
            if (cid == null || cid.trim().isEmpty()) {
                cid = categoryID;
            }
            
            String priceRange = request.getParameter("price");
            String orderBy = request.getParameter("orderby");
            
            // Set default values
            if (priceRange == null || priceRange.isEmpty()) {
                priceRange = "all";
            }
            if (orderBy == null || orderBy.isEmpty()) {
                orderBy = "menu_order";
            }
            
            LOGGER.log(Level.INFO, "Processing category request - cid: {0}, categoryID: {1}, price: {2}, orderby: {3}", 
                      new Object[]{cid, categoryID, priceRange, orderBy});
            
            // Get products by category with filtering and sorting
            List<Product> listP;
            if (cid != null && !cid.trim().isEmpty()) {
                // Get products by category with price filtering and ordering
                listP = productService.getProductsByCategoryAndPriceAndOrder(cid, priceRange, orderBy);
            } else {
                // If no category specified, get all products
                listP = productService.getProductsByNameAndPriceRangeAndOrder("", priceRange, orderBy);
            }
            
            // Get top 5 newest products for sidebar
            List<Product> list5 = productService.getTop5NewestProducts();
            
            // Get categories for mapping categoryID to categoryName
            List<ProductCategory> categories = categoryService.getAllCategories();
            
            // Get category name if cid is provided
            String categoryName = "";
            if (cid != null && !cid.trim().isEmpty()) {
                try {
                    int catIdInt = Integer.parseInt(cid);
                    categoryName = categoryService.getCategoryNameById(catIdInt);
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid category ID: {0}", cid);
                    categoryName = "";
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("listP", listP);
            request.setAttribute("list5", list5);
            request.setAttribute("listCC", categories);
            request.setAttribute("cid", cid);
            request.setAttribute("categoryName", categoryName);
            request.setAttribute("selectedPrice", priceRange);
            request.setAttribute("orderby", orderBy);
            
            LOGGER.log(Level.INFO, "Category page loaded successfully. Products: {0}, Categories: {1}", 
                      new Object[]{listP.size(), categories.size()});
            
            // Forward to Category.jsp
            request.getRequestDispatcher("Category.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryControl", e);
            
            // Set error message and forward with empty lists
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh mục sản phẩm: " + e.getMessage());
            request.setAttribute("listP", java.util.Collections.emptyList());
            request.setAttribute("list5", java.util.Collections.emptyList());
            request.setAttribute("listCC", java.util.Collections.emptyList());
            
            request.getRequestDispatcher("Category.jsp").forward(request, response);
        }
    }
} 