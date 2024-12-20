CREATE DATABASE SOCIALMEDIA1_DB;

USE SOCIALMEDIA1_DB;

CREATE TABLE [User] (
	UserId INT PRIMARY KEY IDENTITY(1,1),
	Username VARCHAR(30) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	[Name] VARCHAR (30) NOT NULL,
	Bio TEXT,
	ProfilePicture VARCHAR(50),
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE [User]
ALTER COLUMN [Password] VARBINARY(100) NOT NULL;


CREATE TABLE [Post] (
	PostId INT PRIMARY KEY IDENTITY(1,1),
	UserId INT,
	Caption TEXT,
	MediaType VARCHAR(20),
	MediaURL VARCHAR(50),
	LikesCount INT DEFAULT 0 NOT NULL,
	CommentsCount INT DEFAULT 0 NOT NULL,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (UserId) REFERENCES [User] (UserId)
);

CREATE TABLE [Like] (
	LikeId INT PRIMARY KEY IDENTITY(1,1),
	PostId INT,
	UserId INT,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (PostId) REFERENCES [Post] (PostId),
	FOREIGN KEY (UserId) REFERENCES [User] (UserId)
);

CREATE TABLE Comment (
	CommentId INT PRIMARY KEY IDENTITY(1,1),
	PostId INT,
	UserId INT,
	Content TEXT,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (UserId) REFERENCES [User] (UserId),
	FOREIGN KEY (PostId) REFERENCES [Post] (PostId)
);

CREATE TABLE [Message] (
	MessageId INT PRIMARY KEY IDENTITY(1,1),
	SenderId INT NOT NULL,
	RecieverId INT NOT NULL,
	Content TEXT,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (SenderId) REFERENCES [User] (UserId),
	FOREIGN KEY (RecieverId) REFERENCES [User] (UserId)
);

CREATE TABLE Follow (
	FollowId INT PRIMARY KEY IDENTITY(1,1),
	FollowerId INT,
	FollowingId INT,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (FollowerId) REFERENCES [User] (UserId),
	FOREIGN KEY (FollowingId) REFERENCES [User] (UserId)
);

CREATE TABLE [Notification] (
	NotificationId INT PRIMARY KEY IDENTITY(1,1),
	UserId INT,
	NotificationType VARCHAR(50),
	SenderId INT,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (UserId) REFERENCES [User] (UserId),
	FOREIGN KEY (SenderId) REFERENCES [User] (UserId)
);

CREATE TABLE [Group] (
	GroupId INT PRIMARY KEY IDENTITY(1,1),
	AdminId INT NOT NULL,
	GroupName VARCHAR(30) NOT NULL,
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (AdminId) REFERENCES [User] (UserId)
);

CREATE TABLE [GroupMembers] (
	Id INT PRIMARY KEY IDENTITY(1,1),
	GroupId INT,
	UserId INT,
	JoinedAt DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (GroupId) REFERENCES [Group] (GroupId),
	FOREIGN KEY (UserId) REFERENCES [User] (UserId)
);

CREATE TABLE [Media] (
	MediaId INT PRIMARY KEY IDENTITY(1,1),
	PostId INT,
	UserId INT,
	MediaType VARCHAR(20),
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	MediaURL VARCHAR(50),
	FOREIGN KEY (PostId) REFERENCES [Post] (PostId),
	FOREIGN KEY (UserId) REFERENCES [User] (UserId)
);
EXEC SP_RENAME '[Media].UserId', 'SavedBy', 'COLUMN'

CREATE TABLE AuditLogs (
	LogId INT PRIMARY KEY IDENTITY(1,1),
	UserId INT,
	ActionPerformed VARCHAR(30),
	ActionTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	Details VARCHAR(MAX)
	FOREIGN KEY (UserID) REFERENCES [User] (UserId)
);
ALTER TABLE AuditLogs
ADD CONSTRAINT FK_AuditLogs_User FOREIGN KEY (UserId)
REFERENCES [User](UserId)

CREATE TABLE UserBackup (
	UserBackupId INT PRIMARY KEY IDENTITY(1,1),
	UserId INT,
	Username VARCHAR(30) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	[Name] VARCHAR (30) NOT NULL,
	Bio TEXT,
	ProfilePicture VARCHAR(50),
	DateAndTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (UserId) REFERENCES [User] (UserId)
);

GO
--SP to add new user and store password using hashing algorithm
CREATE OR ALTER PROCEDURE proc_ToAddNewUser
@Username VARCHAR(30), @Email VARCHAR(50), @Password VARCHAR(100), @Name VARCHAR(30), @Bio TEXT, @ProfilePicture VARCHAR(50)
AS
BEGIN
	DECLARE @HashedPassword VARBINARY(64);
    SET @HashedPassword = HASHBYTES('SHA2_256', @Password);

	INSERT INTO [User] (Username, Email, [Password], [Name], Bio, ProfilePicture)
	VALUES (@Username, @Email, CONVERT(VARCHAR(64), @HashedPassword, 1), @Name, @Bio, @ProfilePicture)
END
GO
EXEC proc_ToAddNewUser @Username = 'Harry_1', @Email =  'Harry@gmail.com', @Password =  'harrY123',  @Name = 'Harry Brar', @Bio = 'Student', @ProfilePicture = 'https://www.pinterest.com/pin/606297168576770597/'
EXEC proc_ToAddNewUser @Username = 'Shinchan99', @Email =  'Shinchan@gmail.com', @Password =  'chan890',  @Name = 'Shinchan', @Bio = 'Student', @ProfilePicture = 'https://www.pinterest.com/pin/825706912925998162/'
EXEC proc_ToAddNewUser @Username = 'Micky00',  @Email = 'mickyM@gmail.com', @Password = 'micky#M12', @Name = 'Micky Mouse', @Bio = 'Mickey the rat', @ProfilePicture = 'https://pixabay.com/illustrations/mickey-mouse-disneyland-disney-7230486/'
EXEC proc_ToAddNewUser @Username = 'Sachin11', @Email =  'Sachin@gmail.com', @Password =  'Sachin123',  @Name = 'Sachin', @Bio = 'Player', @ProfilePicture = 'https://www.pinterest.com/pin/825706912925998162/'
EXEC proc_ToAddNewUser @Username = 'Gian', @Email =  'giaN101@gmail.com', @Password =  'gian$1',  @Name = 'Gian', @Bio = 'Singer', @ProfilePicture = 'https://in.pinterest.com/pin/319122323614003681/'
EXEC proc_ToAddNewUser @Username = 'Bheem', @Email =  'bheeM@gmail.com', @Password =  'Chbheem129#',  @Name = 'Choota Bheem', @Bio = 'Saviour', @ProfilePicture = 'https://www.pinterest.com/pin/50384089572499151/'
EXEC proc_ToAddNewUser @Username = 'Naruto', @Email =  'naruto@gmail.com', @Password =  'naru#09',  @Name = 'Naruto Uzumaki', @Bio = 'Fighter', @ProfilePicture = 'https://naruto.neoseeker.com/wiki/Naruto_Uzumaki'
GO

--SP for user login
CREATE OR ALTER PROCEDURE proc_ForUserLogin
	@Username VARCHAR(30), @Password VARCHAR(100)
AS
BEGIN
	DECLARE @StoredPasswordHash VARBINARY(64)
	DECLARE @ProvidedPasswordHash VARBINARY(64)

	SET @ProvidedPasswordHash = HASHBYTES('SHA_256', @Password)

	SELECT @StoredPasswordHash = CONVERT(VARBINARY(64), [Password], 1)
	FROM [User]
	WHERE Username = @Username

	IF @ProvidedPasswordHash =  @StoredPasswordHash
		BEGIN 
			PRINT 'Login Successful';
		END
	ELSE 
		BEGIN
			PRINT 'Invalid Credentials'
		END
END
GO
EXEC proc_ForUserLogin @Username = 'Naruto', @Password = 'naru#09'
select * from [User]
GO

--SP to add new post
CREATE  PROCEDURE proc_ToAddNewPost
@UserId INT, @Caption TEXT, @MediaType VARCHAR(20), @MediaURL VARCHAR(50)
AS
BEGIN
	INSERT INTO [Post] (UserId, Caption, MediaType, MediaURL)
	VALUES (@UserId, @Caption, @MediaType, @MediaURL)
END
GO
EXEC proc_ToAddNewPost @UserId = 1, @Caption = 'My First Post..', @MediaType = 'Image', @MediaURL = 'https://www.pinterest.com/pin/606297168576770597/'
GO

--SP to add like on a post
CREATE OR ALTER PROCEDURE proc_ToAddLikeOnPost
@PostId INT, @UserId INT
AS
BEGIN
	BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Like] (PostId, UserId)
			VALUES (@PostId, @UserId)

			UPDATE Post
			SET LikesCount = LikesCount + 1
			WHERE PostId = @PostId;

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			THROW;
		END CATCH
