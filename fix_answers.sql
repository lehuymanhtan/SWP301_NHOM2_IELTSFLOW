USE IELTSFlow;
GO

SET IDENTITY_INSERT Answers ON;
IF NOT EXISTS (SELECT * FROM Answers WHERE AnswerID = 1)
BEGIN
    INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect)
    VALUES 
    (1, 1, N'30 phút', 0), 
    (2, 1, N'45 phút', 0), 
    (3, 1, N'60 phút', 1),
    (4, 1, N'120 phút', 0);
END

IF NOT EXISTS (SELECT * FROM Answers WHERE AnswerID = 5)
BEGIN
    INSERT INTO Answers (AnswerID, QuestionID, Content, IsCorrect)
    VALUES 
    (5, 2, N'Matching Headings', 0), 
    (6, 2, N'Map Labeling', 1),
    (7, 2, N'Line Graph', 0), 
    (8, 2, N'Cue Card', 0);
END
SET IDENTITY_INSERT Answers OFF;
GO
