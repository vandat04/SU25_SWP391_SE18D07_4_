/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Orders;

import entity.Ticket.Ticket;
import java.math.BigDecimal;

public class TicketOrderDetail {

    private int detailID;
    private int orderID;
    private int subOrderId;
    private int ticketID;
    private int quantity;
    private BigDecimal price;
    private BigDecimal subtotal; // Computed column
    private Integer villageID;
    private String villageName;
    private int reviewStatus;
    private String ticketCode;
    private Ticket ticket; // Added for seller management
    
    // Constructors
    public TicketOrderDetail() {
    }

    public TicketOrderDetail(int detailID, int orderID, int subOrderId, int ticketID, int quantity, BigDecimal price, BigDecimal subtotal, Integer villageID, int reviewStatus, String ticketCode) {
        this.detailID = detailID;
        this.orderID = orderID;
        this.subOrderId = subOrderId;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.villageID = villageID;
        this.reviewStatus = reviewStatus;
        this.ticketCode = ticketCode;
    }

    public TicketOrderDetail(int detailID, int orderID, int subOrderId, int ticketID,
            int quantity, BigDecimal price, BigDecimal subtotal, Integer villageID) {
        this.detailID = detailID;
        this.orderID = orderID;
        this.subOrderId = subOrderId;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.villageID = villageID;
    }

    public TicketOrderDetail(int detailID, int orderID, int subOrderId, int ticketID, int quantity, BigDecimal price, BigDecimal subtotal, Integer villageID, String villageName) {
        this.detailID = detailID;
        this.orderID = orderID;
        this.subOrderId = subOrderId;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.villageID = villageID;
        this.villageName = villageName;
    }

    public TicketOrderDetail(int orderID, int subOrderId, int ticketID, int quantity, BigDecimal price, Integer villageID, String ticketCode) {
        this.orderID = orderID;
        this.subOrderId = subOrderId;
        this.ticketID = ticketID;
        this.quantity = quantity;
        this.price = price;
        this.villageID = villageID;
        this.ticketCode = ticketCode;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public int getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(int reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public String getVillageName() {
        return villageName;
    }

    public void setVillageName(String villageName) {
        this.villageName = villageName;
    }

    public int getDetailID() {
        return detailID;
    }

    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getSubOrderId() {
        return subOrderId;
    }

    public void setSubOrderId(int subOrderId) {
        this.subOrderId = subOrderId;
    }

    public int getTicketID() {
        return ticketID;
    }

    public void setTicketID(int ticketID) {
        this.ticketID = ticketID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public Integer getVillageID() {
        return villageID;
    }

    public void setVillageID(Integer villageID) {
        this.villageID = villageID;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    @Override
    public String toString() {
        return "TicketOrderDetail{" + "detailID=" + detailID + ", orderID=" + orderID + ", subOrderId=" + subOrderId + ", ticketID=" + ticketID + ", quantity=" + quantity + ", price=" + price + ", subtotal=" + subtotal + ", villageID=" + villageID + ", villageName=" + villageName + ", reviewStatus=" + reviewStatus + ", ticketCode=" + ticketCode + '}';
    }

    

}
