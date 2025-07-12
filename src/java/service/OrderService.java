/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.OrderDAO;
import entity.CartWishList.CartItem;
import entity.Orders.Order;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ACER
 */
public class OrderService implements IOrderService{

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
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
    public void addOrderDetail(int orderId, int productId, int quantity, double price, int status, int villageID, String paymentMethod, int paymentStatus)  {
        oDAO.addOrderDetail(orderId,productId,quantity,price,  status,  villageID,  paymentMethod,  paymentStatus);
    }

    @Override
    public void addTicketOrderDetail(int orderId, int ticketId, int quantity, double price, int status, int villageID, String paymentMethod, int paymentStatus) {
        oDAO.addTicketOrderDetail(orderId,ticketId,quantity,price,  status,  villageID,  paymentMethod,  paymentStatus);
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
        oDAO.addPoints(userID,points);
    }

    public String checkItemStock(List<CartItem> listItem) {
        return oDAO.checkItemStock(listItem);
    }

    public void payPoints(int userID, int points) {
        oDAO.payPoints(userID,points);
    }

    public void updatePaymentStatus(int orderID, int i) {
        oDAO.updatePaymentStatus(orderID,i);
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
     * @param orderID ID của order cần kiểm tra
     * @return true nếu order tồn tại, false nếu không
     */
    public boolean orderExists(int orderID) {
        return oDAO.orderExists(orderID);
    }

    public Order setPaymentStatusByOrderID(int parseInt, int i) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
