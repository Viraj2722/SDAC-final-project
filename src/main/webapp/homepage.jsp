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
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ElementStore</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"
	rel="stylesheet">
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&display=swap')
	;

:root {
	--primary-color: #ffffff;
	--accent-color: #000000;
	--bg-gradient: linear-gradient(135deg, #141514 0%, #3f3f3f 100%);
}

body {
	background: var(--bg-gradient);
	min-height: 100vh;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	font-family: "Lato", serif;
	font-weight: 400;
	font-style: normal;
}

.gallery-item {
	position: relative;
	overflow: hidden;
	border-radius: 12px;
	transition: transform 0.3s ease;
	text-decoration: none;
	color: inherit;
}

.category-overlay {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.5);
	display: flex;
	justify-content: center;
	align-items: center;
	opacity: 0;
	transition: opacity 0.3s ease;
}

.category-overlay span {
	color: white;
	font-size: 1.5rem;
	font-weight: 600;
	text-align: center;
	padding: 1rem;
}

.gallery-item:hover .category-overlay {
	opacity: 1;
}

.gallery-item:hover img {
	filter: blur(3px);
}

.lato-regular {
	font-family: "Lato", serif;
	font-weight: 400;
	font-style: normal;
}

.navbar {
	background: rgba(255, 255, 255, 0.1);
	backdrop-filter: blur(10px);
	transition: all 0.3s ease;
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
	position: relative;
	color: var(--primary-color) !important;
	font-weight: 500;
}

.nav-link::after {
	content: '';
	position: absolute;
	width: 0;
	height: 2px;
	bottom: 0;
	left: 0;
	background-color: var(--accent-color);
	transition: width 0.3s ease;
}

.nav-link:hover::after {
	width: 100%;
}

.gallery-container {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	grid-auto-rows: 200px;
	grid-auto-flow: dense;
	gap: 15px;
	padding: 15px;
	max-width: 1200px;
	margin: 50px auto;
}

.gallery-item {
	position: relative;
	overflow: hidden;
	border-radius: 12px;
	transition: transform 0.3s ease;
}

.gallery-item:hover {
	transform: scale(1.02);
}

.gallery-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.gallery-item.wide {
	grid-column: span 2;
}

.gallery-item.tall {
	grid-row: span 2;
}

.gallery-item.big {
	grid-column: span 2;
	grid-row: span 2;
}

.category {
	color:
}

.card {
	background: rgba(255, 255, 255, 0.7);
	border: none;
	border-radius: 15px;
	backdrop-filter: blur(10px);
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	overflow: hidden;
	animation: fadeInUp 0.6s ease forwards;
}

.card:hover {
	transform: translateY(-10px);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.card-title {
	color: var(--primary-color);
	font-weight: 600;
}

.price {
	color: var(--accent-color);
	font-size: 1.5rem;
	font-weight: 700;
	transition: transform 0.3s ease;
}

.card:hover .price {
	transform: scale(1.1);
}

.btn-custom {
	background: var(--accent-color);
	color: white;
	border: none;
	border-radius: 25px;
	padding: 8px 25px;
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
}

.btn-custom::before {
	content: '';
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.3),
		transparent);
	transition: 0.5s;
}

.btn-custom:hover::before {
	left: 100%;
}

.btn-custom:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 15px rgba(108, 92, 231, 0.4);
	background: #5d4de6;
}

.badge {
	padding: 8px 15px;
	border-radius: 20px;
	font-weight: 500;
	transition: all 0.3s ease;
}

.badge:hover {
	transform: scale(1.1);
}

.quantity-input {
	width: 60px;
	text-align: center;
	border: 1px solid #ddd;
	border-radius: 4px;
	padding: 4px;
}

