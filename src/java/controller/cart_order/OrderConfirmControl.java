package controller.cart_order;

import entity.Orders.Order;
import entity.Account.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.OrderService;

@WebServlet(name = "OrderConfirmControl", urlPatterns = {"/order-confirm"})
public class OrderConfirmControl extends HttpServlet {
    private final OrderService orderService;

    public OrderConfirmControl() {
        this.orderService = new OrderService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy thông tin từ form
            String shippingAddress = request.getParameter("shippingAddress");
            String phoneNumber = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String paymentMethod = request.getParameter("paymentMethod");

            // Validate dữ liệu
            if (shippingAddress == null || shippingAddress.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                paymentMethod == null || paymentMethod.trim().isEmpty()) {
                request.setAttribute("error", "Please fill in all required fields");
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
                return;
            }

            // Tạo đơn hàng mới
            Order order = new Order();
            order.setUserID(user.getUserID());
            order.setShippingAddress(shippingAddress);
            order.setPhoneNumber(phoneNumber);
            order.setEmail(email);
            order.setPaymentMethod(paymentMethod);
            order.setStatus("pending");
            order.setPaymentStatus("pending");

            // Lưu đơn hàng
            int orderId = orderService.createOrder(order);
            
            if (orderId > 0) {
                // Lưu orderId vào session để sử dụng trong các bước tiếp theo
                session.setAttribute("currentOrderId", orderId);
                
                // Chuyển hướng sau khi tạo đơn hàng thành công
                // VNPay payment integration removed
                response.sendRedirect("order-success?orderId=" + orderId);
            } else {
                request.setAttribute("error", "Failed to create order");
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
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
        return "Order Confirmation Controller";
    }
}