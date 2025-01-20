<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP System - Welcome</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .card-container {
            position: relative;
            width: 100%;
            max-width: 480px;
            perspective: 1000px;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: none;
            border-radius: 24px;
            padding: 3rem 2rem;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            transform-style: preserve-3d;
            transition: transform 0.6s ease, box-shadow 0.6s ease;
        }

        .card:hover {
            transform: translateY(-10px) rotateX(5deg);
            box-shadow: 0 35px 60px -15px rgba(0, 0, 0, 0.3);
        }

        .glow {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 24px;
            background: linear-gradient(45deg, #6366f1, #4f46e5);
            filter: blur(20px);
            opacity: 0.5;
            z-index: -1;
            transition: all 0.6s ease;
        }

        .card:hover + .glow {
            transform: translateY(-10px) scale(1.05);
            opacity: 0.7;
        }

        .title {
            color: #1e293b;
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: titleFade 0.8s ease-out forwards;
        }

        .subtitle {
            color: #64748b;
            font-size: 1.1rem;
            margin-bottom: 2.5rem;
            animation: subtitleFade 0.8s ease-out 0.2s forwards;
            opacity: 0;
        }

        .btn-container {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            animation: buttonsFade 0.8s ease-out 0.4s forwards;
            opacity: 0;
        }

        .btn-action {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 1rem;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                rgba(255,255,255,0) 0%,
                rgba(255,255,255,0.2) 50%,
                rgba(255,255,255,0) 100%);
            transition: all 0.6s ease;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.2);
            color: white;
        }

        .btn-action:hover::before {
            left: 100%;
        }

        @keyframes titleFade {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes subtitleFade {
            from {
                opacity: 0;
                transform: translateY(-15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes buttonsFade {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }

        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            animation: float 6s infinite;
        }

        @keyframes float {
            0% {
                transform: translateY(0) translateX(0);
                opacity: 0;
            }
            50% {
                opacity: 1;
            }
            100% {
                transform: translateY(-100vh) translateX(100px);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <div class="particles">
        <script>
            for(let i = 0; i < 50; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                particle.style.left = Math.random() * 100 + 'vw';
                particle.style.animationDelay = Math.random() * 5 + 's';
                document.querySelector('.particles').appendChild(particle);
            }
        </script>
    </div>
	
    <div class="card-container">
        <div class="card">
            <h1 class="title">Welcome to ERP</h1>
            <p class="subtitle">Your complete business management solution</p>
            
            <div class="btn-container">
                <a href="login.jsp" class="btn-action">
                    Login to Your Account
                </a>
                <a href="signup.jsp" class="btn-action" style="background: linear-gradient(135deg, #4f46e5, #6366f1)">
                    Create New Account
                </a>
            </div>
        </div>
        <div class="glow"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>