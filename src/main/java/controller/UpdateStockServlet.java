package controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/UpdateStockServlet")
public class UpdateStockServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/erp_system";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "1234";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String quantity = request.getParameter("quantity");
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            // Begin transaction
            conn.setAutoCommit(false);
            
            // First check if we have enough stock
            String checkStockQuery = "SELECT Stock FROM products WHERE ProductID = ? FOR UPDATE";
            ps = conn.prepareStatement(checkStockQuery);
            ps.setInt(1, Integer.parseInt(productId));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int currentStock = rs.getInt("Stock");
                int requestedQuantity = Integer.parseInt(quantity);
                
                if (currentStock >= requestedQuantity) {
                    // Update stock
                    String updateQuery = "UPDATE products SET Stock = Stock - ? WHERE ProductID = ?";
                    ps = conn.prepareStatement(updateQuery);
                    ps.setInt(1, requestedQuantity);
                    ps.setInt(2, Integer.parseInt(productId));
                    
                    int result = ps.executeUpdate();
                    if (result > 0) {
                        conn.commit();
                        response.setStatus(HttpServletResponse.SC_OK);
                        return;
                    }
                }
            }
            
            // If we get here, something went wrong
            conn.rollback();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Insufficient stock");
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating stock: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
