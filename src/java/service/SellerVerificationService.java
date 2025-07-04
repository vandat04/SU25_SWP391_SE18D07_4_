/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.AccountDAO;
import entity.Account.SellerVerification;
import java.util.List;


/**
 *
 * @author ACER
 */
public class SellerVerificationService implements ISellerVerification {

    AccountDAO aDAO = new AccountDAO();

    @Override
    public List<SellerVerification> AllRequest() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<SellerVerification> AllRequestReject() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<SellerVerification> AllRequestProcessing() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<SellerVerification> AllRequestUpgraded() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean requestUpgradeForIndividual(SellerVerification sellerForm) {
        return aDAO.requestUpgradeForIndividual(sellerForm);
    }

    @Override
    public boolean requestUpgradeForCraftVillage(SellerVerification sellerForm) {
        return aDAO.requestUpgradeForCraftVillage(sellerForm);
    }

    
   
}
