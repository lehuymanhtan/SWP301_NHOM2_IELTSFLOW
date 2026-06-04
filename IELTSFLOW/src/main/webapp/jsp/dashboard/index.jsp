<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        :root {
            --bg:#0a0e1a; --surface:#111827; --surface2:#1a2235;
            --border:rgba(255,255,255,0.08); --accent:#6366f1; --accent2:#8b5cf6;
            --text:#f1f5f9; --text-muted:#94a3b8;
            --success:#10b981; --warning:#f59e0b; --danger:#ef4444;
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:var(--bg);color:var(--text);font-family:'Inter',sans-serif;min-height:100vh;}

        /* SIDEBAR */
        .sidebar{
            position:fixed;left:0;top:0;bottom:0;width:240px;
            background:var(--surface);border-right:1px solid var(--border);
            display:flex;flex-direction:column;padding:1.5rem;z-index:100;
        }
        .logo{font-size:1.3rem;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent2));
              -webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:2rem;}
        .nav-link{
            display:flex;align-items:center;gap:.75rem;padding:.7rem 1rem;border-radius:.6rem;
            color:var(--text-muted);text-decoration:none;font-size:.9rem;font-weight:500;
            transition:all .2s;margin-bottom:.25rem;
        }
        .nav-link:hover,.nav-link.active{background:rgba(99,102,241,.12);color:var(--text);}
        .nav-link.active{color:var(--accent);}

        /* MAIN */
        .main{margin-left:240px;padding:2rem;}
        .page-title{font-size:1.75rem;font-weight:800;margin-bottom:.5rem;}
        .page-subtitle{color:var(--text-muted);font-size:.9rem;margin-bottom:2rem;}

        /* STAT CARDS */
        .stats-row{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1rem;margin-bottom:2rem;}
        .stat-card{
            background:var(--surface);border:1px solid var(--border);border-radius:1rem;
            padding:1.5rem;position:relative;overflow:hidden;
        }
        .stat-card::after{
            content:'';position:absolute;top:-30px;right:-30px;
            width:100px;height:100px;border-radius:50%;
            background:var(--color);opacity:.07;
        }
        .stat-card.tests{--color:var(--accent);}
        .stat-card.avg  {--color:var(--success);}
        .stat-card.best {--color:var(--warning);}
        .stat-label{font-size:.75rem;text-transform:uppercase;letter-spacing:.08em;color:var(--text-muted);margin-bottom:.5rem;}
        .stat-value{font-size:2.25rem;font-weight:800;}
        .stat-value.accent {color:var(--accent);}
        .stat-value.success{color:var(--success);}
        .stat-value.warning{color:var(--warning);}

        /* CHART CARD */
        .chart-card{
            background:var(--surface);border:1px solid var(--border);border-radius:1.25rem;
            padding:1.75rem;margin-bottom:2rem;
        }
        .card-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem;}
        .card-title{font-size:1.05rem;font-weight:700;}
        .chart-wrap{
            position:relative;
            height:280px;
            width:100%;
            overflow-x:auto;
            overflow-y:hidden;
            scrollbar-width:thin;
            scrollbar-color:var(--accent) var(--surface2);
        }
        .chart-wrap::-webkit-scrollbar {
            height:6px;
        }
        .chart-wrap::-webkit-scrollbar-track {
            background:var(--surface2);
            border-radius:3px;
        }
        .chart-wrap::-webkit-scrollbar-thumb {
            background:var(--accent);
            border-radius:3px;
        }
        .chart-container-inner {
            height:100%;
            min-width:100%;
        }

        /* HISTORY TABLE */
        .history-card{
            background:var(--surface);border:1px solid var(--border);border-radius:1.25rem;
            padding:1.75rem;
        }
        .history-table{width:100%;border-collapse:collapse;}
        .history-table th{
            text-align:left;font-size:.75rem;text-transform:uppercase;letter-spacing:.08em;
            color:var(--text-muted);padding:.75rem 1rem;border-bottom:1px solid var(--border);
        }
        .history-table td{padding:.875rem 1rem;border-bottom:1px solid rgba(255,255,255,.04);font-size:.875rem;}
        .history-table tr:last-child td{border-bottom:none;}
        .history-table tr:hover td{background:rgba(255,255,255,.02);}

        .status-badge{
            display:inline-block;padding:.2rem .7rem;border-radius:100px;font-size:.72rem;font-weight:600;
        }
        .status-badge.Completed {background:rgba(16,185,129,.15);color:var(--success);}
        .status-badge.Abandoned {background:rgba(239,68,68,.15);color:var(--danger);}
        .status-badge.InProgress{background:rgba(245,158,11,.15);color:var(--warning);}

        .band-chip{
            display:inline-block;width:42px;text-align:center;padding:.2rem .4rem;
            border-radius:.4rem;font-size:.8rem;font-weight:700;
        }
        .band-chip.null{color:var(--text-muted);background:var(--surface2);}
        .band-chip.val {background:rgba(99,102,241,.15);color:var(--accent);}

        .btn-detail{
            padding:.35rem .9rem;border-radius:.5rem;border:1px solid var(--border);
            background:transparent;color:var(--text-muted);font-size:.8rem;cursor:pointer;
            font-family:'Inter',sans-serif;transition:all .2s;text-decoration:none;display:inline-block;
        }
        .btn-detail:hover{border-color:var(--accent);color:var(--accent);}

        .empty-state{text-align:center;padding:4rem;color:var(--text-muted);}
        .empty-state svg{width:56px;height:56px;margin:0 auto 1rem;display:block;opacity:.3;}

        /* SKILL LEGEND */
        .legend{display:flex;gap:1.5rem;flex-wrap:wrap;}
        .legend-item{display:flex;align-items:center;gap:.4rem;font-size:.8rem;color:var(--text-muted);}
        .legend-dot{width:10px;height:10px;border-radius:50%;}
    </style>
