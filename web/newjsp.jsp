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

<canvas id="lineChart" height="300"></canvas>
<script>
    <%
        Map<Integer, Integer> monthlyRegister = (Map<Integer, Integer>) request.getAttribute("monthlyRegister");

        // Lấy tháng/năm hiện tại
        int month = Calendar.getInstance().get(Calendar.MONTH) + 1; // 1-based
        int year = Calendar.getInstance().get(Calendar.YEAR);
        int daysInMonth = java.time.YearMonth.of(year, month).lengthOfMonth();

        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");

        for (int day = 1; day <= daysInMonth; day++) {
            labels.append("'").append(String.format("%02d", day)).append("/").append(String.format("%02d", month)).append("',");
            int count = (monthlyRegister != null && monthlyRegister.containsKey(day)) ? monthlyRegister.get(day) : 0;
            data.append(count).append(",");
        }

        // Xóa dấu phẩy cuối
        if (labels.length() > 1) {
            labels.setLength(labels.length() - 1);
        }
        if (data.length() > 1) {
            data.setLength(data.length() - 1);
        }
        labels.append("]");
        data.append("]");
    %>
    const labels = <%= labels.toString()%>;
    const data = <%= data.toString()%>;

    new Chart(document.getElementById('lineChart'), {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                    label: 'Tài khoản đăng ký theo ngày',
                    data: data,
                    borderColor: 'rgba(16, 185, 129, 1)',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4
                }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Số tài khoản'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Ngày trong tháng'
                    }
                }
            }
        }
    });
</script>