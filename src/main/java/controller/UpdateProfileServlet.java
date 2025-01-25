package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/erp_system";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer customerIdObj = (Integer) session.getAttribute("CustomerID");

        if (customerIdObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerId = customerIdObj;
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(
                 "UPDATE customers SET Name = ?, Phone = ?, Address = ? WHERE CustomerID = ?")) {

            stmt.setString(1, name);
            stmt.setString(2, phone);
            stmt.setString(3, address);
            stmt.setInt(4, customerId);

            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Error updating profile.");
            }

            response.sendRedirect("userprofile.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while updating the profile.");
            response.sendRedirect("userprofile.jsp");
        }
    }
}