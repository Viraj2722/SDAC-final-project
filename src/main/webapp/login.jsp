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
            font-family: 'Segoe UI', system-ui, sans-serif;
        }

        /* Modern Gradient Background */
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #6366f1, #a855f7, #ec4899);
            padding: 1rem;
        }

        /* Card Container */
        .card {
            width: 100%;
            max-width: 420px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 1rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            transform: translateY(0);
            transition: transform 0.3s ease;
            animation: fadeIn 0.5s ease-out;
        }

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

        /* Header Styles */
        .header {
            padding: 2rem 2rem 1rem;
            text-align: center;
        }

        .logo-container {
            width: 4rem;
            height: 4rem;
            margin: 0 auto 1rem;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .logo-container svg {
            width: 2rem;
            height: 2rem;
            color: white;
        }

        .title {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #6b7280;
            font-size: 0.875rem;
        }

        /* Form Styles */
        .form-container {
            padding: 1.5rem 2rem 2rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
            position: relative;
        }

        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .input-container {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            width: 1rem;
            height: 1rem;
        }

        .form-input {
            width: 100%;
            padding: 0.625rem 0.75rem 0.625rem 2.5rem;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background: white;
        }

        .form-input:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .form-select {
            width: 100%;
            padding: 0.625rem 0.75rem;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            background: white;
            color: #374151;
            cursor: pointer;
        }

        .form-select:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        /* Button Styles */
        .submit-button {
            width: 100%;
            padding: 0.75rem;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            color: white;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .submit-button:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .submit-button:active {
            transform: translateY(0);
        }

        /* Error Message */
        .error-message {
            background: #fee2e2;
            border: 1px solid #fecaca;
            color: #ef4444;
            padding: 0.75rem;
            border-radius: 0.5rem;
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
            color: #6366f1;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .signup-link a:hover {
            color: #4f46e5;
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
            border: 2px solid white;
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
                    <div class="input-container">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                            <polyline points="22,6 12,13 2,6"></polyline>
                        </svg>
                        <input type="email" id="mailID" name="mailID" class="form-input" placeholder="name@example.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div class="input-container">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                    </div>
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