package operations;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import db.GetConnection;
import interfaces.Algo_Operations_Interface;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class Algo_Operations implements Algo_Operations_Interface {
    private static final Gson gson = new Gson();
    
    private String executeAnalysis(Connection conn, String analysisType) throws SQLException {
        String jsonResult = "[]";
        
        try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
            stmt.setString(1, analysisType);
            boolean hasResults = stmt.execute();

            hasResults = stmt.getMoreResults();

            if (hasResults) {
                try (ResultSet rs = stmt.getResultSet()) {
                    if (rs.next()) {
                        String rawJson = rs.getString("Results");
                        try {
                            JsonElement jsonElement = gson.fromJson(rawJson, JsonElement.class);
                            if (!jsonElement.isJsonNull()) {
                                jsonResult = rawJson;
                            }
                        } catch (Exception e) {
                            System.out.println("Invalid JSON detected for " + analysisType + ": " + e.getMessage());
                        }
                    }
                }
            }
        }
        
        return jsonResult;
    }
    
    public Map<String, String> getAllAnalysisData() {
        Map<String, String> results = new HashMap<>();
        results.put("salesData", "[]");
        results.put("abcData", "[]");
        results.put("inventoryData", "[]");
        results.put("demandData", "[]");
        results.put("profitData", "[]");
        
        try (Connection conn = GetConnection.getConnection()) {
            if (conn != null) {
                results.put("salesData", executeAnalysis(conn, "Sales Trend Analysis"));
                results.put("abcData", executeAnalysis(conn, "ABC Classification"));
                results.put("inventoryData", executeAnalysis(conn, "Inventory Turnover Analysis"));
                results.put("demandData", executeAnalysis(conn, "Demand Forecast Analysis"));
                results.put("profitData", executeAnalysis(conn, "Product Profitability Analysis"));
            }
        } catch (Exception e) {
            System.out.println("Error in getAllAnalysisData: " + e.getMessage());
            e.printStackTrace();
        }
        
        return results;
    }
    
    // Individual methods for specific analysis types
    public String getSalesTrendAnalysis() {
        try (Connection conn = GetConnection.getConnection()) {
            return conn != null ? executeAnalysis(conn, "Sales Trend Analysis") : "[]";
        } catch (Exception e) {
            System.out.println("Error in getSalesTrendAnalysis: " + e.getMessage());
            return "[]";
        }
    }
    
    public String getABCClassification() {
        try (Connection conn = GetConnection.getConnection()) {
            return conn != null ? executeAnalysis(conn, "ABC Classification") : "[]";
        } catch (Exception e) {
            System.out.println("Error in getABCClassification: " + e.getMessage());
            return "[]";
        }
    }
    
    public String getInventoryTurnoverAnalysis() {
        try (Connection conn = GetConnection.getConnection()) {
            return conn != null ? executeAnalysis(conn, "Inventory Turnover Analysis") : "[]";
        } catch (Exception e) {
            System.out.println("Error in getInventoryTurnoverAnalysis: " + e.getMessage());
            return "[]";
        }
    }
    
    public String getDemandForecastAnalysis() {
        try (Connection conn = GetConnection.getConnection()) {
            return conn != null ? executeAnalysis(conn, "Demand Forecast Analysis") : "[]";
        } catch (Exception e) {
            System.out.println("Error in getDemandForecastAnalysis: " + e.getMessage());
            return "[]";
        }
    }
    
    public String getProductProfitabilityAnalysis() {
        try (Connection conn = GetConnection.getConnection()) {
            return conn != null ? executeAnalysis(conn, "Product Profitability Analysis") : "[]";
        } catch (Exception e) {
            System.out.println("Error in getProductProfitabilityAnalysis: " + e.getMessage());
            return "[]";
        }
    }
}