package models;

import java.time.LocalDateTime;

/**
 * Maps to the Exams table in IELTSFlow DB.
 */
public class Exam {
    private int examId;
    private String title;
    private String type;       // Mock Test, Placement Test, Practice
    private String skillFocus; // All, Listening, Reading, Writing, Speaking
    private int duration;      // minutes
    private Integer mentorId;
    private LocalDateTime createdAt;

    public Exam() {}

    public Exam(int examId, String title, String type, String skillFocus, int duration) {
        this.examId = examId;
        this.title = title;
        this.type = type;
        this.skillFocus = skillFocus;
        this.duration = duration;
    }

    // --- Getters & Setters ---
    public int getExamId()                   { return examId; }
    public void setExamId(int v)             { this.examId = v; }

    public String getTitle()                 { return title; }
    public void setTitle(String v)           { this.title = v; }

    public String getType()                  { return type; }
    public void setType(String v)            { this.type = v; }

    public String getSkillFocus()            { return skillFocus; }
    public void setSkillFocus(String v)      { this.skillFocus = v; }

    public int getDuration()                 { return duration; }
    public void setDuration(int v)           { this.duration = v; }

    public Integer getMentorId()             { return mentorId; }
    public void setMentorId(Integer v)       { this.mentorId = v; }

    public LocalDateTime getCreatedAt()      { return createdAt; }
    public void setCreatedAt(LocalDateTime v){ this.createdAt = v; }
}
