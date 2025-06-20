package controller.Authenticate;

//package controller;
//
//import DAO.DAO;
//import jakarta.servlet.ServletException;
//import service.EmailService;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import java.util.Random;
//
//
//@WebServlet("/forgot-password")
//public class ForgotPasswordServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws IOException, ServletException {
//        request.getRequestDispatcher("Login.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
//            throws IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//        
//        String action = request.getParameter("action");
//        String message = "";
//
//        boolean success = false;
//        switch (action) {
//            case "sendOTP":
//                String input = request.getParameter("input");
//                DAO dao = new DAO();
//                int userId = dao.findUserIdByUsernameOrEmail(input);
//                
//                if (userId > 0) {
//                    String otp = String.format("%06d", new Random().nextInt(999999));
//                    
//                    HttpSession session = request.getSession();
//                    session.setAttribute("otp", otp);
//                    session.setAttribute("otpTime", System.currentTimeMillis());
//                    session.setAttribute("userId", userId);
//                    String email=dao.getEmailByUserId(userId);
//                    String subject = "Mã OTP đặt lại mật khẩu";
//                    String content = "Xin chào,\n\n"
//                            + "Mã OTP của bạn là: " + otp + "\n"
//                            + "Mã này sẽ hết hạn sau 1 phút.\n\n"
//                            + "Trân trọng,\nHồng Đức Team";
//                    
//                    try {
//                        EmailService.sendEmail(email, subject, content);
//                        success = true;
//                        message = "Đã gửi mã OTP đến email của bạn";
//                    } catch (Exception e) {
//                        message = "Lỗi gửi email: " + e.getMessage();
//                    }
//                } else {
//                    message = "Không tìm thấy tài khoản";
//                }
//                break;
//
//            case "verifyOTP":
//                String inputOTP = request.getParameter("otp");
//                HttpSession session = request.getSession();
//                String storedOTP = (String) session.getAttribute("otp");
//                Long otpTime = (Long) session.getAttribute("otpTime");
//
//                if (storedOTP == null || otpTime == null) {
//                    message = "Phiên làm việc đã hết hạn";
//                } else if (System.currentTimeMillis() - otpTime > 60000) {
//                    message = "Mã OTP đã hết hạn";
//                    session.removeAttribute("otp");
//                    session.removeAttribute("otpTime");
//                } else if (storedOTP.equals(inputOTP)) {
//                    success = true;
//                    message = "Xác thực OTP thành công";
//                } else {
//                    message = "Mã OTP không đúng";
//                }
//                break;
//
//            case "resetPassword":
//                session = request.getSession();
//                Integer userIdd = (Integer) session.getAttribute("userId");
//                String newPassword = request.getParameter("newPassword");
//                
//                if (userIdd == null) {
//                    message = "Phiên làm việc đã hết hạn";
//                } else if (newPassword == null || newPassword.trim().isEmpty()) {
//                    message = "Mật khẩu không được để trống";
//                } else {
//                    dao = new DAO();
//                    if (dao.changePasswordByUserId(userIdd, newPassword)) {
//                        success = true;
//                        message = "Đổi mật khẩu thành công";
//                        // Xóa session sau khi đổi mật khẩu thành công
//                        session.removeAttribute("otp");
//                        session.removeAttribute("otpTime");
//                        session.removeAttribute("userId");
//                    } else {
//                        message = "Lỗi khi đổi mật khẩu";
//                    }
//                }
//                break;
//
//            default:
//                message = "Hành động không hợp lệ";
//                break;
//        }
//
//        String jsonResponse = "{\"success\":" + success + ",\"message\":\"" + message + "\"}";
//        response.getWriter().write(jsonResponse);
//    }
//}