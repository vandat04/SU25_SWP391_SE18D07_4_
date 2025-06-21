
package controller.Authenticate;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import constant.Iconstant;
import entity.Account.GoogleAccount;
import java.io.IOException;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.ClientProtocolException;


public class LoginGmail {

    public static String getToken(String code) throws ClientProtocolException, IOException {
        System.out.println("Getting token with code: " + code);
        
        String response = Request.Post(Iconstant.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                        .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
                        .add("client_secret", Iconstant.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", Iconstant.GOOGLE_GRANT_TYPE)
                        .build()
                )
                .execute()
                .returnContent()
                .asString();

        System.out.println("Token response: " + response);

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        System.out.println("Access token: " + accessToken);
        return accessToken;
    }

    public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken;
        System.out.println("Getting user info from: " + link);
        
        String response = Request.Get(link)
                .execute()
                .returnContent()
                .asString();
        
        System.out.println("User info response: " + response);

        GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);
        System.out.println("Parsed Google account: " + googlePojo);
        
        return googlePojo;
    }
}