-- <Migration ID="dcd6e271-ec24-43c3-b441-06540f9cf730" />
GO

PRINT N'Creating [dbo].[Answer]'
GO
CREATE TABLE [dbo].[Answer]
(
[AnswerId] [int] NOT NULL IDENTITY(1, 1),
[QuestionId] [int] NOT NULL,
[Content] [nvarchar] (max) NOT NULL,
[UserId] [int] NOT NULL,
[Created] [datetime2] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Answer] on [dbo].[Answer]'
GO
ALTER TABLE [dbo].[Answer] ADD CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED  ([AnswerId])
GO
PRINT N'Creating [dbo].[usp_Answer_Delete]'
GO

CREATE PROC [dbo].[usp_Answer_Delete] (
	@AnswerId int
)
AS
BEGIN
	DELETE
	FROM dbo.Answer
	WHERE AnswerID = @AnswerId
END






GO
PRINT N'Creating [dbo].[usp_Answer_Exists]'
GO

CREATE PROC [dbo].[usp_Answer_Exists] (
	@AnswerId int
)
AS
BEGIN
	SELECT CASE WHEN EXISTS (SELECT AnswerId
							 FROM dbo.Answer 
	                         WHERE AnswerId = @AnswerId) 
        THEN CAST (1 AS BIT) 
        ELSE CAST (0 AS BIT) END AS Result

END



GO
PRINT N'Creating [dbo].[AspNetUsers]'
GO
CREATE TABLE [dbo].[AspNetUsers]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserName] [nvarchar] (256) NULL,
[NormalizedUserName] [nvarchar] (256) NULL,
[Email] [nvarchar] (256) NULL,
[NormalizedEmail] [nvarchar] (256) NULL,
[EmailConfirmed] [bit] NOT NULL,
[PasswordHash] [nvarchar] (max) NULL,
[SecurityStamp] [nvarchar] (max) NULL,
[ConcurrencyStamp] [nvarchar] (max) NULL,
[PhoneNumber] [nvarchar] (max) NULL,
[PhoneNumberConfirmed] [bit] NOT NULL,
[TwoFactorEnabled] [bit] NOT NULL,
[LockoutEnd] [datetimeoffset] NULL,
[LockoutEnabled] [bit] NOT NULL,
[AccessFailedCount] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_AspNetUsers] on [dbo].[AspNetUsers]'
GO
ALTER TABLE [dbo].[AspNetUsers] ADD CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[usp_Answer_Get_ByAnswerId]'
GO



CREATE PROC [dbo].[usp_Answer_Get_ByAnswerId] (
	@AnswerId int
)
AS
BEGIN
	SELECT a.AnswerId, a.QuestionId, a.Content, u.Username, a.Created  
	FROM dbo.Answer a
		LEFT JOIN dbo.AspNetUsers u ON a.UserId = u.id
	WHERE a.AnswerId = @AnswerId
END






GO
PRINT N'Creating [dbo].[usp_Answer_Get_ByQuestionId]'
GO


CREATE PROC [dbo].[usp_Answer_Get_ByQuestionId] (
	@QuestionId int
)
AS
BEGIN
	SELECT a.AnswerId, a.QuestionId, a.Content, u.Username, a.Created  
	FROM dbo.Answer a
		LEFT JOIN dbo.AspNetUsers u ON a.UserId = u.id
	WHERE a.QuestionId = @QuestionId
END





GO
PRINT N'Creating [dbo].[usp_Answer_Post]'
GO




CREATE PROC [dbo].[usp_Answer_Post] (
	@QuestionId int,
	@Content nvarchar(max),
	@UserId int,
	@Created datetime2
)
AS
BEGIN
	INSERT INTO dbo.Answer(QuestionId, Content, UserId, Created)
	SELECT @QuestionId, @Content, @UserId, @Created

	SELECT a.AnswerId, a.Content, u.UserName, a.Created
	FROM dbo.Answer a
		LEFT JOIN dbo.AspNetUsers u ON a.UserId = u.Id
	WHERE AnswerId = SCOPE_IDENTITY()
END






