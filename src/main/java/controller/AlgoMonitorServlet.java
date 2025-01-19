package controller;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import db.GetConnection;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AlgoMonitorServlet")
public class AlgoMonitorServlet extends HttpServlet {
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Set response type to JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        // Get the requested algorithm parameter
        String requestedAlgo = req.getParameter("algo");
        if (requestedAlgo == null || requestedAlgo.trim().isEmpty()) {
            resp.getWriter().write("[]");
            return;
        }

        String jsonResult = "[]";

        try (Connection conn = GetConnection.getConnection()) {
            try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
                stmt.setString(1, requestedAlgo);
                boolean hasResults = stmt.execute();

                // Skip summary result set
                if (hasResults) {
                    ResultSet summaryRs = stmt.getResultSet();
                    summaryRs.close();
                }

                // Get actual results
                hasResults = stmt.getMoreResults();
                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        if (rs.next()) {
                            jsonResult = rs.getString("Results");
                            try {
                                JsonElement jsonElement = gson.fromJson(jsonResult, JsonElement.class);
                                if (jsonElement.isJsonNull()) {
                                    jsonResult = "[]";
                                }
                            } catch (Exception e) {
                                System.out.println("Invalid JSON detected for " + requestedAlgo + ": " + e.getMessage());
                                jsonResult = "[]";
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error in AlgoMonitorServlet: " + e.getMessage());
            e.printStackTrace();
            jsonResult = "[]";
        }

        // Write the JSON response directly
        resp.getWriter().write(jsonResult);
    }
}