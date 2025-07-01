package entity.Statistic;

import java.math.BigDecimal;

/**
 * Lớp này chứa các chỉ số thống kê tổng quan.
 */
public class StatisticSummary {
    private BigDecimal totalRevenue;
    private int totalOrders;
    private int totalProductsSold;

    // Getters and Setters
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    public int getTotalProductsSold() { return totalProductsSold; }
    public void setTotalProductsSold(int totalProductsSold) { this.totalProductsSold = totalProductsSold; }
}