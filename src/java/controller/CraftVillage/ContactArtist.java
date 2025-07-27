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
import service.VillageService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ContactArtist", urlPatterns = {"/contact-artist"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ContactArtist extends HttpServlet {

    MessageService mService = new MessageService();
    VillageService vService = new VillageService();
    AccountService aService = new AccountService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            int sellerID = Integer.parseInt(request.getParameter("sellerID"));
            

            // Tạo thread nếu chưa có
            if (!mService.checkMessageThreadExist(userID, sellerID)) {
                int villageID = Integer.parseInt(request.getParameter("villageID"));
                String villageName = vService.getVillageNameByID(villageID);
                String sellerName = aService.getAccountById(sellerID).getFullName();
                mService.addNewMessageThread(new MessageThread(userID, sellerID, villageName + " contact to " + sellerName));
            }

            int threadID;
            try {
                threadID = Integer.parseInt(request.getParameter("threadID"));
            } catch (Exception e) {
                threadID = mService.getThreadID(userID, sellerID);
            }

            List<Message> list = mService.getMessageByThreadID(threadID, userID);

            request.setAttribute("listMessage", list);
            request.setAttribute("messageThread", mService.getMessageThread(userID, sellerID));
            request.setAttribute("receiver", aService.getAccountById(sellerID));
            request.getRequestDispatcher("contact-artist.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading chat: " + e.getMessage());
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
                int userID = Integer.parseInt(request.getParameter("userID"));

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
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
            int threadID = Integer.parseInt(request.getParameter("threadID"));
            HttpSession session = request.getSession();
            Account acc = (Account) session.getAttribute("acc");
            if (acc == null) {
                response.sendRedirect("Login.jsp");
                return;
            }
            int senderID = acc.getUserID();
            String messageContent = request.getParameter("messageContent");

            String attachmentUrl = null;
            Part filePart = request.getPart("attachment");
            if (filePart != null && filePart.getSize() > 0) {
                attachmentUrl = CloudinaryUploader.uploadImage(filePart);
            }

            Message message = new Message(0, threadID, senderID, messageContent, attachmentUrl, null, 0);
            mService.sendMessage(message);
            response.sendRedirect("contact-artist?villageID=" + request.getParameter("villageID")
                    + "&userID=" + senderID
                    + "&sellerID=" + request.getParameter("sellerID")
                    + "&threadID=" + threadID);
        } catch (Exception e) {
            request.setAttribute("error", "Sending failed: " + e.getMessage());
            processRequest(request, response);
        }
    }
}
