package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/erp_system";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Map<String, Object> result = new HashMap<>();
            
            switch (action) {
                case "add":
                    result = addProduct(conn, request);
                    break;
                case "update":
                    result = updateProduct(conn, request);
                    break;
                case "delete":
                    result = deleteProduct(conn, request);
                    break;
                default:
                    result.put("success", false);
                    result.put("message", "Invalid action specified");
                    break;
            }
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(result));
            
        } catch (SQLException e) {
            handleError(response, e);
        }
    }

    private Map<String, Object> addProduct(Connection conn, HttpServletRequest request) 
            throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL add_product(?, ?, ?, ?, ?, ?, ?, ?, ?)}")) {
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("category"));
            stmt.setDouble(3, Double.parseDouble(request.getParameter("cost")));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("sellingPrice")));
            stmt.setInt(5, Integer.parseInt(request.getParameter("stock")));
            stmt.setInt(6, Integer.parseInt(request.getParameter("reorderLevel")));
            stmt.setString(7, request.getParameter("supplierInfo"));
            
            String expiryDate = request.getParameter("expiryDate");
            if (expiryDate != null && !expiryDate.isEmpty()) {
                stmt.setDate(8, Date.valueOf(expiryDate));
            } else {
                stmt.setNull(8, Types.DATE);
            }
            
            stmt.registerOutParameter(9, Types.BOOLEAN);
            
            stmt.execute();
            
            result.put("success", stmt.getBoolean(9));
            result.put("message", stmt.getBoolean(9) ? "Product added successfully" : "Failed to add product");
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid number format: " + e.getMessage());
        }
        
        return result;
    }

    private Map<String, Object> updateProduct(Connection conn, HttpServletRequest request) 
            throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL update_product(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}")) {
            // Set input parameters
            stmt.setInt(1, Integer.parseInt(request.getParameter("productId")));
            stmt.setString(2, request.getParameter("name"));
            stmt.setString(3, request.getParameter("category"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("cost")));
            stmt.setDouble(5, Double.parseDouble(request.getParameter("sellingPrice")));
            stmt.setInt(6, Integer.parseInt(request.getParameter("stock")));
            stmt.setInt(7, Integer.parseInt(request.getParameter("reorderLevel")));
            stmt.setString(8, request.getParameter("supplierInfo"));
            
            // Handle expiry date
            String expiryDate = request.getParameter("expiryDate");
            if (expiryDate != null && !expiryDate.isEmpty()) {
                stmt.setDate(9, Date.valueOf(expiryDate));
            } else {
                stmt.setNull(9, Types.DATE);
            }
            
            // Register output parameter
            stmt.registerOutParameter(10, Types.BOOLEAN);
            
            stmt.execute();
            
            result.put("success", stmt.getBoolean(10));
            result.put("message", stmt.getBoolean(10) ? "Product updated successfully" : "Product not found");
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid number format: " + e.getMessage());
        }
        
        return result;
    }

    private Map<String, Object> deleteProduct(Connection conn, HttpServletRequest request) 
            throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL delete_product(?, ?)}")) {
            stmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            stmt.registerOutParameter(2, Types.BOOLEAN);
            
            stmt.execute();
            
            result.put("success", stmt.getBoolean(2));
            result.put("message", stmt.getBoolean(2) ? "Product deleted successfully" : "Failed to delete product");
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid product ID format");
        }
        
        return result;
    }

    private void handleError(HttpServletResponse response, Exception e) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", "An error occurred: " + e.getMessage());
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(result));
    }
}