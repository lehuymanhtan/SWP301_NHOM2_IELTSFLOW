<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đang thi – IELTSFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0a0e1a; --surface:#111827; --surface2:#1a2235;
            --border:rgba(255,255,255,0.08); --accent:#6366f1; --accent2:#8b5cf6;
            --text:#f1f5f9; --text-muted:#94a3b8;
            --success:#10b981; --warning:#f59e0b; --danger:#ef4444;
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        html,body{height:100%;background:var(--bg);color:var(--text);font-family:'Inter',sans-serif;}

        /* TOP BAR */
        .top-bar{
            position:fixed;top:0;left:0;right:0;z-index:1000;
            display:flex;align-items:center;justify-content:space-between;
            padding:.75rem 2rem;
            background:rgba(17,24,39,.95);backdrop-filter:blur(12px);
            border-bottom:1px solid var(--border);
        }
        .exam-title{font-weight:700;font-size:1rem;color:var(--text);}
        .exam-title span{color:var(--text-muted);font-weight:400;margin-left:.5rem;font-size:.875rem;}
        .timer{
            display:flex;align-items:center;gap:.5rem;
            font-size:1.5rem;font-weight:800;font-variant-numeric:tabular-nums;
            color:var(--accent);
        }
        .timer.warning{color:var(--warning);}
        .timer.danger{color:var(--danger);animation:blink .8s infinite;}
        @keyframes blink{0%,100%{opacity:1}50%{opacity:.3}}
        .violation-bar{display:flex;align-items:center;gap:.5rem;font-size:.85rem;color:var(--text-muted);}
        .violation-dot{width:12px;height:12px;border-radius:50%;border:2px solid var(--text-muted);}
        .violation-dot.used{background:var(--danger);border-color:var(--danger);}

        /* MAIN */
        .main{margin-top:70px;padding:2rem;max-width:900px;margin-left:auto;margin-right:auto;}

        /* SKILL TABS */
        .skill-tabs{display:flex;gap:.5rem;margin-bottom:2rem;flex-wrap:wrap;}
        .skill-tab{
            padding:.5rem 1.25rem;border-radius:.6rem;border:1px solid var(--border);
            background:var(--surface);color:var(--text-muted);cursor:pointer;font-size:.875rem;
            font-family:'Inter',sans-serif;font-weight:500;transition:all .2s;
        }
        .skill-tab.active{background:var(--accent);border-color:var(--accent);color:#fff;}
        .skill-tab:hover:not(.active){border-color:var(--accent);color:var(--accent);}

        /* SKILL SECTION */
        .skill-section{display:none;}
        .skill-section.active{display:block;}

        /* RESOURCE BOX (reading passage / audio) */
        .resource-box{
            background:var(--surface2);border:1px solid var(--border);border-radius:1rem;
            padding:1.5rem;margin-bottom:1.5rem;max-height:280px;overflow-y:auto;
            font-size:.9rem;line-height:1.8;color:var(--text-muted);
        }
        .resource-box audio{width:100%;margin-bottom:1rem;}

        /* QUESTION CARD */
        .q-card{
            background:var(--surface);border:1px solid var(--border);border-radius:1rem;
            padding:1.5rem;margin-bottom:1rem;transition:border-color .2s;
        }
        .q-card:hover{border-color:rgba(99,102,241,.3);}
        .q-num{
            display:inline-block;background:rgba(99,102,241,.15);color:var(--accent);
            border-radius:.4rem;padding:.2rem .6rem;font-size:.75rem;font-weight:700;
            margin-bottom:.75rem;
        }
        .q-skill-badge{
            display:inline-block;padding:.15rem .6rem;border-radius:.4rem;font-size:.7rem;
            font-weight:600;text-transform:uppercase;letter-spacing:.05em;margin-left:.5rem;
        }
        .q-skill-badge.Listening{background:rgba(16,185,129,.15);color:var(--success);}
        .q-skill-badge.Reading{background:rgba(99,102,241,.15);color:var(--accent);}
        .q-skill-badge.Writing{background:rgba(245,158,11,.15);color:var(--warning);}
        .q-skill-badge.Speaking{background:rgba(236,72,153,.15);color:#ec4899;}

        .q-content{font-size:1rem;line-height:1.65;color:var(--text);margin-bottom:1rem;}

        /* MULTIPLE CHOICE */
        .choices{display:flex;flex-direction:column;gap:.5rem;}
        .choice{
            display:flex;align-items:center;gap:.75rem;padding:.75rem 1rem;
            border:1px solid var(--border);border-radius:.6rem;cursor:pointer;
            transition:all .2s;
        }
        .choice:hover{border-color:var(--accent);background:rgba(99,102,241,.05);}
        .choice input[type=radio]{accent-color:var(--accent);width:16px;height:16px;}
        .choice label{cursor:pointer;font-size:.9rem;line-height:1.5;}

        /* ESSAY (Writing) */
        .essay-area{
            width:100%;min-height:220px;padding:1rem;border-radius:.75rem;resize:vertical;
            background:var(--surface2);border:1px solid var(--border);
            color:var(--text);font-family:'Inter',sans-serif;font-size:.9rem;line-height:1.7;
            transition:border-color .2s;
        }
        .essay-area:focus{outline:none;border-color:var(--accent);}
        .word-count{font-size:.8rem;color:var(--text-muted);text-align:right;margin-top:.4rem;}

        /* SPEAKING */
        .speaking-controls{display:flex;flex-direction:column;gap:1rem;}
        .timer-circle{
            display:flex;align-items:center;justify-content:center;
            width:80px;height:80px;border-radius:50%;
            border:3px solid var(--accent);font-size:1.2rem;font-weight:800;
            color:var(--accent);font-variant-numeric:tabular-nums;
            margin:0 auto;
        }
        .rec-btn{
            display:flex;align-items:center;justify-content:center;gap:.5rem;
            padding:.75rem 1.5rem;border-radius:.75rem;border:none;cursor:pointer;
            font-family:'Inter',sans-serif;font-weight:600;font-size:.9rem;transition:all .3s;
        }
        .rec-btn.start{background:var(--danger);color:#fff;}
        .rec-btn.stop{background:var(--surface2);color:var(--text);border:1px solid var(--border);}
        .rec-btn:hover{transform:translateY(-1px);}
        .transcript-display{
            background:var(--surface2);border:1px solid var(--border);border-radius:.75rem;
            padding:1rem;font-size:.85rem;color:var(--text-muted);min-height:80px;
            line-height:1.7;font-style:italic;
        }

        /* BOTTOM NAV */
        .bottom-nav{
            position:fixed;bottom:0;left:0;right:0;
            background:rgba(17,24,39,.95);backdrop-filter:blur(12px);
            border-top:1px solid var(--border);
            display:flex;align-items:center;justify-content:space-between;
            padding:1rem 2rem;
        }
        .progress-info{font-size:.875rem;color:var(--text-muted);}
        .nav-btns{display:flex;gap:.75rem;}
        .btn-nav{
            padding:.65rem 1.5rem;border-radius:.75rem;border:1px solid var(--border);
            background:var(--surface);color:var(--text);cursor:pointer;
            font-family:'Inter',sans-serif;font-size:.9rem;font-weight:600;transition:all .2s;
        }
        .btn-nav:hover{border-color:var(--accent);}
        .btn-submit{
            padding:.65rem 2rem;border-radius:.75rem;border:none;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            color:#fff;cursor:pointer;font-family:'Inter',sans-serif;
            font-size:.9rem;font-weight:700;transition:all .2s;
        }
        .btn-submit:hover{transform:translateY(-1px);box-shadow:0 8px 20px rgba(99,102,241,.35);}

        /* VIOLATION OVERLAY */
        .overlay{
            position:fixed;inset:0;background:rgba(0,0,0,.85);z-index:9999;
            display:none;flex-direction:column;align-items:center;justify-content:center;gap:1.5rem;
        }
        .overlay.active{display:flex;}
        .overlay-card{
            background:var(--surface);border:1px solid var(--danger);border-radius:1.25rem;
            padding:2.5rem;max-width:480px;text-align:center;
        }
        .overlay-card h2{color:var(--danger);font-size:1.5rem;margin-bottom:.75rem;}
        .overlay-card p{color:var(--text-muted);line-height:1.7;margin-bottom:1.5rem;}
        .btn-back-focus{
            padding:.75rem 2rem;border-radius:.875rem;border:none;
            background:var(--accent);color:#fff;font-size:1rem;font-weight:700;
            cursor:pointer;font-family:'Inter',sans-serif;
        }

        /* FORCED SUBMIT OVERLAY */
        .forced-overlay{
            position:fixed;inset:0;background:rgba(0,0,0,.95);z-index:99999;
            display:none;flex-direction:column;align-items:center;justify-content:center;gap:1.5rem;
        }
        .forced-overlay.active{display:flex;}
        .forced-overlay h1{color:var(--danger);font-size:2rem;font-weight:800;}
        .forced-overlay p{color:var(--text-muted);max-width:400px;text-align:center;line-height:1.7;}
    </style>
</head>
<body>

<!-- TOP BAR -->
<div class="top-bar">
    <div class="exam-title">
        ${exam.title}
        <span>${exam.skillFocus} · ${exam.duration} phút</span>
    </div>
    <div class="timer" id="timer">00:00:00</div>
    <div class="violation-bar" id="violation-bar">
        Vi phạm:
        <div class="violation-dot" id="vdot1"></div>
        <div class="violation-dot" id="vdot2"></div>
        <div class="violation-dot" id="vdot3"></div>
    </div>
</div>

<!-- VIOLATION WARNING OVERLAY -->
<div class="overlay" id="violation-overlay">
    <div class="overlay-card">
        <h2>⚠️ Cảnh báo vi phạm!</h2>
        <p id="violation-msg">Bạn đã thoát toàn màn hình hoặc chuyển tab.<br>Vi phạm lần: <strong id="vio-count">1</strong> / 3.<br>Nếu vi phạm đủ 3 lần, bài thi sẽ tự động nộp.</p>
        <button class="btn-back-focus" id="btn-back-focus">🔒 Quay lại thi</button>
    </div>
</div>

<!-- FORCED SUBMIT OVERLAY -->
<div class="forced-overlay" id="forced-overlay">
    <h1>🚫 Bài thi đã kết thúc</h1>
    <p>Bạn đã vi phạm quy định thi quá 3 lần. Bài làm được tự động nộp và đánh dấu vi phạm.</p>
    <div style="color:#94a3b8;font-size:.9rem;">Đang nộp bài...</div>
</div>

<!-- START EXAM OVERLAY -->
<div class="overlay active" id="start-overlay">
    <div class="overlay-card" style="border-color: var(--accent); max-width: 520px;">
        <h2 style="color: var(--accent); font-size: 1.6rem; margin-bottom: 1rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
            🔒 PHÒNG THI BẢO MẬT
        </h2>
        <div style="color: var(--text-muted); font-size: 0.9rem; text-align: left; line-height: 1.8; margin-bottom: 1.75rem;">
            <p>Chào mừng bạn đến với phòng thi <strong>IELTSFlow</strong>.</p>
            <p>Hệ thống đã kích hoạt chế độ <strong>Giám sát trực tuyến (Online Proctoring)</strong> để đảm bảo tính công bằng.</p>
            <div style="margin-top: 1rem; background: rgba(239, 68, 68, 0.08); border-left: 4px solid var(--danger); padding: 0.75rem; border-radius: 0.4rem; color: #fca5a5;">
                <strong>⚠️ QUY ĐỊNH PHÒNG THI:</strong><br>
                1. Hệ thống sẽ khóa toàn màn hình. Không được tự ý thoát.<br>
                2. Tuyệt đối không được chuyển tab hoặc ẩn trình duyệt.<br>
                3. Vi phạm quá <strong>3 lần</strong>, hệ thống sẽ <strong>tự động nộp bài lập tức</strong>.
            </div>
            <p style="margin-top: 1rem; font-style: italic; text-align: center;">Vui lòng chuẩn bị sẵn sàng và bấm nút bên dưới để mở toàn màn hình & bắt đầu tính giờ làm bài.</p>
        </div>
        <button class="btn-back-focus" id="btn-start-exam" style="width: 100%; background: linear-gradient(135deg, var(--accent), var(--accent2)); border-radius: 0.75rem; padding: 0.85rem; font-size: 1.05rem; letter-spacing: 0.02em;">
            🔓 KÍCH HOẠT BẢO MẬT & BẮT ĐẦU LÀM BÀI
        </button>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="main">

    <%-- Build skill set --%>
    <c:set var="skills" value="${['Listening','Reading','Writing','Speaking']}"/>
    <div class="skill-tabs" id="skill-tabs">
        <c:forEach var="sk" items="${skills}" varStatus="st">
            <button class="skill-tab ${st.first ? 'active' : ''}" onclick="switchSkill('${sk}')" id="tab-${sk}" type="button">${sk}</button>
        </c:forEach>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/mock-test?action=submit" id="exam-form" >
        <input type="hidden" name="action" value="submit">
        <input type="hidden" name="submissionId" value="${submissionId}">

        <c:forEach var="sk" items="${skills}" varStatus="skSt">
            <div class="skill-section ${skSt.first ? 'active' : ''}" id="section-${sk}">
                <c:set var="qNum" value="${0}"/>
                <c:forEach var="q" items="${questions}">
                    <c:if test="${q.skill == sk}">
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
                                           style="width:100%;padding:.75rem;border-radius:.6rem;border:1px solid var(--border);background:var(--surface2);color:var(--text);font-size:.9rem;font-family:'Inter',sans-serif;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:forEach>

        <!-- BOTTOM NAV -->
        <div class="bottom-nav">
            <div class="progress-info">Mã bài: #${submissionId}</div>
            <div class="nav-btns">
                <button type="button" class="btn-nav" onclick="history.back()" id="btn-cancel">Hủy</button>
                <button type="submit" class="btn-submit" id="btn-submit-exam"
                        onclick="return confirmSubmit()">
                    📤 Nộp bài
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
let isExamStarted = false;

function formatTime(s) {
    const h = Math.floor(s / 3600).toString().padStart(2,'0');
    const m = Math.floor((s % 3600) / 60).toString().padStart(2,'0');
    const sec = (s % 60).toString().padStart(2,'0');
    return h + ':' + m + ':' + sec;
}

const countdown = setInterval(() => {
    if (!isExamStarted) return;
    secondsLeft--;
    timerEl.textContent = formatTime(secondsLeft);
    if (secondsLeft <= 300) timerEl.classList.add('warning');
    if (secondsLeft <= 60)  { timerEl.classList.remove('warning'); timerEl.classList.add('danger'); }
    if (secondsLeft <= 0) {
        clearInterval(countdown);
        isExamStarted = false;
        document.getElementById('exam-form').submit();
    }
}, 1000);

// ========================================================
// FOCUS MODE — Full-screen + Tab detection
// ========================================================
let violationCount = 0;
const MAX_VIOLATIONS = ${maxViolations};
const submissionId   = ${submissionId};

function requestFullscreen() {
    const el = document.documentElement;
    if (el.requestFullscreen) el.requestFullscreen();
    else if (el.webkitRequestFullscreen) el.webkitRequestFullscreen();
}

function isFullscreen() {
    return !!(document.fullscreenElement || document.webkitFullscreenElement);
}

// Enter fullscreen and start exam on button click
document.getElementById('btn-start-exam').addEventListener('click', () => {
    requestFullscreen();
    isExamStarted = true;
    document.getElementById('start-overlay').classList.remove('active');
    timerEl.textContent = formatTime(secondsLeft);
});

// Detect tab switch
document.addEventListener('visibilitychange', () => {
    if (!isExamStarted) return;
    if (document.hidden) triggerViolation('tab');
});

// Detect fullscreen exit
document.addEventListener('fullscreenchange', () => {
    if (!isExamStarted) return;
    if (!isFullscreen()) triggerViolation('fullscreen');
});

function triggerViolation(type) {
    if (violationCount >= MAX_VIOLATIONS) return; // already cheated

    fetch('${pageContext.request.contextPath}/mock-test?action=violation', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=violation&submissionId=' + submissionId
    })
    .then(r => r.json())
    .then(data => {
        violationCount = data.violations;
        updateViolationDots(violationCount);
        document.getElementById('vio-count').textContent = violationCount;

        if (data.cheated) {
            // Force submit
            isExamStarted = false;
            document.getElementById('forced-overlay').classList.add('active');
            document.getElementById('exam-form').submit();
        } else {
            document.getElementById('violation-overlay').classList.add('active');
        }
    })
    .catch(() => {}); // silently fail if offline
}

function updateViolationDots(count) {
    for (let i = 1; i <= 3; i++) {
        const dot = document.getElementById('vdot' + i);
        dot.classList.toggle('used', i <= count);
    }
}

document.getElementById('btn-back-focus').addEventListener('click', () => {
    document.getElementById('violation-overlay').classList.remove('active');
    requestFullscreen();
});

// ========================================================
// SKILL TABS
// ========================================================
function switchSkill(skill) {
    document.querySelectorAll('.skill-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.skill-section').forEach(s => s.classList.remove('active'));
    document.getElementById('tab-' + skill).classList.add('active');
    document.getElementById('section-' + skill).classList.add('active');
}

// ========================================================
// WORD COUNT (Writing)
// ========================================================
function countWords(textarea, counterId) {
    const words = textarea.value.trim().split(/\s+/).filter(w => w.length > 0);
    document.getElementById(counterId).textContent = words.length + ' từ';
}

// ========================================================
// SPEAKING RECORDING (Web Speech API - Speech-To-Text)
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
        recognition.lang = 'en-US'; // Chỉnh sang tiếng Anh để thi IELTS
        recognition.interimResults = true;
        recognition.continuous = true;

        let finalTranscript = '';
        
        // Reset nội dung
        document.getElementById('transcript-' + qId).textContent = 'Đang nghe... (Hãy nói một câu tiếng Anh)';
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
            // Hiển thị trực tiếp chữ đang nói lên màn hình
            const currentText = finalTranscript + interimTranscript;
            document.getElementById('transcript-' + qId).textContent = currentText;
            document.getElementById('hidden-transcript-' + qId).value = currentText.trim();
        };

        recognition.onerror = (event) => {
            console.error('Lỗi nhận diện:', event.error);
        };

        recognition.onend = () => {
            document.querySelector('[name="q_' + qId + '"]').value = 'recorded';
            
            // Nếu người dùng dừng mà chưa có chữ nào
            if (document.getElementById('hidden-transcript-' + qId).value.trim() === '') {
                 document.getElementById('transcript-' + qId).textContent = '(Không nghe thấy bạn nói gì. Vui lòng thử lại)';
            }
        };

        recognition.start();
        recognitions[qId] = recognition;

        document.getElementById('btn-rec-' + qId).style.display = 'none';
        document.getElementById('btn-stop-' + qId).style.display = '';

        // Speaking timer
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
        recognitions[qId].stop(); // Lệnh này sẽ kích hoạt sự kiện onend ở trên
        delete recognitions[qId];
    }
    clearInterval(recTimers[qId]);
    document.getElementById('btn-rec-' + qId).style.display = '';
    document.getElementById('btn-stop-' + qId).style.display = 'none';
}

// ========================================================
// SUBMIT CONFIRM
// ========================================================
function confirmSubmit() {
    const ok = confirm('Bạn có chắc chắn muốn nộp bài? Hành động này không thể hoàn tác.');
    if (ok) {
        isExamStarted = false;
    }
    return ok;
}
</script>
</body>
</html>
