package controller.Seller;

import DAO.ProductDAO;
import entity.Account.Account;
import entity.Product.Product;
import entity.Product.ProductCategory; // Vẫn cần import để tải danh sách cho giao diện
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchProductServlet", urlPatterns = {"/searchProduct"})
public class SearchProductServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");

        // 1. Kiểm tra quyền truy cập
        if (acc == null || acc.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }

        ProductDAO productDAO = new ProductDAO();

        String pidStr = request.getParameter("pid");
        String productName = request.getParameter("productName"); 
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        // Khai báo biến
        Integer searchPid = null;
        Double minPrice = null;
        Double maxPrice = null;

        try {
            if (pidStr != null && !pidStr.trim().isEmpty()) {
                searchPid = Integer.parseInt(pidStr);
            }
            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr);
                if (minPrice < 0) throw new Exception("Giá trị giá tối thiểu không được là số âm.");
            }
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr);
                if (maxPrice < 0) throw new Exception("Giá trị giá tối đa không được là số âm.");
            }
            if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
                throw new Exception("Giá tối thiểu không được lớn hơn giá tối đa.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Vui lòng nhập đúng định dạng số cho ID sản phẩm hoặc giá.");
            List<ProductCategory> categories = productDAO.getAllCategory();
            request.setAttribute("categories", categories);
            List<Product> productList = productDAO.getProductsBySellerID(acc.getUserID()); // Hoặc một danh sách trống
            request.setAttribute("productList", productList);
            request.getRequestDispatcher("manageProduct.jsp").forward(request, response);
            return;
        } catch (Exception e) { 
            request.setAttribute("errorMessage", e.getMessage());
            List<ProductCategory> categories = productDAO.getAllCategory();
            request.setAttribute("categories", categories);
            List<Product> productList = productDAO.getProductsBySellerID(acc.getUserID()); 
            request.setAttribute("productList", productList);
            request.getRequestDispatcher("manageProduct.jsp").forward(request, response);
            return;
        }

        int sellerId = acc.getUserID();

        List<Product> productList = productDAO.searchProductsForSeller(sellerId, searchPid, productName, minPrice, maxPrice);
        request.setAttribute("productList", productList);
        
        List<ProductCategory> categories = productDAO.getAllCategory();
        request.setAttribute("categories", categories);
        
        // 5. Gửi lại các tham số đã tìm kiếm để giữ giá trị trên form
        request.setAttribute("searchedPid", pidStr);
        request.setAttribute("searchedProductName", productName); // Gửi lại tên sản phẩm đã tìm kiếm
        request.setAttribute("searchedMinPrice", minPriceStr);
        request.setAttribute("searchedMaxPrice", maxPriceStr);
        
        // Giữ lại giá trị của các bộ lọc khác để không bị mất trên form (nếu có)
        // Hiện tại các tham số này không được xử lý trong logic tìm kiếm, nhưng có thể cần cho các bộ lọc khác trên JSP
        request.setAttribute("searchedCategory", request.getParameter("category")); 
        request.setAttribute("searchedStatus", request.getParameter("status"));

        // 6. Forward tới trang JSP để hiển thị
        request.getRequestDispatcher("manageProduct.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for searching products by ID, name, and price for a seller";
    }
}