package interfaces;
import java.util.List;
import java.util.Map;
import model.FeedbackPojo;

public interface Feedback_Operations_Interface {
    List<Map<String, Object>> fetchFeedbackByCustomer(int customerID);
    boolean addFeedback(int customerID, int productID, String comments, double ratings);
    boolean addReply(int customerID, int productID, int parentFeedbackID, String comments);
    boolean deleteFeedback(int feedbackID);
    boolean addFeedback(FeedbackPojo feedback);
    boolean hasCustomerReviewed(int productId, int customerId);
    int getCustomerIdByEmail(String email);
    List<FeedbackPojo> getFeedbackByProductId(int productId);
}