<%-- 
    Document   : newjsp
    Created on : Jun 21, 2025, 9:06:56?PM
    Author     : ACER
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<a href="#" class="menu-name" data-title="Craft Types">Craft Types</a>
<ul class="sub-menu">
    <c:forEach var="c" items="${listCC}">
        <li class="menu-item">
            <a href="blog?type=${c.categoryID}">${c.categoryName}</a>
        </li>
    </c:forEach>
</ul>