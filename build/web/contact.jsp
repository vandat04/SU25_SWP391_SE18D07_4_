<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên Hệ & Hỗ Trợ</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        :root {
            --background-color: #fdfaf6;
            --sidebar-bg: #ffffff;
            --primary-text: #3d3d3d;
            --secondary-text: #888;
            --accent-color: #8c6d46;
            --accent-hover: #7a5c35;
            --border-color: #e0d9cf;
            --shadow-color: rgba(0, 0, 0, 0.05);
            --font-heading: 'Playfair Display', serif;
            --font-body: 'Montserrat', sans-serif;
            --success-bg: #e9f7ef;
            --success-border: #b8e9d1;
            --success-text: #1e6641;
            --error-bg: #fdeaea;
            --error-border: #f8c9c9;
            --error-text: #a82a2a;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: var(--font-body);
            background-color: var(--background-color);
            color: var(--primary-text);
            display: flex;
            min-height: 100vh;
        }

        /* --- Sidebar --- */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-logo { padding: 1.5rem 2rem; text-align: center; border-bottom: 1px solid var(--border-color); }
        .sidebar-logo img { max-width: 80%; height: auto; }
        .sidebar-profile { text-align: center; padding: 2rem 1rem; }
        .sidebar-profile .avatar { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid var(--accent-color); margin-bottom: 1rem; }
        .sidebar-profile h3 { font-family: var(--font-heading); font-size: 1.2rem; margin-bottom: 0.25rem; }
        .sidebar-profile p { font-size: 0.9rem; color: #999; }
        .sidebar-nav { list-style-type: none; flex-grow: 1; margin-top: 1rem; }
        .sidebar-nav a { display: flex; align-items: center; padding: 1rem 2rem; color: var(--primary-text); text-decoration: none; font-weight: 500; transition: background-color 0.2s, color 0.2s; border-left: 4px solid transparent; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background-color: var(--background-color); color: var(--accent-color); border-left-color: var(--accent-color); }
        .sidebar-nav a i { width: 25px; margin-right: 1rem; font-size: 1.1rem; text-align: center; }
        .sidebar-logout { padding: 1rem 0; border-top: 1px solid var(--border-color); }
        .sidebar-logout a { text-decoration: none; color: var(--primary-text); }
        
        /* --- Main Content --- */
        .main-content { flex-grow: 1; padding: 2rem 3rem; overflow-y: auto; }
        .main-header { margin-bottom: 2rem; }
        .main-header h1 { font-family: var(--font-heading); font-size: 2.5rem; font-weight: 700; }
        .main-header p { color: var(--secondary-text); font-size: 1rem; }
        .panel { background-color: #fff; padding: 2.5rem; border-radius: 10px; border: 1px solid var(--border-color); box-shadow: 0 4px 15px var(--shadow-color); }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.75rem; font-weight: 500; }
        .form-group textarea { width: 100%; padding: 0.85rem 1rem; font-size: 1rem; font-family: var(--font-body); border: 1px solid var(--border-color); border-radius: 8px; resize: vertical; min-height: 150px; }
        .form-group textarea:focus { outline: none; border-color: var(--accent-color); box-shadow: 0 0 0 3px rgba(140, 109, 70, 0.15); }
        .btn { background: var(--accent-color); color: #fff; padding: 10px 20px; border: none; cursor: pointer; border-radius: 8px; font-size: 1rem; font-weight: 500;}
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 8px; border: 1px solid transparent; }
        .alert-success { color: var(--success-text); background-color: var(--success-bg); border-color: var(--success-border); }
        .alert-error { color: var(--error-text); background-color: var(--error-bg); border-color: var(--error-border); }
        .user-info { margin-bottom: 20px; background: #f4f4f4; padding: 15px; border-radius: 8px; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-logo"><a href="home"><img src="hinhanh/Logo/logocraft.png" alt="Craft Village Logo"></a></div>
        <c:if test="${not empty sessionScope.acc}">
            <div class="sidebar-profile">
                <img src="${not empty sessionScope.acc.avatarUrl ? sessionScope.acc.avatarUrl : 'https://i.pravatar.cc/150?u='}${sessionScope.acc.userID}" alt="Avatar nghệ nhân" class="avatar">
                <h3>${sessionScope.acc.userName}</h3>
                <p>Nghệ nhân</p>
            </div>
        </c:if>
        <ul class="sidebar-nav">
            <li><a href="seller"><i class="fas fa-tachometer-alt"></i> Bảng điều khiển</a></li>
            <li><a href="manageProduct"><i class="fas fa-palette"></i> Xưởng chế tác</a></li>
            <li><a href="#"><i class="fas fa-book"></i> Sổ đặt hàng</a></li>
            <li><a href="statistics"><i class="fas fa-chart-pie"></i> Thống kê</a></li>
            <li><a href="contact" class="active"><i class="fas fa-headset"></i> Liên hệ & Hỗ trợ</a></li>
        </ul>
        <div class="sidebar-logout">
            <a href="logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Đăng xuất</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Liên Hệ & Hỗ Trợ</h1>
            <p>Nếu bạn có bất kỳ câu hỏi hoặc góp ý nào, vui lòng gửi tin nhắn cho chúng tôi.</p>
        </header>

        <section class="panel">
             <c:if test="${param.success == 'true'}">
                <div class="alert alert-success">
                    Cảm ơn bạn! Tin nhắn của bạn đã được gửi thành công. Chúng tôi sẽ phản hồi sớm nhất có thể.
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    ${errorMessage}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.acc}">
                    <div class="user-info">
                        Bạn đang gửi tin nhắn với tư cách: <strong>${sessionScope.acc.userName}</strong>
                    </div>
                    <form action="contact" method="post">
                        <div class="form-group">
                            <label for="messageContent">Nội dung tin nhắn:</label>
                            <textarea id="messageContent" name="messageContent" rows="8" required placeholder="Nhập nội dung bạn cần hỗ trợ..."></textarea>
                        </div>
                        <button type="submit" class="btn">Gửi Tin Nhắn</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-error">
                        Vui lòng <a href="login">đăng nhập</a> để sử dụng chức năng này.
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

</body>
</html>
