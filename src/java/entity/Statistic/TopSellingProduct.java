package entity.Statistic;

/**
 * Lớp này chứa thông tin về sản phẩm bán chạy.
 */
public class TopSellingProduct {
    private String productName;
    private int totalQuantitySold;

    // Getters and Setters
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getTotalQuantitySold() { return totalQuantitySold; }
    public void setTotalQuantitySold(int totalQuantitySold) { this.totalQuantitySold = totalQuantitySold; }
}