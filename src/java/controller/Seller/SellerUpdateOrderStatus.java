/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Seller;

import entity.Account.Account;
import entity.Orders.OrderDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.OrderService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "SellerUpdateOrderStatus", urlPatterns = {"/seller-update-order-status"})
public class SellerUpdateOrderStatus extends HttpServlet {

    private OrderService orderService = new OrderService();
    private VillageService villageService = new VillageService();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");
        
        if (account == null || account.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String orderDetailIdStr = request.getParameter("orderDetailId");
        
        if (orderDetailIdStr == null || orderDetailIdStr.isEmpty()) {
            response.sendRedirect("seller-order-management");
            return;
        }
        
        try {
            int orderDetailId = Integer.parseInt(orderDetailIdStr);
            OrderDetail orderDetail = orderService.getOrderDetailById(orderDetailId);
            
            if (orderDetail == null) {
                response.sendRedirect("seller-order-management");
                return;
            }
            
            // Verify that this order belongs to seller's village
            int sellerId = account.getUserID();
            int sellerVillageId = villageService.getVillageIdBySellerId(sellerId);
            
            if (orderDetail.getVillageID() != sellerVillageId) {
                response.sendRedirect("seller-order-management");
                return;
            }
            
            boolean result = false;
            String cancelReason = request.getParameter("cancelReason");
            String failureReason = request.getParameter("failureReason");
            
            switch (action) {
                case "confirm":
                    // Từ Pending (0) -> Confirmed (1)
                    if (orderDetail.getStatus() == 0) {
                        result = orderService.updateOrderDetailStatus(orderDetailId, 1);
                    }
                    break;
                    
                case "package":
                    // Từ Confirmed (1) -> Packaging (2)
                    if (orderDetail.getStatus() == 1) {
                        result = orderService.updateOrderDetailStatus(orderDetailId, 2);
                    }
                    break;
                    
                case "prepare":
                    // Từ Packaging (2) -> Preparing for Delivery (3)
                    if (orderDetail.getStatus() == 2) {
                        result = orderService.updateOrderDetailStatus(orderDetailId, 3);
                    }
                    break;
                    
                case "shipping":
                    // Từ Preparing (3) -> Shipping (4)
                    if (orderDetail.getStatus() == 3) {
                        result = orderService.updateOrderDetailStatus(orderDetailId, 4);
                    }
                    break;
                    
                case "delivered":
                    // Từ Shipping (4) -> Delivered Successfully (5)
                    if (orderDetail.getStatus() == 4) {
                        result = orderService.updateOrderDetailStatus(orderDetailId, 5);
                    }
                    break;
                    
                case "failed":
                    // Từ Shipping (4) -> Delivery Failed (6)
                    if (orderDetail.getStatus() == 4) {
                        if (failureReason != null && !failureReason.trim().isEmpty()) {
                            result = orderService.updateOrderDetailStatusWithReason(orderDetailId, 6, failureReason);
                        }
                    }
                    break;
                    
                case "cancel":
                    // Có thể cancel từ các trạng thái 0, 1, 2
                    if (orderDetail.getStatus() <= 2) {
                        if (cancelReason != null && !cancelReason.trim().isEmpty()) {
                            result = orderService.updateOrderDetailStatusWithReason(orderDetailId, 7, cancelReason);
                        }
                    }
                    break;
            }
            
            if (result) {
                request.getSession().setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái đơn hàng!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ!");
        }
        
        response.sendRedirect("seller-order-management");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Seller Update Order Status Servlet";
    }// </editor-fold>

}
