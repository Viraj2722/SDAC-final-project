<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Dark Portal</title>
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

        .form-input {
            width: 100%;
            padding: 0.625rem 0.875rem;
            border: 1px solid #3a3a3a;
            border-radius: 0.375rem;
            font-size: 1rem;
            background: #2a2a2a;
            color: #e0e0e0;
            transition: border-color 0.2s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #bb86fc;
        }

        /* Password requirements styles */
        .password-requirements {
            font-size: 0.8125rem;
            color: #9e9e9e;
            margin-top: 0.75rem;
            padding: 0.75rem;
            border: 1px solid #3a3a3a;
            border-radius: 0.375rem;
            background: #2a2a2a;
        }

        .requirement {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.25rem;
        }

        .requirement:before {
            content: '•';
            color: #9e9e9e;
        }

        .requirement.valid {
            color: #69f0ae;
        }

        .requirement.valid:before {
            content: '✓';
            color: #69f0ae;
        }

        .requirement.invalid {
            color: #ff5252;
        }

        .requirement.invalid:before {
            content: '•';
            color: #ff5252;
        }

        /* Password strength indicator */
        .password-strength {
            height: 4px;
            background: #3a3a3a;
            margin-top: 0.5rem;
            border-radius: 2px;
            overflow: hidden;
        }

        .strength-meter {
            height: 100%;
            width: 0;
            transition: width 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak { background: #ff5252; width: 33.33%; }
        .strength-medium { background: #ffd740; width: 66.66%; }
        .strength-strong { background: #69f0ae; width: 100%; }

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

        .submit-button:disabled {
            background: #4a4a4a;
            color: #9e9e9e;
            cursor: not-allowed;
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
        .login-link {
            text-align: center;
            font-size: 0.9375rem;
            margin-top: 1.25rem;
            color: #9e9e9e;
        }

        .login-link a {
            color: #bb86fc;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .login-link a:hover {
            color: #a174e8;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #bb86fc;
            cursor: pointer;
            font-size: 0.875rem;
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
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <line x1="19" y1="8" x2="19" y2="14"></line>
                    <line x1="22" y1="11" x2="16" y2="11"></line>
                </svg>
            </div>
            <h1 class="title">Create Account</h1>
            <p class="subtitle">Join us by creating your account today</p>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="SignUpServlet" method="POST" id="signupForm">
                <div class="form-group">
                    <label class="form-label" for="mailID">Email Address</label>
                    <input type="email" id="mailID" name="mailID" class="form-input" placeholder="name@example.com" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="name">Full Name</label>
                    <input type="text" id="name" name="name" class="form-input" placeholder="Enter your full name" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div style="position: relative;">
                        <input type="password" id="password" name="password" class="form-input" 
                               placeholder="Create a secure password" required
                               pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}"
                               title="Password must meet all requirements below">
                        <button type="button" class="toggle-password">Show</button>
                    </div>
                    <div class="password-strength">
                        <div class="strength-meter"></div>
                    </div>
                    <div class="password-requirements">
                        <div class="requirement" id="length-requirement">At least 8 characters long</div>
                        <div class="requirement" id="uppercase-requirement">At least one uppercase letter</div>
                        <div class="requirement" id="lowercase-requirement">At least one lowercase letter</div>
                        <div class="requirement" id="number-requirement">At least one number</div>
                        <div class="requirement" id="special-requirement">At least one special character (@$!%*?&)</div>
                    </div>
                </div>

                <button type="submit" class="submit-button" disabled>
                    <span class="button-text">Create Account</span>
                    <span class="spinner"></span>
                </button>

                <div class="login-link">
                    Already have an account? <a href="login.jsp">Sign in</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        const form = document.getElementById('signupForm');
        const passwordInput = document.getElementById('password');
        const submitButton = document.querySelector('.submit-button');
        const strengthMeter = document.querySelector('.strength-meter');
        const togglePassword = document.querySelector('.toggle-password');
        
        // Get all requirement elements
        const requirements = {
            length: document.getElementById('length-requirement'),
            uppercase: document.getElementById('uppercase-requirement'),
            lowercase: document.getElementById('lowercase-requirement'),
            number: document.getElementById('number-requirement'),
            special: document.getElementById('special-requirement')
        };

        function validatePassword(password) {
            // Define validation criteria
            const criteria = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /\d/.test(password),
                special: /[@$!%*?&]/.test(password)
            };

            // Update requirement visual feedback
            Object.keys(criteria).forEach(criterion => {
                const element = requirements[criterion];
                if (criteria[criterion]) {
                    element.classList.add('valid');
                    element.classList.remove('invalid');
                } else {
                    element.classList.add('invalid');
                    element.classList.remove('valid');
                }
            });

            // Calculate password strength
            const strength = Object.values(criteria).filter(Boolean).length;
            strengthMeter.className = 'strength-meter';
            if (strength >= 4) {
                strengthMeter.classList.add('strength-strong');
            } else if (strength >= 3) {
                strengthMeter.classList.add('strength-medium');
            } else if (strength > 0) {
                strengthMeter.classList.add('strength-weak');
            }

            // Enable/disable submit button based on all criteria being met
            const isValid = Object.values(criteria).every(Boolean);
            submitButton.disabled = !isValid;
            
            return isValid;
        }

        // Real-time validation
        passwordInput.addEventListener('input', function(e) {
            validatePassword(this.value);
        });

        // Toggle password visibility
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.textContent = type === 'password' ? 'Show' : 'Hide';
        });

        // Form submission handling
        form.addEventListener('submit', function(e) {
            if (!validatePassword(passwordInput.value)) {
                e.preventDefault();
                return;
            }

            const button = this.querySelector('.submit-button');
            const buttonText = button.querySelector('.button-text');
            buttonText.textContent = 'Creating Account...';
            button.classList.add('loading');
        });
    </script>
</body>
</html>

