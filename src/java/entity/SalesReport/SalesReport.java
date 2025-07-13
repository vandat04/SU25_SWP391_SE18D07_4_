package entity.SalesReport;

import java.math.BigDecimal; // <-- CHANGED THIS LINE
import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class SalesReport {
    private int reportID;
    private int sellerID;
    private int reportMonth;
    private int reportYear;
    private int totalOrders;
    private BigDecimal totalRevenue; // <-- CHANGED TO BigDecimal
    private int totalProducts;
    private BigDecimal commission;   // <-- CHANGED TO BigDecimal
    private BigDecimal netRevenue;   // <-- CHANGED TO BigDecimal
    private Timestamp generatedDate;

    // Constructor
    public SalesReport(int reportID, int sellerID, int reportMonth, int reportYear,
                       int totalOrders, BigDecimal totalRevenue, int totalProducts, // <-- CHANGED PARAMETER TYPE
                       BigDecimal commission, BigDecimal netRevenue, Timestamp generatedDate) { // <-- CHANGED PARAMETER TYPES
        this.reportID = reportID;
        this.sellerID = sellerID;
        this.reportMonth = reportMonth;
        this.reportYear = reportYear;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
        this.totalProducts = totalProducts;
        this.commission = commission;
        this.netRevenue = netRevenue;
        this.generatedDate = generatedDate;
    }

    // Getters and Setters
    public int getReportID() { return reportID; }
    public void setReportID(int reportID) { this.reportID = reportID; }
    public int getSellerID() { return sellerID; }
    public void setSellerID(int sellerID) { this.sellerID = sellerID; }
    public int getReportMonth() { return reportMonth; }
    public void setReportMonth(int reportMonth) { this.reportMonth = reportMonth; }
    public int getReportYear() { return reportYear; }
    public void setReportYear(int reportYear) { this.reportYear = reportYear; }
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    public BigDecimal getTotalRevenue() { return totalRevenue; } // <-- CHANGED RETURN TYPE
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; } // <-- CHANGED PARAMETER TYPE
    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
    public BigDecimal getCommission() { return commission; } // <-- CHANGED RETURN TYPE
    public void setCommission(BigDecimal commission) { this.commission = commission; } // <-- CHANGED PARAMETER TYPE
    public BigDecimal getNetRevenue() { return netRevenue; } // <-- CHANGED RETURN TYPE
    public void setNetRevenue(BigDecimal netRevenue) { this.netRevenue = netRevenue; } // <-- CHANGED PARAMETER TYPE
    public Timestamp getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(Timestamp generatedDate) { this.generatedDate = generatedDate; }

    @Override
    public String toString() {
        return "SalesReport{" +
                "reportID=" + reportID +
                ", sellerID=" + sellerID +
                ", reportMonth=" + reportMonth +
                ", reportYear=" + reportYear +
                ", totalOrders=" + totalOrders +
                ", totalRevenue=" + totalRevenue +
                ", totalProducts=" + totalProducts +
                ", commission=" + commission +
                ", netRevenue=" + netRevenue +
                ", generatedDate=" + generatedDate +
                '}';
    }
}