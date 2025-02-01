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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            
            if(session != null) {
                String userEmail = (String) session.getAttribute("mailID");
                if (userEmail != null) {
                    // Store cart temporarily
                    Object cart = session.getAttribute("cart_" + userEmail);
                    
                    // Clear only authentication-related attributes
                    session.removeAttribute("mailID");
                    session.removeAttribute("role");
                    
                    // Restore cart to session if it exists
                    if (cart != null) {
                        session.setAttribute("cart_" + userEmail, cart);
                    }
                }
                
                // Clear cookies if they exist
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
            
            response.sendRedirect("login.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }
}