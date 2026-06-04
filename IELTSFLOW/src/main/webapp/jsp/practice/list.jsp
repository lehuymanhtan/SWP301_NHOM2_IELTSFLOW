<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách bài luyện tập ${skill} – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0e1a;
            --surface: #111827;
            --surface2: #1a2235;
            --border: rgba(255, 255, 255, 0.08);
            --accent: #6366f1;
            --accent2: #8b5cf6;
            --text: #f1f5f9;
            --text-muted: #94a3b8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 3rem 2rem;
        }

        .header-section {
            text-align: center;
            margin-bottom: 3rem;
            max-width: 600px;
        }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            background: var(--bg-badge);
            border: 1px solid var(--border-badge);
            border-radius: 100px;
            padding: .4rem 1rem;
            font-size: .8rem;
            color: var(--color-badge);
            font-weight: 600;
            letter-spacing: .05em;
            text-transform: uppercase;
            margin-bottom: 1.5rem;
        }
        .hero-badge::before {
            content: '';
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--color-badge);
        }

        .Listening { --bg-badge: rgba(16, 185, 129, 0.15); --border-badge: rgba(16, 185, 129, 0.3); --color-badge: var(--success); }
        .Reading { --bg-badge: rgba(99, 102, 241, 0.15); --border-badge: rgba(99, 102, 241, 0.3); --color-badge: var(--accent); }
        .Writing { --bg-badge: rgba(245, 158, 11, 0.15); --border-badge: rgba(245, 158, 11, 0.3); --color-badge: var(--warning); }
        .Speaking { --bg-badge: rgba(236, 72, 153, 0.15); --border-badge: rgba(236, 72, 153, 0.3); --color-badge: #ec4899; }

        h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }
        .subtitle {
            color: var(--text-muted);
            font-size: 1rem;
            line-height: 1.6;
        }

        .exams-list {
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
            max-width: 760px;
            width: 100%;
        }

        .exam-item {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 1.25rem;
            padding: 1.75rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
            transition: all 0.2s;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .exam-item:hover {
            border-color: var(--color-badge);
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
        }

        .exam-info {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .exam-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text);
        }
        .exam-meta {
            display: flex;
            gap: 1.5rem;
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        .meta-detail {
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .btn-start {
            padding: 0.75rem 1.75rem;
            border-radius: 0.75rem;
            border: none;
            background: var(--color-badge);
            color: #fff;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .btn-start:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            filter: brightness(1.1);
        }

        .no-data {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 1.25rem;
            max-width: 760px;
            width: 100%;
            color: var(--text-muted);
        }
        .no-data svg {
            width: 64px;
            height: 64px;
            margin-bottom: 1rem;
            opacity: 0.3;
            color: var(--text-muted);
            display: inline-block;
        }

        .nav-links {
            margin-top: 3rem;
            display: flex;
            gap: 2rem;
        }
        .nav-link {
            text-decoration: none;
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.2s;
        }
        .nav-link:hover {
            color: var(--accent);
        }
    </style>
</head>
<body>
    <div class="header-section">
        <div class="hero-badge ${skill}">
            <c:choose>
                <c:when test="${skill == 'Listening'}">🎧</c:when>
                <c:when test="${skill == 'Reading'}">📖</c:when>
                <c:when test="${skill == 'Writing'}">✍️</c:when>
                <c:when test="${skill == 'Speaking'}">🗣️</c:when>
            </c:choose>
            ${skill}
        </div>
        <h1>Luyện tập ${skill}</h1>
        <p class="subtitle">Chọn một bài luyện tập bên dưới để rèn luyện kỹ năng của bạn. Hệ thống sẽ tự động canh giờ làm bài.</p>
    </div>

    <c:choose>
        <c:when test="${not empty exams}">
            <div class="exams-list">
                <c:forEach var="e" items="${exams}">
                    <div class="exam-item">
                        <div class="exam-info">
                            <div class="exam-title">${e.title}</div>
                            <div class="exam-meta">
                                <div class="meta-detail">
                                    <span>⏱️</span>
                                    <span>${e.duration} phút</span>
                                </div>
                                <div class="meta-detail">
                                    <span>📝</span>
                                    <span>Luyện tập kỹ năng</span>
                                </div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/practice?action=take&examId=${e.examId}" class="btn-start" id="btn-start-${e.examId}">
                            🚀 Bắt đầu
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="no-data">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                          d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <p>Hiện chưa có bài luyện tập nào cho kỹ năng này.<br>Hãy thử quay lại sau hoặc chọn kỹ năng khác!</p>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/practice" class="nav-link" id="btn-back-practice">
            ← Chọn kỹ năng khác
        </a>
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link" id="btn-back-dashboard-list">
            📊 Về Dashboard
        </a>
    </div>
</body>
</html>
