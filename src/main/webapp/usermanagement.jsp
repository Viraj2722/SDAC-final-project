<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="db.GetConnection"%>
<%
    // Check if user is logged in and is admin
    HttpSession userSession = request.getSession(false);
    if(userSession == null || userSession.getAttribute("role") == null || 
       !userSession.getAttribute("role").toString().equalsIgnoreCase("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Management</title>
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
	cursor:pointer;
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
.user-table {
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

.btn-active {
	background-color: #2ecc71;
	color: white;
}

.btn-active:hover {
	background-color: #27ae60;
	transform: translateY(-2px);
}

.btn-deactive {
	background-color: #e74c3c;
	color: white;
}

.btn-deactive:hover {
	background-color: #c0392b;
	transform: translateY(-2px);
}

/* Status Styles */
.status-cell {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	font-weight: 500;
}

.status-cell.deactivated {
	color: #e74c3c;
}

.status-cell:not(.deactivated) {
	color: #2ecc71;
}

.admin-actions-container {
	background: white;
	padding: 1.5rem;
	border-radius: 10px;
	margin-bottom: 1.5rem;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.section-title {
	font-size: 1.25rem;
	font-weight: 600;
	margin-bottom: 1.5rem;
	color: #1a1a1a;
}

.admin-form {
	max-width: 500px;
}

.form-group {
	margin-bottom: 1rem;
}

.form-group label {
	display: block;
	margin-bottom: 0.5rem;
	font-weight: 500;
	color: #444;
}

.form-input {
	width: 100%;
	padding: 0.8rem 1rem;
	border: 1px solid #e1e1e1;
	border-radius: 8px;
	background: #f5f7fb;
	font-size: 1rem;
	color: #333;
	outline: none;
}

.form-input:focus {
	border-color: #4834d4;
	box-shadow: 0 0 0 2px rgba(72, 52, 212, 0.1);
}

select.form-input {
	appearance: none;
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23666' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10l-5 5z'/%3E%3C/svg%3E");
	background-repeat: no-repeat;
	background-position: right 1rem center;
	padding-right: 2.5rem;
}

.btn-primary {
	background-color: #4834d4;
	color: white;
	transition: all 0.3s ease;
}

.btn-primary:hover {
	background-color: #3a2ab3;
	transform: translateY(-2px);
}

.alert {
	padding: 1rem;
	margin-bottom: 1rem;
	border-radius: 8px;
}

.alert-success {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.alert-danger {
	background-color: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
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
/* Modal Styles */
.modal-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000;
}

.modal {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: white;
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    max-width: 500px;
    width: 90%;
    z-index: 1001;
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
}

.close-modal {
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
    color: #666;
}

.close-modal:hover {
    color: #333;
}

.action-button {
    background-color: #4834d4;
    color: white;
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 1rem;
    transition: all 0.3s ease;
}

.action-button:hover {
    background-color: #3a2ab3;
    transform: translateY(-2px);
}

</style>
</head>
<body>
<div class="layout-container">
		<!-- Sidebar -->
		<div class="sidebar">
			<div class="sidebar-header">
				<div class="sidebar-logo">
					<i class="fas fa-shield-alt"></i> Admin Panel
				</div>
			</div>
			<button class="sidebar-btn active">
				<i class="fas fa-users"></i> User Management
			</button>
			<button class="sidebar-btn" onclick="location.href='feedbackmanagement.jsp'">
				<i class="fas fa-comments"></i> Feedback Management
			</button>
			<button class="sidebar-btn" onclick="location.href='productmanagement.jsp'">
				<i class="fas fa-box"></i> Product Management
			</button>
			<button class="sidebar-btn" onclick="location.href='algomonitoring.jsp'">
                <i class="fas fa-chart-line"></i> Algorithm Monitoring
            </button>
            <button class="sidebar-btn" onclick="location.href='ReportServlet'">
                <i class="fas fa-file-alt"></i> Report Generation
            </button>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<!-- Main Header -->
			<div class="main-header">
				<h1 class="page-title">User Management</h1>
				<button class="admin-badge" onclick="location.href='DashboardServlet'">
					<i class="fas fa-user-shield"></i> Admin Dashboard
				</button>
			</div>
    <div class="content-container">
        <!-- Add Action Button -->
        <button class="action-button" onclick="openModal()">
            <i class="fas fa-user-cog"></i> Manage User Status
        </button>

        <!-- Modal Overlay -->
        <div id="modalOverlay" class="modal-overlay">
            <div class="modal">
                <div class="modal-header">
                    <h2 class="section-title">User Management</h2>
                    <button class="close-modal" onclick="closeModal()">&times;</button>
                </div>

                <%-- Display messages --%>
                <% if(request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("successMessage") %>
                    </div>
                <% } %>

                <% if(request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <form action="AdminServlet" method="POST" class="admin-form">
                    <div class="form-group">
                        <label for="mailID">User Email:</label>
                        <input type="email" id="mailID" name="mailID" class="form-input" placeholder="Enter EmailID" required>
                    </div>

                    <div class="form-group">
                        <label for="action">Action:</label>
                        <select id="action" name="action" class="form-input" required>
                            <option value="">Select an action</option>
                            <option value="deactivate">Deactivate User</option>
                            <option value="reactivate">Reactivate User</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Perform Action</button>
                </form>
            </div>
        </div>

        <!-- Search Box -->
        <div class="search-container">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" class="search-input" placeholder="Search by name, email..." onkeyup="searchUsers()">
            </div>
        </div>

<!-- User Table -->
					<div class="user-table">
						<table>
							<thead>
								<tr>
									<th>ID</th>
									<th>Name</th>
									<th>Email</th>
									<th>Role</th>
									<th>Status</th>
									
								</tr>
							</thead>
							<tbody id="userTableBody">
								<%
								String query = "SELECT UserID, Name, MailID, Role FROM users WHERE Role != 'Admin'";
								try (Connection conn = GetConnection.getConnection();
										Statement stmt = conn.createStatement();
										ResultSet rs = stmt.executeQuery(query)) {

									while (rs.next()) {
										String role = rs.getString("Role");
										boolean isDeactivated = role.endsWith("_DEACTIVATED");
								%>
								<tr data-email="<%=rs.getString("MailID")%>" class="user-row">
									<td><%=rs.getInt("UserID")%></td>
									<td><%=rs.getString("Name")%></td>
									<td><%=rs.getString("MailID")%></td>
									<td><%=role.replace("_DEACTIVATED", "")%></td>
									<td>
										<div
											class="status-cell <%=isDeactivated ? "deactivated" : ""%>">
											<i
												class="fas <%=isDeactivated ? "fa-times-circle" : "fa-check-circle"%>"></i>
											<%=isDeactivated ? "Deactivated" : "Active"%>
										</div>
									</td>
									
								</tr>
								<%
								}
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
</div>
    </div>

    <script>
    function openModal() {
        document.getElementById('modalOverlay').style.display = 'block';
        document.body.style.overflow = 'hidden'; // Prevent scrolling when modal is open
    }

    function closeModal() {
        document.getElementById('modalOverlay').style.display = 'none';
        document.body.style.overflow = 'auto'; // Restore scrolling
    }

    // Close modal if clicking outside of it
    document.getElementById('modalOverlay').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    // Your existing searchUsers function remains the same
    function searchUsers() {
        var input = document.getElementById('searchInput');
        var filter = input.value.toLowerCase();
        var rows = document.getElementsByClassName('user-row');

        for (var i = 0; i < rows.length; i++) {
            var name = rows[i].getElementsByTagName('td')[1].textContent.toLowerCase();
            var email = rows[i].getElementsByTagName('td')[2].textContent.toLowerCase();
            if (name.indexOf(filter) > -1 || email.indexOf(filter) > -1) {
                rows[i].style.display = '';
            } else {
                rows[i].style.display = 'none';
            }
        }
    }
    </script>
</body>
</html>