/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.OrderDAO;
import entity.Account.Account;
import entity.CartWishList.CartItem;
import entity.CraftVillage.CraftReview;
import entity.Orders.Order;
import entity.Orders.OrderDetail;
import entity.Orders.SubOrder;
import entity.Orders.TicketOrderDetail;
import entity.Product.ProductReview;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ACER
 */
public class OrderService implements IOrderService {

    OrderDAO oDAO = new OrderDAO();

    @Override
    public int createOrder(Order order) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Order getOrderById(int orderId) {
        return oDAO.getOrderById(orderId);
    }

    @Override
    public List<Order> getAllOrders() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        return oDAO.getOrdersByUserId(userId);
    }

    @Override
    public List<Order> getOrdersBySellerId(int sellerId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean cancelOrder(int orderId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int addOrderDetail(OrderDetail orderDetail) {
        return oDAO.addOrderDetail(orderDetail);
    }

    @Override
    public int addTicketOrderDetail(TicketOrderDetail ticketOrderDetail) {
        return oDAO.addTicketOrderDetail(ticketOrderDetail);
    }

    @Override
    public Map<String, Double> getRevenueByMonth() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Map<String, Double> getRevenueByYear() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Map<String, Object>> getTopSellingProducts() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int addOrder(Order order) {
        return oDAO.addOrder(order);
    }

    @Override
    public boolean updateOrder(Order order) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean deleteOrder(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateOrderDetail(int orderId, int productId, int quantity, double price) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean deleteOrderDetail(int orderId, int productId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void deleteCartItem(int cartID) {
        oDAO.deleteCartItem(cartID);
    }

    @Override
    public void deleteCartTicket(int cartID) {
        oDAO.deleteCartTicket(cartID);
    }

    @Override
    public int getCartIDByUserID(int userID) {
        return oDAO.getCartIDByUserID(userID);
    }

    public void addPoints(int userID, int points) {
        oDAO.addPoints(userID, points);
    }

    public String checkItemStock(List<CartItem> listItem) {
        return oDAO.checkItemStock(listItem);
    }

    public void payPoints(int userID, int points) {
        oDAO.payPoints(userID, points);
    }

    public void updatePaymentStatus(int orderID, int i) {
        oDAO.updatePaymentStatus(orderID, i);
    }

    public int getUserIDByOrderID(int orderID) {
        return oDAO.getUserIDByOrderID(orderID);
    }

    public double getOrderTotal(int orderID) {
        return oDAO.getOrderTotal(orderID);
    }

    public void deletePendingOrdersOlderThan(int i) {
        oDAO.deletePendingOrdersOlderThan(i);
    }

    /**
     * Kiểm tra order có tồn tại không
     *
     * @param orderID ID của order cần kiểm tra
     * @return true nếu order tồn tại, false nếu không
     */
    public boolean orderExists(int orderID) {
        return oDAO.orderExists(orderID);
    }

    public Order setPaymentStatusByOrderID(int parseInt, int i) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<OrderDetail> getAllOrderDetailByUserId(int userID) {
        return oDAO.getAllOrderDetailByUserId(userID);
    }

    public List<TicketOrderDetail> getAllTicketOrderDetailByUserId(int userID) {
        return oDAO.getAllTicketOrderDetailByUserId(userID);
    }

    public OrderDetail getOrderDetail(int orderDetailID) {
        return oDAO.getOrderDetail(orderDetailID);
    }

    @Override
    public void refundPayment(int id) {
        oDAO.refundSubOrderPayment(id);
    }

    public TicketOrderDetail getTicketOrderDetail(int detailID) {
        return oDAO.getTicketOrderDetail(detailID);
    }

    public Integer addSubOrder(SubOrder subOrder) {
        return oDAO.addSubOrder(subOrder);
    }

    public Integer getSubOrderID(int orderID, int villageID) {
        return oDAO.getSubOrderID(orderID, villageID);
    }

    public List<SubOrder> getSubOrderListByOrderID(int orderID) {
        return oDAO.getSubOrderListByOrderID(orderID);
    }

    public List<OrderDetail> getAllOrderDetailByOrderID(int subOrderId) {
        return oDAO.getAllOrderDetailByOrderID(subOrderId);
    }

    public List<TicketOrderDetail> getAllTicketOrderDetailByOrderID(int subOrderId) {
        return oDAO.getAllTicketOrderDetailByOrderID(subOrderId);
    }

    public boolean cancelSubOrderDetail(int subOrderId, String reason) {
        return oDAO.cancelSubOrderDetail(subOrderId, reason);
    }

    public SubOrder getSubOrderById(int subOrderId) {
        return oDAO.getSubOrderById(subOrderId);
    }

    public boolean confirmSubOrder(int subOrderId) {
        return oDAO.confirmSubOrder(subOrderId);
    }

    public boolean refundSubOrder(int subOrderId, String reason) {
        return oDAO.refundSubOrder(subOrderId, reason);
    }

    public boolean refundSubOrderPayment(int subOrderId) {
        return oDAO.refundSubOrderPayment(subOrderId);
    }

    @Override
    public boolean cancelOrderDetail(int orderDetailID, String cancelReason) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean cancelTicketOrderDetail(int detailID, String cancelReason) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean confirmOrderDetail(int orderID) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean confirmTicketOrderDetail(int detailID) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean refundOrderDetail(int orderDetailID, String refundReason) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean refundTicketOrderDetail(int detailID, String refundReason) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void updateReviewStatus(int subOrderId) {
        oDAO.updateReviewStatus(subOrderId);
    }

    public List<Order> getAllOrderByUserID(int userID) {
        return oDAO.getAllOrderByUserID(userID);
    }

    public List<TicketOrderDetail> getTicketOrderDetailNonReview(int subOrderId) {
        return oDAO.getTicketOrderDetailNonReview(subOrderId);
    }

    public List<OrderDetail> getOrderDetailNonReview(int subOrderId) {
        return oDAO.getOrderDetailNonReview(subOrderId);
    }

    public boolean addProductReviewByUser(ProductReview productReview) {
        return oDAO.addProductReviewByUser(productReview);
    }

    public void calculateProductReview(int rate, int productID) {
        oDAO.calculateProductReview(rate, productID);
    }

    public void updateOrderDetailReviewStatus(int id, int productID) {
        oDAO.updateOrderDetailReviewStatus(id, productID);
    }

    public boolean addVillageReviewByUser(CraftReview review) {
        return oDAO.addVillageReviewByUser(review);
    }

    public void calculateVillageReview(int rate, int villageID) {
        oDAO.calculateVillageReview(rate, villageID);
    }

    public void updateTicketOrderDetailReviewStatus(int subOrderId, int ticketID) {
        oDAO.updateTicketOrderDetailReviewStatus(subOrderId, ticketID);
    }

    public boolean checkSubOrderReviewStatus(int subOrderId) {
        return oDAO.checkSubOrderReviewStatus(subOrderId);
    }

    public List<SubOrder> getSearchSubOrderByAdmin(int status, int searchID) {
        return oDAO.getSearchSubOrderByAdmin( status,  searchID);
    }

    public List<SubOrder> getSearchSubOrderByAdmin(int status, int searchID,String contentSearch, int page, int pageSize) {
        return oDAO.getSearchSubOrderByAdmin( status,  searchID,contentSearch,  page,  pageSize) ;
    }

    public int getTotalSubOrders(int status, int searchID,String contentSearch) {
        return oDAO.getTotalSubOrders( status,  searchID,contentSearch);
    }

    public List<SubOrder> getSubOrderByVillageID(int villageID) {
        return oDAO.getSubOrderByVillageID(villageID);
    }

    public List<SubOrder> getSellerRecentOrders(int sellerId, int limit) {
        return oDAO.getSellerRecentOrders(sellerId, limit);
    }

     public OrderDetail getOrderDetailById(int orderDetailId) {
        return oDAO.getOrderDetailById(orderDetailId);
    }

    public Account getCustomerByOrderId(int orderId) {
        return oDAO.getCustomerByOrderId(orderId);
    }

    // Methods for seller order management using OrderDetail
    public List<OrderDetail> getOrderDetailsByVillageId(int villageId, int status, String searchKeyword, int page, int pageSize) {
        return oDAO.getOrderDetailsByVillageId(villageId, status, searchKeyword, page, pageSize);
    }

   public int getTotalOrderDetailsByVillageId(int villageId, int status, String searchKeyword) {
        return oDAO.getTotalOrderDetailsByVillageId(villageId, status, searchKeyword);
    }

    public List<SubOrder> getSOrdersByVillageId(int villageId, String orderStatus, String searchKeyword, int page, int pageSize) {
        return oDAO.getSOrdersByVillageId(villageId, orderStatus, searchKeyword, page, pageSize);
    }

    public int getTotalSOrderDetailsByVillageId(int villageId, String status, String searchKeyword) {
        return oDAO.getTotalSOrderDetailsByVillageId( villageId, status, searchKeyword);
    }

    public Order getAllOrderBuySubOrder() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void updateStatusSubOrder(int subOrderId, int orderStatus){
        oDAO.updateStatusSubOrder(subOrderId, orderStatus);
    }

    public TicketOrderDetail getTicketOrderByTicketCode(String code, int villageId) {
        return oDAO.getTicketOrderByTicketCode(code,villageId);
    }
    public static void main(String[] args) {
        System.out.println(new OrderService().getTicketOrderByTicketCode("V3T1U1CD2025-07-29 08", 3));
    }
}
