/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.ExportPDF;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import entity.Account.Account;
import java.util.Map;
import service.AccountService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "ExportPDFServlet", urlPatterns = {"/export-account-pdf"})
public class ExportAccountPDFServlet extends HttpServlet {

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
            out.println("<title>Servlet ExportPDFServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportPDFServlet at " + request.getContextPath() + "</h1>");
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
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"report.pdf\"");
        String cas = request.getParameter("cas");
        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            document.add(new Paragraph("Account Report", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16)));
            document.add(new Paragraph("Generated at: " + new java.util.Date()));
            document.add(Chunk.NEWLINE);
            Font headerFont;
            PdfPTable table = null;
            String[] headers1 = new String[]{"User ID", "UserName", "Full Name", "Email", "Address",
                "Phone Number", "Created Date", "RoleID", "Last Login"};
            String[] headers2 = new String[]{ "Role Name", "Quantity"};
            switch (cas) {
                case "1":
                    document.add(new Paragraph("All Account Report"));
                    document.add(new Paragraph("RoleID: 1=Customer, 2=Seller, 3=Admin"));

                    table = new PdfPTable(9);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f, 1.5f, 3.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Account acc : new AccountService().getAllAccounts()) {
                        table.addCell(String.valueOf(acc.getUserID()));
                        table.addCell(acc.getUserName());
                        table.addCell(acc.getFullName());
                        table.addCell(acc.getEmail());
                        table.addCell(acc.getAddress());
                        table.addCell(acc.getPhoneNumber());
                        table.addCell(acc.getCreatedDate());
                        table.addCell(String.valueOf(acc.getRoleID()));
                        table.addCell(acc.getLastLoginDate());
                    }
                    break;
                case "2":
                    document.add(new Paragraph("All Customer Account Report"));
                    document.add(new Paragraph("RoleID: 1=Customer, 2=Seller, 3=Admin"));

                    table = new PdfPTable(9);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f, 1.5f, 3.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Account acc : new AccountService().getSearchAccount(1, 1, "")) {
                        table.addCell(String.valueOf(acc.getUserID()));
                        table.addCell(acc.getUserName());
                        table.addCell(acc.getFullName());
                        table.addCell(acc.getEmail());
                        table.addCell(acc.getAddress());
                        table.addCell(acc.getPhoneNumber());
                        table.addCell(acc.getCreatedDate());
                        table.addCell(String.valueOf(acc.getRoleID()));
                        table.addCell(acc.getLastLoginDate());
                    }
                    break;
                case "3":
                    document.add(new Paragraph("All Seller Account Report"));
                    document.add(new Paragraph("RoleID: 1=Customer, 2=Seller, 3=Admin"));

                    table = new PdfPTable(9);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f, 1.5f, 3.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Account acc : new AccountService().getSearchAccount(1, 2, "")) {
                        table.addCell(String.valueOf(acc.getUserID()));
                        table.addCell(acc.getUserName());
                        table.addCell(acc.getFullName());
                        table.addCell(acc.getEmail());
                        table.addCell(acc.getAddress());
                        table.addCell(acc.getPhoneNumber());
                        table.addCell(acc.getCreatedDate());
                        table.addCell(String.valueOf(acc.getRoleID()));
                        table.addCell(acc.getLastLoginDate());
                    }
                    break;
                case "4":
                    document.add(new Paragraph("All Admin Account Report"));
                    document.add(new Paragraph("RoleID: 1=Customer, 2=Seller, 3=Admin"));

                    table = new PdfPTable(9);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f, 1.5f, 3.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Account acc : new AccountService().getSearchAccount(1, 3, "")) {
                        table.addCell(String.valueOf(acc.getUserID()));
                        table.addCell(acc.getUserName());
                        table.addCell(acc.getFullName());
                        table.addCell(acc.getEmail());
                        table.addCell(acc.getAddress());
                        table.addCell(acc.getPhoneNumber());
                        table.addCell(acc.getCreatedDate());
                        table.addCell(String.valueOf(acc.getRoleID()));
                        table.addCell(acc.getLastLoginDate());
                    }
                    break;
                case "5":
                    document.add(new Paragraph("All Deactivate Account Report"));
                    document.add(new Paragraph("RoleID: 1=Customer, 2=Seller, 3=Admin"));

                    table = new PdfPTable(9);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f, 1.5f, 3.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Account acc : new AccountService().getSearchAccount(0, 0, "")) {
                        table.addCell(String.valueOf(acc.getUserID()));
                        table.addCell(acc.getUserName());
                        table.addCell(acc.getFullName());
                        table.addCell(acc.getEmail());
                        table.addCell(acc.getAddress());
                        table.addCell(acc.getPhoneNumber());
                        table.addCell(acc.getCreatedDate());
                        table.addCell(String.valueOf(acc.getRoleID()));
                        table.addCell(acc.getLastLoginDate());
                    }
                    break;
                case "6":
                    document.add(new Paragraph("Quantity By Account Role Report"));

                    table = new PdfPTable(2);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{ 2.5f, 2.5f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers2) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }
                    table.addCell("Customer");
                    table.addCell(new AccountService().getSearchAccount(1, 1, "").size() + "");
                    table.addCell("Seller");
                    table.addCell(new AccountService().getSearchAccount(1, 2, "").size() + "");
                    table.addCell("Admin");
                    table.addCell(new AccountService().getSearchAccount(1, 3, "").size() + "");
                    break;
                case "7":
                    int year = java.time.Year.now().getValue();
                    document.add(new Paragraph("Monthly Registration Summary Report - Year " + year));
                    document.add(Chunk.NEWLINE); // Dòng trống

                    // Tạo bảng với 2 cột: Tháng | Số lượng đăng ký
                    table = new PdfPTable(2);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{2.0f, 3.0f});

                    // Font in đậm cho header
                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    // Header
                    PdfPCell cell1 = new PdfPCell(new Phrase("Month", headerFont));
                    cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cell1.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    table.addCell(cell1);

                    PdfPCell cell2 = new PdfPCell(new Phrase("Total Registrations", headerFont));
                    cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cell2.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    table.addCell(cell2);

                    // Lấy dữ liệu từ service
                    Map<Integer, Integer> registrationMap = new AccountService().getRegistrationSummaryByMonthYear(year);

                    // In từng dòng cho tháng 1–12
                    for (int month = 1; month <= 12; month++) {
                        table.addCell("Month " + month);
                        table.addCell(String.valueOf(registrationMap.getOrDefault(month, 0)));
                    }
                    break;
                default:
                    throw new AssertionError();
            }

            document.add(table);
            document.close();

        } catch (DocumentException e) {
            throw new IOException(e.getMessage());
        }

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

}
