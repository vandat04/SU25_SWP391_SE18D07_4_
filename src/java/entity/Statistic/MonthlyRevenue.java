package entity.Statistic;

import java.math.BigDecimal;

/**
 * Lớp này chứa doanh thu theo từng tháng.
 */
public class MonthlyRevenue {
    private String month; // Định dạng "YYYY-MM"
    private BigDecimal revenue;

    // Getters and Setters
    public String getMonth() { return month; }
    public void setMonth(String month) { this.month = month; }
    public BigDecimal getRevenue() { return revenue; }
    public void setRevenue(BigDecimal revenue) { this.revenue = revenue; }
}