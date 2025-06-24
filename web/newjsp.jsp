<%-- 
    Document   : newjsp
    Created on : Jun 22, 2025, 10:52:10 PM
    Author     : ACER
--%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <title>Export PDF Demo</title>
        <style>
            /* Dropdown container */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            /* Dropdown button */
            .dropbtn {
                background-color: #3498db;
                color: white;
                padding: 10px 20px;
                font-size: 14px;
                border: none;
                cursor: pointer;
                border-radius: 4px;
            }

            /* Dropdown content (hidden by default) */
            .dropdown-content {
                display: none;
                position: absolute;
                background-color: white;
                min-width: 160px;
                box-shadow: 0px 4px 8px rgba(0,0,0,0.2);
                z-index: 1;
                border-radius: 4px;
            }

            /* Links inside the dropdown */
            .dropdown-content a {
                color: black;
                padding: 10px 15px;
                text-decoration: none;
                display: block;
            }

            /* Hover effect for links */
            .dropdown-content a:hover {
                background-color: #f1f1f1;
            }

            /* Show the dropdown on hover */
            .dropdown:hover .dropdown-content {
                display: block;
            }

            /* Optional: change button color on hover */
            .dropdown:hover .dropbtn {
                background-color: #2980b9;
            }

        </style>
    </head>
    <body>
        <!-- Dropdown Button -->
        <div class="dropdown">
            <button class="dropbtn">Menu ▼</button>
            <div class="dropdown-content">
                <a href="feature1.jsp">Tính năng 1</a>
                <a href="feature2.jsp">Tính năng 2</a>
                <a href="feature3.jsp">Tính năng 3</a>
            </div>
        </div>
    </body>
</html>
