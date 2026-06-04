package services;

import dao.SubmissionDAO;
import models.*;

import java.sql.SQLException;
import java.util.List;

/**
 * SubmissionService — Business logic for test submission management.
 * Controllers should call this instead of accessing SubmissionDAO directly.
 */
public class SubmissionService {

    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    /** Get all submissions for a user. */
    public List<TestSubmission> getSubmissionsByUser(int userId) throws SQLException {
        return submissionDAO.getSubmissionsByUser(userId);
    }

    /** Get a single submission by ID (with ownership check). Returns null if not found or unauthorized. */
    public TestSubmission getSubmissionById(int submissionId) throws SQLException {
        return submissionDAO.getSubmissionById(submissionId);
    }

    /** Get all submission details for a given submission. */
    public List<SubmissionDetail> getDetailsBySubmission(int submissionId) throws SQLException {
        return submissionDAO.getDetailsBySubmission(submissionId);
    }

    /** Create a new submission record. Returns the generated submissionId. */
    public int createSubmission(TestSubmission submission) throws SQLException {
        return submissionDAO.createSubmission(submission);
    }

    /** Persist a single question answer detail. Returns the generated detailId. */
    public int saveDetail(SubmissionDetail detail) throws SQLException {
        return submissionDAO.saveDetail(detail);
    }

    /** Finalize a submission (write band scores, status, end time). */
    public void finaliseSubmission(TestSubmission submission) throws SQLException {
        submissionDAO.finaliseSubmission(submission);
    }

    /** Increment violation count for a submission. Returns new total. */
    public int incrementViolation(int submissionId, int maxViolations) throws SQLException {
        return submissionDAO.incrementViolation(submissionId, maxViolations);
    }
}
