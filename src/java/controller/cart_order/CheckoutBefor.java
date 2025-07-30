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
import entity.Orders.OrderDetail;
import entity.Orders.Payment;
import entity.Orders.SubOrder;
import entity.Orders.TicketOrderDetail;
import entity.Ticket.Ticket;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import service.AccountService;
import service.CartService;
import service.OrderService;
import service.ProductService;
import service.ReportService;
import service.TicketService;
import service.VillageService;

@WebServlet(name = "CheckoutBefor", urlPatterns = {"/checkout-before"})
public class CheckoutBefor extends HttpServlet {

    private final CartService cService = new CartService();
    private final OrderService oService = new OrderService();
    private final ProductService pService = new ProductService();
    private final TicketService tService = new TicketService();

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
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || (cart.getItems().isEmpty() && cart.getTickets().isEmpty())) {
                request.setAttribute("error", "Your cart is empty");
                request.getRequestDispatcher("cart").forward(request, response);
                return;
            }

            double totalPrice = Double.parseDouble(request.getParameter("grandTotal"));

            request.setAttribute("cart", cart);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("user", user);
            request.setAttribute("cartItems", cart.getItems());
            request.setAttribute("cartTickets", cart.getTickets());
            request.setAttribute("point", new AccountService().getPointsByUserID(user.getUserID()));
            request.setAttribute("points", (int) Math.ceil(totalPrice / 10000));

            request.getRequestDispatcher("check-out-before.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("404Loi.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        String userID = request.getParameter("userID");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String paymentMethod = request.getParameter("paymentMethod");
        String totalPriceStr = request.getParameter("totalPrice");
        String note = request.getParameter("note");
        String fullName = request.getParameter("fullName");
        String bankCode = "VNPAYQR";
        request.getSession().setAttribute("noteOrder", note);

        double totalPrice = Double.parseDouble(totalPriceStr);
        int orderID = 0;
        List<CartItem> listItem;
        List<CartTicket> listTicket;
        ProductService pService = new ProductService();
        ReportService rService = new ReportService();
        VillageService vService = new VillageService();

        try {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || (cart.getItems().isEmpty() && cart.getTickets().isEmpty())) {
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
                    fullName,
                    paymentMethod,
                    email
            );
            orderID = oService.addOrder(orderTemp);

            if (paymentMethod.equals("bankTransfer")) {
                String redirectUrl = request.getContextPath()
                        + "/ajaxServlet?action=order"
                        + "&userID=" + userID
                        + "&orderID=" + orderID
                        + "&value=" + totalPrice
                        + "&bankCode=" + bankCode;

                response.sendRedirect(redirectUrl);
                return;
            }

            Map<Integer, BigDecimal> villageMap = pService.getSetVillage(listItem, listTicket);

            for (Map.Entry<Integer, BigDecimal> entry : villageMap.entrySet()) {
                int villageID = entry.getKey();
                BigDecimal totalPriceSubOrder = entry.getValue();
                BigDecimal divisor = new BigDecimal("10000");
                int pointSubOrder = totalPriceSubOrder.divide(divisor, RoundingMode.DOWN).intValue();

                SubOrder subOrder = new SubOrder(
                        orderID,
                        villageID,
                        totalPriceSubOrder,
                        paymentMethod.equalsIgnoreCase("points") ? 0 : pointSubOrder,
                        paymentMethod,
                        paymentMethod.equalsIgnoreCase("points") ? 1 : 0,
                        0,
                        note
                );
                int subOrderId = oService.addSubOrder(subOrder);

                if (paymentMethod.equalsIgnoreCase("points")) {
                    rService.addPaymentManagement(new Payment(subOrderId, vService.getVillageById(villageID).getSellerId(), totalPriceSubOrder, paymentMethod, 1, ""), 1, 2);
                    oService.payPoints(Integer.parseInt(userID), pointSubOrder);
                }

//                // Gọi API GHN tạo đơn và cập nhật vào CSDL
//                try {
//                    GHNService.createShippingOrderAndUpdate(subOrderId, fullName, phoneNumber, address, totalPriceSubOrder);
//                } catch (Exception ex) {
//                    System.err.println("Failed to call GHN API: " + ex.getMessage());
//                    ex.printStackTrace();
//                }
            }

            for (CartItem p : listItem) {
                int villageID = pService.getVillageIDByProductID(p.getProductID());
                int subOrderId = oService.getSubOrderID(orderID, villageID);
                oService.addOrderDetail(new OrderDetail(orderID, subOrderId, p.getProductID(), p.getQuantity(), BigDecimal.valueOf(p.getPrice()), villageID));
            }

            for (CartTicket t : listTicket) {
                int villageID = pService.getVillageIDByTicketID(t.getTicketId());
                int subOrderId = oService.getSubOrderID(orderID, villageID);
                Ticket ticket  = new TicketService().getTicketByTicketId(t.getTicketId());
                String ticketCode = "V" + villageID + "T" + ticket.getTypeID() + "U" + userID + "CD" + new Timestamp(System.currentTimeMillis());
                oService.addTicketOrderDetail(new TicketOrderDetail(orderID, subOrderId, t.getTicketId(), t.getQuantity(), BigDecimal.valueOf(t.getPrice()), villageID, ticketCode, t.getTicketDate()));
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

    @Override
    public String getServletInfo() {
        return "Checkout Before Controller";
    }
}
