// File: controller/Seller/ManageProductServlet.java
package controller.Seller;

import DAO.ProductDAO;
import entity.Account.Account;
import entity.Product.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet này xử lý việc hiển thị danh sách sản phẩm cho một nghệ nhân cụ thể.
 */
@WebServlet(name = "ManageProductServlet", urlPatterns = {"/manageProduct"})
public class ManageProductServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");
        
        // 1. Kiểm tra đăng nhập và vai trò (Giả sử roleID = 2 là của Seller)
        if (acc == null || acc.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // 2. Gọi DAO để lấy TẤT CẢ sản phẩm của nghệ nhân
            ProductDAO productDAO = new ProductDAO();
            List<Product> allProducts = productDAO.getProductsBySellerID(acc.getUserID());
            
            // === BẮT ĐẦU SỬA: Lọc danh sách để chỉ hiển thị sản phẩm đang hoạt động ===
            // Chúng ta chỉ lấy ra các sản phẩm có status = 1 (Đang bán)
            List<Product> activeProducts = allProducts.stream()
                                                      .filter(p -> p.getStatus() == 1)
                                                      .collect(Collectors.toList());
            
            // 3. Đặt danh sách sản phẩm ĐÃ LỌC vào request scope
            request.setAttribute("productList", activeProducts);
            // === KẾT THÚC SỬA ===

        } catch (Exception e) {
            // 4. Bắt lỗi nếu có sự cố khi truy vấn CSDL
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi tải dữ liệu sản phẩm.");
        }
        
        // 5. Luôn chuyển tiếp đến trang JSP để hiển thị giao diện
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
        return "Servlet to manage products for a seller/artist.";
    }
}
