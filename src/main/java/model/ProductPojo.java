package model;

import java.sql.Date;

public class ProductPojo {
    private int productID;
    private String name;
    private String category;
    private double cost;
    private double sellingPrice;
    private int stock;
    private String salesData;
    private int reorderLevel;
    private String supplierInfo;
    private Date expiryDate;

    public ProductPojo() {
    }

    public ProductPojo(int productID, String name, String category, double cost, double sellingPrice, int stock,
            String salesData, int reorderLevel, String supplierInfo, java.sql.Date expiryDate) {
        this.productID = productID;
        this.name = name;
        this.category = category;
        this.cost = cost;
        this.sellingPrice = sellingPrice;
        this.stock = stock;
        this.salesData = salesData;
        this.reorderLevel = reorderLevel;
        this.supplierInfo = supplierInfo;
        this.expiryDate = expiryDate;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getSalesData() {
        return salesData;
    }

    public void setSalesData(String salesData) {
        this.salesData = salesData;
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public String getSupplierInfo() {
        return supplierInfo;
    }

    public void setSupplierInfo(String supplierInfo) {
        this.supplierInfo = supplierInfo;
    }

    public java.sql.Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

}