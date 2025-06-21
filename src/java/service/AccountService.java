/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import DAO.AccountDAO;
import DAO.WishlistDAO;
//import DAO.WishlistDAO;
import entity.Account.Account;
import java.util.List;

/**
 *
 * @author ACER
 */
public class AccountService implements IAccountService{

    AccountDAO aDAO = new AccountDAO();
    WishlistDAO wDAO = new WishlistDAO();

    @Override
    public Account login(String username, String password) {
        return aDAO.loginAccount(username,password);
    }

    @Override
    public boolean updateProfile(Account account) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean changePassword(int userId, String oldPwd, String newPwd) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Account getAccountById(int userId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Account> getAllAccounts() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean blockAccount(int userId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean verifyEmail(int userId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean register(Account account) throws Exception {
        return aDAO.registerAccount(account);
    }

    @Override
    public Account loginByEmail(String email) {
        return aDAO.loginByEmail(email);
    }

    @Override
    public boolean checkPhoneNumberExists(String phoneNumber) {
        return aDAO.checkPhoneNumberExists(phoneNumber);
    }

    @Override
    public boolean checkUsernameExists(String username) {
        return aDAO.checkUsernameExists(username);
    }

    @Override
    public boolean checkEmailExists(String email) {
        return aDAO.checkEmailExists(email);
    }
}
