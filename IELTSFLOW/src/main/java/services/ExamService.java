package services;

import dao.ExamDAO;
import dao.SubmissionDAO;
import models.*;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * ExamService — Business logic for exam retrieval and submission creation.
 * Controllers should call this instead of accessing ExamDAO directly.
 */
public class ExamService {

    private final ExamDAO examDAO = new ExamDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    /** Get a random Placement Test exam. */
    public Exam getRandomPlacementTest() throws SQLException {
        return examDAO.getRandomPlacementTest();
    }

    /** Get a random Mock Test exam. */
    public Exam getRandomMockTest() throws SQLException {
        return examDAO.getRandomMockTest();
    }

    /** Get an exam by its ID. */
    public Exam getExamById(int examId) throws SQLException {
        return examDAO.getExamById(examId);
    }

    /** Get all Practice exams for a specific skill. */
    public List<Exam> getPracticeExamsBySkill(String skill) throws SQLException {
        return examDAO.getPracticeExamsBySkill(skill);
    }

    /** Get all Practice exams (all skills). */
    public List<Exam> getAllPracticeExams() throws SQLException {
        return examDAO.getAllPracticeExams();
    }

    /** Load all questions (with answers) for a given exam. */
    public List<Question> getQuestionsForExam(int examId) throws SQLException {
        return examDAO.getQuestionsForExam(examId);
    }

    /**
     * Creates a new TestSubmission record in the database and returns its generated ID.
     */
    public int startSubmission(int userId, int examId) throws SQLException {
        TestSubmission sub = new TestSubmission();
        sub.setUserId(userId);
        sub.setExamId(examId);
        sub.setStartTime(LocalDateTime.now());
        return submissionDAO.createSubmission(sub);
    }
}
