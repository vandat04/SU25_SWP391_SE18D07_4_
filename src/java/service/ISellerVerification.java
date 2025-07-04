/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import entity.Account.SellerVerification;
import java.util.List;

/**
 *
 * @author ACER
 */
public interface ISellerVerification {
    List<SellerVerification> AllRequest();
    List<SellerVerification> AllRequestReject();
    List<SellerVerification> AllRequestProcessing();
    List<SellerVerification> AllRequestUpgraded();
    boolean requestUpgradeForIndividual(SellerVerification sellerForm);
    boolean requestUpgradeForCraftVillage(SellerVerification sellerForm);
}
