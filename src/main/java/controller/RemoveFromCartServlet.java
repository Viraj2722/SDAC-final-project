package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import java.util.HashMap;
import db.GetConnection;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = GetConnection.getConnection();
            
            // Get parameters from request
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantityToRemove = Integer.parseInt(request.getParameter("quantity"));
            
            // Get cart from session
            HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
            if (cart == null || !cart.containsKey(productId)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Error: Product not found in cart.");
                return;
            }

            // Get current cart quantity for the product
            int currentQuantityInCart = cart.get(productId);

            // Check if the requested quantity to remove is valid
            if (quantityToRemove > currentQuantityInCart) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Error: Cannot remove more items than are in the cart.");
                return;
            }

            // Start transaction
            conn.setAutoCommit(false);

            // Update stock in database first
            String updateStockQuery = "UPDATE products SET Stock = Stock + ? WHERE ProductID = ?";
            pstmt = conn.prepareStatement(updateStockQuery);
            pstmt.setInt(1, quantityToRemove);
            pstmt.setInt(2, productId);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected == 0) {
                conn.rollback();
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Error: Failed to update product stock.");
                return;
            }

            // If stock update successful, update the cart
            if (quantityToRemove == currentQuantityInCart) {
                cart.remove(productId);
            } else {
                cart.put(productId, currentQuantityInCart - quantityToRemove);
            }

            // Save updated cart back to session
            session.setAttribute("cart", cart);

            // Prepare response with updated cart data
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

            // Commit transaction
            conn.commit();
            
            // Send response
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(cartData.toString());

        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Error: " + e.getMessage());
        } finally {
            try {
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