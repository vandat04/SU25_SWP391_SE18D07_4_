package controller.Seller;

import DAO.MessageDAO;
import entity.Account.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet này xử lý chức năng liên hệ, cho phép người dùng đã đăng nhập gửi tin
 * nhắn đến Quản trị viên.
 */
@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    // ID của tài khoản Admin sẽ nhận tất cả các tin nhắn.
    // Dựa theo file SQL, tài khoản admin01 có userID = 3.
    private static final int ADMIN_RECEIVER_ID = 3;

    /**
     * Hiển thị trang form liên hệ.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }

    /**
     * Xử lý việc gửi tin nhắn từ form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account sender = (Account) session.getAttribute("acc");

        // 1. Kiểm tra xem người dùng đã đăng nhập chưa
        if (sender == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 2. Lấy nội dung tin nhắn từ form
            String messageContent = request.getParameter("messageContent");
            
            // 3. Kiểm tra dữ liệu đầu vào
            if (messageContent == null || messageContent.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập nội dung tin nhắn.");
                doGet(request, response); // Quay lại form và hiển thị lỗi
                return;
            }

            // 4. Gọi DAO để gửi tin nhắn
            MessageDAO dao = new MessageDAO();
            dao.sendMessage(sender.getUserID(), ADMIN_RECEIVER_ID, messageContent);

            // 5. Chuyển hướng thành công
            // Thêm một tham số vào URL để trang JSP biết hiển thị thông báo thành công
            response.sendRedirect("contact?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, đặt thông báo và quay lại form
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau.");
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles contact form submissions from logged-in users to the admin.";
    }
}
