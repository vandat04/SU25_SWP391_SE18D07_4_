package constant;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.Map;

public class CloudinaryUploader {

    // Hàm upload ảnh (resource_type = image)
    public static String uploadImage(Part filePart) {
        return uploadFile(filePart, "image");
    }

    //  Hàm upload raw file (dùng cho .glb, .pdf, .zip, ...)
    public static String uploadRaw(Part filePart) {
        System.out.println("🔍 DEBUG: CloudinaryUploader.uploadRaw() called");
        System.out.println("🔍 DEBUG: File part: " + (filePart != null ? "not null" : "null"));
        
        if (filePart == null) {
            System.out.println("❌ ERROR: File part is null");
            return "";
        }
        
        System.out.println("🔍 DEBUG: File name: " + filePart.getSubmittedFileName());
        System.out.println("🔍 DEBUG: File size: " + filePart.getSize());
        System.out.println("🔍 DEBUG: Content type: " + filePart.getContentType());
        
        return uploadFile(filePart, "raw");
    }

    private static String uploadFile(Part filePart, String resourceType) {
        String fileUrl = "";
        try {
            System.out.println("🔍 DEBUG: uploadFile() called with resourceType: " + resourceType);
            
            if (filePart != null && filePart.getSize() > 0) {
                System.out.println("🔍 DEBUG: File is valid, size: " + filePart.getSize());
                
                InputStream fileContent = filePart.getInputStream();

                // Chuyển InputStream thành byte[]
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                byte[] data = new byte[1024];
                int nRead;
                while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                buffer.flush();

                byte[] fileBytes = buffer.toByteArray();
                System.out.println("🔍 DEBUG: File converted to bytes, size: " + fileBytes.length);

                Cloudinary cloudinary = CloudinaryConfig.getInstance();
                System.out.println("🔍 DEBUG: Cloudinary instance created");

                // Upload với resource_type tương ứng
                System.out.println("🔍 DEBUG: Starting Cloudinary upload...");
                Map uploadResult = cloudinary.uploader().upload(
                        fileBytes,
                        ObjectUtils.asMap("resource_type", resourceType)
                );

                fileUrl = (String) uploadResult.get("secure_url");
                System.out.println("🔍 DEBUG: Cloudinary upload successful, URL: " + fileUrl);
            } else {
                System.out.println("❌ ERROR: File part is null or empty");
            }

        } catch (Exception e) {
            System.err.println("❌ EXCEPTION in uploadFile: " + e.getMessage());
            e.printStackTrace();
        }
        return fileUrl;
    }

    public static String uploadRawFromUrl(String glbUrl) {
        String fileUrl = "";
        try {
            URL url = new URL(glbUrl);
            InputStream inputStream = url.openStream();

            // Đọc dữ liệu từ URL thành byte[]
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            byte[] data = new byte[1024];
            int nRead;
            while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, nRead);
            }
            buffer.flush();
            byte[] fileBytes = buffer.toByteArray();

            Cloudinary cloudinary = CloudinaryConfig.getInstance();

            Map uploadResult = cloudinary.uploader().upload(
                    fileBytes,
                    ObjectUtils.asMap("resource_type", "raw") // vì .glb không phải ảnh
            );

            fileUrl = (String) uploadResult.get("secure_url");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return fileUrl;
    }
}