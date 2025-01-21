<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Modern Portal</title>
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #000000;
            color: #ffffff;
            padding: 1rem;
        }

        .card {
            width: 100%;
            max-width: 420px;
            background: #111111;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(255, 255, 255, 0.1), 0 2px 4px -1px rgba(255, 255, 255, 0.06);
            overflow: hidden;
        }

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

        .form-input {
            width: 100%;
            padding: 0.625rem 0.75rem;
            border: 1px solid #2d3748;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            background: #1a202c;
            color: #ffffff;
        }

        .form-input:focus {
            outline: none;
            border-color: #4a5568;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.5);
        }

        /* Password requirements styles */
        .password-requirements {
            font-size: 0.75rem;
            color: #a0aec0;
            margin-top: 0.5rem;
            padding: 0.75rem;
            border: 1px solid #2d3748;
            border-radius: 0.375rem;
            background: #1a202c;
        }

        .requirement {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.25rem;
        }

        .requirement:before {
            content: '•';
            color: #718096;
        }

        .requirement.valid {
            color: #48bb78;
        }

        .requirement.valid:before {
            content: '✓';
            color: #48bb78;
        }

        .requirement.invalid {
            color: #f56565;
        }

        .requirement.invalid:before {
            content: '•';
            color: #f56565;
        }

        /* Password strength indicator */
        .password-strength {
            height: 4px;
            background: #2d3748;
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

        .strength-weak { background: #f56565; width: 33.33%; }
        .strength-medium { background: #ed8936; width: 66.66%; }
        .strength-strong { background: #48bb78; width: 100%; }

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

        .submit-button:disabled {
            background: #718096;
            cursor: not-allowed;
        }

        .error-message {
            background: #742a2a;
            border: 1px solid #9b2c2c;
            color: #fed7d7;
            padding: 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        .login-link {
            text-align: center;
            font-size: 0.875rem;
            margin-top: 1rem;
        }

        .login-link a {
            color: #4299e1;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .login-link a:hover {
            color: #3182ce;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #4299e1;
            cursor: pointer;
            font-size: 0.875rem;
        }

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

                <button type="submit" class="submit-button" disabled>Create Account</button>

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
            button.textContent = 'Creating Account...';
            this.classList.add('loading');
        });
    </script>
</body>
</html>