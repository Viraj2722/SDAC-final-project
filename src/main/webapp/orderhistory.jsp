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
    <title>Order History - ShopHub</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">    
<style>
                .order-card {
            transition: transform 0.2s;
        }
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.85rem;
            padding: 0.35em 0.65em;
        }
        .table-responsive {
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .logout-btn {
            color: #ff6b6b !important;
            transition: color 0.3s ease;
        }
        .logout-btn:hover {
            color: #ff4757 !important;
        }
        .review-btn {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        .review-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .reviewed-btn {
            background-color: #198754 !important;
            border-color: #198754 !important;
            cursor: default !important;
        }
        .reviewed-btn:hover {
            transform: none !important;
            box-shadow: none !important;
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
                        <a class="nav-link logout-btn" href="login.jsp" onclick="logout()">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <h2 class="mb-4">Order History</h2>
        
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-dark">
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
                            
                            // Modified query to include feedback check
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
                                            <button class="btn btn-primary review-btn reviewed-btn" disabled>
                                                <i class="fas fa-check me-1"></i>
                                                Reviewed
                                            </button>
                                        <% } else { %>
                                            <a href="productpage.jsp?productId=<%= orderRs.getInt("ProductID") %>" 
                                               class="btn btn-primary review-btn">
                                                <i class="fas fa-star me-1"></i>
                                                Rate & Review
                                            </a>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                            }
                            
 if (!hasOrders) {
                                %>
                                <tr>
                                    <td colspan="8" class="text-center py-4">
                                        <div class="text-muted">
                                            <i class="fas fa-shopping-cart fa-3x mb-3"></i>
                                            <h5>No orders found</h5>
                                            <p>Start shopping to see your orders here!</p>
                                            <a href="homepage.jsp" class="btn btn-primary mt-2">
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


<!-- Footer -->
	<footer class="bg-dark text-light py-4">
		<div class="container">
			<div class="row">
				<div class="col-md-3">
					<h5>About Us</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light text-decoration-none">About
								ShopHub</a></li>
						<li><a href="#" class="text-light text-decoration-none">Careers</a></li>
						<li><a href="#" class="text-light text-decoration-none">Press
								Releases</a></li>
					</ul>
				</div>
				<div class="col-md-3">
					<h5>Customer Service</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light text-decoration-none">Contact
								Us</a></li>
						<li><a href="#" class="text-light text-decoration-none">Returns</a></li>
						<li><a href="#" class="text-light text-decoration-none">Shipping
								Info</a></li>
					</ul>
				</div>
				<div class="col-md-3">
					<h5>Payment Methods</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light text-decoration-none">Credit
								Cards</a></li>
						<li><a href="#" class="text-light text-decoration-none">Debit
								Cards</a></li>
						<li><a href="#" class="text-light text-decoration-none">Net
								Banking</a></li>
					</ul>
				</div>
				<div class="col-md-3">
					<h5>Connect With Us</h5>
					<div class="d-flex gap-3">
						<a href="#" class="text-light"><i
							class="fab fa-facebook fa-lg"></i></a> <a href="#" class="text-light"><i
							class="fab fa-twitter fa-lg"></i></a> <a href="#" class="text-light"><i
							class="fab fa-instagram fa-lg"></i></a>
					</div>
				</div>
			</div>
			<hr class="my-4">
			<div class="text-center">
				<p class="mb-0">&copy; 2025 ShopHub. All rights reserved.</p>
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
    </script></body>
</html>