GO
PRINT N'Creating [dbo].[usp_Answer_Put]'
GO




CREATE PROC [dbo].[usp_Answer_Put] (
	@AnswerId int,
	@Content nvarchar(max)
)
AS
BEGIN
	UPDATE dbo.Answer
	SET Content = @Content
	WHERE AnswerId = @AnswerId

	SELECT a.AnswerId, a.QuestionId, a.Content, u.UserName, a.Created
	FROM dbo.Answer a
		LEFT JOIN AspNetUsers u ON a.UserId = u.Id
	WHERE AnswerId = @AnswerId
END






GO
PRINT N'Creating [dbo].[Question]'
GO
CREATE TABLE [dbo].[Question]
(
[QuestionId] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (100) NOT NULL,
[Content] [nvarchar] (max) NOT NULL,
[UserId] [int] NOT NULL,
[Created] [datetime2] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Question] on [dbo].[Question]'
GO
ALTER TABLE [dbo].[Question] ADD CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED  ([QuestionId])
GO
PRINT N'Creating [dbo].[usp_Question_Delete]'
GO

CREATE PROC [dbo].[usp_Question_Delete] (
	@QuestionId int
)
AS
BEGIN
	DELETE
	FROM dbo.Question
	WHERE QuestionID = @QuestionId
END






GO
PRINT N'Creating [dbo].[usp_Question_Exists]'
GO
CREATE PROC [dbo].[usp_Question_Exists] (
	@QuestionId int
)
AS
BEGIN
	SELECT CASE WHEN EXISTS (SELECT QuestionId
							 FROM dbo.Question 
	                         WHERE QuestionId = @QuestionId) 
        THEN CAST (1 AS BIT) 
        ELSE CAST (0 AS BIT) END AS Result

END


GO
PRINT N'Creating [dbo].[usp_Question_GetMany]'
GO


CREATE PROC [dbo].[usp_Question_GetMany] 
AS
BEGIN
	SELECT q.QuestionId, q.Title, q.Content, u.UserName, q.Created 
	FROM dbo.Question q 
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
END



GO
PRINT N'Creating [dbo].[usp_Question_GetMany_BySearch]'
GO



CREATE PROC [dbo].[usp_Question_GetMany_BySearch] (
	@Search nvarchar(100)
)
AS
BEGIN
	SELECT q.QuestionId, q.Title, q.Content, u.UserName, Created  
	FROM dbo.Question q 
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
	WHERE Title LIKE '%' + @Search + '%'
	
	UNION
	
	SELECT q.QuestionId, q.Title, q.Content, u.UserName, Created  
	FROM dbo.Question q
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
	WHERE Content LIKE '%' + @Search + '%'
END



GO
PRINT N'Creating [dbo].[usp_Question_GetMany_BySearch_WithPaging]'
GO





