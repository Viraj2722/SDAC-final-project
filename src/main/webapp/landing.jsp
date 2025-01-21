<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to ERP</title>
    <style>
        /* Reset and base styles */
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #0f172a;
            color: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            overflow-x: hidden;
        }

        .container {
            max-width: 28rem;
            width: 100%;
            text-align: center;
            z-index: 10;
            position: relative;
        }

        h1 {
            font-size: 2.25rem;
            font-weight: 800;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        p {
            font-size: 1.125rem;
            color: #94a3b8;
            margin-bottom: 2rem;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .button {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: 0.375rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .button-primary {
            background-color: #f8fafc;
            color: #0f172a;
        }

        .button-primary:hover {
            background-color: #e2e8f0;
        }

        .button-secondary {
            background-color: transparent;
            color: #f8fafc;
            border: 1px solid #334155;
        }

        .button-secondary:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        /* Particle styles */
        .particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        .particle {
            position: absolute;
            width: 6px;
            height: 6px;
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
        }

        @media (min-width: 640px) {
            h1 {
                font-size: 3rem;
            }
        }
    </style>
</head>
<body>
    <div class="particles" id="particles"></div>
    <div class="container">
        <h1>Welcome to ERP</h1>
        <p>Your complete business management solution</p>
        <div class="button-container">
            <a href="login.jsp" class="button button-primary">Login to Your Account</a>
            <a href="signup.jsp" class="button button-secondary">Create New Account</a>
        </div>
    </div>

    <script>
        // Particle animation
        const particlesContainer = document.getElementById('particles');
        const particleCount = 50;

        function createParticle() {
            const particle = document.createElement('div');
            particle.classList.add('particle');
            particle.style.left = Math.random() * 100 + 'vw';
            particle.style.top = Math.random() * 100 + 'vh';
            particle.style.opacity = Math.random();
            particle.style.animationDuration = Math.random() * 3 + 2 + 's';
            particlesContainer.appendChild(particle);

            setTimeout(() => {
                particle.remove();
                createParticle();
            }, parseFloat(particle.style.animationDuration) * 1000);
        }

        for (let i = 0; i < particleCount; i++) {
            setTimeout(createParticle, i * 100);
        }
    </script>
</body>
</html>