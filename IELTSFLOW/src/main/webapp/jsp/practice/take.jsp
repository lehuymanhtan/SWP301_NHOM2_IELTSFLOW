<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Luyện tập: ${exam.title} – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0e1a; --surface: #111827; --surface2: #1a2235;
            --border: rgba(255,255,255,0.08); --accent: #6366f1; --accent2: #8b5cf6;
            --text: #f1f5f9; --text-muted: #94a3b8;
            --success: #10b981; --warning: #f59e0b; --danger: #ef4444;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { height: 100%; background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; }

        /* TOP BAR */
        .top-bar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
            display: flex; align-items: center; justify-content: space-between;
            padding: .75rem 2rem;
            background: rgba(17,24,39,.95); backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
        }
        .exam-title { font-weight: 700; font-size: 1rem; color: var(--text); }
        .exam-title span { color: var(--text-muted); font-weight: 400; margin-left: .5rem; font-size: .875rem; }
        .timer {
            display: flex; align-items: center; gap: .5rem;
            font-size: 1.5rem; font-weight: 800; font-variant-numeric: tabular-nums;
            color: var(--accent);
        }
        .timer.warning { color: var(--warning); }
        .timer.danger { color: var(--danger); animation: blink .8s infinite; }
        @keyframes blink { 0%,100% { opacity: 1 } 50% { opacity: .3 } }

        /* MAIN */
        .main { margin-top: 70px; padding: 2rem 2rem 80px; max-width: 900px; margin-left: auto; margin-right: auto; }

        /* RESOURCE BOX (reading passage / audio) */
        .resource-box {
            background: var(--surface2); border: 1px solid var(--border); border-radius: 1rem;
            padding: 1.5rem; margin-bottom: 1.5rem; max-height: 350px; overflow-y: auto;
            font-size: .95rem; line-height: 1.8; color: var(--text-muted);
        }
        .resource-box audio { width: 100%; margin-bottom: 1rem; }

        /* QUESTION CARD */
        .q-card {
            background: var(--surface); border: 1px solid var(--border); border-radius: 1rem;
            padding: 1.5rem; margin-bottom: 1.25rem; transition: border-color .2s;
        }
        .q-card:hover { border-color: rgba(99,102,241,.3); }
        .q-num {
            display: inline-block; background: rgba(99,102,241,.15); color: var(--accent);
            border-radius: .4rem; padding: .2rem .6rem; font-size: .75rem; font-weight: 700;
            margin-bottom: .75rem;
        }
        .q-skill-badge {
            display: inline-block; padding: .15rem .6rem; border-radius: .4rem; font-size: .7rem;
            font-weight: 600; text-transform: uppercase; letter-spacing: .05em; margin-left: .5rem;
        }
        .q-skill-badge.Listening { background: rgba(16,185,129,.15); color: var(--success); }
        .q-skill-badge.Reading { background: rgba(99,102,241,.15); color: var(--accent); }
        .q-skill-badge.Writing { background: rgba(245,158,11,.15); color: var(--warning); }
        .q-skill-badge.Speaking { background: rgba(236,72,153,.15); color: #ec4899; }

        .q-content { font-size: 1.05rem; line-height: 1.65; color: var(--text); margin-bottom: 1.25rem; }

        /* MULTIPLE CHOICE */
        .choices { display: flex; flex-direction: column; gap: .6rem; }
        .choice {
            display: flex; align-items: center; gap: .75rem; padding: .75rem 1rem;
            border: 1px solid var(--border); border-radius: .6rem; cursor: pointer;
            transition: all 0.2s;
        }
        .choice:hover { border-color: var(--accent); background: rgba(99,102,241,.05); }
        .choice input[type=radio] { accent-color: var(--accent); width: 18px; height: 18px; }
        .choice label { cursor: pointer; font-size: .925rem; line-height: 1.5; width: 100%; }

        /* ESSAY (Writing) */
        .essay-area {
            width: 100%; min-height: 250px; padding: 1rem; border-radius: .75rem; resize: vertical;
            background: var(--surface2); border: 1px solid var(--border);
            color: var(--text); font-family: 'Inter', sans-serif; font-size: .95rem; line-height: 1.7;
            transition: border-color .2s;
        }
        .essay-area:focus { outline: none; border-color: var(--accent); }
        .word-count { font-size: .8rem; color: var(--text-muted); text-align: right; margin-top: .4rem; }

        /* SPEAKING */
        .speaking-controls { display: flex; flex-direction: column; gap: 1rem; }
        .timer-circle {
            display: flex; align-items: center; justify-content: center;
            width: 80px; height: 80px; border-radius: 50%;
            border: 3px solid var(--accent); font-size: 1.2rem; font-weight: 800;
            color: var(--accent); font-variant-numeric: tabular-nums;
            margin: 0 auto;
        }
        .rec-btn {
            display: flex; align-items: center; justify-content: center; gap: .5rem;
            padding: .75rem 1.5rem; border-radius: .75rem; border: none; cursor: pointer;
            font-family: 'Inter', sans-serif; font-weight: 600; font-size: .9rem; transition: all .3s;
        }
        .rec-btn.start { background: var(--danger); color: #fff; }
        .rec-btn.stop { background: var(--surface2); color: var(--text); border: 1px solid var(--border); }
        .rec-btn:hover { transform: translateY(-1px); }
        .transcript-display {
            background: var(--surface2); border: 1px solid var(--border); border-radius: .75rem;
            padding: 1rem; font-size: .9rem; color: var(--text-muted); min-height: 90px;
            line-height: 1.7; font-style: italic;
        }

        /* BOTTOM NAV */
        .bottom-nav {
            position: fixed; bottom: 0; left: 0; right: 0;
            background: rgba(17,24,39,.95); backdrop-filter: blur(12px);
            border-top: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 1rem 2rem;
        }
        .progress-info { font-size: .875rem; color: var(--text-muted); }
        .nav-btns { display: flex; gap: .75rem; }
        .btn-nav {
            padding: .65rem 1.5rem; border-radius: .75rem; border: 1px solid var(--border);
            background: var(--surface); color: var(--text); cursor: pointer;
            font-family: 'Inter', sans-serif; font-size: .9rem; font-weight: 600; transition: all .2s;
            text-decoration: none; display: inline-flex; align-items: center;
        }
        .btn-nav:hover { border-color: var(--accent); }
        .btn-submit {
            padding: .65rem 2rem; border-radius: .75rem; border: none;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff; cursor: pointer; font-family: 'Inter', sans-serif;
            font-size: .9rem; font-weight: 700; transition: all .2s;
        }
        .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 8px 20px rgba(99,102,241,.35); }
    </style>
</head>
<body>

<!-- TOP BAR -->
<div class="top-bar">
    <div class="exam-title">
        Luyện tập: ${exam.title}
        <span>${exam.skillFocus} · ${exam.duration} phút</span>
    </div>
    <div class="timer" id="timer">00:00:00</div>
</div>

<!-- MAIN CONTENT -->
<div class="main">

    <form method="post" action="${pageContext.request.contextPath}/practice?action=submit" id="exam-form">
        <input type="hidden" name="action" value="submit">
        <input type="hidden" name="submissionId" value="${submissionId}">

        <c:set var="qNum" value="${0}"/>
        <c:forEach var="q" items="${questions}">
            <c:set var="qNum" value="${qNum + 1}"/>

            <%-- Resource box for passage / audio --%>
            <c:if test="${not empty q.resourceText || not empty q.resourceAudioUrl}">
                <div class="resource-box">
                    <c:if test="${not empty q.resourceAudioUrl}">
                        <audio controls src="${q.resourceAudioUrl}"></audio>
                    </c:if>
                    <c:if test="${not empty q.resourceText}">
                        <p>${q.resourceText}</p>
                    </c:if>
                </div>
            </c:if>

            <div class="q-card">
                <div>
                    <span class="q-num">Câu ${qNum}</span>
                    <span class="q-skill-badge ${q.skill}">${q.skill}</span>
                </div>
                <div class="q-content">${q.content}</div>

                <c:choose>
                    <%-- MULTIPLE CHOICE --%>
                    <c:when test="${q.questionType == 'Multiple_Choice'}">
                        <div class="choices">
                            <c:forEach var="ans" items="${q.answers}">
                                <div class="choice">
                                    <input type="radio" name="q_${q.questionId}"
                                           id="ans_${ans.answerId}"
                                           value="${ans.answerId}">
                                    <label for="ans_${ans.answerId}">${ans.content}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>

                    <%-- ESSAY (Writing) --%>
                    <c:when test="${q.questionType == 'Essay'}">
                        <textarea class="essay-area"
                                  name="q_${q.questionId}"
                                  id="essay_${q.questionId}"
                                  placeholder="Viết bài của bạn ở đây..."
                                  oninput="countWords(this, 'wc_${q.questionId}')"></textarea>
                        <div class="word-count" id="wc_${q.questionId}">0 từ</div>
                    </c:when>

                    <%-- SPEAKING --%>
                    <c:when test="${q.questionType == 'Speaking'}">
                        <div class="speaking-controls">
                            <div class="timer-circle" id="rec-timer-${q.questionId}">00:00</div>
                            <div style="display:flex;gap:.75rem;justify-content:center;">
                                <button type="button" class="rec-btn start"
                                        onclick="startRecording(${q.questionId})"
                                        id="btn-rec-${q.questionId}">
                                    🎙 Bắt đầu thu âm
                                </button>
                                <button type="button" class="rec-btn stop"
                                        onclick="stopRecording(${q.questionId})"
                                        id="btn-stop-${q.questionId}" style="display:none">
                                    ⏹ Dừng thu âm
                                </button>
                            </div>
                            <div class="transcript-display" id="transcript-${q.questionId}">
                                Transcript sẽ hiện tại đây sau khi bạn dừng thu âm...
                            </div>
                            <input type="hidden" name="transcript_${q.questionId}" id="hidden-transcript-${q.questionId}">
                            <input type="hidden" name="q_${q.questionId}" value="">
                        </div>
                    </c:when>

                    <%-- FILL BLANK --%>
                    <c:otherwise>
                        <input type="text" name="q_${q.questionId}"
                               placeholder="Nhập câu trả lời..."
                               style="width:100%;padding:.75rem;border-radius:.6rem;border:1px solid var(--border);background:var(--surface2);color:var(--text);font-size:.95rem;font-family:'Inter',sans-serif;">
                    </c:otherwise>
                </c:choose>
            </div>
        </c:forEach>

        <!-- BOTTOM NAV -->
        <div class="bottom-nav">
            <div class="progress-info">Luyện tập #${submissionId}</div>
            <div class="nav-btns">
                <a href="${pageContext.request.contextPath}/practice" class="btn-nav" id="btn-exit-take">Hủy & Thoát</a>
                <button type="submit" class="btn-submit" id="btn-submit-practice" onclick="return confirmSubmit()">
                    📤 Nộp bài luyện tập
                </button>
            </div>
        </div>
    </form>
</div>

<script>
// ========================================================
// COUNTDOWN TIMER
// ========================================================
const TOTAL_SECONDS = ${exam.duration} * 60;
let secondsLeft = TOTAL_SECONDS;
const timerEl = document.getElementById('timer');

function formatTime(s) {
    const h = Math.floor(s / 3600).toString().padStart(2,'0');
    const m = Math.floor((s % 3600) / 60).toString().padStart(2,'0');
    const sec = (s % 60).toString().padStart(2,'0');
    return h + ':' + m + ':' + sec;
}

timerEl.textContent = formatTime(secondsLeft);

const countdown = setInterval(() => {
    secondsLeft--;
    timerEl.textContent = formatTime(secondsLeft);
    if (secondsLeft <= 300) timerEl.classList.add('warning');
    if (secondsLeft <= 60)  { timerEl.classList.remove('warning'); timerEl.classList.add('danger'); }
    if (secondsLeft <= 0) {
        clearInterval(countdown);
        document.getElementById('exam-form').submit();
    }
}, 1000);

// ========================================================
// WORD COUNT (Writing)
// ========================================================
function countWords(textarea, counterId) {
    const words = textarea.value.trim().split(/\s+/).filter(w => w.length > 0);
    document.getElementById(counterId).textContent = words.length + ' từ';
}

// ========================================================
// SPEAKING RECORDING (Web Speech API)
// ========================================================
const recognitions = {};
const recTimers = {};

async function startRecording(qId) {
    try {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            alert('Trình duyệt của bạn không hỗ trợ nhận diện giọng nói tự động. Vui lòng sử dụng Google Chrome hoặc Microsoft Edge.');
            return;
        }

        const recognition = new SpeechRecognition();
        recognition.lang = 'en-US';
        recognition.interimResults = true;
        recognition.continuous = true;

        let finalTranscript = '';
        
        document.getElementById('transcript-' + qId).textContent = 'Đang nghe... (Hãy nói bằng tiếng Anh)';
        document.getElementById('hidden-transcript-' + qId).value = '';

        recognition.onresult = (event) => {
            let interimTranscript = '';
            for (let i = event.resultIndex; i < event.results.length; ++i) {
                if (event.results[i].isFinal) {
                    finalTranscript += event.results[i][0].transcript + ' ';
                } else {
                    interimTranscript += event.results[i][0].transcript;
                }
            }
            const currentText = finalTranscript + interimTranscript;
            document.getElementById('transcript-' + qId).textContent = currentText;
            document.getElementById('hidden-transcript-' + qId).value = currentText.trim();
        };

        recognition.onend = () => {
            document.querySelector('[name="q_' + qId + '"]').value = 'recorded';
            if (document.getElementById('hidden-transcript-' + qId).value.trim() === '') {
                 document.getElementById('transcript-' + qId).textContent = '(Không nghe thấy bạn nói gì. Vui lòng thử lại)';
            }
        };

        recognition.start();
        recognitions[qId] = recognition;

        document.getElementById('btn-rec-' + qId).style.display = 'none';
        document.getElementById('btn-stop-' + qId).style.display = '';

        let secs = 0;
        document.getElementById('rec-timer-' + qId).textContent = '00:00';
        recTimers[qId] = setInterval(() => {
            secs++;
            const m = Math.floor(secs/60).toString().padStart(2,'0');
            const s = (secs%60).toString().padStart(2,'0');
            document.getElementById('rec-timer-' + qId).textContent = m + ':' + s;
        }, 1000);
    } catch (e) {
        alert('Có lỗi xảy ra khi bắt đầu thu âm: ' + e.message);
    }
}

function stopRecording(qId) {
    if (recognitions[qId]) {
        recognitions[qId].stop();
        delete recognitions[qId];
    }
    clearInterval(recTimers[qId]);
    document.getElementById('btn-rec-' + qId).style.display = '';
    document.getElementById('btn-stop-' + qId).style.display = 'none';
}

function confirmSubmit() {
    return confirm('Bạn có chắc chắn muốn nộp bài luyện tập này?');
}
</script>
</body>
</html>
