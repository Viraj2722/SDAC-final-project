package operations;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import db.GetConnection;
import interfaces.Sale_Operations_Interface;
import model.ProductPojo;

public class Sale_Operations implements Sale_Operations_Interface{

    
    public Map<Integer, Map<String, Object>> getSalesSummary() {
        Map<Integer, Map<String, Object>> salesSummary = new HashMap<>();
        String query = "SELECT s.productID, SUM(s.totalAmount) AS totalRevenue, "
                     + "COUNT(s.saleID) AS saleCount, MAX(s.date) AS latestSaleDate "
                     + "FROM sales s "
                     + "GROUP BY s.productID";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int productId = rs.getInt("productID");

                
                Map<String, Object> salesDetails = new HashMap<>();
                salesDetails.put("totalRevenue", rs.getDouble("totalRevenue"));
                salesDetails.put("saleCount", rs.getInt("saleCount"));
                salesDetails.put("latestSaleDate", rs.getDate("latestSaleDate"));

                
                salesSummary.put(productId, salesDetails);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return salesSummary;
    }

    // Method to calculate profit for all products based on sales and stock data
    public Map<Integer, Double> computeProfitMargins() {
        Map<Integer, Double> profitMargins = new HashMap<>();
        String query = "SELECT p.productID, "
                     + "(p.sellingPrice - p.cost) AS unitProfit, "
                     + "SUM(s.quantity) AS totalQuantity "
                     + "FROM products p "
                     + "LEFT JOIN sales s ON p.productID = s.productID "
                     + "GROUP BY p.productID";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int productId = rs.getInt("productID");
                double unitProfit = rs.getDouble("unitProfit");
                int totalQuantitySold = rs.getInt("totalQuantity");

                // Calculate profit as unitProfit * totalQuantitySold
                double totalProfit = unitProfit * totalQuantitySold;
                profitMargins.put(productId, totalProfit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return profitMargins;
    }

    // Method to retrieve sales data and product information together
    public Map<ProductPojo, Map<String, Object>> fetchProductSalesData() {
        Map<ProductPojo, Map<String, Object>> productSalesData = new HashMap<>();
        String query = "SELECT p.productID, p.name, p.category, p.cost, p.sellingPrice, p.stock, "
                     + "p.reorderLevel, p.supplierInfo, p.expiryDate, "
                     + "SUM(s.totalAmount) AS revenue, COUNT(s.saleID) AS numberOfSales "
                     + "FROM products p "
                     + "LEFT JOIN sales s ON p.productID = s.productID "
                     + "GROUP BY p.productID";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                // Map product details 
                ProductPojo product = new ProductPojo(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("category"),
                        rs.getDouble("cost"),
                        rs.getDouble("sellingPrice"),
                        rs.getInt("stock"),
                        null, // Sales data not included in ProductPojo directly
                        rs.getInt("reorderLevel"),
                        rs.getString("supplierInfo"),
                        rs.getDate("expiryDate")
                );

                // Map sales details
                Map<String, Object> salesDetails = new HashMap<>();
                salesDetails.put("revenue", rs.getDouble("revenue"));
                salesDetails.put("numberOfSales", rs.getInt("numberOfSales"));

                productSalesData.put(product, salesDetails);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productSalesData;
    }

public boolean reduceStock(int productID, int quantity) {
    String sql = "UPDATE products SET Stock = Stock - ? WHERE ProductID = ? AND Stock >= ?";
    try (Connection conn = GetConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, quantity);
        ps.setInt(2, productID);
        ps.setInt(3, quantity); // Ensures stock won't go negative
        return ps.executeUpdate() > 0; // Returns true if stock is updated
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

public boolean processSale(int customerID, Map<Integer, Integer> items, BigDecimal totalAmount, String paymentMethod) {
    Connection conn = null;
    boolean success = false;
    try {
        conn = GetConnection.getConnection();
        conn.setAutoCommit(false); // Start transaction

        // Record each sale item in the sales table
        String saleSql = "INSERT INTO sales (ProductID, CustomerID, SaleDate, Quantity, TotalAmount, PaymentMethod) " +
                         "VALUES (?, ?, NOW(), ?, ?, ?)";
        for (Map.Entry<Integer, Integer> entry : items.entrySet()) {
            int productID = entry.getKey();
            int quantity = entry.getValue();
            
            // Validate stock before proceeding
            String stockCheckSql = "SELECT Stock FROM products WHERE ProductID = ?";
            try (PreparedStatement stockCheckPs = conn.prepareStatement(stockCheckSql)) {
                stockCheckPs.setInt(1, productID);
                ResultSet stockRs = stockCheckPs.executeQuery();
                if (stockRs.next()) {
                    int stock = stockRs.getInt("Stock");
                    if (stock < quantity) {
                        conn.rollback(); // Insufficient stock
                        return false;
                    }
                } else {
                    conn.rollback(); // Product not found
                    return false;
                }
            }

            // Insert sale record
            try (PreparedStatement salePs = conn.prepareStatement(saleSql)) {
                salePs.setInt(1, productID);
                salePs.setInt(2, customerID);
                salePs.setInt(3, quantity);
                salePs.setBigDecimal(4, totalAmount);
                salePs.setString(5, paymentMethod);
                salePs.executeUpdate();
            }

            // Reduce stock
            String stockUpdateSql = "UPDATE products SET Stock = Stock - ? WHERE ProductID = ?";
            try (PreparedStatement stockUpdatePs = conn.prepareStatement(stockUpdateSql)) {
                stockUpdatePs.setInt(1, quantity);
                stockUpdatePs.setInt(2, productID);
                if (stockUpdatePs.executeUpdate() <= 0) {
                    conn.rollback(); // Stock update failed
                    return false;
                }
            }
        }

        conn.commit(); // Commit transaction
        success = true;
    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback(); // Rollback on failure
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true); // Reset auto-commit
                conn.close();
            } catch (Exception closeEx) {
                closeEx.printStackTrace();
            }
        }
    }
    return success;
}

}

