package controller;

import services.ExamService;
import services.SubmissionService;
import models.*;
import services.AIService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * PracticeServlet — Handles skill-based practice (Luyện thi riêng từng kỹ năng):
 *   GET  /practice                          → Landing: chọn kỹ năng
 *   GET  /practice?skill=Reading            → Danh sách bài luyện Reading
 *   GET  /practice?action=take&examId=X     → Làm bài luyện tập
 *   POST /practice?action=submit            → Chấm điểm, hiển thị kết quả ngay
 *   GET  /practice?action=result&submissionId=X → Kết quả chi tiết
 */
@WebServlet(name = "PracticeServlet", urlPatterns = {"/practice"})
public class PracticeServlet extends HttpServlet {

    private static final String[] SKILLS = {"Listening", "Reading", "Writing", "Speaking"};
    private final ExamService examService = new ExamService();
    private final SubmissionService submissionService = new SubmissionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        if (session.getAttribute("userId") == null) {
            session.setAttribute("userId", 1);
            session.setAttribute("fullName", "Vương");
        }
        String action = req.getParameter("action");
        String skill  = req.getParameter("skill");

        try {
            if ("take".equals(action)) {
                handleTake(req, resp);
            } else if ("submit".equals(action)) {
                doPost(req, resp);
            } else if ("result".equals(action)) {
                handleResult(req, resp);
            } else if (skill != null && !skill.isBlank()) {
                handleSkillList(req, resp, skill);
            } else {
                handleIndex(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
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
        try {
            handleSubmit(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
        }
    }

    /** Landing page: hiển thị 4 kỹ năng để chọn */
    private void handleIndex(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // Load all practice exams grouped by skill
        Map<String, List<Exam>> bySkill = new LinkedHashMap<>();
        for (String s : SKILLS) {
            bySkill.put(s, examService.getPracticeExamsBySkill(s));
        }
        req.setAttribute("bySkill", bySkill);
        req.getRequestDispatcher("/jsp/practice/index.jsp").forward(req, resp);
    }

    /** Danh sách bài luyện theo kỹ năng */
    private void handleSkillList(HttpServletRequest req, HttpServletResponse resp, String skill) throws Exception {
        List<Exam> exams = examService.getPracticeExamsBySkill(skill);
        req.setAttribute("skill", skill);
        req.setAttribute("exams", exams);
        req.getRequestDispatcher("/jsp/practice/list.jsp").forward(req, resp);
    }

    /** Bắt đầu làm bài luyện tập */
    private void handleTake(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int examId;
        try { examId = Integer.parseInt(req.getParameter("examId")); }
        catch (NumberFormatException e) { resp.sendRedirect(req.getContextPath() + "/practice"); return; }

        Exam exam = examService.getExamById(examId);
        if (exam == null || !"Practice".equals(exam.getType())) {
            resp.sendRedirect(req.getContextPath() + "/practice"); return;
        }

        int userId = (int) req.getSession().getAttribute("userId");
        TestSubmission sub = new TestSubmission();
        sub.setUserId(userId);
        sub.setExamId(examId);
        sub.setStartTime(LocalDateTime.now());
        int submissionId = submissionService.createSubmission(sub);

        List<Question> questions = examService.getQuestionsForExam(examId);
        HttpSession session = req.getSession();
        session.setAttribute("pr_currentExam", exam);
        session.setAttribute("pr_currentQuestions", questions);
        session.setAttribute("pr_currentSubmissionId", submissionId);

        req.setAttribute("exam", exam);
        req.setAttribute("questions", questions);
        req.setAttribute("submissionId", submissionId);
        req.getRequestDispatcher("/jsp/practice/take.jsp").forward(req, resp);
    }

    /** Chấm điểm bài luyện tập */
    @SuppressWarnings("unchecked")
    private void handleSubmit(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        HttpSession session = req.getSession(false);
        int submissionId = (Integer) session.getAttribute("pr_currentSubmissionId");
        List<Question> questions = (List<Question>) session.getAttribute("pr_currentQuestions");

        int correct = 0, total = 0;
        double sumAI = 0; int countAI = 0;
        AIService aiService = new AIService();

        for (Question q : questions) {
            String qType  = q.getQuestionType() != null ? q.getQuestionType().trim() : "";
            String skill   = q.getSkill() != null ? q.getSkill().trim() : "";
            String answer  = req.getParameter("q_" + q.getQuestionId());

            SubmissionDetail detail = new SubmissionDetail();
            detail.setSubmissionId(submissionId);
            detail.setQuestionId(q.getQuestionId());
            detail.setCandidateAnswer(answer);

            if ("Multiple_Choice".equals(qType) || "FillBlank".equals(qType)) {
                boolean isCorrect = isAnswerCorrect(q, answer);
                detail.setIsCorrect(isCorrect);
                detail.setScore(isCorrect ? 1.0 : 0.0);
                detail.setGradingStatus("Graded");
                total++;
                if (isCorrect) correct++;
                submissionService.saveDetail(detail);
            } else {
                detail.setGradingStatus("Pending_AI");
                if ("Speaking".equals(skill)) {
                    detail.setSpeakingUrl(req.getParameter("speaking_url_" + q.getQuestionId()));
                    detail.setCandidateTranscript(req.getParameter("transcript_" + q.getQuestionId()));
                }
                int detailId = submissionService.saveDetail(detail);
                double aiScore = aiService.gradeSubjectiveAnswer(detailId, skill, answer);
                sumAI += aiScore; countAI++;
            }
        }

        // Finalize submission
        Double band = total > 0 ? rawToBand(correct, total)
                    : (countAI > 0 ? sumAI / countAI : null);

        Exam exam = (Exam) session.getAttribute("pr_currentExam");
        String skillFocus = exam != null ? exam.getSkillFocus() : "";

        TestSubmission finalSub = new TestSubmission();
        finalSub.setSubmissionId(submissionId);
        finalSub.setEndTime(LocalDateTime.now());
        if ("Listening".equals(skillFocus)) finalSub.setListeningBand(band);
        if ("Reading".equals(skillFocus))   finalSub.setReadingBand(band);
        if ("Writing".equals(skillFocus))   finalSub.setWritingBand(band);
        if ("Speaking".equals(skillFocus))  finalSub.setSpeakingBand(band);
        finalSub.setOverallBand(band);
        finalSub.setStatus("Completed");
        submissionService.finaliseSubmission(finalSub);

        session.removeAttribute("pr_currentExam");
        session.removeAttribute("pr_currentQuestions");
        session.removeAttribute("pr_currentSubmissionId");

        resp.sendRedirect(req.getContextPath() + "/practice?action=result&submissionId=" + submissionId);
    }

    /** Kết quả bài luyện tập với chi tiết từng câu */
    private void handleResult(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int subId;
        try { subId = Integer.parseInt(req.getParameter("submissionId")); }
        catch (NumberFormatException e) { resp.sendRedirect(req.getContextPath() + "/practice"); return; }

        int userId = (int) req.getSession().getAttribute("userId");
        TestSubmission sub = submissionService.getSubmissionById(subId);
        if (sub == null || sub.getUserId() != userId) {
            resp.sendRedirect(req.getContextPath() + "/practice"); return;
        }

        List<SubmissionDetail> details = submissionService.getDetailsBySubmission(subId);
        req.setAttribute("submission", sub);
        req.setAttribute("details", details);
        req.getRequestDispatcher("/jsp/practice/result.jsp").forward(req, resp);
    }

    private boolean isAnswerCorrect(Question q, String candidateAnswer) {
        if (candidateAnswer == null || candidateAnswer.isBlank()) return false;
        for (Answer a : q.getAnswers()) {
            if (a.isCorrect() && candidateAnswer.equalsIgnoreCase(a.getContent().trim())) return true;
            try { if (a.isCorrect() && a.getAnswerId() == Integer.parseInt(candidateAnswer.trim())) return true; }
            catch (NumberFormatException ignored) {}
        }
        return false;
    }

    private double rawToBand(int correct, int total) {
        if (total == 0) return 0;
        double pct = (double) correct / total;
        if (pct >= 0.97) return 9.0; if (pct >= 0.93) return 8.5;
        if (pct >= 0.87) return 8.0; if (pct >= 0.80) return 7.5;
        if (pct >= 0.73) return 7.0; if (pct >= 0.67) return 6.5;
        if (pct >= 0.60) return 6.0; if (pct >= 0.53) return 5.5;
        if (pct >= 0.47) return 5.0; if (pct >= 0.40) return 4.5;
        if (pct >= 0.33) return 4.0; if (pct >= 0.27) return 3.5;
        if (pct >= 0.20) return 3.0; return 2.5;
    }
}
