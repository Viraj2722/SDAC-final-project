package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import operations.Authentication_Operations;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String mailID = request.getParameter("mailID");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // Check if user is deactivated
        if (Authentication_Operations.isUserDeactivated(mailID)) {
            request.setAttribute("errorMessage", "Account is deactivated. Please contact admin.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        if (Authentication_Operations.authenticateUser(mailID, password, role)) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("mailID", mailID);
            session.setAttribute("role", role);
            
            // Redirect based on role
            if (role.equalsIgnoreCase("admin")) {
                response.sendRedirect("adminPanel.jsp");
            } else {
                response.sendRedirect("homepage.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid credentials or role!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}