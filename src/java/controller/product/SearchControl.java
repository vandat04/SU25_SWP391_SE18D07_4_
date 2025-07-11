/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.product;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.ProductService;
import service.CategoryService;
import entity.Product.Product;
import entity.Product.ProductCategory;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * SearchControl - Controller for product search functionality
 * Follows MVC pattern: Client → Controller → Service → DAO → Database
 */
@WebServlet(name = "SearchControl", urlPatterns = {"/search"})
public class SearchControl extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(SearchControl.class.getName());
    private final ProductService productService;
    private final CategoryService categoryService;
    
    public SearchControl() {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try {
            LOGGER.log(Level.INFO, "Processing search request");
            
            // Get and validate search parameters
            SearchParameters params = extractSearchParameters(request);
            
            // Perform search and get related data
            SearchResult searchResult = performSearch(params);
            
            // Set attributes for JSP
            setSearchAttributes(request, searchResult, params);
            
            LOGGER.log(Level.INFO, "Search completed. Found {0} products for keyword: {1}", 
                      new Object[]{searchResult.filteredProducts.size(), params.searchKeyword});
            
            // Forward to Category.jsp
            request.getRequestDispatcher("Category.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in search functionality", e);
            handleSearchError(request, response, e);
        }
    }
    
    /**
     * Extract and validate search parameters from request
     */
    private SearchParameters extractSearchParameters(HttpServletRequest request) {
        // Get search keyword from different possible parameters
        String searchKeyword = request.getParameter("txt");
        if (searchKeyword == null || searchKeyword.trim().isEmpty()) {
            searchKeyword = request.getParameter("name");
        }
        if (searchKeyword == null || searchKeyword.trim().isEmpty()) {
            searchKeyword = "";
        }
        
        // Handle price filtering and ordering
        String priceRange = request.getParameter("price");
        if (priceRange == null || priceRange.isEmpty()) {
            priceRange = "all";
        }
        
        String orderBy = request.getParameter("orderby");
        if (orderBy == null || orderBy.isEmpty()) {
            orderBy = "menu_order";
        }
        
        LOGGER.log(Level.INFO, "Search keyword: {0}", searchKeyword);
        
        return new SearchParameters(searchKeyword, priceRange, orderBy);
    }
    
    /**
     * Perform search and get all related data
     */
    private SearchResult performSearch(SearchParameters params) {
        // Controller calls Service layer for business logic
        List<Product> searchResults = productService.searchByName(params.searchKeyword);
        List<ProductCategory> categories = categoryService.getAllCategories();
        List<Product> newestProducts = productService.getTop5NewestProducts();
        List<Product> allProducts = productService.getAllProducts();
        
        // Get filtered and ordered products
        List<Product> filteredProducts = applyAdvancedFiltering(
            params.searchKeyword, params.priceRange, params.orderBy, searchResults);
        
        return new SearchResult(filteredProducts, searchResults, categories, newestProducts, allProducts);
    }
    
    /**
     * Apply advanced filtering if available, fallback to basic results
     */
    private List<Product> applyAdvancedFiltering(String searchKeyword, String priceRange, 
            String orderBy, List<Product> basicResults) {
        try {
            // Try to use advanced filtering if available
            return productService.getProductsByNameAndPriceRangeAndOrder(
                searchKeyword, priceRange, orderBy);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Advanced filtering not available, using basic search results", e);
            return basicResults;
        }
    }
    
    /**
     * Set all search-related attributes for JSP
     */
    private void setSearchAttributes(HttpServletRequest request, SearchResult result, SearchParameters params) {
        request.setAttribute("productList", result.filteredProducts);
        request.setAttribute("listP", result.filteredProducts); // For compatibility
        request.setAttribute("listPP", result.allProducts);
        request.setAttribute("listCC", result.categories);
        request.setAttribute("list5", result.newestProducts);
        request.setAttribute("selectedPrice", params.priceRange);
        request.setAttribute("searchKeyword", params.searchKeyword);
        request.setAttribute("txt", params.searchKeyword); // For compatibility
    }
    
    /**
     * Handle search errors by setting error attributes and forwarding to page
     */
    private void handleSearchError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        // Set error message and empty results
        request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm sản phẩm: " + e.getMessage());
        request.setAttribute("productList", java.util.Collections.emptyList());
        request.setAttribute("listP", java.util.Collections.emptyList());
        request.setAttribute("listCC", java.util.Collections.emptyList());
        request.setAttribute("list5", java.util.Collections.emptyList());
        request.setAttribute("listPP", java.util.Collections.emptyList());
        
        request.getRequestDispatcher("Category.jsp").forward(request, response);
    }
    
    /**
     * Helper class to hold search parameters
     */
    private static class SearchParameters {
        final String searchKeyword;
        final String priceRange;
        final String orderBy;
        
        SearchParameters(String searchKeyword, String priceRange, String orderBy) {
            this.searchKeyword = searchKeyword;
            this.priceRange = priceRange;
            this.orderBy = orderBy;
        }
    }
    
    /**
     * Helper class to hold search results
     */
    private static class SearchResult {
        final List<Product> filteredProducts;
        final List<Product> searchResults;
        final List<ProductCategory> categories;
        final List<Product> newestProducts;
        final List<Product> allProducts;
        
        SearchResult(List<Product> filteredProducts, List<Product> searchResults,
                    List<ProductCategory> categories, List<Product> newestProducts,
                    List<Product> allProducts) {
            this.filteredProducts = filteredProducts;
            this.searchResults = searchResults;
            this.categories = categories;
            this.newestProducts = newestProducts;
            this.allProducts = allProducts;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "SearchControl - Handles product search requests following MVC pattern";
    }
} 