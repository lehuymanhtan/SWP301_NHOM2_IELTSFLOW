package models;

import java.time.LocalDateTime;

/**
 * Maps to the TestSubmissions table in IELTSFlow DB.
 * Represents a candidate's attempt at an exam.
 */
public class TestSubmission {
    private int submissionId;
    private int userId;
    private int examId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;

    // Band scores per skill
    private Double listeningBand;
    private Double readingBand;
    private Double writingBand;
    private Double speakingBand;
    private Double overallBand;
    private Double totalScore;

    // Anti-cheat fields
    private int violationCount;
    private boolean isCheated;
    private String status; // InProgress, Completed, Abandoned

    // Transient: exam title for display
    private String examTitle;
    private String examType;
    private String skillFocus;
    private int chronologicalIndex;

    public TestSubmission() {}

    public int getChronologicalIndex() { return chronologicalIndex; }
    public void setChronologicalIndex(int v) { this.chronologicalIndex = v; }

    // --- Getters & Setters ---
    public int getSubmissionId()                  { return submissionId; }
    public void setSubmissionId(int v)            { this.submissionId = v; }

    public int getUserId()                        { return userId; }
    public void setUserId(int v)                  { this.userId = v; }

    public int getExamId()                        { return examId; }
    public void setExamId(int v)                  { this.examId = v; }

    public LocalDateTime getStartTime()           { return startTime; }
    public void setStartTime(LocalDateTime v)     { this.startTime = v; }

    public LocalDateTime getEndTime()             { return endTime; }
    public void setEndTime(LocalDateTime v)       { this.endTime = v; }

    public Double getListeningBand()              { return listeningBand; }
    public void setListeningBand(Double v)        { this.listeningBand = v; }

    public Double getReadingBand()                { return readingBand; }
    public void setReadingBand(Double v)          { this.readingBand = v; }

    public Double getWritingBand()                { return writingBand; }
    public void setWritingBand(Double v)          { this.writingBand = v; }

    public Double getSpeakingBand()               { return speakingBand; }
    public void setSpeakingBand(Double v)         { this.speakingBand = v; }

    public Double getOverallBand()                { return overallBand; }
    public void setOverallBand(Double v)          { this.overallBand = v; }

    public Double getTotalScore()                 { return totalScore; }
    public void setTotalScore(Double v)           { this.totalScore = v; }

    public int getViolationCount()                { return violationCount; }
    public void setViolationCount(int v)          { this.violationCount = v; }

    public boolean isCheated()                    { return isCheated; }
    public void setCheated(boolean v)             { this.isCheated = v; }

    public String getStatus()                     { return status; }
    public void setStatus(String v)               { this.status = v; }

    public String getExamTitle()                  { return examTitle; }
    public void setExamTitle(String v)            { this.examTitle = v; }

    public String getExamType()                   { return examType; }
    public void setExamType(String v)             { this.examType = v; }

    public String getSkillFocus()                 { return skillFocus; }
    public void setSkillFocus(String v)           { this.skillFocus = v; }

    /**
     * Calculates duration in minutes between start and end time.
     * Returns -1 if either time is null.
     */
    public long getDurationMinutes() {
        if (startTime == null || endTime == null) return -1;
        return java.time.Duration.between(startTime, endTime).toMinutes();
    }

    public java.util.Date getStartTimeAsDate() {
        if (startTime == null) return null;
        return java.sql.Timestamp.valueOf(startTime);
    }

    public java.util.Date getEndTimeAsDate() {
        if (endTime == null) return null;
        return java.sql.Timestamp.valueOf(endTime);
    }
}
