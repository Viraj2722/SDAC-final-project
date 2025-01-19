<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Product Management</title>
<style>
/* General Styles */
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
}

.container {
	padding: 20px;
	margin-left: 220px; /* Space for sidebar */
}

h2 {
	margin-top: 0;
}

/* Sidebar Navigation */
.sidebar {
	width: 200px;
	height: 100vh;
	position: fixed;
	top: 0;
	left: 0;
	background-color: #2c3e50;
	padding: 10px 0;
	color: white;
}

.sidebar a {
	display: block;
	color: white;
	text-decoration: none;
	padding: 10px 20px;
	margin: 5px 0;
}

.sidebar a:hover, .sidebar a.active {
	background-color: #34495e;
}

/* Table Styles */
.product-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	font-size: 14px;
}

.product-table th, .product-table td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

.product-table th {
	background-color: #f4f4f4;
	position: sticky;
	top: 0;
}

.low-stock {
	background-color: #ffe6e6;
}

.table-container {
	max-height: 80vh;
	overflow-y: auto;
}

/* Action Buttons */
.action-button {
	padding: 5px 10px;
	margin: 2px;
	border: none;
	border-radius: 3px;
	cursor: pointer;
}

.delete-btn {
	background-color: #ff4444;
	color: white;
}

.reply-btn {
	background-color: #44b;
	color: white;
}

.update-btn {
	background-color: #4CAF50;
	color: white;
}

