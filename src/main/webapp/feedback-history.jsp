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
    String dbURL = "jdbc:mysql://localhost:3306/grp_sdac";
    String dbUser = "root";
    String dbPassword = "";
    
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
    <title>My Feedback History - ElementStore</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #171717;
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        
        .navbar {
            background-color: #000000 !important;
            padding: 1rem 0;
            border-bottom: none;
        }
        
        .navbar-brand {
            color: #ffffff !important;
            font-weight: 600;
            font-size: 1.25rem;
        }
        
        .nav-link {
            color: #ffffff !important;
            font-weight: 400;
            padding: 0.5rem 1rem;
        }
        
        .page-title {
            background-color: #222222;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .page-title h1 {
            color: #ffffff;
            font-size: 2rem;
            font-weight: 400;
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .page-title i {
            margin-right: 1rem;
            font-size: 1.75rem;
        }
        
        .feedback-card {
            background-color: #2d2d2d;
            border: none;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            padding: 1.5rem;
        }
        
        .star-rating {
            color: #ffd700;
            font-size: 1.25rem;
            margin-bottom: 1rem;
        }
        
        .product-title {
            color: #ffffff;
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
        }
        
        .timestamp {
            color: #888888;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .btn-view {
            background-color: transparent;
            border: 1px solid #00a8e8;
            color: #00a8e8;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .btn-view:hover {
            background-color: #00a8e8;
            color: #ffffff;
        }
        
        .btn-delete {
            background-color: transparent;
            border: 1px solid #ff4444;
            color: #ff4444;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        .btn-delete:hover {
            background-color: #ff4444;
            color: #ffffff;
        }
        
        .footer {
            background-color: #000000;
            padding: 2rem 0;
            margin-top: auto;
        }
        
        .footer-brand {
            color: #ffffff;
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .footer-text {
            color: #888888;
        }
        
        .copyright {
            color: #888888;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#">ElementStore</a>
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
                        <span class="nav-link">
                            Welcome, <%= userEmail %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="Cart">
                            <i class="fas fa-shopping-cart"></i> Cart
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link logout-btn" href="#" onclick="logout()">
                            Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h2><i class="fas fa-comments me-2"></i>My Feedback History</h2>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container my-5">
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
                        %>
                        <div class="col-12">
                            <div class="alert alert-info" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                You haven't provided any feedback yet. When you rate products, they will appear here!
                            </div>
                        </div>
                        <%
                    }
                    
                    while (rs.next()) {
                        %>
                         <div class="col-md-4">
                    <div class="feedback-card">
                        <h3 class="product-title"><%= rs.getString("ProductName") %></h3>
                        <div class="star-rating">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star <%= i <= rs.getInt("Rating") ? "" : "text-secondary" %>"></i>
                            <% } %>
                        </div>
                        <div class="timestamp">
                            <i class="far fa-clock"></i> <%= rs.getTimestamp("FeedbackDate") %>
                        </div>
                        <div class="d-flex justify-content-between">
                            <a href="productpage.jsp?productId=<%= rs.getInt("ProductID") %>" 
                               class="btn-view">
                                <i class="fas fa-external-link-alt"></i> View Product
                            </a>
                            <button onclick="confirmDelete(<%= rs.getInt("FeedbackID") %>)" 
                                    class="btn-delete">
                                <i class="fas fa-trash-alt"></i> Delete
                            </button>
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
    <footer class="footer py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <h5 class="text-white">ElementStore</h5>
                    <p class="mb-0 text-muted">Your premium electronics destination.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <p class="mb-0 text-muted">&copy; 2025 ElementStore. All rights reserved.</p>
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