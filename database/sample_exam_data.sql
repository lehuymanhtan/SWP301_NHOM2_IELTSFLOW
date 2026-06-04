-- ============================================================
-- IELTS MOCK TEST - DỮ LIỆU MẪU ĐỂ TEST
-- Chạy file này trong SSMS với database IELTSFlow
-- ============================================================

USE IELTSFlow;
GO

-- ============================================================
-- XÓA DỮ LIỆU LỖI TỪ LẦN CHẠY TRƯỚC (nếu có)
-- ============================================================
DELETE FROM ExamQuestions WHERE ExamID IN (SELECT ExamID FROM Exams WHERE Title = N'IELTS Mock Test 1 - Reading');
DELETE FROM Answers WHERE QuestionID IN (SELECT QuestionID FROM Questions WHERE ResourceID IN (SELECT ResourceID FROM QuestionResource WHERE Type = 'Reading Passage'));
DELETE FROM Questions WHERE ResourceID IN (SELECT ResourceID FROM QuestionResource WHERE Type = 'Reading Passage');
DELETE FROM QuestionResource WHERE Type = 'Reading Passage';
DELETE FROM Exams WHERE Title = N'IELTS Mock Test 1 - Reading';
PRINT N'Đã xóa dữ liệu cũ (nếu có).';
GO

-- ============================================================
-- BƯỚC 1: Thêm đề thi
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'IELTS Mock Test 1 - Reading', 'Mock Test', 'Reading', 60);

DECLARE @ExamID INT = SCOPE_IDENTITY();
PRINT N'Đã tạo đề thi ExamID = ' + CAST(@ExamID AS VARCHAR);

-- ============================================================
-- BƯỚC 2: Thêm bài đọc (QuestionResource)
-- Type = 'Reading Passage' là loại bài đọc
-- ============================================================
INSERT INTO QuestionResource (ResourceText, ResourceAudioURL, ResourceImageURL, Type)
VALUES (
N'The Amazon rainforest, often referred to as the "lungs of the Earth," covers over 5.5 million square kilometres across nine countries in South America. It is home to an estimated 10% of all species on Earth, including more than 40,000 plant species, 1,300 bird species, and 3,000 types of fish. The forest plays a critical role in regulating the global climate by absorbing vast amounts of carbon dioxide and releasing oxygen. However, deforestation driven by agriculture, logging, and urban expansion has led to the loss of approximately 17% of the Amazon over the past 50 years. Scientists warn that if deforestation continues at the current rate, the Amazon could reach a "tipping point" at which it can no longer sustain itself as a rainforest and would transition into a savanna-like ecosystem, with catastrophic consequences for global biodiversity and climate stability.',
NULL,
NULL,
'Reading Passage'
);

DECLARE @ResourceID INT = SCOPE_IDENTITY();
PRINT N'Đã tạo bài đọc ResourceID = ' + CAST(@ResourceID AS VARCHAR);

-- ============================================================
-- BƯỚC 3: Thêm câu hỏi và đáp án
-- ============================================================

-- Câu 1
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'What percentage of all Earth''s species does the Amazon rainforest contain?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @Q1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q1,N'5%',0), (@Q1,N'10%',1), (@Q1,N'17%',0), (@Q1,N'25%',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q1, 1);

-- Câu 2
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'How much of the Amazon has been lost to deforestation in the past 50 years?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @Q2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q2,N'10%',0), (@Q2,N'17%',1), (@Q2,N'25%',0), (@Q2,N'30%',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q2, 2);

-- Câu 3
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'What does the Amazon rainforest primarily absorb from the atmosphere?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @Q3 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q3,N'Oxygen',0), (@Q3,N'Carbon dioxide',1), (@Q3,N'Nitrogen',0), (@Q3,N'Methane',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q3, 3);

-- Câu 4
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'According to the passage, what is the Amazon sometimes called?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @Q4 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q4,N'The heart of the Earth',0), (@Q4,N'The lungs of the Earth',1), (@Q4,N'The brain of the Earth',0), (@Q4,N'The green ocean',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q4, 4);

-- Câu 5
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'Which of the following is NOT listed as a cause of deforestation in the Amazon?', 'Multiple_Choice', 'Reading', 'Medium');
DECLARE @Q5 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q5,N'Agriculture',0), (@Q5,N'Logging',0), (@Q5,N'Urbanisation',0), (@Q5,N'Flooding',1);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q5, 5);

-- Câu 6
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'What would happen if the Amazon reaches its "tipping point"?', 'Multiple_Choice', 'Reading', 'Medium');
DECLARE @Q6 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q6,N'It would become a desert',0), (@Q6,N'It would transition into a savanna-like ecosystem',1), (@Q6,N'It would recover and grow larger',0), (@Q6,N'It would flood from increased rainfall',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q6, 6);

-- Câu 7
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'How many plant species are found in the Amazon rainforest?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @Q7 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q7,N'More than 10,000',0), (@Q7,N'More than 40,000',1), (@Q7,N'More than 60,000',0), (@Q7,N'More than 80,000',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q7, 7);

-- Câu 8
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'How many types of fish live in the Amazon region?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @Q8 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q8,N'1,300',0), (@Q8,N'2,500',0), (@Q8,N'3,000',1), (@Q8,N'5,000',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q8, 8);

-- Câu 9
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'How many countries does the Amazon rainforest span?', 'Multiple_Choice', 'Reading', 'Medium');
DECLARE @Q9 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q9,N'Five',0), (@Q9,N'Seven',0), (@Q9,N'Nine',1), (@Q9,N'Twelve',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q9, 9);

-- Câu 10
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResourceID, N'The word "catastrophic" in the last sentence is closest in meaning to:', 'Multiple_Choice', 'Reading', 'Hard');
DECLARE @Q10 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES (@Q10,N'Minor',0), (@Q10,N'Disastrous',1), (@Q10,N'Gradual',0), (@Q10,N'Beneficial',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q10, 10);

-- ============================================================
-- KIỂM TRA KẾT QUẢ
-- ============================================================
PRINT N'';
PRINT N'=== XONG! Đã insert thành công ===';
SELECT e.ExamID, e.Title, COUNT(eq.QuestionID) AS [So cau hoi]
FROM Exams e
JOIN ExamQuestions eq ON e.ExamID = eq.ExamID
WHERE e.Title = N'IELTS Mock Test 1 - Reading'
GROUP BY e.ExamID, e.Title;
