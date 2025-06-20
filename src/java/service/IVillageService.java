/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import entity.CraftVillage.CraftVillage;
import java.util.List;

/**
 *
 * @author ACER
 */
public interface IVillageService {
    int addVillage(CraftVillage village) throws Exception;
    boolean updateVillage(CraftVillage village);
    boolean deleteVillage(int villageId);
    CraftVillage getVillageById(int villageId);
    List<CraftVillage> getAllVillages();
    List<CraftVillage> searchVillages(String keyword);
    List<CraftVillage> getVillagesBySeller(int sellerId);
    List<CraftVillage> getTopVisitedVillages(int limit);
}
