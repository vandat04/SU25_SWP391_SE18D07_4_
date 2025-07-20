<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact User</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&amp;display=swap" rel="stylesheet">
        <link rel="shortcut icon" type="image/x-icon" href="hinhanh/Logo/cropped-Favicon-1-32x32.png" />
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">
        <style>
            .chat-wrapper {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            #chat-box {
                max-height: 500px;
                overflow-y: auto;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                margin-bottom: 20px;
                display: flex;
                flex-direction: column;
                gap: 10px;
                background-color: #fafafa;
            }
            .message {
                max-width: 70%;
                padding: 10px;
                border-radius: 10px;
                word-break: break-word;
            }
            .sent {
                align-self: flex-end;
                background-color: #e0fce4;
                border: 1px solid #4caf50;
                text-align: right;
            }
            .received {
                align-self: flex-start;
                background-color: #f1f1f1;
                border: 1px solid #bbb;
                text-align: left;
            }
            .message img {
                max-width: 100%;
                border-radius: 5px;
                margin-top: 5px;
            }
            .message small {
                font-size: 0.75em;
                color: #666;
                display: block;
                margin-top: 5px;
            }
            .chat-form {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .chat-form textarea {
                resize: vertical;
                min-height: 60px;
            }
            .chat-header {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 15px;
                margin-bottom: 20px;
            }

            .chat-title {
                font-size: 24px;
                margin: 0;
            }

            .back-button {
                padding: 6px 12px;
                background-color: #4caf50;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-weight: bold;
                font-size: 14px;
                transition: background-color 0.3s ease;
            }

            .back-button:hover {
                background-color: #388e3c;
            }
    </style>
</head>
<body>

<jsp:include page="Menu.jsp" />

<div class="chat-header">
    <a href="contact-seller?userID=${sessionScope.acc.userID}" class="back-button">← Back</a>
    <h1 class="chat-title">Chat with ${receiver.fullName}</h1>
</div>

<div class="chat-wrapper">
    <div id="chat-box">
        <c:forEach var="msg" items="${listMessage}">
            <div class="message ${msg.senderID == sessionScope.acc.userID ? 'sent' : 'received'}">
                <p>${msg.messageContent}</p>
                <c:if test="${not empty msg.attachmentUrl}">
                    <img src="${msg.attachmentUrl}" alt="Attachment"/>
                </c:if>
                <small>${msg.sentDate}</small>
            </div>
        </c:forEach>
    </div>

    <form action="contact-user" method="post" enctype="multipart/form-data" class="chat-form">
        <input type="hidden" name="threadID" value="${messageThread.threadID}"/>
        <input type="hidden" name="sellerID" value="${sessionScope.acc.userID}"/>
        <input type="hidden" name="userID" value="${receiver.userID}"/>
        <textarea name="messageContent" placeholder="Type your message..." required></textarea>
        <input type="file" name="attachment" accept="image/*"/>
        <button type="submit">Send</button>
    </form>
</div>

<jsp:include page="Footer.jsp" />

<script>
    const sellerID = ${sessionScope.acc.userID};
    const threadID = ${messageThread.threadID};
    let lastMessageID = ${listMessage.isEmpty() ? 0 : listMessage.get(listMessage.size() - 1).messageID};

    function scrollToBottom() {
        const chatBox = document.getElementById("chat-box");
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    window.addEventListener("load", scrollToBottom);

    function fetchNewMessages() {
        $.ajax({
            url: 'contact-user?action=fetchNew',
            type: 'GET',
            dataType: 'json',
            data: {
                threadID: threadID,
                lastMessageID: lastMessageID,
                sellerID: sellerID
            },
            success: function (messages) {
                if (messages.length > 0) {
                    messages.forEach(function (msg) {
                        const msgClass = (msg.senderID === sellerID) ? 'sent' : 'received';
                        let html = '<div class="message ' + msgClass + '">';
                        html += '<p>' + msg.messageContent + '</p>';
                        if (msg.attachmentUrl) {
                            html += '<img src="' + msg.attachmentUrl + '" alt="Attachment"/>';
                        }
                        html += '<small>' + msg.sentDate + '</small></div>';
                        $('#chat-box').append(html);
                    });
                    lastMessageID = messages[messages.length - 1].messageID;
                    scrollToBottom();
                }
            },
            error: function () {
                console.error("Error fetching messages");
            }
        });
    }

    setInterval(fetchNewMessages, 2000);
</script>

</body>
</html>
