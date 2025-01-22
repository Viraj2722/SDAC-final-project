<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
// Check if user is logged in
HttpSession userSession = request.getSession(false);
if (userSession == null || userSession.getAttribute("mailID") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String userEmail = (String) userSession.getAttribute("mailID");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History - ElementStore</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ffffff;
            --accent-color: #5d4de6;
            --bg-gradient: linear-gradient(135deg, #141514 0%, #3f3f3f 100%);
            --card-bg: rgba(255, 255, 255, 0.1);
            --hover-bg: rgba(255, 255, 255, 0.15);
            --border-color: rgba(255, 255, 255, 0.1);
        }

        body {
            background: var(--bg-gradient);
            min-height: 100vh;
            font-family: "Lato", serif;
            font-weight: 400;
            color: var(--primary-color);
            padding-top: 76px;
        }

        /* Navbar Styles */
        .navbar {
            background: rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-color);
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover {
            transform: translateY(-2px);
        }

        .nav-link {
            color: var(--primary-color) !important;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            transform: translateY(-2px);
        }

        /* Table Container Styles */
        .orders-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            margin-top: 2rem;
            animation: fadeInUp 0.6s ease forwards;
        }

        .table {
            color: var(--primary-color);
            margin-bottom: 0;
        }

        .table thead th {
            background: rgba(0, 0, 0, 0.2);
            color: var(--primary-color);
            font-weight: 600;
            border: none;
            padding: 1.2rem 1rem;
        }

        .table tbody td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-weight: 400;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        /* Button Styles */
        .review-btn {
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 8px 25px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .review-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(120deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: 0.5s;
        }

        .review-btn:hover::before {
            left: 100%;
        }

        .review-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(93, 77, 230, 0.4);
        }

        .reviewed-btn {
            background: rgba(46, 204, 113, 0.2) !important;
            color: #2ecc71 !important;
            cursor: default !important;
        }

        .reviewed-btn:hover {
            transform: none !important;
            box-shadow: none !important;
        }

        /* Empty State Styles */
        .empty-state {
            text-align: center;
            padding: 6rem 0;
            animation: fadeInUp 0.6s ease forwards;
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--accent-color);
            margin-bottom: 2rem;
        }

        .empty-state h5 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            font-size: 1.1rem;
        }

        .browse-btn {
            background: var(--accent-color);
            color: white;
            padding: 1rem 3rem;
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .browse-btn:hover {
            background: #4d3fd9;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(93, 77, 230, 0.4);
        }

        /* Page Title */
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            animation: fadeInUp 0.6s ease forwards;
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            animation: fadeInUp 0.6s ease forwards;
            animation-delay: 0.2s;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .orders-container {
                padding: 1rem;
            }
            
            .table thead {
                display: none;
            }
            
            .table tbody td {
                display: block;
                text-align: right;
                padding: 0.75rem;
                border: none;
                position: relative;
            }
            
            .table tbody td::before {
                content: attr(data-label);
                float: left;
                font-weight: 600;
                color: rgba(255, 255, 255, 0.7);
            }
            
            .table tbody tr {
                display: block;
                border-bottom: 1px solid var(--border-color);
                margin-bottom: 1rem;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 8px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg fixed-top">
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
                        <a class="nav-link">
                            <i class="fas fa-user"></i> <%= userEmail %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-danger" href="#" onclick="logout()">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <h1 class="page-title">Order History</h1>
        <p class="page-subtitle">Track your past purchases and leave reviews</p>
        
        <div class="orders-container">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Total Amount</th>
                            <th>Payment Method</th>
                            <th>Order Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        String dbURL = "jdbc:mysql://localhost:3306/erp_system";
                        String dbUser = "root";
                        String dbPassword = "1234";
                        
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                            
                            // First get the customer ID
                            PreparedStatement custStmt = conn.prepareStatement(
                                "SELECT CustomerID FROM customers WHERE Email = ?"
                            );
                            custStmt.setString(1, userEmail);
                            ResultSet custRs = custStmt.executeQuery();
                            
                            if (custRs.next()) {
                                int customerId = custRs.getInt("CustomerID");
                                
                                PreparedStatement orderStmt = conn.prepareStatement(
                                    "SELECT s.*, p.Name, p.Category, p.ProductID, " +
                                    "(SELECT COUNT(*) FROM feedback f WHERE f.ProductID = p.ProductID AND f.CustomerID = ?) as has_feedback " +
                                    "FROM sales s " +
                                    "JOIN products p ON s.ProductID = p.ProductID " +
                                    "WHERE s.CustomerID = ? " +
                                    "ORDER BY s.SaleDate DESC"
                                );
                                orderStmt.setInt(1, customerId);
                                orderStmt.setInt(2, customerId);
                                ResultSet orderRs = orderStmt.executeQuery();
                                
                                boolean hasOrders = false;
                                
                                while (orderRs.next()) {
                                    hasOrders = true;
                                    boolean hasReviewed = orderRs.getInt("has_feedback") > 0;
                        %>
                        <tr>
                            <td><%= orderRs.getInt("SaleID") %></td>
                            <td><%= orderRs.getString("Name") %></td>
                            <td><%= orderRs.getString("Category") %></td>
                            <td><%= orderRs.getInt("Quantity") %></td>
                            <td>$<%= String.format("%.2f", orderRs.getDouble("TotalAmount")) %></td>
                            <td><%= orderRs.getString("PaymentMethod") %></td>
                            <td><%= orderRs.getTimestamp("SaleDate") %></td>
                            <td>
                                <% if (hasReviewed) { %>
                                    <button class="btn review-btn reviewed-btn" disabled>
                                        <i class="fas fa-check me-1"></i> Reviewed
                                    </button>
                                <% } else { %>
                                    <a href="productpage.jsp?productId=<%= orderRs.getInt("ProductID") %>" 
                                       class="btn review-btn">
                                        <i class="fas fa-star me-1"></i> Rate & Review
                                    </a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                                
                                if (!hasOrders) {
                        %>
                        <tr>
                            <td colspan="8">
                                <div class="empty-state">
                                    <i class="fas fa-shopping-cart"></i>
                                    <h5>No orders found</h5>
                                    <p>Start shopping to see your orders here!</p>
                                    <a href="homepage.jsp" class="btn browse-btn">
                                        Browse Products
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                                
                                orderRs.close();
                                orderStmt.close();
                            }
                            
                            custRs.close();
                            custStmt.close();
                            conn.close();
                            
                        } catch(Exception e) {
                            out.println("<tr><td colspan='8' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                        }
                        %>
                    
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }
    </script>
</body>
</html>