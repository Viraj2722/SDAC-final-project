<%@ page import="java.sql.*, java.util.*"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="db.GetConnection"%>
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
<title>Product Details</title>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=account_circle" />
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
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
	font-family: 'Lato', serif;
	font-weight: 400;
	font-style: normal;
	color: var(--primary-color);
}

/* Product Details Card */
.bg-white {
	background: rgba(255, 255, 255, 0.1) !important;
	backdrop-filter: blur(10px);
	border: none;
}

.text-gray-900 {
	color: var(--primary-color) !important;
}

.text-gray-600, .text-gray-700, .text-gray-500 {
	color: rgba(255, 255, 255, 0.7) !important;
}

/* Buttons */
.btn-custom, .btn-primary, .btn-increment, .btn-decrement {
	background: var(--accent-color);
	color: white;
	border: none;
	border-radius: 25px;
	padding: 8px 25px;
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
}

.btn-custom:hover, .btn-primary:hover, .btn-increment:hover,
	.btn-decrement:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 15px rgba(255, 255, 255, 0.2);
	background: #333;
}

/* Input Fields */
.form-control, textarea {
	background: rgba(255, 255, 255, 0.1);
	border: 1px solid rgba(255, 255, 255, 0.2);
	color: var(--primary-color);
}

.form-control:focus, textarea:focus {
	background: rgba(255, 255, 255, 0.15);
	border-color: rgba(255, 255, 255, 0.3);
	color: var(--primary-color);
	box-shadow: none;
}

/* Star Rating */
.star-rating {
	color: rgba(255, 255, 255, 0.3);
	cursor: pointer;
}

.star-rating.selected {
	color: #fbbf24;
}

/* Cart Modal */
.modal-content {
	background: var(--bg-gradient);
	border: none;
}

.modal-header, .modal-footer {
	border-color: rgba(255, 255, 255, 0.1);
}

.cart-item {
	background: rgba(255, 255, 255, 0.05);
	transition: background-color 0.2s;
}

.cart-item:hover {
	background: rgba(255, 255, 255, 0.1);
}

