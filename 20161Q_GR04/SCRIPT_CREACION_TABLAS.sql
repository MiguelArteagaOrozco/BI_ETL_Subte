USE [MIS_GRUPO_04]
GO

IF OBJECT_ID('dbo.BT_Pases', 'U') IS NOT NULL
  DROP TABLE dbo.BT_Pases

IF OBJECT_ID('dbo.LK_FranjaHoraria', 'U') IS NOT NULL
  DROP TABLE dbo.LK_FranjaHoraria;

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

ALTER TABLE [dbo].[LK_Dia]  WITH CHECK ADD  CONSTRAINT [FK_LK_Dia_LK_Mes] FOREIGN KEY([Mes_Sk])
REFERENCES [dbo].[LK_Mes] ([Mes_SK])
GO

ALTER TABLE [dbo].[LK_Dia] CHECK CONSTRAINT [FK_LK_Dia_LK_Mes]
GO

--creo tabla temporal
create table #temp_time (
	Anio int,
	Mes int,
	DiaSemana int,
	Dia int
);

--query para llenar de fechas la tabla temporal
with mycte as
( select cast('2008-01-01' as datetime) DateValue
union all
select DateValue + 1
from mycte
where DateValue + 1 < '2017-01-01'
) insert into #temp_time (Anio, Mes, Dia, DiaSemana)
select Year(DateValue) as Anio,
DATEPART(month ,DateValue) as Mes,
DATEPART(day,DateValue) as Dia,
DATEPART(DW,DateValue) as DiaSemana
from mycte
OPTION (MAXRECURSION 0);

--inserto los anios
insert into LK_Anio (Anio_numero)
select Anio from #temp_time group by Anio order by Anio;

--inserto los meses
insert into LK_Mes (Mes_Numero, Anio_SK)
select tt.Mes, a.Anio_SK from #temp_time tt inner join LK_Anio a on tt.Anio = a.Anio_numero group by a.Anio_SK, tt.Mes order by a.Anio_SK, tt.Mes;

--inserto los días
insert into LK_Dia (Dia_Numero, Dia_DiaSemana, Mes_Sk)
select tt.Dia, tt.DiaSemana, m.Mes_SK from #temp_time tt, LK_Mes m, LK_Anio a
where tt.Anio = a.Anio_numero and tt.Mes = m.Mes_Numero and a.Anio_SK = m.Anio_SK
order by Anio, Mes, Dia;

--borro tabla temporal
drop table #temp_time;

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


CREATE TABLE [dbo].[LK_FranjaHoraria](
	[FranjaHoraria_SK] [int] IDENTITY(1,1) NOT NULL,
	[FranjaHoraria_Desde] [time](7) NOT NULL,
	[FranjaHoraria_Hasta] [time](7) NOT NULL,
 CONSTRAINT [PK_LK_FranjaHoraria] PRIMARY KEY CLUSTERED
(
	[FranjaHoraria_SK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO dbo.LK_FranjaHoraria (FranjaHoraria_Desde, FranjaHoraria_Hasta)
VALUES
	('00:00', '00:14'),('00:15', '00:29'),('00:30', '00:44'),('00:45', '00:59'),
	('01:00', '01:14'),('01:15', '01:29'),('01:30', '01:44'),('01:45', '01:59'),
	('02:00', '02:14'),('02:15', '02:29'),('02:30', '02:44'),('02:45', '02:59'),
	('03:00', '03:14'),('03:15', '03:29'),('03:30', '03:44'),('03:45', '03:59'),
	('04:00', '04:14'),('04:15', '04:29'),('04:30', '04:44'),('04:45', '04:59'),
	('05:00', '05:14'),('05:15', '05:29'),('05:30', '05:44'),('05:45', '05:59'),
	('06:00', '06:14'),('06:15', '06:29'),('06:30', '06:44'),('06:45', '06:59'),
	('07:00', '07:14'),('07:15', '07:29'),('07:30', '07:44'),('07:45', '07:59'),
	('08:00', '08:14'),('08:15', '08:29'),('08:30', '08:44'),('08:45', '08:59'),
	('09:00', '09:14'),('09:15', '09:29'),('09:30', '09:44'),('09:45', '09:59'),
	('10:00', '10:14'),('10:15', '10:29'),('10:30', '10:44'),('10:45', '10:59'),
	('11:00', '11:14'),('11:15', '11:29'),('11:30', '11:44'),('11:45', '11:59'),
	('12:00', '12:14'),('12:15', '12:29'),('12:30', '12:44'),('12:45', '12:59'),
	('13:00', '13:14'),('13:15', '13:29'),('13:30', '13:44'),('13:45', '13:59'),
	('14:00', '14:14'),('14:15', '14:29'),('14:30', '14:44'),('14:45', '14:59'),
	('15:00', '15:14'),('15:15', '15:29'),('15:30', '15:44'),('15:45', '15:59'),
	('16:00', '16:14'),('16:15', '16:29'),('16:30', '16:44'),('16:45', '16:59'),
	('17:00', '17:14'),('17:15', '17:29'),('17:30', '17:44'),('17:45', '17:59'),
	('18:00', '18:14'),('18:15', '18:29'),('18:30', '18:44'),('18:45', '18:59'),
	('19:00', '19:14'),('19:15', '19:29'),('19:30', '19:44'),('19:45', '19:59'),
	('20:00', '20:14'),('20:15', '20:29'),('20:30', '20:44'),('20:45', '20:59'),
	('21:00', '21:14'),('21:15', '21:29'),('21:30', '21:44'),('21:45', '21:59'),
	('22:00', '22:14'),('22:15', '22:29'),('22:30', '22:44'),('22:45', '22:59'),
	('23:00', '23:14'),('23:15', '23:29'),('23:30', '23:44'),('23:45', '23:59')


CREATE TABLE [dbo].[BT_Pases](
	[Estacion_SK] [int] NOT NULL,
	[FranjaHoraria_SK] [int] NOT NULL,
	[Dia_SK] [int] NOT NULL,
	[CantPersonas] [int] NOT NULL,
	[CantPasesPagos] [int] NOT NULL,
	[CantPasesJubilados] [int] NOT NULL,
	[CantPasesPlanes] [int] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[BT_Pases]  WITH CHECK ADD  CONSTRAINT [FK_BT_Pases_LK_Dia] FOREIGN KEY([Dia_SK])
REFERENCES [dbo].[LK_Dia] ([Dia_SK])
GO

ALTER TABLE [dbo].[BT_Pases] CHECK CONSTRAINT [FK_BT_Pases_LK_Dia]
GO

ALTER TABLE [dbo].[BT_Pases]  WITH CHECK ADD  CONSTRAINT [FK_BT_Pases_LK_Estacion] FOREIGN KEY([Estacion_SK])
REFERENCES [dbo].[LK_Estacion] ([Estacion_SK])
GO

ALTER TABLE [dbo].[BT_Pases] CHECK CONSTRAINT [FK_BT_Pases_LK_Estacion]
GO

ALTER TABLE [dbo].[BT_Pases]  WITH CHECK ADD  CONSTRAINT [FK_BT_Pases_LK_FranjaHoraria] FOREIGN KEY([FranjaHoraria_SK])
REFERENCES [dbo].[LK_FranjaHoraria] ([FranjaHoraria_SK])
GO

ALTER TABLE [dbo].[BT_Pases] CHECK CONSTRAINT [FK_BT_Pases_LK_FranjaHoraria]
GO