END
GO
EXEC proc_ToAddLikeOnPost @PostId = 1, @UserId = 1
EXEC proc_ToAddLikeOnPost @PostId = 1, @UserId = 2
EXEC proc_ToAddLikeOnPost @PostId = 1, @UserId = 3

GO
--SP to add comment on a post
CREATE PROCEDURE porc_ToAddCommentOnPost
@PostId INT, @UserID INT, @Content TEXT
AS
BEGIN
	BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO Comment (PostId, UserId, Content)
			VALUES (@PostId, @UserID, @Content)

			UPDATE Post
			SET CommentsCount = CommentsCount + 1
			WHERE PostId = @PostId;

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			THROW;
		END CATCH
END
GO
EXEC porc_ToAddCommentOnPost @PostID = 1, @UserId = 1, @Content = 'Nice Photo..'
EXEC porc_ToAddCommentOnPost @PostId = 1, @UserId = 2, @Content = 'Looking good'
EXEC porc_ToAddCommentOnPost @PostId = 1, @UserId = 3, @Content = 'Awesome Pic'
GO

-- SP to send follow request to other users
CREATE PROCEDURE proc_ToSendFollowRequest
	@FollowerId INT, @FollowingId INT 
AS
BEGIN
	INSERT INTO Follow (FollowerId, FollowingId)
	VALUES (@FollowerId, @FollowingId)
