/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import constant.CloudinaryUploader;
import entity.CraftVillage.CraftVillage;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.List;
import service.VillageService;

/**
 *
 * @author ACER
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB: Khi vượt ngưỡng này, file sẽ lưu vào ổ đĩa tạm
        maxFileSize = 10 * 1024 * 1024, // 10MB: Kích thước tối đa của từng file
        maxRequestSize = 20 * 1024 * 1024 // 20MB: Tổng dung lượng toàn bộ request (nếu có nhiều file)
)
@WebServlet(name = "AdminVillageManagement", urlPatterns = {"/admin-village-management"})
public class AdminVillageManagement extends HttpServlet {

    private VillageService vService = new VillageService();

    private static final int PAGE_SIZE = 10;

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * PAGE_SIZE;

        String statusStr = request.getParameter("status") != null ? request.getParameter("status") : "1";
        String searchIDStr = request.getParameter("searchID") != null ? request.getParameter("searchID") : "0";
        String contentSearch = request.getParameter("contentSearch") != null ? request.getParameter("contentSearch") : "";

        String error = request.getParameter("error");
        String message = "";
        if (error != null) {
            switch (error) {
                case "1":
                    message = "Update Success";
                    break;
                case "2":
                    message = "Update Fail";
                    break;
                case "3":
                    message = "Delete Success";
                    break;
                case "4":
                    message = "Delete Fail";
                    break;
                case "5":
                    message = "Create Success";
                    break;
                case "6":
                    message = "Create Fail";
                    break;
                default:
                    throw new AssertionError();
            }
            request.setAttribute("error", error);
            request.setAttribute("message", message);
        }

        List<CraftVillage> villages;
        int totalVillages;

        int status = Integer.parseInt(statusStr);
        int searchID = Integer.parseInt(searchIDStr);
        villages = vService.getSearchVillageByAdmin(status, searchID, contentSearch, offset, PAGE_SIZE);
        totalVillages = vService.getTotalSearchVillages(status, searchID, contentSearch);

        request.setAttribute("status", statusStr);
        request.setAttribute("searchID", searchIDStr);
        request.setAttribute("contentSearch", contentSearch);

        int totalPages = (totalVillages + PAGE_SIZE - 1) / PAGE_SIZE;

        request.setAttribute("listAllVillages", villages);
        request.setAttribute("totalVillages", totalVillages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("listVillages", vService.getAllCraftType());

        request.getRequestDispatcher("admin-village-management.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeName = request.getParameter("action");
        String villageID = request.getParameter("villageID");
        String status = request.getParameter("status");

        String villageName = request.getParameter("villageName");
        String typeID = request.getParameter("typeName");
        String description = request.getParameter("description");
        String address = request.getParameter("address");
        String contactPhone = request.getParameter("contactPhone");
        String contactEmail = request.getParameter("contactEmail");
        String statusVillage = request.getParameter("statusVillage");
        String sellerId = request.getParameter("sellerId");
        String openingHours = request.getParameter("openingHours");
        String closingDays = request.getParameter("closingDays");
        String mapEmbedUrl = request.getParameter("mapEmbedUrl");
        String virtualTourUrl = request.getParameter("virtualTourUrl");
        String history = request.getParameter("history");
        String specialFeatures = request.getParameter("specialFeatures");
        String famousProducts = request.getParameter("famousProducts");
        String culturalEvents = request.getParameter("culturalEvents");
        String craftProcess = request.getParameter("craftProcess");
        String videoDescriptionUrl = request.getParameter("videoDescriptionUrl");
        String travelTips = request.getParameter("travelTips");
        String existingMainImageUrl = request.getParameter("existingMainImageUrl");

        String mainImageUrl = "";
        try {
            Part filePart = request.getPart("mainImageUrl");
            if (filePart != null && filePart.getSize() > 0) {
                mainImageUrl = CloudinaryUploader.uploadImage(filePart);
            }
        } catch (Exception e) {
            // Handle upload error
        }
        if (mainImageUrl.equals("")) {
            mainImageUrl = existingMainImageUrl;
        }

        CraftVillage village;
        boolean success = false;
        String message = "";
        String errorCode = "0";

        switch (typeName) {
            case "updateVillage":
                village = new CraftVillage(Integer.parseInt(villageID), villageName, Integer.parseInt(typeID), description, address, 0.0, 0.0, contactPhone, contactEmail, Integer.parseInt(statusVillage), Integer.parseInt(sellerId), openingHours, closingDays, mapEmbedUrl, virtualTourUrl, history, specialFeatures, famousProducts, culturalEvents, craftProcess, videoDescriptionUrl, travelTips, mainImageUrl);
                success = vService.updateCraftVillageByAdmin(village);
                if (success) {
                    errorCode = "1";
                } else {
                    errorCode = "2";
                }
                break;
            case "deleteVillage":
                success = vService.deleteVillageByAdmin(Integer.parseInt(villageID));
                if (success) {
                    errorCode = "3";
                } else {
                    errorCode = "4";
                }
                break;
            case "addVillage":
                village = new CraftVillage(villageName, Integer.parseInt(typeID), description, address, 0.0, 0.0, contactPhone, contactEmail, Integer.parseInt(statusVillage), Integer.parseInt(sellerId), openingHours, closingDays, mapEmbedUrl, virtualTourUrl, history, specialFeatures, famousProducts, culturalEvents, craftProcess, videoDescriptionUrl, travelTips, mainImageUrl);
                success = vService.addNewVillageByAdmin(village);

                if (success) {
                    errorCode = "5";
                } else {
                    errorCode = "6";
                }
                break;

        }

        request.setAttribute("error", errorCode);
        request.setAttribute("message", message);
        response.sendRedirect("admin-village-management?status=" + status + "&error=" + errorCode);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
