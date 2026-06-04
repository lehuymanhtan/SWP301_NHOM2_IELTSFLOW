<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả luyện tập – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0e1a; --surface: #111827; --surface2: #1a2235;
            --border: rgba(255,255,255,0.08); --accent: #6366f1; --accent2: #8b5cf6;
            --text: #f1f5f9; --text-muted: #94a3b8;
            --success: #10b981; --warning: #f59e0b; --danger: #ef4444;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; min-height: 100vh; padding: 3rem 2rem; }

        .page-header { text-align: center; margin-bottom: 3rem; }
        .page-header .badge {
            display: inline-block; padding: .35rem 1rem; border-radius: 100px; font-size: .8rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .06em; margin-bottom: 1.5rem;
            background: rgba(16,185,129,.15); color: var(--success); border: 1px solid rgba(16,185,129,.3);
        }
        .page-header h1 { font-size: 2.2rem; font-weight: 800; margin-bottom: .5rem; }
        .page-header p { color: var(--text-muted); font-size: 1rem; }

        /* SCORE SUMMARY */
        .score-summary {
            background: var(--surface); border: 1px solid var(--border); border-radius: 1.25rem;
            padding: 2rem; text-align: center; max-width: 600px; margin: 0 auto 3rem;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            position: relative; overflow: hidden;
        }
        .score-summary::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
        }
        .score-title { font-size: .8rem; text-transform: uppercase; letter-spacing: .08em; color: var(--text-muted); margin-bottom: 1rem; }
        .band-score {
            font-size: 4rem; font-weight: 800; line-height: 1;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
        }
        .score-desc { font-size: .95rem; color: var(--text-muted); line-height: 1.6; }

        /* DETAILS SECTION */
        .details-container { max-width: 800px; margin: 0 auto 3rem; display: flex; flex-direction: column; gap: 1.25rem; }
        .details-title { font-size: 1.25rem; font-weight: 700; border-bottom: 1px solid var(--border); padding-bottom: .75rem; margin-bottom: .5rem; }

        .q-detail {
            background: var(--surface); border: 1px solid var(--border); border-radius: 1rem; padding: 1.5rem;
            border-left: 4px solid var(--indicator);
        }
        .q-detail.correct   { --indicator: var(--success); }
        .q-detail.incorrect { --indicator: var(--danger); }
        .q-detail.pending   { --indicator: var(--warning); }

        .q-header { display: flex; align-items: center; gap: .75rem; margin-bottom: .875rem; flex-wrap: wrap; }
        .q-num-badge {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: .4rem; padding: .2rem .6rem; font-size: .75rem; font-weight: 700; color: var(--text-muted);
        }
        .result-icon { font-size: 1.1rem; }
        .score-badge { display: inline-block; padding: .2rem .7rem; border-radius: 100px; font-size: .75rem; font-weight: 700; }
        .score-badge.correct   { background: rgba(16,185,129,.15); color: var(--success); }
        .score-badge.incorrect { background: rgba(239,68,68,.15); color: var(--danger); }
        .score-badge.pending   { background: rgba(245,158,11,.15); color: var(--warning); }

        .q-content { font-size: .95rem; color: var(--text); line-height: 1.65; margin-bottom: 1rem; }

        /* ANSWER ROW */
        .answer-row { display: grid; grid-template-columns: 1fr 1fr; gap: .75rem; margin-bottom: 1rem; }
        @media(max-width: 600px) { .answer-row { grid-template-columns: 1fr; } }
        .answer-box { background: var(--surface2); border-radius: .75rem; padding: 1rem; border: 1px solid var(--border); }
        .answer-box-label { font-size: .7rem; text-transform: uppercase; letter-spacing: .07em; color: var(--text-muted); margin-bottom: .4rem; }
        .answer-box-content { font-size: .875rem; line-height: 1.6; }
        .answer-box.correct-ans .answer-box-content { color: var(--success); }
        .answer-box.candidate-ans.was-correct .answer-box-content { color: var(--success); }
        .answer-box.candidate-ans.was-wrong .answer-box-content { color: var(--danger); }

        /* SPEAKING TRANSCRIPT */
        .transcript-box {
            background: var(--surface2); border-radius: .75rem; padding: 1rem;
            font-size: .875rem; color: var(--text-muted); line-height: 1.7; font-style: italic;
            border-left: 3px solid #ec4899; margin-bottom: 1rem;
        }
        .transcript-label { font-size: .7rem; text-transform: uppercase; letter-spacing: .07em; color: #ec4899; margin-bottom: .4rem; font-style: normal; }

        /* EXPLANATION */
        .explanation {
            background: rgba(99,102,241,.06); border: 1px solid rgba(99,102,241,0.15);
            border-radius: .75rem; padding: 1rem; font-size: .875rem; color: var(--text-muted); line-height: 1.7;
        }
        .explanation strong { color: var(--text); display: block; margin-bottom: .35rem; }

        /* AI FEEDBACK */
        .ai-feedback {
            background: linear-gradient(135deg, rgba(99,102,241,.08), rgba(168,85,247,.08));
            border: 1px solid rgba(99,102,241,.2); border-radius: .875rem; padding: 1.25rem;
            margin-top: 1rem;
        }
        .ai-feedback-title {
            font-size: .8rem; text-transform: uppercase; letter-spacing: .07em; color: var(--accent);
            font-weight: 700; margin-bottom: .75rem; display: flex; align-items: center; gap: .4rem;
        }
        .ai-criteria { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px,1fr)); gap: .6rem; margin-bottom: .875rem; }
        .ai-crit-item { background: var(--surface2); border-radius: .6rem; padding: .6rem .875rem; border: 1px solid var(--border); }
        .ai-crit-label { font-size: .7rem; color: var(--text-muted); margin-bottom: .15rem; }
        .ai-crit-score { font-size: 1.1rem; font-weight: 700; color: var(--accent); }
        .ai-comment { font-size: .875rem; color: var(--text-muted); line-height: 1.7; }

        /* ACTIONS */
        .actions { display: flex; gap: 1rem; justify-content: center; margin-bottom: 3rem; flex-wrap: wrap; }
        .btn {
            padding: .75rem 2rem; border-radius: .875rem; font-family: 'Inter', sans-serif;
            font-size: .9rem; font-weight: 700; cursor: pointer; transition: all .2s; text-decoration: none;
            display: inline-flex; align-items: center; gap: .5rem;
        }
        .btn-primary { background: linear-gradient(135deg, var(--accent), var(--accent2)); color: #fff; border: none; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(99,102,241,.35); }
        .btn-outline { background: transparent; color: var(--text); border: 1px solid var(--border); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }
    </style>
</head>
<body>

<div class="page-header">
    <div class="badge">Luyện tập hoàn thành</div>
    <h1>${submission.examTitle}</h1>
    <p>
        Thời gian hoàn thành: 
        <fmt:formatDate value="${submission.startTimeAsDate}" pattern="dd/MM/yyyy HH:mm" type="both"/>
    </p>
</div>

<!-- SCORE SUMMARY -->
<div class="score-summary">
    <div class="score-title">Band Score Đạt Được</div>
    <div class="band-score">
        <c:choose>
            <c:when test="${submission.overallBand != null}">
                <fmt:formatNumber value="${submission.overallBand}" pattern="0.0"/>
            </c:when>
            <c:otherwise>—</c:otherwise>
        </c:choose>
    </div>
    <div class="score-desc">
        Chúc mừng bạn đã hoàn thành bài luyện tập kỹ năng <strong>${submission.skillFocus}</strong>. 
        Hãy xem lại chi tiết bài làm bên dưới để rút kinh nghiệm cho các bài thi thực tế.
    </div>
</div>

<!-- DETAILS LIST -->
<div class="details-container">
    <div class="details-title">Chi Tiết Từng Câu Hỏi</div>
    
    <c:forEach var="d" items="${details}" varStatus="st">
        <c:set var="cardClass" value="pending"/>
        <c:if test="${d.isCorrect != null && d.isCorrect}">
            <c:set var="cardClass" value="correct"/>
        </c:if>
        <c:if test="${d.isCorrect != null && !d.isCorrect}">
            <c:set var="cardClass" value="incorrect"/>
        </c:if>

        <div class="q-detail ${cardClass}">
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
                    <span style="color:var(--text-muted);font-size:.8rem;margin-left:auto;">
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
                <div class="transcript-box">
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
                    <strong>💡 Giải thích & Hướng dẫn:</strong>
                    ${d.explanation}
                </div>
            </c:if>

            <%-- AI Feedback (Writing / Speaking) --%>
            <c:if test="${not empty d.aiFeedbackJson}">
                <div class="ai-feedback" id="ai-feedback-${d.detailId}">
                    <div class="ai-feedback-title">🤖 AI Feedback</div>
                    <div class="ai-feedback-content" data-json="${d.aiFeedbackJson}">
                        <div class="ai-criteria" id="criteria-${d.detailId}"></div>
                        <div class="ai-comment" id="comment-${d.detailId}"></div>
                    </div>
                </div>
            </c:if>
        </div>
    </c:forEach>
</div>

<!-- ACTIONS -->
<div class="actions">
    <a href="${pageContext.request.contextPath}/practice?skill=${submission.skillFocus}" class="btn btn-primary" id="btn-practice-again">
        🔄 Luyện tiếp kỹ năng này
    </a>
    <a href="${pageContext.request.contextPath}/practice" class="btn btn-outline" id="btn-back-skills">
        💪 Chọn kỹ năng khác
    </a>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline" id="btn-dashboard">
        📊 Về Dashboard
    </a>
</div>

<script>
document.querySelectorAll('.ai-feedback-content').forEach(el => {
    try {
        const data = JSON.parse(el.dataset.json);
        const container = el.closest('.ai-feedback');
        const detailId = container.id.replace('ai-feedback-', '');
        const criteriaEl = document.getElementById('criteria-' + detailId);
        const commentEl  = document.getElementById('comment-'   + detailId);

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
        el.innerHTML = '<div class="ai-comment">' + el.dataset.json + '</div>';
    }
});
</script>
</body>
</html>