END
GO
EXEC proc_ToSendFollowRequest @FollowerId = 2, @FollowingId = 1
EXEC proc_ToSendFollowRequest @FollowerId = 1, @FollowingId = 3
GO

--SP to send message to the other user
CREATE PROCEDURE proc_ToSendMessage
	@SenderId INT, @RecieverId INT, @Content TEXT
AS
BEGIN
	INSERT INTO [Message] (SenderId, RecieverId, Content)
	VALUES (@SenderId, @RecieverId, @Content)
END
GO
EXEC proc_ToSendMessage @SenderId = 1, @RecieverId = 3, @Content = 'Hello, How are you?'
EXEC proc_ToSendMessage @SenderId = 3, @RecieverId = 1, @Content = 'I am good, thank you.'
GO

--SP to create a group
CREATE PROCEDURE proc_ToCreateAGroup
	@AdminId INT, @GroupName VARCHAR(50)
AS
BEGIN
	INSERT INTO [Group] (AdminId, GroupName)
	VALUES (@AdminId, @GroupName)
END
EXEC proc_ToCreateAGroup @AdminId = 1, @GroupName = 'Job for freshers'
EXEC proc_ToCreateAGroup @AdminId = 3, @GroupName = 'Forever Friends'
GO

--SP to join a group 
CREATE PROCEDURE proc_ToJoinAGroup
	@GroupId INT, @UserId INT
AS
BEGIN
	INSERT INTO GroupMembers (GroupId, UserId)
	VALUES (@GroupId, @UserId)
END
GO
EXEC proc_ToJoinAGroup @GroupId = 1, @UserId = 2
EXEC proc_ToJoinAGroup @GroupId = 1, @UserId = 3
EXEC proc_ToJoinAGroup @GroupId = 2, @UserId = 1
EXEC proc_ToJoinAGroup @GroupId = 2, @UserId = 3
GO

