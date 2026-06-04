package dao;

import models.Answer;
import models.Exam;
import models.Question;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * DAO for Exam and Question operations — Mock Test, Placement Test, Practice.
 */
public class ExamDAO {

    /**
     * Returns one random Placement Test exam.
     */
    public Exam getRandomPlacementTest() throws SQLException {
        String sql = "SELECT TOP 1 ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt "
                   + "FROM Exams WHERE Type = 'Placement Test' ORDER BY NEWID()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return mapExam(rs);
        }
        return null;
    }

    /**
     * Returns all Practice exams for a given skill (Listening/Reading/Writing/Speaking).
     */
    public List<Exam> getPracticeExamsBySkill(String skill) throws SQLException {
        String sql = "SELECT ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt "
                   + "FROM Exams WHERE Type = 'Practice' AND SkillFocus = ? ORDER BY ExamID";
        List<Exam> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, skill);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapExam(rs));
            }
        }
        return list;
    }

    /**
     * Returns all Practice exams grouped (all skills) — for the Practice landing page.
     */
    public List<Exam> getAllPracticeExams() throws SQLException {
        String sql = "SELECT ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt "
                   + "FROM Exams WHERE Type = 'Practice' ORDER BY SkillFocus, ExamID";
        List<Exam> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapExam(rs));
        }
        return list;
    }

    /**
     * Retrieves one random Mock Test exam (Type = 'Mock Test') from the DB.
     */
    public Exam getRandomMockTest() throws SQLException {
        String sql = "SELECT TOP 1 ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt "
                   + "FROM Exams WHERE Type = 'Mock Test' ORDER BY NEWID()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapExam(rs);
            }
        }
        return null;
    }

    /**
     * Returns an exam by its primary key.
     */
    public Exam getExamById(int examId) throws SQLException {
        String sql = "SELECT ExamID, Title, Type, SkillFocus, Duration, MentorID, CreatedAt "
                   + "FROM Exams WHERE ExamID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapExam(rs);
            }
        }
        return null;
    }

    /**
     * Loads all questions for a given exam, with their answers.
     * Questions are shuffled randomly.
     */
    public List<Question> getQuestionsForExam(int examId) throws SQLException {
        String sql = "SELECT q.QuestionID, q.ResourceID, q.Content, q.QuestionType, q.Skill, "
                   + "       q.Difficulty, q.Explanation, q.OrderInResource, q.MetadataJSON, "
                   + "       r.ResourceText, r.ResourceAudioURL "
                   + "FROM ExamQuestions eq "
                   + "JOIN Questions q ON eq.QuestionID = q.QuestionID "
                   + "LEFT JOIN QuestionResource r ON q.ResourceID = r.ResourceID "
                   + "WHERE eq.ExamID = ?";
        List<Question> questions = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = mapQuestion(rs);
                    q.setAnswers(getAnswersForQuestion(conn, q.getQuestionId()));
                    questions.add(q);
                }
            }
        }
        Collections.shuffle(questions);
        return questions;
    }

    private List<Answer> getAnswersForQuestion(Connection conn, int questionId) throws SQLException {
        String sql = "SELECT AnswerID, QuestionID, Content, IsCorrect FROM Answers WHERE QuestionID = ?";
        List<Answer> answers = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Answer a = new Answer();
                    a.setAnswerId(rs.getInt("AnswerID"));
                    a.setQuestionId(rs.getInt("QuestionID"));
                    a.setContent(rs.getString("Content"));
                    a.setCorrect(rs.getBoolean("IsCorrect"));
                    answers.add(a);
                }
            }
        }
        return answers;
    }

    // --- Mappers ---

    private Exam mapExam(ResultSet rs) throws SQLException {
        Exam e = new Exam();
        e.setExamId(rs.getInt("ExamID"));
        e.setTitle(rs.getString("Title"));
        e.setType(rs.getString("Type"));
        e.setSkillFocus(rs.getString("SkillFocus"));
        e.setDuration(rs.getInt("Duration"));
        int mid = rs.getInt("MentorID");
        if (!rs.wasNull()) e.setMentorId(mid);
        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) e.setCreatedAt(ts.toLocalDateTime());
        return e;
    }

    private Question mapQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionId(rs.getInt("QuestionID"));
        int rid = rs.getInt("ResourceID");
        if (!rs.wasNull()) q.setResourceId(rid);
        q.setContent(rs.getString("Content"));
        q.setQuestionType(rs.getString("QuestionType"));
        q.setSkill(rs.getString("Skill"));
        q.setDifficulty(rs.getString("Difficulty"));
        q.setExplanation(rs.getString("Explanation"));
        int order = rs.getInt("OrderInResource");
        if (!rs.wasNull()) q.setOrderInResource(order);
        q.setMetadataJSON(rs.getString("MetadataJSON"));
        q.setResourceText(rs.getString("ResourceText"));
        q.setResourceAudioUrl(rs.getString("ResourceAudioURL"));
        return q;
    }
}
