/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Product;

/**
 *
 * @author ACER
 */
public class Product3D {
    private int product3dID;
    private int productID;
    private String modelFile;

    public Product3D() {
    }

    public Product3D(int product3dID, int productID, String modelFile) {
        this.product3dID = product3dID;
        this.productID = productID;
        this.modelFile = modelFile;
    }

    public Product3D(int productID, String modelFile) {
        this.productID = productID;
        this.modelFile = modelFile;
    }

    public int getProduct3dID() {
        return product3dID;
    }

    public void setProduct3dID(int product3dID) {
        this.product3dID = product3dID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getModelFile() {
        return modelFile;
    }

    public void setModelFile(String modelFile) {
        this.modelFile = modelFile;
    }

    @Override
    public String toString() {
        return "Product3D{" + "product3dID=" + product3dID + ", productID=" + productID + ", modelFile=" + modelFile + '}';
    }
}
