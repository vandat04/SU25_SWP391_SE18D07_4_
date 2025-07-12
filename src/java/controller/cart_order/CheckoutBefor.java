/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.cart_order;

import entity.CartWishList.Cart;
import entity.Account.Account;
import entity.CartWishList.CartItem;
import entity.CartWishList.CartTicket;
import entity.Orders.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import service.AccountService;
import service.CartService;
import service.OrderService;
import service.ProductService;
import service.TicketService;
import java.net.URLEncoder;

/**
 *
 * @author DELL
 */
@WebServlet(name = "CheckoutBefor", urlPatterns = {"/checkout-before"})
public class CheckoutBefor extends HttpServlet {

    private final CartService cService = new CartService();
    private final OrderService oService = new OrderService();
    private final ProductService pService = new ProductService();
    private final TicketService tService = new TicketService();

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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy giỏ hàng từ session
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                request.setAttribute("error", "Your cart is empty");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // Tính toán tổng tiền và các thông tin cần thiết
            double totalPrice = Double.parseDouble(request.getParameter("grandTotal"));

            // Lưu thông tin vào request để hiển thị trên trang checkout
            request.setAttribute("cart", cart);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("user", user);
            request.setAttribute("cartItems", cart.getItems());
            request.setAttribute("cartTickets", cart.getTickets());
            request.setAttribute("point", new AccountService().getPointsByUserID(user.getUserID()));
            request.setAttribute("points", (int) Math.ceil(totalPrice * 1 / 100));
            // Chuyển hướng đến trang checkout
            request.getRequestDispatcher("check-out-before.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("404Loi.jsp").forward(request, response);
        }
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
        HttpSession session = request.getSession();
        String userID = request.getParameter("userID");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String paymentMethod = request.getParameter("paymentMethod");
        String totalPriceStr = request.getParameter("totalPrice");
        String note = request.getParameter("note");
        String fullName = request.getParameter("fullName");
        String points = request.getParameter("points");
        String bankCode = "VNPAYQR"; // LẤY BANK CODE

        double totalPrice = Double.parseDouble(totalPriceStr);
        long totalPriceL = (long) totalPrice;
        int orderID = 0;
        int paymentStatus = 0;
        List<CartItem> listItem;
        List<CartTicket> listTicket;

        try {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                request.setAttribute("error", "Your cart is empty");
                request.getRequestDispatcher("cart").forward(request, response);
                return;
            }

            listItem = cart.getItems();
            String itemStock = oService.checkItemStock(listItem);
            listTicket = cart.getTickets();

            if (!itemStock.isEmpty()) {
                request.setAttribute("error", 0);
                request.setAttribute("noti", itemStock + "\n out of Stock");
                request.getRequestDispatcher("NotificationOrder.jsp").forward(request, response);
                return;
            }

            Order orderTemp = new Order(
                    Integer.parseInt(userID),
                    BigDecimal.valueOf(totalPrice),
                    address,
                    phoneNumber,
                    email,
                    paymentMethod,
                    paymentStatus,
                    note,
                    fullName,
                    Integer.parseInt(points)
            );

            if (paymentMethod.equals("bankTransfer")) {
                orderID = oService.addOrder(orderTemp);

                String redirectUrl = request.getContextPath()
                        + "/ajaxServlet?action=order"
                        + "&userID=" + userID
                        + "&orderID=" + orderID
                        + "&value=" + totalPrice
                        + "&bankCode=" + bankCode;

                response.sendRedirect(redirectUrl);
                return;
            }

            if (paymentMethod.equals("points")) {
                paymentStatus = 1;
                orderTemp.setPaymentStatus(paymentStatus);
                orderTemp.setPoints(0);
                orderID = oService.addOrder(orderTemp);
                oService.payPoints(Integer.parseInt(userID), (int) totalPrice);
            } else if (paymentMethod.equals("cod")) {
                orderID = oService.addOrder(orderTemp);
            }

            for (CartItem p : listItem) {
                oService.addOrderDetail(orderID, p.getProductID(), p.getQuantity(), p.getPrice(),
                        0, pService.getVillageIDByProductID(p.getProductID()), paymentMethod, paymentStatus);
            }

            for (CartTicket t : listTicket) {
                oService.addTicketOrderDetail(orderID, t.getTicketId(), t.getQuantity(), t.getPrice(),
                        0, tService.getVillageIDByTicketID(t.getTicketId()), paymentMethod, paymentStatus);
            }

            int cartID = oService.getCartIDByUserID(Integer.parseInt(userID));
            oService.deleteCartItem(cartID);
            oService.deleteCartTicket(cartID);

            request.setAttribute("error", 1);
            request.getRequestDispatcher("NotificationOrder.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("404Loi.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Checkout Before Controller";
    }// </editor-fold>

}
