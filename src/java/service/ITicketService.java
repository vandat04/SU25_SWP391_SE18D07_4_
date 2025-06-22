/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import entity.Orders.TicketCode;
import entity.Orders.TicketOrder;
import entity.Ticket.Ticket;
import java.util.List;

/**
 *
 * @author ACER
 */
public interface ITicketService {
    List<Ticket> getTicketsByVillage(int villageId);
    boolean addTicket(Ticket ticket);
    TicketOrder createTicketOrder(TicketOrder order) throws Exception;
    boolean cancelTicketOrder(int orderId);
    List<TicketCode> getTicketCodesByOrderDetail(int detailId);
}
