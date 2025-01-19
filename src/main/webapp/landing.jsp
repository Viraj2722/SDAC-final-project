<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP System - Landing Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            background: linear-gradient(to right, #6a11cb, #2575fc);
            font-family: 'Arial', sans-serif;
            color: #fff;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            padding: 40px;
            text-align: center;
            width: 90%;
            max-width: 400px;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(to right, #6a11cb, #2575fc);
            z-index: -1;
            transform: rotate(45deg);
            animation: gradient-rotate 6s linear infinite;
            filter: blur(20px);
        }

        @keyframes gradient-rotate {
            0% {
                transform: rotate(45deg);
            }
            100% {
                transform: rotate(405deg);
            }
        }

        .card h1 {
            color: #6a11cb;
            font-weight: bold;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        .card p {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 30px;
        }

        .btn {
            width: 200px;
            font-weight: bold;
            padding: 12px 20px;
            border-radius: 8px;
            background: #6a11cb;
            border: none;
            color: #fff;
            margin: 10px 0;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .btn:hover {
            background: #2575fc;
            transform: scale(1.05);
            box-shadow: 0 4px 15px rgba(37, 117, 252, 0.6);
        }

        .btn:focus {
            outline: none;
            box-shadow: 0 0 10px rgba(106, 17, 203, 0.8);
        }
    </style>
</head>

<body>
    <div class="card">
        <h1>Welcome to the ERP System</h1>
        <p>Please choose an option to proceed:</p>

        <!-- Login Button -->
        <a href="login.jsp">
            <button class="btn">Login</button>
        </a>	

        <!-- Sign Up Button -->
        <a href="signup.jsp">
            <button class="btn">Sign Up</button>
        </a>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>