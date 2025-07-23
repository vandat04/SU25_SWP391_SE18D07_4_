package constant;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryUploader {

    // Hàm upload ảnh (resource_type = image)
    public static String uploadImage(Part filePart) {
        return uploadFile(filePart, "image");
    }

    //  Hàm upload raw file (dùng cho .glb, .pdf, .zip, ...)
    public static String uploadRaw(Part filePart) {
        return uploadFile(filePart, "raw");
    }
    
    private static String uploadFile(Part filePart, String resourceType) {
        String fileUrl = "";
        try {
            if (filePart != null && filePart.getSize() > 0) {
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

                Cloudinary cloudinary = CloudinaryConfig.getInstance();

                // Upload với resource_type tương ứng
                Map uploadResult = cloudinary.uploader().upload(
                        fileBytes,
                        ObjectUtils.asMap("resource_type", resourceType)
                );

                fileUrl = (String) uploadResult.get("secure_url");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return fileUrl;
    }
}
