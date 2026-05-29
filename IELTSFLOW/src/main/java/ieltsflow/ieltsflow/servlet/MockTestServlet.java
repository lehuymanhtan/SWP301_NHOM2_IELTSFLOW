package ieltsflow.ieltsflow.servlet;

import ieltsflow.ieltsflow.dao.ExamDAO;
import ieltsflow.ieltsflow.dao.SubmissionDAO;
import ieltsflow.ieltsflow.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;

/**
 * MockTestServlet — Handles all Mock Test actions:
 *   GET  /mock-test          → start page (pick a random exam)
 *   GET  /mock-test?action=start&examId=X  → load exam into session, redirect to focus page
 *   GET  /mock-test?action=take           → render the timed exam UI
 *   POST /mock-test?action=submit         → grade answers, save, redirect to result
 *   POST /mock-test?action=violation      → record a tab-switch / focus-loss violation (AJAX)
 *   GET  /mock-test?action=result&submissionId=X → show band scores
 */
@WebServlet(name = "MockTestServlet", urlPatterns = {"/mock-test"})
public class MockTestServlet extends HttpServlet {

    private static final int MAX_VIOLATIONS = 3;

    private final ExamDAO examDAO = new ExamDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard (Auto-login for local testing)
        HttpSession session = req.getSession(true);
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", 1);
            session.setAttribute("fullName", "Vương");
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "start":
                    handleStart(req, resp);
                    break;
                case "take":
                    handleTake(req, resp);
                    break;
                case "result":
                    handleResult(req, resp);
                    break;
                default:
                    handleIndex(req, resp);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", 1);
            session.setAttribute("fullName", "Vương");
        }

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "submit":
                    handleSubmit(req, resp);
                    break;
                case "violation":
                    handleViolation(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/mock-test");
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }

    // ------------------------------------------------------------------ //
    //  HANDLERS
    // ------------------------------------------------------------------ //

    /** Landing: show intro and pick a random exam. */
    private void handleIndex(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        Exam exam = examDAO.getRandomMockTest();
        req.setAttribute("exam", exam);
        req.getRequestDispatcher("/WEB-INF/views/mock-test/index.jsp").forward(req, resp);
    }

    /**
     * Start: create a submission row, load questions into session, redirect to /mock-test?action=take
     */
    private void handleStart(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int userId = (int) req.getSession().getAttribute("userId");

        // Pick a random exam (ignore examId param — always fresh random)
        Exam exam = examDAO.getRandomMockTest();
        if (exam == null) {
            req.setAttribute("errorMsg", "Hiện tại chưa có đề thi nào. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/WEB-INF/views/mock-test/index.jsp").forward(req, resp);
            return;
        }

        // Create submission in DB
        TestSubmission sub = new TestSubmission();
        sub.setUserId(userId);
        sub.setExamId(exam.getExamId());
        sub.setStartTime(LocalDateTime.now());
        int submissionId = submissionDAO.createSubmission(sub);

        // Load questions with shuffled order
        List<Question> questions = examDAO.getQuestionsForExam(exam.getExamId());

        // Store in session so take-page can render without a DB round-trip
        HttpSession session = req.getSession();
        session.setAttribute("currentExam", exam);
        session.setAttribute("currentQuestions", questions);
        session.setAttribute("currentSubmissionId", submissionId);
        session.setAttribute("examStartTime", System.currentTimeMillis());

        resp.sendRedirect(req.getContextPath() + "/mock-test?action=take");
    }

    /**
     * Take: render the full-screen exam page with countdown timer.
     */
    private void handleTake(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        Exam exam = (Exam) session.getAttribute("currentExam");
        if (exam == null) {
            resp.sendRedirect(req.getContextPath() + "/mock-test");
            return;
        }
        req.setAttribute("exam", exam);
        req.setAttribute("questions", session.getAttribute("currentQuestions"));
        req.setAttribute("submissionId", session.getAttribute("currentSubmissionId"));
        req.setAttribute("maxViolations", MAX_VIOLATIONS);
        req.getRequestDispatcher("/WEB-INF/views/mock-test/take.jsp").forward(req, resp);
    }

    /**
     * Submit: grade MC/fill-blank answers, set Writing/Speaking to pending,
     * calculate band scores, finalise submission.
     */
    @SuppressWarnings("unchecked")
    private void handleSubmit(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        int submissionId = (Integer) session.getAttribute("currentSubmissionId");
        List<Question> questions = (List<Question>) session.getAttribute("currentQuestions");
        Exam exam = (Exam) session.getAttribute("currentExam");

        int correctReading   = 0, totalReading   = 0;
        int correctListening = 0, totalListening = 0;
        double sumWriting = 0, sumSpeaking = 0;
        int countWriting = 0, countSpeaking = 0;

        ieltsflow.ieltsflow.service.AIService aiService = new ieltsflow.ieltsflow.service.AIService();

        for (Question q : questions) {
            String skill  = q.getSkill() != null ? q.getSkill().trim() : "";
            String qType = q.getQuestionType() != null ? q.getQuestionType().trim() : "";
            String answer = req.getParameter("q_" + q.getQuestionId());

            SubmissionDetail detail = new SubmissionDetail();
            detail.setSubmissionId(submissionId);
            detail.setQuestionId(q.getQuestionId());
            detail.setCandidateAnswer(answer);

            if ("Multiple_Choice".equals(qType) || "FillBlank".equals(qType)) {
                boolean correct = isAnswerCorrect(q, answer);
                detail.setIsCorrect(correct);
                detail.setScore(correct ? 1.0 : 0.0);
                detail.setGradingStatus("Graded");

                if ("Reading".equals(skill))   { totalReading++;   if (correct) correctReading++;   }
                if ("Listening".equals(skill)) { totalListening++; if (correct) correctListening++; }
                
                submissionDAO.saveDetail(detail);
            } else {
                // Writing / Speaking
                detail.setGradingStatus("Pending_AI");
                if ("Speaking".equals(skill)) {
                    detail.setSpeakingUrl(req.getParameter("speaking_url_" + q.getQuestionId()));
                    detail.setCandidateTranscript(req.getParameter("transcript_" + q.getQuestionId()));
                }
                int detailId = submissionDAO.saveDetail(detail);
                
                // Call AI Mock Service
                double aiScore = aiService.gradeSubjectiveAnswer(detailId, skill, answer);
                
                if ("Writing".equals(skill)) { sumWriting += aiScore; countWriting++; }
                if ("Speaking".equals(skill)) { sumSpeaking += aiScore; countSpeaking++; }
            }
        }

        // Calculate band for objective skills (IELTS raw score → band mapping, simplified)
        Double listeningBand = totalListening > 0 ? rawToBand(correctListening, totalListening) : null;
        Double readingBand   = totalReading   > 0 ? rawToBand(correctReading,   totalReading)   : null;
        Double writingBand   = countWriting   > 0 ? (sumWriting / countWriting) : null;
        Double speakingBand  = countSpeaking  > 0 ? (sumSpeaking / countSpeaking) : null;

        // Overall = average of available bands
        Double overall = calcOverall(listeningBand, readingBand, writingBand, speakingBand);

        // Finalise submission
        int violationCount = 0;
        boolean isCheated = false;
        Object vc = session.getAttribute("violationCount_" + submissionId);
        if (vc != null) violationCount = (int) vc;
        boolean forcedSubmit = Boolean.TRUE.equals(session.getAttribute("forcedSubmit_" + submissionId));
        if (forcedSubmit) { isCheated = true; violationCount = MAX_VIOLATIONS; }

        TestSubmission finalSub = new TestSubmission();
        finalSub.setSubmissionId(submissionId);
        finalSub.setEndTime(LocalDateTime.now());
        finalSub.setListeningBand(listeningBand);
        finalSub.setReadingBand(readingBand);
        finalSub.setOverallBand(overall);
        finalSub.setViolationCount(violationCount);
        finalSub.setCheated(isCheated);
        finalSub.setStatus(forcedSubmit ? "Abandoned" : "Completed");
        submissionDAO.finaliseSubmission(finalSub);

        // Clean session
        session.removeAttribute("currentExam");
        session.removeAttribute("currentQuestions");
        session.removeAttribute("currentSubmissionId");
        session.removeAttribute("examStartTime");
        session.removeAttribute("violationCount_" + submissionId);
        session.removeAttribute("forcedSubmit_" + submissionId);

        resp.sendRedirect(req.getContextPath() + "/mock-test?action=result&submissionId=" + submissionId);
    }

    /**
     * Violation: AJAX endpoint called when candidate exits fullscreen / switches tab.
     * Returns JSON: {"violations": N, "cheated": false/true}
     */
    private void handleViolation(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        HttpSession session = req.getSession(false);
        Object subIdObj = session != null ? session.getAttribute("currentSubmissionId") : null;
        if (subIdObj == null) {
            resp.setStatus(400);
            return;
        }
        int submissionId = (int) subIdObj;
        int violations = submissionDAO.incrementViolation(submissionId, MAX_VIOLATIONS);

        if (violations >= MAX_VIOLATIONS && session != null) {
            session.setAttribute("forcedSubmit_" + submissionId, true);
        }

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("{\"violations\":" + violations + ",\"cheated\":" + (violations >= MAX_VIOLATIONS) + "}");
    }

    /**
     * Result: load submission + details and forward to result page.
     */
    private void handleResult(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int subId;
        try {
            subId = Integer.parseInt(req.getParameter("submissionId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Security: only owner can view
        int userId = (int) req.getSession().getAttribute("userId");
        TestSubmission sub = submissionDAO.getSubmissionById(subId);
        if (sub == null || sub.getUserId() != userId) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.setAttribute("submission", sub);
        req.getRequestDispatcher("/WEB-INF/views/mock-test/result.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------ //
    //  HELPERS
    // ------------------------------------------------------------------ //

    private boolean isAnswerCorrect(Question q, String candidateAnswer) {
        if (candidateAnswer == null || candidateAnswer.isBlank()) return false;
        for (Answer a : q.getAnswers()) {
            if (a.isCorrect() && candidateAnswer.equalsIgnoreCase(a.getContent().trim())) return true;
            // Also support answer by answerId (radio button value = answerId)
            try {
                if (a.isCorrect() && a.getAnswerId() == Integer.parseInt(candidateAnswer.trim())) return true;
            } catch (NumberFormatException ignored) {}
        }
        return false;
    }

    /**
     * Simplified raw-score → IELTS band mapping for Listening/Reading.
     * Listening: 40 questions; Reading: 40 questions.
     * Uses approximate official IELTS conversion (Academic).
     */
    private double rawToBand(int correct, int total) {
        if (total == 0) return 0;
        double pct = (double) correct / total;
        if (pct >= 0.97) return 9.0;
        if (pct >= 0.93) return 8.5;
        if (pct >= 0.87) return 8.0;
        if (pct >= 0.80) return 7.5;
        if (pct >= 0.73) return 7.0;
        if (pct >= 0.67) return 6.5;
        if (pct >= 0.60) return 6.0;
        if (pct >= 0.53) return 5.5;
        if (pct >= 0.47) return 5.0;
        if (pct >= 0.40) return 4.5;
        if (pct >= 0.33) return 4.0;
        if (pct >= 0.27) return 3.5;
        if (pct >= 0.20) return 3.0;
        return 2.5;
    }

    private Double calcOverall(Double l, Double r, Double w, Double s) {
        double sum = 0; int count = 0;
        if (l != null) { sum += l; count++; }
        if (r != null) { sum += r; count++; }
        if (w != null) { sum += w; count++; }
        if (s != null) { sum += s; count++; }
        if (count == 0) return null;
        // IELTS rounds to nearest 0.5
        double avg = sum / count;
        return Math.round(avg * 2) / 2.0;
    }
}