</head>
<body>

<!-- SIDEBAR -->
<nav class="sidebar">
    <div class="logo">IELTSFlow</div>
    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active" id="nav-dashboard">📊 Dashboard</a>
    <a href="${pageContext.request.contextPath}/mock-test" class="nav-link" id="nav-mocktest">📝 Mock Test</a>
    <a href="${pageContext.request.contextPath}/placement-test" class="nav-link" id="nav-placement">🎓 Thi đầu vào</a>
    <a href="${pageContext.request.contextPath}/practice" class="nav-link" id="nav-practice">💪 Luyện tập</a>
    <a href="${pageContext.request.contextPath}/pathway" class="nav-link" id="nav-pathway">🗺️ Lộ trình</a>
    <a href="${pageContext.request.contextPath}/tickets" class="nav-link" id="nav-tickets">💬 Hỏi đáp</a>
    <a href="${pageContext.request.contextPath}/profile" class="nav-link" id="nav-profile">👤 Hồ sơ</a>
</nav>

<main class="main">
    <h1 class="page-title">Dashboard</h1>
    <p class="page-subtitle">Theo dõi tiến trình học tập và kết quả thi thử của bạn</p>

    <!-- STATS -->
    <div class="stats-row">
        <div class="stat-card tests">
            <div class="stat-label">Tổng bài đã thi</div>
            <div class="stat-value accent">${totalTests}</div>
        </div>
        <div class="stat-card avg">
            <div class="stat-label">Band trung bình</div>
            <div class="stat-value success">${avgBand > 0 ? avgBand : '—'}</div>
        </div>
        <div class="stat-card best">
            <div class="stat-label">Band cao nhất</div>
            <div class="stat-value warning">${maxBand > 0 ? maxBand : '—'}</div>
        </div>
    </div>

    <!-- PROGRESS CHART -->
    <div class="chart-card">
        <div class="card-header">
            <span class="card-title">📈 Biểu đồ tiến độ Band Score</span>
            <div class="legend">
                <div class="legend-item"><div class="legend-dot" style="background:#10b981"></div> Listening</div>
                <div class="legend-item"><div class="legend-dot" style="background:#6366f1"></div> Reading</div>
                <div class="legend-item"><div class="legend-dot" style="background:#f59e0b"></div> Writing</div>
                <div class="legend-item"><div class="legend-dot" style="background:#ec4899"></div> Speaking</div>
                <div class="legend-item"><div class="legend-dot" style="background:#a855f7"></div> Overall</div>
            </div>
        </div>
        <div class="chart-wrap">
            <c:choose>
                <c:when test="${totalTests > 0}">
                    <div class="chart-container-inner" id="chartContainerInner">
                        <canvas id="progressChart"></canvas>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                        <p>Chưa có dữ liệu. Hãy làm bài Mock Test đầu tiên!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- HISTORY TABLE -->
    <div class="history-card">
        <div class="card-header">
            <span class="card-title">📋 Lịch sử bài thi</span>
            <a href="${pageContext.request.contextPath}/mock-test" class="btn-detail" id="btn-new-test">+ Thi thử mới</a>
        </div>
        <c:choose>
            <c:when test="${not empty submissions}">
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Đề thi</th>
                            <th>Ngày thi</th>
                            <th>L</th><th>R</th><th>W</th><th>S</th>
                            <th>Overall</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sub" items="${submissions}" varStatus="st">
                            <tr>
                                <td style="color:var(--text-muted)">#${st.count}</td>
                                <td style="font-weight:600;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${sub.examTitle}</td>
                                <td style="color:var(--text-muted)">
                                    <fmt:formatDate value="${sub.startTimeAsDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <%-- Band chips --%>
                                <c:set var="bands" value="${[sub.listeningBand, sub.readingBand, sub.writingBand, sub.speakingBand]}"/>
                                <c:forEach var="b" items="${bands}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${b != null}">
                                                <span class="band-chip val"><fmt:formatNumber value="${b}" pattern="0.0"/></span>
                                            </c:when>
                                            <c:otherwise><span class="band-chip null">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                                <td>
                                    <c:choose>
                                        <c:when test="${sub.overallBand != null}">
                                            <strong style="color:var(--accent)"><fmt:formatNumber value="${sub.overallBand}" pattern="0.0"/></strong>
                                        </c:when>
                                        <c:otherwise><span style="color:var(--text-muted)">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status-badge ${sub.status}">${sub.status}</span>
                                    <c:if test="${sub.cheated}">
                                        <span title="Vi phạm" style="color:var(--danger);font-size:.75rem;margin-left:.3rem;">⚠️</span>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/dashboard?action=detail&submissionId=${sub.submissionId}"
                                       class="btn-detail" id="btn-detail-${sub.submissionId}">Chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                    </svg>
                    <p>Bạn chưa làm bài thi nào. <a href="${pageContext.request.contextPath}/mock-test" style="color:var(--accent)">Bắt đầu ngay!</a></p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
