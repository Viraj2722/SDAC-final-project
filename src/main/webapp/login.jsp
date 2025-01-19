<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        /* Background Gradient */
        body {
            background: linear-gradient(to right, #6a11cb, #2575fc);
            font-family: 'Arial', sans-serif;
            color: #fff;
        }

        /* Card Styling */
        .card {
            border: none;
            border-radius: 15px;
            background: #ffffff;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        /* Button Styling */
        .btn-primary {
            background: #6a11cb;
            border: none;
            font-weight: bold;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .btn-primary:hover {
            background: #2575fc;
            transform: scale(1.05);
        }

        /* Input Field Focus Effect */
        .form-control:focus {
            box-shadow: 0 0 8px rgba(106, 17, 203, 0.6);
            border-color: #6a11cb;
        }

        /* Links */
        .text-center a {
            color: #6a11cb;
            text-decoration: none;
            transition: color 0.3s ease, text-shadow 0.3s ease;
        }

        .text-center a:hover {
            color: #2575fc;
            text-shadow: 0 0 5px rgba(37, 117, 252, 0.6);
        }

        /* Logo Styling */
        .logo {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        /* Subtle Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: fadeIn 0.6s ease;
        }
    </style>
</head>

<body>
    <div class="container vh-100 d-flex justify-content-center align-items-center">
        <div class="card p-4 fade-in" style="width: 100%; max-width: 450px;">
            <div class="text-center mb-4">
                <img src="https://via.placeholder.com/80" alt="Logo" class="logo">
            </div>
            
            <p class="text-center text-muted">Login to access your account</p>

            <!-- Display error message if login fails -->
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="alert alert-danger text-center" role="alert">
                    <%= errorMessage %>
                </div>
            <%
                }
            %>

            <!-- Login form with Role dropdown -->
            <form action="LoginServlet" method="POST">
                <div class="mb-3">
                    <label for="mailID" class="form-label">Email Address</label>
                    <input type="email" name="mailID" id="mailID" class="form-control" placeholder="Enter your email"
                        required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control"
                        placeholder="Enter your password" required>
                </div>

                <!-- Role Dropdown -->
                <div class="mb-4">
                    <label for="role" class="form-label">Role</label>
                    <select name="role" id="role" class="form-select" required>
                        <option value="admin">Admin</option>
                        <option value="customer">Customer</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2">Login</button>
            </form>

            <p class="text-center mt-3">
                Don't have an account? <a href="signup.jsp">Sign up here</a>.
            </p>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>