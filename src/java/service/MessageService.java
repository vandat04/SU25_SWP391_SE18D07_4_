/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.MessageDAO;
import entity.MessageNotification.MessageThread;
import entity.MessageNotification.Message;
import java.util.List;

/**
 *
 * @author ACER
 */
public class MessageService implements IMessageService {

    MessageDAO mDAO = new MessageDAO();

    @Override
    public List<MessageThread> getThreadsByUser(int userId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Message> getMessagesByThread(int threadId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int sendMessage(Message message) {
        return mDAO.sendMessage(message);
    }

    public Message getMessageByMessageId(int messageId) {
        return mDAO.getMessageByMessageId(messageId);
    }

    @Override
    public boolean markMessageAsRead(int messageId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean checkMessageThreadExist(int userID, int sellerID) {
        return mDAO.checkMessageThreadExist(userID, sellerID);
    }

    @Override
    public boolean addNewMessageThread(MessageThread messageThread) {
        return mDAO.addNewMessageThread(messageThread);
    }

    @Override
    public List<Message> getMessageByThreadID(int threadID, int userID) {
        return mDAO.getMessageByThreadID(threadID, userID);
    }

    public MessageThread getMessageThread(int userID, int sellerID) {
        return mDAO.getMessageThread(userID, sellerID);
    }

    @Override
    public List<MessageThread> getMessageThreadByUserID(int userId) {
        return mDAO.getMessageThreadByUserID(userId);
    }

    @Override
    public int getThreadID(int userID, int sellerID) {
        return mDAO.getThreadID(userID, sellerID);
    }

    public void markAsRead(int threadID) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<Message> getNewMessages(int threadID, int lastMessageID) {
        return mDAO.getNewMessages(threadID, lastMessageID);
    }

    public List<MessageThread> getAllMessageThreadBySellerId(int sellerId) {
        return mDAO.getAllMessageThreadBySellerId(sellerId);
    }

    public List<Message> getMessageBySeller(int threadID) {
        return mDAO.getMessageBySeller(threadID);
    }

    public List<Message> getMessageByThreadIDForSeller(int threadID, int sellerID) {
        return mDAO.getMessageByThreadIDForSeller(threadID, sellerID);
    }

    public List<Message> getNewMessagess(int threadID, int lastMessageID) {
        return mDAO.getMessagesAfterID(threadID, lastMessageID);
    }

    public void markMessagesAsReadBySeller(int threadID, int sellerID) {
        mDAO.updateUserReadBySeller(threadID, sellerID);
    }

}