CREATE PROC [dbo].[usp_Question_GetMany_BySearch_WithPaging] (
	@Search nvarchar(100),
	@PageNumber int,
	@PageSize int
)
AS
BEGIN
	SELECT QuestionId, Title, Content, UserName, Created  
	FROM
		(SELECT q.QuestionId, q.Title, q.Content, u.UserName, Created  
		FROM dbo.Question q 
			LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
		WHERE Title LIKE '%' + @Search + '%'
	
		UNION
	
		SELECT q.QuestionId, q.Title, q.Content, u.UserName, Created  
		FROM dbo.Question q
			LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
		WHERE Content LIKE '%' + @Search + '%') Sub
	ORDER BY QuestionId
	OFFSET @PageSize * (@PageNumber - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY
END





GO
PRINT N'Creating [dbo].[QuestionTag]'
GO
CREATE TABLE [dbo].[QuestionTag]
(
[QuestionTagId] [int] NOT NULL IDENTITY(1, 1),
[QuestionId] [int] NOT NULL,
[Tag] [nvarchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_QuestionTag] on [dbo].[QuestionTag]'
GO
ALTER TABLE [dbo].[QuestionTag] ADD CONSTRAINT [PK_QuestionTag] PRIMARY KEY CLUSTERED  ([QuestionTagId])
GO
PRINT N'Creating [dbo].[usp_Question_GetMany_ByTag]'
GO




CREATE PROC [dbo].[usp_Question_GetMany_ByTag] (
	@Tag nvarchar(50)
)
AS
BEGIN
	SELECT q.QuestionId, q.Title, q.Content, u.UserName, Created  
	FROM dbo.Question q 
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
	WHERE EXISTS (SELECT * FROM dbo.QuestionTag t WHERE t.Tag = @Tag AND q.QuestionId = t.QuestionId) 
	
END




GO
PRINT N'Creating [dbo].[usp_Question_GetMany_ByTag_WithPaging]'
GO





CREATE PROC [dbo].[usp_Question_GetMany_ByTag_WithPaging] (
	@Tag nvarchar(50),
	@PageNumber int,
	@PageSize int
)
AS
BEGIN
	SELECT q.QuestionId, q.Title, q.Content, u.UserName, Created  
	FROM dbo.Question q 
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
	WHERE EXISTS (SELECT * FROM dbo.QuestionTag t WHERE t.Tag = @Tag AND q.QuestionId = t.QuestionId) 
	ORDER BY QuestionId
	OFFSET @PageSize * (@PageNumber - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY
END





GO
PRINT N'Creating [dbo].[usp_Question_GetMany_WithPaging]'
GO



CREATE PROC [dbo].[usp_Question_GetMany_WithPaging] 
	@PageNumber int,
	@PageSize int
AS
BEGIN
	SELECT q.QuestionId, q.Title, q.Content, u.UserName, q.Created 
	FROM dbo.Question q 
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.Id
	ORDER BY q.QuestionId
	OFFSET @PageSize * (@PageNumber - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY
END




GO
PRINT N'Creating [dbo].[usp_Question_GetSingle_ByQuestionId]'
GO

CREATE PROC [dbo].[usp_Question_GetSingle_ByQuestionId] (
	@QuestionId int
)
AS
BEGIN
	SELECT q.QuestionId, q.Title, q.Content, u.Username, q.Created  
	FROM dbo.Question q
		LEFT JOIN dbo.AspNetUsers u ON q.UserId = u.id
	WHERE QuestionId = @QuestionId
END




GO
PRINT N'Creating [dbo].[usp_Question_Post]'
GO


CREATE PROC [dbo].[usp_Question_Post] (
	@Title nvarchar(100),
	@Content nvarchar(max),
	@UserId int,
	@Created datetime2 
)
AS
BEGIN
	INSERT INTO dbo.Question(Title, Content, UserId, Created)
	VALUES(@Title, @Content, @UserId, @Created)

	SELECT SCOPE_IDENTITY() AS QuestionId
END




GO
PRINT N'Creating [dbo].[usp_Question_Put]'
GO



CREATE PROC [dbo].[usp_Question_Put] (
	@QuestionId int,
	@Title nvarchar(100),
	@Content nvarchar(max)
)
AS
BEGIN
	UPDATE dbo.Question
	SET Title = @Title, Content = @Content
	WHERE QuestionID = @QuestionId
END





GO
PRINT N'Creating [dbo].[usp_QuestionTag_Delete_ByQuestionId]'
GO
CREATE PROC [dbo].[usp_QuestionTag_Delete_ByQuestionId] (
	@QuestionId int
)
AS
BEGIN
	DELETE
	FROM dbo.QuestionTag
	WHERE QuestionID = @QuestionId
END





GO
PRINT N'Creating [dbo].[usp_QuestionTag_Get_ByQuestionId]'
GO


CREATE PROC [dbo].[usp_QuestionTag_Get_ByQuestionId] (
	@QuestionId int
)
AS
BEGIN
	SELECT Tag  
	FROM dbo.QuestionTag
	WHERE QuestionId = @QuestionId
END




GO
PRINT N'Creating [dbo].[usp_QuestionTag_Post]'
GO


CREATE PROC [dbo].[usp_QuestionTag_Post] (
	@QuestionId int,
	@Tag nvarchar(50)
)
AS
BEGIN
	INSERT INTO dbo.QuestionTag(QuestionId, Tag)
	VALUES(@QuestionId, @Tag)
END


GO
PRINT N'Creating [dbo].[AspNetRoles]'
GO
CREATE TABLE [dbo].[AspNetRoles]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (256) NULL,
[NormalizedName] [nvarchar] (256) NULL,
[ConcurrencyStamp] [nvarchar] (max) NULL
)
GO
PRINT N'Creating primary key [PK_AspNetRoles] on [dbo].[AspNetRoles]'
GO
ALTER TABLE [dbo].[AspNetRoles] ADD CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[AspNetRoleClaims]'
GO
CREATE TABLE [dbo].[AspNetRoleClaims]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[ClaimType] [nvarchar] (max) NULL,
[ClaimValue] [nvarchar] (max) NULL
)
GO
PRINT N'Creating primary key [PK_AspNetRoleClaims] on [dbo].[AspNetRoleClaims]'
GO
ALTER TABLE [dbo].[AspNetRoleClaims] ADD CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[AspNetUserClaims]'
GO
CREATE TABLE [dbo].[AspNetUserClaims]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ClaimType] [nvarchar] (max) NULL,
[ClaimValue] [nvarchar] (max) NULL
)
GO
PRINT N'Creating primary key [PK_AspNetUserClaims] on [dbo].[AspNetUserClaims]'
GO
ALTER TABLE [dbo].[AspNetUserClaims] ADD CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[AspNetUserLogins]'
GO
CREATE TABLE [dbo].[AspNetUserLogins]
(
[LoginProvider] [nvarchar] (128) NOT NULL,
[ProviderKey] [nvarchar] (128) NOT NULL,
[ProviderDisplayName] [nvarchar] (max) NULL,
[UserId] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_AspNetUserLogins] on [dbo].[AspNetUserLogins]'
GO
ALTER TABLE [dbo].[AspNetUserLogins] ADD CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED  ([LoginProvider], [ProviderKey])
GO
PRINT N'Creating [dbo].[AspNetUserRoles]'
GO
CREATE TABLE [dbo].[AspNetUserRoles]
(
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_AspNetUserRoles] on [dbo].[AspNetUserRoles]'
GO
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED  ([UserId], [RoleId])
GO
PRINT N'Creating [dbo].[AspNetUserTokens]'
GO
CREATE TABLE [dbo].[AspNetUserTokens]
(
[UserId] [int] NOT NULL,
[LoginProvider] [nvarchar] (128) NOT NULL,
[Name] [nvarchar] (128) NOT NULL,
[Value] [nvarchar] (max) NULL
)
GO
PRINT N'Creating primary key [PK_AspNetUserTokens] on [dbo].[AspNetUserTokens]'
GO
ALTER TABLE [dbo].[AspNetUserTokens] ADD CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED  ([UserId], [LoginProvider], [Name])
GO
PRINT N'Adding foreign keys to [dbo].[Answer]'
GO
ALTER TABLE [dbo].[Answer] ADD CONSTRAINT [FK_Answer_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Question] ([QuestionId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Answer] ADD CONSTRAINT [FK_Answer_AspNetUsers] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id])
GO
PRINT N'Adding foreign keys to [dbo].[AspNetRoleClaims]'
GO
ALTER TABLE [dbo].[AspNetRoleClaims] ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[AspNetUserRoles]'
GO
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[AspNetUserClaims]'
GO
ALTER TABLE [dbo].[AspNetUserClaims] ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[AspNetUserLogins]'
GO
ALTER TABLE [dbo].[AspNetUserLogins] ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[AspNetUserTokens]'
GO
ALTER TABLE [dbo].[AspNetUserTokens] ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[Question]'
GO
ALTER TABLE [dbo].[Question] ADD CONSTRAINT [FK_Question_AspNetUsers] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
PRINT N'Adding foreign keys to [dbo].[QuestionTag]'
GO
ALTER TABLE [dbo].[QuestionTag] ADD CONSTRAINT [FK_QuestionTag_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Question] ([QuestionId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
