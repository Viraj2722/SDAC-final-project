package operations;

import java.sql.*;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import db.GetConnection;
import model.DemandForecastPojo;

public class DemandForecastOperations {
    public List<DemandForecastPojo> getDemandForecastData() {
        List<DemandForecastPojo> forecastList = new ArrayList<>();
        String query = "SELECT Results FROM Logs WHERE AlgorithmName = 'demand forecast analysis' ORDER BY Timestamp DESC LIMIT 1";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            
            if (rs.next()) {
                String jsonResult = rs.getString("Results");
                Gson gson = new Gson();
                forecastList = gson.fromJson(jsonResult, new TypeToken<List<DemandForecastPojo>>(){}.getType());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return forecastList;
    }
}
