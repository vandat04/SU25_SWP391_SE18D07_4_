package filter;

import entity.Account.Account;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoggingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo nếu cần
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Lấy đường dẫn trang đang truy cập
        String requestURI = req.getRequestURI();
        String servletPath = req.getServletPath();

        HttpSession session = req.getSession();
        Object account = session.getAttribute("acc");

        if (account == null) {
            res.sendRedirect("login"); // Nếu chưa đăng nhập, chuyển về trang login
            return;
        } else {
            // Ép kiểu account về Account
            Account acc = (Account) account;

            // Xác định quyền
            boolean isAdmin = acc.getRoleID() == 3;
            boolean isSeller = acc.getRoleID() == 2;

            // Phân quyền
            // Kiểm tra quyền truy cập manager
            if (requestURI.endsWith("manager")) {
                if (!isAdmin && !isSeller) {
                    res.sendRedirect("Login.jsp");
                    return;
                }
                // Nếu là admin hoặc seller thì cho phép truy cập
                req.getRequestDispatcher("manager").forward(request, response);
                return;
            }

            // Nếu không phải Admin mà truy cập ManagerAccount.jsp => Chuyển lại
            if (requestURI.endsWith("managerAccount") && !isAdmin) {
                System.out.println("🚨 Không có quyền truy cập ManagerAccount.jsp => Chuyển hướng 404");
                res.sendRedirect("Login.jsp");
                return;
            }

            // Nếu là Admin, cho vào ManagerAccount.jsp
            if (requestURI.endsWith("managerAccount") && isAdmin) {
                System.out.println("🚨 Có quyền truy cập ManagerAccount.jsp => Chuyển hướng");
                req.getRequestDispatcher("managerAccount").forward(request, response);
                return;
            }
            try {
                chain.doFilter(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void destroy() {
        // Dọn dẹp nếu cần
    }
}
