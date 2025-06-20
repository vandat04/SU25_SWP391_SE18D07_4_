package controller.Authenticate;

//package controller;
//
//import entity.Account.GoogleAccount;
//import DAO.DAO;
//import DAO.WishlistDAO1;
//import entity.Account.Account;
//import entity.CartWishList.Wishlist;
//import java.io.IOException;
//import java.util.List;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.Cookie;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//@WebServlet(name = "LoginControl", urlPatterns = {"/login"})
//public class LoginControl extends HttpServlet {
//
//    private WishlistDAO1 wishlistDAO;
//
//    @Override
//    public void init() throws ServletException {
//        super.init();
//        wishlistDAO = new WishlistDAO1(); // Khởi tạo WishlistDAO1
//    }
//
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        String username = request.getParameter("user");
//        String password = request.getParameter("pass");
//        DAO dao = new DAO();
//        Account a = dao.login(username, password);
//        if (a == null) {
//            request.setAttribute("mess", "Wrong user or pass");
//            request.getRequestDispatcher("Login.jsp").forward(request, response);
//        } else {
//            HttpSession session = request.getSession();
//            session.setAttribute("acc", a);
//            session.setAttribute("userID", a.getUserID());
//            session.setAttribute("userName", a.getUserName());
//            session.setAttribute("roleID", a.getRoleID());
//
//            // Kiểm tra roleID để chuyển hướng đến đúng trang
//            if (a.getRoleID() == 3) { // Admin
//                response.sendRedirect("admin");
//            } else if (a.getRoleID() == 2) { // Seller
//                response.sendRedirect("seller");
//            } else { // User (roleID == 1)
//                response.sendRedirect("home");
//            }
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String code = request.getParameter("code"); // Lấy mã code từ Google
//        System.out.println("Received code from Google: " + code);
//
//        if (code == null || code.isEmpty()) {
//            request.getRequestDispatcher("Login.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            // Bước 1: Lấy access token từ Google
//            LoginGmail gg = new LoginGmail();
//            String accessToken = gg.getToken(code);
//            System.out.println("Access token: " + accessToken);
//
//            if (accessToken == null) {
//                throw new IOException("Failed to get access token");
//            }
//
//            // Bước 2: Lấy thông tin user từ Google
//            GoogleAccount acc = gg.getUserInfo(accessToken);
//            System.out.println("Google account info: " + acc);
//            System.out.println("Google email: " + acc.getEmail());
//
//            if (acc == null || acc.getEmail() == null) {
//                throw new IOException("Failed to get Google account info");
//            }
//
//            // Bước 3: Kiểm tra user trong database
//            DAO dao = new DAO();
//            System.out.println("Checking database for email: " + acc.getEmail());
//            Account a = dao.loginByEmail(acc.getEmail());
//            System.out.println("Database account: " + a);
//
//            // Kiểm tra nếu không tìm thấy tài khoản trong database
//            if (a == null) {
//                System.out.println("No account found for email: " + acc.getEmail());
//                request.setAttribute("error", "Email not found. Please register or try again.");
//                request.getRequestDispatcher("Login.jsp").forward(request, response);
//            } else {
//                // Nếu tìm thấy tài khoản, thiết lập session
//                HttpSession session = request.getSession();
//                session.setAttribute("account", a);
//                session.setAttribute("acc", a);
//                session.setAttribute("userID", a.getUserID());
//                session.setAttribute("userName", a.getUserName());
//                session.setAttribute("roleID", a.getRoleID());
//                session.setMaxInactiveInterval(600);
//
//                // Cập nhật wishlistCount
//                List<Wishlist> wishlist = wishlistDAO.getWishlistByUser(a.getUserID());
//                int wishlistCount = (wishlist != null) ? wishlist.size() : 0;
//                session.setAttribute("wishlistCount", wishlistCount);
//
//                // Chuyển hướng dựa vào roleID
//                if (a.getRoleID() == 3) { // Admin
//                    response.sendRedirect("admin");
//                } else if (a.getRoleID() == 2) { // Seller
//                    response.sendRedirect("seller");
//                } else { // User (roleID == 1)
//                    response.sendRedirect("home");
//                }
//            }
//        } catch (Exception e) {
//            System.out.println("Error during Google login: " + e.getMessage());
//            e.printStackTrace();
//            request.setAttribute("error", "Error during Google login: " + e.getMessage());
//            request.getRequestDispatcher("Login.jsp").forward(request, response);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String rememberMe = request.getParameter("rememberMe");
//        String u = request.getParameter("user");
//        String p = request.getParameter("pass");
//
//        // Thêm log để debug
//        System.out.println("Username: " + u);
//        System.out.println("Password: " + p);
//
//        DAO dao = new DAO();
//        Account a = dao.login(u, p);
//
//        if (a == null) {
//            request.setAttribute("error", "username or password invalid");
//            request.getRequestDispatcher("Login.jsp").forward(request, response);
//        } else {
//            HttpSession session = request.getSession();
//            session.setAttribute("account", a);
//            session.setAttribute("acc", a);
//            session.setAttribute("userID", a.getId());
//            session.setMaxInactiveInterval(600);
//
//            // Cập nhật wishlistCount
//            List<Wishlist> wishlist = wishlistDAO.getWishlistByUser(a.getId());
//            int wishlistCount = (wishlist != null) ? wishlist.size() : 0;
//            session.setAttribute("wishlistCount", wishlistCount);
//
//            if (rememberMe != null && rememberMe.equals("on")) {
//                Cookie usernameCookie = new Cookie("COOKIE_USERNAME", u);
//                Cookie passwordCookie = new Cookie("COOKIE_PASSWORD", p);
//                usernameCookie.setMaxAge(60 * 60 * 24);
//                passwordCookie.setMaxAge(60 * 60 * 24);
//                response.addCookie(usernameCookie);
//                response.addCookie(passwordCookie);
//            }
//            response.sendRedirect("home");
//        }
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }
//}
