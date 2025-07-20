package controller.CraftVillage;

import constant.CloudinaryUploader;
import entity.Account.Account;
import entity.MessageNotification.Message;
import entity.MessageNotification.MessageThread;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;
import service.AccountService;
import service.MessageService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ContactUser", urlPatterns = {"/contact-user"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ContactUser extends HttpServlet {

    private final MessageService mService = new MessageService();
    private final AccountService aService = new AccountService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            int sellerID = Integer.parseInt(request.getParameter("sellerID"));

            MessageThread thread = mService.getMessageThread(userID, sellerID);
            if (thread == null) {
                throw new Exception("No message thread found between user and seller.");
            }

            List<Message> list = mService.getMessageByThreadIDForSeller(thread.getThreadID(), sellerID);

            request.setAttribute("messageThread", thread);
            request.setAttribute("listMessage", list);
            request.setAttribute("receiver", aService.getAccountById(userID));

            request.getRequestDispatcher("contact-user.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Chat loading failed: " + e.getMessage());
            request.getRequestDispatcher("404Loi.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("fetchNew".equals(request.getParameter("action"))) {
            try {
                int threadID = Integer.parseInt(request.getParameter("threadID"));
                int lastMessageID = Integer.parseInt(request.getParameter("lastMessageID"));

                List<Message> newMessages = mService.getNewMessages(threadID, lastMessageID);

                JSONArray jsonArray = new JSONArray();
                for (Message msg : newMessages) {
                    JSONObject jsonMsg = new JSONObject();
                    jsonMsg.put("messageID", msg.getMessageID());
                    jsonMsg.put("senderID", msg.getSenderID());
                    jsonMsg.put("messageContent", msg.getMessageContent());
                    jsonMsg.put("attachmentUrl", msg.getAttachmentUrl() == null ? "" : msg.getAttachmentUrl());
                    jsonMsg.put("sentDate", msg.getSentDate().toString());
                    jsonArray.put(jsonMsg);
                }

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(jsonArray.toString());
                out.flush();
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("[]");
            }
        } else {
            processRequest(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account seller = (Account) session.getAttribute("acc");
            if (seller == null) {
                response.sendRedirect("Login.jsp");
                return;
            }

            int threadID = Integer.parseInt(request.getParameter("threadID"));
            int senderID = seller.getUserID();
            int userID = Integer.parseInt(request.getParameter("userID"));
            String messageContent = request.getParameter("messageContent");

            String attachmentUrl = null;
            Part filePart = request.getPart("attachment");
            if (filePart != null && filePart.getSize() > 0) {
                attachmentUrl = CloudinaryUploader.uploadFile(filePart);
            }

            Message message = new Message(0, threadID, senderID, messageContent, attachmentUrl, null, 0);
            mService.sendMessage(message);

            // ✅ FIXED: redirect đúng
            response.sendRedirect("contact-user?sellerID=" + senderID
                    + "&userID=" + userID
                    + "&threadID=" + threadID);

        } catch (Exception e) {
            request.setAttribute("error", "Sending failed: " + e.getMessage());
            processRequest(request, response);
        }
    }
}