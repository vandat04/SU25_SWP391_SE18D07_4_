package controller.Authenticate;

import DAO.AccountDAO;
import entity.Account.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.AccountService;

@WebServlet(name = "RegisterControl", urlPatterns = {"/register"})
public class RegisterControl extends HttpServlet {

    AccountDAO aDAO = new AccountDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from form
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");
            String rePassword = request.getParameter("rePassword");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String phoneNumber = request.getParameter("phoneNumber");
            
            // Validate form data
            if (userName == null || userName.isEmpty() || 
                password == null || password.isEmpty() || 
                email == null || email.isEmpty()) {
                request.setAttribute("error", "Please fill all required fields");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }
            
            // Check if passwords match
            if (!password.equals(rePassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }
            
            
            // Call stored procedure with all required parameters
            AccountService aSer = new AccountService();
            
            boolean success = aSer.register(new Account(userName, password, email, address, phoneNumber));
            
            if (success) {
                // Registration successful, automatically log in
                Account a = aDAO.loginAccount(email, password);
                if (a != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("account", a);
                    response.sendRedirect("home");
                } else {
                    request.setAttribute("error", "Registration successful but login failed");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "UserName or Email was existed");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("Register.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Register Control Servlet";
    }
}