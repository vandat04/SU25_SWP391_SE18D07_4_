/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.ReportDAO;
import entity.Orders.Payment;
import java.math.BigDecimal;
import java.util.Map;

/**
 *
 * @author ACER
 */
public class ReportService implements IReportService{

    ReportDAO rDAO = new ReportDAO();
    
    @Override
    public Map<Integer, Integer> getMonthlyAccountRegistrations(int month, int year) {
        return rDAO.getMonthlyAccountRegistrations(month, year);
    }

    @Override
    public Map<Integer, Integer> getOrderStatusSummaryByMonthYear(int month, int year) {
       return rDAO.getOrderStatusSummaryByMonthYear(month, year);
    }


    public BigDecimal getRevenueByDayMonthYear(int date, int month, int year) {
        return rDAO.getRevenueByDayMonthYear(date, month, year);
    }


    @Override
    public int getNumberCraftPostByDayMonthYear(int day, int month, int year) {
        return rDAO.getNumberCraftPostByDayMonthYear(day, month, year);
    }

    @Override
    public int getNumberProductPostByDayMonthYear(int day, int month, int year) {
        return rDAO.getNumberProductPostByDayMonthYear(day, month, year);
    }

    @Override
    public int getNumberTicketPostByDayMonthYear(int day, int month, int year) {
        return rDAO.getNumberTicketPostByDayMonthYear(day, month, year);
    }

    @Override
    public void addPaymentManagement(Payment payment, int paymentStatus, int status) {
        rDAO.addPaymentManagement(payment, paymentStatus, status);
    }
    
    public int getSellerIdByProductId(int pid){ 
        return rDAO.getSellerIdByProductId(pid);
    }
    public int getSellerIdByTicketId(int ticketId){ 
        return rDAO.getSellerIdByTicketId(ticketId);
    }
    
    public int getSellerIdByVillageId(int villageId){ 
        return rDAO.getSellerIdByVillageId(villageId);
    }

    public Payment getPaymentBySubOrderID(int subOrderId) {
        return rDAO.getPaymentBySubOrderID(subOrderId);
    }
}
