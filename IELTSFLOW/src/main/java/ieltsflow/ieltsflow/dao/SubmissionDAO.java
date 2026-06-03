package ieltsflow.ieltsflow.dao;

import ieltsflow.ieltsflow.model.SubmissionDetail;
import ieltsflow.ieltsflow.model.TestSubmission;
import ieltsflow.ieltsflow.util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for TestSubmissions and SubmissionDetails — used in Mock Test and Dashboard.
 */
public class SubmissionDAO {

    /**
     * Creates a new submission (start of exam) and returns its generated ID.
     */
    public int createSubmission(TestSubmission sub) throws SQLException {
        String sql = "INSERT INTO TestSubmissions (UserID, ExamID, StartTime, Status) "
                   + "VALUES (?, ?, ?, 'InProgress')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, sub.getUserId());
            ps.setInt(2, sub.getExamId());
            ps.setTimestamp(3, Timestamp.valueOf(sub.getStartTime()));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Finalises a submission: writes band scores, status, timestamps, violation info.
     */
    public void finaliseSubmission(TestSubmission sub) throws SQLException {
        String sql = "UPDATE TestSubmissions SET EndTime=?, ListeningBand=?, ReadingBand=?, "
                   + "WritingBand=?, SpeakingBand=?, OverallBand=?, TotalScore=?, "
                   + "ViolationCount=?, IsCheated=?, Status=? "
                   + "WHERE SubmissionID=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, sub.getEndTime() != null ? Timestamp.valueOf(sub.getEndTime()) : null);
            setNullableDouble(ps, 2, sub.getListeningBand());
            setNullableDouble(ps, 3, sub.getReadingBand());
            setNullableDouble(ps, 4, sub.getWritingBand());
            setNullableDouble(ps, 5, sub.getSpeakingBand());
            setNullableDouble(ps, 6, sub.getOverallBand());
            setNullableDouble(ps, 7, sub.getTotalScore());
            ps.setInt(8, sub.getViolationCount());
            ps.setBoolean(9, sub.isCheated());
            ps.setString(10, sub.getStatus());
            ps.setInt(11, sub.getSubmissionId());
            ps.executeUpdate();
        }
    }

