/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.CraftVillage;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import entity.CraftVillage.CraftVillage;
import entity.CraftVillage.Province;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import service.VillageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "CraftVillageControl", urlPatterns = {"/craftVillage"})
public class CraftVillageControl extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CraftVillageControl</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CraftVillageControl at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        // Call API to load provinces
        List<Province> listProvinces = getProvincesFromAPI();
        request.setAttribute("listProvinces", listProvinces);
        VillageService vService = new VillageService();
         
        String provinceCode = request.getParameter("provinceCode");
        String typeID = request.getParameter("typeID");
        String provinceCodeSearch = "";
        String typeIDStr = "";
        if (provinceCode != null) {
            provinceCodeSearch = cleanProvinceName(request.getParameter("provinceCode"));
        }
        if (typeID != null) {
            typeIDStr = typeID;
        }

       List<CraftVillage> vlist = vService.getVillageByFilter(provinceCodeSearch, typeIDStr);

        request.setAttribute("vlist", vlist);
        request.getRequestDispatcher("craftVillage.jsp").forward(request, response);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private List<Province> getProvincesFromAPI() throws IOException {
        List<Province> list = new ArrayList<>();

        // Chỉ lấy 2 tỉnh có code 48 và 49
        int[] provinceCodes = {48, 49};

        for (int provCode : provinceCodes) {
            URL url = new URL("https://provinces.open-api.vn/api/p/" + provCode + "?depth=3");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            conn.disconnect();

            JsonParser parser = new JsonParser();
            JsonElement jsonElement = parser.parse(response.toString());
            JsonObject provinceObject = jsonElement.getAsJsonObject();

            JsonArray districts = provinceObject.getAsJsonArray("districts");
            for (JsonElement districtEl : districts) {
                JsonObject districtObj = districtEl.getAsJsonObject();
                JsonArray wards = districtObj.getAsJsonArray("wards");

                for (JsonElement wardEl : wards) {
                    JsonObject wardObj = wardEl.getAsJsonObject();
                    String wardCode = wardObj.get("code").getAsString();
                    String wardName = wardObj.get("name").getAsString();
                    list.add(new Province(wardCode, wardName));
                }
            }
        }

        return list;
    }

    public String cleanProvinceName(String encoded) {
        String decoded = URLDecoder.decode(encoded, StandardCharsets.UTF_8);

        // Bỏ tiền tố
        String[] prefixes = {"Phường", "Xã", "Thị trấn", "Thị xã"};
        for (String prefix : prefixes) {
            if (decoded.startsWith(prefix)) {
                decoded = decoded.substring(prefix.length()).trim();
                break;
            }
        }

        // Xóa dấu
        decoded = removeAccents(decoded);

        // Chữ thường (nếu muốn)
        decoded = decoded.toLowerCase();

        return decoded;
    }

    public String removeAccents(String input) {
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(normalized).replaceAll("").replaceAll("đ", "d").replaceAll("Đ", "D");
    }

}