--SP to save a post
CREATE OR ALTER PROCEDURE proc_ToSaveAPost
	@PostId INT, @SavedBy INT, @MediaType VARCHAR(20), @MediaURL VARCHAR(50)
AS
BEGIN
	INSERT INTO Media (PostId, UserId, MediaType, MediaURL)
	VALUES (@PostId, @SavedBy, @MediaType, @MediaURL)
END
GO
EXEC proc_ToSaveAPost @PostId  = 1, @SavedBy = 2, @MediaType = 'Image', @MediaURL = 'https://www.pinterest.com/pin/606297168576770597/'
GO

--SP to update user details
CREATE PROCEDURE proc_ToUpdateUserDetails
	@UserId INT,
	@Username VARCHAR(30) = NULL,
	@Email VARCHAR(50) = NULL,
	@Password VARCHAR(30) = NULL,
	@Name VARCHAR (30) =  NULL,
	@Bio TEXT = NULL,
	@ProfilePicture VARCHAR(50) = NULL
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO UserBackup (UserId, Username, Email, [Password], [Name], Bio, ProfilePicture) 
			SELECT UserId, Username, Email, [Password], [Name], Bio, ProfilePicture
			FROM [User]
			WHERE UserId = @UserId

			UPDATE [User]
			SET 
				Username = COALESCE(@Username, Username),
				Email = COALESCE(@Email, Email),
				[Password] = COALESCE(@Password, [Password]),
				[Name] = COALESCE(@Name, [Name]),
				Bio = COALESCE(@Bio, Bio),
				ProfilePicture = COALESCE(@ProfilePicture, ProfilePicture)
			WHERE UserId = @UserId
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			THROW
		END CATCH
END
GO
EXEC proc_ToUpdateUserDetails @UserId = 1, @Email = 'Harry1@gmail.com'
GO

--Trigger to send notification to the user when someone add new post
CREATE OR ALTER TRIGGER tr_AuditLogs
ON [User]
AFTER INSERT, UPDATE, DELETE 
AS
BEGIN
	INSERT INTO AuditLogs(UserId, ActionPerformed, Details)
	SELECT
		COALESCE(i.UserId, d.UserId) AS UserId,
		CASE
			WHEN i.UserId IS NOT NULL AND d.UserId IS NULL THEN 'Insert'
			WHEN i.UserId IS NOT NULL AND d.UserId IS NOT NULL THEN 'Update'
			WHEN i.UserId IS NULL AND d.UserId IS NOT NULL THEN 'Delete'
		END AS ActionPerformed,
		CASE 
			WHEN i.UserId IS NOT NULL AND d.UserId IS NULL THEN 'Registered New User'
			WHEN i.UserId IS NOT NULL AND d.UserId IS NOT NULL THEN 'Updated User Details'
			WHEN i.UserId IS NULL AND d.UserId IS NOT NULL THEN 'Deleted User'
		END AS Details
	FROM inserted i
	FULL OUTER JOIN deleted d ON i.UserId = d.UserId
END
GO

-- Trigger to send notification to the user when someone like there post.
CREATE OR ALTER TRIGGER tr_LikingAPost
ON [Like]
AFTER INSERT
AS
BEGIN
	INSERT INTO [Notification] (UserId, NotificationType, SenderId)
	SELECT 
		p.UserId AS UserId,
		'Like' AS NotificationType,
		i.UserId AS SenderId
	FROM inserted i
	JOIN Post p ON i.PostId = p.PostId

	DECLARE @Message VARCHAR(50)
	SELECT @Message = CONCAT('User ',  i.UserId , ' liked a post of user ', p.UserId)
	FROM inserted i
	JOIN [Post] p ON i.PostId = p.PostId
	PRINT @Message