    /**
     * Increments violation counter and optionally marks as cheated.
     */
    public int incrementViolation(int submissionId, int maxViolations) throws SQLException {
        // Get current count
        int current = 0;
        String select = "SELECT ViolationCount FROM TestSubmissions WHERE SubmissionID=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(select)) {
            ps.setInt(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) current = rs.getInt("ViolationCount");
            }
        }
        int next = current + 1;
        boolean cheat = next >= maxViolations;
        String update = "UPDATE TestSubmissions SET ViolationCount=?, IsCheated=? "
                      + (cheat ? ", Status='Abandoned'" : "") + " WHERE SubmissionID=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(update)) {
            ps.setInt(1, next);
            ps.setBoolean(2, cheat);
            ps.setInt(3, submissionId);
            ps.executeUpdate();
        }
        return next;
    }

    /**
     * Saves one candidate answer (SubmissionDetail row).
     */
    public int saveDetail(SubmissionDetail detail) throws SQLException {
        String sql = "INSERT INTO SubmissionDetails "
                   + "(SubmissionID, QuestionID, CandidateAnswer, SpeakingUrl, "
                   + " CandidateTranscript, IsCorrect, Score, GradingStatus) "
                   + "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, detail.getSubmissionId());
            ps.setInt(2, detail.getQuestionId());
            ps.setString(3, detail.getCandidateAnswer());
            ps.setString(4, detail.getSpeakingUrl());
            ps.setString(5, detail.getCandidateTranscript());
            if (detail.getIsCorrect() != null) ps.setBoolean(6, detail.getIsCorrect());
            else ps.setNull(6, Types.BIT);
            if (detail.getScore() != null) ps.setDouble(7, detail.getScore());
            else ps.setNull(7, Types.DECIMAL);
            ps.setString(8, detail.getGradingStatus() != null ? detail.getGradingStatus() : "Graded");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Returns all submissions for a user (Dashboard - history).
     * Ordered by most recent first.
     */
    public List<TestSubmission> getSubmissionsByUser(int userId) throws SQLException {
        String sql = "SELECT ts.SubmissionID, ts.UserID, ts.ExamID, ts.StartTime, ts.EndTime, "
                   + "ts.ListeningBand, ts.ReadingBand, ts.WritingBand, ts.SpeakingBand, "
                   + "ts.OverallBand, ts.TotalScore, ts.ViolationCount, ts.IsCheated, ts.Status, "
                   + "e.Title AS ExamTitle, e.Type AS ExamType, e.SkillFocus "
                   + "FROM TestSubmissions ts "
                   + "JOIN Exams e ON ts.ExamID = e.ExamID "
                   + "WHERE ts.UserID = ? "
                   + "ORDER BY ts.StartTime DESC";
        List<TestSubmission> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSubmission(rs));
            }
        }
        return list;
    }

    /**
     * Returns one submission by its ID (used for result detail page).
     */
    public TestSubmission getSubmissionById(int submissionId) throws SQLException {
        String sql = "SELECT ts.SubmissionID, ts.UserID, ts.ExamID, ts.StartTime, ts.EndTime, "
                   + "ts.ListeningBand, ts.ReadingBand, ts.WritingBand, ts.SpeakingBand, "
                   + "ts.OverallBand, ts.TotalScore, ts.ViolationCount, ts.IsCheated, ts.Status, "
                   + "e.Title AS ExamTitle, e.Type AS ExamType, e.SkillFocus "
                   + "FROM TestSubmissions ts "
                   + "JOIN Exams e ON ts.ExamID = e.ExamID "
                   + "WHERE ts.SubmissionID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSubmission(rs);
            }
        }
        return null;
    }

    /**
     * Returns detailed answers for a submission, enriched with question info and AI feedback.
     */
    public List<SubmissionDetail> getDetailsBySubmission(int submissionId) throws SQLException {
        String sql = "SELECT sd.DetailID, sd.SubmissionID, sd.QuestionID, sd.CandidateAnswer, "
                   + "sd.SpeakingUrl, sd.CandidateTranscript, sd.IsCorrect, sd.Score, sd.GradingStatus, "
                   + "q.Content AS QuestionContent, q.QuestionType, q.Skill, q.Explanation, "
                   + "a.Content AS CorrectAnswer, ai.FeedbackJSON "
                   + "FROM SubmissionDetails sd "
                   + "JOIN Questions q ON sd.QuestionID = q.QuestionID "
                   + "LEFT JOIN Answers a ON a.QuestionID = q.QuestionID AND a.IsCorrect = 1 "
                   + "LEFT JOIN AIEvaluations ai ON ai.DetailID = sd.DetailID "
                   + "WHERE sd.SubmissionID = ? "
                   + "ORDER BY sd.DetailID";
        List<SubmissionDetail> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SubmissionDetail d = new SubmissionDetail();
                    d.setDetailId(rs.getInt("DetailID"));
                    d.setSubmissionId(rs.getInt("SubmissionID"));
                    d.setQuestionId(rs.getInt("QuestionID"));
                    d.setCandidateAnswer(rs.getString("CandidateAnswer"));
                    d.setSpeakingUrl(rs.getString("SpeakingUrl"));
                    d.setCandidateTranscript(rs.getString("CandidateTranscript"));
                    boolean ic = rs.getBoolean("IsCorrect");
                    d.setIsCorrect(rs.wasNull() ? null : ic);
                    double sc = rs.getDouble("Score");
                    d.setScore(rs.wasNull() ? null : sc);
                    d.setGradingStatus(rs.getString("GradingStatus"));
                    d.setQuestionContent(rs.getString("QuestionContent"));
                    d.setQuestionType(rs.getString("QuestionType"));
                    d.setSkill(rs.getString("Skill"));
                    d.setExplanation(rs.getString("Explanation"));
                    d.setCorrectAnswerContent(rs.getString("CorrectAnswer"));
                    d.setAiFeedbackJson(rs.getString("FeedbackJSON"));
                    list.add(d);
                }
            }
        }
        return list;
    }

    // --- Private helpers ---

    private TestSubmission mapSubmission(ResultSet rs) throws SQLException {
        TestSubmission s = new TestSubmission();
        s.setSubmissionId(rs.getInt("SubmissionID"));
        s.setUserId(rs.getInt("UserID"));
        s.setExamId(rs.getInt("ExamID"));
        Timestamp st = rs.getTimestamp("StartTime");
        if (st != null) s.setStartTime(st.toLocalDateTime());
        Timestamp et = rs.getTimestamp("EndTime");
        if (et != null) s.setEndTime(et.toLocalDateTime());
        double lb = rs.getDouble("ListeningBand"); s.setListeningBand(rs.wasNull() ? null : lb);
        double rb = rs.getDouble("ReadingBand");   s.setReadingBand(rs.wasNull() ? null : rb);
        double wb = rs.getDouble("WritingBand");   s.setWritingBand(rs.wasNull() ? null : wb);
        double spb = rs.getDouble("SpeakingBand"); s.setSpeakingBand(rs.wasNull() ? null : spb);
        double ob = rs.getDouble("OverallBand");   s.setOverallBand(rs.wasNull() ? null : ob);
        double ts = rs.getDouble("TotalScore");    s.setTotalScore(rs.wasNull() ? null : ts);
        s.setViolationCount(rs.getInt("ViolationCount"));
        s.setCheated(rs.getBoolean("IsCheated"));
        s.setStatus(rs.getString("Status"));
        s.setExamTitle(rs.getString("ExamTitle"));
        s.setExamType(rs.getString("ExamType"));
        s.setSkillFocus(rs.getString("SkillFocus"));
        return s;
    }

    private void setNullableDouble(PreparedStatement ps, int idx, Double val) throws SQLException {
        if (val != null) ps.setDouble(idx, val);
        else ps.setNull(idx, Types.DECIMAL);
    }
}
