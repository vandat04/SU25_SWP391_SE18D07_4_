/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.ProductDAO;
import DAO.TicketDAO;
import entity.Orders.TicketCode;
import entity.Orders.TicketOrder;
import entity.Ticket.Ticket;
import java.util.List;

/**
 *
 * @author ACER
 */
public class TicketService implements ITicketService {

    ProductDAO pDAO = new ProductDAO();
    TicketDAO tDAO = new TicketDAO();

    @Override
    public List<Ticket> getTicketsByVillage(int villageId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean addTicket(Ticket ticket) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public TicketOrder createTicketOrder(TicketOrder order) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean cancelTicketOrder(int orderId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<TicketCode> getTicketCodesByOrderDetail(int detailId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Ticket> getAllTicketActive() {
        return pDAO.getAllTicketActive();
    }

    public boolean createTicketByAdmin(Ticket ticket) {
        return tDAO.createTicketByAdmin(ticket);
    }

    public boolean updateTicketByAdmin(Ticket ticket) {
        return tDAO.updateTicketByAdmin(ticket);
    }

    public boolean deleteTicketByAdmin(int ticketID) {
        return tDAO.deleteTicketByAdmin(ticketID);
    }

    public List<Ticket> getTickeReportByAdmin(int status) {
        return tDAO.getTickeReportByAdmin(status);
    }

    public String getTicketNameByID(int typeID){
        return tDAO.getTicketNameByID(typeID);
    }
    
}
