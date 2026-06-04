<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:#0a0e1a;color:#f1f5f9;font-family:'Inter',sans-serif;
             min-height:100vh;display:flex;align-items:center;justify-content:center;text-align:center;padding:2rem;}
        .err-code{font-size:6rem;font-weight:800;background:linear-gradient(135deg,#6366f1,#ec4899);
                  -webkit-background-clip:text;-webkit-text-fill-color:transparent;line-height:1;}
        h1{font-size:1.5rem;font-weight:700;margin:.75rem 0 .5rem;}
        p{color:#94a3b8;line-height:1.7;max-width:420px;}
        a{display:inline-block;margin-top:2rem;padding:.75rem 2rem;border-radius:.875rem;
          background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;text-decoration:none;font-weight:700;}
    </style>
</head>
<body>
    <div>
        <div class="err-code">⚠</div>
        <h1>Có lỗi xảy ra</h1>
        <p><c:choose>
            <c:when test="${not empty errorMsg}">${errorMsg}</c:when>
            <c:otherwise>Đã xảy ra lỗi không mong muốn. Vui lòng thử lại hoặc liên hệ quản trị viên.</c:otherwise>
        </c:choose></p>
        <a href="${pageContext.request.contextPath}/dashboard">← Về Dashboard</a>
    </div>
</body>
</html>
