
import entity.Product.ProductReview;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import service.ReviewService;

@WebServlet(name = "AdminPReviewManagement", urlPatterns = {"/admin-preview-management"})
public class AdminPReviewManagement extends HttpServlet {

    ReviewService rService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pid = request.getParameter("pid");
        String name = request.getParameter("name");
        String searchIDStr = request.getParameter("searchID");
        String pageStr = request.getParameter("page");

        int searchID = 4; // mặc định sort theo reviewDate DESC
        int page = 1;
        int pageSize = 5;

        try {
            if (searchIDStr != null && !searchIDStr.trim().isEmpty()) {
                searchID = Integer.parseInt(searchIDStr);
            }
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        try {
            int pidInt = Integer.parseInt(pid);
            List<ProductReview> listPReview = rService.searchProductReviewByAdmin(pidInt, searchID, page, pageSize);
            List<ProductReview> listReviewToday = rService.searchProductReviewToday(pidInt);
            int totalReviews = rService.countProductReviews(pidInt);
            int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

            request.setAttribute("listPReview", listPReview);
            request.setAttribute("listReviewToday", listReviewToday);
            request.setAttribute("name", name);
            request.setAttribute("pid", pid);
            request.setAttribute("searchID", searchID);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
            request.setAttribute("error", "0");
            request.setAttribute("message", "Unable to load reviews.");
        }
        
        String error = request.getParameter("error");
        String message = "";
        if (error != null) {
            switch (error) {
                case "1":
                    message = "Delete Success";
                    break;
                case "2":
                    message = "Delete Fail";
                    break;
                case "3":
                    message = "Respond Success";
                    break;
                case "4":
                    message = "Respond Fail";
                    break;
                default:
                    throw new AssertionError();
            }
            request.setAttribute("error", error);
            request.setAttribute("message", message);
        }

        
        request.getRequestDispatcher("admin-preview-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String typeName = request.getParameter("typeName");
        String reviewID = request.getParameter("reviewID");
        String responseText = request.getParameter("responseText");
        String pid = request.getParameter("pid");
        String name = request.getParameter("name");
        boolean result;
        String errorCode;

        switch (typeName) {
            case "deleteReview":
                result = rService.deleteProductReviewByAdmin(Integer.parseInt(reviewID));
                if (result) {
                    errorCode = "1";
                } else {
                    errorCode = "2";
                }
                break;
            case "respondReview":
                result = rService.responseProductReviewByAdmin(Integer.parseInt(reviewID), responseText);
                if (result) {
                    errorCode = "3";
                } else {
                    errorCode = "4";
                }
                break;
            default:
                throw new AssertionError("Unknown typeName: " + typeName);
        }

        // Redirect để tránh lỗi submit lại
        response.sendRedirect("admin-preview-management?pid=" + pid + "&name=" + URLEncoder.encode(name, "UTF-8") + "&error=" + errorCode);
    }
}
