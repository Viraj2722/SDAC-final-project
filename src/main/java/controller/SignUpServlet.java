package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserPojo;
import operations.Authentication_Operations;

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String mailID = request.getParameter("mailID");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        
        // Check if user already exists
        if (Authentication_Operations.userExists(mailID)) {
            request.setAttribute("errorMessage", "User already exists! Please login.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        UserPojo newUser = new UserPojo();
        newUser.setMailID(mailID);
        newUser.setName(name);
        newUser.setPassword(password);
        
        // Attempt registration
        if (Authentication_Operations.registerUser(newUser)) {
            // Redirect to login page with success message
            request.setAttribute("successMessage", "Registration successful! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed! Please try again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}