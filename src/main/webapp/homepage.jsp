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
<title>ShopHub</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
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

.lato-regular {
	font-family: "Lato", serif;
	font-weight: 400;
	font-style: normal;
}

.navbar {
	background: rgba(0, 0, 0, 0.1);
	backdrop-filter: blur(10px);
}

.navbar-brand {
	font-weight: 700;
	color: var(--primary-color) !important;
	transition: transform 0.3s ease;
}

.navbar-brand:hover {
	transform: translateY(-2px);
}

.dropdown-menu {
	background: rgba(14, 14, 14, 1);
	backdrop-filter: blur(10px);
	border: none;
	color: white;
	box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
}

.dropdown-item {
	padding: 0.5rem 1.5rem;
	color: white;
	transition: all 0.2s ease;
}

.dropdown-item:hover {
	background: rgba(0, 0, 0, 0.05);
	color: white;
	transform: translateX(5px);
}

.nav-link {
	color: var(--primary-color) !important;
	transition: all 0.3s ease;
}

.nav-link:hover {
	transform: translateY(-2px);
}

.dropdown-divider {
	background-color: #434343;
}

#cartCount {
	font-size: 0.6rem;
	padding: 0.25em 0.6em;
}

/* Animation for dropdown */
.dropdown-menu {
	animation: fadeInDown 0.3s ease forwards;
}

