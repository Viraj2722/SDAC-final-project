package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import db.GetConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import operations.Authentication_Operations;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final Authentication_Operations authOps = Authentication_Operations.getInstance();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String mailID = request.getParameter("mailID");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (authOps.isUserDeactivated(mailID)) {
            request.setAttribute("errorMessage", "Account is deactivated. Contact admin.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (authOps.authenticateUser(mailID, password, role)) {
            HttpSession session = request.getSession();
            session.setAttribute("mailID", mailID);
            session.setAttribute("role", role);

            if (role.equalsIgnoreCase("admin")) {
                // Skip fetching CustomerID for admin
                response.sendRedirect("usermanagement.jsp");
            } else {
                int customerId = getCustomerIdByEmail(mailID);
                if (customerId != -1) {
                    session.setAttribute("CustomerID", customerId);
                    HashMap<Integer, Integer> cart = new HashMap<>();
                    session.setAttribute("cart", cart);
                    response.sendRedirect("homepage.jsp");
                } else {
                    request.setAttribute("errorMessage", "Customer ID not found.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } else {
            request.setAttribute("errorMessage", "Invalid credentials or role!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private int getCustomerIdByEmail(String email) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT CustomerID FROM customers WHERE Email = ?")) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("CustomerID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}