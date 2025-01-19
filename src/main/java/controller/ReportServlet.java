package controller;

import operations.Algo_Operations;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private final Algo_Operations algoOperations = new Algo_Operations();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Get all analysis data in one call using the previously refactored Algo_Operations class
        Map<String, String> analysisResults = algoOperations.getAllAnalysisData();
        
        // Set all attributes
        for (Map.Entry<String, String> entry : analysisResults.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }
        
        // Forward to report.jsp
        req.getRequestDispatcher("report.jsp").forward(req, resp);
    }
}