/* Quantity Controls */
.quantity-input {
	background: rgba(255, 255, 255, 0.1);
	color: var(--primary-color);
	border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Success and Error Messages */
.success-message {
	color: #10b981;
}

.error-message {
	color: #ef4444;
}

/* Navbar */
.navbar {
	background: rgba(0, 0, 0, 0.1);
	backdrop-filter: blur(10px);
}

.navbar-brand {
	font-weight: 700;
	color: var(--primary-color) !important;
	transition: transform 0.3s ease;
}

.nav-link {
	color: var(--primary-color) !important;
	transition: all 0.3s ease;
}

.nav-link:hover {
	transform: translateY(-2px);
}

/* Animations */
@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* Card Animations */
.card {
	animation: fadeInUp 0.6s ease forwards;
}

.card:nth-child(2) {
	animation-delay: 0.2s;
}

.card:nth-child(3) {
	animation-delay: 0.4s;
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
</style>
<script>
        // Rating system
        function setRating(rating) {
            document.getElementById('rating-input').value = rating;
            const stars = document.querySelectorAll('#rating-stars .star-rating');
            stars.forEach((star, index) => {
                star.classList.toggle('selected', index < rating);
            });
        }


   // Update quantity control function
function updateQuantity(productId, change) {
    const quantityInput = document.getElementById('quantity-'+productId);
    let newValue = parseInt(quantityInput.value) + change;
    
    const minQuantity = parseInt(quantityInput.getAttribute('min')); 
    const maxQuantity = parseInt(quantityInput.getAttribute('max')); 
    
    // Ensure new value is within the valid range
    if (newValue < minQuantity) newValue = minQuantity;
    if (newValue > maxQuantity) newValue = maxQuantity;

    quantityInput.value = newValue;
}

//Add to cart function
async function addToCart(productId, productName, price) {
    try {
        const quantity = document.getElementById('quantity-'+productId).value;
        
        // First update the stock
        const stockResponse = await fetch("UpdateStockServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: "productId="+productId+"&quantity="+quantity,
        });

        if (!stockResponse.ok) {
            const errorText = await stockResponse.text();
            alert("Failed to update stock: " + errorText);
            return;
        }

        // If stock update successful, add to cart
        const cartResponse = await fetch("AddToCartServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: 'productId='+productId+'&quantity='+quantity,
        });

        if (cartResponse.ok) {
            const cartData = await cartResponse.text();
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

//Function to update the cart modal dynamically
// Function to update the cart modal dynamically
function updateCartModal(cartData) {
    const cartItemsDiv = document.getElementById("cartItems");
    const cartTotalDiv = document.getElementById("cartTotal");

    const cartItems = cartData.trim().split("\n");
    let total = 0;

    if (cartItems.length === 0 || (cartItems.length === 1 && cartItems[0] === "")) {
        cartItemsDiv.innerHTML = '<div class="text-center py-8">'+
               '<i class="fas fa-shopping-bag text-gray-300 text-5xl mb-4"></i>'+
                '<p class="text-gray-500">Your cart is empty</p>'+
               '<button class="btn btn-outline-primary mt-3" data-bs-dismiss="modal">'+
                  '  Start Shopping '+
               ' </button>'+
           ' </div>';
        cartTotalDiv.textContent = "$0.00";
        return;
    }

    let cartHTML = '<div class="space-y-4">';

    for (const item of cartItems) {
        const [productId, quantity, price, productName] = item.split(",");
        const itemTotal = parseFloat(price) * parseInt(quantity);
        total += itemTotal;

        cartHTML += '<div class="flex items-center p-4 border-b">' +
        '<div class="flex-grow">' +
            '<h6 class="font-semibold text-gray-900">' + productName + '</h6>' +
            '<div class="flex items-center mt-1">' +
                '<span class="text-gray-600">Qty: ' + quantity + '</span>' +
                '<span class="mx-2 text-gray-400">|</span>' +
                '<span class="text-gray-600">$' + parseFloat(price).toFixed(2) + ' each</span>' +
            '</div>' +
        '</div>' +
        '<div class="text-end ms-4">' +
            '<div class="font-semibold text-primary">$' + itemTotal.toFixed(2) + '</div>' +
            '<button onclick="removeFromCart(' + productId + ', ' + quantity + ')" ' +
            'class="btn btn-sm btn-outline-danger mt-2">' +
            '<i class="fas fa-trash-alt"></i>' +
        '</button>' +
        '</div>' +
    '</div>';    }

    cartHTML += '</div>';
    cartItemsDiv.innerHTML = cartHTML;
    cartTotalDiv.textContent = '$'+total.toFixed(2);
}

// Function to remove item from cart
async function removeFromCart(productId, quantity) {
    try {
        const formData = new URLSearchParams();
        formData.append('productId', productId);
        formData.append('quantity', quantity);

        // Get the context path
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
        
        const response = await fetch(contextPath + '/RemoveFromCartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        });

        if (response.ok) {
            const cartData = await response.text();
            updateCartModal(cartData);
            
            // Update the stock display if it exists on the page
            const stockDisplay = document.querySelector('[data-stock-id="' + productId + '"]');
            if (stockDisplay) {
                const currentStock = parseInt(stockDisplay.textContent) + quantity;
                stockDisplay.textContent = currentStock;
                
                // Update the max quantity allowed in the input if it exists
                const quantityInput = document.getElementById('quantity-' + productId);
                if (quantityInput) {
                    quantityInput.max = currentStock;
                }
                
                // Re-enable add to cart button if it was disabled
                const addToCartBtn = document.querySelector('[data-product-id="' + productId + '"]');
                if (addToCartBtn) {
                    addToCartBtn.disabled = false;
                }
            }
        } else {
            const errorText = await response.text();
            console.error('Error removing from cart:', errorText);
            alert('Failed to remove item from cart. Please try again.');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('An error occurred while removing the item from cart.');
    }
}

async function processCheckout() {
    const paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));
    paymentModal.show();
}

// Function to handle payment and create sale
// Update the processPurchase function with proper data extraction and error handling
async function processPurchase(paymentMethod) {
    try {
        // Get all cart items from the cart modal
        const cartItems = document.getElementById('cartItems');
        if (!cartItems) {
            throw new Error('Cart not found');
        }
        // Get all item divs
        const itemDivs = cartItems.querySelectorAll('.flex.items-center.p-4.border-b');
        if (!itemDivs || itemDivs.length === 0) {
            throw new Error('No items in cart');
        }
        // Calculate total cart value
        const cartTotal = document.getElementById('cartTotal').textContent;
        const totalCartValue = parseFloat(cartTotal.replace('$', ''));

        // Create array to store all products
        let products = [];

        // Process each item and store in array
        itemDivs.forEach((item) => {
            try {
                const productName = item.querySelector('.font-semibold.text-gray-900')?.textContent?.trim();
                const removeButton = item.querySelector('button[onclick*="removeFromCart"]');
                // Updated regex pattern to match removeFromCart(productId, quantity)
                const productId = removeButton?.getAttribute('onclick')?.match(/removeFromCart\((\d+),\s*\d+\)/)?.[1];
                console.log("Remove button onclick:", removeButton?.getAttribute('onclick'));
                console.log("productId extracted:", productId);

                const quantityText = item.querySelector('.text-gray-600')?.textContent?.trim();
                const quantity = quantityText?.match(/Qty:\s*(\d+)/)?.[1];

                const totalElement = item.querySelector('.font-semibold.text-primary');
                const itemTotal = totalElement?.textContent?.replace('$', '').trim();

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

        // Rest of the function remains the same...

        
        // Create FormData with cart information
        const formData = new URLSearchParams();
        formData.append('paymentMethod', paymentMethod);
        formData.append('itemCount', products.length);
        formData.append('cartTotal', totalCartValue);
        
        // Add all products to formData
        products.forEach((product, index) => {
            formData.append('productId_' + index, product.productId);
            formData.append('productName_' + index, product.productName);
            formData.append('quantity_' + index, product.quantity);
            formData.append('total_' + index, product.total);
        });
        
        // Also send the entire products array as JSON for easier server-side processing
        formData.append('products', JSON.stringify(products));

        // Send request to process sale
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
        
        // Success handling
        alert('Purchase successful! Thank you for shopping with us.');
        
        // Close modals
        const paymentModal = bootstrap.Modal.getInstance(document.getElementById('paymentModal'));
        const cartModal = bootstrap.Modal.getInstance(document.getElementById('cartModal'));
        if (paymentModal) paymentModal.hide();
        if (cartModal) cartModal.hide();
        
        // Clear cart and refresh page
        updateCartModal('');
        window.location.reload();
    } catch (error) {
        console.error('Purchase processing error:', error);
        alert('Error processing purchase: ' + error.message);
    }
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

if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}

    </script>
</head>
<body class="bg-gray-50">
	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-light fixed-top">
		<div class="container">
			<!-- Logo with home link -->
			<a class="navbar-brand" href="homepage.jsp"> ShopHub </a>

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
						data-bs-toggle="dropdown" aria-expanded="false"><svg
								xmlns="http://www.w3.org/2000/svg" width="24" height="24"
								viewBox="0 0 24 24">
								<path fill="currentColor"
									d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2m0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6m0 14c-2.03 0-4.43-.82-6.14-2.88a9.95 9.95 0 0 1 12.28 0C16.43 19.18 14.03 20 12 20" /></svg>
					</a>
						<ul class="dropdown-menu dropdown-menu-end" style="color: white;"
							aria-labelledby="navbarDropdown">
							<li class="dropdown-item-text" style="color: white;"><span
								class="fw-bold"><%=userEmail%></span></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="orderhistory.jsp"> <i
									class="bi bi-clock-history me-2"></i>Order History
							</a></li>
							<li><a class="dropdown-item" href="feedbackhistory.jsp">
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

	<div class="container mx-auto px-4 py-8 max-w-4xl">
		<%
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String errorMessage = "";
		String successMessage = "";
		int currentProductId = 0;

		// Get productId from URL parameter
		String productId = request.getParameter("productId");

		try {
			conn = GetConnection.getConnection();

			if (productId != null && !productId.trim().isEmpty()) {
				// Product info section
				String productQuery = "SELECT * FROM products WHERE ProductID = ?";
				ps = conn.prepareStatement(productQuery);
				ps.setInt(1, Integer.parseInt(productId.trim()));
				rs = ps.executeQuery();

				if (rs.next()) {
			currentProductId = rs.getInt("ProductID");
		%>
		<!-- Product Details Card -->
		<div class="bg-white rounded-lg shadow-lg p-6 mt-10 mb-8">
			<h1 class="text-3xl font-bold text-gray-900 mb-4">
				<%=rs.getString("Name")%>
			</h1>

			<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
				<div>
					<p class="text-gray-600 mb-2">Category</p>
					<p class="text-gray-900 font-medium">
						<%=rs.getString("Category")%>
					</p>
				</div>

				<div>
					<p class="text-gray-600 mb-2">Price</p>
					<p class="text-gray-900 font-medium">
						$<%=rs.getDouble("SellingPrice")%>
					</p>
				</div>

				<div>
					<p class="text-gray-600 mb-2">Stock</p>
					<p class="text-gray-900 font-medium"
						data-stock-id="<%=currentProductId%>">
						<%=rs.getInt("Stock")%>
						units
					</p>
				</div>

				<div>
					<p class="text-gray-600 mb-2">Supplier</p>
					<p class="text-gray-900 font-medium">
						<%=rs.getString("SupplierInfo")%>
					</p>
				</div>
			</div>

			<!-- Quantity Controls and Add to Cart -->
			<!-- Quantity Controls -->
			<div class="mt-6">
				<div class="d-flex align-items-center justify-content-center mb-3">
					<div class="input-group w-[15vw] align-items-center">
						<button class="btn btn-sm btn-decrement text-white py-2 px-3"
							type="button" onclick="updateQuantity(<%=currentProductId%>, -1)"
							<%=rs.getInt("Stock") > 0 ? "" : "disabled"%>>&#8722;</button>

						<input type="number"
							class="form-control text-center no-spinner quantity-input"
							style="width: 70px;" id="quantity-<%=currentProductId%>"
							name="quantity" value="1" min="1" max="<%=rs.getInt("Stock")%>"
							<%=rs.getInt("Stock") > 0 ? "" : "disabled"%> readonly>

						<button class="btn btn-sm btn-increment text-white py-2 px-3"
							type="button" onclick="updateQuantity(<%=currentProductId%>, 1)"
							<%=rs.getInt("Stock") > 0 ? "" : "disabled"%>>&#43;</button>
					</div>
				</div>

				<button
					class="w-full btn-custom h-[50px] add-to-cart-btn"
					<%=rs.getInt("Stock") > 0 ? "" : "disabled"%>
					data-product-id="<%=rs.getInt("ProductID")%>"
					data-product-name="<%=rs.getString("Name")%>"
					data-product-price="<%=rs.getDouble("SellingPrice")%>">
					Add to Cart</button>
			</div>



			<%
			// Handle feedback submission
			if ("POST".equalsIgnoreCase(request.getMethod())) {
				String comments = request.getParameter("comments");
				String ratingStr = request.getParameter("rating");

				if (comments != null && ratingStr != null) {
					if (userEmail == null) {
				errorMessage = "Please login to submit a review.";
					} else if (comments.trim().isEmpty()) {
				errorMessage = "Feedback comments cannot be empty.";
					} else if (ratingStr.trim().isEmpty()) {
				errorMessage = "Rating is required.";
					} else {
				try {
					int rating = Integer.parseInt(ratingStr);
					if (rating < 1 || rating > 5) {
						errorMessage = "Rating must be between 1 and 5.";
					} else {
						// Get CustomerID using email
						String customerQuery = "SELECT CustomerID FROM customers WHERE Email = ?";
						PreparedStatement customerPs = conn.prepareStatement(customerQuery);
						customerPs.setString(1, userEmail);
						ResultSet customerRs = customerPs.executeQuery();

						if (customerRs.next()) {
							int customerId = customerRs.getInt("CustomerID");
							customerRs.close();
							customerPs.close();

							// Insert feedback
							String insertFeedbackQuery = "INSERT INTO feedback (ProductID, CustomerID, Comments, Rating, FeedbackDate) "
									+ "VALUES (?, ?, ?, ?, NOW())";
							PreparedStatement feedbackPs = conn.prepareStatement(insertFeedbackQuery);
							feedbackPs.setInt(1, currentProductId);
							feedbackPs.setInt(2, customerId);
							feedbackPs.setString(3, comments.trim());
							feedbackPs.setInt(4, rating);

							int result = feedbackPs.executeUpdate();
							feedbackPs.close();

							if (result > 0) {
								successMessage = "Thank you for your feedback!";
							} else {
								errorMessage = "Failed to submit feedback.";
							}
						} else {
							errorMessage = "Customer information not found.";
						}
					}
				} catch (NumberFormatException e) {
					errorMessage = "Invalid rating format.";
				}
					}
				}
			}

			// Display feedback section
			%>
			<br>
			<div class="bg-white rounded-lg shadow-lg p-6 mb-8">
				<h2 class="text-2xl font-bold text-gray-900 mb-6">Customer
					Reviews</h2>
				<%
				String feedbackQuery = "SELECT f.*, c.Name " + "FROM feedback f " + "JOIN customers c ON f.CustomerID = c.CustomerID "
						+ "WHERE f.ProductID = ? " + "ORDER BY f.FeedbackDate DESC";
				PreparedStatement feedbackPs = conn.prepareStatement(feedbackQuery);
				feedbackPs.setInt(1, currentProductId);
				ResultSet feedbackRs = feedbackPs.executeQuery();

				boolean hasFeedback = false;

				while (feedbackRs.next()) {
					hasFeedback = true;
					int rating = feedbackRs.getInt("Rating");
					String feedbackComments = feedbackRs.getString("Comments");
					Timestamp feedbackDate = feedbackRs.getTimestamp("FeedbackDate");
					String customerName = feedbackRs.getString("Name");
				%>
				<div
					class="border-b border-gray-200 pb-6 mb-6 last:border-0 last:pb-0 last:mb-0">
					<div class="flex justify-between items-center">
						<h3 class="text-lg font-medium text-gray-900">
							<%=customerName%>
						</h3>
						<div class="flex items-center space-x-1">
							<%
							for (int i = 1; i <= 5; i++) {
							%>
							<span class="star-rating <%=i <= rating ? "selected" : ""%>">
								&#9733; </span>
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
				feedbackRs.close();
				feedbackPs.close();

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
				<div class="error-message"><%=errorMessage%></div>
				<%
				}
				if (!successMessage.isEmpty()) {
				%>
				<div class="success-message"><%=successMessage%></div>
				<%
				}
				%>
				<h2 class="text-2xl font-bold text-gray-900 mb-6">Write a
					Review</h2>
				<form method="POST"
					action="productpage.jsp?productId=<%=currentProductId%>"
					class="space-y-4">
					<div>
						<label class="block text-gray-700 mb-2">Rating</label>
						<div class="flex space-x-1" id="rating-stars">
							<%
							for (int i = 1; i <= 5; i++) {
							%>
							<span class="star-rating" data-rating="<%=i%>"
								onclick="setRating(<%=i%>)"> &#9733; </span>
							<%
							}
							%>
						</div>
						<input type="hidden" name="rating" id="rating-input" value="">
					</div>

					<div>
						<label for="comments" class="block text-gray-700 mb-2">Comments</label>
						<textarea id="comments" name="comments" rows="4"
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
							required></textarea>
					</div>

					<button type="submit"
						class="w-full btn-custom h-[50px]">
						Submit Review</button>
				</form>
				<%
				}
				%>
			</div>
			<%
			} else {
			response.sendRedirect("home.jsp");
			return;
			}
			} else {
			response.sendRedirect("home.jsp");
			return;
			}
			} catch (Exception e) {
			e.printStackTrace();
			errorMessage = "An error occurred while processing your request.";
			} finally {
			if (rs != null)
			try {
			rs.close();
			} catch (SQLException e) {
			}
			if (ps != null)
			try {
			ps.close();
			} catch (SQLException e) {
			}
			if (conn != null)
			try {
			conn.close();
			} catch (SQLException e) {
			}
			}
			%>


			<script
				src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>