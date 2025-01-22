package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import operations.Authentication_Operations;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final Authentication_Operations authOps = Authentication_Operations.getInstance();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String targetMailID = request.getParameter("mailID");

		HttpSession session = request.getSession();
		String adminMailID = (String) session.getAttribute("mailID");
		String role = (String) session.getAttribute("role");

		if (adminMailID == null || !role.equalsIgnoreCase("admin")) {
			request.setAttribute("errorMessage", "Unauthorized access: Admin privileges required");
			request.getRequestDispatcher("login.jsp").forward(request, response);
			return;
		}

		boolean success = false;
		String message = "";

		if ("deactivate".equalsIgnoreCase(action)) {
			success = authOps.deactivateUser(targetMailID);
			message = success ? "User deactivated successfully" : "Failed to deactivate user";
		} else if ("reactivate".equalsIgnoreCase(action)) {
			success = authOps.reactivateUser(targetMailID);
			message = success ? "User reactivated successfully" : "Failed to reactivate user";
		} else {
			message = "Invalid action requested";
		}

		request.setAttribute(success ? "successMessage" : "errorMessage", message + ": " + targetMailID);
		request.getRequestDispatcher("usermanagement.jsp").forward(request, response);
	}
}