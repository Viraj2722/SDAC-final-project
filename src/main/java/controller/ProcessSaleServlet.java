package controller;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/ProcessSaleServlet")
public class ProcessSaleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Get basic sale information
            String paymentMethod = request.getParameter("paymentMethod");
            int itemCount = Integer.parseInt(request.getParameter("itemCount"));
            double cartTotal = Double.parseDouble(request.getParameter("cartTotal"));

            // Get customer ID from session
            HttpSession session = request.getSession();
            Integer customerId = (Integer) session.getAttribute("customerId");
            if (customerId == null) customerId = 53; // Default customer ID if not logged in

            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/erp_system", "root", "1234");
            conn.setAutoCommit(false); // Start transaction

            // SQL to insert into sales table
            String insertSale = "INSERT INTO sales (ProductID, CustomerID, SaleDate, Quantity, TotalAmount, PaymentMethod) " +
                                "VALUES (?, ?, NOW(), ?, ?, ?)";

            // Process each item in the sale
            for (int i = 0; i < itemCount; i++) {
                int productId = Integer.parseInt(request.getParameter("productId_" + i));
                int quantity = Integer.parseInt(request.getParameter("quantity_" + i));
                double itemTotal = Double.parseDouble(request.getParameter("total_" + i));

                // Insert sale record into the sales table
                ps = conn.prepareStatement(insertSale);
                ps.setInt(1, productId);
                ps.setInt(2, customerId);
                ps.setInt(3, quantity);
                ps.setDouble(4, itemTotal);
                ps.setString(5, paymentMethod);
                ps.executeUpdate();
            }

            // Update customer loyalty points (1 point per dollar spent)
            String updateLoyalty = "UPDATE customers SET LoyaltyPoints = LoyaltyPoints + ? WHERE CustomerID = ?";
            ps = conn.prepareStatement(updateLoyalty);
            ps.setInt(1, (int) cartTotal);
            ps.setInt(2, customerId);
            ps.executeUpdate();

            // Commit transaction
            conn.commit();
            out.write("success");

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                               "Error processing sale: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
}
