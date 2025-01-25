<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="db.GetConnection" %>
<%
// Check if user is logged in
HttpSession userSession = request.getSession(false);
if (userSession == null || userSession.getAttribute("mailID") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String userEmail = (String) userSession.getAttribute("mailID");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History - ElementStore</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        border: "hsl(var(--border))",
                        input: "hsl(var(--input))",
                        ring: "hsl(var(--ring))",
                        background: "hsl(var(--background))",
                        foreground: "hsl(var(--foreground))",
                        primary: {
                            DEFAULT: "hsl(var(--primary))",
                            foreground: "hsl(var(--primary-foreground))",
                        },
                        secondary: {
                            DEFAULT: "hsl(var(--secondary))",
                            foreground: "hsl(var(--secondary-foreground))",
                        },
                        destructive: {
                            DEFAULT: "hsl(var(--destructive))",
                            foreground: "hsl(var(--destructive-foreground))",
                        },
                        muted: {
                            DEFAULT: "hsl(var(--muted))",
                            foreground: "hsl(var(--muted-foreground))",
                        },
                        accent: {
                            DEFAULT: "hsl(var(--accent))",
                            foreground: "hsl(var(--accent-foreground))",
                        },
                        popover: {
                            DEFAULT: "hsl(var(--popover))",
                            foreground: "hsl(var(--popover-foreground))",
                        },
                        card: {
                            DEFAULT: "hsl(var(--card))",
                            foreground: "hsl(var(--card-foreground))",
                        },
                    },
                    borderRadius: {
                        lg: "var(--radius)",
                        md: "calc(var(--radius) - 2px)",
                        sm: "calc(var(--radius) - 4px)",
                    },
                },
            },
        }
    </script>
    <style type="text/css">
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        
        :root {
            --background: 0 0% 100%;
            --foreground: 240 10% 3.9%;
            --card: 0 0% 100%;
            --card-foreground: 240 10% 3.9%;
            --popover: 0 0% 100%;
            --popover-foreground: 240 10% 3.9%;
            --primary: 240 5.9% 10%;
            --primary-foreground: 0 0% 98%;
            --secondary: 240 4.8% 95.9%;
            --secondary-foreground: 240 5.9% 10%;
            --muted: 240 4.8% 95.9%;
            --muted-foreground: 240 3.8% 46.1%;
            --accent: 240 4.8% 95.9%;
            --accent-foreground: 240 5.9% 10%;
            --destructive: 0 84.2% 60.2%;
            --destructive-foreground: 0 0% 98%;
            --border: 240 5.9% 90%;
            --input: 240 5.9% 90%;
            --ring: 240 5.9% 10%;
            --radius: 0.5rem;
        }

        .dark {
            --background: 240 10% 3.9%;
            --foreground: 0 0% 98%;
            --card: 240 10% 3.9%;
            --card-foreground: 0 0% 98%;
            --popover: 240 10% 3.9%;
            --popover-foreground: 0 0% 98%;
            --primary: 0 0% 98%;
            --primary-foreground: 240 5.9% 10%;
            --secondary: 240 3.7% 15.9%;
            --secondary-foreground: 0 0% 98%;
            --muted: 240 3.7% 15.9%;
            --muted-foreground: 240 5% 64.9%;
            --accent: 240 3.7% 15.9%;
            --accent-foreground: 0 0% 98%;
            --destructive: 0 62.8% 30.6%;
            --destructive-foreground: 0 0% 98%;
            --border: 240 3.7% 15.9%;
            --input: 240 3.7% 15.9%;
            --ring: 240 4.9% 83.9%;
        }
    </style>
