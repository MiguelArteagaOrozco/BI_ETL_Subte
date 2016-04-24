USE [MIS_GRUPO_04]
GO

CREATE TABLE [dbo].[LK_Linea](
	[Linea_SK] [int] IDENTITY(1,1) NOT NULL,
	[Linea_nombre] [varchar](max) NOT NULL,
 CONSTRAINT [PK_LK_Linea] PRIMARY KEY CLUSTERED 
(
	[Linea_SK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[LK_Estacion](
	[Estacion_SK] [int] IDENTITY(1,1) NOT NULL,
	[Estacion_XCoord] [decimal](19, 15) NOT NULL,
	[Estacion_YCoord] [decimal](19, 15) NOT NULL,
	[Estacion_AscensorCon] [int] NOT NULL,
	[Estacion_EscaleraCon] [int] NOT NULL,
	[Estacion_EstaAdaptado] [bit] NOT NULL,
	[Estacion_EsAccesible] [bit] NOT NULL,
	[Linea_SK] [int] NOT NULL,
	[Estacion_Nombre] [varchar](50) NOT NULL,
	[Estacion_ID] [int] NOT NULL,
 CONSTRAINT [PK_LK_Estacion] PRIMARY KEY CLUSTERED 
(
	[Estacion_SK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LK_Estacion]  WITH CHECK ADD  CONSTRAINT [FK_LK_Estacion_LK_Linea] FOREIGN KEY([Linea_SK])
REFERENCES [dbo].[LK_Linea] ([Linea_SK])
GO

ALTER TABLE [dbo].[LK_Estacion] CHECK CONSTRAINT [FK_LK_Estacion_LK_Linea]
GO
