/*
 * Seller Product Management Controller
 * Handles CRUD operations for seller's products
 */
package controller.Seller;

import entity.Account.Account;
import entity.CraftVillage.CraftVillage;
import entity.Product.Product;
import entity.Product.ProductCategory;
import entity.Product.ProductImage;
import entity.CraftVillage.CraftType;
import service.VillageService;
import service.ProductService;
import service.CategoryService;
import constant.CloudinaryUploader;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;
import java.util.List;
import java.util.ArrayList;
import java.sql.Timestamp;

/**
 * Seller Product Management Controller - Handles CRUD operations for products
 * @author ACER
 */
@WebServlet(name = "SellerProductManagement", urlPatterns = {"/seller-product-management"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024, // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class SellerProductManagement extends HttpServlet {
    
    private ProductService productService = new ProductService();
    private CategoryService categoryService = new CategoryService();
    private VillageService villageService = new VillageService();
    private service.SellerService sellerService = new service.SellerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");
        
        // Check authentication and authorization
        if (seller == null || seller.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                handleListProducts(request, response, seller);
                break;
            case "add":
                handleAddProductForm(request, response, seller);
                break;
            case "edit":
                handleEditProductForm(request, response, seller);
                break;
            case "delete":
                handleDeleteProduct(request, response, seller);
                break;
            case "view":
                handleViewProduct(request, response, seller);
                break;
            default:
                handleListProducts(request, response, seller);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");
        
        // Check authentication and authorization
        if (seller == null || seller.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "add":
                handleAddProduct(request, response, seller);
                break;
            case "edit":
                handleEditProduct(request, response, seller);
                break;
            case "updateStatus":
                handleUpdateStatus(request, response, seller);
                break;
            default:
                handleListProducts(request, response, seller);
        }
    }
    
    /**
     * Handle listing products for seller
     */
    private void handleListProducts(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        // Get seller's villages
        List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
        
        // Get filtering parameters
        String statusStr = request.getParameter("status");
        String search = request.getParameter("search");
        String categoryIdStr = request.getParameter("categoryId");
        
        // Parse parameters
        int status = -1; // -1 means all statuses
        int categoryId = 0; // 0 means all categories
        
        try {
            if (statusStr != null && !statusStr.isEmpty()) {
                status = Integer.parseInt(statusStr);
            }
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr);
            }
        } catch (NumberFormatException e) {
            // Keep default values
        }
        
        // Pagination
        int page = 1;
        int pageSize = 8;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Calculate offset
        int offset = (page - 1) * pageSize;
        
        // Use SellerService to get products (no villageId and sortBy filtering)
        List<Product> products = sellerService.getProductsBySeller(
            seller.getUserID(), status, 0, categoryId, 
            search, "created_desc", offset, pageSize
        );
        
        // Debug logging
        System.out.println("=== DEBUG SELLER PRODUCT MANAGEMENT ===");
        System.out.println("Seller ID: " + seller.getUserID());
        System.out.println("Seller Villages: " + sellerVillages.size());
        System.out.println("Products found: " + products.size());
        for (CraftVillage village : sellerVillages) {
            System.out.println("Village: " + village.getVillageName() + " (ID: " + village.getVillageID() + ")");
        }
        for (Product product : products) {
            System.out.println("Product: " + product.getName() + " (Village ID: " + product.getVillageID() + ")");
        }
        System.out.println("=======================================");
        
        // Get total count for pagination (no villageId filtering)
        int totalProducts = sellerService.getTotalProductsBySeller(
            seller.getUserID(), status, 0, categoryId, search
        );
        
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        
        // Get additional data
        List<ProductCategory> categories = categoryService.getAllActiveCategories();
        
        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("sellerVillages", sellerVillages);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("selectedStatus", statusStr);
        request.setAttribute("selectedCategoryId", categoryIdStr);
        request.setAttribute("searchQuery", search);
        
        request.getRequestDispatcher("seller-product-list.jsp").forward(request, response);
    }
    
    /**
     * Handle showing add product form
     */
    /**
     * Handle showing add product form
     */
    private void handleAddProductForm(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            // Get all necessary data for the form
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            List<ProductCategory> categories = categoryService.getAllActiveCategories();
            List<CraftType> craftTypes = villageService.getAllActiveCraftTypes();
            
            // Set attributes for the form
            request.setAttribute("sellerVillages", sellerVillages);
            request.setAttribute("categories", categories);
            request.setAttribute("craftTypes", craftTypes);
            request.setAttribute("isEdit", false);
            
            // Forward to the form page
            request.getRequestDispatcher("seller-product-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error for debugging
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the add product page.: " + e.getMessage());
            handleListProducts(request, response, seller);
        }
    }
    
    /**
     * Handle showing edit product form
     */
    private void handleEditProductForm(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("error", "Product ID not provided");
                handleListProducts(request, response, seller);
                return;
            }
            
            int productId = Integer.parseInt(idParam);
            Product product = productService.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Product does not exist");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Check if seller owns this product through village ownership
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            boolean ownsProduct = sellerVillages.stream()
                .anyMatch(village -> village.getVillageID() == product.getVillageID());
            
            if (!ownsProduct) {
                request.setAttribute("error", "You do not have permission to edit this product");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Get all necessary data for the form
            List<ProductCategory> categories = categoryService.getAllActiveCategories();
            List<CraftType> craftTypes = villageService.getAllActiveCraftTypes();
            List<ProductImage> productImages = productService.getProductImages(productId);
            
            // Set attributes for the form
            request.setAttribute("product", product);
            request.setAttribute("sellerVillages", sellerVillages);
            request.setAttribute("categories", categories);
            request.setAttribute("craftTypes", craftTypes);
            request.setAttribute("productImages", productImages);
            request.setAttribute("isEdit", true);
            
            // Forward to the form page
            request.getRequestDispatcher("seller-product-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID: " + e.getMessage());
            handleListProducts(request, response, seller);
        } catch (Exception e) {
            // Log the error for debugging
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the edit page.: " + e.getMessage());
            handleListProducts(request, response, seller);
        }
    }
    
    /**
     * Handle adding new product
     */
    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            int villageId = Integer.parseInt(request.getParameter("villageId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int craftTypeId = Integer.parseInt(request.getParameter("craftTypeId"));
            String sku = request.getParameter("sku");
            String materials = request.getParameter("materials");
            String dimensions = request.getParameter("dimensions");
            String careInstructions = request.getParameter("careInstructions");
            String warranty = request.getParameter("warranty");
            BigDecimal weight = null;
            if (request.getParameter("weight") != null && !request.getParameter("weight").isEmpty()) {
                weight = new BigDecimal(request.getParameter("weight"));
            }
            
            // Validate seller owns the village
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            boolean ownsVillage = sellerVillages.stream()
                .anyMatch(village -> village.getVillageID() == villageId);
            
            if (!ownsVillage) {
                request.setAttribute("error", "You do not have permission to add products to this village.");
                handleAddProductForm(request, response, seller);
                return;
            }
            
            // Handle main image upload
            String mainImageUrl = null;
            Part mainImagePart = request.getPart("mainImage");
            if (mainImagePart != null && mainImagePart.getSize() > 0) {
                mainImageUrl = CloudinaryUploader.uploadImage(mainImagePart);
            }
            
            // Create product
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setVillageID(villageId);
            product.setCategoryID(categoryId);
            product.setCraftTypeID(craftTypeId);
            product.setSku(sku);
            product.setMaterials(materials);
            product.setDimensions(dimensions);
            product.setCareInstructions(careInstructions);
            product.setWarranty(warranty);
            product.setWeight(weight);
            product.setMainImageUrl(mainImageUrl);
            product.setStatus(1); // Active - no approval needed
            product.setCreatedDate(new Timestamp(System.currentTimeMillis()));
            
            // Save product
            int productId = productService.addProduct(product);
            
            if (productId > 0) {
                // Handle additional images
                handleAdditionalImages(request, productId);
                
                request.setAttribute("success", "Product added successfully!");
            } else {
                request.setAttribute("error", "An error occurred while adding the product.");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred.: " + e.getMessage());
        }
        
        handleListProducts(request, response, seller);
    }
    
    /**
     * Handle editing product
     */
    private void handleEditProduct(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product existingProduct = productService.getProductById(productId);
            
            if (existingProduct == null) {
                request.setAttribute("error", "Product does not exist");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Check ownership
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            boolean ownsProduct = sellerVillages.stream()
                .anyMatch(village -> village.getVillageID() == existingProduct.getVillageID());
            
            if (!ownsProduct) {
                request.setAttribute("error", "You do not have permission to edit this product");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            // Handle price with null check
            BigDecimal price = BigDecimal.ZERO;
            String priceParam = request.getParameter("price");
            if (priceParam != null && !priceParam.trim().isEmpty()) {
                price = new BigDecimal(priceParam);
            }
            
            // Handle stock with null check
            int stock = 0;
            String stockParam = request.getParameter("stock");
            if (stockParam != null && !stockParam.trim().isEmpty()) {
                stock = Integer.parseInt(stockParam);
            }
            
            // Handle categoryId
            int categoryId = 0;
            String categoryParam = request.getParameter("categoryId");
            if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                categoryId = Integer.parseInt(categoryParam);
            }
            
            // Handle craftTypeId
            int craftTypeId = 0;
            String craftTypeParam = request.getParameter("craftTypeId");
            if (craftTypeParam != null && !craftTypeParam.trim().isEmpty()) {
                craftTypeId = Integer.parseInt(craftTypeParam);
            }
            
            // Handle status
            int status = 1;
            String statusParam = request.getParameter("status");
            if (statusParam != null && !statusParam.trim().isEmpty()) {
                status = Integer.parseInt(statusParam);
            }
            
            String sku = request.getParameter("sku");
            String materials = request.getParameter("materials");
            String dimensions = request.getParameter("dimensions");
            String careInstructions = request.getParameter("careInstructions");
            String warranty = request.getParameter("warranty");
            
            // Handle weight
            BigDecimal weight = null;
            String weightParam = request.getParameter("weight");
            if (weightParam != null && !weightParam.trim().isEmpty()) {
                weight = new BigDecimal(weightParam);
            }
            
            // Handle main image upload if new image provided
            String mainImageUrl = existingProduct.getMainImageUrl();
            try {
                Part imagesPart = request.getPart("images");
                if (imagesPart != null && imagesPart.getSize() > 0) {
                    // CloudinaryUploader might not exist, skip for now
                    // mainImageUrl = CloudinaryUploader.uploadImage(imagesPart);
                }
            } catch (Exception imageEx) {
                // Image upload failed, continue without updating image
                System.out.println("Image upload failed: " + imageEx.getMessage());
            }
            
            // Update product
            existingProduct.setName(name);
            existingProduct.setDescription(description);
            existingProduct.setPrice(price);
            existingProduct.setStock(stock);
            existingProduct.setStatus(status);
            existingProduct.setCategoryID(categoryId);
            existingProduct.setCraftTypeID(craftTypeId);
            existingProduct.setSku(sku);
            existingProduct.setMaterials(materials);
            existingProduct.setDimensions(dimensions);
            existingProduct.setCareInstructions(careInstructions);
            existingProduct.setWarranty(warranty);
            existingProduct.setWeight(weight);
            existingProduct.setMainImageUrl(mainImageUrl);
            existingProduct.setUpdatedDate(new Timestamp(System.currentTimeMillis()));
            
            // Save product
            boolean success = productService.updateProduct(existingProduct);
            
            if (success) {
                // Handle additional images
                handleAdditionalImages(request, productId);
                
                request.setAttribute("success", "Product update successful!");
            } else {
                request.setAttribute("error", "An error occurred while updating the product.");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred.: " + e.getMessage());
        }
        
        handleListProducts(request, response, seller);
    }
    
    /**
     * Handle deleting product
     */
    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Product does not exist");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Check ownership
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            boolean ownsProduct = sellerVillages.stream()
                .anyMatch(village -> village.getVillageID() == product.getVillageID());
            
            if (!ownsProduct) {
                request.setAttribute("error", "You do not have permission to delete this product.");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Set status to inactive instead of deleting
            product.setStatus(0);
            boolean success = productService.updateProduct(product);
            
            if (success) {
                request.setAttribute("success", "Product deleted successfully!");
            } else {
                request.setAttribute("error", "An error occurred while deleting the product.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID");
        }
        
        handleListProducts(request, response, seller);
    }
    
    /**
     * Handle viewing product details
     */
    private void handleViewProduct(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Product does not exist");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Check ownership
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            boolean ownsProduct = sellerVillages.stream()
                .anyMatch(village -> village.getVillageID() == product.getVillageID());
            
            if (!ownsProduct) {
                request.setAttribute("error", "You do not have permission to view this product.");
                handleListProducts(request, response, seller);
                return;
            }
            
            List<ProductImage> productImages = productService.getProductImages(productId);
            CraftVillage village = villageService.getVillageById(product.getVillageID());
            ProductCategory category = categoryService.getCategoryById(product.getCategoryID());
            
            request.setAttribute("product", product);
            request.setAttribute("productImages", productImages);
            request.setAttribute("village", village);
            request.setAttribute("category", category);
            
            request.getRequestDispatcher("seller-product-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product ID");
            handleListProducts(request, response, seller);
        }
    }
    
    /**
     * Handle updating product status
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, Account seller)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            int status = Integer.parseInt(request.getParameter("status"));
            
            Product product = productService.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Product does not exist");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Check ownership
            List<CraftVillage> sellerVillages = villageService.getVillagesBySellerId(seller.getUserID());
            boolean ownsProduct = sellerVillages.stream()
                .anyMatch(village -> village.getVillageID() == product.getVillageID());
            
            if (!ownsProduct) {
                request.setAttribute("error", "You do not have permission to update this product.");
                handleListProducts(request, response, seller);
                return;
            }
            
            // Sellers can only set status to active (1) or inactive (0)
            if (status != 1 && status != 0) {
                request.setAttribute("error", "Invalid status");
                handleListProducts(request, response, seller);
                return;
            }
            
            product.setStatus(status);
            boolean success = productService.updateProduct(product);
            
            if (success) {
                String statusText = (status == 1) ? "activate" : "inactive";
                request.setAttribute("success", "Already " + statusText + " product successfully!");
            } else {
                request.setAttribute("error", "An error occurred while updating the status.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data");
        }
        
        handleListProducts(request, response, seller);
    }
    
    /**
     * Handle uploading additional product images
     */
    private void handleAdditionalImages(HttpServletRequest request, int productId)
            throws ServletException, IOException {
        
        // Get all parts that represent additional images
        for (Part part : request.getParts()) {
            if (part.getName().startsWith("additionalImage") && part.getSize() > 0) {
                try {
                    String imageUrl = CloudinaryUploader.uploadImage(part);
                    if (imageUrl != null) {
                        ProductImage productImage = new ProductImage();
                        productImage.setProductID(productId);
                        productImage.setImageUrl(imageUrl);
                        productImage.setMain(false);
                        productImage.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                        
                        productService.addProductImage(productImage);
                    }
                } catch (Exception e) {
                    // Log error but don't fail the whole operation
                    System.err.println("Error uploading additional image: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Apply filters to product list
     */
    private List<Product> applyFilters(List<Product> products, String status, String search, 
                                     String villageId, String categoryId) {
        
        return products.stream()
            .filter(product -> {
                // Status filter
                if (status != null && !status.isEmpty()) {
                    try {
                        int statusInt = Integer.parseInt(status);
                        if (product.getStatus() != statusInt) return false;
                    } catch (NumberFormatException e) {
                        // Ignore invalid status
                    }
                }
                
                // Search filter
                if (search != null && !search.trim().isEmpty()) {
                    String searchLower = search.toLowerCase().trim();
                    if (!product.getName().toLowerCase().contains(searchLower) &&
                        (product.getDescription() == null || 
                         !product.getDescription().toLowerCase().contains(searchLower))) {
                        return false;
                    }
                }
                
                // Village filter
                if (villageId != null && !villageId.isEmpty()) {
                    try {
                        int villageIdInt = Integer.parseInt(villageId);
                        if (product.getVillageID() != villageIdInt) return false;
                    } catch (NumberFormatException e) {
                        // Ignore invalid villageId
                    }
                }
                
                // Category filter
                if (categoryId != null && !categoryId.isEmpty()) {
                    try {
                        int categoryIdInt = Integer.parseInt(categoryId);
                        if (product.getCategoryID() != categoryIdInt) return false;
                    } catch (NumberFormatException e) {
                        // Ignore invalid categoryId
                    }
                }
                
                return true;
            })
            .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Apply sorting to product list
     */
    private List<Product> applySorting(List<Product> products, String sortBy) {
        switch (sortBy) {
            case "name_asc":
                products.sort((p1, p2) -> p1.getName().compareToIgnoreCase(p2.getName()));
                break;
            case "name_desc":
                products.sort((p1, p2) -> p2.getName().compareToIgnoreCase(p1.getName()));
                break;
            case "price_asc":
                products.sort((p1, p2) -> p1.getPrice().compareTo(p2.getPrice()));
                break;
            case "price_desc":
                products.sort((p1, p2) -> p2.getPrice().compareTo(p1.getPrice()));
                break;
            case "stock_asc":
                products.sort((p1, p2) -> Integer.compare(p1.getStock(), p2.getStock()));
                break;
            case "stock_desc":
                products.sort((p1, p2) -> Integer.compare(p2.getStock(), p1.getStock()));
                break;
            case "created_desc":
                products.sort((p1, p2) -> p2.getCreatedDate().compareTo(p1.getCreatedDate()));
                break;
            case "created_asc":
                products.sort((p1, p2) -> p1.getCreatedDate().compareTo(p2.getCreatedDate()));
                break;
            default:
                // Default sort by creation date descending
                products.sort((p1, p2) -> p2.getCreatedDate().compareTo(p1.getCreatedDate()));
        }
        return products;
    }

    @Override
    public String getServletInfo() {
        return "Seller Product Management Controller";
    }
}
