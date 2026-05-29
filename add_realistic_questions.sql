USE IELTSFlow;
GO

-- 1. Thêm một bài thi thực tế mới vào bảng Exams
SET IDENTITY_INSERT Exams ON;
INSERT INTO Exams (ExamID, Title, Type, SkillFocus, Duration)
VALUES (2, N'Đề IELTS Thực Chiến 01 (Cập nhật 2026)', 'Mock Test', 'All', 180);
SET IDENTITY_INSERT Exams OFF;
GO

-- 2. Thêm các câu hỏi thực tế vào bảng Questions
SET IDENTITY_INSERT Questions ON;
INSERT INTO Questions (QuestionID, Content, QuestionType, Skill, Difficulty)
VALUES 
-- Reading (Multiple Choice)
(5, N'Đọc đoạn văn sau và trả lời: "The global temperature has risen by 1.2 degrees Celsius since the pre-industrial era, leading to severe weather disruptions." What is the main cause of severe weather disruptions according to the text?', 'Multiple_Choice', 'Reading', 'Medium'),
-- Listening (Multiple Choice)
(6, N'Audio transcript: "Welcome to the central library. The fiction section is on the second floor, right next to the multimedia room." Where is the fiction section located?', 'Multiple_Choice', 'Listening', 'Easy'),
-- Writing (Essay)
(7, N'IELTS Writing Task 2: Some people believe that university education should be free for everyone. Others think that students should pay for their higher education. Discuss both these views and give your own opinion. (Write at least 250 words)', 'Essay', 'Writing', 'Hard'),
-- Speaking (Speaking)
(8, N'IELTS Speaking Part 2: Describe a memorable journey you have made. You should say: where you went, how you travelled, why you went on the journey, and explain why it is memorable to you.', 'Speaking', 'Speaking', 'Medium');
SET IDENTITY_INSERT Questions OFF;
GO

-- 3. Thêm các đáp án trắc nghiệm cho Reading & Listening
SET IDENTITY_INSERT Answers ON;
-- Đáp án cho câu 5 (Reading)
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (9, 5, N'The pre-industrial era', 0);
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (10, 5, N'The rise in global temperature by 1.2 degrees', 1);
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (11, 5, N'Severe weather patterns', 0);
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (12, 5, N'Industrial development', 0);

-- Đáp án cho câu 6 (Listening)
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (13, 6, N'On the first floor', 0);
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (14, 6, N'Next to the main entrance', 0);
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (15, 6, N'On the second floor, next to the multimedia room', 1);
INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect) VALUES (16, 6, N'Behind the multimedia room', 0);
SET IDENTITY_INSERT Answers OFF;
GO

-- 4. Map câu hỏi vào bài thi mới (ExamID = 2)
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex)
VALUES 
(2, 5, 1), 
(2, 6, 2), 
(2, 7, 3), 
(2, 8, 4);
GO

PRINT 'Đã thêm Đề IELTS Thực Chiến 01 thành công!';
