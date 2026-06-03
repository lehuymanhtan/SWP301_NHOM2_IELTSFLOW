<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thi – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0a0e1a; --surface:#111827; --surface2:#1a2235;
            --border:rgba(255,255,255,0.08); --accent:#6366f1; --accent2:#8b5cf6;
            --text:#f1f5f9; --text-muted:#94a3b8;
            --success:#10b981; --warning:#f59e0b; --danger:#ef4444;
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:var(--bg);color:var(--text);font-family:'Inter',sans-serif;min-height:100vh;padding:2rem;}

        .page-header{text-align:center;padding:3rem 1rem 2rem;}
        .page-header .badge{
            display:inline-block;padding:.35rem 1rem;border-radius:100px;font-size:.8rem;font-weight:700;
            text-transform:uppercase;letter-spacing:.06em;margin-bottom:1.5rem;
        }
        .badge.completed{background:rgba(16,185,129,.15);color:var(--success);border:1px solid rgba(16,185,129,.3);}
        .badge.abandoned{background:rgba(239,68,68,.15);color:var(--danger);border:1px solid rgba(239,68,68,.3);}
        .page-header h1{font-size:2.2rem;font-weight:800;margin-bottom:.5rem;}
        .page-header p{color:var(--text-muted);font-size:1rem;}

        /* BAND DISPLAY */
        .band-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1.25rem;max-width:880px;margin:0 auto 3rem;}
        .band-card{
            background:var(--surface);border:1px solid var(--border);border-radius:1.25rem;
            padding:1.75rem;text-align:center;position:relative;overflow:hidden;
            transition:transform .2s;
        }
        .band-card:hover{transform:translateY(-3px);}
        .band-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--grad);}
        .band-card.listening{--grad:linear-gradient(90deg,#10b981,#059669);}
        .band-card.reading  {--grad:linear-gradient(90deg,#6366f1,#8b5cf6);}
        .band-card.writing  {--grad:linear-gradient(90deg,#f59e0b,#ef4444);}
        .band-card.speaking {--grad:linear-gradient(90deg,#ec4899,#a855f7);}
        .band-card.overall  {--grad:linear-gradient(90deg,#6366f1,#ec4899);}

        .band-icon{font-size:1.75rem;margin-bottom:.5rem;}
        .band-label{font-size:.75rem;text-transform:uppercase;letter-spacing:.08em;color:var(--text-muted);margin-bottom:.5rem;}
        .band-score{font-size:3rem;font-weight:800;line-height:1;}
        .band-score.listening{color:#10b981;}
        .band-score.reading  {color:var(--accent);}
        .band-score.writing  {color:var(--warning);}
        .band-score.speaking {color:#ec4899;}
        .band-score.overall  {background:linear-gradient(135deg,#6366f1,#ec4899);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
        .band-pending{font-size:1rem;color:var(--text-muted);font-style:italic;}

        /* VIOLATION NOTICE */
        .violation-notice{
            max-width:880px;margin:0 auto 2rem;padding:1rem 1.5rem;
            background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.3);border-radius:.875rem;
            display:flex;align-items:center;gap:1rem;font-size:.9rem;
        }
        .violation-notice svg{width:24px;height:24px;color:var(--danger);flex-shrink:0;}

        /* ACTION BUTTONS */
        .actions{display:flex;gap:1rem;justify-content:center;margin-bottom:3rem;flex-wrap:wrap;}
        .btn{
            padding:.75rem 2rem;border-radius:.875rem;font-family:'Inter',sans-serif;
            font-size:.9rem;font-weight:700;cursor:pointer;transition:all .2s;text-decoration:none;
            display:inline-flex;align-items:center;gap:.5rem;
        }
        .btn-primary{background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;border:none;}
        .btn-primary:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(99,102,241,.35);}
        .btn-outline{background:transparent;color:var(--text);border:1px solid var(--border);}
        .btn-outline:hover{border-color:var(--accent);color:var(--accent);}
    </style>
</head>
<body>

<div class="page-header">
    <div class="badge ${submission.status == 'Completed' ? 'completed' : 'abandoned'}">
        ${submission.status == 'Completed' ? '✅ Hoàn thành' : '⚠️ Bị gián đoạn'}
    </div>
    <h1>${submission.examTitle}</h1>
    <p>
        Kết quả bài thi thử •
        <fmt:formatDate value="${submission.startTimeAsDate}" pattern="dd/MM/yyyy HH:mm" type="both"/>
    </p>
</div>

<c:if test="${submission.cheated}">
    <div class="violation-notice">
        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
        </svg>
        <span>Bài thi này đã bị đánh dấu <strong>vi phạm</strong> (thoát màn hình / chuyển tab quá ${submission.violationCount} lần). Kết quả có thể không phản ánh đúng trình độ.</span>
    </div>
</c:if>

<!-- BAND SCORES -->
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
        <div class="band-label">Overall Band Dự đoán</div>
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
    <a href="${pageContext.request.contextPath}/dashboard?action=detail&submissionId=${submission.submissionId}"
       class="btn btn-outline" id="btn-view-detail">
        📋 Xem chi tiết đáp án & AI Feedback
    </a>
    <a href="${pageContext.request.contextPath}/mock-test" class="btn btn-primary" id="btn-new-test">
        🔄 Thi lại
    </a>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline" id="btn-dashboard">
        📊 Về Dashboard
    </a>
</div>

</body>
</html>
