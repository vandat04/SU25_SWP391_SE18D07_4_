
package controller.Seller;

import DAO.FeedbackDAO;
import entity.Product.ProductReview;
import entity.CraftVillage.CraftReview;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "FeedbackManagementServlet", urlPatterns = {"/feedback-management"})
public class FeedbackManagementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(FeedbackManagementServlet.class.getName());
    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "view"; // Mặc định là xem danh sách
        }

        try {
            switch (action) {
                case "view":
                    viewFeedback(request, response);
                    break;
                case "deleteVillageReview":
                    deleteVillageReview(request, response);
                    break;
                case "deleteProductReview":
                    deleteProductReview(request, response);
                    break;
                default:
                    viewFeedback(request, response); // Xử lý action không hợp lệ
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi trong FeedbackManagementServlet: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
            viewFeedback(request, response); // Chuyển hướng về trang xem với thông báo lỗi
        }
    }

    private void viewFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CraftReview> villageReviews = feedbackDAO.getTop1000VillageReviews();
        List<ProductReview> productReviews = feedbackDAO.getTop1000ProductReviews();

        request.setAttribute("villageReviews", villageReviews);
        request.setAttribute("productReviews", productReviews);
        request.getRequestDispatcher("feedbackManagement.jsp").forward(request, response);
    }

    private void deleteVillageReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            boolean success = feedbackDAO.deleteVillageReview(reviewID);
            if (success) {
                request.setAttribute("successMessage", "Đánh giá làng nghề đã được xóa thành công.");
            } else {
                request.setAttribute("errorMessage", "Không thể xóa đánh giá làng nghề.");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid reviewID for deleting village review.", e);
            request.setAttribute("errorMessage", "ID đánh giá không hợp lệ.");
        }
        viewFeedback(request, response); // Sau khi xóa, hiển thị lại danh sách
    }

    private void deleteProductReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            boolean success = feedbackDAO.deleteProductReview(reviewID);
            if (success) {
                request.setAttribute("successMessage", "Đánh giá sản phẩm đã được xóa thành công.");
            } else {
                request.setAttribute("errorMessage", "Không thể xóa đánh giá sản phẩm.");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid reviewID for deleting product review.", e);
            request.setAttribute("errorMessage", "ID đánh giá không hợp lệ.");
        }
        viewFeedback(request, response); // Sau khi xóa, hiển thị lại danh sách
    }

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
        return "Servlet for managing feedback (village and product reviews).";
    }
}