@
keyframes fadeInDown {from { opacity:0;
	transform: translateY(-10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

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

/* Scroll to Top Button */
#scrollToTopBtn {
	position: fixed;
	bottom: 20px;
	right: 20px;
	background-color: var(--accent-color);
	color: white;
	border: none;
	border-radius: 50%;
	width: 50px;
	height: 50px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	transition: all 0.3s ease;
	z-index: 1000;
	opacity: 0;
	visibility: hidden;
}

#scrollToTopBtn:hover {
	background-color: #5d4de6;
	transform: translateY(-5px);
}

#scrollToTopBtn.show {
	opacity: 1;
	visibility: visible;
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
	color: black;
	font-weight: bolder;
	font-size: x-large;
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

.card:nth-child(2) {
	animation-delay: 0.2s;
}

.card:nth-child(3) {
	animation-delay: 0.4s;
}

.no-spinner {
	-moz-appearance: textfield; /* Firefox */
}

.no-spinner::-webkit-inner-spin-button, .no-spinner::-webkit-outer-spin-button
	{
	-webkit-appearance: none; /* Chrome, Safari, Edge */
	margin: 0; /* Remove margin */
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
.dropdown-toggle::after {
	display: none !important;
}

.card:nth-child(2) {
	animation-delay: 0.2s;
}

.card:nth-child(3) {
	animation-delay: 0.4s;
}
</style>
<script>
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
</script>

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

// Add to cart function
async function addToCart(productId, productName, price) {
    try {
        const quantity = document.getElementById('quantity-'+productId).value;

        // Add to cart - stock will be updated in the servlet
        const cartResponse = await fetch("AddToCartServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: 'productId='+productId+'&quantity='+quantity,
        });

        if (cartResponse.ok) {
            const cartData = await cartResponse.text();
            if (cartData.startsWith("Error:")) {
                alert(cartData);
                return;
            }
            
            updateCartModal(cartData);
            alert("Added "+quantity+" of "+productName+" to the cart!");

            // Update the stock display on the page
            const stockDisplay = document.querySelector('[data-stock-id="'+productId+'"]');
            if (stockDisplay) {
                const currentStock = parseInt(stockDisplay.textContent) - parseInt(quantity);
                stockDisplay.textContent = currentStock;

                // Update the max quantity allowed
                const quantityInput = document.getElementById('quantity-'+productId);
                quantityInput.max = currentStock;

                // Disable add to cart if no stock
                if (currentStock <= 0) {
                    const addToCartBtn = document.querySelector(`[data-product-id="${productId}"]`);
                    if (addToCartBtn) {
                        addToCartBtn.disabled = true;
                    }
                }
            }
        } else {
            const errorText = await cartResponse.text();
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

    // Handle empty cart data cases
    if (!cartData || cartData.trim() === "" || cartData === "Cart is empty") {
        cartItemsDiv.innerHTML = '<div class="text-center py-8">'+
            '<i class="fas fa-shopping-bag text-gray-300 text-5xl mb-4"></i>'+
            '<p class="text-gray-500">Your cart is empty</p>'+
            '<button class="btn btn-outline-primary mt-3" data-bs-dismiss="modal">'+
            'Start Shopping'+
            '</button>'+
            '</div>';
        cartTotalDiv.textContent = "₹0.00";
        return;
    }

    const cartItems = cartData.trim().split("\n");
    let total = 0;

    // Additional check for empty array or invalid data
    if (cartItems.length === 0 || (cartItems.length === 1 && cartItems[0] === "")) {
        cartItemsDiv.innerHTML = '<div class="text-center py-8">'+
            '<i class="fas fa-shopping-bag text-gray-300 text-5xl mb-4"></i>'+
            '<p class="text-gray-500">Your cart is empty</p>'+
            '<button class="btn btn-outline-primary mt-3" data-bs-dismiss="modal">'+
            'Start Shopping'+
            '</button>'+
            '</div>';
        cartTotalDiv.textContent = "₹0.00";
        return;
    }

    let cartHTML = '<div class="space-y-4">';

    for (const item of cartItems) {
        const [productId, quantity, price, productName] = item.split(",");
        
        // Skip invalid items
        if (!productId || !quantity || !price || !productName) continue;
        
        const itemTotal = parseFloat(price) * parseInt(quantity);
        if (isNaN(itemTotal)) continue;
        
        total += itemTotal;

        cartHTML += '<div class="flex items-center p-4 border-b">' +
            '<div class="flex-grow">' +
            '<h6 class="font-semibold text-gray-900" style="color:white;">' + productName + '</h6>' +
            '<div class="flex items-center mt-1" style="color:white;">' +
            '<span class="text-gray-600">Qty: ' + quantity + '</span>' +
            '<span class="mx-2 text-gray-400">|</span>' +
            '<span class="text-gray-600">₹' + parseFloat(price).toFixed(2) + ' each</span>' +
            '</div>' +
            '</div>' +
            '<div class="text-end ms-4">' +
            '<div class="font-semibold text-primary">₹' + itemTotal.toFixed(2) + '</div>' +
            '<button onclick="removeFromCart(' + productId + ', ' + quantity + ')" ' +
            'class="btn btn-sm btn-outline-danger mt-2">' +
            '<i class="fas fa-trash-alt"></i>' +
            '</button>' +
            '</div>' +
            '</div>';
    }

    cartHTML += '</div>';
    
    // Only update the cart if we have valid items
    if (total > 0) {
        cartItemsDiv.innerHTML = cartHTML;
        cartTotalDiv.textContent = '₹' + total.toFixed(2);
    } else {
        cartItemsDiv.innerHTML = '<div class="text-center py-8">'+
            '<i class="fas fa-shopping-bag text-gray-300 text-5xl mb-4"></i>'+
            '<p class="text-gray-500">Your cart is empty</p>'+
            '<button class="btn btn-outline-primary mt-3" data-bs-dismiss="modal">'+
            'Start Shopping'+
            '</button>'+
            '</div>';
        cartTotalDiv.textContent = "₹0.00";
    }
}

// Function to load cart from session on page load
document.addEventListener('DOMContentLoaded', () => {
    fetch('AddToCartServlet')
        .then(response => response.text())
        .then(cartData => {
            if (cartData !== "Cart is empty") {
                updateCartModal(cartData);
            }
        })
        .catch(error => console.error('Error loading cart:', error));

    // Add event listeners to buttons
    const addToCartButtons = document.querySelectorAll(".add-to-cart-btn");
    addToCartButtons.forEach((button) => {
        button.addEventListener("click", () => {
            const productId = button.getAttribute("data-product-id");
            const productName = button.getAttribute("data-product-name");
            const price = button.getAttribute("data-product-price");

            addToCart(productId, productName, price);
        });
    });

    // Star rating event listeners
    const stars = document.querySelectorAll('.star-rating');
    stars.forEach(star => {
        star.addEventListener('click', () => {
            const selected = star.classList.contains('selected');
            stars.forEach(s => s.classList.remove('selected'));
            if (!selected) {
                star.classList.add('selected');
            }
        });
    });

    // Gallery item event listeners
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
});

async function fetchAddress() {
    try {
        const response = await fetch('GetCustomerAddressServlet');
        if (!response.ok) {
            throw new Error('Failed to fetch address');
        }
        const address = await response.text();
        document.getElementById('deliveryAddress').textContent = address;
    } catch (error) {
        console.error('Error fetching address:', error);
        document.getElementById('deliveryAddress').textContent = 'Error loading address';
    }
}

// Function to remove from cart
function removeFromCart(productId, quantity) {
    const formData = new URLSearchParams();
    formData.append('productId', productId);
    formData.append('quantity', -quantity); // Negative quantity to remove items

    fetch('AddToCartServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData
    })
    .then(response => response.text())
    .then(cartData => {
        updateCartModal(cartData);
    })
    .catch(error => console.error('Error removing from cart:', error));
}

async function processCheckout() {
    const paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));
    paymentModal.show();
}

