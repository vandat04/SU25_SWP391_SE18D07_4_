/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.MessageNotification.Message;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Lớp DAO này xử lý các thao tác với cơ sở dữ liệu cho các bảng Message và MessageThread.
 */
public class MessageDAO {

    /**
     * Gửi một tin nhắn từ người dùng đến người nhận.
     * Phương thức này sẽ tự động tìm một luồng hội thoại đã có giữa hai người,
     * hoặc tạo một luồng mới nếu chưa có.
     * @param senderId ID của người gửi.
     * @param receiverId ID của người nhận.
     * @param content Nội dung tin nhắn.
     * @throws SQLException nếu có lỗi khi tương tác với CSDL.
     */
    public void sendMessage(int senderId, int receiverId, String content) throws SQLException {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            // Bắt đầu một transaction để đảm bảo cả hai thao tác đều thành công
            conn.setAutoCommit(false);

            // 1. Tìm hoặc tạo một luồng hội thoại (thread)
            int threadId = findOrCreateThread(conn, senderId, receiverId);

            // 2. Tạo một đối tượng Message mới
            Message message = new Message();
            message.setThreadID(threadId);
            message.setSenderID(senderId);
            message.setReceiverID(receiverId);
            message.setMessageContent(content);
            
            // 3. Chèn tin nhắn mới vào cơ sở dữ liệu
            insertMessage(conn, message);
            
            // 4. Cập nhật lại ngày của tin nhắn cuối cùng trong luồng hội thoại
            updateThreadLastMessageDate(conn, threadId);

            // Nếu tất cả các bước trên thành công, commit transaction
            conn.commit(); 
            
        } catch (Exception e) {
            // Nếu có bất kỳ lỗi nào xảy ra, hủy bỏ tất cả các thay đổi
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            throw new SQLException("Lỗi khi gửi tin nhắn.", e);
        } finally {
            // Luôn trả lại trạng thái auto-commit và đóng kết nối
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Một phương thức nội bộ để tìm hoặc tạo luồng hội thoại.
     */
    private int findOrCreateThread(Connection conn, int userId1, int userId2) throws SQLException {
        // Sắp xếp ID để đảm bảo tính nhất quán (userID1 luôn nhỏ hơn userID2)
        int u1 = Math.min(userId1, userId2);
        int u2 = Math.max(userId1, userId2);
        
        String findSql = "SELECT threadID FROM MessageThread WHERE userID1 = ? AND userID2 = ?";
        String createSql = "INSERT INTO MessageThread (userID1, userID2, status) VALUES (?, ?, 1)";
        
        // Thử tìm một luồng đã có
        try (PreparedStatement psFind = conn.prepareStatement(findSql)) {
            psFind.setInt(1, u1);
            psFind.setInt(2, u2);
            try (ResultSet rs = psFind.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("threadID"); // Trả về ID luồng đã tìm thấy
                }
            }
        }

        // Nếu không tìm thấy, tạo một luồng mới
        try (PreparedStatement psCreate = conn.prepareStatement(createSql, Statement.RETURN_GENERATED_KEYS)) {
            psCreate.setInt(1, u1);
            psCreate.setInt(2, u2);
            psCreate.executeUpdate();
            
            try (ResultSet generatedKeys = psCreate.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Trả về ID của luồng vừa được tạo
                }
            }
        }
        
        // Ném lỗi nếu không thể tạo hoặc tìm thấy luồng
        throw new SQLException("Không thể tìm hoặc tạo luồng hội thoại.");
    }

    /**
     * Một phương thức nội bộ để chèn một tin nhắn vào bảng Message.
     */
    private void insertMessage(Connection conn, Message message) throws SQLException {
        String sql = "INSERT INTO Message (threadID, senderID, receiverID, messageContent, status) VALUES (?, ?, ?, ?, 1)"; // status = 1 (đã gửi)
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, message.getThreadID());
            ps.setInt(2, message.getSenderID());
            ps.setInt(3, message.getReceiverID());
            ps.setString(4, message.getMessageContent());
            ps.executeUpdate();
        }
    }
    
    /**
     * Một phương thức nội bộ để cập nhật ngày của tin nhắn cuối cùng trong một luồng.
     */
    private void updateThreadLastMessageDate(Connection conn, int threadId) throws SQLException {
        String sql = "UPDATE MessageThread SET lastMessageDate = GETDATE() WHERE threadID = ?";
        try(PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threadId);
            ps.executeUpdate();
        }
    }
}
