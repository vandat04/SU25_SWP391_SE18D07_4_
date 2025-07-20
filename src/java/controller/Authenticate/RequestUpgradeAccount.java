/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Authenticate;

import DAO.CraftVillageDAO;
import DAO.ProductDAO;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import constant.CloudinaryConfig;
import constant.CloudinaryUploader;
import entity.Account.SellerVerification;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Map;
import service.SellerVerificationService;

/**
 *
 * @author ACER
 */
@MultipartConfig
@WebServlet(name = "RequestUpgradeAccount", urlPatterns = {"/request-upgrade"})
public class RequestUpgradeAccount extends HttpServlet {

    SellerVerificationService sService = new SellerVerificationService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("UpgradeAccount.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String userID = request.getParameter("userID");
        String businessType = request.getParameter("businessType");
        String businessVillageCategrySelect = request.getParameter("businessVillageCategrySelect");
        String businessVillageCategry = request.getParameter("businessVillageCategry");
        String businessVillageName = request.getParameter("businessVillageName");
        String businessVillageAddress = request.getParameter("businessVillageAddress");
        String productProductCategorySelect = request.getParameter("productProductCategorySelect");
        String productProductCategory = request.getParameter("productProductCategory");
        String contactPerson = request.getParameter("contactPerson");
        String contactPhone = request.getParameter("contactPhone");
        String contactEmail = request.getParameter("contactEmail");
        String idCardNumber = request.getParameter("idCardNumber");
        String businessLicense = request.getParameter("businessLicense");
        String taxCode = request.getParameter("taxCode");
        String documentUrl = request.getParameter("documentUrl");
        String note = request.getParameter("note");

        // Upload ảnh lên Cloudinary
        String profileVillagePictureUrl = null;
        String idCardFrontUrl = null;
        String idCardBackUrl = null;

        try {
            Part profilePart = request.getPart("profileVillagePictureUrl");
            Part frontPart = request.getPart("idCardFrontUrl");
            Part backPart = request.getPart("idCardBackUrl");

            profileVillagePictureUrl = CloudinaryUploader.uploadFile(profilePart);
            idCardFrontUrl = CloudinaryUploader.uploadFile(frontPart);
            idCardBackUrl = CloudinaryUploader.uploadFile(backPart);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "0");
            request.setAttribute("message", "Image upload failed");
            request.getRequestDispatcher("UpgradeAccount.jsp").forward(request, response);
            return;
        }
        try {
            boolean result = false;

            if (!businessVillageCategrySelect.isEmpty()) {
                businessVillageCategry = new CraftVillageDAO().getCraftTypeNameByID(Integer.parseInt(businessVillageCategrySelect));
            }
            if (!productProductCategorySelect.isEmpty()) {
                productProductCategory = new ProductDAO().getCategoryNameByCategoryID(Integer.parseInt(productProductCategorySelect));
            }

            if (businessType.equals("Individual")) {
                result = sService.requestUpgradeForIndividual(new SellerVerification(
                        Integer.parseInt(userID), businessType, businessVillageCategry, businessVillageName,
                        businessVillageAddress, productProductCategory, profileVillagePictureUrl,
                        contactPerson, contactPhone, contactEmail, idCardNumber,
                        idCardFrontUrl, idCardBackUrl, note));
            } else {
                result = sService.requestUpgradeForCraftVillage(new SellerVerification(
                        businessType, Integer.parseInt(userID), businessVillageCategry, businessVillageName,
                        businessVillageAddress, productProductCategory, profileVillagePictureUrl,
                        contactPerson, contactPhone, contactEmail, businessLicense, taxCode, documentUrl, note));
            }

            if (result) {
                request.setAttribute("error", "1");
                request.setAttribute("message", "Send request success");
            } else {
                request.setAttribute("error", "0");
                request.setAttribute("message", "Village Name already existed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "0");
            request.setAttribute("message", "System error");
        }

        request.getRequestDispatcher("UpgradeAccount.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}