END
GO
--Trigger to send notification to the user when someone comment on there post.
CREATE OR ALTER TRIGGER tr_CommentingOnAPost
ON Comment 
AFTER INSERT
AS 
BEGIN
	INSERT INTO [Notification] (UserId, NotificationType, SenderId)
	SELECT 
		p.UserId AS UserId,
		'Comment' AS NotificationType,
		i.UserId AS SenderId
	FROM inserted i
	JOIN [Post] p ON i.PostId = p.PostId

	DECLARE @Message VARCHAR(50)
	SELECT @Message = CONCAT('User ', i.UserId, ' commented on post of user ', p.UserId)
	FROM inserted i
	JOIN [Post] p ON i.PostId = p.PostId 
	PRINT @Message
END
GO

--Trigger to notify user when some other user sends follow request
CREATE OR ALTER TRIGGER tr_ToNotifyFollowRequest
ON Follow
AFTER INSERT
AS
BEGIN 
	INSERT INTO [Notification] (UserId, NotificationType, SenderId)
	SELECT
		FollowingId AS UserId,
		'Follow' AS NotificationType,
		FollowerId AS SenderId
	FROM inserted 

	DECLARE @Message VARCHAR(50)
	SELECT @Message = CONCAT('User ', FollowerId, ' sent follow request to user ', FollowingId)
	FROM inserted
	PRINT @Message
END
GO

--Trigger to notify user when other user sends message
CREATE TRIGGER tr_ToNotifyAboutMessage
ON [Message]
AFTER INSERT
AS
BEGIN 
	INSERT INTO [Notification] (UserId, NotificationType, SenderId)
	SELECT 
		RecieverId AS UserId,
		'Message' AS NotificationType,
		SenderId
	FROM inserted

	DECLARE @Message VARCHAR(50)
	SELECT @Message = CONCAT('User ', SenderId, ' sent message to user ', RecieverId)
	FROM inserted
	PRINT @Message
END
GO

--Trigger to tell admin about users who joined the group
CREATE OR ALTER TRIGGER tr_ToNotifyNewGroupMembers
ON GroupMembers
AFTER INSERT
AS
BEGIN
	INSERT INTO [Notification] (UserId, NotificationType, SenderId)
	SELECT 
		g.AdminId AS UserId,
		'Group' AS NotificationType,
		i.UserId AS SenderId
	FROM inserted i
	JOIN [Group] g ON g.GroupId = i.GroupId

	DECLARE @Message VARCHAR(100)
	SELECT @Message = CONCAT('User ', i.UserId, ' joined a group ', g.GroupId, ' - ', g.GroupName, ' created by user ', g.AdminId)
	FROM inserted i
	JOIN [Group] g ON g.GroupId = i.GroupId
	PRINT @Message
END

GO
--A cursor to count the total number of users
DECLARE @UserId INT
DECLARE @TotalUsers INT = 0

DECLARE TotalNumOfUsersCursor CURSOR FOR
SELECT UserId FROM [User]

OPEN TotalNumOfUsersCursor
FETCH NEXT FROM TotalNumOfUsersCursor INTO @UserId

WHILE (@@FETCH_STATUS = 0)
BEGIN 
	SET @TotalUsers = @TotalUsers + 1
	FETCH NEXT FROM TotalNumOfUsersCursor INTO @UserId
END

PRINT '---*TOTAL USERS*---'
PRINT @TotalUsers

CLOSE TotalNumOfUsersCursor
DEALLOCATE TotalNumOfUsersCursor

--Backup of database
BACKUP DATABASE SOCIALMEDIA_DB
TO DISK = 'F:\Database_Backups\SocialMedia1_FullBackUp.bak'
WITH FORMAT,
NAME = 'Full Backup of Social Media Project'

SELECT * FROM [User];
SELECT * FROM UserBackup;
SELECT * FROM Post;
SELECT * FROM [Like];
SELECT * FROM [Comment]; 
SELECT * FROM AuditLogs;
SELECT * FROM [Notification];	
SELECT * FROM Follow;
SELECT * FROM [Message];
SELECT * FROM [Group];
SELECT * FROM [GroupMembers];
SELECT * FROM Media;


