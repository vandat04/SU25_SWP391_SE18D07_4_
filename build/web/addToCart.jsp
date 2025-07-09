<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.JSONObject"%>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    String productId = request.getParameter("productId");
    JSONObject result = new JSONObject();
    
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userID");
    if (userId == null) {
        result.put("success", false);
        result.put("message", "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng");
        out.print(result.toString());
        return;
    }
    
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=craft;encrypt=true;trustServerCertificate=true";
        String username = "sa";
        String password = "12345";
        Connection conn = DriverManager.getConnection(url, username, password);
        
        // Get or create cart
        String cartSql = "SELECT cartID FROM Cart WHERE userID = ?";
        PreparedStatement cartStmt = conn.prepareStatement(cartSql);
        cartStmt.setInt(1, userId);
        ResultSet cartRs = cartStmt.executeQuery();
        
        int cartId;
        if (cartRs.next()) {
            cartId = cartRs.getInt("cartID");
        } else {
            String insertCartSql = "INSERT INTO Cart (userID, createdDate) VALUES (?, GETDATE())";
            PreparedStatement insertCartStmt = conn.prepareStatement(insertCartSql, Statement.RETURN_GENERATED_KEYS);
            insertCartStmt.setInt(1, userId);
            insertCartStmt.executeUpdate();
            
            ResultSet generatedKeys = insertCartStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                cartId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Creating cart failed, no ID obtained.");
            }
            generatedKeys.close();
            insertCartStmt.close();
        }
        cartRs.close();
        cartStmt.close();
        
        // Check if product already in cart
        String checkSql = "SELECT itemID, quantity FROM CartItem WHERE cartID = ? AND productID = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setInt(1, cartId);
        checkStmt.setInt(2, Integer.parseInt(productId));
        ResultSet checkRs = checkStmt.executeQuery();
        
        if (checkRs.next()) {
            // Update quantity
            String updateSql = "UPDATE CartItem SET quantity = quantity + 1, updatedDate = GETDATE() WHERE itemID = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, checkRs.getInt("itemID"));
            updateStmt.executeUpdate();
            updateStmt.close();
        } else {
            // Add new item
            String insertSql = "INSERT INTO CartItem (cartID, productID, quantity, createdDate) VALUES (?, ?, 1, GETDATE())";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, cartId);
            insertStmt.setInt(2, Integer.parseInt(productId));
            insertStmt.executeUpdate();
            insertStmt.close();
        }
        
        checkRs.close();
        checkStmt.close();
        conn.close();
        
        result.put("success", true);
        result.put("message", "Đã thêm sản phẩm vào giỏ hàng");
        
    } catch(Exception e) {
        e.printStackTrace();
        result.put("success", false);
        result.put("message", "Có lỗi xảy ra: " + e.getMessage());
    }
    
    out.print(result.toString());
%> 