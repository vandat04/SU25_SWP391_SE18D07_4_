import constant.CloudinaryUploader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpRequest.BodyPublishers;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.json.JSONObject;
import org.json.JSONArray;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.RenderingHints;
import java.awt.Image;
import javax.imageio.ImageIO;
import java.io.ByteArrayOutputStream;
import java.awt.Color;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/ImageTo3DServlet")
@MultipartConfig
public class ImageTo3DServlet extends HttpServlet {
    private static final String MESHY_API_KEY = "msy_NwhmT6GtsfDF0Nlq2a2HgO9vb1JEQ2803Fpd";
    private static final boolean DEMO_MODE = false; // Tắt demo mode vì đã tìm thấy endpoint hoạt động
    
    // Performance optimization constants
    private static final int TARGET_SIZE = 512;
    private static final float JPEG_QUALITY = 0.7f;
    private static final int BLACK_THRESHOLD = 30;
    private static final double BLACK_PIXEL_RATIO = 0.33;
    private static final int SAMPLE_STEP = 10;
    
    // Caching for performance
    private static final ConcurrentHashMap<String, String> imageCache = new ConcurrentHashMap<>();
    private static final ExecutorService imageProcessingExecutor = Executors.newFixedThreadPool(2);
    
    // Optimized image processing with better algorithms
    private static class OptimizedImageProcessor {
        
        /**
         * Fast image processing with optimized algorithms
         */
        public static String processImageOptimized(Part imagePart) throws IOException {
            String cacheKey = generateCacheKey(imagePart);
            
            // Check cache first
            String cachedResult = imageCache.get(cacheKey);
            if (cachedResult != null) {
                System.out.println("🚀 Using cached image processing result");
                return cachedResult;
            }
            
            System.out.println("⚡ Starting optimized image processing...");
            long startTime = System.currentTimeMillis();
            
            try (InputStream is = imagePart.getInputStream()) {
                BufferedImage originalImage = ImageIO.read(is);
                
                // Fast processing pipeline
                BufferedImage processedImage = processImagePipeline(originalImage, imagePart.getContentType());
                
                // Optimized encoding
                String base64Result = encodeImageOptimized(processedImage, imagePart.getContentType());
                
                // Cache the result
                imageCache.put(cacheKey, base64Result);
                
                long processingTime = System.currentTimeMillis() - startTime;
                System.out.println("⚡ Image processing completed in " + processingTime + "ms");
                
                return base64Result;
            }
        }
        
        /**
         * Optimized image processing pipeline
         */
        private static BufferedImage processImagePipeline(BufferedImage original, String contentType) {
            int width = original.getWidth();
            int height = original.getHeight();
            
            // Step 1: Fast background detection and conversion
            BufferedImage bgProcessed = processBackgroundOptimized(original);
            
            // Step 2: Fast square cropping
            BufferedImage cropped = cropToSquareOptimized(bgProcessed);
            
            // Step 3: Fast high-quality resizing
            BufferedImage resized = resizeOptimized(cropped, TARGET_SIZE, TARGET_SIZE);
            
            return resized;
        }
        
        /**
         * Optimized background processing
         */
        private static BufferedImage processBackgroundOptimized(BufferedImage img) {
            boolean hasAlpha = img.getColorModel().hasAlpha();
            boolean isMostlyBlack = fastBlackDetection(img);
            
            if (!hasAlpha && !isMostlyBlack) {
                return img; // No processing needed
            }
            
            int width = img.getWidth();
            int height = img.getHeight();
            
            // Create white background image
            BufferedImage whiteBg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = whiteBg.createGraphics();
            
            // Optimize rendering quality
            g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            
            // Fill white background
            g2d.setColor(Color.WHITE);
            g2d.fillRect(0, 0, width, height);
            
            // Draw original image
            g2d.drawImage(img, 0, 0, null);
            g2d.dispose();
            
            return whiteBg;
        }
        
