package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import db.GetConnection;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        Connection conn = null;
        
        try {
            conn = GetConnection.getConnection();
            
            // Get the user's email
            String userEmail = (String) session.getAttribute("mailID");
            if (userEmail == null) {
                out.print("Cart is empty");
                return;
            }
            
            // Get user-specific cart from session using email as key
            String cartKey = "cart_" + userEmail;
            HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute(cartKey);
            
            if (cart == null || cart.isEmpty()) {
                out.print("Cart is empty");
                return;
            }
            
            // Build cart data with product details
            StringBuilder cartData = new StringBuilder();
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int pid = entry.getKey();
                int qty = entry.getValue();
                ProductInfo productInfo = getProductInfo(pid, conn);
                cartData.append(pid).append(",")
                       .append(qty).append(",")
                       .append(productInfo.price).append(",")
                       .append(productInfo.name).append("\n");
            }
            
            out.print(cartData.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Error retrieving cart: " + e.getMessage());
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Check if user is logged in
            String userEmail = (String) session.getAttribute("mailID");
            if (userEmail == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("Error: Please login to add items to cart");
                return;
            }
            
            conn = GetConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Get parameters from request
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // Get or create user-specific cart in session
            String cartKey = "cart_" + userEmail;
            HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute(cartKey);
            if (cart == null) {
                cart = new HashMap<>();
            }
            
            if (quantity < 0) { // Remove from cart case
                // Return stock to inventory
                String updateStockQuery = "UPDATE products SET Stock = Stock + ? WHERE ProductID = ?";
                pstmt = conn.prepareStatement(updateStockQuery);
                pstmt.setInt(1, Math.abs(quantity));
                pstmt.setInt(2, productId);
                pstmt.executeUpdate();
                
                // Remove item from cart
                cart.remove(productId);
                
                // If cart is now empty, remove it from session
                if (cart.isEmpty()) {
                    session.removeAttribute(cartKey);
                    conn.commit();
                    out.print("Cart is empty");
                    return;
                }
            } else { // Add to cart case
                // Check stock availability first
                String checkStockQuery = "SELECT Stock FROM products WHERE ProductID = ? FOR UPDATE";
                pstmt = conn.prepareStatement(checkStockQuery);
                pstmt.setInt(1, productId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    int currentStock = rs.getInt("Stock");
                    if (currentStock < quantity) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print("Error: Insufficient stock. Only " + currentStock + " items available.");
                        return;
                    }
                    
                    // Update stock
                    String updateStockQuery = "UPDATE products SET Stock = Stock - ? WHERE ProductID = ?";
                    pstmt = conn.prepareStatement(updateStockQuery);
                    pstmt.setInt(1, Math.abs(quantity));
                    pstmt.setInt(2, productId);
                    pstmt.executeUpdate();
                    
                    // Add or update product quantity in cart
                    cart.put(productId, cart.getOrDefault(productId, 0) + quantity);
                }
            }
            
            // Save cart back to session with user-specific key
            session.setAttribute(cartKey, cart);
            
            // Return cart data with product names
            StringBuilder cartData = new StringBuilder();
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int pid = entry.getKey();
                int qty = entry.getValue();
                ProductInfo productInfo = getProductInfo(pid, conn);
                cartData.append(pid).append(",")
                       .append(qty).append(",")
                       .append(productInfo.price).append(",")
                       .append(productInfo.name).append("\n");
            }
            
            conn.commit();
            out.print(cartData.toString());
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    private static class ProductInfo {
        double price;
        String name;
    }
    
    private ProductInfo getProductInfo(int productId, Connection conn) {
        ProductInfo info = new ProductInfo();
        try {
            String query = "SELECT Name, SellingPrice FROM products WHERE ProductID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                info.price = rs.getDouble("SellingPrice");
                info.name = rs.getString("Name");
            }
            rs.close();
            pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return info;
    }
}