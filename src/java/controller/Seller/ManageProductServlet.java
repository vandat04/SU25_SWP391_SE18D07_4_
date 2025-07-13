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

@WebServlet(name = "ManageProductServlet", urlPatterns = {"/manageProduct"})
public class ManageProductServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    Account acc = (Account) session.getAttribute("acc");
    
    if (acc == null || acc.getRoleID() != 2) {
        response.sendRedirect("login");
        return;
    }
    
    try {
        ProductDAO productDAO = new ProductDAO();
        List<Product> allProducts = productDAO.getProductsBySellerID(acc.getUserID());
        
        request.setAttribute("productList", allProducts);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi tải dữ liệu sản phẩm.");
    }
    
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
