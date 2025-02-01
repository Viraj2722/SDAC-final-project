package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.GetConnection;

@WebServlet("/GetCustomerAddressServlet")
public class GetCustomerAddressServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("CustomerID") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No customer logged in");
            return;
        }

        int customerId = (int) session.getAttribute("CustomerID");
        String address = getCustomerAddressByCustomerId(customerId);
      
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(address);
    }

    private String getCustomerAddressByCustomerId(int customerId) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT Address FROM customers WHERE CustomerID = ?")) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String address = rs.getString("Address");
                return address != null ? address : "Address not available";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error retrieving address: " + e.getMessage();
        }
        return "Address not available";
    }
}