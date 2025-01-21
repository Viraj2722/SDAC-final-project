<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Modern Portal</title>
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        /* Modern Dark Theme */
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #000000;
            color: #ffffff;
            padding: 1rem;
        }

        /* Card Container */
        .card {
            width: 100%;
            max-width: 420px;
            background: #111111;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(255, 255, 255, 0.1), 0 2px 4px -1px rgba(255, 255, 255, 0.06);
            overflow: hidden;
        }

        /* Header Styles */
        .header {
            padding: 2rem 2rem 1rem;
            text-align: center;
        }

        .logo-container {
            width: 4rem;
            height: 4rem;
            margin: 0 auto 1rem;
            background: #ffffff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-container svg {
            width: 2rem;
            height: 2rem;
            color: #000000;
        }

        .title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #a0aec0;
            font-size: 0.875rem;
        }

        /* Form Styles */
        .form-container {
            padding: 1.5rem 2rem 2rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #e2e8f0;
            margin-bottom: 0.5rem;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 0.625rem 0.75rem;
            border: 1px solid #2d3748;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background: #1a202c;
            color: #ffffff;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #4a5568;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.5);
        }

        /* Button Styles */
        .submit-button {
            width: 100%;
            padding: 0.75rem;
            background: #4299e1;
            color: #ffffff;
            border: none;
            border-radius: 0.375rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .submit-button:hover {
            background: #3182ce;
        }

        .submit-button:active {
            background: #2b6cb0;
        }

        /* Error Message */
        .error-message {
            background: #742a2a;
            border: 1px solid #9b2c2c;
            color: #fed7d7;
            padding: 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        /* Links */
        .signup-link {
            text-align: center;
            font-size: 0.875rem;
            margin-top: 1rem;
        }

        .signup-link a {
            color: #4299e1;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .signup-link a:hover {
            color: #3182ce;
        }

        /* Loading Animation */
        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .loading .submit-button {
            position: relative;
            color: transparent;
        }

        .loading .submit-button::after {
            content: '';
            position: absolute;
            left: 50%;
            top: 50%;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #ffffff;
            border-top-color: transparent;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            animation: spin 0.75s linear infinite;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="header">
            <div class="logo-container">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
            </div>
            <h1 class="title">Welcome Back</h1>
            <p class="subtitle">Enter your credentials to access your account</p>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="LoginServlet" method="POST" id="loginForm">
                <div class="form-group">
                    <label class="form-label" for="mailID">Email Address</label>
                    <input type="email" id="mailID" name="mailID" class="form-input" placeholder="name@example.com" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="role">Role</label>
                    <select id="role" name="role" class="form-select" required>
                        <option value="admin">Admin</option>
                        <option value="customer">Customer</option>
                    </select>
                </div>

                <button type="submit" class="submit-button">Sign In</button>

                <div class="signup-link">
                    Don't have an account? <a href="signup.jsp">Sign up</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const button = this.querySelector('.submit-button');
            button.textContent = 'Signing in...';
            this.classList.add('loading');
        });
    </script>
</body>
</html>