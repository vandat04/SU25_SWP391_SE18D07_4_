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
    
    ProductDAO dao = new ProductDAO();
    int pid = Integer.parseInt(request.getParameter("pid"));
    
    try {
        // KHÔI PHỤC: Lấy toàn bộ thông tin đã được sửa từ form
        Product updatedProduct = new Product();
        updatedProduct.setPid(pid);
        updatedProduct.setName(request.getParameter("name"));
        updatedProduct.setPrice(new BigDecimal(request.getParameter("price")));
        updatedProduct.setStock(Integer.parseInt(request.getParameter("stock")));
        updatedProduct.setCategoryID(Integer.parseInt(request.getParameter("categoryId")));
        updatedProduct.setDescription(request.getParameter("description"));
        updatedProduct.setMainImageUrl(request.getParameter("mainImageUrl"));
        
        // Status = 1 là active, 2 là inactive (tùy bạn quy ước)
        updatedProduct.setStatus(request.getParameter("status") != null ? 1 : 2);
        
        // KHÔI PHỤC: Lấy các trường chi tiết
        updatedProduct.setSku(request.getParameter("sku"));
        updatedProduct.setDimensions(request.getParameter("dimensions"));
        updatedProduct.setMaterials(request.getParameter("materials"));
        updatedProduct.setCareInstructions(request.getParameter("careInstructions"));
        updatedProduct.setWarranty(request.getParameter("warranty"));
        
        // isFeatured là kiểu boolean, checkbox nếu không tick sẽ không gửi giá trị (null)
        updatedProduct.setIsFeatured(request.getParameter("isFeatured") != null);
        
        // Xử lý các trường số có thể bị rỗng
        String craftTypeIDStr = request.getParameter("craftTypeID");
        if (craftTypeIDStr != null && !craftTypeIDStr.trim().isEmpty()) {
            updatedProduct.setCraftTypeID(Integer.valueOf(craftTypeIDStr));
        }
        
        String weightStr = request.getParameter("weight");
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            updatedProduct.setWeight(new BigDecimal(weightStr));
        }

        // Gọi DAO để thực hiện cập nhật
        boolean success = dao.updateProductBySeller(updatedProduct, acc.getUserID());
        
        if (success) {
            session.setAttribute("successMessage", "Đã cập nhật tác phẩm '" + updatedProduct.getName() + "' thành công!");
            response.sendRedirect("manageProduct");
        } else {
            throw new Exception("Cập nhật thất bại. Có thể bạn không có quyền hoặc đã có lỗi xảy ra.");
        }
        
    } catch (NumberFormatException e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Lỗi định dạng số. Vui lòng kiểm tra lại giá, số lượng, cân nặng...");
        request.setAttribute("product", dao.getProductByID(pid)); // Gửi lại sản phẩm cũ
        request.setAttribute("categoryList", dao.getAllCategory());
        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Lỗi cập nhật sản phẩm: " + e.getMessage());
        
        
        request.setAttribute("product", dao.getProductByID(pid)); 
        request.setAttribute("categoryList", dao.getAllCategory());
        request.getRequestDispatcher("editProduct.jsp").forward(request, response);
         }
    }
}


