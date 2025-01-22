package interfaces;
import java.math.BigDecimal;
import java.util.Map;
import model.ProductPojo;

public interface Sale_Operations_Interface {
    Map<Integer, Map<String, Object>> getSalesSummary();
    Map<Integer, Double> computeProfitMargins();
    Map<ProductPojo, Map<String, Object>> fetchProductSalesData();
    boolean reduceStock(int productID, int quantity);
    boolean processSale(int customerID, Map<Integer, Integer> items, BigDecimal totalAmount, String paymentMethod);
}