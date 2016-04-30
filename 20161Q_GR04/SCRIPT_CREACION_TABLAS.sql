USE [MIS_GRUPO_04]
GO

IF OBJECT_ID('dbo.LK_Dia', 'U') IS NOT NULL 
  DROP TABLE dbo.LK_Dia; 

IF OBJECT_ID('dbo.LK_Causa', 'U') IS NOT NULL 
  DROP TABLE dbo.LK_Causa; 
  
IF OBJECT_ID('dbo.LK_Mes', 'U') IS NOT NULL 
  DROP TABLE dbo.LK_Mes; 

IF OBJECT_ID('dbo.LK_Anio', 'U') IS NOT NULL 
  DROP TABLE dbo.LK_Anio; 

IF OBJECT_ID('dbo.LK_Estacion', 'U') IS NOT NULL 
  DROP TABLE dbo.LK_Estacion; 
  
IF OBJECT_ID('dbo.LK_Linea', 'U') IS NOT NULL 
  DROP TABLE dbo.LK_Linea; 


CREATE TABLE [dbo].[LK_Linea](
	[Linea_SK] [int] IDENTITY(1,1) NOT NULL,
	[Linea_nombre] [varchar](50) NOT NULL,
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
	[Estacion_EstaAdaptado] [varchar](50) NOT NULL,
	[Estacion_EsAccesible] [varchar](50) NOT NULL,
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

CREATE TABLE [dbo].[LK_Anio](
	[Anio_SK] [int] IDENTITY(1,1) NOT NULL,
	[Anio_numero] [int] NOT NULL,
 CONSTRAINT [PK_LK_Anio] PRIMARY KEY CLUSTERED 
(
	[Anio_SK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


--Inserto los anios
--INSERT INTO dbo.LK_Anio (Anio_numero) VALUES(2013),(2014),(2015),(2016),(2017)

CREATE TABLE [dbo].[LK_Mes](
	[Mes_SK] [int] IDENTITY(1,1) NOT NULL,
	[Mes_Numero] [int] NOT NULL,
	[Anio_SK] [int] NOT NULL,
 CONSTRAINT [PK_LK_Mes] PRIMARY KEY CLUSTERED 
(
	[Mes_SK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LK_Mes]  WITH CHECK ADD  CONSTRAINT [FK_LK_Mes_LK_Anio] FOREIGN KEY([Anio_SK])
REFERENCES [dbo].[LK_Anio] ([Anio_SK])
GO

ALTER TABLE [dbo].[LK_Mes] CHECK CONSTRAINT [FK_LK_Mes_LK_Anio]
GO

--Inserto los meses de cada anio
--INSERT INTO dbo.LK_Mes (Mes_Numero, Anio_SK)
--	SELECT 1, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 2, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 3, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 4, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 5, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 6, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 7, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 8, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 9, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 10, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 11, Anio_SK FROM dbo.LK_Anio
--	UNION ALL
--	SELECT 12, Anio_SK FROM dbo.LK_Anio


CREATE TABLE [dbo].[LK_Dia](
	[Dia_SK] [int] IDENTITY(1,1) NOT NULL,
	[Dia_Numero] [int] NOT NULL,
	[Dia_DiaSemana] [int] NOT NULL,
	[Mes_Sk] [int] NOT NULL,
 CONSTRAINT [PK_LK_Dia] PRIMARY KEY CLUSTERED 
(
	[Dia_SK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




-------------------------------------------------------------
------ INSERTAR ACA EL RESTO DE LA DIM TIEMPO ---------------
-------------------------------------------------------------

CREATE TABLE [dbo].[LK_Causa](
	[Causa_Sk] [int] IDENTITY(1,1) NOT NULL,
	[Causa_Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LK_Causa] PRIMARY KEY CLUSTERED 
(
	[Causa_Sk] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
