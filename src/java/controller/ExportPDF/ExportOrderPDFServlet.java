package controller.ExportPDF;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import entity.CraftVillage.CraftVillage;
import entity.Orders.Order;
import entity.Orders.Payment;
import entity.Orders.SubOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.OrderService;
import service.ReportService;
import service.VillageService;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ExportOrderPDFServlet", urlPatterns = {"/export-order-pdf"})
public class ExportOrderPDFServlet extends HttpServlet {

    private final VillageService vService = new VillageService();
    private final OrderService oService = new OrderService();
    private final ReportService rService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"order-report.pdf\"");

        int villageID = Integer.parseInt(request.getParameter("cas"));
        CraftVillage village = vService.getVillageById(villageID);

        try {
            Document document = new Document(PageSize.A3.rotate(), 20, 20, 20, 20);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8);
            Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 8);

            document.add(new Paragraph("Village Management Report", titleFont));
            document.add(new Paragraph("Generated at: " + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()), dataFont));
            document.add(Chunk.NEWLINE);

            // I. General Info
            String[] headers1 = {"Type", "Village Name", "Address", "Contact Phone", "Contact Email"};
            PdfPTable table = new PdfPTable(headers1.length);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{3, 3, 4, 3, 3});
            document.add(new Paragraph("I. General information of the craft village\n", titleFont));
            addTableHeader(table, headers1, headerFont);
            addVillageRow(village, table, dataFont);
            document.add(table); // ✅ Bắt buộc phải add bảng
            document.add(Chunk.NEWLINE);

            // II. Summary
            List<SubOrder> orderList = oService.getSubOrderByVillageID(villageID);
            int revenue = 0, realRevenue = 0, totalPaid = 0, totalUnpaid = 0;
            int processingOrder = 0, deliveringOrder = 0, receivedOrder = 0;
            int canceledOrder = 0, refundedOrder = 0, refundingOrder = 0;

            for (SubOrder so : orderList) {
                Payment payment = rService.getPaymentBySubOrderID(so.getSubOrderId());
                if (payment != null) {
                    int amount = payment.getAmount().intValue();
                    revenue += amount;
                    if ("points".equals(payment.getPaymentMethod()) || payment.getPaymentStatus() == 0) {
                        realRevenue += amount;
                    }
                    if (payment.getPaymentStatus() == 1) {
                        totalPaid++;
                    } else {
                        totalUnpaid++;
                    }
                }
                switch (so.getOrderStatus()) {
                    case 0 -> processingOrder++;
                    case 1 -> deliveringOrder++;
                    case 2 -> receivedOrder++;
                    case 3 -> canceledOrder++;
                    case 4 -> refundedOrder++;
                    case 5 -> refundingOrder++;
                }
            }
            realRevenue = revenue - realRevenue;

            String[] headers2 = {
                "Total Order", "Total Revenue", "Total Real Revenue", "Total Paid Orders",
                "Total Unpaid Orders", "Processing Orders", "Delivering Orders", "Received Orders",
                "Canceled Orders", "Refund Orders", "Refunding Orders"
            };

            table = new PdfPTable(headers2.length);
            table.setWidthPercentage(100);
            float[] widths2 = new float[headers2.length];
            for (int i = 0; i < headers2.length; i++) widths2[i] = 3f;
            table.setWidths(widths2);
            document.add(new Paragraph("II. Summary of order statistics\n", titleFont));
            addTableHeader(table, headers2, headerFont);
            table.addCell(cell(orderList.size(), dataFont));
            table.addCell(cell(revenue, dataFont));
            table.addCell(cell(realRevenue, dataFont));
            table.addCell(cell(totalPaid, dataFont));
            table.addCell(cell(totalUnpaid, dataFont));
            table.addCell(cell(processingOrder, dataFont));
            table.addCell(cell(deliveringOrder, dataFont));
            table.addCell(cell(receivedOrder, dataFont));
            table.addCell(cell(canceledOrder, dataFont));
            table.addCell(cell(refundedOrder, dataFont));
            table.addCell(cell(refundingOrder, dataFont));
            document.add(table);
            document.add(Chunk.NEWLINE);

            // III. Detailed Order List
            String[] headers3 = {
                "STT", "OrderID", "Total Amount", "Payment Method", "Payment Status",
                "Order Status", "Note", "Email", "Created Date"
            };

            table = new PdfPTable(headers3.length);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1, 2, 2, 2, 2, 2, 3, 3, 2});
            document.add(new Paragraph("III. Detailed list of orders \n ", titleFont));
            addTableHeader(table, headers3, headerFont);

            int stt = 1;
            for (SubOrder so : orderList) {
                table.addCell(cell(stt++, dataFont));
                table.addCell(cell("OD" + so.getSubOrderId(), dataFont));
                table.addCell(cell(so.getTotalPrice(), dataFont));
                table.addCell(cell(so.getPaymentMethod(), dataFont));
                table.addCell(cell(so.getPaymentStatus() == 1 ? "Paid" : "Unpaid", dataFont));
                table.addCell(cell(orderStatusToString(so.getOrderStatus()), dataFont));
                table.addCell(cell(so.getNote(), dataFont));
                table.addCell(cell(oService.getOrderById(so.getOrderId()).getEmail(), dataFont));
                table.addCell(cell(so.getCreatedDate(), dataFont));
            }
            document.add(table);

            // Finalize
            document.close();

        } catch (DocumentException e) {
            throw new IOException(e.getMessage(), e);
        }
    }

    private void addTableHeader(PdfPTable table, String[] headers, Font font) {
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, font));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setPadding(4f);
            table.addCell(cell);
        }
    }

    private void addVillageRow(CraftVillage v, PdfPTable table, Font font) {
        table.addCell(cell(vService.getCraftTypeNameByID(v.getTypeID()), font));
        table.addCell(cell(v.getVillageName(), font));
        table.addCell(cell(v.getAddress(), font));
        table.addCell(cell(v.getContactPhone(), font));
        table.addCell(cell(v.getContactEmail(), font));
    }

    private PdfPCell cell(Object value, Font font) {
        String text;
        if (value == null) {
            text = "-";
        } else if (value instanceof Timestamp ts) {
            text = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(ts);
        } else {
            text = value.toString();
        }
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(3f);
        return cell;
    }

    private String orderStatusToString(Integer status) {
        return switch (status) {
            case 0 -> "Processing";
            case 1 -> "Delivering";
            case 2 -> "Received";
            case 3 -> "Canceled";
            case 4 -> "Refunded";
            case 5 -> "Refunding";
            default -> "Unknown";
        };
    }
}
