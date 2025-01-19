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
<title>ShopHub - Your One-Stop Shop</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	rel="stylesheet">
<style>
html {
	scroll-behavior: smooth;
}

.category-icon {
	width: 40px;
	height: 40px;
	object-fit: cover;
	border-radius: 50%;
	margin-right: 8px;
}

.category-link {
	display: flex;
	align-items: center;
	padding: 8px 16px;
	transition: all 0.3s ease;
}

.category-link:hover {
	background-color: #e9ecef;
	border-radius: 8px;
}

.product-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
}

@media ( max-width : 1200px) {
	.product-grid {
		grid-template-columns: repeat(3, 1fr);
	}
}

@media ( max-width : 768px) {
	.product-grid {
		grid-template-columns: repeat(2, 1fr);
	}
}

@media ( max-width : 576px) {
	.product-grid {
		grid-template-columns: 1fr;
	}
}

.product-card {
	height: 100%;
	position: relative;
}

.card-body {
	display: flex;
	flex-direction: column;
}

.btn-primary {
	margin-top: auto;
}

.no-spinner {
	-moz-appearance: textfield; /* Firefox */
}

.no-spinner::-webkit-inner-spin-button, .no-spinner::-webkit-outer-spin-button
	{
	-webkit-appearance: none; /* Chrome, Safari, Edge */
	margin: 0; /* Remove margin */
}

.logout-btn {
	color: #ff6b6b !important;
	transition: color 0.3s ease;
}

.logout-btn:hover {
	color: #ff4757 !important;
}

.nav-link {
	padding: 0.5rem 1rem !important;
}
</style>
<script>
// Update quantity control function
function updateQuantity(productId, change) {
    const quantityInput = document.getElementById('quantity-'+productId);
    let newValue = parseInt(quantityInput.value) + change;
    console.log(newValue);

    const minQuantity = parseInt(quantityInput.getAttribute('min')); 
    const maxQuantity = parseInt(quantityInput.getAttribute('max')); 
    
    // Ensure new value is within the valid range
    if (newValue < minQuantity) newValue = minQuantity;
    if (newValue > maxQuantity) newValue = maxQuantity;

    quantityInput.value = newValue;
}

// Add to cart function
async function addToCart(productId, productName, price) {
    try {
        const quantity = document.getElementById('quantity-'+productId).value;
        
        // Sending the POST request to AddToCartServlet
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
            const errorText = await response.text();
            console.error("Error adding to cart:", errorText);
            alert("Failed to add item to the cart. Please try again.");
        }
    } catch (error) {
        console.error("Error:", error);
        alert("An error occurred while adding the item to the cart.");
    }
}

// Function to update the cart modal dynamically
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

        cartHTML += '<li class="list-group-item d-flex justify-content-between align-items-center"> Product ID: ' + productId +' | Quantity: ' + quantity + ' | Price: $' + parseFloat(price).toFixed(2) + '<span>Total: $' + itemTotal.toFixed(2) + '</span> </li>';
    }

    cartHTML += "</ul>";
    cartItemsDiv.innerHTML = cartHTML;
    cartTotalDiv.textContent = `Total: $${total.toFixed(2)}`;
}

