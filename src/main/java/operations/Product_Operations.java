package operations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.GetConnection;

import model.ProductPojo;

public class Product_Operations {

	public static ProductPojo getProductById(int productId) {
        String query = "SELECT ProductID, Name, Category, SellingPrice, Stock, SupplierInfo " +
                      "FROM products " +
                      "WHERE ProductID = ?";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductPojo product = new ProductPojo();
                    product.setProductID(rs.getInt("ProductID"));
                    product.setName(rs.getString("Name"));
                    product.setCategory(rs.getString("Category"));
                    product.setSellingPrice(rs.getDouble("SellingPrice"));
                    product.setStock(rs.getInt("Stock"));
                    product.setSupplierInfo(rs.getString("SupplierInfo"));
                    return product;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
	
    public static boolean editProduct(ProductPojo product) {
        try {
            String sql = "UPDATE products SET name = ?, category = ?, cost = ?, sellingPrice = ?, stock = ?, salesData = ?, reorderLevel = ?, supplierInfo = ?, expiryDate = ? WHERE productID = ?";
            
            PreparedStatement ps = GetConnection.getConnection().prepareStatement(sql);
            ps.setString(1, product.getName());
            ps.setString(2, product.getCategory());
            ps.setDouble(3, product.getCost());
            ps.setDouble(4, product.getSellingPrice());
            ps.setInt(5, product.getStock());
            ps.setString(6, product.getSalesData());
            ps.setInt(7, product.getReorderLevel());
            ps.setString(8, product.getSupplierInfo());
            ps.setDate(9, product.getExpiryDate());
            ps.setInt(10, product.getProductID());
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteProduct(int productID) {
        try {
            String sql = "DELETE FROM products WHERE productID = ?";
            Connection conn = GetConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productID);
            int rowsDeleted = ps.executeUpdate();
            return rowsDeleted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public static boolean addProduct(ProductPojo product) {
        try {
            String sql = "INSERT INTO products (name, category, cost, sellingPrice, stock, salesData, reorderLevel, supplierInfo, expiryDate) VALUES (?,?,?,?,?,?,?,?,?)";
            Connection conn = GetConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getName());
            ps.setString(2, product.getCategory());
            ps.setDouble(3, product.getCost());
            ps.setDouble(4, product.getSellingPrice());
            ps.setInt(5, product.getStock());
            ps.setString(6, product.getSalesData());
            ps.setInt(7, product.getReorderLevel());
            ps.setString(8, product.getSupplierInfo());
            ps.setDate(9, product.getExpiryDate());
            
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



public static boolean updateProductDetails(int productID, double newPrice, int newStock, String newSupplierInfo) {
    try {
        String sql = "UPDATE products SET sellingPrice = ?, stock = ?, supplierInfo = ? WHERE productID = ?";
        Connection conn = GetConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setDouble(1, newPrice);
        ps.setInt(2, newStock);
        ps.setString(3, newSupplierInfo);
        ps.setInt(4, productID);
        
        int rowsUpdated = ps.executeUpdate();
        return rowsUpdated > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}




}