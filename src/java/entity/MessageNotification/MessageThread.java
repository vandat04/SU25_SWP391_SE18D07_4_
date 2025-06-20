/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.MessageNotification;

import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 *
 * @author ACER
 */
public class MessageThread {
     private int threadID;
    private int userID1;
    private int userID2;
    private Timestamp lastMessageDate;
    private int status;
    private Timestamp createdDate;

    // Constructors-------------------------------------------------------------
    public MessageThread() {}

    //--------------------------------------------------------------------------
    public int getThreadID() {
        return threadID;
    }

    public void setThreadID(int threadID) {
        this.threadID = threadID;
    }

    public int getUserID1() {
        return userID1;
    }

    public void setUserID1(int userID1) {
        this.userID1 = userID1;
    }

    public int getUserID2() {
        return userID2;
    }

    public void setUserID2(int userID2) {
        this.userID2 = userID2;
    }

    public Timestamp getLastMessageDate() {
        return lastMessageDate;
    }

    public void setLastMessageDate(Timestamp lastMessageDate) {
        this.lastMessageDate = lastMessageDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "MessageThread{" + "threadID=" + threadID + ", userID1=" + userID1 + ", userID2=" + userID2 + ", lastMessageDate=" + lastMessageDate + ", status=" + status + ", createdDate=" + createdDate + '}';
    }
    
}
