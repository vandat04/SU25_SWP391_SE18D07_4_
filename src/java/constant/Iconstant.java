package constant;

/**
 * Constants for application configuration
 * Note: Replace with your actual OAuth credentials in production
 * @author ASUS
 */
public class Iconstant {
    // TODO: Replace with your actual Google OAuth Client ID
    public static final String GOOGLE_CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID_HERE";

    // TODO: Replace with your actual Google OAuth Client Secret  
    public static final String GOOGLE_CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET_HERE";
    
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/DuAnBanHang/login";

    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static final String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";

    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=";
}
