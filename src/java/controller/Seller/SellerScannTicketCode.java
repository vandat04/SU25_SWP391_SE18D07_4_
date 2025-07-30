/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Seller;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import net.sourceforge.tess4j.Tesseract;

import java.io.*;
import entity.Account.Account;
import entity.Orders.TicketOrderDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.OrderService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@MultipartConfig
@WebServlet(name = "SellerScannTicketCode", urlPatterns = {"/seller-scanner-ticket-code"})
public class SellerScannTicketCode extends HttpServlet {

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
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");

        // Check if user is logged in and is a seller
        if (account == null || account.getRole() != 2) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("seller-scanner.jsp").forward(request, response);
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
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("acc");

        // Check if user is logged in and is a seller
        if (account == null || account.getRole() != 2) {
            response.sendRedirect("login");
            return;
        }

        Part filePart = request.getPart("image");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("ocrResult", "❌ No file uploaded.");
            request.getRequestDispatcher("seller-scanner.jsp").forward(request, response);
            return;
        }

        // Tạo file tạm
        File tempFile = File.createTempFile("upload-", ".jpg");

        try (InputStream input = filePart.getInputStream(); OutputStream output = new FileOutputStream(tempFile)) {
            input.transferTo(output);
        }

        try {
            Tesseract tesseract = new Tesseract();
            String datapath = getServletContext().getRealPath("/tessdata");
            tesseract.setDatapath(datapath);
            tesseract.setLanguage("eng");

            // OCR và xử lý chuỗi về 1 dòng
            String rawResult = tesseract.doOCR(tempFile);

            String oneLineResult = rawResult.replaceAll("[\\r\\n]+", " ").trim(); // nếu có xuống dòng
            int index = oneLineResult.indexOf("V");
            String code = oneLineResult.substring(index).trim();
            int villageId = new VillageService().getVillageIdBySellerId(account.getUserID());

            TicketOrderDetail ticketOrder = new OrderService().getTicketOrderByTicketCode(code, villageId);
            System.out.println(ticketOrder);
            request.setAttribute("ticketOrder", ticketOrder);
            request.setAttribute("code", code);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ocrResult", "❌ Error during OCR: " + e.getMessage());
        } finally {
            // Xoá file tạm
            if (tempFile.exists()) {
                tempFile.delete();
            }
        }

        request.getRequestDispatcher("seller-scanner.jsp").forward(request, response);
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

}
