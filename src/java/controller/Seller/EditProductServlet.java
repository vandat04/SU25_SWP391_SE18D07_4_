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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet này xử lý việc hiển thị form và cập nhật thông tin sản phẩm.
 */
@WebServlet(name = "EditProductServlet", urlPatterns = {"/editProduct"})
public class EditProductServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Lấy dữ liệu sản phẩm và hiển thị trang form chỉnh sửa.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");

        // Kiểm tra đăng nhập
        if (acc == null) {
            response.sendRedirect("login");
            return;
        }
        
        ProductDAO dao = new ProductDAO();
        try {
            // 1. Lấy ID sản phẩm từ URL
            int pid = Integer.parseInt(request.getParameter("pid"));
            
            // 2. Lấy thông tin chi tiết của sản phẩm đó
            Product product = dao.getProductByID(pid);
            
            // 3. Lấy danh sách các danh mục để hiển thị trong dropdown
            List<ProductCategory> categoryList = dao.getAllCategory();
            
            // 4. Kiểm tra xem sản phẩm có tồn tại và có thuộc sở hữu của nghệ nhân không
            // (Giả định bạn đã có CraftVillageDAO)
            CraftVillageDAO villageDAO = new CraftVillageDAO();
            CraftVillage managedVillage = villageDAO.getCraftVillageBySellerID(acc.getUserID());

            if (product == null || managedVillage == null || product.getVillageID() != managedVillage.getVillageID()) {
                session.setAttribute("errorMessage", "Không tìm thấy sản phẩm hoặc bạn không có quyền chỉnh sửa.");
                response.sendRedirect("manageProduct");
            } else {
                // 5. Gửi dữ liệu sản phẩm và danh mục sang trang JSP
                request.setAttribute("product", product);
                request.setAttribute("categoryList", categoryList);
                request.getRequestDispatcher("editProduct.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Chuyển hướng về trang quản lý nếu có lỗi
            session.setAttribute("errorMessage", "Đã có lỗi xảy ra khi tải dữ liệu.");
            response.sendRedirect("manageProduct");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Nhận dữ liệu từ form, cập nhật vào CSDL và chuyển hướng.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Lấy toàn bộ thông tin đã được sửa từ form
            Product updatedProduct = new Product();
            updatedProduct.setPid(Integer.parseInt(request.getParameter("pid")));
            updatedProduct.setName(request.getParameter("name"));
            updatedProduct.setPrice(new BigDecimal(request.getParameter("price")));
            updatedProduct.setStock(Integer.parseInt(request.getParameter("stock")));
            updatedProduct.setCategoryID(Integer.parseInt(request.getParameter("categoryId")));
            updatedProduct.setDescription(request.getParameter("description"));
            updatedProduct.setMainImageUrl(request.getParameter("imageUrl"));
            updatedProduct.setStatus(request.getParameter("status") != null ? 1 : 2);
            updatedProduct.setSku(request.getParameter("sku"));
            updatedProduct.setDimensions(request.getParameter("dimensions"));
            updatedProduct.setMaterials(request.getParameter("materials"));
            updatedProduct.setCareInstructions(request.getParameter("careInstructions"));
            updatedProduct.setWarranty(request.getParameter("warranty"));
            updatedProduct.setIsFeatured(request.getParameter("isFeatured") != null);
            
            String craftTypeIDStr = request.getParameter("craftTypeID");
            updatedProduct.setCraftTypeID((craftTypeIDStr == null || craftTypeIDStr.trim().isEmpty() || craftTypeIDStr.equals("0")) ? null : Integer.valueOf(craftTypeIDStr));
            
            String weightStr = request.getParameter("weight");
            updatedProduct.setWeight((weightStr != null && !weightStr.trim().isEmpty()) ? new BigDecimal(weightStr) : null);
            
            // Gọi DAO để thực hiện cập nhật, truyền cả sellerId để xác thực quyền
            ProductDAO dao = new ProductDAO();
            boolean success = dao.updateProductBySeller(updatedProduct, acc.getUserID());
            
            if (success) {
                // Sau khi cập nhật thành công, chuyển hướng về trang quản lý
                session.setAttribute("successMessage", "Đã cập nhật tác phẩm '" + updatedProduct.getName() + "' thành công!");
                response.sendRedirect("manageProduct");
            } else {
                throw new Exception("Cập nhật thất bại. Có thể bạn không có quyền hoặc đã có lỗi xảy ra.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cập nhật sản phẩm: " + e.getMessage());
            // Nếu có lỗi, gọi lại doGet để hiển thị lại form với thông báo lỗi
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for editing a product";
    }
}
