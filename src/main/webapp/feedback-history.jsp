<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Check if user is logged in
HttpSession userSession = request.getSession(false);
if (userSession == null || userSession.getAttribute("mailID") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String userEmail = (String) userSession.getAttribute("mailID");

// Handle delete feedback action
if (request.getParameter("deleteFeedback") != null) {
    int feedbackId = Integer.parseInt(request.getParameter("deleteFeedback"));
    String dbURL = "jdbc:mysql://localhost:3306/erp_system";
    String dbUser = "root";
    String dbPassword = "1234";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        // Verify the feedback belongs to the logged-in user before deleting
        String verifyQuery = "SELECT f.FeedbackID FROM feedback f " +
                           "JOIN customers c ON f.CustomerID = c.CustomerID " +
                           "WHERE f.FeedbackID = ? AND c.Email = ?";
        PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery);
        verifyStmt.setInt(1, feedbackId);
        verifyStmt.setString(2, userEmail);
        ResultSet verifyRs = verifyStmt.executeQuery();
        
        if (verifyRs.next()) {
            // Delete the feedback
            String deleteQuery = "DELETE FROM feedback WHERE FeedbackID = ?";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery);
            deleteStmt.setInt(1, feedbackId);
            deleteStmt.executeUpdate();
            
            // Redirect to refresh the page
            response.sendRedirect("feedback-history.jsp?deleted=true");
            return;
        }
        conn.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>" + e.getMessage() + "</div>");
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedback History - ShopHub</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
  /* Add these styles to your existing CSS */
:root {
    --dark-bg: #1a1a1a;
    --card-bg: #2a2a2a;
    --text-primary: #ffffff;
    --text-secondary: #b0b0b0;
    --accent-green: #4CAF50;
}

body {
    background-color: var(--dark-bg);
    color: var(--text-primary);
}

.navbar {
    background-color: var(--dark-bg) !important;
    border-bottom: 1px solid #333;
}

.card {
    background-color: var(--card-bg);
    border: none;
}

.card-body {
    color: var(--text-primary);
}

.card-title {
    color: var(--text-primary);
}

.text-muted {
    color: var(--text-secondary) !important;
}

.alert-info {
    background-color: var(--card-bg);
    border-color: #333;
    color: var(--text-primary);
}

.alert-success {
    background-color: #1b4d1b;
    border-color: #2c662c;
    color: var(--text-primary);
}

.alert-danger {
    background-color: #4d1b1b;
    border-color: #662c2c;
    color: var(--text-primary);
}

.btn-outline-primary {
    color: var(--text-primary);
    border-color: var(--text-primary);
}

.btn-outline-primary:hover {
    background-color: var(--text-primary);
    color: var(--dark-bg);
}

.footer {
    background-color: var(--dark-bg) !important;
    border-top: 1px solid #333;
}

h2 {
    color: var(--text-primary);
}
    </style>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">ShopHub</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="homepage.jsp">
                            <i class="fas fa-home"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-user"></i> <%= userEmail %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="orderhistory.jsp">
                            <i class="fas fa-history"></i> Order History
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link logout-btn" href="#" onclick="logout()">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <h2 class="mb-4">My Feedback History</h2>
        
        <% if (request.getParameter("deleted") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                Feedback has been successfully deleted.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="row g-4">
            <%
            String dbURL = "jdbc:mysql://localhost:3306/erp_system";
            String dbUser = "root";
            String dbPassword = "1234";
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                
                // First get the CustomerID for the logged-in user
                String customerQuery = "SELECT CustomerID FROM customers WHERE Email = ?";
                PreparedStatement pstmt = conn.prepareStatement(customerQuery);
                pstmt.setString(1, userEmail);
                ResultSet customerRs = pstmt.executeQuery();

                if (customerRs.next()) {
                    int customerId = customerRs.getInt("CustomerID");
                    
                    // Now get all feedback from this customer
                    String feedbackQuery = "SELECT f.*, p.Name as ProductName FROM feedback f " +
                                         "JOIN products p ON f.ProductID = p.ProductID " +
                                         "WHERE f.CustomerID = ? " +
                                         "ORDER BY f.FeedbackDate DESC";
                    
                    pstmt = conn.prepareStatement(feedbackQuery);
                    pstmt.setInt(1, customerId);
                    ResultSet rs = pstmt.executeQuery();
                    
                    if (!rs.isBeforeFirst()) {
 // No feedback found
                        %>
                        <div class="col-12">
                            <div class="alert alert-info" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                You haven't provided any feedback yet. When you rate products, they will appear here!
                            </div>
                        </div>
                        <%                    }
                    
                    while (rs.next()) {
                        %>
                        <div class="col-md-6 col-lg-4">
                            <div class="card feedback-card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><%= rs.getString("ProductName") %></h5>
                                    <div class="mb-2">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <i class="fas fa-star star-rating <%= i <= rs.getInt("Rating") ? "" : "text-secondary" %>"></i>
                                        <% } %>
                                    </div>
                                    <p class="card-text"><%= rs.getString("Comments") %></p>
                                    <p class="card-text">
                                        <small class="text-muted">
                                            <i class="far fa-clock me-1"></i>
                                            <%= rs.getTimestamp("FeedbackDate") %>
                                        </small>
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <a href="productpage.jsp?productId=<%= rs.getInt("ProductID") %>" 
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-external-link-alt me-1"></i>
                                            View Product
                                        </a>
                                        <button onclick="confirmDelete(<%= rs.getInt("FeedbackID") %>)" 
                                                class="btn btn-outline-danger btn-sm">
                                            <i class="fas fa-trash-alt me-1"></i>
                                            Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                    }
                }
                conn.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>" + e.getMessage() + "</div>");
            }
            %>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <h5>ShopHub</h5>
                    <p class="mb-0">Your one-stop shop for everything you need.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <p class="mb-0">&copy; 2025 ShopHub. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }

        function confirmDelete(feedbackId) {
            if(confirm('Are you sure you want to delete this feedback? This action cannot be undone.')) {
                window.location.href = 'feedback-history.jsp?deleteFeedback=' + feedbackId;
            }
        }
    </script>
</body>
</html>