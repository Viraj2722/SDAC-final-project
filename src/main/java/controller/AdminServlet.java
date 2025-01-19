package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import operations.Authentication_Operations;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String action = request.getParameter("action"); // "deactivate" or "reactivate"
        String targetMailID = request.getParameter("mailID");
        
        // Get the admin's session
        HttpSession session = request.getSession();
        String adminMailID = (String) session.getAttribute("mailID");
        String role = (String) session.getAttribute("role");
        
        // Verify admin privileges
        if (adminMailID == null || !role.equalsIgnoreCase("admin")) {
            request.setAttribute("errorMessage", "Unauthorized access: Admin privileges required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        boolean success = false;
        String message = "";
        
        // Perform the requested action
        if ("deactivate".equalsIgnoreCase(action)) {
            success = Authentication_Operations.deactivateUser(targetMailID);
            message = success ? "User deactivated successfully" : "Failed to deactivate user";
        } 
        else if ("reactivate".equalsIgnoreCase(action)) {
            success = Authentication_Operations.reactivateUser(targetMailID);
            message = success ? "User reactivated successfully" : "Failed to reactivate user";
        }
        else {
            message = "Invalid action requested";
        }
        
        // Set appropriate message
        if (success) {
            request.setAttribute("successMessage", message + ": " + targetMailID);
        } else {
            request.setAttribute("errorMessage", message + ": " + targetMailID);
        }
        
        // Redirect back to admin dashboard
        request.getRequestDispatcher("usermanagement.jsp").forward(request, response);
    }
}