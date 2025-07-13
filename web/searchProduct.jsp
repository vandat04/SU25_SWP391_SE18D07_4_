<%-- CHÚ THÍCH: TRANG JSP MỚI HOÀN TOÀN --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Tìm Kiếm Sản Phẩm</title>
    <link rel="stylesheet" href="path/to/your/styles.css">
    <style>
        /* CSS đơn giản để trang dễ nhìn hơn */
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 1200px; margin: auto; }
        .search-form { background-color: #f4f4f4; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .form-group { margin-bottom: 10px; }
        .form-group label { display: inline-block; width: 100px; }
        .form-group input { padding: 8px; width: 200px; }
        .btn { padding: 10px 15px; background-color: #007bff; color: white; border: none; cursor: pointer; border-radius: 4px; }
        .btn:hover { background-color: #0056b3; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .error-message { color: red; font-weight: bold; }
        .no-results { color: #888; font-style: italic; }
        .product-image { max-width: 80px; height: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Tìm Kiếm Sản Phẩm</h1>
        <p>Tìm kiếm trong danh sách sản phẩm bạn đang quản lý.</p>
        <a href="manageProduct">Quay lại trang quản lý chính</a>

        <div class="search-form">
            <form action="searchProduct" method="get">
                <div class="form-group">
                    <label for="pid">Mã Sản Phẩm:</label>
                    <input type="text" id="pid" name="pid" value="${searchedPid}">
                </div>
                <div class="form-group">
                    <label>Khoảng Giá:</label>
                    <input type="number" name="minPrice" placeholder="Từ" value="${searchedMinPrice}">
                    -
                    <input type="number" name="maxPrice" placeholder="Đến" value="${searchedMaxPrice}">
                </div>
                <button type="submit" class="btn">Tìm Kiếm</button>
            </form>
        </div>

        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

        <h2>Kết Quả Tìm Kiếm</h2>
        
        <table>
            <thead>
                <tr>
                    <th>Ảnh</th>
                    <th>ID</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Giá</th>
                    <th>Tồn Kho</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty productList}">
                        <c:forEach var="p" items="${productList}">
                            <tr>
                                <td><img src="${p.mainImageUrl}" alt="${p.name}" class="product-image"></td>
                                <td>${p.pid}</td>
                                <td>${p.name}</td>
                                <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>${p.stock}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status == 1}">Hoạt động</c:when>
                                        <c:when test="${p.status == 0}">Chờ duyệt</c:when>
                                        <c:when test="${p.status == 2}">Đã ẩn</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <%-- Liên kết đến servlet chỉnh sửa và xóa của bạn --%>
                                    <a href="editProduct?pid=${p.pid}">Sửa</a> |
                                    <a href="deleteProduct?pid=${p.pid}" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="no-results">Không tìm thấy sản phẩm nào phù hợp.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>