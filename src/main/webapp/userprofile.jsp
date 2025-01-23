<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserPojo, operations.Authentication_Operations" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .profile-container {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <%
    // Session check similar to homepage
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("mailID") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userEmail = (String) userSession.getAttribute("mailID");
    Authentication_Operations authOps = Authentication_Operations.getInstance();
    UserPojo currentUser = authOps.getUserByEmail(userEmail);
    %>

    <div class="container">
        <div class="profile-container">
            <div class="text-center mb-4">
                <img src="https://cdn-icons-png.flaticon.com/512/12225/12225881.png" 
                     class="rounded-circle" 
                     width="120" height="120" 
                     alt="Profile Picture">
                <h2 class="mt-3"><%=currentUser.getName() %></h2>
                <p class="text-muted"><%=userEmail %></p>
            </div>

            <form id="profileForm">
                <div class="mb-3">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="name" 
                           value="<%=currentUser.getName() %>" readonly>
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" 
                           value="<%=userEmail %>" readonly>
                </div>

                <div class="mb-3">
                    <label for="accountCreated" class="form-label">Account Created</label>
                    <input type="text" class="form-control" id="accountCreated" 
                           value="<%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %>" readonly>
                </div>

                <div class="text-center">
                    <button type="button" class="btn btn-primary" onclick="editProfile()">
                        Edit Profile
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
    
    <script>
    function editProfile() {
        alert('Profile editing functionality to be implemented');
        // Future implementation: Open modal or redirect to profile edit page
    }
    </script>
</body>
</html>