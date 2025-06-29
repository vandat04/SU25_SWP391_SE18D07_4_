package controller.ticket;

import DAO.VillageTicketDAO;
import DAO.CraftVillageDAO;
import DAO.TicketAvailabilityDAO;
import service.ITicketAvailabilityService;
import service.TicketAvailabilityService;
import entity.Ticket.VillageTicket;
import entity.Ticket.TicketAvailability;
import entity.CraftVillage.CraftVillage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Ticket Detail functionality
 * URL: /ticket-detail?ticketId={ticketId}
 */
@WebServlet(name = "TicketDetailControl", urlPatterns = {"/ticket-detail"})
public class TicketDetailControl extends HttpServlet {
    
    private VillageTicketDAO villageTicketDAO = new VillageTicketDAO();
    private CraftVillageDAO villageDAO = new CraftVillageDAO();
    private TicketAvailabilityDAO availabilityDAO = new TicketAvailabilityDAO();
    private ITicketAvailabilityService availabilityService = new TicketAvailabilityService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String ticketIdStr = request.getParameter("ticketId");
        if (ticketIdStr == null || ticketIdStr.isEmpty()) {
            response.sendRedirect("ticket-list");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            
            // Get ticket information
            VillageTicket ticket = villageTicketDAO.getTicketById(ticketId);
            if (ticket == null) {
                response.sendRedirect("ticket-list");
                return;
            }

            // Get village information
            CraftVillage village = villageDAO.getVillageById(ticket.getVillageID());
            if (village == null) {
                response.sendRedirect("ticket-list");
                return;
            }

            // Get available dates for this ticket (next 30 days) using service
            List<TicketAvailability> availableDates = availabilityService.getAvailableDatesForTicket(ticketId);
            
            if (availableDates.isEmpty()) {
                // Initialize sample availability for testing (next 7 days)
                for (int i = 1; i <= 7; i++) {
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.add(java.util.Calendar.DAY_OF_MONTH, i);
                    availabilityDAO.initializeAvailability(ticketId, cal.getTime(), 20);
                }
                // Re-fetch after initialization
                availableDates = availabilityService.getAvailableDatesForTicket(ticketId);
            }

            // Get all ticket types for same village (for dropdown selection)
            List<VillageTicket> allTicketTypes = villageTicketDAO.getTicketsByVillageId(village.getVillageID());
            
            // Get other ticket types (excluding current one for recommendations)
            List<VillageTicket> otherTickets = villageTicketDAO.getTicketsByVillageId(village.getVillageID());
            otherTickets.removeIf(t -> t.getTicketID() == ticketId);

            // Set attributes for JSP
            request.setAttribute("selectedTicket", ticket);
            request.setAttribute("ticket", ticket);
            request.setAttribute("village", village);
            request.setAttribute("availableDates", availableDates);
            request.setAttribute("availabilities", availableDates);
            request.setAttribute("allTicketTypes", allTicketTypes);
            request.setAttribute("otherTickets", otherTickets);
            
            // Add some utility data
            request.setAttribute("hasAvailability", !availableDates.isEmpty());
            
            request.getRequestDispatcher("TicketDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("ticket-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests if needed (like adding reviews)
        doGet(request, response);
    }
} 