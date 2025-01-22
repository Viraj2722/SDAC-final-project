package interfaces;
import java.util.Map;

public interface Algo_Operations_Interface {
    String getSalesTrendAnalysis();
    String getABCClassification();
    String getInventoryTurnoverAnalysis();
    String getDemandForecastAnalysis();
    String getProductProfitabilityAnalysis();
    Map<String, String> getAllAnalysisData();
}