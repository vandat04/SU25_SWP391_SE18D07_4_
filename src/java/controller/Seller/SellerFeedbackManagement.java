package controller.Seller;

import DAO.FeedbackDAO;
import entity.CraftVillage.CraftReview;
import entity.Product.ProductReview;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SellerFeedbackManagement", urlPatterns = {"/seller-feedback-management"})
public class SellerFeedbackManagement extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SellerFeedbackManagement.class.getName());
    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
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
                case "respondVillageReview":
                    respondVillageReview(request, response);
                    break;
                case "respondProductReview":
                    respondProductReview(request, response);
                    break;
                default:
                    viewFeedback(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "A system error has occurred. Please try again later.");
            viewFeedback(request, response);
        }
    }

    private void viewFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("acc") == null) {
            response.sendRedirect("login");
            return;
        }
        List<CraftReview> villageReviews = feedbackDAO.getTop1000VillageReviews();
        List<ProductReview> productReviews = feedbackDAO.getTop1000ProductReviews();
        LOGGER.info("Retrieved " + villageReviews.size() + " village reviews and " + productReviews.size() + " product reviews.");
        request.setAttribute("villageReviews", villageReviews);
        request.setAttribute("productReviews", productReviews);
        request.getRequestDispatcher("seller-feedback-management.jsp").forward(request, response);
    }

    private void deleteVillageReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            boolean success = feedbackDAO.deleteVillageReview(reviewID);
            request.setAttribute("successMessage", success ? "Successfully deleted village review." : "Failed to delete village review.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid reviewID when deleting village review.", e);
            request.setAttribute("errorMessage", "Invalid review ID.");
        }
        viewFeedback(request, response);
    }

    private void deleteProductReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            boolean success = feedbackDAO.deleteProductReview(reviewID);
            request.setAttribute("successMessage", success ? "Successfully deleted product review." : "Failed to delete product review.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid reviewID when deleting product review.", e);
            request.setAttribute("errorMessage", "Invalid review ID.");
        }
        viewFeedback(request, response);
    }

    private void respondVillageReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            String responseText = request.getParameter("responseText");
            boolean success = feedbackDAO.respondVillageReview(reviewID, responseText);
            request.setAttribute("successMessage", success ? "Successfully responded to village review." : "Failed to respond to village review.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid reviewID when responding to village review.", e);
            request.setAttribute("errorMessage", "Invalid review ID.");
        }
        viewFeedback(request, response);
    }

    private void respondProductReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            String responseText = request.getParameter("responseText");
            boolean success = feedbackDAO.respondProductReview(reviewID, responseText);
            request.setAttribute("successMessage", success ? "Successfully responded to product review." : "Failed to respond to product review.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid reviewID when responding to product review.", e);
            request.setAttribute("errorMessage", "Invalid review ID.");
        }
        viewFeedback(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing feedback (village and product reviews).";
    }
}
