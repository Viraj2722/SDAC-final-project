package model;

import java.sql.Date;

public class SalePojo {
    private int saleID;
    private int productID;
    private int customerID;
    private java.sql.Date date;
    private int quantity;
    private double totalAmount;
    private String paymentMethod;

    public SalePojo() {
    }

    public SalePojo(int saleID, int productID, int customerID, Date date, int quantity, double totalAmount,
            String paymentMethod) {
        this.saleID = saleID;
        this.productID = productID;
        this.customerID = customerID;
        this.date = date;
        this.quantity = quantity;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
    }

    public int getSaleID() {
        return saleID;
    }

    public void setSaleID(int saleID) {
        this.saleID = saleID;
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

    public java.sql.Date getDate() {
        return date;
    }

    public void setDate(java.sql.Date date) {
        this.date = date;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

}