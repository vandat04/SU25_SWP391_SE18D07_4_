/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.cart_order;

import entity.Orders.Order;
import entity.Orders.OrderDetail;
import entity.Orders.SubOrder;
import entity.Orders.TicketOrderDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import service.OrderService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "OrderControlServlet", urlPatterns = {"/order"})
public class OrderControlServlet extends HttpServlet {

    OrderService oService = new OrderService();

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
        String cas = request.getParameter("cas");
        int status = Integer.parseInt(cas);
        String userIDStr = request.getParameter("userID");
        int userID = Integer.parseInt(userIDStr);
        List<SubOrder> subOrderList;
        List<OrderDetail> orderDetailsList = new ArrayList<>();
        List<TicketOrderDetail> ticketOrderDetailsList = new ArrayList<>();
        List<Order> orderList ;
        orderList = oService.getAllOrderByUserID(userID);
        
        subOrderList = getSubOrderList(userID, status);

        // Pagination logic
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        int pageSize = 4;
        int totalItems = subOrderList.size();
        int totalPages = (totalItems + pageSize - 1) / pageSize;
        int startItem = (page - 1) * pageSize;
        int endItem = Math.min(startItem + pageSize, totalItems);
        List<SubOrder> paginatedSubOrders = new ArrayList<>();
        if (totalItems > 0) {
            paginatedSubOrders = subOrderList.subList(startItem, endItem);
        }

        // Collect unique order IDs to avoid duplicate fetches
        Set<Integer> uniqueOrderIds = new HashSet<>();
        for (SubOrder so : paginatedSubOrders) {
            uniqueOrderIds.add(so.getOrderId());
        }

        // Fetch details only for unique order IDs
        for (Integer orderId : uniqueOrderIds) {
            orderDetailsList.addAll(oService.getAllOrderDetailByOrderID(orderId));
            ticketOrderDetailsList.addAll(oService.getAllTicketOrderDetailByOrderID(orderId));
        }
        

        request.setAttribute("orderList", orderList);
        request.setAttribute("subOrderList", paginatedSubOrders);
        request.setAttribute("orderDetailsList", orderDetailsList);
        request.setAttribute("ticketOrderDetailsList", ticketOrderDetailsList);
        request.setAttribute("cas", cas);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("userID", userID);

        request.getRequestDispatcher("order-list.jsp").forward(request, response);
    }

    private List<SubOrder> getSubOrderList(int userID, int status) {
        Date now = new Date();
        Date threeDaysAgo = new Date(now.getTime() - 3L * 24 * 60 * 60 * 1000);

        List<SubOrder> allSubOrders = new ArrayList<>();
        List<SubOrder> filteredList = new ArrayList<>();
        // Lay danh sach order tong
        List<Order> orderList = oService.getOrdersByUserId(userID);
        // Lay danh sach suborder
        for (Order o : orderList) {
            allSubOrders.addAll(oService.getSubOrderListByOrderID(o.getId()));
        }
        for (SubOrder od : allSubOrders) {
            if (od.getOrderStatus() == 2) {
                if (od.getUpdatedDate() != null && od.getUpdatedDate().before(threeDaysAgo)) {
                    oService.updateReviewStatus(od.getSubOrderId());
                    od.setReviewStatus(1);
                }
            }
            if (status == 4) {
                if (status == od.getOrderStatus() || 5 == od.getOrderStatus()) {
                    String subName = "#" + od.getSubOrderId() + ": " + new VillageService().getVillageNameByID(od.getVillageId());
                    od.setSubName(subName);
                    filteredList.add(0, od);
                }
            } else {
                if (status == od.getOrderStatus()) {
                    String subName = "#" + od.getSubOrderId() + ": " + new VillageService().getVillageNameByID(od.getVillageId());
                    od.setSubName(subName);
                    filteredList.add(0, od);
                }
            }
        }
        return filteredList;
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
        return "Short description";
    }// </editor-fold>

}
