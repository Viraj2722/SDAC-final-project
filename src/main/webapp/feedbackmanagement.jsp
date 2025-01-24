<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="db.GetConnection"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback Management</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

/* Table Styles */
.feedback-table {
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

/* Button Styles */
.btn {
	padding: 0.6rem 1rem;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 500;
	transition: all 0.3s ease;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
}

.feedback-row {
    transition: opacity 0.3s ease;
}

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
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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

.btn-reply {
	background-color: #4834d4;
	color: white;
}

.btn-reply:hover {
	background-color: #3a2bb3;
	transform: translateY(-2px);
}

.btn-delete {
	background-color: #e74c3c;
	color: white;
}

.btn-delete:hover {
	background-color: #c0392b;
	transform: translateY(-2px);
}

/* Modal Styles */
.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.modal-content {
	background-color: white;
	padding: 2rem;
	border-radius: 10px;
	width: 500px;
	max-width: 90%;
}

.modal-content h2 {
	margin-bottom: 1rem;
	color: #333;
}

.modal textarea {
	width: 100%;
	padding: 1rem;
	margin: 1rem 0;
	border: 1px solid #e1e1e1;
	border-radius: 8px;
	min-height: 120px;
	font-size: 0.95rem;
	resize: vertical;
}

.modal-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 1rem;
	margin-top: 1.5rem;
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
		<div class="sidebar">
			<div class="sidebar-header">
				<a class="sidebar-logo"> <i class="fas fa-shield-alt"></i> Admin
					Panel
				</a>
			</div>
			<button class="sidebar-btn"
				onclick="location.href='usermanagement.jsp'">
				<i class="fas fa-users"></i> User Management
			</button>
			<button class="sidebar-btn active"
				onclick="location.href='feedbackmanagement.jsp'">
				<i class="fas fa-comments"></i> Feedback Management
			</button>
			<button class="sidebar-btn " onclick="location.href='productmanagement.jsp'">
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
				<h1 class="page-title">Feedback Management</h1>
				<div class="header-actions">
					<button class="admin-badge mr-2"
						onclick="location.href='DashboardServlet'">
						<i class="fas fa-user-shield"></i> Admin Dashboard
					</button>
					<button class="admin-badge btn-logout"
						onclick="location.href='LogoutServlet'">
						<i class="fas fa-sign-out-alt"></i> Logout
					</button>
				</div>
			</div>

			<!-- Content Container -->
			<div class="content-container">
				<!-- Search Box -->
				<div class="search-container">
					<div class="search-box">
						<i class="fas fa-search"></i>
						<input type="text" id="searchInput" class="search-input" 
							   placeholder="Search feedback..." onkeyup="searchFeedback()">
					</div>
				</div>

				<!-- Feedback Table -->
				<div class="feedback-table">
					<table>
						<thead>
							<tr>
								<th>Feedback ID</th>
								<th>Product ID</th>
								<th>Customer ID</th>
								<th>Comments</th>
								<th>Rating</th>
								<th>Date</th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody id="feedbackTableBody">
							<%
							try {
								Connection con = GetConnection.getConnection();
								String query = "SELECT FeedbackID, ProductID, CustomerID, Comments, Rating, FeedbackDate FROM feedback";
								PreparedStatement ps = con.prepareStatement(query);
								ResultSet rs = ps.executeQuery();

								while (rs.next()) {
									int feedbackId = rs.getInt("FeedbackID");
									int productId = rs.getInt("ProductID");
									int customerId = rs.getInt("CustomerID");
									String comments = rs.getString("Comments");
									int rating = rs.getInt("Rating");
									Timestamp feedbackDate = rs.getTimestamp("FeedbackDate");
							%>
							<tr class="feedback-row" data-feedback-id="<%=feedbackId%>">
								<td><%=feedbackId%></td>
								<td><%=productId%></td>
								<td><%=customerId%></td>
								<td><%=comments%></td>
								<td><%=rating%></td>
								<td><%=feedbackDate%></td>
								<td class="action-column">
									<button onclick="deleteFeedback(<%=feedbackId%>)" class="btn btn-delete">
										<i class="fas fa-trash"></i> Delete
									</button>
								</td>
							</tr>
							<%
							}
							rs.close();
							ps.close();
							con.close();
							} catch (Exception e) {
							e.printStackTrace();
							}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="toast" class="toast"></div>

	<script>
        function searchFeedback() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const tbody = document.getElementById('feedbackTableBody');
            const rows = tbody.getElementsByClassName('feedback-row');

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

        function deleteFeedback(feedbackId) {
            if (confirm('Are you sure you want to delete this feedback?')) {
                fetch('DeleteFeedbackServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'feedbackId=' + feedbackId
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        // Reload the page after successful deletion
                        location.reload();
                    } else {
                        showToast(data.message || 'Error deleting feedback', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Error deleting feedback', 'error');
                });
            }
        }
    </script>
</body>
</html>