<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luyện Tập Kỹ Năng – IELTSFlow</title>
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

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.3);
            border-radius: 100px;
            padding: .4rem 1rem;
            font-size: .8rem;
            color: var(--accent);
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
            background: var(--accent);
            animation: pulse 2s infinite;
        }
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: .3; } }

        h1 {
            font-size: 2.8rem;
            font-weight: 800;
            text-align: center;
            line-height: 1.2;
            background: linear-gradient(135deg, #6366f1, #a855f7, #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: .75rem;
        }
        .subtitle {
            color: var(--text-muted);
            text-align: center;
            font-size: 1.05rem;
            max-width: 600px;
            line-height: 1.7;
            margin-bottom: 4rem;
        }

        .skills-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            max-width: 900px;
            width: 100%;
        }
        @media (max-width: 768px) {
            .skills-grid { grid-template-columns: 1fr; }
        }

        .skill-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 1.5rem;
            padding: 2rem 2.5rem;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            text-decoration: none;
            color: inherit;
        }
        .skill-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--grad);
        }
        .skill-card:hover {
            transform: translateY(-5px);
            border-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }

        .skill-card.listening { --grad: linear-gradient(90deg, #10b981, #059669); }
        .skill-card.reading { --grad: linear-gradient(90deg, #6366f1, #8b5cf6); }
        .skill-card.writing { --grad: linear-gradient(90deg, #f59e0b, #ef4444); }
        .skill-card.speaking { --grad: linear-gradient(90deg, #ec4899, #a855f7); }

        .skill-info {
            display: flex;
            align-items: center;
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }
        .skill-icon {
            font-size: 2.5rem;
            background: rgba(255, 255, 255, 0.03);
            width: 64px;
            height: 64px;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--border);
        }
        .skill-details h2 {
            font-size: 1.35rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        .skill-details p {
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .skill-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--border);
            padding-top: 1.5rem;
            margin-top: auto;
        }
        .stat-count {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
        }
        .stat-count strong {
            color: var(--text);
            font-size: 1rem;
        }
        .btn-go {
            padding: 0.5rem 1rem;
            border-radius: 0.75rem;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border);
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .skill-card:hover .btn-go {
            background: var(--text);
            color: var(--bg);
            border-color: var(--text);
        }

        .btn-dashboard {
            margin-top: 3rem;
            text-decoration: none;
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.2s;
        }
        .btn-dashboard:hover {
            color: var(--accent);
        }
    </style>
</head>
<body>
    <div class="hero-badge">⚡ Practice Mode</div>
    <h1>Luyện Tập Từng Kỹ Năng</h1>
    <p class="subtitle">Tập trung cải thiện các kỹ năng còn yếu. Bạn có thể tự chọn kỹ năng và làm các bài luyện ngắn có chấm điểm tự động.</p>

    <div class="skills-grid">
        <!-- LISTENING -->
        <a href="${pageContext.request.contextPath}/practice?skill=Listening" class="skill-card listening" id="card-listening">
            <div>
                <div class="skill-info">
                    <div class="skill-icon">🎧</div>
                    <div class="skill-details">
                        <h2>Listening</h2>
                        <p>Luyện nghe hiểu hội thoại, bài giảng và điền thông tin chính xác.</p>
                    </div>
                </div>
            </div>
            <div class="skill-stats">
                <div class="stat-count">
                    <strong><c:out value="${bySkill['Listening'] != null ? bySkill['Listening'].size() : 0}"/></strong> bài luyện tập
                </div>
                <span class="btn-go">Luyện ngay →</span>
            </div>
        </a>

        <!-- READING -->
        <a href="${pageContext.request.contextPath}/practice?skill=Reading" class="skill-card reading" id="card-reading">
            <div>
                <div class="skill-info">
                    <div class="skill-icon">📖</div>
                    <div class="skill-details">
                        <h2>Reading</h2>
                        <p>Cải thiện kỹ năng đọc hiểu nhanh và trả lời câu hỏi trắc nghiệm.</p>
                    </div>
                </div>
            </div>
            <div class="skill-stats">
                <div class="stat-count">
                    <strong><c:out value="${bySkill['Reading'] != null ? bySkill['Reading'].size() : 0}"/></strong> bài luyện tập
                </div>
                <span class="btn-go">Luyện ngay →</span>
            </div>
        </a>

        <!-- WRITING -->
        <a href="${pageContext.request.contextPath}/practice?skill=Writing" class="skill-card writing" id="card-writing">
            <div>
                <div class="skill-info">
                    <div class="skill-icon">✍️</div>
                    <div class="skill-details">
                        <h2>Writing</h2>
                        <p>Tập viết luận Task 1 & Task 2. Được AI chấm điểm và sửa lỗi chi tiết.</p>
                    </div>
                </div>
            </div>
            <div class="skill-stats">
                <div class="stat-count">
                    <strong><c:out value="${bySkill['Writing'] != null ? bySkill['Writing'].size() : 0}"/></strong> bài luyện tập
                </div>
                <span class="btn-go">Luyện ngay →</span>
            </div>
        </a>

        <!-- SPEAKING -->
        <a href="${pageContext.request.contextPath}/practice?skill=Speaking" class="skill-card speaking" id="card-speaking">
            <div>
                <div class="skill-info">
                    <div class="skill-icon">🗣️</div>
                    <div class="skill-details">
                        <h2>Speaking</h2>
                        <p>Thực hành nói trực tiếp. Sử dụng Speech-to-Text và chấm điểm AI.</p>
                    </div>
                </div>
            </div>
            <div class="skill-stats">
                <div class="stat-count">
                    <strong><c:out value="${bySkill['Speaking'] != null ? bySkill['Speaking'].size() : 0}"/></strong> bài luyện tập
                </div>
                <span class="btn-go">Luyện ngay →</span>
            </div>
        </a>
    </div>

    <a href="${pageContext.request.contextPath}/dashboard" class="btn-dashboard" id="btn-back-dashboard">
        ← Về Dashboard
    </a>
</body>
</html>