/* Form Styles */
.form-container {
	background-color: #f9f9f9;
	padding: 20px;
	border-radius: 5px;
	margin-bottom: 20px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input, .form-group select {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

.btn-submit {
	background-color: #2c3e50;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.btn-submit:hover {
	background-color: #34495e;
}

.btn-cancel {
	background-color: #6c757d;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	margin-left: 10px;
}

.btn-cancel:hover {
	background-color: #5a6268;
}

.message {
	padding: 10px;
	margin: 10px 0;
	border-radius: 4px;
}

.success {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.error {
	background-color: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}
</style>
</head>
<body>
	<!-- Sidebar Navigation -->
	<div class="sidebar">
		<a href="adminPanel.jsp"><h3 style="text-align: center;">Admin
				Panel</h3></a> <a href="usermanagement.jsp">User Management</a> <a
			href="feedbackmanagement.jsp">Feedback Management</a> <a
			href="productmanagement.jsp" class="active">Product Management</a> 
			<a class="sidebar-btn" onclick="location.href='algomonitoring.jsp'">
			<i class="fas fa-chart-line"></i> Algorithm Monitoring
		</a> <a class="sidebar-btn" onclick="location.href='ReportServlet'"> <i
			class="fas fa-file-download"></i> Report Generation
		</a>

	</div>

	<!-- Main Content -->
	<div class="container">
		<h2>Product Management</h2>

		<!-- Add Product Form -->
		<div class="form-container">
			<h3>Add New Product</h3>
			<form id="addProductForm" onsubmit="return handleAddProduct(event)">
				<div class="form-group">
					<label for="name">Product Name:</label> <input type="text"
						id="name" name="name" required>
				</div>

				<div class="form-group">
					<label for="category">Category:</label> <input type="text"
						id="category" name="category" required>
				</div>

				<div class="form-group">
					<label for="cost">Cost Price ($):</label> <input type="number"
						id="cost" name="cost" step="0.01" min="0" required>
				</div>

				<div class="form-group">
					<label for="sellingPrice">Selling Price ($):</label> <input
						type="number" id="sellingPrice" name="sellingPrice" step="0.01"
						min="0" required>
				</div>

				<div class="form-group">
					<label for="stock">Initial Stock:</label> <input type="number"
						id="stock" name="stock" min="0" required>
				</div>

				<div class="form-group">
					<label for="reorderLevel">Reorder Level:</label> <input
						type="number" id="reorderLevel" name="reorderLevel" min="0"
						required>
				</div>

				<div class="form-group">
					<label for="supplierInfo">Supplier Information:</label> <input
						type="text" id="supplierInfo" name="supplierInfo" required>
				</div>

				<div class="form-group">
					<label for="expiryDate">Expiry Date:</label> <input type="date"
						id="expiryDate" name="expiryDate">
				</div>

				<button type="submit" class="btn-submit">Add Product</button>
			</form>
		</div>

		<!-- Update Product Form (Initially Hidden) -->
		<div id="updateFormContainer" class="form-container"
			style="display: none;">
			<h3>Update Product</h3>
			<form id="updateProductForm"
				onsubmit="return handleUpdateProduct(event)">
				<input type="hidden" id="updateProductId" name="productId">

				<div class="form-group">
					<label for="updateName">Product Name:</label> <input type="text"
						id="updateName" name="name" required>
				</div>

				<div class="form-group">
					<label for="updateCategory">Category:</label> <input type="text"
						id="updateCategory" name="category" required>
				</div>

				<div class="form-group">
					<label for="updateCost">Cost Price ($):</label> <input
						type="number" id="updateCost" name="cost" step="0.01" min="0"
						required>
				</div>

				<div class="form-group">
					<label for="updateSellingPrice">Selling Price ($):</label> <input
						type="number" id="updateSellingPrice" name="sellingPrice"
						step="0.01" min="0" required>
				</div>

				<div class="form-group">
					<label for="updateStock">Stock:</label> <input type="number"
						id="updateStock" name="stock" min="0" required>
				</div>

				<div class="form-group">
					<label for="updateReorderLevel">Reorder Level:</label> <input
						type="number" id="updateReorderLevel" name="reorderLevel" min="0"
						required>
				</div>

				<div class="form-group">
					<label for="updateSupplierInfo">Supplier Information:</label> <input
						type="text" id="updateSupplierInfo" name="supplierInfo" required>
				</div>

				<div class="form-group">
					<label for="updateExpiryDate">Expiry Date:</label> <input
						type="date" id="updateExpiryDate" name="expiryDate">
				</div>

				<button type="submit" class="btn-submit">Update Product</button>
				<button type="button" class="btn-cancel" onclick="hideUpdateForm()">Cancel</button>
			</form>
		</div>

		<div class="table-container">
			<table class="product-table">
				<thead>
					<tr>
						<th>Product ID</th>
						<th>Name</th>
						<th>Category</th>
						<th>Cost Price</th>
						<th>Selling Price</th>
						<th>Stock</th>
						<th>Sales Data</th>
						<th>Reorder Level</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<%
					// Connect to the database
					Connection conn = null;
					Statement stmt = null;
					ResultSet rs = null;

					try {
						Class.forName("com.mysql.cj.jdbc.Driver");
						conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/erp_system", "root", "1234");
						stmt = conn.createStatement();
						String sql = "SELECT * FROM products";
						rs = stmt.executeQuery(sql);

						while (rs.next()) {
							int productId = rs.getInt("ProductID");
							String name = rs.getString("Name");
							String category = rs.getString("Category");
							double cost = rs.getDouble("Cost");
							double sellingPrice = rs.getDouble("SellingPrice");
							int stock = rs.getInt("Stock");
							int salesData = rs.getInt("SalesData");
							int reorderLevel = rs.getInt("ReorderLevel");
							String supplierInfo = rs.getString("SupplierInfo");
							Date expiryDate = rs.getDate("ExpiryDate");

							String rowClass = stock <= reorderLevel ? "low-stock" : "";
					%>
					<tr class="<%=rowClass%>">
						<td><%=productId%></td>
						<td><%=name%></td>
						<td><%=category%></td>
						<td>$<%=cost%></td>
						<td>$<%=sellingPrice%></td>
						<td><%=stock%></td>
						<td><%=salesData%></td>
						<td><%=reorderLevel%></td>
						<td>
							<button class="action-button update-btn"
								onclick="showUpdateForm(<%=productId%>, '<%=name%>', '<%=category%>', <%=cost%>, <%=sellingPrice%>, <%=stock%>, <%=reorderLevel%>, '<%=supplierInfo%>', '<%=expiryDate != null ? expiryDate.toString() : ""%>')">Update</button>
							<button class="action-button delete-btn"
								onclick="deleteProduct(<%=productId%>)">Delete</button>
						</td>

						<%
						}
						} catch (Exception e) {
						e.printStackTrace();
						} finally {
						if (rs != null)
						rs.close();
						if (stmt != null)
						stmt.close();
						if (conn != null)
						conn.close();
						}
						%>
					
				</tbody>
			</table>
		</div>
	</div>

	<script>
        function deleteProduct(productId) {
            if (confirm('Are you sure you want to delete this product?')) {
                fetch('ProductServlet?action=delete&id=' + productId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Error deleting product');
                    }
                });
            }
        }

        function showReplyForm(productId) {
            const form = document.getElementById('replyForm' + productId);
            form.style.display = form.style.display === 'none' ? 'table-row' : 'none';
        }

        function handleAddProduct(event) {
            event.preventDefault();
            
            const formData = new FormData(event.target);
            const data = new URLSearchParams(formData);
            
            fetch('ProductServlet?action=add', {
                method: 'POST',
                body: data
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    showMessage('Product added successfully!', 'success');
                    document.getElementById('addProductForm').reset();
                    location.reload(); // Refresh to show new product
                } else {
                    showMessage('Error: ' + result.message, 'error');
                }
            })
            .catch(error => {
                showMessage('Error: ' + error.message, 'error');
            });
            
            return false;
        }

        function showUpdateForm(productId, name, category, cost, sellingPrice, stock, reorderLevel, supplierInfo, expiryDate) {
            // Populate the form with current values
            document.getElementById('updateProductId').value = productId;
            document.getElementById('updateName').value = name;
            document.getElementById('updateCategory').value = category;
            document.getElementById('updateCost').value = cost;
            document.getElementById('updateSellingPrice').value = sellingPrice;
            document.getElementById('updateStock').value = stock;
            document.getElementById('updateReorderLevel').value = reorderLevel;
            document.getElementById('updateSupplierInfo').value = supplierInfo;
            document.getElementById('updateExpiryDate').value = expiryDate;
            
            // Show the update form
            document.getElementById('updateFormContainer').style.display = 'block';
            
            // Scroll to the update form
            document.getElementById('updateFormContainer').scrollIntoView({ behavior: 'smooth' });
        }

        function hideUpdateForm() {
            document.getElementById('updateFormContainer').style.display = 'none';
        }

        function handleUpdateProduct(event) {
            event.preventDefault();
            
            const formData = new FormData(event.target);
            const data = new URLSearchParams(formData);
            
            fetch('ProductServlet?action=update', {
                method: 'POST',
                body: data
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    showMessage('Product updated successfully!', 'success');
                    hideUpdateForm();
                    location.reload(); // Refresh to show updated product
                } else {
                    showMessage('Error: ' + result.message, 'error');
                }
            })
            .catch(error => {
                showMessage('Error: ' + error.message, 'error');
            });
            
            return false;
        }
        
        function showMessage(message, type) {
            const messageDiv = document.createElement('div');
            messageDiv.className = message ${type};
            messageDiv.textContent = message;
            
            const form = document.getElementById('addProductForm');
            form.parentNode.insertBefore(messageDiv, form);
            
            // Remove message after 5 seconds
            setTimeout(() => {
                messageDiv.remove();
            }, 5000);
        }
    </script>
</body>
</html>