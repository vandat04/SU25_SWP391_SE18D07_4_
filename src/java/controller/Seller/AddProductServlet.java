/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Seller;

import DAO.CraftVillageDAO;
import DAO.ProductDAO;
import entity.Account.Account;
import entity.CraftVillage.CraftVillage;
import entity.Product.Product;
import entity.Product.ProductCategory;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet này xử lý logic cho việc thêm mới một sản phẩm bởi nghệ nhân (Seller).
 */
@WebServlet(name = "AddProductServlet", urlPatterns = {"/createProduct"})
public class AddProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        List<ProductCategory> categoryList = productDAO.getAllCategory();
        request.setAttribute("categoryList", categoryList);
        
        // Chuyển hướng đến đúng tệp JSP đã đổi tên
        request.getRequestDispatcher("createProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");

        // 1. Kiểm tra đăng nhập
        if (seller == null) {
            response.sendRedirect("login");
            return;
        }

        ProductDAO productDAO = new ProductDAO();

        try {
            // 2. Lấy villageID chính xác bằng cách truy vấn CSDL
            CraftVillageDAO villageDAO = new CraftVillageDAO();
            CraftVillage managedVillage = villageDAO.getCraftVillageBySellerID(seller.getUserID());
            
            if (managedVillage == null) {
                throw new Exception("Tài khoản của bạn chưa được liên kết với một làng nghề nào.");
            }
            int villageId = managedVillage.getVillageID();

            // 3. Lấy và kiểm tra dữ liệu từ form
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String categoryIdStr = request.getParameter("categoryId");
            
            if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() || stockStr == null || stockStr.trim().isEmpty()) {
                throw new Exception("Tên, giá và số lượng tồn kho là bắt buộc.");
            }

            // 4. Chuyển đổi kiểu dữ liệu an toàn
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            
            String craftTypeIDStr = request.getParameter("craftTypeID");
            Integer craftTypeID = (craftTypeIDStr == null || craftTypeIDStr.trim().isEmpty() || craftTypeIDStr.equals("0")) ? null : Integer.valueOf(craftTypeIDStr);
            
            String weightStr = request.getParameter("weight");
            BigDecimal weight = (weightStr != null && !weightStr.trim().isEmpty()) ? new BigDecimal(weightStr) : null;

            // 5. Tạo đối tượng Product và gán giá trị
            Product newProduct = new Product();
            newProduct.setName(name);
            newProduct.setPrice(price);
            newProduct.setStock(stock);
            newProduct.setCategoryID(categoryId);
            newProduct.setVillageID(villageId); // Gán villageID đúng
            newProduct.setStatus((request.getParameter("status") != null) ? 1 : 2); // 1: hoạt động, 2: ẩn
            newProduct.setIsFeatured(request.getParameter("isFeatured") != null);
            newProduct.setDescription(request.getParameter("description"));
            newProduct.setSku(request.getParameter("sku"));
            newProduct.setWeight(weight);
            newProduct.setDimensions(request.getParameter("dimensions"));
            newProduct.setMaterials(request.getParameter("materials"));
            newProduct.setCareInstructions(request.getParameter("careInstructions"));
            newProduct.setWarranty(request.getParameter("warranty"));
            newProduct.setMainImageUrl(request.getParameter("imageUrl"));
            newProduct.setCraftTypeID(craftTypeID);
            
            // Gán giá trị mặc định cho các trường không có trên form
            newProduct.setAverageRating(BigDecimal.ZERO);
            newProduct.setTotalReviews(0);

            // 6. Gọi đúng phương thức DAO để lưu vào CSDL
            // (Giả định phương thức trong DAO là 'insertProduct')
            productDAO.createProduct(newProduct);

            // 7. Chuyển hướng sang trang thành công
            request.setAttribute("addedProductName", name);
            request.getRequestDispatcher("createProductSuccess.jsp").forward(request, response);

        } catch (Exception e) {
            // Nếu có lỗi, gửi lại form với thông báo lỗi
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            
            // Lấy lại danh sách category để hiển thị lại trên form
            List<ProductCategory> categoryList = productDAO.getAllCategory();
            request.setAttribute("categoryList", categoryList);
            
            // Chuyển hướng về trang createProduct.jsp khi có lỗi
            request.getRequestDispatcher("createProduct.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for adding a new product";
    }
}
