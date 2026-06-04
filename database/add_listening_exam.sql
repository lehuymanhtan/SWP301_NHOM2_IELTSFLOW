-- ============================================================
-- TEMPLATE: THÊM ĐỀ LUYỆN NGHE (LISTENING PRACTICE)
-- Hướng dẫn:
--   1. Sửa các giá trị N'...' theo đề thi thực tế của bạn
--   2. Thêm/bớt câu hỏi bằng cách copy block -- Câu X
--   3. Chạy: sqlcmd -S localhost -U sa -P 123456 -d IELTSFlow -C -f i:65001 -i add_listening_exam.sql
-- ============================================================

USE IELTSFlow;
GO

-- ============================================================
-- BƯỚC 1: TẠO ĐỀ THI
--   Title  : Tên đề thi (hiển thị trên giao diện)
--   Duration: Thời gian làm bài (phút)
-- ============================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration)
VALUES (N'Luyện Nghe - Bài 2: Daily Conversations', 'Practice', 'Listening', 20);
DECLARE @ExamID INT = SCOPE_IDENTITY();
PRINT N'Đã tạo đề thi ExamID = ' + CAST(@ExamID AS VARCHAR);

-- ============================================================
-- BƯỚC 2 (TÙY CHỌN): THÊM FILE AUDIO
--   Nếu bạn có file audio (mp3/m4a), điền URL vào ResourceAudioURL
--   Nếu không có audio thì bỏ qua bước này và xóa phần ResourceID bên dưới
-- ============================================================
INSERT INTO QuestionResource (ResourceText, ResourceAudioURL, ResourceImageURL, Type)
VALUES (
    NULL,    -- Không cần transcript text, chỉ dùng audio
    N'https://drive.google.com/file/d/1PJtI3daT6wkfkC1dxlFz9sVO113UEs8L/view?usp=sharing',  -- << ĐỔI THÀNH URL FILE AUDIO CỦA BẠN
    NULL,
    'Listening Audio'
);
DECLARE @ResID INT = SCOPE_IDENTITY();
PRINT N'Đã tạo resource audio ResourceID = ' + CAST(@ResID AS VARCHAR);

-- ============================================================
-- BƯỚC 3: THÊM CÂU HỎI VÀ ĐÁP ÁN
--   - Mỗi câu gồm: INSERT Questions → INSERT Answers → INSERT ExamQuestions
--   - IsCorrect: 1 = đúng, 0 = sai  (chỉ 1 đáp án đúng mỗi câu)
--   - Nếu không có audio (bỏ bước 2), đổi (@ResID, N'...') thành (NULL, N'...')
--     trong INSERT Questions
-- ============================================================

-- ============================================================
-- Câu 1
-- ============================================================
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResID, N'What time does the woman usually wake up?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @Q1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@Q1, N'6:00 AM',  0),
(@Q1, N'6:30 AM',  1),  -- << ĐÁP ÁN ĐÚNG
(@Q1, N'7:00 AM',  0),
(@Q1, N'7:30 AM',  0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q1, 1);

-- ============================================================
-- Câu 2
-- ============================================================
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResID, N'Where does the man work?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @Q2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@Q2, N'A hospital',   0),
(@Q2, N'A school',     0),
(@Q2, N'A bank',       1),  -- << ĐÁP ÁN ĐÚNG
(@Q2, N'A restaurant', 0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q2, 2);

-- ============================================================
-- Câu 3
-- ============================================================
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResID, N'What does the woman order for lunch?', 'Multiple_Choice', 'Listening', 'Medium');
DECLARE @Q3 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@Q3, N'Sandwich',  1),  -- << ĐÁP ÁN ĐÚNG
(@Q3, N'Salad',     0),
(@Q3, N'Soup',      0),
(@Q3, N'Pizza',     0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q3, 3);

-- ============================================================
-- Câu 4
-- ============================================================
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResID, N'Why is the man late?', 'Multiple_Choice', 'Listening', 'Medium');
DECLARE @Q4 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@Q4, N'He overslept',         0),
(@Q4, N'There was heavy traffic', 1),  -- << ĐÁP ÁN ĐÚNG
(@Q4, N'His car broke down',   0),
(@Q4, N'He missed the bus',    0);
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q4, 4);

-- ============================================================
-- Câu 5
-- ============================================================
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty)
VALUES (@ResID, N'What will they do this weekend?', 'Multiple_Choice', 'Listening', 'Easy');
DECLARE @Q5 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect) VALUES
(@Q5, N'Go to the cinema',  0),
(@Q5, N'Visit their parents', 0),
(@Q5, N'Stay at home',      0),
(@Q5, N'Go to the park',    1);  -- << ĐÁP ÁN ĐÚNG
INSERT INTO ExamQuestions (ExamID, QuestionID, OrderIndex) VALUES (@ExamID, @Q5, 5);

-- ============================================================
-- KIỂM TRA KẾT QUẢ
-- ============================================================
PRINT N'';
PRINT N'=== XONG! Đề Listening đã được thêm thành công ===';
SELECT e.ExamID, e.Title, e.SkillFocus, COUNT(eq.QuestionID) AS [So_cau_hoi]
FROM Exams e
JOIN ExamQuestions eq ON e.ExamID = eq.ExamID
WHERE e.ExamID = @ExamID
GROUP BY e.ExamID, e.Title, e.SkillFocus;
