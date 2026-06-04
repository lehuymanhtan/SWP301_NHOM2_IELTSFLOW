<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thi đầu vào – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0e1a; --surface: #111827; --surface2: #1a2235;
            --border: rgba(255,255,255,0.08); --accent: #6366f1; --accent2: #8b5cf6;
            --text: #f1f5f9; --text-muted: #94a3b8;
            --success: #10b981; --warning: #f59e0b; --danger: #ef4444;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { background:var(--bg); color:var(--text); font-family:'Inter',sans-serif; min-height:100vh; padding:2rem; }

        .page-header { text-align:center; padding:3rem 1rem 2rem; }
        .page-header .badge {
            display:inline-block; padding:.35rem 1rem; border-radius:100px; font-size:.8rem; font-weight:700;
            text-transform:uppercase; letter-spacing:.06em; margin-bottom:1.5rem;
            background:rgba(139,92,246,.15); color:var(--accent2); border:1px solid rgba(139,92,246,.3);
        }
        .page-header h1 { font-size:2.2rem; font-weight:800; margin-bottom:.5rem; }
        .page-header p { color:var(--text-muted); font-size:1rem; }

        /* RECOMMENDATION CARD */
        .recom-card {
            background:linear-gradient(135deg, rgba(99,102,241,.1), rgba(139,92,246,.1));
            border:1px solid rgba(99,102,241,.25); border-radius:1.5rem;
            padding:2.5rem; max-width:880px; margin:0 auto 3rem; text-align:center;
            box-shadow:0 20px 50px rgba(0,0,0,.3);
            position:relative; overflow:hidden;
        }
        .recom-card::before {
            content:''; position:absolute; inset:0;
            background:radial-gradient(circle at top right, rgba(139,92,246,0.15), transparent 60%);
            pointer-events:none;
        }
        .recom-label { font-size:.8rem; text-transform:uppercase; letter-spacing:.1em; color:var(--text-muted); margin-bottom:.75rem; }
        .recom-level {
            font-size:2.2rem; font-weight:800;
            background:linear-gradient(135deg,#6366f1,#8b5cf6,#ec4899);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            margin-bottom:1rem;
        }
        .recom-desc { font-size:1rem; color:var(--text-muted); max-width:600px; margin:0 auto; line-height:1.7; }

        /* BAND GRID */
        .band-grid { display:grid; grid-template-columns:repeat(auto-fit, minmax(180px, 1fr)); gap:1.25rem; max-width:880px; margin:0 auto 3rem; }
        .band-card {
            background:var(--surface); border:1px solid var(--border); border-radius:1.25rem;
            padding:1.75rem; text-align:center; position:relative; overflow:hidden;
            transition:transform .2s;
        }
        .band-card:hover { transform:translateY(-3px); }
        .band-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:var(--grad); }
        .band-card.listening { --grad:linear-gradient(90deg,#10b981,#059669); }
        .band-card.reading   { --grad:linear-gradient(90deg,#6366f1,#8b5cf6); }
        .band-card.writing   { --grad:linear-gradient(90deg,#f59e0b,#ef4444); }
        .band-card.speaking  { --grad:linear-gradient(90deg,#ec4899,#a855f7); }
        .band-card.overall   { --grad:linear-gradient(90deg,#6366f1,#ec4899); }

        .band-icon { font-size:1.75rem; margin-bottom:.5rem; }
        .band-label { font-size:.75rem; text-transform:uppercase; letter-spacing:.08em; color:var(--text-muted); margin-bottom:.5rem; }
        .band-score { font-size:3rem; font-weight:800; line-height:1; }
        .band-score.listening { color:#10b981; }
        .band-score.reading   { color:var(--accent); }
        .band-score.writing   { color:var(--warning); }
        .band-score.speaking  { color:#ec4899; }
        .band-score.overall   { background:linear-gradient(135deg,#6366f1,#ec4899);-webkit-background-clip:text;-webkit-text-fill-color:transparent; }
        .band-pending { font-size:1rem; color:var(--text-muted); font-style:italic; }

        /* ACTION BUTTONS */
        .actions { display:flex; gap:1rem; justify-content:center; margin-bottom:3rem; flex-wrap:wrap; }
        .btn {
            padding:.75rem 2rem; border-radius:.875rem; font-family:'Inter',sans-serif;
            font-size:.9rem; font-weight:700; cursor:pointer; transition:all .2s; text-decoration:none;
            display:inline-flex; align-items:center; gap:.5rem;
        }
        .btn-primary { background:linear-gradient(135deg,var(--accent),var(--accent2)); color:#fff; border:none; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(99,102,241,.35); }
        .btn-outline { background:transparent; color:var(--text); border:1px solid var(--border); }
        .btn-outline:hover { border-color:var(--accent); color:var(--accent); }
    </style>
</head>
<body>

<div class="page-header">
    <div class="badge">Đã hoàn thành đánh giá</div>
    <h1>Đánh Giá Trình Độ Đầu Vào</h1>
    <p>
        Mã bài thi: #${submission.submissionId} • Ngày thực hiện: 
        <fmt:formatDate value="${submission.startTimeAsDate}" pattern="dd/MM/yyyy HH:mm" type="both"/>
    </p>
</div>

<!-- RECOMMENDATION CARD -->
<div class="recom-card">
    <div class="recom-label">Phân Lớp Đề Xuất</div>
    <div class="recom-level">${levelLabel}</div>
    <div class="recom-desc">
        Hệ thống AI đã phân tích kết quả bài làm 4 kỹ năng của bạn. Lộ trình học tập tương ứng đã được kích hoạt và cập nhật trực tiếp tại phần Lộ Trình của bạn.
    </div>
</div>

<!-- BAND SCORES BREAKDOWN -->
<div class="band-grid">
    <div class="band-card listening">
        <div class="band-icon">🎧</div>
        <div class="band-label">Listening</div>
        <c:choose>
            <c:when test="${submission.listeningBand != null}">
                <div class="band-score listening"><fmt:formatNumber value="${submission.listeningBand}" pattern="0.0"/></div>
            </c:when>
            <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
        </c:choose>
    </div>

    <div class="band-card reading">
        <div class="band-icon">📖</div>
        <div class="band-label">Reading</div>
        <c:choose>
            <c:when test="${submission.readingBand != null}">
                <div class="band-score reading"><fmt:formatNumber value="${submission.readingBand}" pattern="0.0"/></div>
            </c:when>
            <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
        </c:choose>
    </div>

    <div class="band-card writing">
        <div class="band-icon">✍️</div>
        <div class="band-label">Writing</div>
        <c:choose>
            <c:when test="${submission.writingBand != null}">
                <div class="band-score writing"><fmt:formatNumber value="${submission.writingBand}" pattern="0.0"/></div>
            </c:when>
            <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
        </c:choose>
    </div>

    <div class="band-card speaking">
        <div class="band-icon">🗣️</div>
        <div class="band-label">Speaking</div>
        <c:choose>
            <c:when test="${submission.speakingBand != null}">
                <div class="band-score speaking"><fmt:formatNumber value="${submission.speakingBand}" pattern="0.0"/></div>
            </c:when>
            <c:otherwise><div class="band-pending">Chờ AI chấm</div></c:otherwise>
        </c:choose>
    </div>

    <div class="band-card overall" style="grid-column:span 2;">
        <div class="band-icon">🏆</div>
        <div class="band-label">Overall Band Ước Tính</div>
        <c:choose>
            <c:when test="${submission.overallBand != null}">
                <div class="band-score overall"><fmt:formatNumber value="${submission.overallBand}" pattern="0.0"/></div>
            </c:when>
            <c:otherwise><div class="band-pending">Đang tính toán...</div></c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ACTIONS -->
<div class="actions">
    <a href="${pageContext.request.contextPath}/pathway" class="btn btn-primary" id="btn-view-pathway">
        🗺️ Xem lộ trình học tập cá nhân
    </a>
    <a href="${pageContext.request.contextPath}/placement-test" class="btn btn-outline" id="btn-retake-placement">
        🔄 Thi lại đầu vào
    </a>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline" id="btn-dashboard">
        📊 Về Dashboard
    </a>
</div>

</body>
</html>
