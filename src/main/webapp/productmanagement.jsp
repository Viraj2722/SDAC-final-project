<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="db.GetConnection"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Product Management</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body {
	background-color: #f0f2f5;
	color: #1a1a1a;
}

.layout-container {
	display: flex;
	min-height: 100vh;
}

/* Sidebar Styles */
.sidebar {
	width: 280px;
	background-color: white;
	box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
	padding: 2rem 0;
	position: fixed;
	height: 100vh;
	z-index: 100;
}

.sidebar-header {
	padding: 0 1.5rem 2rem 1.5rem;
	border-bottom: 1px solid #eee;
	margin-bottom: 1rem;
}

.sidebar-logo {
	color: #4834d4;
	font-size: 1.5rem;
	font-weight: bold;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.sidebar-btn {
	display: flex;
	align-items: center;
	gap: 0.8rem;
	width: 100%;
	padding: 1rem 1.5rem;
	background: none;
	border: none;
	color: #666;
	text-align: left;
	font-size: 0.95rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
}

.sidebar-btn:hover {
	background-color: #f8f9fa;
	color: #4834d4;
}

.sidebar-btn.active {
	background-color: #4834d4;
	color: white;
	position: relative;
}

.sidebar-btn.active::before {
	content: '';
	position: absolute;
	left: 0;
	top: 0;
	height: 100%;
	width: 4px;
	background-color: #2d1faa;
}

/* Main Content Area */
.main-content {
	flex: 1;
	margin-left: 280px;
	background-color: #f0f2f5;
}

/* Header Area */
.main-header {
	background-color: white;
	padding: 1.5rem 2rem;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.page-title {
	font-size: 1.5rem;
	color: #1a1a1a;
	font-weight: 600;
}

.admin-badge {
	background: #4834d4;
	color: white;
	padding: 0.5rem 1rem;
	border-radius: 20px;
	font-size: 0.9rem;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	cursor: pointer;
	transition: all 0.3s ease;
}

/* Content Container */
.content-container {
	padding: 2rem;
}

/* Search Box */
.search-container {
	background: white;
	padding: 1.5rem;
	border-radius: 10px;
	margin-bottom: 1.5rem;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.search-box {
	display: flex;
	gap: 1rem;
	align-items: center;
	background: #f5f7fb;
	padding: 0.8rem 1rem;
	border-radius: 8px;
	border: 1px solid #e1e1e1;
}

.search-box i {
	color: #666;
}

.search-input {
	border: none;
	background: none;
	width: 100%;
	font-size: 1rem;
	color: #333;
	outline: none;
}

/* Form Styles */
.form-container {
	background: white;
	border-radius: 10px;
	padding: 1.5rem;
	margin-bottom: 1.5rem;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.form-container h3 {
	margin-bottom: 1rem;
	color: #333;
}

.form-group {
	margin-bottom: 1rem;
}

.form-group label {
	display: block;
	margin-bottom: 0.5rem;
	font-weight: 500;
	color: #555;
}

.form-group input {
	width: 100%;
	padding: 0.8rem 1rem;
	border: 1px solid #e1e1e1;
	border-radius: 6px;
	font-size: 0.95rem;
}

.btn-submit {
	background-color: #4834d4;
	color: white;
	padding: 0.8rem 1.5rem;
	border: none;
	border-radius: 6px;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
}

.btn-submit:hover {
	background-color: #3a2bb3;
}

.btn-cancel {
	background-color: #e74c3c;
	color: white;
	padding: 0.8rem 1.5rem;
	border: none;
	border-radius: 6px;
	font-weight: 500;
	cursor: pointer;
	margin-left: 0.5rem;
	transition: all 0.3s ease;
}

.btn-cancel:hover {
	background-color: #c0392b;
}

/* Table Styles */
.product-table {
	background: white;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	background: #f8f9fa;
	padding: 1rem;
	text-align: left;
	font-weight: 600;
	color: #444;
	border-bottom: 2px solid #e1e1e1;
}

td {
	padding: 1rem;
	border-bottom: 1px solid #e1e1e1;
	vertical-align: middle;
}

tr:hover {
	background-color: #f8f9fa;
}

.low-stock {
	background-color: #ffe6e6;
}

/* Button Styles */
.btn {
	padding: 0.4rem 1rem;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 500;
	transition: all 0.3s ease;
	display: inline-flex;
	align-items: center;
	gap: 15px;
}

.btn-update {
	background-color: #4834d4;
	color: white;
	margin-bottom:3px
}

.btn-update:hover {
	background-color: #3a2bb3;
	transform: translateY(-2px);
}

.btn-delete {
	background-color: #e74c3c;
	color: white;
	width:104px;
}

.btn-delete:hover {
	background-color: #c0392b;
	transform: translateY(-2px);
}

/* Toast Notifications */
.toast {
	position: fixed;
	top: 20px;
	right: 20px;
	padding: 1rem 1.5rem;
	border-radius: 8px;
	color: white;
	opacity: 0;
	transition: opacity 0.3s ease;
	z-index: 1000;
}

.toast.success {
	background-color: #2ecc71;
}

.toast.error {
	background-color: #e74c3c;
}

.toast.show {
	opacity: 1;
}

.header-actions {
    display: flex;
    align-items: center;
    gap: 0.8rem;
}

.btn-logout {
    background-color: #e74c3c;
}

.btn-logout:hover {
    background-color: #c0392b;
}

@media ( max-width : 768px) {
	.sidebar {
		width: 0;
		transform: translateX(-100%);
	}
	.main-content {
		margin-left: 0;
	}
	.content-container {
		padding: 1rem;
	}
}
</style>
</head>
<body>
	<div class="layout-container">
		<!-- Sidebar -->
		<div class="sidebar">
			<div class="sidebar-header">
				<a class="sidebar-logo"> <i class="fas fa-shield-alt"></i> Admin
					Panel
				</a>
			</div>
			<button class="sidebar-btn"
				onclick="location.href='DashboardServlet'">
				<i class="fas fa-chart-pie"></i> Dashboard
			</button>
			<button class="sidebar-btn"
				onclick="location.href='usermanagement.jsp'">
				<i class="fas fa-users"></i> User Management
			</button>
			<button class="sidebar-btn"
				onclick="location.href='feedbackmanagement.jsp'">
				<i class="fas fa-comments"></i> Feedback Management
			</button>
			<button class="sidebar-btn active">
				<i class="fas fa-box"></i> Product Management
			</button>
			<a class="sidebar-btn" onclick="location.href='algomonitoring.jsp'">
				<i class="fas fa-chart-line"></i> Algorithm Monitoring
			</a> <a class="sidebar-btn" onclick="location.href='ReportServlet'">
				<i class="fas fa-file-download"></i> Report Generation
			</a>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<!-- Main Header -->
			<div class="main-header">
				<h1 class="page-title">Product Management</h1>
				<button class="admin-badge btn-logout"
						onclick="location.href='LogoutServlet'">
						<i class="fas fa-sign-out-alt"></i> Logout
					</button>
			</div>

			<!-- Content Container -->
			<div class="content-container">
				<!-- Search Box -->
				<div class="search-container">
					<div class="search-box">
						<i class="fas fa-search"></i> <input type="text" id="searchInput"
							class="search-input" placeholder="Search products..."
							onkeyup="searchProducts()">
					</div>
				</div>

				<!-- Add Product Form -->
				<div class="form-container">
					<h3>Add New Product</h3>
					<form id="addProductForm" onsubmit="return handleAddProduct(event)">
						<div class="form-group">
							<label for="name">Product Name</label> <input type="text"
								id="name" name="name" required>
						</div>

						<div class="form-group">
							<label for="category">Category</label> <input type="text"
								id="category" name="category" required>
						</div>

						<div class="form-group">
							<label for="cost">Cost Price ($)</label> <input type="number"
								id="cost" name="cost" step="0.01" min="0" required>
						</div>

						<div class="form-group">
							<label for="sellingPrice">Selling Price ($)</label> <input
								type="number" id="sellingPrice" name="sellingPrice" step="0.01"
								min="0" required>
						</div>

						<div class="form-group">
							<label for="stock">Initial Stock</label> <input type="number"
								id="stock" name="stock" min="0" required>
						</div>

						<div class="form-group">
							<label for="reorderLevel">Reorder Level</label> <input
								type="number" id="reorderLevel" name="reorderLevel" min="0"
								required>
						</div>

						<div class="form-group">
							<label for="supplierInfo">Supplier Information</label> <input
								type="text" id="supplierInfo" name="supplierInfo" required>
						</div>

						<div class="form-group">
							<label for="expiryDate">Expiry Date</label> <input type="date"
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
							<label for="updateName">Product Name</label> <input type="text"
								id="updateName" name="name" required>
						</div>

						<div class="form-group">
							<label for="updateCategory">Category</label> <input type="text"
								id="updateCategory" name="category" required>
						</div>

						<div class="form-group">
							<label for="updateCost">Cost Price ($)</label> <input
								type="number" id="updateCost" name="cost" step="0.01" min="0"
								required>
						</div>

						<div class="form-group">
							<label for="updateSellingPrice">Selling Price ($)</label> <input
								type="number" id="updateSellingPrice" name="sellingPrice"
								step="0.01" min="0" required>
						</div>

						<div class="form-group">
							<label for="updateStock">Stock</label> <input type="number"
								id="updateStock" name="stock" min="0" required>
						</div>

						<div class="form-group">
							<label for="updateReorderLevel">Reorder Level</label> <input
								type="number" id="updateReorderLevel" name="reorderLevel"
								min="0" required>
						</div>

						<div class="form-group">
							<label for="updateSupplierInfo">Supplier Information</label> <input
								type="text" id="updateSupplierInfo" name="supplierInfo" required>
						</div>

						<div class="form-group">
							<label for="updateExpiryDate">Expiry Date</label> <input
								type="date" id="updateExpiryDate" name="expiryDate">
						</div>

						<button type="submit" class="btn-submit">Update Product</button>
						<button type="button" class="btn-cancel"
							onclick="hideUpdateForm()">Cancel</button>
					</form>
				</div>

				<div class="product-table">
					<table>
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
								<th>Supplier Info</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody id="productTableBody">
							<%
							try {
								Connection conn = GetConnection.getConnection();
								Statement stmt = conn.createStatement();
								String sql = "SELECT * FROM products";
								ResultSet rs = stmt.executeQuery(sql);

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
							<tr class="<%=rowClass%>" data-product-id="<%=productId%>">
								<td><%=productId%></td>
								<td><%=name%></td>
								<td><%=category%></td>
								<td>$<%=String.format("%.2f", cost)%></td>
								<td>$<%=String.format("%.2f", sellingPrice)%></td>
								<td><%=stock%></td>
								<td><%=salesData%></td>
								<td><%=reorderLevel%></td>
								<td><%=supplierInfo%></td>
								<td>
									<button class="btn btn-update"
										onclick="showUpdateForm(<%=productId%>, '<%=name%>', '<%=category%>', <%=cost%>, <%=sellingPrice%>, <%=stock%>, <%=reorderLevel%>, '<%=supplierInfo%>', '<%=expiryDate != null ? expiryDate.toString() : ""%>')">
										<i class="fas fa-edit"></i> Update
									</button>
									<button class="btn btn-delete"
										onclick="deleteProduct(<%=productId%>)">
										<i class="fas fa-trash"></i> Delete
									</button>
								</td>
							</tr>
							<%
							}
							rs.close();
							stmt.close();
							conn.close();
							} catch (Exception e) {
							e.printStackTrace();
							}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div id="toast" class="toast"></div>

		<script>
            function searchProducts() {
                const input = document.getElementById('searchInput');
                const filter = input.value.toLowerCase();
                const tbody = document.getElementById('productTableBody');
                const rows = tbody.getElementsByTagName('tr');

                for (let row of rows) {
                    const text = row.textContent.toLowerCase();
                    row.style.display = text.includes(filter) ? '' : 'none';
                }
            }

            function showToast(message, type) {
                const toast = document.getElementById('toast');
                toast.textContent = message;
                toast.className = `toast ${type} show`;
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }

            // Existing product management functions from previous implementation
            function deleteProduct(productId) {
                if (confirm('Are you sure you want to delete this product?')) {
                    fetch('ProductServlet?action=delete&id=' + productId, {
                        method: 'POST'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const row = document.querySelector(`tr[data-product-id="${productId}"]`);
                            if (row) {
                                row.style.transition = 'opacity 0.3s ease';
                                row.style.opacity = '0';
                                setTimeout(() => row.remove(), 300);
                            }
                            showToast('Product deleted successfully', 'success');
                        } else {
                            showToast('Error deleting product', 'error');
                        }
                    });
                }
            }

            function showUpdateForm(productId, name, category, cost, sellingPrice, stock, reorderLevel, supplierInfo, expiryDate) {
                document.getElementById('updateProductId').value = productId;
                document.getElementById('updateName').value = name;
                document.getElementById('updateCategory').value = category;
                document.getElementById('updateCost').value = cost;
                document.getElementById('updateSellingPrice').value = sellingPrice;
                document.getElementById('updateStock').value = stock;
                document.getElementById('updateReorderLevel').value = reorderLevel;
                document.getElementById('updateSupplierInfo').value = supplierInfo;
                document.getElementById('updateExpiryDate').value = expiryDate;
                
                document.getElementById('updateFormContainer').style.display = 'block';
                document.getElementById('updateFormContainer').scrollIntoView({ behavior: 'smooth' });
            }

            function hideUpdateForm() {
                document.getElementById('updateFormContainer').style.display = 'none';
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
                        showToast('Product added successfully!', 'success');
                        document.getElementById('addProductForm').reset();
                        location.reload();
                    } else {
                        showToast('Error: ' + result.message, 'error');
                    }
                })
                .catch(error => {
                    showToast('Error: ' + error.message, 'error');
                });
                
                return false;
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
                        showToast('Product updated successfully!', 'success');
                        hideUpdateForm();
                        location.reload();
                    } else {
                        showToast('Error: ' + result.message, 'error');
                    }
                })
                .catch(error => {
                    showToast('Error: ' + error.message, 'error');
                });
                
                return false;
            }
        </script>
</body>
</html>