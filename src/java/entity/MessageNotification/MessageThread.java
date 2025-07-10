/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.MessageNotification;

/**
 *
 * @author ACER
 */
public class MessageThread {

    private int threadID;
    private int userID1;
    private int sellerID2;
    private String messageName;

    // Constructors-------------------------------------------------------------
    public MessageThread() {
    }

    public MessageThread(int threadID, int userID1, int sellerID2, String messageName) {
        this.threadID = threadID;
        this.userID1 = userID1;
        this.sellerID2 = sellerID2;
        this.messageName = messageName;
    }

    public MessageThread(int userID1, int sellerID2) {
        this.userID1 = userID1;
        this.sellerID2 = sellerID2;
    }
    
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

    public int getSellerID2() {
        return sellerID2;
    }

    public void setSellerID2(int sellerID2) {
        this.sellerID2 = sellerID2;
    }

    public String getMessageName() {
        return messageName;
    }

    public void setMessageName(String messageName) {
        this.messageName = messageName;
    }

    @Override
    public String toString() {
        return "MessageThread{" + "threadID=" + threadID + ", userID1=" + userID1 + ", sellerID2=" + sellerID2 + ", messageName=" + messageName + '}';
    }
}
