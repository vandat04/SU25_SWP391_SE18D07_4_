package controller.Seller;

import DAO.CraftVillageDAO;
import entity.CraftVillage.CraftType;
import entity.CraftVillage.CraftVillage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VillageManagementServlet", urlPatterns = {"/manage-villages"})
public class VillageManagementServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        CraftVillageDAO dao = new CraftVillageDAO();

        switch (action) {
            case "add":
                showAddForm(request, response, dao);
                break;
            case "save":
                saveVillage(request, response, dao);
                break;
            case "edit":
                showEditForm(request, response, dao);
                break;
            case "delete":
                deleteVillage(request, response, dao);
                break;
            case "search":
                searchVillage(request, response, dao);
                break;
            default:
                listVillages(request, response, dao);
                break;
        }
    }

    private void listVillages(HttpServletRequest request, HttpServletResponse response, CraftVillageDAO dao) throws ServletException, IOException {
        List<CraftVillage> villageList = dao.getAllCraftVillageActive();
        request.setAttribute("VILLAGE_LIST", villageList);
        // Kiểm tra và hiển thị thông báo từ session (nếu có)
        HttpSession session = request.getSession();
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }
        request.getRequestDispatcher("villageList.jsp").forward(request, response);
    }

    private void searchVillage(HttpServletRequest request, HttpServletResponse response, CraftVillageDAO dao) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                listVillages(request, response, dao);
                return;
            }
            int id = Integer.parseInt(idStr);
            CraftVillage village = dao.getVillageById(id);
            List<CraftVillage> villageList = new ArrayList<>();
            if (village != null) {
                villageList.add(village);
            }
            request.setAttribute("VILLAGE_LIST", villageList);
            request.setAttribute("SEARCH_VALUE", id);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã làng nghề không hợp lệ!");
        }
        request.getRequestDispatcher("villageList.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response, CraftVillageDAO dao) throws ServletException, IOException {
        List<CraftType> craftTypes = dao.getAllCraftType();
        request.setAttribute("CRAFT_TYPES", craftTypes);
        request.getRequestDispatcher("villageForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, CraftVillageDAO dao) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CraftVillage village = dao.getVillageById(id);
            if (village == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy làng nghề để cập nhật.");
                response.sendRedirect("manage-villages");
                return;
            }
            List<CraftType> craftTypes = dao.getAllCraftType();
            request.setAttribute("VILLAGE", village);
            request.setAttribute("CRAFT_TYPES", craftTypes);
            request.getRequestDispatcher("villageForm.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID làng nghề không hợp lệ.");
        }
    }
    
    /**
     * PHIÊN BẢN HOÀN CHỈNH: Đã lấy tất cả các trường từ form chi tiết
     */
    private void saveVillage(HttpServletRequest request, HttpServletResponse response, CraftVillageDAO dao) 
            throws IOException, ServletException {
        
        String villageIdStr = request.getParameter("villageID");
        
        try {
            // 1. Lấy tất cả dữ liệu từ form
            String typeIdStr = request.getParameter("typeID");
            String villageName = request.getParameter("villageName");
            String description = request.getParameter("description");
            String address = request.getParameter("address");
            String contactPhone = request.getParameter("contactPhone");
            String contactEmail = request.getParameter("contactEmail");
            String openingHours = request.getParameter("openingHours");
            String closingDays = request.getParameter("closingDays");
            String latitudeStr = request.getParameter("latitude");
            String longitudeStr = request.getParameter("longitude");
            String mainImageUrl = request.getParameter("mainImageUrl");
            String mapEmbedUrl = request.getParameter("mapEmbedUrl");
            String virtualTourUrl = request.getParameter("virtualTourUrl");
            String videoDescriptionUrl = request.getParameter("videoDescriptionUrl");
            String history = request.getParameter("history");
            String specialFeatures = request.getParameter("specialFeatures");
            String famousProducts = request.getParameter("famousProducts");
            String culturalEvents = request.getParameter("culturalEvents");
            String craftProcess = request.getParameter("craftProcess");
            String travelTips = request.getParameter("travelTips");
            String sellerIdStr = request.getParameter("sellerId");

            // 2. Kiểm tra dữ liệu bắt buộc
            if (villageName == null || villageName.trim().isEmpty() || typeIdStr == null || typeIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Tên làng nghề và Loại hình là bắt buộc.");
                showAddForm(request, response, dao);
                return;
            }

            // 3. Tạo đối tượng và gán toàn bộ dữ liệu
            CraftVillage village = new CraftVillage();
            village.setVillageName(villageName.trim());
            village.setTypeID(Integer.parseInt(typeIdStr));
            village.setAddress(address);
            village.setDescription(description);
            village.setMainImageUrl(mainImageUrl);
            village.setContactPhone(contactPhone);
            village.setContactEmail(contactEmail);
            village.setOpeningHours(openingHours);
            village.setClosingDays(closingDays);
            village.setMapEmbedUrl(mapEmbedUrl);
            village.setVirtualTourUrl(virtualTourUrl);
            village.setVideoDescriptionUrl(videoDescriptionUrl);
            village.setHistory(history);
            village.setSpecialFeatures(specialFeatures);
            village.setFamousProducts(famousProducts);
            village.setCulturalEvents(culturalEvents);
            village.setCraftProcess(craftProcess);
            village.setTravelTips(travelTips);

            if (sellerIdStr != null && !sellerIdStr.trim().isEmpty()) {
                village.setSellerId(Integer.parseInt(sellerIdStr));
            }

            // Chuyển đổi số (Double) một cách an toàn
            if (latitudeStr != null && !latitudeStr.trim().isEmpty()) village.setLatitude(Double.parseDouble(latitudeStr));
            if (longitudeStr != null && !longitudeStr.trim().isEmpty()) village.setLongitude(Double.parseDouble(longitudeStr));

            // 4. Gọi DAO để lưu và đặt thông báo
            HttpSession session = request.getSession();
            if (villageIdStr == null || villageIdStr.isEmpty()) {
                dao.addVillage(village);
                session.setAttribute("successMessage", "Thêm làng nghề mới thành công!");
            } else {
                village.setVillageID(Integer.parseInt(villageIdStr));
                dao.updateVillage(village);
                session.setAttribute("successMessage", "Cập nhật thông tin làng nghề thành công!");
            }

            // 5. Chuyển hướng về trang danh sách
            response.sendRedirect("manage-villages");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại các trường số.");
            showAddForm(request, response, dao);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra phía máy chủ. Vui lòng thử lại.");
            showAddForm(request, response, dao);
        }
    }

    private void deleteVillage(HttpServletRequest request, HttpServletResponse response, CraftVillageDAO dao) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteVillage(id);
            request.getSession().setAttribute("successMessage", "Đã ẩn làng nghề thành công.");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Mã làng nghề không hợp lệ để xóa.");
        }
        response.sendRedirect("manage-villages");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}