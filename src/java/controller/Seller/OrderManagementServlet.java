package controller.Seller;

import DAO.ProductOrderDAO; // Đảm bảo import đúng DAO
import entity.Orders.ProductOrder;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderManagementServlet", urlPatterns = {"/order-management"})
public class OrderManagementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OrderManagementServlet.class.getName());
    private static final String LIST_ORDERS_JSP = "/orderList.jsp"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductOrderDAO orderDAO = new ProductOrderDAO();
        List<ProductOrder> orders;

        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        String userIDStr = request.getParameter("userID");

        Timestamp fromDate = null;
        Timestamp toDate = null;
        Integer userID = null;

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                Date parsedFromDate = dateFormat.parse(fromDateStr);
                fromDate = new Timestamp(parsedFromDate.getTime());
            }
            if (toDateStr != null && !toDateStr.isEmpty()) {
                Date parsedToDate = dateFormat.parse(toDateStr);
                // Để bao gồm cả ngày cuối cùng, thêm 23:59:59.999
                toDate = new Timestamp(parsedToDate.getTime() + 24 * 60 * 60 * 1000 - 1); 
            }
        } catch (ParseException e) {
            LOGGER.log(Level.WARNING, "Invalid date format provided for search.", e);
            request.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
        }

        if (userIDStr != null && !userIDStr.isEmpty()) {
            try {
                userID = Integer.parseInt(userIDStr);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid User ID format provided for search.", e);
                request.setAttribute("errorMessage", "Invalid User ID format. Please enter a number.");
            }
        }

        // Apply search if parameters are present, otherwise get all orders
        if (fromDate != null || toDate != null || (userID != null && userID > 0)) {
            orders = orderDAO.searchOrders(fromDate, toDate, userID);
        } else {
            orders = orderDAO.getAllOrders();
        }

        request.setAttribute("orderList", orders);
        request.getRequestDispatcher(LIST_ORDERS_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                int newStatus = Integer.parseInt(request.getParameter("newStatus"));

                ProductOrderDAO orderDAO = new ProductOrderDAO();
                boolean success = orderDAO.updateOrderStatus(orderId, newStatus);

                if (success) {
                    request.setAttribute("message", "Order status updated successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to update order status.");
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid order ID or status format for update.", e);
                request.setAttribute("errorMessage", "Invalid order ID or status provided.");
            }
        }
        // Sau bất kỳ hành động nào, chuyển hướng trở lại trang danh sách để làm mới
        doGet(request, response); 
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing orders (view, update, search)";
    }
}