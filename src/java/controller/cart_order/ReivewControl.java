/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.cart_order;

import constant.CloudinaryUploader;
import entity.Account.Account;
import entity.CraftVillage.CraftReview;
import entity.Orders.OrderDetail;
import entity.Orders.SubOrder;
import entity.Orders.TicketOrderDetail;
import entity.Product.ProductReview;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.List;
import service.OrderService;
import service.ProductService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)

@WebServlet(name = "ReivewControl", urlPatterns = {"/review-control"})

public class ReivewControl extends HttpServlet {

    private OrderService oService = new OrderService();

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

        String error = request.getParameter("error");
        if (error != null) {
            if (error.equals("1")) {
                request.setAttribute("error", error);
                request.setAttribute("message", "Send feedback success");
            } else {
                request.setAttribute("error", error);
                request.setAttribute("message", "Send feedback fail");
            }
        }

        int subOrderId = Integer.parseInt(request.getParameter("subOrderId"));
        SubOrder subOrder = oService.getSubOrderById(subOrderId);
        subOrder.setSubName("#" + subOrder.getVillageId() + " :" + new VillageService().getVillageNameByID(subOrder.getVillageId()));
        List<OrderDetail> orderList = oService.getOrderDetailNonReview(subOrderId);
        List<TicketOrderDetail> ticketOrderList = oService.getTicketOrderDetailNonReview(subOrderId);

        System.out.println("subOrder: " + subOrder);
        System.out.println("orderList size: " + orderList.size());
        System.out.println("ticketOrderList size: " + ticketOrderList.size());

        request.setAttribute("subOrder", subOrder);
        request.setAttribute("orderList", orderList);
        request.setAttribute("ticketOrderList", ticketOrderList);

        request.getRequestDispatcher("product-review.jsp").forward(request, response);

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

        request.setCharacterEncoding("UTF-8");

        int subOrderId = Integer.parseInt(request.getParameter("subOrderId"));
        String ticketIDStr = request.getParameter("ticketID");
        String productIDStr = request.getParameter("productID");

        int ticketID = ticketIDStr != null && !ticketIDStr.isEmpty() ? Integer.parseInt(ticketIDStr) : -1;
        int productID = productIDStr != null && !productIDStr.isEmpty() ? Integer.parseInt(productIDStr) : -1;

        String type = request.getParameter("type");

        String rateStr = request.getParameter("rate");
        if (rateStr == null) {
            System.out.println("ERROR: rate is null");
            response.sendRedirect("review-control?subOrderId=" + subOrderId + "&error=0");
            return;
        }
        int rate = Integer.parseInt(rateStr);

        String comment = request.getParameter("comment");

        String fileName = "";
        try {
            Part filePart = request.getPart("pictureUrl");
            fileName = CloudinaryUploader.uploadFile(filePart);
        } catch (Exception e) {
        }

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        boolean result = false;
        int error = 0;
        switch (type) {
            case "product":
                if (productID != -1) {
                    ProductReview review = new ProductReview(productID, user.getUserID(), rate, comment, fileName);
                    result = oService.addProductReviewByUser(review);
                    if (result) {
                        oService.calculateProductReview(rate, productID);
                        oService.updateOrderDetailReviewStatus(subOrderId, productID);
                        error = 1;
                    }
                }
                break;

            case "village":
                if (ticketID != -1) {
                    int villageID = new ProductService().getVillageIDByTicketID(ticketID);
                    CraftReview vreview = new CraftReview(villageID, user.getUserID(), rate, comment, fileName);
                    result = oService.addVillageReviewByUser(vreview);
                    if (result) {
                        oService.calculateVillageReview(rate, villageID);
                        oService.updateTicketOrderDetailReviewStatus(subOrderId, ticketID);
                        error = 1;
                    }
                }
                break;
        }
        oService.checkSubOrderReviewStatus(subOrderId);
        response.sendRedirect("review-control?subOrderId=" + subOrderId + "&error=" + error);
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