        /**
         * Fast black pixel detection using sampling
         */
        public static boolean fastBlackDetection(BufferedImage img) {
            int width = img.getWidth();
            int height = img.getHeight();
            int blackPixels = 0;
            int totalSamples = 0;
            
            // Sample pixels with step to improve performance
            for (int y = 0; y < height; y += SAMPLE_STEP) {
                for (int x = 0; x < width; x += SAMPLE_STEP) {
                    int rgb = img.getRGB(x, y);
                    int r = (rgb >> 16) & 0xff;
                    int g = (rgb >> 8) & 0xff;
                    int b = rgb & 0xff;
                    
                    if (r < BLACK_THRESHOLD && g < BLACK_THRESHOLD && b < BLACK_THRESHOLD) {
                        blackPixels++;
                    }
                    totalSamples++;
                }
            }
            
            return totalSamples > 0 && (double) blackPixels / totalSamples > BLACK_PIXEL_RATIO;
        }
        
        /**
         * Optimized square cropping
         */
        private static BufferedImage cropToSquareOptimized(BufferedImage img) {
            int width = img.getWidth();
            int height = img.getHeight();
            
            if (width == height) {
                return img; // Already square
            }
            
            int size = Math.min(width, height);
            int x = (width - size) / 2;
            int y = (height - size) / 2;
            
            return img.getSubimage(x, y, size, size);
        }
        
        /**
         * High-quality optimized resizing
         */
        private static BufferedImage resizeOptimized(BufferedImage img, int targetWidth, int targetHeight) {
            if (img.getWidth() == targetWidth && img.getHeight() == targetHeight) {
                return img; // No resize needed
            }
            
            BufferedImage resized = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = resized.createGraphics();
            
            // High-quality rendering hints
            g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g2d.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
            
            // Draw resized image
            g2d.drawImage(img, 0, 0, targetWidth, targetHeight, null);
            g2d.dispose();
            
            return resized;
        }
        
        /**
         * Optimized image encoding
         */
        private static String encodeImageOptimized(BufferedImage img, String originalContentType) throws IOException {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            String finalContentType;
            
            if (originalContentType != null && originalContentType.toLowerCase().contains("jpeg")) {
                // Optimized JPEG encoding
                encodeJPEGOptimized(img, baos);
                finalContentType = "image/jpeg";
            } else {
                // PNG encoding
                ImageIO.write(img, "png", baos);
                finalContentType = "image/png";
            }
            
            byte[] imageBytes = baos.toByteArray();
            return "data:" + finalContentType + ";base64," + java.util.Base64.getEncoder().encodeToString(imageBytes);
        }
        
        /**
         * Optimized JPEG encoding
         */
        private static void encodeJPEGOptimized(BufferedImage img, ByteArrayOutputStream baos) throws IOException {
            javax.imageio.ImageWriter writer = ImageIO.getImageWritersByFormatName("jpg").next();
            javax.imageio.ImageWriteParam params = writer.getDefaultWriteParam();
            
            // Set compression quality
            params.setCompressionMode(javax.imageio.ImageWriteParam.MODE_EXPLICIT);
            params.setCompressionQuality(JPEG_QUALITY);
            
            // Write image
            writer.setOutput(ImageIO.createImageOutputStream(baos));
            writer.write(null, new javax.imageio.IIOImage(img, null, null), params);
            writer.dispose();
        }
        
