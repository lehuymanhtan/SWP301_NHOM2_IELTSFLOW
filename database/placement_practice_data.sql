-- ============================================================
-- DỮ LIỆU MẪU: PLACEMENT TEST + PRACTICE
-- Chạy trong SSMS với database IELTSFlow
-- ============================================================

USE IELTSFlow;
GO

-- ============================================================
-- PLACEMENT TEST (Thi đầu vào) — 8 câu, All skills
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'Bài Kiểm Tra Đầu Vào IELTS', 'Placement Test', 'All', 45);
DECLARE @PT_ExamID INT = SCOPE_IDENTITY();

-- 2 câu Listening
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Đâu là một dạng bài phổ biến trong IELTS Listening?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @PT_L1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PT_L1, N'Map Labeling',     1),
(@PT_L1, N'Matching Headings',0),
(@PT_L1, N'Line Graph',       0),
(@PT_L1, N'Cue Card',         0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_L1, 1);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'IELTS Listening có bao nhiêu phần (sections)?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @PT_L2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PT_L2, N'2', 0), (@PT_L2, N'3', 0), (@PT_L2, N'4', 1), (@PT_L2, N'5', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_L2, 2);

-- 2 câu Reading
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Trong bài IELTS Reading, bạn có bao nhiêu phút để làm bài?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @PT_R1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PT_R1, N'30 phút', 0), (@PT_R1, N'45 phút', 0), (@PT_R1, N'60 phút', 1), (@PT_R1, N'90 phút', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_R1, 3);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'IELTS Academic Reading có bao nhiêu đoạn văn (passages)?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @PT_R2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PT_R2, N'1', 0), (@PT_R2, N'2', 0), (@PT_R2, N'3', 1), (@PT_R2, N'4', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_R2, 4);

-- 2 câu Writing
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Trong IELTS Writing Task 2, bạn cần viết tối thiểu bao nhiêu từ?', 'Multiple_Choice', 'Writing', 'Easy');
DECLARE @PT_W1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PT_W1, N'150 từ', 0), (@PT_W1, N'200 từ', 0), (@PT_W1, N'250 từ', 1), (@PT_W1, N'300 từ', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_W1, 5);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'IELTS Writing Task 1 yêu cầu bạn viết dạng nào sau đây?', 'Multiple_Choice', 'Writing', 'Easy');
DECLARE @PT_W2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PT_W2, N'Thư cá nhân',             0),
(@PT_W2, N'Mô tả biểu đồ/đồ thị',   1),
(@PT_W2, N'Bài luận tranh luận',     0),
(@PT_W2, N'Báo cáo nghiên cứu',      0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_W2, 6);

-- 2 câu Speaking
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'IELTS Speaking Part 1: Talk about your hometown or the place where you live. (Speak for 1-2 minutes)', 'Speaking', 'Speaking', 'Easy');
DECLARE @PT_S1 INT = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_S1, 7);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'IELTS Speaking Part 2: Describe a book that you have read recently. You should say: what the book is, who wrote it, what it is about, and explain why you liked or disliked it. (Speak for 1-2 minutes)', 'Speaking', 'Speaking', 'Medium');
DECLARE @PT_S2 INT = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PT_ExamID, @PT_S2, 8);

PRINT N'✓ Placement Test ExamID=' + CAST(@PT_ExamID AS VARCHAR) + ' (8 câu)';
GO

