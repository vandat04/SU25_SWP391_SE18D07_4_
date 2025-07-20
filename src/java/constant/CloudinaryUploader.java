package constant;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryUploader {

    public static String uploadFile(Part filePart) {
        String imageUrl = "";
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

                // Upload với byte[] (được hỗ trợ rõ ràng)
                Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.emptyMap());

                imageUrl = (String) uploadResult.get("secure_url");
            } else {

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return imageUrl;
    }
}
