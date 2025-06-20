package service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private static final String FROM_EMAIL = "dreamtamiev@gmail.com"; 
    private static final String APP_PASSWORD = "rrvw bnag dnbe yazx"; 

    public static void sendEmail(String toEmail, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Bật TLS

        // Xác thực tài khoản email
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);
            System.out.println("✅ Email đã gửi thành công!");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        sendEmail("kaeturdream@gmail.com", "Test Subject", "This is a test email.");
    }
}
