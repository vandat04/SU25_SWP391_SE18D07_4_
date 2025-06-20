package controller.Authenticate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "HomeControl", urlPatterns = {"/home"})
public class HomeControl extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
//        // Lấy danh sách sản phẩm active cho user
//        List<Product> list = new ProductService().getActivateProducts();
//        request.setAttribute("listP", list);
//
//        // Lấy danh sách tất cả danh mục
//        List<ProductCategory> listC = new ProductService().getAllCategory();
//        request.setAttribute("listCC", listC);
//        
//        // Lấy 3 sản phẩm mới nhất
//        List<Product> listTop5Newsest = new ProductService().getTop5NewestProducts();
//        request.setAttribute("listTop5Newsest", listTop5Newsest);

        request.getRequestDispatcher("Home.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
