package controller.Admin;

import entity.Product.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ProductService;

@WebServlet(name = "Admin3DProductManagement", urlPatterns = {"/admin-3d-product-management"})
public class Admin3DProductManagement extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductService ps = new ProductService();

        // Get current page
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Get search parameters with defaults
        String statusStr = request.getParameter("status");
        int status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : 1; // Default to 1 (Active)
        String searchIDStr = request.getParameter("searchID");
        int searchID = (searchIDStr != null && !searchIDStr.isEmpty()) ? Integer.parseInt(searchIDStr) : 0; // Default to 0 (All)
        String contentSearch = request.getParameter("contentSearch");
        contentSearch = (contentSearch != null) ? contentSearch.trim() : "";

        // Calculate total products and pages
        int totalProducts = ps.getTotalSearchProducts(status, searchID, contentSearch);
        int totalPages = (totalProducts + PAGE_SIZE - 1) / PAGE_SIZE;

        // Adjust page to valid range
        if (page < 1) {
            page = 1;
        }
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        int offset = (page - 1) * PAGE_SIZE;

        // Fetch paginated products
        List<Product> products = ps.getSearchProductByAdmin(status, searchID, contentSearch, offset, PAGE_SIZE);

        // Calculate 3D model statistics
        int productsWith3D = 0;
        int productsWithout3D = 0;
        for (Product product : products) {
            if (product.getModelFile() != null && !product.getModelFile().trim().isEmpty() && !"null".equals(product.getModelFile().trim())) {
                productsWith3D++;
            } else {
                productsWithout3D++;
            }
        }

        // Set attributes
        request.setAttribute("listProduct", products);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("searchID", searchID);
        request.setAttribute("contentSearch", contentSearch);
        request.setAttribute("productsWith3D", productsWith3D);
        request.setAttribute("productsWithout3D", productsWithout3D);

        // Handle flash message from POST redirect
        String message = request.getParameter("message");
        String error = request.getParameter("error");
        if (message != null && !message.isEmpty()) {
            request.setAttribute("message", message);
            request.setAttribute("error", error != null ? error : "0");
        }

        request.getRequestDispatcher("admin-3d-product-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("delete3DModel".equals(action)) {
            delete3DModel(request, response);
        } else {
            response.sendRedirect("admin-3d-product-management");
        }
    }

    private void delete3DModel(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pidStr = request.getParameter("pid");
            if (pidStr == null || pidStr.isEmpty()) {
                response.sendRedirect("admin-3d-product-management?error=1&message=Invalid product ID");
                return;
            }

            int pid = Integer.parseInt(pidStr);
            ProductService ps = new ProductService();
            
            // Get the product to check if it has a 3D model
            Product product = ps.getProductByID(String.valueOf(pid));
            if (product == null) {
                response.sendRedirect("admin-3d-product-management?error=1&message=Product not found");
                return;
            }

            // Debug: Log the model file value
            System.out.println("DEBUG: Product ID: " + pid);
            System.out.println("DEBUG: Model File: '" + product.getModelFile() + "'");
            System.out.println("DEBUG: Model File is null: " + (product.getModelFile() == null));
            System.out.println("DEBUG: Model File is empty: " + (product.getModelFile() != null && product.getModelFile().trim().isEmpty()));

            if (product.getModelFile() == null || product.getModelFile().trim().isEmpty() || "null".equals(product.getModelFile().trim())) {
                response.sendRedirect("admin-3d-product-management?error=1&message=Product does not have a 3D model");
                return;
            }

            // Clear the 3D model file
            boolean success = ps.updateProductModelFile(pid, "");

            if (success) {
                response.sendRedirect("admin-3d-product-management?error=0&message=3D model deleted successfully");
            } else {
                response.sendRedirect("admin-3d-product-management?error=1&message=Failed to delete 3D model");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("admin-3d-product-management?error=1&message=Invalid product ID format");
        } catch (Exception e) {
            response.sendRedirect("admin-3d-product-management?error=1&message=An error occurred: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin 3D Product Management Servlet";
    }
} 
