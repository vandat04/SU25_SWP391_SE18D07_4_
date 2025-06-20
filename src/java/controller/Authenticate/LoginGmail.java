package controller.Authenticate;

//package controller;
//
//import com.google.gson.Gson;
//import com.google.gson.JsonObject;
//
//import java.io.IOException;
//
//import constant.Iconstant;
//import entity.Account.GoogleAccount;
//import entity.Account.Account;
//import DAO.DAO;
//import org.apache.http.client.ClientProtocolException;
//import org.apache.http.client.fluent.Form;  
//import org.apache.http.client.fluent.Request;
///**
// *
// * @author ASUS
// */
//public class LoginGmail {
//    public static String getToken(String code) throws ClientProtocolException, IOException {
//        System.out.println("Getting token with code: " + code);
//        
//        String response = Request.Post(Iconstant.GOOGLE_LINK_GET_TOKEN)
//                .bodyForm(
//                        Form.form()
//                        .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
//                        .add("client_secret", Iconstant.GOOGLE_CLIENT_SECRET)
//                        .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
//                        .add("code", code)
//                        .add("grant_type", Iconstant.GOOGLE_GRANT_TYPE)
//                        .build()
//                )
//                .execute()
//                .returnContent()
//                .asString();
//
//        System.out.println("Token response: " + response);
//
//        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
//        if (jobj.has("error")) {
//            throw new IOException("Error from Google: " + jobj.get("error").getAsString());
//        }
//        
//        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
//        System.out.println("Access token: " + accessToken);
//        return accessToken;
//    }
//
//    public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
//        String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken;
//        System.out.println("Getting user info from: " + link);
//        
//        String response = Request.Get(link)
//                .execute()
//                .returnContent()
//                .asString();
//        
//        System.out.println("User info response: " + response);
//
//        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
//        if (jobj.has("error")) {
//            throw new IOException("Error from Google: " + jobj.get("error").getAsString());
//        }
//
//        GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);
//        System.out.println("Parsed Google account: " + googlePojo);
//        
//        return googlePojo;
//    }
//
//    public static String getRedirectUrl(String email) {
//        DAO dao = new DAO();
//        Account account = dao.loginByEmail(email);
//        
//        if (account == null) {
//            return "Login.jsp"; // Redirect to login page if account not found
//        }
//        
//        // Redirect based on roleID
//        if (account.getRoleID() == 3) { // Admin
//            return "admin";
//        } else if (account.getRoleID() == 2) { // Seller
//            return "seller";
//        } else { // User (roleID == 1)
//            return "home";
//        }
//    }
//}