package controller.Seller;

import DAO.AccountDAO; // Cần AccountDAO để lấy thông tin người dùng
import DAO.MessageDAO;
import entity.Account.Account;
import entity.MessageNotification.MessageThread;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ContactSellerServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ContactServlet.class.getName());

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Account loggedInAccount = (Account) session.getAttribute("acc");

        // 1. Kiểm tra quyền truy cập
        if (loggedInAccount == null || loggedInAccount.getRoleID() != 2) { // RoleID 2 là Seller
            LOGGER.log(Level.WARNING, "Unauthorized access to ContactSellerServlet. Account: {0}", loggedInAccount);
            response.sendRedirect(request.getContextPath() + "/login"); // Chuyển hướng về trang đăng nhập
            return;
        }

        try {
            MessageDAO messageDAO = new MessageDAO();
            AccountDAO accountDAO = new AccountDAO(); // Khởi tạo AccountDAO ở đây
            int sellerID = loggedInAccount.getUserID(); // Lấy userID của Seller

            // 2. Lấy danh sách MessageThread của Seller (chỉ thông tin cơ bản)
            List<MessageThread> rawMessageThreads = messageDAO.getMessageThreadsBySellerID(sellerID);
            
            // 3. Chuẩn bị danh sách dữ liệu để truyền đến JSP
            // Mỗi Map sẽ chứa một MessageThread và thông tin Account của người dùng liên quan
            List<Map<String, Object>> displayThreads = new ArrayList<>();

            for (MessageThread thread : rawMessageThreads) {
                Map<String, Object> threadData = new HashMap<>();
                threadData.put("thread", thread); // Đặt đối tượng MessageThread gốc
                
                // Lấy thông tin Account của người dùng (userID)
                Account userAccount = accountDAO.getAccountByID(thread.getUserID());
                threadData.put("userAccount", userAccount); // Đặt đối tượng Account của người dùng
                
                displayThreads.add(threadData);
            }

      
            request.setAttribute("displayThreads", displayThreads); 

            
            request.getRequestDispatcher("contact.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ContactSellerServlet for sellerID: " + loggedInAccount.getUserID(), e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải danh sách tin nhắn. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response); // Chuyển hướng đến trang lỗi
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
        return "Servlet for displaying seller's message threads.";
    }
}