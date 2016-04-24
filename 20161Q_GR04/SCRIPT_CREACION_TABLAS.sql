USE [MIS_GRUPO_04]
GO

CREATE TABLE [dbo].[LK_Linea](
	[Linea_SK] [int] IDENTITY(1,1) NOT NULL,
	[Linea_nombre] [varchar](max) NOT NULL,
 CONSTRAINT [PK_LK_Linea] PRIMARY KEY CLUSTERED 
(
