/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import entity.Orders.TicketCode;
import entity.Orders.TicketOrderDetail;
import java.util.List;

/**
 *
 * @author ACER
 */
public interface ITicketOrderService {
    // Chi tiết đơn
    List<TicketOrderDetail> getOrderDetails(int orderId);
    boolean addTicketOrderDetail(int orderId, int ticketId, int quantity, double price);
    // Mã vé (QR)
    List<TicketCode> getTicketCodesByOrder(int orderId);
    TicketCode getTicketCodeByCode(String code);
    boolean markTicketAsUsed(String code);
    // Hủy đơn
    boolean cancelTicketOrder(int orderId, String reason);
    // Thống kê
    double calculateTotalRevenue();

}