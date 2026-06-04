package services;

import util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;

/**
 * Service to interact with AI API for grading subjective skills (Writing, Speaking).
 * Currently implemented as a Mock Service for local demonstration.
 */
public class AIService {
    
    private final Random random = new Random();
    
    public double gradeSubjectiveAnswer(int detailId, String skill, String answerContent) {
        System.out.println("Calling AI API for DetailID: " + detailId + ", Skill: " + skill);
        try { Thread.sleep(500); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        
        double[] possibleBands = {5.5, 6.0, 6.5, 7.0, 7.5, 8.0};
        double score = possibleBands[random.nextInt(possibleBands.length)];
        
        String feedbackJson = "Writing".equals(skill)
            ? "{\"TaskResponse\":\"Good effort.\",\"Coherence\":\"Logical.\",\"EstimatedBand\":" + score + "}"
            : "{\"Fluency\":\"Generally fluent.\",\"Grammar\":\"Good.\",\"EstimatedBand\":" + score + "}";
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE SubmissionDetails SET Score=?, GradingStatus='Graded' WHERE DetailID=?")) {
                    ps.setDouble(1, score); ps.setInt(2, detailId); ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO AIEvaluations (DetailID, FeedbackJSON) VALUES (?,?)")) {
                    ps.setInt(1, detailId); ps.setString(2, feedbackJson); ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) { conn.rollback(); e.printStackTrace(); }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) { e.printStackTrace(); }
        
        return score;
    }
}
