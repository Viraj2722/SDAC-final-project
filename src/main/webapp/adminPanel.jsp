<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Panel</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
}

.container {
	display: flex;
	min-height: 100vh;
}

/* Sidebar Styles */
.sidebar {
	width: 250px;
	background-color: #2c3e50;
	padding: 20px;
	color: white;
}

.sidebar-btn {
	display: block;
	width: 100%;
	padding: 12px 15px;
	margin: 8px 0;
	background: none;
	border: none;
	color: white;
	text-align: left;
	font-size: 16px;
	cursor: pointer;
	border-radius: 5px;
	transition: background-color 0.3s;
}

.sidebar-btn:hover {
	background-color: #34495e;
}

/* Main Content Area */
.main-content {
	flex: 1;
	background-color: #f5f6fa;
}

/* Top Navigation */
.top-nav {
	background-color: white;
	padding: 15px 30px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	display: flex;
	justify-content: flex-end;
}

.nav-tabs {
	display: flex;
	gap: 10px;
}

.tab-btn {
	padding: 10px 20px;
	border: none;
	background-color: #f5f6fa;
	cursor: pointer;
	border-radius: 5px;
	font-size: 14px;
	transition: background-color 0.3s;
}

.tab-btn.active {
	background-color: #2c3e50;
	color: white;
}

.tab-btn:hover:not(.active) {
	background-color: #e0e0e0;
}

/* Content Area */
.content {
	padding: 20px;
}

.page-title {
	margin-bottom: 20px;
	color: #2c3e50;
}

.logout-btn {
    background-color: #e74c3c !important;
    color: white !important;
}

.logout-btn:hover {
    background-color: #c0392b !important;
}

.nav-tabs {
    display: flex;
    gap: 10px;
    align-items: center;
}
</style>
</head>
<body>
	<div class="container">
		<!-- Sidebar -->
		<div class="sidebar">
			<button class="sidebar-btn"
				onclick="location.href='usermanagement.jsp'">User
				Management</button>
			<button class="sidebar-btn"
				onclick="location.href='feedbackmanagement.jsp'">Feedback
				Management</button>
			<button class="sidebar-btn"
				onclick="location.href='productmanagement.jsp'">Product
				Management</button>
				  <button class="sidebar-btn" onclick="location.href='algomonitoring.jsp'">
                <i class="fas fa-chart-line"></i>
                Algorithm Monitoring
            </button>
            <button class="sidebar-btn active" onclick="location.href='ReportServlet'">
                <i class="fas fa-file-download"></i>
                Report Generation
            </button>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<!-- Top Navigation -->
			<div class="top-nav">
				<div class="nav-tabs">
					<button class="tab-btn active">Admin Panel</button>
					<button class="tab-btn"
						onclick="location.href='adminDashboard.jsp'">Admin
						Dashboard</button>
					<button class="tab-btn logout-btn" onclick="logout()">Logout</button>
				</div>
			</div>

			<!-- Content Area -->
			<div class="content">
				<h1 class="page-title">Welcome to Admin Panel</h1>
				<!-- Add your main content here -->
			</div>
		</div>
	</div>

	<script>
        // Add active class to sidebar buttons
        const sidebarBtns = document.querySelectorAll('.sidebar-btn');
        sidebarBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                sidebarBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            });
        });
        
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                location.href = 'LogoutServlet';
            }
        }
    </script>
</body>
</html>