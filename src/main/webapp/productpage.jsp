<%@ page import="java.sql.*, java.util.*"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Details</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
.star-rating {
	color: #cbd5e0;
	cursor: pointer;
}

.star-rating.selected {
	color: #fbbf24;
}

.error-message {
	color: #ef4444;
	margin-top: 0.5rem;
	font-size: 0.875rem;
}

.success-message {
	color: #10b981;
	margin-top: 0.5rem;
	font-size: 0.875rem;
}
</style>
</head>
<body class="bg-gray-50">
	<div class="container mx-auto px-4 py-8 max-w-4xl">
		<%
		// Database connection setup
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String dbUrl = "jdbc:mysql://localhost:3306/erp_system";
		String dbUser = "root";
		String dbPass = "1234";

		String errorMessage = "";
		String successMessage = "";

		// Get productId from URL parameter
		String productId = request.getParameter("productId");
		Integer productIdInt = null;

		try {
			if (productId != null && !productId.trim().isEmpty()) {
				productIdInt = Integer.parseInt(productId.trim());
			} else {
				errorMessage = "Product ID is required.";
			}
		} catch (NumberFormatException e) {
			errorMessage = "Invalid Product ID format.";
		}

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

			// Only proceed with database operations if we have a valid productId
			if (productIdInt != null) {
				// Product info section
				String productQuery = "SELECT * FROM products WHERE ProductID = ?";
				ps = conn.prepareStatement(productQuery);
				ps.setInt(1, productIdInt);
				rs = ps.executeQuery();

				if (rs.next()) {
		%>
		<!-- Product Details Card -->
		<div class="bg-white rounded-lg shadow-lg p-6 mb-8">
			<h1 class="text-3xl font-bold text-gray-900 mb-4"><%=rs.getString("Name")%></h1>

			<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
				<div>
					<p class="text-gray-600 mb-2">Category</p>
					<p class="text-gray-900 font-medium"><%=rs.getString("Category")%></p>
				</div>

				<div>
					<p class="text-gray-600 mb-2">Price</p>
					<p class="text-gray-900 font-medium">
						$<%=rs.getDouble("SellingPrice")%></p>
				</div>

				<div>
					<p class="text-gray-600 mb-2">Stock</p>
					<p class="text-gray-900 font-medium"><%=rs.getInt("Stock")%>
						units
					</p>
				</div>

				<div>
					<p class="text-gray-600 mb-2">Supplier</p>
					<p class="text-gray-900 font-medium"><%=rs.getString("SupplierInfo")%></p>
				</div>
			</div>
		</div>
		<%
		} else {
		errorMessage = "Product not found.";
		}
		if (rs != null)
		rs.close();
		if (ps != null)
		ps.close();

		// Inside the feedback submission handling section, after getting the comments and rating
		if ("POST".equalsIgnoreCase(request.getMethod())) {
		String comments = request.getParameter("comments");
		String ratingStr = request.getParameter("rating");

		// Get email from session
		HttpSession userSession = request.getSession();
		String userEmail = (String) userSession.getAttribute("mailID");

		if (comments != null && ratingStr != null) {
			try {
				if (userEmail == null) {
			errorMessage = "Please login to submit a review.";
				} else if (comments.trim().isEmpty()) {
			errorMessage = "Feedback comments cannot be empty.";
				} else if (ratingStr.trim().isEmpty()) {
			errorMessage = "Rating is required.";
				} else {
			int rating = Integer.parseInt(ratingStr);
			if (rating < 1 || rating > 5) {
				errorMessage = "Rating must be between 1 and 5.";
			} else {
				// First get the CustomerID using the email
				String customerQuery = "SELECT CustomerID FROM customers WHERE Email = ?";
				ps = conn.prepareStatement(customerQuery);
				ps.setString(1, userEmail);
				rs = ps.executeQuery();

				if (rs.next()) {
					int customerId = rs.getInt("CustomerID");

					// Close the previous PreparedStatement and ResultSet
					if (rs != null)
						rs.close();
					if (ps != null)
						ps.close();

					// Now insert the feedback with the customer ID
					String insertFeedbackQuery = "INSERT INTO feedback (ProductID, CustomerID, Comments, Rating, FeedbackDate) "
							+ "VALUES (?, ?, ?, ?, NOW())";
					ps = conn.prepareStatement(insertFeedbackQuery);
					ps.setInt(1, productIdInt);
					ps.setInt(2, customerId);
					ps.setString(3, comments.trim());
					ps.setInt(4, rating);

					int result = ps.executeUpdate();
					if (result > 0) {
						successMessage = "Thank you for your feedback!";
						response.sendRedirect("productpage.jsp?productId=" + productIdInt + "&success=true");
						return;
					} else {
						errorMessage = "Failed to submit feedback.";
					}
				} else {
					errorMessage = "Customer information not found.";
				}
			}
				}
			} catch (NumberFormatException e) {
				errorMessage = "Invalid rating format.";
			} catch (SQLException e) {
				e.printStackTrace();
				errorMessage = "Database error occurred.";
			}
			if (ps != null)
				ps.close();
			if (rs != null)
				rs.close();
		}
		}
		%>

		<!-- Feedback Display Section -->
<div class="bg-white rounded-lg shadow-lg p-6 mb-8">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">Customer Reviews</h2>

    <%
    // Modified query to join with customers table to get customer name
    String feedbackQuery = 
        "SELECT f.*, c.Name " +
        "FROM feedback f " +
        "JOIN customers c ON f.CustomerID = c.CustomerID " +
        "WHERE f.ProductID = ? " +
        "ORDER BY f.FeedbackDate DESC";
    ps = conn.prepareStatement(feedbackQuery);
    ps.setInt(1, productIdInt);
    rs = ps.executeQuery();

    boolean hasFeedback = false;

    while (rs.next()) {
        hasFeedback = true;
        int rating = rs.getInt("Rating");
        String feedbackComments = rs.getString("Comments");
        Timestamp feedbackDate = rs.getTimestamp("FeedbackDate");
        String customerName = rs.getString("Name");
    %>
    <div class="border-b border-gray-200 pb-6 mb-6 last:border-0 last:pb-0 last:mb-0">
        <div class="flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900"><%=customerName%></h3>
            <div class="flex items-center space-x-1">
                <%
                for (int i = 1; i <= 5; i++) {
                %>
                <span class="star-rating <%=i <= rating ? "selected" : ""%>">&#9733;</span>
                <%
                }
                %>
            </div>
        </div>
        <p class="text-gray-700 mt-2"><%=feedbackComments%></p>
        <p class="text-gray-500 text-sm mt-2"><%=feedbackDate%></p>
    </div>
    <%
    }

    if (!hasFeedback) {
    %>
    <div class="text-center py-8 text-gray-500">
        <p>No reviews yet. Be the first to review this product!</p>
    </div>
    <%
    }
    %>
</div>

		<!-- Feedback Form -->
		<div class="bg-white rounded-lg shadow-lg p-6">
			<%
			String userEmail = (String) session.getAttribute("mailID");
			if (userEmail == null) {
			%>
			<div class="text-center py-4">
				<p class="text-gray-600">
					Please <a href="login.jsp" class="text-blue-600 hover:underline">login</a>
					to submit a review.
				</p>
			</div>
			<%
			} else {
			%>
			<%
			if (!errorMessage.isEmpty()) {
			%>
			<div class="error-message">
				<%=errorMessage%>
			</div>
			<%
			}
			%>
			<%
			if (!successMessage.isEmpty()) {
			%>
			<div class="success-message">
				<%=successMessage%>
			</div>
			<%
			}
			%>

			<h3 class="text-2xl font-bold text-gray-900 mb-4">Leave a Review</h3>
			<form method="post"
				action="productpage.jsp?productId=<%=productIdInt%>"
				class="space-y-4">
				<input type="hidden" name="productId" value="<%=productIdInt%>">
				<textarea name="comments" rows="4"
					class="w-full p-3 border border-gray-300 rounded-lg"
					placeholder="Write your review here..." required></textarea>
				<div class="flex items-center space-x-2">
					<label for="rating" class="text-gray-600">Rating:</label> <select
						name="rating" id="rating"
						class="p-2 border border-gray-300 rounded-lg" required>
						<option value="">Select Rating</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
					</select>
				</div>
				<button type="submit"
					class="w-full bg-green-600 text-white py-3 px-6 rounded-lg hover:bg-green-700 transition duration-200">
					Submit Review</button>
			</form>
			<%
			}
			%>
		</div>
		<%
		} else {
		// Show error if no valid productId
		%>
		<div class="bg-white rounded-lg shadow-lg p-6">
			<div class="error-message"><%=errorMessage%></div>
		</div>
		<%
		}
		} catch (Exception e) {
		e.printStackTrace();
		errorMessage = "An error occurred while processing the request. Please try again later.";
		} finally {
		try {
		if (rs != null)
			rs.close();
		if (ps != null)
			ps.close();
		if (conn != null)
			conn.close();
		} catch (SQLException e) {
		e.printStackTrace();
		}
		}
		%>
	</div>

	<script>
		// Refresh the page after successful feedback submission to show the new review
	<%if (!successMessage.isEmpty()) {%>
		setTimeout(function() {
			window.location.reload();
		}, 2000);
	<%}%>
		
	</script>
</body>
</html>