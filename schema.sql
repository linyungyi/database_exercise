SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_access]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_access](
	[f_id] [int] IDENTITY(1,1) NOT NULL,
	[f_email] [varchar](100) NOT NULL,
	[f_pwd] [varchar](50) NOT NULL,
	[f_name] [varchar](50) NOT NULL
) ON [PRIMARY]
END
