package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get the session
            HttpSession session = request.getSession(false);
            
            if(session != null) {
                // Clear session attributes
                session.removeAttribute("mailID");
                session.removeAttribute("role");
                
                // Invalidate the session
                session.invalidate();
                
                // Clear any cookies if they exist
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        cookie.setValue("");
                        cookie.setPath("/");
                        cookie.setMaxAge(0);
                        response.addCookie(cookie);
                    }
                }
            }
            
            // Redirect to login page
            response.sendRedirect("login.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            // If any error occurs, still try to redirect to login
            response.sendRedirect("login.jsp");
        }
    }
    
    // Handle POST requests the same way as GET
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}