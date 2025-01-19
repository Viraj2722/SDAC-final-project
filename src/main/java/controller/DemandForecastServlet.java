package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import operations.DemandForecastOperations;
import model.DemandForecastPojo;

@WebServlet("/DemandForecastServlet")
public class DemandForecastServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DemandForecastOperations operations = new DemandForecastOperations();
            List<DemandForecastPojo> forecastData = operations.getDemandForecastData();
            
            // Convert the data to JSON
            Gson gson = new Gson();
            String jsonData = gson.toJson(forecastData);
            
            // Set the JSON data as an attribute
            request.setAttribute("forecastDataJson", jsonData);
            
            // Forward to the JSP page
            request.getRequestDispatcher("/DemandForecast.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing forecast data");
        }
    }
}