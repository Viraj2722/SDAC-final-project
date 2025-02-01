<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        /* Dark Theme */
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #121212;
            color: #e0e0e0;
            padding: 1rem;
        }

        /* Card Container */
        .card {
            width: 100%;
            max-width: 400px;
            background: #1e1e1e;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        /* Header Styles */
        .header {
            padding: 2rem 2rem 1.5rem;
            text-align: center;
        }

        .logo-container {
            width: 4rem;
            height: 4rem;
            margin: 0 auto 1.25rem;
            background: #3a3a3a;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-container svg {
            width: 2.25rem;
            height: 2.25rem;
            color: #bb86fc;
        }

        .title {
            font-size: 1.75rem;
            font-weight: 600;
            color: #bb86fc;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #9e9e9e;
            font-size: 1rem;
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
            font-size: 0.9375rem;
            font-weight: 500;
            color: #bb86fc;
            margin-bottom: 0.375rem;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 0.625rem 0.875rem;
            border: 1px solid #3a3a3a;
            border-radius: 0.375rem;
            font-size: 1rem;
            background: #2a2a2a;
            color: #e0e0e0;
            transition: border-color 0.2s ease;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #bb86fc;
        }

        /* Button Styles */
        .submit-button {
            width: 100%;
            padding: 0.75rem;
            background: #bb86fc;
            color: #121212;
            border: none;
            border-radius: 0.375rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease;
            position: relative;
        }

        .submit-button:hover {
            background: #a174e8;
        }

        .submit-button:active {
            background: #8758e0;
        }

        /* Error Message */
        .error-message {
            background: #cf6679;
            color: #121212;
            padding: 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.9375rem;
            margin-bottom: 1.25rem;
        }

        /* Links */
        .signup-link {
            text-align: center;
            font-size: 0.9375rem;
            margin-top: 1.25rem;
            color: #9e9e9e;
        }

        .signup-link a {
            color: #bb86fc;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .signup-link a:hover {
            color: #a174e8;
        }

        /* Loading Animation */
        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .submit-button .spinner {
            display: none;
            position: absolute;
            left: 50%;
            top: 50%;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #121212;
            border-top-color: transparent;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            animation: spin 0.75s linear infinite;
        }

        .loading .submit-button {
            color: transparent;
        }

        .loading .submit-button .spinner {
            display: block;
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
            <p class="subtitle">Sign in to your account</p>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="LoginServlet" method="POST" id="loginForm">
                <div class="form-group">
                    <label class="form-label" for="mailID">Email</label>
                    <input type="email" id="mailID" name="mailID" class="form-input" placeholder="name@example.com" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="role">Role</label>
                    <select id="role" name="role" class="form-select" required>
                        <option value="admin">Admin</option>
                        <option value="customer">Customer</option>
                    </select>
                </div>

                <button type="submit" class="submit-button">
                    <span class="button-text">Sign In</span>
                    <span class="spinner"></span>
                </button>

                <div class="signup-link">
                    No account? <a href="signup.jsp">Create one</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const button = this.querySelector('.submit-button');
            const buttonText = button.querySelector('.button-text');
            buttonText.textContent = 'Signing in...';
            button.classList.add('loading');
        });
    </script>
</body>
</html>

