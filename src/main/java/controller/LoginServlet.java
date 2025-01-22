package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import operations.Authentication_Operations;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final Authentication_Operations authOps = Authentication_Operations.getInstance();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String mailID = request.getParameter("mailID");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

		if (authOps.isUserDeactivated(mailID)) {
			request.setAttribute("errorMessage", "Account is deactivated. Please contact admin.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
			return;
		}

		if (authOps.authenticateUser(mailID, password, role)) {
			HttpSession session = request.getSession();
			session.setAttribute("mailID", mailID);
			session.setAttribute("role", role);

			response.sendRedirect(role.equalsIgnoreCase("admin") ? "adminPanel.jsp" : "homepage.jsp");
		} else {
			request.setAttribute("errorMessage", "Invalid credentials or role!");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}
}