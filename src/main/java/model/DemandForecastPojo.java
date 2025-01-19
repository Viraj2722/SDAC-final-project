package model;

public class DemandForecastPojo {
	
	private int product_id;
    private int forecast_monthly_demand;
    private int current_stock;
    private int reorder_level;
    private double selling_price;
    private String stock_status;
    private String action;
    private int suggested_order;
    private String trend;
	
    public int getProduct_id() {
		return product_id;
	}
	public int getForecast_monthly_demand() {
		return forecast_monthly_demand;
	}
	public int getCurrent_stock() {
		return current_stock;
	}
	public int getReorder_level() {
		return reorder_level;
	}
	public double getSelling_price() {
		return selling_price;
	}
	public String getStock_status() {
		return stock_status;
	}
	public String getAction() {
		return action;
	}
	public int getSuggested_order() {
		return suggested_order;
	}
	public String getTrend() {
		return trend;
	}
	public void setProduct_id(int product_id) {
		this.product_id = product_id;
	}
	public void setForecast_monthly_demand(int forecast_monthly_demand) {
		this.forecast_monthly_demand = forecast_monthly_demand;
	}
	public void setCurrent_stock(int current_stock) {
		this.current_stock = current_stock;
	}
	public void setReorder_level(int reorder_level) {
		this.reorder_level = reorder_level;
	}
	public void setSelling_price(double selling_price) {
		this.selling_price = selling_price;
	}
	public void setStock_status(String stock_status) {
		this.stock_status = stock_status;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public void setSuggested_order(int suggested_order) {
		this.suggested_order = suggested_order;
	}
	public void setTrend(String trend) {
		this.trend = trend;
	}

}