package ieltsflow.ieltsflow.servlet;

import ieltsflow.ieltsflow.dao.SubmissionDAO;
import ieltsflow.ieltsflow.model.SubmissionDetail;
import ieltsflow.ieltsflow.model.TestSubmission;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

/**
 * DashboardServlet — Handles candidate dashboard:
 *   GET  /dashboard            → history + progress stats
 *   GET  /dashboard?action=detail&submissionId=X → full result detail + AI feedback
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

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

        try {
            if ("detail".equals(action)) {
                handleDetail(req, resp);
            } else {
                handleDashboard(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }

    // ------------------------------------------------------------------ //
    //  HANDLERS
    // ------------------------------------------------------------------ //

    /**
     * Main dashboard: history list + progress statistics for chart.
     */
    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int userId = (int) req.getSession().getAttribute("userId");
        List<TestSubmission> submissions = submissionDAO.getSubmissionsByUser(userId);

        // ---- Build chart data (last 10 completed submissions ordered by time asc) ----
        List<TestSubmission> completed = submissions.stream()
                .filter(s -> "Completed".equals(s.getStatus()) || "Abandoned".equals(s.getStatus()))
                .sorted(Comparator.comparing(TestSubmission::getStartTime))
                .collect(java.util.stream.Collectors.toList());

        // Last 10 for chart
        List<TestSubmission> chartData = completed.size() > 10
                ? completed.subList(completed.size() - 10, completed.size())
                : completed;

        // Build JSON arrays for chart.js
        StringBuilder labels       = new StringBuilder("[");
        StringBuilder listeningArr = new StringBuilder("[");
        StringBuilder readingArr   = new StringBuilder("[");
        StringBuilder writingArr   = new StringBuilder("[");
        StringBuilder speakingArr  = new StringBuilder("[");
        StringBuilder overallArr   = new StringBuilder("[");

        for (int i = 0; i < chartData.size(); i++) {
            TestSubmission s = chartData.get(i);
            String label = "Bài " + (i + 1);
            labels.append("\"").append(label).append("\"");
            listeningArr.append(s.getListeningBand() != null ? s.getListeningBand() : "null");
            readingArr.append(s.getReadingBand()     != null ? s.getReadingBand()   : "null");
            writingArr.append(s.getWritingBand()     != null ? s.getWritingBand()   : "null");
            speakingArr.append(s.getSpeakingBand()   != null ? s.getSpeakingBand() : "null");
            overallArr.append(s.getOverallBand()     != null ? s.getOverallBand()  : "null");
            if (i < chartData.size() - 1) {
                labels.append(","); listeningArr.append(","); readingArr.append(",");
                writingArr.append(","); speakingArr.append(","); overallArr.append(",");
            }
        }
        labels.append("]"); listeningArr.append("]"); readingArr.append("]");
        writingArr.append("]"); speakingArr.append("]"); overallArr.append("]");

        // ---- Progress stats ----
        double avgOverall = completed.stream()
                .filter(s -> s.getOverallBand() != null)
                .mapToDouble(TestSubmission::getOverallBand)
                .average().orElse(0);
        double maxOverall = completed.stream()
                .filter(s -> s.getOverallBand() != null)
                .mapToDouble(TestSubmission::getOverallBand)
                .max().orElse(0);
        long totalTests = completed.size();

        req.setAttribute("submissions",    submissions);
        req.setAttribute("totalTests",     totalTests);
        req.setAttribute("avgBand",        Math.round(avgOverall * 2) / 2.0);
        req.setAttribute("maxBand",        maxOverall);
        req.setAttribute("chartLabels",    labels.toString());
        req.setAttribute("chartListening", listeningArr.toString());
        req.setAttribute("chartReading",   readingArr.toString());
        req.setAttribute("chartWriting",   writingArr.toString());
        req.setAttribute("chartSpeaking",  speakingArr.toString());
        req.setAttribute("chartOverall",   overallArr.toString());

        req.getRequestDispatcher("/WEB-INF/views/dashboard/index.jsp").forward(req, resp);
    }

    /**
     * Detail view: full question-by-question breakdown with AI feedback.
     */
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int userId = (int) req.getSession().getAttribute("userId");
        int subId;
        try {
            subId = Integer.parseInt(req.getParameter("submissionId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        TestSubmission sub = submissionDAO.getSubmissionById(subId);
        if (sub == null || sub.getUserId() != userId) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        List<SubmissionDetail> details = submissionDAO.getDetailsBySubmission(subId);

        // Group details by skill for organised display
        Map<String, List<SubmissionDetail>> bySkill = new LinkedHashMap<>();
        bySkill.put("Listening", new ArrayList<>());
        bySkill.put("Reading",   new ArrayList<>());
        bySkill.put("Writing",   new ArrayList<>());
        bySkill.put("Speaking",  new ArrayList<>());

        for (SubmissionDetail d : details) {
            String skill = d.getSkill();
            bySkill.computeIfAbsent(skill, k -> new ArrayList<>()).add(d);
        }

        req.setAttribute("submission", sub);
        req.setAttribute("details",    details);
        req.setAttribute("bySkill",    bySkill);
        req.getRequestDispatcher("/WEB-INF/views/dashboard/detail.jsp").forward(req, resp);
    }
}
