package ieltsflow.ieltsflow.service;

import ieltsflow.ieltsflow.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;

/**
 * Service to interact with AI API (OpenAI) for grading subjective skills (Writing, Speaking).
 * Currently implemented as a Mock Service for local demonstration.
 */
public class AIService {
    
    private final Random random = new Random();
    
    /**
     * Simulates an AI call to grade Writing or Speaking.
     * Inserts the feedback into AIEvaluations and updates the score in SubmissionDetails.
     */
    public double gradeSubjectiveAnswer(int detailId, String skill, String answerContent) {
        // 1. Pretend to call OpenAI API
        System.out.println("Calling OpenAI API for DetailID: " + detailId + ", Skill: " + skill);
        try {
            Thread.sleep(500); // simulate network delay
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 2. Generate random band score (5.5 - 8.0)
        double[] possibleBands = {5.5, 6.0, 6.5, 7.0, 7.5, 8.0};
        double score = possibleBands[random.nextInt(possibleBands.length)];
        
        // 3. Generate mock JSON feedback
        String feedbackJson;
        if ("Writing".equals(skill)) {
            feedbackJson = "{" +
                "\"TaskResponse\": \"Good effort, but could elaborate more.\"," +
                "\"Coherence\": \"Logical flow is mostly present.\"," +
                "\"LexicalResource\": \"Some good vocabulary used, e.g., 'fundamental'.\"," +
                "\"Grammar\": \"A few minor errors in article usage.\"," +
                "\"EstimatedBand\": " + score +
            "}";
        } else {
            feedbackJson = "{" +
                "\"Fluency\": \"Generally fluent with some hesitation.\"," +
                "\"LexicalResource\": \"Adequate range of vocabulary.\"," +
                "\"Grammar\": \"Good control of simple structures.\"," +
                "\"Pronunciation\": \"Clear and easy to understand.\"," +
                "\"EstimatedBand\": " + score +
            "}";
        }
        
        // 4. Save to Database
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Update SubmissionDetails
                String updateDetail = "UPDATE SubmissionDetails SET Score = ?, GradingStatus = 'Graded' WHERE DetailID = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateDetail)) {
                    ps.setDouble(1, score);
                    ps.setInt(2, detailId);
                    ps.executeUpdate();
                }
                
                // Insert into AIEvaluations
                String insertAI = "INSERT INTO AIEvaluations (DetailID, FeedbackJSON) VALUES (?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertAI)) {
                    ps.setInt(1, detailId);
                    ps.setString(2, feedbackJson);
                    ps.executeUpdate();
                }
                
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return score;
    }
}
