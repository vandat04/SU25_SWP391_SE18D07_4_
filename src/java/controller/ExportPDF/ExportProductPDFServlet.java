/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.ExportPDF;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import entity.CraftVillage.CraftType;
import entity.CraftVillage.CraftVillage;
import entity.Product.Product;
import entity.Product.ProductCategory;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.ProductService;
import service.VillageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "ExportProductPDFServlet", urlPatterns = {"/export-product-pdf"})
public class ExportProductPDFServlet extends HttpServlet {

    private ProductService pService = new ProductService();
    private VillageService vService = new VillageService();

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
            out.println("<title>Servlet ExportProductPDFServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportProductPDFServlet at " + request.getContextPath() + "</h1>");
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
        List<ProductCategory> listCateCaregory = (List<ProductCategory>) request.getAttribute("listCC");
        List<CraftVillage> listCraftVillgae = (List<CraftVillage>) request.getAttribute("listAllVillage");
        List<CraftType> listCraftType = (List<CraftType>) request.getAttribute("listVillages");
        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            document.add(new Paragraph("Product Report", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16)));
            document.add(new Paragraph("Generated at: " + new java.util.Date()));
            document.add(Chunk.NEWLINE);
            Font headerFont;
            PdfPTable table = null;
            String[] headers1 = new String[]{"Product ID", "Product Name", "Price(d)", "Stock", "Description", "Category",
                "Village", "Craft Type", "Click Count", "Average Rating", "Total Reviews", "Created Date", "Updated Date"};
            String[] headers2 = new String[]{"CategoryID", "Category Name", "Product ID", "Product Name", "Price(d)", "Stock", "Click Count", "Created Date", "Average Rating", "Total Reviews"};
            String[] headers3 = new String[]{"CategoryID", "Category Name", "Product ID", "Product Name"};
            String[] headers4 = new String[]{"Category ID",  "Category Name","Product ID", "Product Name", "Average Rating",  "Total Reviews", "Price (d)" };
            switch (cas) {
                case "1":
                    document.add(new Paragraph("All Product Report"));
                    table = new PdfPTable(13);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 3.0f, 2.0f, 4.0f, 3.0f, 2.0f, 2.0f, 3.5f, 2.5f, 2.0f, 3.5f, 2.5f, 2.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Product product : pService.getAllProductActiveByAdmin()) {
                        table.addCell(String.valueOf(product.getId()));
                        table.addCell(product.getName());
                        table.addCell(String.valueOf(product.getPrice()));
                        table.addCell(String.valueOf(product.getStock()));
                        table.addCell(product.getDescription());
                        table.addCell(pService.getCategoryNameByCategoryID(product.getCategoryID()));
                        table.addCell(vService.getVillageNameByID(product.getVillageID()));
                        table.addCell(vService.getCraftTypeNameByID(product.getCraftTypeID()));
                        table.addCell(String.valueOf(product.getClickCount()));
                        table.addCell(String.valueOf(product.getAverageRating()));
                        table.addCell(String.valueOf(product.getTotalReviews()));
                        table.addCell(String.valueOf(product.getCreatedDate()));
                        table.addCell(String.valueOf(product.getUpdatedDate()));
                    }
                    break;
                case "2":
                    document.add(new Paragraph("All Product By Category Report"));
                    table = new PdfPTable(10);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f, 1.5f, 3.0f, 1.5f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers2) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }
                    for (ProductCategory x : pService.getAllCategory()) {
                        for (Product p : pService.getProductByCategory(x.getCategoryID())) {
                            table.addCell(String.valueOf(x.getCategoryID()));
                            table.addCell(x.getCategoryName());
                            table.addCell(String.valueOf(p.getId()));
                            table.addCell(p.getName());
                            table.addCell(String.valueOf(p.getPrice()));
                            table.addCell(String.valueOf(p.getStock()));
                            table.addCell(String.valueOf(p.getClickCount()));
                            table.addCell(String.valueOf(p.getCreatedDate()));
                            table.addCell(String.valueOf(p.getAverageRating()));
                            table.addCell(String.valueOf(p.getTotalReviews()));
                        }
                    }

                    break;
                case "3":
                    document.add(new Paragraph("Out of Stock Product Report"));
                    table = new PdfPTable(4);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers3) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Product product : pService.getProductOutOfStockByAdmin()) {
                        table.addCell(String.valueOf(product.getCategoryID()));
                        table.addCell(pService.getCategoryNameByCategoryID(product.getCategoryID()));
                        table.addCell(String.valueOf(product.getId()));
                        table.addCell(product.getName());
                    }
                    break;
                case "4":
                    document.add(new Paragraph("All Deactivate Product Report"));
                    table = new PdfPTable(13);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 3.0f, 2.0f, 4.0f, 3.0f, 2.0f, 2.0f, 3.5f, 2.5f, 2.0f, 3.5f, 2.5f, 2.0f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers1) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }

                    for (Product product : pService.getSearchProductByAdmin(0, 0, "")) {
                        table.addCell(String.valueOf(product.getId()));
                        table.addCell(product.getName());
                        table.addCell(String.valueOf(product.getPrice()));
                        table.addCell(String.valueOf(product.getStock()));
                        table.addCell(product.getDescription());
                        table.addCell(pService.getCategoryNameByCategoryID(product.getCategoryID()));
                        table.addCell(vService.getVillageNameByID(product.getVillageID()));
                        table.addCell(vService.getCraftTypeNameByID(product.getCraftTypeID()));
                        table.addCell(String.valueOf(product.getClickCount()));
                        table.addCell(String.valueOf(product.getAverageRating()));
                        table.addCell(String.valueOf(product.getTotalReviews()));
                        table.addCell(String.valueOf(product.getCreatedDate()));
                        table.addCell(String.valueOf(product.getUpdatedDate()));
                    }
                    break;
                case "5":
                    document.add(new Paragraph("Top Rated Product Report "));

                    table = new PdfPTable(7);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{1.5f, 2.5f, 2.5f, 3.5f, 3.0f, 2.5f, 2.5f});

                    headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

                    for (String header : headers4) {
                        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                        table.addCell(cell);
                    }
                    for (Product product : pService.getTopRatedByAdmin()) {
                        table.addCell(String.valueOf(product.getCategoryID()));
                        table.addCell(pService.getCategoryNameByCategoryID(product.getCategoryID()));
                        table.addCell(String.valueOf(product.getId()));
                        table.addCell(product.getName());
                        table.addCell(String.valueOf(product.getAverageRating()));
                        table.addCell(String.valueOf(product.getTotalReviews()));
                        table.addCell(String.valueOf(product.getPrice()));
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
