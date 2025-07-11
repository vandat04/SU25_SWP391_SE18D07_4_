/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Authenticate;

import entity.Product.Product;
import entity.Product.ProductCategory;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.ProductService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "DetailControl", urlPatterns = {"/detail"})
public class DetailControl extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductService productService = new ProductService();
        
        String id = request.getParameter("pid");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        // Lấy thông tin sản phẩm
        Product product = productService.getProductByID(id);
        if (product == null) {
            response.sendRedirect("home");
            return;
        }

        // Set thông tin sản phẩm
        request.setAttribute("detail", product);
        request.setAttribute("cid", product.getCategoryID());
        request.setAttribute("productName", product.getName());
        request.setAttribute("price", product.getPrice());
        request.setAttribute("description", product.getDescription());
        request.setAttribute("img", product.getMainImageUrl());
        request.setAttribute("product3D", new ProductService().getProduct3D(product.getPid()));

        // Lấy danh sách tất cả sản phẩm
        List<Product> listP = productService.getAllProducts();
        request.setAttribute("listP", listP);

        // Lấy sản phẩm cùng danh mục
        List<Product> listPP = productService.getProductByCategoryID(String.valueOf(product.getCategoryID()));
        request.setAttribute("listPP", listPP);

        // Lấy tất cả categories
        List<ProductCategory> listC = productService.getAllCategory();
        request.setAttribute("listCC", listC);

        // Tìm tên category của sản phẩm hiện tại
        String categoryName = "";
        for (ProductCategory c : listC) {
            if (c.getCategoryID() == product.getCategoryID()) {
                categoryName = c.getCategoryName();
                break;
            }
        }
        request.setAttribute("categoryName", categoryName);

        // Lấy top 5 sản phẩm mới nhất
        List<Product> list5 = productService.getTop5NewestProducts();
        request.setAttribute("list5", list5);

        request.getRequestDispatcher("Detail.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        processRequest(request, response);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

} 