-- ============================================================
-- PRACTICE - LISTENING (5 câu)
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'Luyện Nghe - Bài 1: Cuộc Sống Hàng Ngày', 'Practice', 'Listening', 20);
DECLARE @PR_L_ExamID INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Từ "commute" có nghĩa là gì?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @PR_L1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_L1, N'Di chuyển hàng ngày đến nơi làm việc', 1),
(@PR_L1, N'Ở nhà làm việc', 0),
(@PR_L1, N'Đi du lịch nước ngoài', 0),
(@PR_L1, N'Làm thêm giờ', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_L_ExamID, @PR_L1, 1);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Từ "punctual" có nghĩa là gì?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @PR_L2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_L2, N'Đúng giờ', 1), (@PR_L2, N'Trễ giờ', 0), (@PR_L2, N'Bận rộn', 0), (@PR_L2, N'Chăm chỉ', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_L_ExamID, @PR_L2, 2);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Từ "hectic" thường dùng để mô tả điều gì?', 'Multiple_Choice', 'Listening', 'Medium');
DECLARE @PR_L3 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_L3, N'Lịch trình bận rộn, hối hả', 1),
(@PR_L3, N'Kỳ nghỉ dài ngày', 0),
(@PR_L3, N'Không khí trong lành', 0),
(@PR_L3, N'Cuộc sống yên tĩnh', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_L_ExamID, @PR_L3, 3);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Từ nào là đồng nghĩa với "exhausted"?', 'Multiple_Choice', 'Listening', 'Medium');
DECLARE @PR_L4 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_L4, N'Worn out', 1), (@PR_L4, N'Energetic', 0), (@PR_L4, N'Motivated', 0), (@PR_L4, N'Refreshed', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_L_ExamID, @PR_L4, 4);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (N'Từ "leisure" có nghĩa là gì trong ngữ cảnh hàng ngày?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @PR_L5 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_L5, N'Thời gian rảnh rỗi', 1), (@PR_L5, N'Công việc', 0), (@PR_L5, N'Trường học', 0), (@PR_L5, N'Tiền bạc', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_L_ExamID, @PR_L5, 5);

PRINT N'✓ Practice Listening ExamID=' + CAST(@PR_L_ExamID AS VARCHAR) + ' (5 câu)';
GO

-- ============================================================
-- PRACTICE - READING (5 câu)
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'Luyện Đọc - Bài 1: Môi Trường', 'Practice', 'Reading', 20);
DECLARE @PR_R_ExamID INT = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceText, ResourceAudioURL, ResourceImageURL, Type)
VALUES (N'Climate change is one of the most pressing issues of our time. Rising global temperatures, caused primarily by greenhouse gas emissions from human activities, are leading to more frequent and severe weather events. These include heatwaves, floods, droughts, and powerful storms. Scientists agree that immediate action is needed to reduce carbon emissions and transition to renewable energy sources such as solar, wind, and hydroelectric power to prevent the worst impacts of climate change.', NULL, NULL, 'Reading Passage');
DECLARE @PR_R_ResID INT = SCOPE_IDENTITY();

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@PR_R_ResID, N'What is identified as the primary cause of rising global temperatures?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @PR_R1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_R1, N'Natural volcanic eruptions',         0),
(@PR_R1, N'Greenhouse gas emissions from humans', 1),
(@PR_R1, N'Changes in ocean currents',           0),
(@PR_R1, N'Deforestation alone',                 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_R_ExamID, @PR_R1, 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@PR_R_ResID, N'Which of the following is NOT mentioned as an effect of climate change?', 'Multiple_Choice', 'Reading', 'Medium');
DECLARE @PR_R2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_R2, N'Heatwaves',       0),
(@PR_R2, N'Floods',          0),
(@PR_R2, N'Earthquakes',     1),
(@PR_R2, N'Powerful storms', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_R_ExamID, @PR_R2, 2);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@PR_R_ResID, N'What does the passage suggest as a solution to climate change?', 'Multiple_Choice', 'Reading', 'Easy');
DECLARE @PR_R3 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_R3, N'Building more factories',              0),
(@PR_R3, N'Transitioning to renewable energy',   1),
(@PR_R3, N'Increasing fossil fuel use',          0),
(@PR_R3, N'Reducing population growth',          0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_R_ExamID, @PR_R3, 3);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@PR_R_ResID, N'The word "pressing" in the first sentence is closest in meaning to:', 'Multiple_Choice', 'Reading', 'Medium');
DECLARE @PR_R4 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_R4, N'Minor',   0), (@PR_R4, N'Urgent',  1), (@PR_R4, N'Distant', 0), (@PR_R4, N'Simple', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_R_ExamID, @PR_R4, 4);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@PR_R_ResID, N'Which renewable energy source is NOT mentioned in the passage?', 'Multiple_Choice', 'Reading', 'Hard');
DECLARE @PR_R5 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@PR_R5, N'Solar',       0),
(@PR_R5, N'Wind',        0),
(@PR_R5, N'Geothermal',  1),
(@PR_R5, N'Hydroelectric',0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_R_ExamID, @PR_R5, 5);

PRINT N'✓ Practice Reading ExamID=' + CAST(@PR_R_ExamID AS VARCHAR) + ' (5 câu)';
GO

-- ============================================================
-- PRACTICE - WRITING (1 câu Essay)
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'Luyện Viết - Bài 1: Essay Task 2', 'Practice', 'Writing', 40);
DECLARE @PR_W_ExamID INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (
N'Some people believe that technology has made our lives more complicated. Others argue that it has made life simpler and easier. Discuss both views and give your own opinion. (Write at least 250 words)',
'Essay', 'Writing', 'Medium');
DECLARE @PR_W1 INT = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_W_ExamID, @PR_W1, 1);

PRINT N'✓ Practice Writing ExamID=' + CAST(@PR_W_ExamID AS VARCHAR) + ' (1 câu Essay)';
GO

-- ============================================================
-- PRACTICE - SPEAKING (1 câu Speaking)
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'Luyện Nói - Bài 1: Part 2 Cue Card', 'Practice', 'Speaking', 15);
DECLARE @PR_S_ExamID INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty)
VALUES (
N'Describe a place you have visited that you found very interesting. You should say: where the place is, when you went there, what you did there, and explain why you found it interesting. (Speak for 1-2 minutes)',
'Speaking', 'Speaking', 'Medium');
DECLARE @PR_S1 INT = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@PR_S_ExamID, @PR_S1, 1);

PRINT N'✓ Practice Speaking ExamID=' + CAST(@PR_S_ExamID AS VARCHAR) + ' (1 câu Speaking)';
GO

-- ============================================================
-- KIỂM TRA TỔNG KẾT
-- ============================================================
SELECT e.ExamID, e.Title, e.Type, e.SkillFocus,
       COUNT(eq.QuestionID) AS [So cau hoi]
FROM Exams e
LEFT JOIN ExamQuestions eq ON e.ExamID = eq.ExamID
GROUP BY e.ExamID, e.Title, e.Type, e.SkillFocus
ORDER BY e.Type, e.ExamID;