</head>
<body class="bg-background text-foreground dark">
    <div class="min-h-screen">
        <!-- Navigation -->
        <nav class="bg-card/50 backdrop-blur-lg border-b border-border sticky top-0 z-40">
            <div class="container mx-auto px-4">
                <div class="flex items-center justify-between h-16">
                    <a href="#" class="text-2xl font-bold text-primary">ElementStore</a>
                    <div class="flex items-center space-x-4">
                        <a href="homepage.jsp" class="text-sm font-medium hover:text-primary transition-colors">
                            <i class="fas fa-home mr-2"></i> Home
                        </a>
                        <span class="text-sm font-medium">
                            <i class="fas fa-user mr-2"></i> <%=userEmail%>
                        </span>
                        <button onclick="logout()" class="text-sm font-medium text-destructive hover:text-destructive/80 transition-colors">
                            <i class="fas fa-sign-out-alt mr-2"></i> Logout
                        </button>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="container mx-auto px-4 py-8">
            <h1 class="text-4xl font-bold mb-2">Order History</h1>
            <p class="text-muted-foreground mb-8">Track your past purchases and leave reviews</p>

            <div class="bg-card rounded-lg shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead>
                            <tr class="bg-muted/50">
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Order ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Product</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Category</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Quantity</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Total Amount</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Payment Method</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Order Date</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Action</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-border">
                            <%
                            try {
                                Connection conn = GetConnection.getConnection();

                                // First get the customer ID
                                PreparedStatement custStmt = conn.prepareStatement("SELECT CustomerID FROM customers WHERE Email = ?");
                                custStmt.setString(1, userEmail);
                                ResultSet custRs = custStmt.executeQuery();

                                if (custRs.next()) {
                                    int customerId = custRs.getInt("CustomerID");

                                    PreparedStatement orderStmt = conn.prepareStatement(
                                        "SELECT s.*, p.Name, p.Category, p.ProductID, " +
                                        "(SELECT COUNT(*) FROM feedback f WHERE f.ProductID = p.ProductID AND f.CustomerID = ?) as has_feedback " +
                                        "FROM sales s " +
                                        "JOIN products p ON s.ProductID = p.ProductID " +
                                        "WHERE s.CustomerID = ? " +
                                        "ORDER BY s.SaleDate DESC"
                                    );
                                    orderStmt.setInt(1, customerId);
                                    orderStmt.setInt(2, customerId);
                                    ResultSet orderRs = orderStmt.executeQuery();

                                    boolean hasOrders = false;

                                    while (orderRs.next()) {
                                        hasOrders = true;
                                        boolean hasReviewed = orderRs.getInt("has_feedback") > 0;
                            %>
                            <tr class="hover:bg-muted/50 transition-colors">
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%=orderRs.getInt("SaleID")%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%=orderRs.getString("Name")%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%=orderRs.getString("Category")%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%=orderRs.getInt("Quantity")%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">$<%=String.format("%.2f", orderRs.getDouble("TotalAmount"))%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%=orderRs.getString("PaymentMethod")%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm"><%=orderRs.getTimestamp("SaleDate")%></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                    <% if (hasReviewed) { %>
                                        <button class="px-3 py-2 rounded-md bg-secondary text-secondary-foreground text-xs font-medium" disabled>
                                            <i class="fas fa-check mr-1"></i> Reviewed
                                        </button>
                                    <% } else { %>
                                        <a href="productpage.jsp?productId=<%=orderRs.getInt("ProductID")%>" 
                                           class="px-3 py-2 rounded-md bg-primary text-primary-foreground text-xs font-medium hover:bg-primary/90 transition-colors">
                                            <i class="fas fa-star mr-1"></i> Rate & Review
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }

                                    if (!hasOrders) {
                            %>
                            <tr>
                                <td colspan="8" class="px-6 py-24 text-center">
                                    <div class="space-y-4">
                                        <i class="fas fa-shopping-cart text-6xl text-muted-foreground"></i>
                                        <h5 class="text-xl font-semibold">No orders found</h5>
                                        <p class="text-muted-foreground">Start shopping to see your orders here!</p>
                                        <a href="homepage.jsp" class="inline-block px-6 py-3 rounded-md bg-primary text-primary-foreground font-medium hover:bg-primary/90 transition-colors">
                                            Browse Products
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }

                                    orderRs.close();
                                    orderStmt.close();
                                }

                                custRs.close();
                                custStmt.close();
                                conn.close();

                            } catch (Exception e) {
                                out.println("<tr><td colspan='8' class='px-6 py-4 text-center text-destructive'>Error: " + e.getMessage() + "</td></tr>");
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script>
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'LogoutServlet';
            }
        }
    </script>
</body>
</html>