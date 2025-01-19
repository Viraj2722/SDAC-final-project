package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import operations.Feedback_Operations;
import org.json.JSONObject;

@WebServlet(name = "DeleteFeedbackServlet", urlPatterns = {"/DeleteFeedbackServlet"})
public class DeleteFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            // Add debug logging
            System.out.println("DeleteFeedbackServlet received request");
            String feedbackIdParam = request.getParameter("feedbackId");
            System.out.println("Feedback ID received: " + feedbackIdParam);

            if (feedbackIdParam == null || feedbackIdParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Feedback ID is required");
            }

            int feedbackId = Integer.parseInt(feedbackIdParam);
            Feedback_Operations operations = new Feedback_Operations();

            boolean deleted = operations.deleteFeedback(feedbackId);
            System.out.println("Delete operation result: " + deleted);

            if (deleted) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Feedback deleted successfully");
                jsonResponse.put("feedbackId", feedbackId);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to delete feedback");
            }

        } catch (NumberFormatException e) {
            System.err.println("Invalid feedback ID format: " + e.getMessage());
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid feedback ID format");
        } catch (Exception e) {
            System.err.println("Error in DeleteFeedbackServlet: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error: " + e.getMessage());
        }

        out.print(jsonResponse.toString());
        out.flush();
    }
}