async function processPurchase(paymentMethod) {
    try {
        const cartItems = document.getElementById('cartItems');
        if (!cartItems) {
            throw new Error('Cart not found');
        }

        const itemDivs = cartItems.querySelectorAll('.flex.items-center.p-4.border-b');
        if (!itemDivs || itemDivs.length === 0) {
            throw new Error('No items in cart');
        }

        const cartTotal = document.getElementById('cartTotal').textContent;
        const totalCartValue = parseFloat(cartTotal.replace('₹', ''));

        let products = [];

        itemDivs.forEach((item) => {
            try {
                const productName = item.querySelector('.font-semibold.text-gray-900')?.textContent?.trim();
                const removeButton = item.querySelector('button[onclick*="removeFromCart"]');
                const productId = removeButton?.getAttribute('onclick')?.match(/removeFromCart\((\d+),\s*\d+\)/)?.[1];
                
                const quantityText = item.querySelector('.text-gray-600')?.textContent?.trim();
                const quantity = quantityText?.match(/Qty:\s*(\d+)/)?.[1];

                const totalElement = item.querySelector('.font-semibold.text-primary');
                const itemTotal = totalElement?.textContent?.replace('₹', '').trim();

                if (!productId || !quantity || !itemTotal) {
                    console.error('Missing data:', { productId, productName, quantity, itemTotal });
                    throw new Error('Missing required product information.');
                }

                products.push({
                    productId: productId,
                    productName: productName,
                    quantity: quantity,
                    total: itemTotal
                });
            } catch (error) {
                console.error('Error processing item:', error);
                throw error;
            }
        });

        const formData = new URLSearchParams();
        formData.append('paymentMethod', paymentMethod);
        formData.append('itemCount', products.length);
        formData.append('cartTotal', totalCartValue);
        
        products.forEach((product, index) => {
            formData.append('productId_' + index, product.productId);
            formData.append('productName_' + index, product.productName);
            formData.append('quantity_' + index, product.quantity);
            formData.append('total_' + index, product.total);
        });
        
        formData.append('products', JSON.stringify(products));

        const response = await fetch('ProcessSaleServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error('Server error: ' + errorText);
        }
        
        const result = await response.text();
        if (result !== 'success') {
            throw new Error('Purchase processing failed');
        }
        
        alert('Purchase successful! Thank you for shopping with us.');
        
        const paymentModal = bootstrap.Modal.getInstance(document.getElementById('paymentModal'));
        const cartModal = bootstrap.Modal.getInstance(document.getElementById('cartModal'));
        if (paymentModal) paymentModal.hide();
        if (cartModal) cartModal.hide();
        
        updateCartModal('');
        window.location.reload();
    } catch (error) {
        console.error('Purchase processing error:', error);
        alert('Error processing purchase: ' + error.message);
    }
}

function logout() {
    if(confirm('Are you sure you want to logout?')) {
        window.location.href = 'LogoutServlet';
    }
}
</script>
>