const labels       = ${chartLabels};
const listeningData= ${chartListening};
const readingData  = ${chartReading};
const writingData  = ${chartWriting};
const speakingData = ${chartSpeaking};
const overallData  = ${chartOverall};

if (labels.length > 0 && document.getElementById('progressChart')) {
    const N = labels.length;
    const containerInner = document.getElementById('chartContainerInner');
    if (containerInner && N > 10) {
        const dynamicWidth = N * 80;
        containerInner.style.width = dynamicWidth + 'px';
        containerInner.style.minWidth = dynamicWidth + 'px';
    } else if (containerInner) {
        containerInner.style.width = '100%';
    }

    const ctx = document.getElementById('progressChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels,
            datasets: [
                {
                    label: 'Listening', data: listeningData, borderColor: '#10b981',
                    backgroundColor: 'rgba(16,185,129,.1)', tension: .4,
                    spanGaps: true, pointRadius: 5, pointHoverRadius: 8,
                },
                {
                    label: 'Reading', data: readingData, borderColor: '#6366f1',
                    backgroundColor: 'rgba(99,102,241,.1)', tension: .4,
                    spanGaps: true, pointRadius: 5, pointHoverRadius: 8,
                },
                {
                    label: 'Writing', data: writingData, borderColor: '#f59e0b',
                    backgroundColor: 'rgba(245,158,11,.1)', tension: .4,
                    spanGaps: true, pointRadius: 5, pointHoverRadius: 8,
                },
                {
                    label: 'Speaking', data: speakingData, borderColor: '#ec4899',
                    backgroundColor: 'rgba(236,72,153,.1)', tension: .4,
                    spanGaps: true, pointRadius: 5, pointHoverRadius: 8,
                },
                {
                    label: 'Overall', data: overallData, borderColor: '#a855f7',
                    backgroundColor: 'rgba(168,85,247,.1)', tension: .4,
                    spanGaps: true, pointRadius: 6, pointHoverRadius: 9,
                    borderWidth: 2.5, borderDash: [],
                },
            ]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            interaction: { mode: 'index', intersect: false },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1a2235',
                    titleColor: '#f1f5f9',
                    bodyColor: '#94a3b8',
                    borderColor: 'rgba(255,255,255,.08)',
                    borderWidth: 1,
                    padding: 12,
                    callbacks: {
                        label: ctx => ctx.dataset.label + ': ' + (ctx.raw !== null ? ctx.raw : '—')
                    }
                }
            },
            scales: {
                x: {
                    grid: { color: 'rgba(255,255,255,.04)' },
                    ticks: { color: '#94a3b8', font: { family: 'Inter', size: 12 } }
                },
                y: {
                    min: 0, max: 9,
                    grid: { color: 'rgba(255,255,255,.04)' },
                    ticks: {
                        color: '#94a3b8', font: { family: 'Inter', size: 12 },
                        stepSize: 0.5
                    }
                }
            }
        }
    });

    const chartWrap = document.querySelector('.chart-wrap');
    if (chartWrap) {
        setTimeout(() => {
            chartWrap.scrollLeft = chartWrap.scrollWidth;
        }, 100);
    }
}
</script>
</body>
</html>
