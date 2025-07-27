/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.MessageNotification.Message;
import entity.MessageNotification.MessageThread;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ACER
 */
public class MessageDAO {

    private static final Logger LOGGER = Logger.getLogger(MessageDAO.class.getName());

    private Message mapResultSetToMessage(ResultSet rs) throws SQLException {
        return new Message(
                rs.getInt("messageID"),
                rs.getInt("threadID"),
                rs.getInt("senderID"),
                rs.getString("messageContent"),
                rs.getString("attachmentUrl"),
                rs.getTimestamp("sentDate"),
                rs.getInt("userRead")
        ) {
        };
    }

    private MessageThread mapResultSetToMessageThread(ResultSet rs) throws SQLException {
        return new MessageThread(
                rs.getInt("threadID"),
                rs.getInt("userID"),
                rs.getInt("sellerID"),
                rs.getString("messageName")
        ) {
        };
    }

    private void closeResources(java.sql.Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
        }
    }

    public boolean checkMessageThreadExist(int userID, int sellerID) {
        String query = "SELECT COUNT(*) FROM MessageThread WHERE userID = ? and sellerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userID);
            ps.setInt(2, sellerID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if message thread exists for userID="
                    + userID + " and sellerID=" + sellerID, e);
        }
        return false;
    }

    public boolean addNewMessageThread(MessageThread messageThread) {
        String query = "{call addNewMessageThread(?, ?, ?, ?)}";

        try (Connection conn = new DBContext().getConnection(); CallableStatement cs = conn.prepareCall(query)) {

            cs.setInt(1, messageThread.getUserID());
            cs.setInt(2, messageThread.getSellerID());
            cs.setString(3, messageThread.getMessageName());
            cs.registerOutParameter(4, java.sql.Types.INTEGER);

            cs.execute();

            int result = cs.getInt(4);
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding new message thread for userID="
                    + messageThread.getUserID() + " and sellerID=" + messageThread.getSellerID(), e);
        }
        return false;
    }

    public List<Message> getMessageByThreadID(int threadID, int userID) {
        List<Message> list = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection()) {

            // Lấy senderID tin nhắn cuối cùng
            String lastMsgSql
                    = "SELECT TOP 1 senderID FROM Message WHERE threadID = ? ORDER BY sentDate DESC";

            try (PreparedStatement psLast = conn.prepareStatement(lastMsgSql)) {
                psLast.setInt(1, threadID);

                try (ResultSet rsLast = psLast.executeQuery()) {
                    if (rsLast.next()) {
                        int lastSenderID = rsLast.getInt("senderID");

                        if (lastSenderID != userID) {
                            // Nếu sender khác userID → update toàn bộ userRead = 1
                            String updateSql
                                    = "UPDATE Message SET userRead = 1 WHERE threadID = ?";
                            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                                psUpdate.setInt(1, threadID);
                                psUpdate.executeUpdate();
                            }
                        }
                    }
                }
            }

            // Lấy lại danh sách message mới nhất
            String selectSql
                    = "SELECT * FROM Message WHERE threadID = ?";

            try (PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
                psSelect.setInt(1, threadID);

                try (ResultSet rs = psSelect.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapResultSetToMessage(rs));
                    }
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting messages for threadID=" + threadID, e);
        }

        return list;
    }

    public List<Message> getMessageByThreadIDForSeller(int threadID, int sellerID) {
        List<Message> list = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection()) {

            // Lấy senderID tin nhắn cuối cùng
            String lastMsgSql
                    = "SELECT TOP 1 senderID FROM Message WHERE threadID = ? ORDER BY sentDate DESC";

            try (PreparedStatement psLast = conn.prepareStatement(lastMsgSql)) {
                psLast.setInt(1, threadID);

                try (ResultSet rsLast = psLast.executeQuery()) {
                    if (rsLast.next()) {
                        int lastSenderID = rsLast.getInt("senderID");

                        if (lastSenderID != sellerID) {
                            // Nếu sender khác userID → update toàn bộ userRead = 1
                            String updateSql
                                    = "UPDATE Message SET userRead = 1 WHERE threadID = ?";
                            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                                psUpdate.setInt(1, threadID);
                                psUpdate.executeUpdate();
                            }
                        }
                    }
                }
            }

            // Lấy lại danh sách message mới nhất
            String selectSql
                    = "SELECT * FROM Message WHERE threadID = ?";

            try (PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
                psSelect.setInt(1, threadID);

                try (ResultSet rs = psSelect.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapResultSetToMessage(rs));
                    }
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting messages for threadID=" + threadID, e);
        }

        return list;
    }

    public int sendMessage(Message message) {
        String sql = "{call sendMessage(?, ?, ?, ?, ?)}";

        try (Connection conn = new DBContext().getConnection(); CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, message.getThreadID());
            cs.setInt(2, message.getSenderID());
            cs.setString(3, message.getMessageContent());

            if (message.getAttachmentUrl() != null) {
                cs.setString(4, message.getAttachmentUrl());
            } else {
                cs.setNull(4, java.sql.Types.VARCHAR);
            }

            cs.registerOutParameter(5, java.sql.Types.INTEGER);

            cs.execute();

            return cs.getInt(5);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "Error sending message for threadID=" + message.getThreadID()
                    + ", senderID=" + message.getSenderID(), e);
        }
        return 0;
    }

    public Message getMessageByMessageId(int messageId) {
        String query = "SELECT * FROM Message WHERE messageID = ? ";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, messageId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMessage(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "Error getting message thread for messageID=" + messageId);
        }
        return null;
    }

    public List<MessageThread> getMessageThreadByUserID(int userID) {
        String query = "SELECT * FROM MessageThread WHERE userID = ?";
        List<MessageThread> list = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMessageThread(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting message threads for userID=" + userID, e);
        }
        return list;
    }

    public MessageThread getMessageThread(int userID, int sellerID) {
        String query = "SELECT * FROM MessageThread WHERE userID = ? AND sellerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userID);
            ps.setInt(2, sellerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMessageThread(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "Error getting message thread for userID=" + userID
                    + " and sellerID=" + sellerID, e);
        }
        return null;
    }

    public int getThreadID(int userID, int sellerID) {
        String query = "SELECT threadID FROM MessageThread WHERE userID = ? AND sellerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userID);
            ps.setInt(2, sellerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return (rs.getInt("threadID"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                    "Error getting message thread for userID=" + userID
                    + " and sellerID=" + sellerID, e);
        }
        return 0;
    }

    public static void main(String[] args) {
        System.out.println(new MessageDAO().getMessageBySeller(1));
    }

    public List<Message> getNewMessages(int threadID, int lastMessageID) {
        List<Message> list = new ArrayList<>();
        String query = "SELECT * FROM Message WHERE threadID = ? AND messageID > ? ORDER BY sentDate ASC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, threadID);
            ps.setInt(2, lastMessageID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMessage(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting new messages for threadID=" + threadID + " after messageID=" + lastMessageID, e);
        }
        return list;
    }

    public List<MessageThread> getAllMessageThreadBySellerId(int sellerId) {
        String query = "SELECT * FROM MessageThread WHERE sellerID = ?";
        List<MessageThread> list = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMessageThread(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting message threads for sellerID=" + sellerId, e);
        }
        return list;
    }

    public List<Message> getMessageBySeller(int threadID) {
        List<Message> list = new ArrayList<>();
        String query = "SELECT * FROM Message WHERE threadID = ? ORDER BY sentDate ASC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, threadID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMessage(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting new messages for threadID=" + threadID, e);
        }
        return list;
    }

    public List<Message> getMessagesAfterID(int threadID, int lastMessageID) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM Message WHERE threadID = ? AND messageID > ? ORDER BY sentDate ASC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threadID);
            ps.setInt(2, lastMessageID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message m = new Message(
                        rs.getInt("messageID"),
                        rs.getInt("threadID"),
                        rs.getInt("senderID"),
                        rs.getString("messageContent"),
                        rs.getString("attachmentUrl"),
                        rs.getTimestamp("sentDate"),
                        rs.getInt("userRead")
                );
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateUserReadBySeller(int threadID, int sellerID) {
        String sql = "UPDATE Message SET userRead = 1 WHERE threadID = ? AND senderID != ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, threadID);
            ps.setInt(2, sellerID); // Người đọc là seller, không cập nhật tin do họ gửi
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
