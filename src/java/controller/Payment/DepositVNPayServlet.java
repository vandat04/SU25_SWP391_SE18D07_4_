///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller.Deposit;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//
///**
// *
// * @author ACER
// */
//@WebServlet(name = "DepositVNPayServlet", urlPatterns = {"/DepositVNPayServlet"})
//public class DepositVNPayServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet DepositVNPayServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet DepositVNPayServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        double depositValue = Double.parseDouble(request.getParameter("vnp_Amount")) / 100;
//
//        // 1. Lấy userID từ vnp_TxnRef
//        String txnRef = request.getParameter("vnp_TxnRef");
//        String userID = (txnRef != null && txnRef.contains("&&")) ? txnRef.split("&&")[0] : txnRef;
//        // 2. Lấy mã ngân hàng từ vnp_BankCode
//        String bank = request.getParameter("vnp_BankCode");
//        // 3. Lấy trạng thái giao dịch
//        String transactionStatus = request.getParameter("vnp_TransactionStatus");
//
//        // 4. Kiểm tra nếu giao dịch thành công (vnp_TransactionStatus = "00")
//        if ("00".equals(transactionStatus)) {
//            try {
//                
//                // Cập nhật lịch sử nạp tiền lớn hơn 500000 thì đợi admin duyệt, còn nhỏ thì tự động   
//                int depositID = DepositHistoryDB.addDeposit(Integer.parseInt(userID), bank, depositValue);
//                if (depositValue < 500000.0 && depositID != -1 ){
//                    DepositHistoryDB.updateStatus(depositID, "Completed");
//                    request.setAttribute("err", "Add success");
//                }   else {        
//                   request.setAttribute("err", "Large Amount Please Wait For Admin Confirmation"); 
//                }
//                // Cập nhật lại session user sau khi nạp tiền
//            } catch (Exception e) {
//                e.printStackTrace();
//                request.setAttribute("err", "Nạp Tiền Thất Bại"); 
//            }
//            request.getSession().setAttribute("user", UsersDB.getUserByID(Integer.parseInt(userID)));
//            request.getSession().setAttribute("listDeposit", DepositHistoryDB.allListDeposit());
//            request.setAttribute("status", "Transaction successful!");
//            request.getRequestDispatcher("/deposit/depositHistory.jsp").forward(request, response);
//
//        } else {
//            // Giao dịch thất bại, hiển thị thông báo lỗi
//            request.setAttribute("status", "Transaction failed. Please try again.!");
//            request.getSession().setAttribute("listDeposit", DepositHistoryDB.allListDeposit());
//            request.getRequestDispatcher("/deposit/depositHistory.jsp").forward(request, response);
//        }
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}