<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết kết quả – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0a0e1a; --surface:#111827; --surface2:#1a2235;
            --border:rgba(255,255,255,0.08); --accent:#6366f1; --accent2:#8b5cf6;
            --text:#f1f5f9; --text-muted:#94a3b8;
            --success:#10b981; --warning:#f59e0b; --danger:#ef4444;
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:var(--bg);color:var(--text);font-family:'Inter',sans-serif;min-height:100vh;}

        /* SIDEBAR (reuse) */
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
        .main{margin-left:240px;padding:2rem;max-width:1100px;}

        /* BACK LINK */
        .back-link{
            display:inline-flex;align-items:center;gap:.5rem;color:var(--text-muted);
            text-decoration:none;font-size:.875rem;margin-bottom:1.5rem;transition:color .2s;
        }
        .back-link:hover{color:var(--accent);}

        .page-title{font-size:1.5rem;font-weight:800;margin-bottom:.25rem;}
        .page-meta{color:var(--text-muted);font-size:.875rem;margin-bottom:2rem;}

        /* SUMMARY BAND ROW */
        .band-row{display:flex;gap:.75rem;flex-wrap:wrap;margin-bottom:2rem;}
        .mini-band{
            background:var(--surface);border:1px solid var(--border);border-radius:.875rem;
            padding:1rem 1.25rem;text-align:center;flex:1;min-width:100px;
        }
        .mini-band-label{font-size:.7rem;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted);margin-bottom:.25rem;}
        .mini-band-score{font-size:1.5rem;font-weight:800;}
        .mini-band-score.L{color:#10b981;}
        .mini-band-score.R{color:var(--accent);}
        .mini-band-score.W{color:var(--warning);}
        .mini-band-score.S{color:#ec4899;}
        .mini-band-score.O{background:linear-gradient(135deg,var(--accent),#ec4899);-webkit-background-clip:text;-webkit-text-fill-color:transparent;}

        /* SKILL SECTIONS */
        .skill-section{margin-bottom:2rem;}
        .skill-header{
            display:flex;align-items:center;gap:.75rem;padding:.75rem 1.25rem;
            background:var(--surface);border:1px solid var(--border);border-radius:.875rem;
            margin-bottom:1rem;cursor:pointer;user-select:none;
        }
        .skill-header h2{font-size:1rem;font-weight:700;flex:1;}
        .skill-header .toggle-icon{color:var(--text-muted);font-size:.8rem;transition:transform .3s;}
        .skill-header.collapsed .toggle-icon{transform:rotate(-90deg);}
        .skill-body{display:flex;flex-direction:column;gap:.875rem;}
        .skill-body.hidden{display:none;}

        /* QUESTION DETAIL CARD */
        .q-detail{
            background:var(--surface);border:1px solid var(--border);border-radius:1rem;padding:1.5rem;
            border-left:4px solid var(--indicator);
        }
        .q-detail.correct  {--indicator:var(--success);}
        .q-detail.incorrect{--indicator:var(--danger);}
        .q-detail.pending  {--indicator:var(--warning);}

        .q-header{display:flex;align-items:center;gap:.75rem;margin-bottom:.875rem;flex-wrap:wrap;}
        .q-num-badge{
            background:var(--surface2);border:1px solid var(--border);
            border-radius:.4rem;padding:.2rem .6rem;font-size:.75rem;font-weight:700;color:var(--text-muted);
        }
        .result-icon{font-size:1.1rem;}
        .score-badge{
            display:inline-block;padding:.2rem .7rem;border-radius:100px;font-size:.75rem;font-weight:700;
        }
        .score-badge.correct  {background:rgba(16,185,129,.15);color:var(--success);}
        .score-badge.incorrect{background:rgba(239,68,68,.15);color:var(--danger);}
        .score-badge.pending  {background:rgba(245,158,11,.15);color:var(--warning);}
        .grading-status{font-size:.75rem;color:var(--text-muted);}

        .q-content{font-size:.95rem;color:var(--text);line-height:1.65;margin-bottom:1rem;}

        /* ANSWER COMPARISON */
        .answer-row{display:grid;grid-template-columns:1fr 1fr;gap:.75rem;margin-bottom:1rem;}
        .answer-row{display:grid;grid-template-columns:1fr 1fr;gap:.75rem;margin-bottom:1rem;}
        .answer-box{background:var(--surface2);border-radius:.75rem;padding:1rem;}
        .answer-box-label{font-size:.7rem;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted);margin-bottom:.4rem;}
        .answer-box-content{font-size:.875rem;line-height:1.6;}
        .answer-box.correct-ans .answer-box-content{color:var(--success);}
        .answer-box.candidate-ans.was-correct .answer-box-content{color:var(--success);}
        .answer-box.candidate-ans.was-wrong  .answer-box-content{color:var(--danger);}

        /* EXPLANATION */
        .explanation{
            background:rgba(99,102,241,.06);border:1px solid rgba(99,102,241,.15);
            border-radius:.75rem;padding:1rem;font-size:.875rem;color:var(--text-muted);line-height:1.7;
        }
        .explanation strong{color:var(--text);display:block;margin-bottom:.35rem;}

        /* AI FEEDBACK */
        .ai-feedback{
            background:linear-gradient(135deg,rgba(99,102,241,.08),rgba(168,85,247,.08));
            border:1px solid rgba(99,102,241,.2);border-radius:.875rem;padding:1.25rem;
            margin-top:1rem;
        }
        .ai-feedback-title{
            font-size:.8rem;text-transform:uppercase;letter-spacing:.07em;color:var(--accent);
            font-weight:700;margin-bottom:.75rem;display:flex;align-items:center;gap:.4rem;
        }
        .ai-criteria{display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:.6rem;margin-bottom:.875rem;}
        .ai-crit-item{background:var(--surface2);border-radius:.6rem;padding:.6rem .875rem;}
        .ai-crit-label{font-size:.7rem;color:var(--text-muted);margin-bottom:.15rem;}
        .ai-crit-score{font-size:1.1rem;font-weight:700;color:var(--accent);}
        .ai-comment{font-size:.875rem;color:var(--text-muted);line-height:1.7;}

        /* TRANSCRIPT */
        .transcript-box{
            background:var(--surface2);border-radius:.75rem;padding:1rem;
            font-size:.875rem;color:var(--text-muted);line-height:1.7;font-style:italic;
            border-left:3px solid #ec4899;
        }
        .transcript-label{font-size:.7rem;text-transform:uppercase;letter-spacing:.07em;color:#ec4899;margin-bottom:.4rem;font-style:normal;}
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
</nav>

<main class="main">
    <a href="${pageContext.request.contextPath}/dashboard" class="back-link">← Quay lại Dashboard</a>

    <h1 class="page-title">${submission.examTitle}</h1>
    <p class="page-meta">
        Chi tiết kết quả •
        <fmt:formatDate value="${submission.startTimeAsDate}" pattern="dd/MM/yyyy HH:mm" type="both"/>
        <c:if test="${submission.cheated}">
            &nbsp;<span style="color:var(--danger)">⚠️ Vi phạm</span>
        </c:if>
    </p>

    <!-- BAND SUMMARY -->
    <div class="band-row">
        <div class="mini-band">
            <div class="mini-band-label">Listening</div>
            <div class="mini-band-score L">
                <c:choose>
                    <c:when test="${submission.listeningBand != null}"><fmt:formatNumber value="${submission.listeningBand}" pattern="0.0"/></c:when>
                    <c:otherwise><span style="font-size:.9rem;font-weight:400">—</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="mini-band">
            <div class="mini-band-label">Reading</div>
            <div class="mini-band-score R">
                <c:choose>
                    <c:when test="${submission.readingBand != null}"><fmt:formatNumber value="${submission.readingBand}" pattern="0.0"/></c:when>
                    <c:otherwise><span style="font-size:.9rem;font-weight:400">—</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="mini-band">
            <div class="mini-band-label">Writing</div>
            <div class="mini-band-score W">
                <c:choose>
                    <c:when test="${submission.writingBand != null}"><fmt:formatNumber value="${submission.writingBand}" pattern="0.0"/></c:when>
                    <c:otherwise><span style="font-size:.9rem;font-weight:400">Chờ AI</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="mini-band">
            <div class="mini-band-label">Speaking</div>
            <div class="mini-band-score S">
                <c:choose>
                    <c:when test="${submission.speakingBand != null}"><fmt:formatNumber value="${submission.speakingBand}" pattern="0.0"/></c:when>
                    <c:otherwise><span style="font-size:.9rem;font-weight:400">Chờ AI</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="mini-band">
            <div class="mini-band-label">Overall</div>
            <div class="mini-band-score O">
                <c:choose>
                    <c:when test="${submission.overallBand != null}"><fmt:formatNumber value="${submission.overallBand}" pattern="0.0"/></c:when>
                    <c:otherwise><span style="font-size:.9rem;font-weight:400">—</span></c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- DETAIL BY SKILL -->
    <c:forEach var="entry" items="${bySkill}">
        <c:if test="${not empty entry.value}">
            <div class="skill-section" id="skill-section-${entry.key}">
                <div class="skill-header" onclick="toggleSkill('${entry.key}')" id="skill-hdr-${entry.key}">
                    <c:choose>
                        <c:when test="${entry.key == 'Listening'}">🎧</c:when>
                        <c:when test="${entry.key == 'Reading'}">📖</c:when>
                        <c:when test="${entry.key == 'Writing'}">✍️</c:when>
                        <c:otherwise>🗣️</c:otherwise>
                    </c:choose>
                    <h2>${entry.key}</h2>
                    <span class="grading-status">${entry.value.size()} câu</span>
                    <span class="toggle-icon">▼</span>
                </div>

                <div class="skill-body" id="skill-body-${entry.key}">
                    <c:forEach var="d" items="${entry.value}" varStatus="st">
                        <%-- Determine card class --%>
                        <c:set var="cardClass" value="pending"/>
                        <c:if test="${d.isCorrect != null && d.isCorrect}">
                            <c:set var="cardClass" value="correct"/>
                        </c:if>
                        <c:if test="${d.isCorrect != null && !d.isCorrect}">
                            <c:set var="cardClass" value="incorrect"/>
                        </c:if>

                        <div class="q-detail ${cardClass}" id="qdetail-${d.detailId}">
                            <div class="q-header">
                                <span class="q-num-badge">Câu ${st.index + 1}</span>
                                <c:choose>
                                    <c:when test="${d.isCorrect == null}"><span class="result-icon">⏳</span></c:when>
                                    <c:when test="${d.isCorrect}"><span class="result-icon">✅</span></c:when>
                                    <c:otherwise><span class="result-icon">❌</span></c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${d.isCorrect == null}">
                                        <span class="score-badge pending">${d.gradingStatus}</span>
                                    </c:when>
                                    <c:when test="${d.isCorrect}">
                                        <span class="score-badge correct">Đúng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="score-badge incorrect">Sai</span>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${d.score != null}">
                                    <span style="color:var(--text-muted);font-size:.8rem;">
                                        Điểm: <strong style="color:var(--text)">${d.score}</strong>
                                    </span>
                                </c:if>
                            </div>

                            <div class="q-content">${d.questionContent}</div>

                            <%-- MC / FillBlank: show answer comparison --%>
                            <c:if test="${d.questionType == 'Multiple_Choice' || d.questionType == 'FillBlank'}">
                                <div class="answer-row">
                                    <div class="answer-box candidate-ans ${d.isCorrect ? 'was-correct' : 'was-wrong'}">
                                        <div class="answer-box-label">Câu trả lời của bạn</div>
                                        <div class="answer-box-content">
                                            <c:choose>
                                                <c:when test="${not empty d.candidateAnswer}">${d.candidateAnswer}</c:when>
                                                <c:otherwise><em>Không trả lời</em></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="answer-box correct-ans">
                                        <div class="answer-box-label">Đáp án đúng</div>
                                        <div class="answer-box-content">
                                            <c:choose>
                                                <c:when test="${not empty d.correctAnswerContent}">${d.correctAnswerContent}</c:when>
                                                <c:otherwise><em>N/A</em></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <%-- Speaking: transcript --%>
                            <c:if test="${d.questionType == 'Speaking' && not empty d.candidateTranscript}">
                                <div class="transcript-box" style="margin-bottom:1rem;">
                                    <div class="transcript-label">Transcript (Speech-to-Text)</div>
                                    ${d.candidateTranscript}
                                </div>
                            </c:if>

                            <%-- Essay: candidate answer --%>
                            <c:if test="${d.questionType == 'Essay' && not empty d.candidateAnswer}">
                                <div class="answer-box" style="margin-bottom:1rem;">
                                    <div class="answer-box-label">Bài làm của bạn</div>
                                    <div class="answer-box-content" style="white-space:pre-wrap">${d.candidateAnswer}</div>
                                </div>
                            </c:if>

                            <%-- Explanation --%>
                            <c:if test="${not empty d.explanation}">
                                <div class="explanation">
                                    <strong>💡 Giải thích:</strong>
                                    ${d.explanation}
                                </div>
                            </c:if>

                            <%-- AI Feedback (Writing / Speaking) --%>
                            <c:if test="${not empty d.aiFeedbackJson}">
                                <div class="ai-feedback" id="ai-feedback-${d.detailId}">
                                    <div class="ai-feedback-title">🤖 AI Feedback</div>
                                    <%-- JSON is parsed by JavaScript below --%>
                                    <div class="ai-feedback-content" data-json="${d.aiFeedbackJson}">
                                        <div class="ai-criteria" id="criteria-${d.detailId}"></div>
                                        <div class="ai-comment" id="comment-${d.detailId}"></div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </c:forEach>
</main>

<script>
// ====================================================
// Toggle skill sections
// ====================================================
function toggleSkill(skill) {
    const body = document.getElementById('skill-body-' + skill);
    const hdr  = document.getElementById('skill-hdr-' + skill);
    body.classList.toggle('hidden');
    hdr.classList.toggle('collapsed');
}

// ====================================================
// Parse and render AI Feedback JSON
// ====================================================
document.querySelectorAll('.ai-feedback-content').forEach(el => {
    try {
        const data = JSON.parse(el.dataset.json);
        const container = el.closest('.ai-feedback');
        const detailId = container.id.replace('ai-feedback-', '');
        const criteriaEl = document.getElementById('criteria-' + detailId);
        const commentEl  = document.getElementById('comment-'   + detailId);

        // Render criteria scores (e.g. Task Response, Coherence, Lexical, Grammar)
        const criteriaKeys = ['task_response','coherence_cohesion','lexical_resource','grammatical_accuracy',
                              'pronunciation','fluency','vocabulary','grammar'];
        const criteriaLabels = {
            'task_response'        : 'Task Response',
            'coherence_cohesion'   : 'Coherence',
            'lexical_resource'     : 'Lexical',
            'grammatical_accuracy' : 'Grammar',
            'pronunciation'        : 'Pronunciation',
            'fluency'              : 'Fluency',
            'vocabulary'           : 'Vocabulary',
            'grammar'              : 'Grammar',
        };

        let criteriaHtml = '';
        criteriaKeys.forEach(k => {
            if (data[k] !== undefined) {
                criteriaHtml += `
                    <div class="ai-crit-item">
                        <div class="ai-crit-label">${criteriaLabels[k]}</div>
                        <div class="ai-crit-score">${data[k]}</div>
                    </div>`;
            }
        });
        if (criteriaEl) criteriaEl.innerHTML = criteriaHtml;

        // Render overall comment
        if (commentEl) {
            let commentHtml = '';
            if (data.overall_comment) commentHtml += '<p>' + data.overall_comment + '</p>';
            if (data.suggestions && Array.isArray(data.suggestions)) {
                commentHtml += '<ul style="margin-top:.5rem;padding-left:1rem;">';
                data.suggestions.forEach(s => { commentHtml += '<li style="margin:.2rem 0">' + s + '</li>'; });
                commentHtml += '</ul>';
            }
            commentEl.innerHTML = commentHtml || '<em>Không có nhận xét.</em>';
        }
    } catch(e) {
        // If JSON malformed, show raw
        el.innerHTML = '<div class="ai-comment">' + el.dataset.json + '</div>';
    }
});
</script>
</body>
</html>
