/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.CraftVillageDAO;
import entity.CraftVillage.CraftType;
import entity.CraftVillage.CraftVillage;
import java.util.List;

/**
 *
 * @author ACER
 */
public class VillageService implements IVillageService{

    CraftVillageDAO vDAO = new CraftVillageDAO();
    
    @Override
    public int addVillage(CraftVillage village) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateVillage(CraftVillage village) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean deleteVillage(int villageId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public CraftVillage getVillageById(int villageId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftVillage> getAllVillages() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftVillage> searchVillages(String keyword) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftVillage> getVillagesBySeller(int sellerId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftVillage> getTopVisitedVillages(int limit) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<CraftType> getAllCraftType() {
        return vDAO.getAllCraftType();
    }

    @Override
    public String getVillageNameByID(int villageID) {
        return vDAO.getVillageNameByID(villageID);
    }

    @Override
    public String getCraftTypeNameByID(int typeID) {
        return vDAO.getCraftTypeNameByID(typeID);
    }
    
}
