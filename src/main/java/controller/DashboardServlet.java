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

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String salesJsonResult = null;
        String abcJsonResult = null;
        String itrJsonResult = null;
        String dfJsonResult = null;
        String profitJsonResult = null;

        try (Connection conn = GetConnection.getConnection()) {
            // Get sales trend data
            try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
                stmt.setString(1, "Sales Trend Analysis");
                boolean hasResults = stmt.execute();

                if (hasResults) {
                    ResultSet summaryRs = stmt.getResultSet();
                    summaryRs.close();
                }

                hasResults = stmt.getMoreResults();

                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        if (rs.next()) {
                            salesJsonResult = rs.getString("Results");
                            try {
                                JsonElement jsonElement = gson.fromJson(salesJsonResult, JsonElement.class);
                                if (jsonElement.isJsonNull()) {
                                    salesJsonResult = "[]";
                                }
                            } catch (Exception e) {
                                System.out.println("Invalid JSON detected: " + e.getMessage());
                                salesJsonResult = "[]";
                            }
                        } else {
                            salesJsonResult = "[]";
                        }
                    }
                } else {
                    salesJsonResult = "[]";
                }
            }

            // Get ABC classification data
            try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
                stmt.setString(1, "ABC Classification");
                boolean hasResults = stmt.execute();

                if (hasResults) {
                    ResultSet summaryRs = stmt.getResultSet();
                    summaryRs.close();
                }

                hasResults = stmt.getMoreResults();

                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        if (rs.next()) {
                            abcJsonResult = rs.getString("Results");
                            try {
                                JsonElement jsonElement = gson.fromJson(abcJsonResult, JsonElement.class);
                                if (jsonElement.isJsonNull()) {
                                    abcJsonResult = "[]";
                                }
                            } catch (Exception e) {
                                System.out.println("Invalid ABC JSON detected: " + e.getMessage());
                                abcJsonResult = "[]";
                            }
                        } else {
                            abcJsonResult = "[]";
                        }
                    }
                } else {
                    abcJsonResult = "[]";
                }
            }
            
            try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
                stmt.setString(1, "Inventory Turnover Analysis");
                boolean hasResults = stmt.execute();

                if (hasResults) {
                    ResultSet summaryRs = stmt.getResultSet();
                    summaryRs.close();
                }

                hasResults = stmt.getMoreResults();

                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        if (rs.next()) {
                            itrJsonResult = rs.getString("Results");
                            try {
                                JsonElement jsonElement = gson.fromJson(itrJsonResult, JsonElement.class);
                                if (jsonElement.isJsonNull()) {
                                    itrJsonResult = "[]";
                                }
                            } catch (Exception e) {
                                System.out.println("Invalid ABC JSON detected: " + e.getMessage());
                                itrJsonResult = "[]";
                            }
                        } else {
                            itrJsonResult = "[]";
                        }
                    }
                } else {
                    itrJsonResult = "[]";
                }
            }
        
            try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
                stmt.setString(1, "Demand Forecast Analysis");
                boolean hasResults = stmt.execute();

                if (hasResults) {
                    ResultSet summaryRs = stmt.getResultSet();
                    summaryRs.close();
                }

                hasResults = stmt.getMoreResults();

                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        if (rs.next()) {
                            dfJsonResult = rs.getString("Results");
                            try {
                                JsonElement jsonElement = gson.fromJson(dfJsonResult, JsonElement.class);
                                if (jsonElement.isJsonNull()) {
                                    dfJsonResult = "[]";
                                }
                            } catch (Exception e) {
                                System.out.println("Invalid ABC JSON detected: " + e.getMessage());
                                dfJsonResult = "[]";
                            }
                        } else {
                            dfJsonResult = "[]";
                        }
                    }
                } else {
                    dfJsonResult = "[]";
                }
            }
            
            try (CallableStatement stmt = conn.prepareCall("{CALL log_analysis(?)}")) {
                stmt.setString(1, "Product Profitability Analysis");
                boolean hasResults = stmt.execute();

                if (hasResults) {
                    ResultSet summaryRs = stmt.getResultSet();
                    summaryRs.close();
                }

                hasResults = stmt.getMoreResults();

                if (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        if (rs.next()) {
                            profitJsonResult = rs.getString("Results");
                            try {
                                JsonElement jsonElement = gson.fromJson(profitJsonResult, JsonElement.class);
                                if (jsonElement.isJsonNull()) {
                                    profitJsonResult = "[]";
                                }
                            } catch (Exception e) {
                                System.out.println("Invalid ABC JSON detected: " + e.getMessage());
                                profitJsonResult = "[]";
                            }
                        } else {
                            profitJsonResult = "[]";
                        }
                    }
                } else {
                    profitJsonResult = "[]";
                }
            }
        

        } catch (Exception e) {
            System.out.println("Error in DashboardServlet: " + e.getMessage());
            e.printStackTrace();
            salesJsonResult = "[]";
            abcJsonResult = "[]";
            itrJsonResult = "[]";
            dfJsonResult = "[]";
            profitJsonResult = "[]";
        }
        
        String destination = req.getParameter("page");
        if (destination == null) {
            destination = "dashboard"; // default destination
        }


        req.setAttribute("salesData", salesJsonResult);
        req.setAttribute("abcData", abcJsonResult);
        req.setAttribute("inventoryData", itrJsonResult);
        req.setAttribute("demandData", dfJsonResult);
        req.setAttribute("profitData", profitJsonResult);
     // Forward to appropriate JSP based on destination
        String jspPage = destination.equals("report") ? "report.jsp" : "adminDashboard.jsp";
        req.getRequestDispatcher(jspPage).forward(req, resp);
    }
}