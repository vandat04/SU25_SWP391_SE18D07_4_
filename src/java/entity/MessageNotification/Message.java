/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.MessageNotification;

import java.sql.Timestamp;

/**
 *
 * @author ACER
 */
public class Message {
    private int messageID;
    private int threadID;
    private int senderID;
    private int receiverID;
    private String messageContent;
    private boolean isRead;
    private String attachmentUrl;
    private int status;
    private Timestamp sentDate;

    // Constructors-------------------------------------------------------------
    public Message() {}
    
    //--------------------------------------------------------------------------
    public int getMessageID() {
        return messageID;
    }

    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public int getThreadID() {
        return threadID;
    }

    public void setThreadID(int threadID) {
        this.threadID = threadID;
    }

    public int getSenderID() {
        return senderID;
    }

    public void setSenderID(int senderID) {
        this.senderID = senderID;
    }

    public int getReceiverID() {
        return receiverID;
    }

    public void setReceiverID(int receiverID) {
        this.receiverID = receiverID;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public boolean isIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getSentDate() {
        return sentDate;
    }

    public void setSentDate(Timestamp sentDate) {
        this.sentDate = sentDate;
    }

    @Override
    public String toString() {
        return "Message{" + "messageID=" + messageID + ", threadID=" + threadID + ", senderID=" + senderID + ", receiverID=" + receiverID + ", messageContent=" + messageContent + ", isRead=" + isRead + ", attachmentUrl=" + attachmentUrl + ", status=" + status + ", sentDate=" + sentDate + '}';
    }
    
}
