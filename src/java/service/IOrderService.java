package service;

import entity.CartWishList.CartItem;
import entity.Orders.Order;
import java.util.List;
import java.util.Map;

public interface IOrderService {
    // Basic CRUD operations
    int createOrder(Order order) throws Exception;
    Order getOrderById(int orderId);
    List<Order> getAllOrders();
    List<Order> getOrdersByUserId(int userId);
    List<Order> getOrdersBySellerId(int sellerId);
    boolean updateOrderStatus(int orderId, String status);
    boolean cancelOrder(int orderId);
    
    // Business operations
    void addOrderDetail(int orderId, int productId, int quantity, double price, int status, int villageID, String paymentMethod, int paymentStatus) ;
    void addTicketOrderDetail(int orderId, int ticketId, int quantity, double price, int status, int villageID, String paymentMethod, int paymentStatus);
    void deleteCartItem(int cartID);
    void deleteCartTicket(int cartID);
    // Analytics operations
    Map<String, Double> getRevenueByMonth();
    Map<String, Double> getRevenueByYear();
    List<Map<String, Object>> getTopSellingProducts();

    int getCartIDByUserID(int userID);
    int addOrder(Order order);
    boolean updateOrder(Order order);
    boolean deleteOrder(int id);

    boolean updateOrderDetail(int orderId, int productId, int quantity, double price);
    boolean deleteOrderDetail(int orderId, int productId);
    
    String checkItemStock(List<CartItem> listItem) ;
    void payPoints(int userID, int points);
    void updatePaymentStatus(int orderID, int i) ;
    int getUserIDByOrderID(int orderID);
    double getOrderTotal(int parseInt);
    void deletePendingOrdersOlderThan(int i);
} 