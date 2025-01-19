package model;

public class FeedbackPojo {
    private int feedbackID;
    private int productID;
    private int customerID;
    private String comments;
    private int ratings;
    private java.sql.Timestamp feedbackDate; // Represents the FeedbackDate column in the database
    private String customerName; // Represents the customer's name

    // Default Constructor
    public FeedbackPojo() {
    }

    // Parameterized Constructor
    public FeedbackPojo(int feedbackID, int productID, int customerID, String comments, int ratings,
                        java.sql.Timestamp feedbackDate, String customerName) {
        this.feedbackID = feedbackID;
        this.productID = productID;
        this.customerID = customerID;
        this.comments = comments;
        this.ratings = ratings;
        this.feedbackDate = feedbackDate;
        this.customerName = customerName;
    }

    // Getters and Setters
    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public int getRatings() {
        return ratings;
    }

    public void setRatings(int ratings) {
        this.ratings = ratings;
    }

    public java.sql.Timestamp getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(java.sql.Timestamp feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}
