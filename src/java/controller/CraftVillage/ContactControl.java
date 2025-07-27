package controller.CraftVillage;

import entity.MessageNotification.MessageThread;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.MessageService;

/**
 *
 * @author ACER
 */
@WebServlet(name = "ContactControl", urlPatterns = {"/contacts"})
public class ContactControl extends HttpServlet {

    MessageService mService = new MessageService();
    List<MessageThread> listMessageThread;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            listMessageThread = mService.getMessageThreadByUserID(userID);
        } catch (Exception e) {
        }

        request.setAttribute("listMessageThread", listMessageThread);
        request.getRequestDispatcher("contact.jsp").forward(request, response);

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}