// Add event listeners to buttons dynamically
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
	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="#">ShopHub</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto">
					<li class="nav-item"><a class="nav-link" href="#"> <i
							class="fas fa-user"></i> <%=userEmail%> <!-- Display user email -->
					</a></li>
					<li class="nav-item"><a class="nav-link" href="#"
						data-bs-toggle="modal" data-bs-target="#cartModal"> <i
							class="fas fa-shopping-cart"></i> Cart
					</a></li>
					<li class="nav-item"><a class="nav-link logout-btn" href="#"
						onclick="logout()"> <i class="fas fa-sign-out-alt"></i> Logout
					</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Update the cart modal div with this content -->
	<div class="modal fade" id="cartModal" tabindex="-1"
		aria-labelledby="cartModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="cartModalLabel">Your Cart</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div id="cartItems">
						<!-- Cart items will be dynamically inserted here -->
					</div>
					<hr>
					<div class="text-end">
						<strong id="cartTotal">Total: $0.00</strong>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<a href="cart.jsp" class="btn btn-primary">View Cart</a>
				</div>
			</div>
		</div>
	</div>

	<!-- Categories Bar -->
	<div class="bg-light py-3">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-12">
					<div class="d-flex flex-wrap  justify-content-around">
						<a href="#electronics"
							class="category-link d-flex flex-column  text-dark text-decoration-none">
							<img
							src="https://rukminim2.flixcart.com/fk-p-flap/80/80/image/6c22d4999cdb4144.jpg?q=100"
							alt="Electronics" class="category-icon w-32 h-32"> <span
							class="fw-bold">Electronics</span>
						</a> <a href="#fashion"
							class="category-link d-flex flex-column text-dark text-decoration-none">
							<img
							src="https://rukminim2.flixcart.com/fk-p-flap/80/80/image/46de73feaefc28cd.jpg?q=100"
							alt="Fashion" class="category-icon w-32 h-32"> <span
							class="fw-bold">Fashion</span>
						</a> <a href="#home"
							class="category-link d-flex flex-column text-dark text-decoration-none">
							<img
							src="https://rukminim2.flixcart.com/fk-p-flap/80/80/image/8538d487cd2bc8b7.jpg?q=100"
							alt="Home" class="category-icon w-32 h-32"> <span
							class="fw-bold">Home & Kitchen</span>
						</a> <a href="#books"
							class="category-link d-flex flex-column text-dark text-decoration-none">
							<img
							src="https://rukminim2.flixcart.com/fk-p-flap/80/80/image/e7947cc0cc4a6b7c.jpg?q=100"
							alt="Books" class="category-icon w-32 h-32"> <span
							class="fw-bold">Furniture</span>
						</a> <a href="#toys"
							class="category-link d-flex flex-column text-dark text-decoration-none">
							<img
							src="https://rukminim2.flixcart.com/fk-p-flap/80/80/image/800e00a6322c6985.jpg?q=100"
							alt="Toys" class="category-icon w-32 h-32"> <span
							class="fw-bold">Grocery</span>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Hero Carousel -->
	<div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
		<div class="carousel-inner">
			<div class="carousel-item active">
				<img
					src="https://rukminim2.flixcart.com/fk-p-flap/1620/270/image/f29e90d0b3e1c6e1.jpg?q=20"
					class="d-block w-100" alt="Deal 1">
				<div class="carousel-caption">
					<h2>Big Sale Up to 70% Off</h2>
					<p>Shop the latest electronics and gadgets</p>
				</div>
			</div>
			<div class="carousel-item">
				<img
					src="https://rukminim2.flixcart.com/fk-p-flap/1620/270/image/f29e90d0b3e1c6e1.jpg?q=20"
					class="d-block w-100" alt="Deal 2">
				<div class="carousel-caption">
					<h2>Fashion Week Special</h2>
					<p>Discover trending styles</p>
				</div>
			</div>
		</div>
		<button class="carousel-control-prev" type="button"
			data-bs-target="#heroCarousel" data-bs-slide="prev">
			<span class="carousel-control-prev-icon"></span>
		</button>
		<button class="carousel-control-next" type="button"
			data-bs-target="#heroCarousel" data-bs-slide="next">
			<span class="carousel-control-next-icon"></span>
		</button>
	</div>

	<!-- Main Content -->
	<div class="container my-5">
		<!-- Electronics Section -->
		<section id="electronics" class="mb-5">
			<h3 class="mb-4">Electronics</h3>
			<div class="product-grid">
				<%
				// Database connection details
				String dbURL = "jdbc:mysql://localhost:3306/erp_system";
				String dbUser = "root";
				String dbPassword = "1234";
				Connection conn = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Load MySQL JDBC Driver
					Class.forName("com.mysql.cj.jdbc.Driver");

					// Establish the connection
					conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

					// Query to fetch products from the 'products' table
					String query = "SELECT ProductID, Name, Category, Cost, SellingPrice, Stock, SalesData, ReorderLevel, SupplierInfo, ExpiryDate FROM products WHERE Category = 'Electronics'";
					stmt = conn.createStatement();
					rs = stmt.executeQuery(query);

					// Loop through the result set and display products
					while (rs.next()) {
						String productName = rs.getString("Name");
						double sellingPrice = rs.getDouble("SellingPrice");
						double cost = rs.getDouble("Cost");
						int stock = rs.getInt("Stock");
				%>
				<%-- Inside the product card loop, replace the existing card-body div with: --%>
				<div class="card product-card">
					<div class="card-body">
						<div
							class="badge bg-<%=stock > 0 ? "success" : "danger"%> position-absolute top-0 end-0 m-2">
							<%=stock > 0 ? "In Stock" : "Out of Stock"%>
						</div>
						<h5 class="card-title"><%=productName%></h5>
						<p class="card-text">
							<span class="text-danger">$<%=sellingPrice%></span>
						</p>

						<!-- Quantity Controls -->
						<!-- Quantity Controls -->
						<div class="d-flex align-items-center justify-content-center mb-3">
							<!-- Decrement Button -->
							<button class="btn btn-outline-secondary p-2 btn-sm"
								type="button"
								onclick="updateQuantity('<%=rs.getInt("ProductID")%>', -1)">
								-</button>

							<!-- Quantity Input -->
							<input type="number" class="form-control text-center no-spinner"
								style="width: 60px;" id="quantity-<%=rs.getInt("ProductID")%>"
								value="1" min="1" max="<%=stock%>"
								<%=stock > 0 ? "" : "disabled"%> readonly>

							<!-- Increment Button -->
							<button class="btn btn-outline-secondary p-2 btn-sm"
								type="button"
								onclick="updateQuantity('<%=rs.getInt("ProductID")%>', 1)">
								+</button>
						</div>


						<!-- Action Buttons -->
						<div class="d-flex flex-row justify-content-around">
							<a href="productpage.jsp?productId=<%=rs.getInt("ProductID")%>"
								class="btn btn-primary" <%=stock > 0 ? "" : "disabled"%>>View
								Product</a>
							<button class="btn btn-primary add-to-cart-btn"
								<%=stock > 0 ? "" : "disabled"%>
								data-product-id="<%=rs.getInt("ProductID")%>"
								data-product-name="<%=productName%>"
								data-product-price="<%=sellingPrice%>">Add to Cart</button>
						</div>
					</div>
				</div>


				<%
				}
				} catch (Exception e) {
				out.println("<p>Error: " + e.getMessage() + "</p>");
				} finally {
				// Close resources
				if (rs != null)
				rs.close();
				if (stmt != null)
				stmt.close();
				if (conn != null)
				conn.close();
				}
				%>
			</div>
		</section>
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

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js">
	</script>
	<script>
function logout() {
    if(confirm('Are you sure you want to logout?')) {
        window.location.href = 'LogoutServlet';
    }
}
</script>



</body>
</html>