/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import constant.CloudinaryUploader;
import entity.Account.Account;
import entity.Product.Product;
import entity.Ticket.Ticket;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;
import service.ProductService;

/**
 *
 * @author ACER
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB: Khi vượt ngưỡng này, file sẽ lưu vào ổ đĩa tạm
        maxFileSize = 10 * 1024 * 1024, // 10MB: Kích thước tối đa của từng file
        maxRequestSize = 20 * 1024 * 1024 // 20MB: Tổng dung lượng toàn bộ request (nếu có nhiều file)
)
@WebServlet(name = "AdminProductManagement", urlPatterns = {"/admin-product-management"})
public class AdminProductManagement extends HttpServlet {

    private List<Product> listProduct;
    List<Ticket> listTicket;

    private static final int PAGE_SIZE = 10;

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductService ps = new ProductService();

         HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");

        // Check if user is logged in and is a seller
        if (account == null || account.getRole() != 3) {
            response.sendRedirect("login");
            return;
        }
        
        
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
        request.getSession().setAttribute("status", status);
        String searchIDStr = request.getParameter("searchID");
        int searchID = (searchIDStr != null && !searchIDStr.isEmpty()) ? Integer.parseInt(searchIDStr) : 0; // Default to 0 (All)
        String contentSearch = request.getParameter("contentSearch");
        contentSearch = (contentSearch != null) ? contentSearch.trim() : "";
        
        String error = request.getParameter("error");
        String message = "";
        if (error != null) {
            switch (error) {
                case "1":
                    message = "Update Success";
                    break;
                case "2":
                    message = "Update Fail";
                    break;
                case "3":
                    message = "Delete Success";
                    break;
                case "4":
                    message = "Delete Fail";
                    break;
                case "5":
                    message = "Create Success";
                    break;
                case "6":
                    message = "Create Fail";
                    break;
                default:
                    throw new AssertionError();
            }
            request.setAttribute("error", error);
            request.setAttribute("message", message);
        }

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

        // Set attributes
        request.setAttribute("listProduct", products);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("searchID", searchID);
        request.setAttribute("contentSearch", contentSearch);

        request.getRequestDispatcher("admin-product-management.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductService ps = new ProductService();
        String typeName = request.getParameter("typeName");
        String pidStr = request.getParameter("pid");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        String stockStr = request.getParameter("stock");
        String stockAddStr = request.getParameter("stockAdd");
        String sku = request.getParameter("sku");
        String villageIDStr = request.getParameter("villageID");
        String categoryIDStr = request.getParameter("categoryID");
        String craftTypeIDStr = request.getParameter("craftTypeID");
        String weightStr = request.getParameter("weight");
        String dimensions = request.getParameter("dimensions");
        String materials = request.getParameter("materials");
        String careInstructions = request.getParameter("careInstructions");
        String warranty = request.getParameter("warranty");
        String statusProduct = request.getParameter("statusProduct");
        String existingMainImageUrl = request.getParameter("existingMainImageUrl");
        String existingModelFileUrl = request.getParameter("existingModelFileUrl");

        String mainImageUrl = "";
        try {
            Part filePart = request.getPart("mainImageUrl");
            if (filePart != null && filePart.getSize() > 0) {
                mainImageUrl = CloudinaryUploader.uploadImage(filePart);
            }
        } catch (Exception e) {
            // Handle upload error
        }

        if (mainImageUrl.isEmpty()) {
            mainImageUrl = existingMainImageUrl;
        }

        String modelFile = "";
        try {
            Part filePart = request.getPart("modelFile");
            if (filePart != null && filePart.getSize() > 0) {
                modelFile = CloudinaryUploader.uploadRaw(filePart);
            }
        } catch (Exception e) {
            // Handle upload error
        }

        if (modelFile.isEmpty()) {
            modelFile = existingModelFileUrl;
        }

        boolean success = false;
        String message = "";
        String errorCode = "0";

        switch (typeName) {
            case "updateProduct":
                try {
                    int pid = Integer.parseInt(pidStr);
                    int stock = Integer.parseInt(stockStr);
                    int stockAdd = stockAddStr != null ? Integer.parseInt(stockAddStr) : 0;
                    int villageID = Integer.parseInt(villageIDStr);
                    int categoryID = Integer.parseInt(categoryIDStr);
                    int craftTypeID = Integer.parseInt(craftTypeIDStr);
                    double price = Double.parseDouble(priceStr);
                    double weight = Double.parseDouble(weightStr);
                    int productStatus = Integer.parseInt(statusProduct);

                    Product product = new Product(pid, name, BigDecimal.valueOf(price), description, stock, stockAdd, productStatus, villageID, categoryID, mainImageUrl, craftTypeID, sku, BigDecimal.valueOf(weight), dimensions, materials, careInstructions, warranty, modelFile);
                    success = ps.updateProductByAdmin(product);
                    if (success) {

                        errorCode = "1";
                    } else {
                        errorCode = "2";
                    }
                } catch (Exception e) {
                    message = "Update Fail";
                }
                break;
            case "createProduct":
                try {
                    int stock = Integer.parseInt(stockStr);
                    int villageID = Integer.parseInt(villageIDStr);
                    int categoryID = Integer.parseInt(categoryIDStr);
                    int craftTypeID = Integer.parseInt(craftTypeIDStr);
                    double price = Double.parseDouble(priceStr);
                    double weight = Double.parseDouble(weightStr);
                    int productStatus = Integer.parseInt(statusProduct);

                    Product product = new Product(name, BigDecimal.valueOf(price), description, stock, productStatus, villageID, categoryID, mainImageUrl, craftTypeID, sku, BigDecimal.valueOf(weight), dimensions, materials, careInstructions, warranty, modelFile);
                    success = ps.createProductByAdmin(product);
                    if (success) {
                        errorCode = "5";
                    } else {
                        errorCode = "6";
                    }
                } catch (Exception e) {
                    message = "Create Fail";
                }
                break;
            case "deleteProduct":
                try {
                    int pid = Integer.parseInt(pidStr);
                    success = ps.deleteProductByAdmin(pid);
                    if (success) {
                        errorCode = "3";
                    } else {
                        errorCode = "4";
                    }
                } catch (Exception e) {
                    message = "Delete Fail";
                }
                break;
            default:
                // Unknown type
                break;
        }

        // After POST, redirect to GET with parameters to show message
        String redirectUrl = "admin-product-management?status=1&searchID=0&contentSearch=&message=" + URLEncoder.encode(message, "UTF-8") + "&error=" + errorCode;
        response.sendRedirect(redirectUrl);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Product Management Servlet";
    }

}
