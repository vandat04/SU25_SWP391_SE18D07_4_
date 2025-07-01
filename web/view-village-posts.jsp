<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bài Viết - ${village.villageName}</title>
    
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
        .main-header { margin-bottom: 2rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1.5rem; }
        .main-header h1 { font-family: var(--font-heading); font-size: 2.5rem; font-weight: 700; }
        .main-header p { color: var(--secondary-text); font-size: 1rem; margin-top: 0.5rem; }
        
        /* --- Post List --- */
        .post-list { display: flex; flex-direction: column; gap: 2.5rem; }
        .post-item { display: flex; flex-direction: column; gap: 1.5rem; background: #fff; padding: 1.5rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: transform 0.2s, box-shadow 0.2s; }
        .post-item:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
        .post-item img { width: 100%; height: 250px; object-fit: cover; border-radius: 5px; }
        .post-content { flex: 1; }
        .post-content h2 { margin: 0 0 10px; font-size: 1.6rem; font-family: var(--font-heading); }
        .post-content h2 a { text-decoration: none; color: var(--primary-text); }
        .post-content h2 a:hover { color: var(--accent-color); }
        .post-meta { font-size: 0.9em; color: #888; margin-bottom: 1rem; }
        .post-meta span { margin-right: 15px; }
        .post-excerpt { color: #555; line-height: 1.7; }
        .read-more { display: inline-block; margin-top: 1rem; font-weight: bold; color: var(--accent-color); text-decoration: none; }
        .read-more:hover { text-decoration: underline; }
        
        @media (min-width: 768px) {
            .post-item { flex-direction: row; }
            .post-item img { max-width: 300px; height: 200px; }
        }

    </style>
</head>
<body>

    <aside class="sidebar">
        <!-- Nội dung sidebar của bạn -->
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
            <li><a href="village-posts" class="active"><i class="fas fa-newspaper"></i> Quản lý bài đăng</a></li>
            <li><a href="statistics"><i class="fas fa-chart-pie"></i> Thống kê</a></li>
            <li><a href="contact"><i class="fas fa-headset"></i> Liên hệ & Hỗ trợ</a></li>
        </ul>
        <div class="sidebar-logout">
            <a href="logout" style="padding: 1rem 2rem;"><i class="fas fa-sign-out-alt" style="margin-right: 1rem; width: 25px; text-align: center;"></i> Đăng xuất</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Bài Viết & Câu Chuyện từ ${village.villageName}</h1>
            <p>${village.description}</p>
        </header>
        
        <div class="post-list">
            <c:forEach var="post" items="${postList}">
                <article class="post-item">
                    <c:if test="${not empty post.imageUrl}">
                        <a href="post-detail?id=${post.postID}">
                            <img src="${post.imageUrl}" alt="${post.title}" onerror="this.style.display='none'">
                        </a>
                    </c:if>
                    <div class="post-content">
                        <h2><a href="post-detail?id=${post.postID}">${post.title}</a></h2>
                        <div class="post-meta">
                            <span><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="${post.createdDate}" pattern="dd/MM/yyyy"/></span>
                        </div>
                        <p class="post-excerpt">
                            <c:set var="content" value="${post.content}" />
                            ${content.substring(0, Math.min(content.length(), 250))}...
                        </p>
                        <a href="post-detail?id=${post.postID}" class="read-more">Đọc tiếp &rarr;</a>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty postList}">
                <p>Làng nghề này hiện chưa có bài đăng nào.</p>
            </c:if>
        </div>
    </div>

</body>
</html>
