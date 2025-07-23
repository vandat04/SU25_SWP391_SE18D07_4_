/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import entity.Account.Account;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ACER
 */
public interface IAccountService {

    boolean register(Account account) throws Exception;

    Account login(String username, String password);

    boolean updateProfile(Account account);

    boolean changePassword(int userId, String oldPwd, String newPwd);

    Account getAccountById(int userId);

    List<Account> getAllAccounts(int offset, int pageSize);

    boolean blockAccount(int userId);

    boolean verifyEmail(int userId);

    public Account loginByEmail(String email);

    boolean checkPhoneNumberExists(String phoneNumber);

    boolean checkUsernameExists(String username);

    boolean checkEmailExists(String email);
    
    boolean addNewAccountFull(Account account);
    
    List<Account> getSearchAccount(int status, int searchID, String contentSearch, int offset, int pageSize);
    
    Map<Integer, Integer> getRegistrationSummaryByMonthYear(int year);
    
    int getPointsByUserID(int userID);

    public boolean changePasswordByUserId(Integer userIdd, String newPassword);
    
    int findUserIdByUsernameOrEmail(String input);
    
    String getEmailByUserId(int userId);
    
    public List<Account> getAllAccounts();
}