</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light fixed-top">
		<div class="container">
			<!-- Logo with home link -->
			<a class="navbar-brand" href="homepage.jsp"> ElementStore </a>

			<!-- Toggler for mobile -->
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>

			<!-- Navigation items -->
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto align-items-center">
					<!-- Account Dropdown -->
					<li class="nav-item dropdown"><a
						class="nav-link d-flex align-items-center" style="color: white;"
						href="#" id="navbarDropdown" role="button"
						data-bs-toggle="dropdown" aria-expanded="false"> <img
							src="https://cdn-icons-png.flaticon.com/512/12225/12225881.png"
							style="width: 30px; height: 30px" alt="user icon">
					</a>
						<ul class="dropdown-menu dropdown-menu-end" style="color: white;"
							aria-labelledby="navbarDropdown">
							<li class="dropdown-item-text" style="color: white;"><span
								class="fw-bold"><%=userEmail%></span></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="userprofile.jsp"> <i
									class="bi bi-clock-history me-2"></i>User Profile
							</a></li>
							<li><a class="dropdown-item" href="orderhistory.jsp"> <i
									class="bi bi-clock-history me-2"></i>Order History
							</a></li>
							<li><a class="dropdown-item" href="feedback-history.jsp">
									<i class="bi bi-chat-left-text me-2"></i>Feedback
							</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item text-danger" href="#"
								onclick="logout()"> <i class="bi bi-box-arrow-right me-2"></i>Logout
							</a></li>
						</ul></li>

					<!-- Cart -->
					<li class="nav-item ms-3"><a
						class="nav-link position-relative" href="#" data-bs-toggle="modal"
						data-bs-target="#cartModal"> <img
							src="https://cdn-icons-png.flaticon.com/512/428/428173.png"
							style="width: 30px; height: 30px" alt="cart icon"> <!--  <span class="position-absolute top-10 start-99 translate-middle badge rounded-pill bg-danger" id="cartCount">
                    0
                </span> -->
					</a></li>
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
				<a></a>
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
								<input type="number" class="quantity-input no-spinner"
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
						<div class="mt-3"
							style="display: flex; direction: flex-column; gap: 5px; justify-content: space-around;">
							<a href="productpage.jsp?productId=<%=productId%>"
								class="btn btn-custom" style="width: 12vw;"
								<%=stock > 0 ? "" : "disabled"%>>View Product</a>
							<button class="btn btn-custom add-to-cart-btn"
								style="width: 12vw;" <%=stock > 0 ? "" : "disabled"%>
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
	<div class="modal fade" id="cartModal" tabindex="-1"
		aria-labelledby="cartModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content"
				style="background: rgba(14, 14, 14, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1);">
				<div class="modal-header border-bottom"
					style="border-color: rgba(255, 255, 255, 0.1) !important;">
					<h5 class="modal-title text-white" id="cartModalLabel">
						<i class="bi bi-cart3 me-2"></i>Shopping Cart
					</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body p-0">
					<div id="cartItems" class="p-4">
						<!-- Cart items will be dynamically inserted here -->
					</div>
					<div class="p-4"
						style="background: rgba(255, 255, 255, 0.05); color: white;">
						<div class="d-flex justify-content-between align-items-center">
							<span class="text-white fs-5">Subtotal:</span> <strong
								id="cartTotal" class="text-white fs-4">₹0.00</strong>
						</div>
						<p class="text-light opacity-75 mt-2">Shipping and taxes
							calculated at checkout</p>
						<div class="mt-3">
							<h6 class="text-white">Delivery Address:</h6>
							<p id="deliveryAddress" class="text-light opacity-75">Loading
								address...</p>
						</div>
					</div>
				</div>
				<div class="modal-footer border-top"
					style="border-color: rgba(255, 255, 255, 0.1) !important;">
					<button type="button" class="btn btn-outline-light"
						data-bs-dismiss="modal">Continue Shopping</button>
					<button onclick="processCheckout()" class="btn btn-custom">
						<i class="bi bi-lock me-2"></i>Checkout
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Payment Modal -->
	<div class="modal fade" id="paymentModal" tabindex="-1"
		aria-labelledby="paymentModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content"
				style="background: rgba(14, 14, 14, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1);">
				<div class="modal-header border-bottom"
					style="border-color: rgba(255, 255, 255, 0.1) !important;">
					<h5 class="modal-title text-white" id="paymentModalLabel">
						<i class="bi bi-credit-card me-2"></i>Select Payment Method
					</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body p-4">
					<div class="d-grid gap-3">
						<!-- Cash Payment -->
						<button onclick="processPurchase('Cash')"
							class="btn btn-outline-light text-start p-3 d-flex align-items-center">
							<i class="bi bi-cash me-3 fs-4"></i> <span class="fs-5">Cash
								Payment</span>
						</button>
						<!-- Card Payment -->
						<button onclick="processPurchase('Card')"
							class="btn btn-outline-light text-start p-3 d-flex align-items-center">
							<i class="bi bi-credit-card me-3 fs-4"></i> <span class="fs-5">Card
								Payment</span>
						</button>
						<!-- UPI Payment -->
						<button onclick="processPurchase('UPI')"
							class="btn btn-outline-light text-start p-3 d-flex align-items-center">
							<i class="bi bi-phone me-3 fs-4"></i> <span class="fs-5">UPI
								Payment</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Scroll to Top Button -->
	<button id="scrollToTopBtn" title="Go to top">
		<i class="fas fa-chevron-up"></i>
	</button>

	<footer class="py-4">
		<div class="container">
			<div class="row g-4">
				<div class="col-md-6">
					<h5 class="mb-3">About Us</h5>
					<p class="mb-0">Your premium destination for cutting-edge
						electronics and accessories.</p>
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
    // Scroll to Top Button functionality
    document.addEventListener('DOMContentLoaded', function() {
        const scrollToTopBtn = document.getElementById('scrollToTopBtn');

        // Show/hide button based on scroll position
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                scrollToTopBtn.classList.add('show');
            } else {
                scrollToTopBtn.classList.remove('show');
            }
        });

        // Scroll to top when button is clicked
        scrollToTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    });
    
    document.getElementById('cartModal').addEventListener('shown.bs.modal', function() {
        fetchAddress();
    });
</script>

</body>
</html>