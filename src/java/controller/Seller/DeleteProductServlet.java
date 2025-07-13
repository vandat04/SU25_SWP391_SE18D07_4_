// File: controller/Seller/DeleteProductServlet.java
package controller.Seller;

import DAO.ProductDAO;
import entity.Account.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DeleteProductServlet", urlPatterns = {"/deleteProduct"})
public class DeleteProductServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account seller = (Account) session.getAttribute("acc");

        if (seller == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int pid = Integer.parseInt(request.getParameter("pid"));
            ProductDAO productDAO = new ProductDAO();
            
            // Gọi phương thức xóa và kiểm tra kết quả trả về
            boolean success = productDAO.deleteProductBySeller(pid, seller.getUserID());
            
            if (success) {
                // Nếu thành công, đặt thông báo thành công vào session
                session.setAttribute("successMessage", "Deleted Successfully!");
            } else {
                // Nếu thất bại (không có dòng nào được cập nhật), đặt thông báo lỗi
                session.setAttribute("errorMessage", "Cannot hide product. You may not have permission or the product does not exist.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý các lỗi khác (ví dụ: pid không hợp lệ, lỗi CSDL)
            session.setAttribute("errorMessage", "An error occurred during processing.: " + e.getMessage());
        }
        
        // Luôn chuyển hướng về trang quản lý sản phẩm
        response.sendRedirect("manageProduct");
    }
}
