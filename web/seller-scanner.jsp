<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Scan</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col items-center justify-center px-4">
        <div class="w-full max-w-md bg-white p-6 rounded-2xl shadow-lg">
            <div class="flex items-center gap-4 mb-4">
  <a href="home" class="px-4 py-2 bg-indigo-100 text-indigo-700 rounded-lg hover:bg-indigo-200 transition">
    ← Back
  </a>
  <h2 class="text-2xl font-bold text-indigo-600">Scan Tourist Ticket</h2>
</div>
            <!-- Upload Form -->
            <form action="seller-scanner-ticket-code" method="post" enctype="multipart/form-data" class="space-y-4">
                <input type="file" name="image" accept=".png,.jpg,.jpeg"
                       class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full 
                       file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 
                       hover:file:bg-indigo-100"
                       required />
                <button type="submit"
                        class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2 rounded-xl">
                    Scan and Verify
                </button>
            </form>

            <!-- Nếu có vé đã xác thực -->
            <c:if test="${not empty ticketOrder}">
                <div class="mt-6 bg-green-50 border border-green-200 p-4 rounded-xl shadow-sm">
                    <h3 class="text-lg font-semibold text-green-700 mb-2">✅ Ticket verified successfully</h3>
                    <p><span class="font-medium">Ticket Code:</span> ${code}</p>
                    <p><span class="font-medium">Village Name:</span> ${ticketOrder.villageName}</p>
                    <p><span class="font-medium">Type: </span> ${ticketOrder.villageName}</p>
                    <p><span class="font-medium">Quantity:</span> ${ticketOrder.quantity}</p>
                    <p><span class="font-medium">Price:</span> <fmt:formatNumber value="${ticketOrder.price}" type="currency"/></p>
                    <p><span class="font-medium">Total Price: </span> <fmt:formatNumber value="${ticketOrder.subtotal}" type="currency"/></p>
                    <p><span class="font-medium">Date of Use:</span> ${ticketOrder.bookDate}</p>
                    <p><span class="font-medium">Status:</span> 
                        <c:choose>
                            <c:when test="${ticketOrder.status == 0}">Used</c:when>
                            <c:otherwise>Not used yet</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:if>
            <c:if test="${empty ticketOrder}"> Ticket Not Found Please Try Again</c:if>
        </div>
    </body>
</html>
