USE IELTSFlow;
GO

-- 1. Insert standard roles if they do not exist
IF NOT EXISTS (SELECT * FROM Roles WHERE RoleID = 1)
BEGIN
    SET IDENTITY_INSERT Roles ON;
    INSERT INTO Roles (RoleID, RoleName, Description) VALUES (1, 'Admin', 'System Administrator');
    INSERT INTO Roles (RoleID, RoleName, Description) VALUES (2, 'Mentor', 'Teacher/Mentor');
    INSERT INTO Roles (RoleID, RoleName, Description) VALUES (3, 'Candidate', 'IELTS Candidate');
    SET IDENTITY_INSERT Roles OFF;
END
GO

-- 2. Insert dummy Candidate user 'Vương' with UserID = 1 if it does not exist
IF NOT EXISTS (SELECT * FROM Users WHERE UserID = 1)
BEGIN
    SET IDENTITY_INSERT Users ON;
    INSERT INTO Users (UserID, RoleID, Email, FullName, Status)
    VALUES (1, 3, 'vuong@ieltsflow.com', N'Vương', 'Active');
    SET IDENTITY_INSERT Users OFF;
END
GO

-- 3. Verify standard Exams table has a dummy mock test
IF NOT EXISTS (SELECT * FROM Exams WHERE ExamID = 1)
BEGIN
    SET IDENTITY_INSERT Exams ON;
    INSERT INTO Exams (ExamID, Title, Type, SkillFocus, Duration)
    VALUES (1, N'Đề IELTS Dummy Test 01', 'Mock Test', 'All', 180);
    SET IDENTITY_INSERT Exams OFF;
END
GO

-- 4. Verify standard questions are inserted
IF NOT EXISTS (SELECT * FROM Questions WHERE QuestionID = 1)
BEGIN
    SET IDENTITY_INSERT Questions ON;
    INSERT INTO Questions (QuestionID, Content, QuestionType, Skill, Difficulty)
    VALUES 
    (1, N'Trong bài IELTS Reading, bạn có bao nhiêu phút để làm bài?', 'Multiple_Choice', 'Reading', 'Easy'),
    (2, N'Đâu là một dạng bài phổ biến trong Listening?', 'Multiple_Choice', 'Listening', 'Easy'),
    (3, N'Task 1: The chart below shows... Write a report of 150 words.', 'Essay', 'Writing', 'Medium'),
    (4, N'Part 1: Do you work or are you a student?', 'Speaking', 'Speaking', 'Easy');
    SET IDENTITY_INSERT Questions OFF;
END
GO

-- 5. Verify standard answers are inserted
IF NOT EXISTS (SELECT * FROM Answers WHERE AnswerID = 1)
BEGIN
    SET IDENTITY_INSERT Answers ON;
    INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect)
    VALUES 
    (1, 1, N'30 phút', 0), 
    (2, 1, N'45 phút', 0), 
    (3, 1, N'60 phút', 1),
    (4, 1, N'120 phút', 0);
    SET IDENTITY_INSERT Answers OFF;
END
GO

IF NOT EXISTS (SELECT * FROM Answers WHERE AnswerID = 5)
BEGIN
    SET IDENTITY_INSERT Answers ON;
    INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect)
    VALUES 
    (5, 2, N'Matching Headings', 0), 
    (6, 2, N'Map Labeling', 1),
    (7, 2, N'Line Graph', 0), 
    (8, 2, N'Cue Card', 0);
    SET IDENTITY_INSERT Answers OFF;
END
GO

-- 6. Verify ExamQuestions mapping is present
IF NOT EXISTS (SELECT * FROM ExamQuestions WHERE ExamID = 1 AND QuestionID = 1)
BEGIN
    INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex)
    VALUES 
    (1, 1, 1), 
    (1, 2, 2), 
    (1, 3, 3), 
    (1, 4, 4);
END
GO

PRINT 'SQL Server Mock Data set up successfully!';
