package operations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;
import db.GetConnection;
import interfaces.Feedback_Operations_Interface;
import model.FeedbackPojo;
import model.ProductPojo;

public class Feedback_Operations implements Feedback_Operations_Interface {
	
   
    public List<Map<String, Object>> fetchFeedbackByCustomer(int customerID) {
        List<Map<String, Object>> feedbackList = new ArrayList<>();
        String query = "SELECT f.feedbackID, f.comments, f.ratings, f.timestamp " +
                       "FROM feedback f " +
                       "WHERE f.customerID = ? " +
                       "ORDER BY f.timestamp DESC";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> feedbackDetails = new LinkedHashMap<>();
                feedbackDetails.put("feedbackID", rs.getInt("feedbackID"));
                feedbackDetails.put("comments", rs.getString("comments"));
                feedbackDetails.put("ratings", rs.getDouble("ratings"));
                feedbackDetails.put("timestamp", rs.getTimestamp("timestamp"));
                feedbackList.add(feedbackDetails);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public boolean addFeedback(int customerID, int productID, String comments, double ratings) {
        String query = "INSERT INTO feedback (customerID, productID, comments, ratings, timestamp) " +
                       "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, customerID);
            stmt.setInt(2, productID);
            stmt.setString(3, comments);
            stmt.setDouble(4, ratings);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean addReply(int customerID, int productID, int parentFeedbackID, String comments) {
        String query = "INSERT INTO feedback (customerID, productID, comments, parentFeedbackID, timestamp) " +
                       "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, customerID);
            stmt.setInt(2, productID);
            stmt.setString(3, comments);
            stmt.setInt(4, parentFeedbackID);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete feedback
    public boolean deleteFeedback(int feedbackID) {
        String query = "DELETE FROM feedback WHERE feedbackID = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, feedbackID);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean addFeedback(FeedbackPojo feedback) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = GetConnection.getConnection();
            String query = "INSERT INTO feedback (ProductID, CustomerID, Comments, Rating, FeedbackDate) VALUES (?, ?, ?, ?, NOW())";
            
            ps = conn.prepareStatement(query);
            ps.setInt(1, feedback.getProductID());
            ps.setInt(2, feedback.getCustomerID());
            ps.setString(3, feedback.getComments());
            ps.setInt(4, feedback.getRatings());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean hasCustomerReviewed(int productId, int customerId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = GetConnection.getConnection();
            String query = "SELECT COUNT(*) as count FROM feedback WHERE ProductID = ? AND CustomerID = ?";
            
            ps = conn.prepareStatement(query);
            ps.setInt(1, productId);
            ps.setInt(2, customerId);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public int getCustomerIdByEmail(String email) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = GetConnection.getConnection();
            String query = "SELECT CustomerID FROM customers WHERE Email = ?";
            
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("CustomerID");
            }
            return -1;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    public List<FeedbackPojo> getFeedbackByProductId(int productId) {
        List<FeedbackPojo> feedbackList = new ArrayList<>();
        String query = "SELECT f.FeedbackID, f.ProductID, f.CustomerID, f.Comments, f.Rating, f.FeedbackDate, c.Name " +
                       "FROM feedback f " +
                       "JOIN customers c ON f.CustomerID = c.CustomerID " +
                       "WHERE f.ProductID = ? " +
                       "ORDER BY f.FeedbackDate DESC";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                FeedbackPojo feedback = new FeedbackPojo();
                feedback.setFeedbackID(rs.getInt("FeedbackID"));
                feedback.setProductID(rs.getInt("ProductID"));
                feedback.setCustomerID(rs.getInt("CustomerID"));
                feedback.setComments(rs.getString("Comments"));
                feedback.setRatings(rs.getInt("Rating"));
                feedback.setFeedbackDate(rs.getTimestamp("FeedbackDate"));

                // Use customer name from the result set
                feedback.setCustomerName(rs.getString("Name"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

}