footer {
	background: rgba(255, 255, 255, 0.1);
	backdrop-filter: blur(10px);
	color: var(--primary-color);
	margin-top: 100px;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.card:nth-child(2) {
	animation-delay: 0.2s;
}

.card:nth-child(3) {
	animation-delay: 0.4s;
}
</style>
<script>
        function updateQuantity(productId, change) {
            const quantityInput = document.getElementById('quantity-'+productId);
            let newValue = parseInt(quantityInput.value) + change;
            const minQuantity = parseInt(quantityInput.getAttribute('min'));
            const maxQuantity = parseInt(quantityInput.getAttribute('max'));
            
            if (newValue < minQuantity) newValue = minQuantity;
            if (newValue > maxQuantity) newValue = maxQuantity;

            quantityInput.value = newValue;
        }

        async function addToCart(productId, productName, price) {
            try {
                const quantity = document.getElementById('quantity-'+productId).value;
                const response = await fetch("AddToCartServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded",
                    },
                    body: 'productId='+productId+'&quantity='+quantity,
                });

                if (response.ok) {
                    const cartData = await response.text();
                    updateCartModal(cartData);
                    alert('Added '+quantity+' of '+productName+' to the cart!');
                } else {
                    alert("Failed to add item to the cart. Please try again.");
                }
            } catch (error) {
                console.error("Error:", error);
                alert("An error occurred while adding the item to the cart.");
            }
        }

        function updateCartModal(cartData) {
            const cartItemsDiv = document.getElementById("cartItems");
            const cartTotalDiv = document.getElementById("cartTotal");

            const cartItems = cartData.trim().split("\n");
            let total = 0;
            let cartHTML = "<ul class='list-group'>";

            for (const item of cartItems) {
                const [productId, quantity, price] = item.split(",");
                const itemTotal = parseFloat(price) * parseInt(quantity);
                total += itemTotal;

                cartHTML += '<li class="list-group-item d-flex justify-content-between align-items-center">'+
                    'Product ID: '+ productId+ ' | Quantity: '+quantity+' | Price: $'+parseFloat(price).toFixed(2)+'<span>Total: $'+itemTotal.toFixed(2)+'</span>'+
                '</li>';
            }

            cartHTML += "</ul>";
            cartItemsDiv.innerHTML = cartHTML;
            cartTotalDiv.innerHTML = '<strong>Total: $'+total.toFixed(2)+'</strong>';
        }

        function logout() {
            if(confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            const addToCartButtons = document.querySelectorAll(".add-to-cart-btn");
            addToCartButtons.forEach((button) => {
                button.addEventListener("click", () => {
                    const productId = button.getAttribute("data-product-id");
                    const productName = button.getAttribute("data-product-name");
                    const price = button.getAttribute("data-product-price");

                    addToCart(productId, productName, price);
                });
            });
        });
    </script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light fixed-top">
		<div class="container">
			<a class="navbar-brand" href="#">ElementStore</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto">
					<li class="nav-item"><a class="nav-link" href="#">Welcome,
							<%=userEmail%></a></li>
					<li class="nav-item"><a class="nav-link" href="#"
						data-bs-toggle="modal" data-bs-target="#cartModal">Cart</a></li>
					<li class="nav-item"><a class="nav-link" href="#"
						onclick="logout()">Logout</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Update the gallery container section -->
	<div class="gallery-container">
		<a href="#clothing" class="gallery-item big"> <img
			src="https://images.pexels.com/photos/5709661/pexels-photo-5709661.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Clothing">
			<div class="category-overlay">
				<span>Clothing</span>
			</div>
		</a> <a href="#accessory" class="gallery-item"> <img
			src="https://images.pexels.com/photos/236900/pexels-photo-236900.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Accessories">
			<div class="category-overlay">
				<span>Accessories</span>
			</div>
		</a> <a href="#groceries" class="gallery-item tall"> <img
			src="https://images.pexels.com/photos/6331200/pexels-photo-6331200.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Grocery & Essentials">
			<div class="category-overlay">
				<span>Grocery & Essentials</span>
			</div>
		</a> <a href="#beauty" class="gallery-item wide"> <img
			src="https://images.pexels.com/photos/4620873/pexels-photo-4620873.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Beauty">
			<div class="category-overlay">
				<span>Beauty</span>
			</div>
		</a> <a href="#electronics" class="gallery-item tall"> <img
			src="https://images.pexels.com/photos/3550482/pexels-photo-3550482.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Electronics">
			<div class="category-overlay">
				<span>Electronics</span>
			</div>
		</a> <a href="#furniture" class="gallery-item tall"> <img
			src="https://images.pexels.com/photos/1148955/pexels-photo-1148955.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Furniture">
			<div class="category-overlay">
				<span>Furniture</span>
			</div>
		</a> <a href="#sports" class="gallery-item wide"> <img
			src="https://images.pexels.com/photos/257970/pexels-photo-257970.jpeg?auto=compress&cs=tinysrgb&w=600"
			alt="Sports">
			<div class="category-overlay">
				<span>Sports</span>
			</div>
		</a>
	</div>

	<div class="container"
		style="margin-top: 100px; color: white; font-weight: 900;">
		<h1 class="text-center mb-5" style="font-weight: 600;">Featured
			Products</h1>

		<div class="row g-4" style="margin-top: 50px" id="electronics">
			<h2 class="category">Electronics</h2>
			<%
			// Database connection details
			String dbURL = "jdbc:mysql://localhost:3306/erp_system";
			String dbUser = "root";
			String dbPassword = "1234";
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Electronics'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>

		<div class="row g-4" style="margin-top: 50px" id="clothing">
			<h2 class="category">Clothing</h2>
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Clothing'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>


		<div class="row g-4" style="margin-top: 50px" id="furniture">
			<h2 class="category">Furniture</h2>
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Furniture'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>



		<div class="row g-4" style="margin-top: 50px" id="sports">
			<h2 class="category">Sports</h2>
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Sports'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>



		<div class="row g-4" style="margin-top: 50px" id="accessory">
			<h2 class="category">Accessory</h2>
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Accessory'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>



		<div class="row g-4" style="margin-top: 50px" id="groceries">
			<h2 class="category">Groceries & Essentials</h2>
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Groceries & Essentials'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>


		<div class="row g-4" style="margin-top: 50px" id="beauty">
			<h2 class="category">Beauty</h2>
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
				String query = "SELECT ProductID, Name, Category, SellingPrice, Stock FROM products WHERE Category='Beauty'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					String productName = rs.getString("Name");
					double sellingPrice = rs.getDouble("SellingPrice");
					int stock = rs.getInt("Stock");
					int productId = rs.getInt("ProductID");
			%>

			<div class="col-md-4">
				<div class="card h-100">
					<div class="card-body p-4">
						<h5 class="card-title mb-3"><%=productName%></h5>
						<p class="card-text text-muted">
							Experience premium quality with our
							<%=productName%>.
						</p>
						<p class="price mb-3">
							₹<%=String.format("%.2f", sellingPrice)%></p>
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center">
								<button class="btn btn-sm btn-secondary me-2"
									onclick="updateQuantity('<%=productId%>', -1)">-</button>
								<input type="number" class="quantity-input"
									id="quantity-<%=productId%>" value="1" min="1" max="<%=stock%>"
									readonly>
								<button class="btn btn-sm btn-secondary ms-2"
									onclick="updateQuantity('<%=productId%>', 1)">+</button>
							</div>
							<%
							if (stock > 0) {
							%>
							<span class="badge bg-success">In Stock</span>
							<%
							} else {
							%>
							<span class="badge bg-danger">Sold Out</span>
							<%
							}
							%>
						</div>
						<div class="mt-3">
							<button class="btn btn-custom w-100 add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=productId%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (stmt != null)
			stmt.close();
			if (conn != null)
			conn.close();
			}
			%>
		</div>

	</div>

	<!-- Cart Modal -->
	<div class="modal fade" id="cartModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Shopping Cart</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<div id="cartItems"></div>
					<div id="cartTotal" class="text-end mt-3"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<a href="checkout.jsp" class="btn btn-primary">Checkout</a>
				</div>
			</div>
		</div>
	</div>

	<footer class="py-4">
		<div class="container">
			<div class="row g-4">
				<div class="col-md-6">
					<h5 class="mb-3">About Us</h5>
					<p class="mb-0">Your premium destination for shopping</p>
				</div>
				<div class="col-md-6">
					<h5 class="mb-3">Contact</h5>
					<p class="mb-0">
						Email: hello@elementstore.com<br>Phone: (555) 123-4567
					</p>
				</div>
			</div>
		</div>
	</footer>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
	<script>
document.querySelectorAll('.gallery-item').forEach(item => {
    item.addEventListener('click', function(e) {
        e.preventDefault();
        const targetId = this.getAttribute('href');
        const targetSection = document.querySelector(targetId);
        
        if (targetSection) {
            targetSection.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});
</script>

</body>
</html>