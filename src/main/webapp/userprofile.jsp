<%@page import="db.GetConnection"%>
<%@ page import="java.sql.*" %>

<%
String mailID = (String) session.getAttribute("mailID");
Integer customerIdObj = (Integer) session.getAttribute("CustomerID");
if (customerIdObj != null) {
    int customerId = customerIdObj;

   
    try (Connection conn = GetConnection.getConnection();
	PreparedStatement stmt = conn.prepareStatement("SELECT * FROM customers WHERE CustomerID = ?")) {
		stmt.setInt(1, customerId);
		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background: linear-gradient(to bottom right, #000000, #0f172a);
            color: #fff;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            min-height: 100vh;
        }
        
        .form-card {
            background: linear-gradient(145deg, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0.7));
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .form-input {
            background-color: rgba(2, 6, 23, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff;
            transition: all 0.2s ease;
        }
        
        .form-input:focus {
            background-color: rgba(2, 6, 23, 0.7);
            border-color: rgba(255, 255, 255, 0.2);
            outline: none;
            box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.1);
        }
        
        .form-label {
            color: #94a3b8;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .update-button {
            background-color: #fff;
            color: #000;
            transition: all 0.2s ease;
        }
        
        .update-button:hover {
            background-color: rgba(255, 255, 255, 0.9);
        }
        .home-button {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            background: linear-gradient(to bottom right, #000c3b, #00072d);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
        }
        
        .home-button:hover {
            background: rgba(255, 255, 255, 0.5);
        }
        
        .home-button svg {
            width: 16px;
            height: 16px;
        }
    </style>
</head>
<body class="flex items-center justify-center p-6">
<a href="homepage.jsp" class="home-button">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
        </svg>
        Home
    </a>
    <div class="w-full max-w-md my-8">
        <div class="form-card rounded-2xl p-6 space-y-4">
            <% 
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) { 
            %>
                <div class="bg-green-600 text-white p-3 rounded-lg text-center mb-4">
                    <%= successMessage %>
                </div>
                <% 
                // Clear the success message after displaying
                session.removeAttribute("successMessage"); 
            } 
            %>

            <h1 class="text-2xl font-semibold text-center text-white mb-6">User Profile</h1>
            
            <form action="UpdateProfileServlet" method="post" class="space-y-4">
                <div class="space-y-1">
                    <label for="name" class="form-label block">Name:</label>
                    <input type="text" id="name" name="name" 
                           value="<%= rs.getString("Name") %>" 
                           required
                           class="form-input w-full px-3 py-2 rounded-lg text-sm">
                </div>
                
                <div class="space-y-1">
                    <label for="email" class="form-label block">Email:</label>
                    <input type="email" id="email" name="email" 
                           value="<%= rs.getString("Email") %>" 
                           readonly
                           class="form-input w-full px-3 py-2 rounded-lg text-sm opacity-70">
                </div>
                
                <div class="space-y-1">
                    <label for="phone" class="form-label block">Phone:</label>
                    <input type="tel" id="phone" name="phone" 
                           value="<%= rs.getString("Phone") %>" 
                           required
                           class="form-input w-full px-3 py-2 rounded-lg text-sm">
                </div>
                
                <div class="space-y-1">
                    <label for="address" class="form-label block">Address:</label>
                    <textarea id="address" name="address" 
                              required
                              class="form-input w-full px-3 py-2 rounded-lg text-sm min-h-[80px] resize-none"><%= rs.getString("Address") %></textarea>
                </div>
                
                <input type="hidden" name="customerId" value="<%= customerId %>">
                
                <button type="submit" 
                        class="update-button w-full py-2 px-4 rounded-lg font-medium mt-6">
                    Update Profile
                </button>
            </form>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <p class="text-red-400 text-sm text-center">
                    <%= request.getAttribute("errorMessage") %>
                </p>
            <% } %>
        </div>
    </div>
</body>
</html>

<% } else { %>
    <p>User not found.</p>
<% }
    } catch (SQLException e) {
        e.printStackTrace();
    }
} else {
    // CustomerID not found in the session
    response.sendRedirect("login.jsp");
}
%>