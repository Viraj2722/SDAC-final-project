package interfaces;
import model.ProductPojo;

public interface Product_Operations_Interface {
    ProductPojo getProductById(int productId);
    boolean editProduct(ProductPojo product);
    boolean deleteProduct(int productID);
    boolean addProduct(ProductPojo product);
    boolean updateProductDetails(int productID, double newPrice, int newStock, String newSupplierInfo);
}