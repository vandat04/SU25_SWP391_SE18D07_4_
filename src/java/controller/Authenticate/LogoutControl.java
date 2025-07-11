package controller.Authenticate;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import listener.SessionCounterListener;

/**
 * ✅ MERGED: Combined LogoutControl + InvalidateSessionServlet
 * Servlet xử lý đăng xuất người dùng với session counter management
 */
@WebServlet(name = "LogoutControl", urlPatterns = {"/logout", "/invalidateSession"})
public class LogoutControl extends HttpServlet {

    /**
     * Xử lý yêu cầu GET để đăng xuất người dùng
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    /**
     * Xử lý yêu cầu POST để đăng xuất người dùng (chuyển hướng sang GET)
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    /**
     * ✅ MERGED: Core logout processing with session counter management
     * Handles both user-facing logout and API invalidation
     */
    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy session hiện tại, không tạo mới nếu chưa có
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // ✅ MERGED: Mark that this is a controlled session end (from InvalidateSessionServlet)
            session.setAttribute("controlledSessionEnd", true);
            
            // Hủy toàn bộ session để đăng xuất người dùng
            session.invalidate();
            
            // ✅ MERGED: Force update to session counter (from InvalidateSessionServlet)
            SessionCounterListener.decrementCounter();
        }
        
        // Handle different response types based on URL pattern
        String servletPath = request.getServletPath();
        
        if ("/invalidateSession".equals(servletPath)) {
            // ✅ MERGED: API endpoint behavior - just return OK status
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            // Default behavior - redirect to login page  
            response.sendRedirect("login");
        }
    }

    /**
     * Trả về mô tả ngắn gọn về Servlet này
     * @return Mô tả Servlet
     */
    @Override
    public String getServletInfo() {
        return "✅ MERGED: Comprehensive logout controller handling both user logout and session invalidation";
    }
}
