<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mock Test – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0e1a;
            --surface: #111827;
            --surface2: #1a2235;
            --border: rgba(255,255,255,0.08);
            --accent: #6366f1;
            --accent2: #8b5cf6;
            --text: #f1f5f9;
            --text-muted: #94a3b8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { background:var(--bg); color:var(--text); font-family:'Inter',sans-serif; min-height:100vh; display:flex; flex-direction:column; align-items:center; justify-content:center; padding:2rem; }

        .hero-badge {
            display:inline-flex; align-items:center; gap:.5rem; background:rgba(99,102,241,.15);
            border:1px solid rgba(99,102,241,.3); border-radius:100px; padding:.4rem 1rem;
            font-size:.8rem; color:var(--accent); font-weight:600; letter-spacing:.05em;
            text-transform:uppercase; margin-bottom:2rem;
        }
        .hero-badge::before { content:''; width:8px; height:8px; border-radius:50%; background:var(--accent); animation:pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.3} }

        h1 { font-size:2.8rem; font-weight:800; text-align:center; line-height:1.2;
             background: linear-gradient(135deg,#6366f1,#a855f7,#ec4899); -webkit-background-clip:text; -webkit-text-fill-color:transparent; margin-bottom:.75rem; }
        .subtitle { color:var(--text-muted); text-align:center; font-size:1.05rem; max-width:520px; line-height:1.7; margin-bottom:3rem; }

        .exam-card {
            background:var(--surface); border:1px solid var(--border); border-radius:1.25rem;
            padding:2rem 2.5rem; max-width:580px; width:100%;
            box-shadow:0 20px 60px rgba(0,0,0,.4);
        }
        .exam-meta { display:grid; grid-template-columns:1fr 1fr; gap:1rem; margin-bottom:2rem; }
        .meta-item {
            background:var(--surface2); border-radius:.75rem; padding:1rem 1.25rem;
            border:1px solid var(--border);
        }
        .meta-label { font-size:.7rem; text-transform:uppercase; letter-spacing:.08em; color:var(--text-muted); margin-bottom:.25rem; }
        .meta-value { font-size:1.1rem; font-weight:700; color:var(--text); }

        .rules { background:rgba(99,102,241,.07); border:1px solid rgba(99,102,241,.2); border-radius:.75rem; padding:1.25rem 1.5rem; margin-bottom:2rem; }
        .rules h3 { font-size:.9rem; color:var(--accent); margin-bottom:.75rem; display:flex; align-items:center; gap:.5rem; }
        .rules ul { list-style:none; }
        .rules ul li { font-size:.875rem; color:var(--text-muted); padding:.3rem 0; display:flex; align-items:flex-start; gap:.5rem; line-height:1.5; }
        .rules ul li::before { content:'•'; color:var(--accent); flex-shrink:0; margin-top:.05rem; }

        .btn-start {
            width:100%; padding:1rem; border-radius:.875rem; border:none; cursor:pointer;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            color:#fff; font-size:1.05rem; font-weight:700; font-family:'Inter',sans-serif;
            transition:all .3s; position:relative; overflow:hidden;
        }
        .btn-start:hover { transform:translateY(-2px); box-shadow:0 12px 30px rgba(99,102,241,.4); }
        .btn-start:active { transform:translateY(0); }

        .no-exam { text-align:center; padding:3rem; color:var(--text-muted); }
        .no-exam svg { width:64px; height:64px; margin:0 auto 1rem; display:block; opacity:.4; }
    </style>
</head>
<body>
    <div class="hero-badge">🎯 Mock Test</div>
    <h1>Thi Thử IELTS</h1>
    <p class="subtitle">Trải nghiệm thi thực tế với đề ngẫu nhiên từ ngân hàng đề của Mentor. Kết quả sẽ được ghi lại vào hồ sơ học tập của bạn.</p>

    <c:choose>
        <c:when test="${exam != null}">
            <div class="exam-card">
                <div class="exam-meta">
                    <div class="meta-item">
                        <div class="meta-label">Đề thi</div>
                        <div class="meta-value">${exam.title}</div>
                    </div>
                    <div class="meta-item">
                        <div class="meta-label">Thời gian</div>
                        <div class="meta-value">${exam.duration} phút</div>
                    </div>
                    <div class="meta-item">
                        <div class="meta-label">Loại đề</div>
                        <div class="meta-value">${exam.type}</div>
                    </div>
                    <div class="meta-item">
                        <div class="meta-label">Kỹ năng</div>
                        <div class="meta-value">${exam.skillFocus}</div>
                    </div>
                </div>

                <div class="rules">
                    <h3>⚠️ Quy định thi</h3>
                    <ul>
                        <li>Bài thi sẽ bắt đầu ở chế độ <strong>Toàn màn hình</strong>.</li>
                        <li>Nếu bạn thoát toàn màn hình hoặc chuyển tab quá <strong>3 lần</strong>, bài thi sẽ tự động nộp và bị đánh dấu vi phạm.</li>
                        <li>Câu hỏi được <strong>sắp xếp ngẫu nhiên</strong> mỗi lần thi.</li>
                        <li>Bạn có thể xem lại đáp án chi tiết và AI Feedback sau khi nộp bài.</li>
                    </ul>
                </div>

                <form action="${pageContext.request.contextPath}/mock-test" method="get">
                    <input type="hidden" name="action" value="start">
                    <button type="submit" class="btn-start" id="btn-start-test">
                        🚀 Bắt đầu thi ngay
                    </button>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <div class="exam-card no-exam">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414A1 1 0 0119 9.414V19a2 2 0 01-2 2z"/>
                </svg>
                <p>Hiện tại chưa có đề thi Mock Test nào.<br>Mentor đang chuẩn bị đề thi, vui lòng quay lại sau!</p>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>