        /**
         * Generate cache key for image
         */
        private static String generateCacheKey(Part imagePart) {
            return imagePart.getSubmittedFileName() + "_" + imagePart.getSize() + "_" + imagePart.getContentType();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra nếu đây là request test API key
        String action = request.getParameter("action");
        if ("testApiKey".equals(action)) {
            testApiKey(request, response);
            return;
        }
        
        // Check if this is a generate or upload for product action
        boolean generateForProduct = "generateForProduct".equals(action);
        boolean uploadForProduct = "uploadForProduct".equals(action);
        String productId = request.getParameter("productId");
        
        Collection<Part> parts = request.getParts();
        
        // Handle upload 3D model file
        if (uploadForProduct) {
            System.out.println("🔍 DEBUG: Starting 3D model upload for product ID: " + productId);
            
            List<Part> modelParts = new ArrayList<>();
            for (Part part : parts) {
                System.out.println("🔍 DEBUG: Found part: " + part.getName() + ", size: " + part.getSize());
                if ("modelFile".equals(part.getName()) && part.getSize() > 0) {
                    modelParts.add(part);
                }
            }
            
            if (modelParts.size() != 1) {
                String errorMsg = "Vui lòng upload đúng 1 file 3D model! (Found: " + modelParts.size() + " files)";
                System.out.println("❌ ERROR: " + errorMsg);
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
                return;
            }
            
            // Upload 3D model file to Cloudinary
            Part modelFile = modelParts.get(0);
            System.out.println("🔍 DEBUG: Uploading file: " + modelFile.getSubmittedFileName() + ", size: " + modelFile.getSize());
            
            String cloudinaryUrl = CloudinaryUploader.uploadRaw(modelFile);
            System.out.println("🔍 DEBUG: Cloudinary upload result: " + cloudinaryUrl);
            
            if (cloudinaryUrl != null && !cloudinaryUrl.isEmpty()) {
                // Save to product database
                try {
                    service.ProductService ps = new service.ProductService();
                    entity.Product.Product product = ps.getProductByID(productId);
                    
                    if (product != null) {
                        System.out.println("🔍 DEBUG: Product found - Name: " + product.getName() + ", ID: " + product.getPid());
                        
                        boolean updateSuccess = ps.updateProductModelFile(product.getPid(), cloudinaryUrl);
                        System.out.println("🔍 DEBUG: Database update result: " + updateSuccess);
                        
                        if (updateSuccess) {
                            String successMsg = "3D model uploaded and saved to product successfully!";
                            System.out.println("✅ SUCCESS: " + successMsg);
                            request.setAttribute("message", successMsg);
                            request.setAttribute("productUpdated", true);
                            request.setAttribute("modelUrl", cloudinaryUrl);
                        } else {
                            String errorMsg = "Failed to save 3D model to product database.";
                            System.out.println("❌ ERROR: " + errorMsg);
                            request.setAttribute("error", errorMsg);
                        }
                    } else {
                        String errorMsg = "Product not found for ID: " + productId;
                        System.out.println("❌ ERROR: " + errorMsg);
                        request.setAttribute("error", errorMsg);
                    }
                } catch (Exception e) {
                    String errorMsg = "Error saving 3D model to product: " + e.getMessage();
                    System.err.println("❌ EXCEPTION: " + errorMsg);
                    e.printStackTrace();
                    request.setAttribute("error", errorMsg);
                }
            } else {
                String errorMsg = "Failed to upload 3D model to Cloudinary. Please check your file format and try again.";
                System.out.println("❌ ERROR: " + errorMsg);
                request.setAttribute("error", errorMsg);
            }
            
            // Set attributes for the page
            request.setAttribute("uploadForProduct", true);
            request.setAttribute("productId", productId);
            request.setAttribute("productName", request.getParameter("productName"));
            
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        // Handle image upload for 3D generation
        List<Part> imageParts = new ArrayList<>();
        for (Part part : parts) {
            if ("images".equals(part.getName()) && part.getSize() > 0) {
                imageParts.add(part);
            }
        }
        if (imageParts.size() != 1) {
            request.setAttribute("error", "Vui lòng upload đúng 1 hình ảnh!");
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        if (DEMO_MODE) {
            // Demo mode: tạo response giả lập
            System.out.println("Running in DEMO MODE");
            
            // Simulate processing time
            try { Thread.sleep(2000); } catch (InterruptedException e) {}
            
            // Mock 3D model URL (sample GLB file)
            String demoModelUrl = "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
            request.setAttribute("modelUrl", demoModelUrl);
            request.setAttribute("demoMode", true);
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        HttpClient client = HttpClient.newHttpClient();
        
        // Sử dụng endpoint v1 đã hoạt động
        String apiUrl = "https://api.meshy.ai/v1/image-to-3d";
        
        System.out.println("Using working endpoint: " + apiUrl);
        
        // Use optimized image processing with performance monitoring
        Part firstImage = imageParts.get(0);
        String base64Image;
        
        long imageProcessingStart = System.currentTimeMillis();
        try {
            base64Image = OptimizedImageProcessor.processImageOptimized(firstImage);
            logPerformanceMetrics("Image processing", imageProcessingStart);
        } catch (Exception e) {
            System.err.println("❌ Image processing error: " + e.getMessage());
            request.setAttribute("error", "Lỗi xử lý ảnh: " + e.getMessage());
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        // Tạo JSON body theo format API v1
        JSONObject requestBody = new JSONObject();
        requestBody.put("mode", "preview");
        requestBody.put("image_url", base64Image);
        
        System.out.println("Sending request to: " + apiUrl);
        System.out.println("Request body size: " + requestBody.toString().length() + " chars");
        
        HttpResponse<String> meshResp = null;
        try {
            meshResp = client.send(HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .header("Authorization", "Bearer " + MESHY_API_KEY)
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .timeout(java.time.Duration.ofSeconds(120)) // Tăng timeout lên 2 phút
                .POST(BodyPublishers.ofString(requestBody.toString()))
                .build(),
                HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            request.setAttribute("error", "Quá trình gửi request bị gián đoạn!");
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        } catch (java.net.http.HttpTimeoutException e) {
            request.setAttribute("error", "Request timeout! Vui lòng thử lại sau hoặc kiểm tra kết nối mạng.");
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        System.out.println("Response: " + meshResp.statusCode() + " - " + meshResp.body());
        
        // Chấp nhận 200, 201, 202 là hợp lệ
        if (meshResp.statusCode() != 200 && meshResp.statusCode() != 201 && meshResp.statusCode() != 202) {
            // Nếu v1 không work, thử openapi/v1
            if (meshResp.statusCode() == 404 || meshResp.statusCode() >= 400) {
                apiUrl = "https://api.meshy.ai/openapi/v1/image-to-3d";
                System.out.println("Trying alternative v1 endpoint: " + apiUrl);
                try {
                    meshResp = client.send(HttpRequest.newBuilder()
                        .uri(URI.create(apiUrl))
                        .header("Authorization", "Bearer " + MESHY_API_KEY)
                        .header("Content-Type", "application/json")
                        .header("Accept", "application/json")
                        .timeout(java.time.Duration.ofSeconds(120)) // Thêm timeout cho alternative endpoint
                        .POST(BodyPublishers.ofString(requestBody.toString()))
                        .build(),
                        HttpResponse.BodyHandlers.ofString());
                    System.out.println("Alternative v1 Response: " + meshResp.statusCode() + " - " + meshResp.body());
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } catch (java.net.http.HttpTimeoutException e) {
                    System.out.println("Alternative endpoint timeout: " + e.getMessage());
                }
            }
        }
        // Nếu vẫn không phải 200, 201, 202 thì báo lỗi
        if (meshResp.statusCode() != 200 && meshResp.statusCode() != 201 && meshResp.statusCode() != 202) {
            String errorMsg = "Meshy API lỗi: " + meshResp.statusCode() + " - " + meshResp.body();
            if (meshResp.statusCode() == 400) {
                errorMsg += "\n\nLỗi dữ liệu đầu vào. Có thể:\n" +
                           "- Ảnh quá lớn (> 10MB)\n" +
                           "- Format ảnh không hỗ trợ\n" +
                           "- Base64 encoding lỗi";
            } else if (meshResp.statusCode() == 401) {
                errorMsg += "\n\nAPI key không hợp lệ hoặc hết hạn";
            } else if (meshResp.statusCode() == 403) {
                errorMsg += "\n\nTài khoản hết credits hoặc không có quyền";
            } else if (meshResp.statusCode() == 429) {
                errorMsg += "\n\nQuá nhiều request - vui lòng thử lại sau";
            }
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        // Parse response để lấy task ID
        JSONObject meshJson = new JSONObject(meshResp.body());
        String taskId = meshJson.optString("result", meshJson.optString("id", meshJson.optString("task_id", "")));
        
        if (taskId.isEmpty()) {
            request.setAttribute("error", "Không thể lấy task ID từ response: " + meshResp.body());
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ Task created successfully! ID: " + taskId);
        
        // Poll task status với endpoint v1
        String status = "";
        JSONObject taskJson = null;
        int maxTry = 120; // Tăng lên 10 phút (120 × 5 giây)
        
        while (maxTry-- > 0) {
            HttpRequest pollReq = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/" + taskId))
                    .header("Authorization", "Bearer " + MESHY_API_KEY)
                    .header("Accept", "application/json")
                    .timeout(java.time.Duration.ofSeconds(30)) // Timeout 30 giây cho mỗi poll
                    .GET().build();
            
            HttpResponse<String> pollResp = null;
            try {
                pollResp = client.send(pollReq, HttpResponse.BodyHandlers.ofString());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                request.setAttribute("error", "Quá trình polling bị gián đoạn!");
                request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
                return;
            } catch (java.net.http.HttpTimeoutException e) {
                System.out.println("Poll timeout at attempt " + (120 - maxTry) + "/120");
                // Tiếp tục thử lại thay vì dừng
                try { Thread.sleep(5000); } catch (InterruptedException ie) { break; }
                continue;
            }
            
            System.out.println("Poll " + (120 - maxTry) + "/120: " + pollResp.statusCode() + " - " + pollResp.body());
            
            if (pollResp.statusCode() != 200) {
                request.setAttribute("error", "Lỗi khi kiểm tra task status: " + pollResp.statusCode() + " - " + pollResp.body());
                request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
                return;
            }
            
            taskJson = new JSONObject(pollResp.body());
            status = taskJson.optString("status", "");
            
            System.out.println("Current status: " + status);
            
            if ("SUCCEEDED".equals(status) || "COMPLETED".equals(status)) {
                break;
            }
            if ("FAILED".equals(status) || "ERROR".equals(status)) {
                request.setAttribute("error", "Tạo mô hình 3D thất bại! Lý do: " + taskJson.optString("error", "Không rõ"));
                request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
                return;
            }
            
            // Sleep 5 giây giữa các lần poll
            try { Thread.sleep(5000); } catch (InterruptedException e) { break; }
        }
        
        if (!"SUCCEEDED".equals(status) && !"COMPLETED".equals(status)) {
            request.setAttribute("error", "Tạo mô hình 3D timeout sau 10 phút! Status cuối: " + status + "\n\nCó thể do:\n- Kết nối mạng chậm\n- Server Meshy bận\n- Ảnh quá phức tạp\n\nVui lòng thử lại sau hoặc sử dụng ảnh đơn giản hơn.");
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        // Lấy URL file GLB
        String glbUrl = null;
        if (taskJson.has("model_urls")) {
            JSONObject modelUrls = taskJson.getJSONObject("model_urls");
            glbUrl = modelUrls.optString("glb", modelUrls.optString("model", ""));
        } else if (taskJson.has("model_url")) {
            glbUrl = taskJson.getString("model_url");
        } else if (taskJson.has("result_url")) {
            glbUrl = taskJson.getString("result_url");
        }
        
        if (glbUrl == null || glbUrl.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy URL mô hình 3D trong response: " + taskJson.toString());
            request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
            return;
        }
        
        System.out.println("🎉 SUCCESS! Model URL: " + glbUrl);
        request.setAttribute("modelUrl", glbUrl);
        
        // Upload to Cloudinary and get the link
        String cloudinaryLink = CloudinaryUploader.uploadRawFromUrl(glbUrl);
        System.out.println("Cloudinary Link: " + cloudinaryLink);
        
        request.setAttribute("demoMode", false);
        
        // If generating for a specific product, save the 3D model to the product
        if (generateForProduct && productId != null && !productId.isEmpty()) {
            try {
                System.out.println("🔍 DEBUG: Starting to save 3D model for productId=" + productId);
                System.out.println("🔍 DEBUG: Cloudinary link=" + cloudinaryLink);
                
                service.ProductService ps = new service.ProductService();
                entity.Product.Product product = ps.getProductByID(productId);
                
                if (product != null) {
                    System.out.println("🔍 DEBUG: Product found - Name: " + product.getName() + ", Current modelFile: " + product.getModelFile());
                    System.out.println("🔍 DEBUG: Product ID: " + product.getPid() + ", Status: " + product.getStatus());
                    
                    // Use the Cloudinary link instead of the original Meshy URL
                    product.setModelFile(cloudinaryLink);
                    System.out.println("🔍 DEBUG: Setting new modelFile: " + cloudinaryLink);
                    
                    try {
                        boolean updateSuccess = ps.updateProductModelFile(product.getPid(), cloudinaryLink);
                        System.out.println("🔍 DEBUG: Update result: " + updateSuccess);
                        
                        if (updateSuccess) {
                            request.setAttribute("message", "3D model generated and saved to product successfully!");
                            request.setAttribute("productUpdated", true);
                        } else {
                            System.out.println("🔍 DEBUG: Update returned false - simple update may have failed");
                            request.setAttribute("warning", "3D model generated but failed to save to product. Please update manually.");
                        }
                    } catch (Exception updateEx) {
                        System.err.println("🔍 DEBUG: Exception during updateProductModelFile: " + updateEx.getMessage());
                        updateEx.printStackTrace();
                        request.setAttribute("warning", "3D model generated but failed to save to product. Please update manually.");
                    }
                } else {
                    System.out.println("🔍 DEBUG: Product not found for ID: " + productId);
                    request.setAttribute("warning", "3D model generated but product not found. Please update manually.");
                }
            } catch (Exception e) {
                System.err.println("🔍 DEBUG: Exception saving 3D model to product: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("warning", "3D model generated but failed to save to product. Please update manually.");
            }
        }
        
        request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
    }
    
    private void testApiKey(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpClient client = HttpClient.newHttpClient();
        StringBuilder testResult = new StringBuilder();
        boolean isValid = false;
        
        testResult.append("🔍 CHẨN ĐOÁN API KEY: ").append(MESHY_API_KEY.substring(0, 15)).append("...\n\n");
        
        try {
            // Test với documentation endpoint được tìm thấy
            testResult.append("📚 KIỂM TRA DOCUMENTATION:\n");
            try {
                HttpRequest docReq = HttpRequest.newBuilder()
                    .uri(URI.create("https://docs.meshy.ai/en/api/image-to-3d"))
                    .timeout(java.time.Duration.ofSeconds(15)) // Tăng timeout lên 15 giây
                    .GET().build();
                
                HttpResponse<String> docResp = client.send(docReq, HttpResponse.BodyHandlers.ofString());
                testResult.append("   Docs page: ").append(docResp.statusCode()).append(" ✅\n");
                testResult.append("   → Documentation accessible, API cấu trúc có thể đã thay đổi\n\n");
            } catch (Exception e) {
                testResult.append("   Docs page: ERROR - ").append(e.getMessage()).append("\n\n");
            }
            
            // Test các endpoint phổ biến khác
            String[] commonEndpoints = {
                "https://api.meshy.ai/v1/tasks",
                "https://api.meshy.ai/v2/tasks", 
                "https://api.meshy.ai/v1/image-to-3d",
                "https://api.meshy.ai/v2/image-to-3d",
                "https://api.meshy.ai/openapi/v1/image-to-3d",
                "https://api.meshy.ai/openapi/v2/image-to-3d"
            };
            
            testResult.append("🎯 TESTING COMMON ENDPOINTS:\n");
            for (String endpoint : commonEndpoints) {
                try {
                    HttpRequest testReq = HttpRequest.newBuilder()
                        .uri(URI.create(endpoint))
                        .header("Authorization", "Bearer " + MESHY_API_KEY)
                        .header("Accept", "application/json")
                        .timeout(java.time.Duration.ofSeconds(15)) // Tăng timeout lên 15 giây
                        .GET().build();
                    
                    HttpResponse<String> testResp = client.send(testReq, HttpResponse.BodyHandlers.ofString());
                    testResult.append("   ").append(endpoint).append(" → ").append(testResp.statusCode());
                    
                    if (testResp.statusCode() == 200) {
                        testResult.append(" ✅ SUCCESS!");
                        isValid = true;
                    } else if (testResp.statusCode() == 401) {
                        testResult.append(" 🔑 UNAUTHORIZED");
                    } else if (testResp.statusCode() == 403) {
                        testResult.append(" 🚫 FORBIDDEN");
                    } else if (testResp.statusCode() == 404) {
                        testResult.append(" ❌ NOT FOUND");
                    } else if (testResp.statusCode() == 405) {
                        testResult.append(" 🚫 METHOD NOT ALLOWED (endpoint tồn tại nhưng không cho GET)");
                    } else {
                        testResult.append(" ⚠️ ").append(testResp.statusCode());
                    }
                    testResult.append("\n");
                    
                } catch (java.net.http.HttpTimeoutException e) {
                    testResult.append("   ").append(endpoint).append(" → TIMEOUT (15s)\n");
                } catch (Exception e) {
                    testResult.append("   ").append(endpoint).append(" → ERROR: ").append(e.getMessage()).append("\n");
                }
            }
            
            testResult.append("\n🔍 PHÂN TÍCH:\n");
            testResult.append("• Tất cả endpoint trả về 404 → API structure đã thay đổi\n");
            testResult.append("• Documentation vẫn accessible → Service đang hoạt động\n");
            testResult.append("• Có thể cần:\n");
            testResult.append("  - API key format mới\n");
            testResult.append("  - Base URL mới\n");
            testResult.append("  - Authentication method khác\n");
            testResult.append("  - API version mới\n\n");
            
            testResult.append("📋 KẾT LUẬN:\n");
            testResult.append("API key có thể hợp lệ nhưng Meshy API đã thay đổi cấu trúc.\n");
            testResult.append("Khuyến nghị:\n");
            testResult.append("1. Kiểm tra docs mới tại: https://docs.meshy.ai\n");
            testResult.append("2. Liên hệ Meshy support\n");
            testResult.append("3. Sử dụng demo mode trong lúc chờ\n");
            
        } catch (Exception e) {
            testResult.append("❌ CRITICAL ERROR: ").append(e.getMessage());
        }
        
        request.setAttribute("apiKeyTestResult", testResult.toString());
        request.setAttribute("apiKeyValid", isValid);
        request.setAttribute("currentApiKey", MESHY_API_KEY);
        request.setAttribute("apiStatusMessage", "API structure đã thay đổi - sử dụng demo mode");
        request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("[DEBUG] ImageTo3DServlet doGet called. QueryString: " + request.getQueryString());
        
        String action = request.getParameter("action");
        if ("generateForProduct".equals(action)) {
            // Handle generate action for specific product
            String pidStr = request.getParameter("productId");
            String productName = request.getParameter("productName");
            
            // Debug logging
            System.out.println("[DEBUG] generateForProduct action detected");
            System.out.println("[DEBUG] productId: " + pidStr);
            System.out.println("[DEBUG] productName (raw): " + productName);
            
            if (pidStr != null && !pidStr.isEmpty()) {
                // URL decode the product name if it's encoded
                if (productName != null) {
                    try {
                        productName = java.net.URLDecoder.decode(productName, "UTF-8");
                        System.out.println("[DEBUG] productName (decoded): " + productName);
                    } catch (Exception e) {
                        System.out.println("[DEBUG] Error decoding productName: " + e.getMessage());
                    }
                }
                
                request.setAttribute("generateForProduct", true);
                request.setAttribute("productId", pidStr);
                request.setAttribute("productName", productName);
                request.setAttribute("message", "Ready to generate 3D model for: " + productName);
            }
        } else if ("uploadForProduct".equals(action)) {
            // Handle upload action for specific product
            String pidStr = request.getParameter("productId");
            String productName = request.getParameter("productName");
            
            // Debug logging
            System.out.println("[DEBUG] uploadForProduct action detected");
            System.out.println("[DEBUG] productId: " + pidStr);
            System.out.println("[DEBUG] productName (raw): " + productName);
            
            if (pidStr != null && !pidStr.isEmpty()) {
                // URL decode the product name if it's encoded
                if (productName != null) {
                    try {
                        productName = java.net.URLDecoder.decode(productName, "UTF-8");
                        System.out.println("[DEBUG] productName (decoded): " + productName);
                    } catch (Exception e) {
                        System.out.println("[DEBUG] Error decoding productName: " + e.getMessage());
                    }
                }
                
                request.setAttribute("uploadForProduct", true);
                request.setAttribute("productId", pidStr);
                request.setAttribute("productName", productName);
                request.setAttribute("message", "Ready to upload 3D model for: " + productName);
            }
        }
        
        request.getRequestDispatcher("ImageTo3D.jsp").forward(request, response);
    }

    /**
     * Cleanup method for servlet lifecycle
     */
    @Override
    public void destroy() {
        super.destroy();
        // Shutdown executor service gracefully
        if (imageProcessingExecutor != null && !imageProcessingExecutor.isShutdown()) {
            imageProcessingExecutor.shutdown();
            try {
                if (!imageProcessingExecutor.awaitTermination(5, TimeUnit.SECONDS)) {
                    imageProcessingExecutor.shutdownNow();
                }
            } catch (InterruptedException e) {
                imageProcessingExecutor.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
        
        // Clear cache to free memory
        imageCache.clear();
        System.out.println("🧹 ImageTo3DServlet cleanup completed");
    }
    
    /**
     * Performance monitoring method
     */
    private void logPerformanceMetrics(String operation, long startTime) {
        long duration = System.currentTimeMillis() - startTime;
        System.out.println("📊 Performance: " + operation + " completed in " + duration + "ms");
        
        // Log cache statistics
        System.out.println("📊 Cache stats: " + imageCache.size() + " cached images");
    }
    
    /**
     * Legacy method - kept for backward compatibility
     * @deprecated Use OptimizedImageProcessor.fastBlackDetection instead
     */
    @Deprecated
    private boolean isMostlyBlack(BufferedImage img) {
        return OptimizedImageProcessor.fastBlackDetection(img);
    }
}