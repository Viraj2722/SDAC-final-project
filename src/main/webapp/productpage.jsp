<%@ page import="java.sql.*, java.util.*"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Details</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<style>
.cart-item {
    transition: background-color 0.2s;
}

.cart-item:hover {
    background-color: #f8f9fa;
}

.cart-notification {
    animation: fadeInOut 3s ease-in-out;
}

@keyframes fadeInOut {
    0% { opacity: 0; }
    10% { opacity: 1; }
    90% { opacity: 1; }
    100% { opacity: 0; }
}

.item-details {
    flex-grow: 1;
}

.item-name {
    font-weight: 500;
}

.item-price {
    font-size: 0.9em;
}

.cart-total {
    margin-top: 1rem;
    border-top: 2px solid #dee2e6;
}
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

.navbar-nav {
	display: flex !important;
	align-items: center;
}

@media ( max-width : 991px) {
	.navbar-collapse {
		display: none;
	}
	.navbar-collapse.show {
		display: block;
	}
}

.success-message {
	color: #10b981;
	margin-top: 0.5rem;
	font-size: 0.875rem;
}

.no-spinner {
	-moz-appearance: textfield;
}

.no-spinner::-webkit-inner-spin-button, .no-spinner::-webkit-outer-spin-button
	{
	-webkit-appearance: none;
	margin: 0;
}

/* Button Styles */
.btn-decrement, .btn-increment {
	background-color: #007bff;
	border: 1px solid #007bff;
	transition: all 0.3s ease;
}

.btn-decrement:hover, .btn-increment:hover {
	background-color: #0056b3;
	border-color: #0056b3;
	transform: scale(1.1);
	cursor: pointer;
}

.btn-decrement:disabled, .btn-increment:disabled {
	background-color: #d6d6d6;
	border-color: #d6d6d6;
	cursor: not-allowed;
}

.quantity-input {
	font-size: 1rem;
	font-weight: bold;
	color: #333;
}

.quantity-input:focus {
	border-color: #007bff;
	box-shadow: 0 0 3px rgba(0, 123, 255, 0.5);
}

@media ( max-width : 576px) {
	.btn-decrement, .btn-increment {
		padding: 0.5rem;
	}
	.quantity-input {
		width: 50px;
	}
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
    </script>
</head>
<body class="bg-gray-50">
	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="home.jsp">ShopHub</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav"
				aria-controls="navbarNav" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto">
				<li class="nav-item">
                        <a class="nav-link" href="homepage.jsp">
                            <i class="fas fa-home"></i> Home
                        </a>
                    </li>
					<li class="nav-item"><a class="nav-link" href="#"><i
							class="fas fa-user"></i> Account</a></li>
					<li class="nav-item"><a class="nav-link" href="#"
						data-bs-toggle="modal" data-bs-target="#cartModal"> <i
							class="fas fa-shopping-cart"></i> Cart
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
				<div class="modal-header bg-gray-100">
					<h5 class="modal-title" id="cartModalLabel">
						<i class="fas fa-shopping-cart me-2"></i>Shopping Cart
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body p-0">
					<div id="cartItems" class="p-4">
						<!-- Cart items will be dynamically inserted here -->
					</div>
					<div class="p-4 bg-gray-50">
						<div class="d-flex justify-content-between align-items-center">
							<span class="text-lg font-semibold">Subtotal:</span> <strong
								id="cartTotal" class="text-xl text-primary">$0.00</strong>
						</div>
						<p class="text-gray-600 text-sm mt-2">Shipping and taxes
							calculated at checkout</p>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary"
						data-bs-dismiss="modal">Continue Shopping</button>
					<button onclick="processCheckout()" class="btn btn-primary">
						<i class="fas fa-lock me-2"></i>Checkout
					</button>
				</div>

				<!-- Add new payment modal -->
				<div class="modal fade" id="paymentModal" tabindex="-1"
					aria-labelledby="paymentModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
							<div class="modal-header bg-gray-100">
								<h5 class="modal-title" id="paymentModalLabel">
									<i class="fas fa-credit-card me-2"></i>Select Payment Method
								</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"></button>
							</div>
							<div class="modal-body p-4">
								<div class="space-y-4">
									<!-- Cash Payment -->
									<button onclick="processPurchase('Cash')"
										class="w-full p-4 text-left border rounded-lg hover:bg-gray-50 transition-colors duration-200 flex items-center space-x-3">
										<i class="fas fa-money-bill-wave text-green-600 text-2xl"></i>
										<span class="font-medium">Cash Payment</span>
									</button>

									<!-- Card Payment -->
									<button onclick="processPurchase('Card')"
										class="w-full p-4 text-left border rounded-lg hover:bg-gray-50 transition-colors duration-200 flex items-center space-x-3">
										<i class="fas fa-credit-card text-blue-600 text-2xl"></i> <span
											class="font-medium">Card Payment</span>
									</button>

									<!-- UPI Payment -->
									<button onclick="processPurchase('UPI')"
										class="w-full p-4 text-left border rounded-lg hover:bg-gray-50 transition-colors duration-200 flex items-center space-x-3">
										<i class="fas fa-mobile-alt text-purple-600 text-2xl"></i> <span
											class="font-medium">UPI Payment</span>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

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
		int currentProductId = 0;

		// Get productId from URL parameter
		String productId = request.getParameter("productId");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

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
		<div class="bg-white rounded-lg shadow-lg p-6 mb-8">
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
                    type="button"
                    onclick="updateQuantity(<%=currentProductId%>, -1)"
                    <%= rs.getInt("Stock") > 0 ? "" : "disabled" %>>
                &#8722;
            </button>

            <input type="number"
                   class="form-control text-center no-spinner quantity-input"
                   style="width: 70px;"
                   id="quantity-<%=currentProductId%>"
                   name="quantity"
                   value="1"
                   min="1"
                   max="<%= rs.getInt("Stock") %>"
                   <%= rs.getInt("Stock") > 0 ? "" : "disabled" %>
                   readonly>

            <button class="btn btn-sm btn-increment text-white py-2 px-3"
                    type="button"
                    onclick="updateQuantity(<%=currentProductId%>, 1)"
                    <%= rs.getInt("Stock") > 0 ? "" : "disabled" %>>
                &#43;
            </button>
        </div>
    </div>

    <button
					class="w-full bg-blue-600 text-white py-3 px-6 rounded-lg hover:bg-blue-700 transition duration-200 add-to-cart-btn"
					<%= rs.getInt("Stock") > 0 ? "" : "disabled" %>
					data-product-id="<%= rs.getInt("ProductID") %>"
					data-product-name="<%= rs.getString("Name") %>"
					data-product-price="<%= rs.getDouble("SellingPrice") %>">
					Add to Cart</button>
</div>
	


	<%
	// Handle feedback submission
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		String comments = request.getParameter("comments");
		String ratingStr = request.getParameter("rating");
		String userEmail = (String) session.getAttribute("mailID");

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
		<div class="error-message"><%=errorMessage%></div>
		<%
		}
		if (!successMessage.isEmpty()) {
		%>
		<div class="success-message"><%=successMessage%></div>
		<%
		}
		%>
		<h2 class="text-2xl font-bold text-gray-900 mb-6">Write a Review</h2>
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
				class="w-full bg-blue-600 text-white py-3 px-6 rounded-lg hover:bg-blue-700 transition duration-200">
				Submit Review</button>
		</form>
		<%
		}
		%>
	</div>
	<%
	} else {
	response.sendRedirect("homepage.jsp");
	return;
	}
	} else {
	response.sendRedirect("homepage.jsp");
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