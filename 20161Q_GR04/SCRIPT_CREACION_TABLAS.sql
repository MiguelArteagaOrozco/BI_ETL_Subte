/*
  este script es solo para nosotros
  el proceso ETL solo debe llenar datos y no tocar estructuras
*/

USE [MIS_GRUPO_04]
GO

IF OBJECT_ID('dbo.BT_Pases', 'U') IS NOT NULL
  DROP TABLE dbo.BT_Pases

IF OBJECT_ID('dbo.BT_Despachos', 'U') IS NOT NULL
  DROP TABLE dbo.BT_Despachos

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
	('00:00:00', '00:14:59'),('00:15:00', '00:29:59'),('00:30:00', '00:44:59'),('00:45:00', '00:59:59'),
	('01:00:00', '01:14:59'),('01:15:00', '01:29:59'),('01:30:00', '01:44:59'),('01:45:00', '01:59:59'),
	('02:00:00', '02:14:59'),('02:15:00', '02:29:59'),('02:30:00', '02:44:59'),('02:45:00', '02:59:59'),
	('03:00:00', '03:14:59'),('03:15:00', '03:29:59'),('03:30:00', '03:44:59'),('03:45:00', '03:59:59'),
	('04:00:00', '04:14:59'),('04:15:00', '04:29:59'),('04:30:00', '04:44:59'),('04:45:00', '04:59:59'),
	('05:00:00', '05:14:59'),('05:15:00', '05:29:59'),('05:30:00', '05:44:59'),('05:45:00', '05:59:59'),
	('06:00:00', '06:14:59'),('06:15:00', '06:29:59'),('06:30:00', '06:44:59'),('06:45:00', '06:59:59'),
	('07:00:00', '07:14:59'),('07:15:00', '07:29:59'),('07:30:00', '07:44:59'),('07:45:00', '07:59:59'),
	('08:00:00', '08:14:59'),('08:15:00', '08:29:59'),('08:30:00', '08:44:59'),('08:45:00', '08:59:59'),
	('09:00:00', '09:14:59'),('09:15:00', '09:29:59'),('09:30:00', '09:44:59'),('09:45:00', '09:59:59'),
	('10:00:00', '10:14:59'),('10:15:00', '10:29:59'),('10:30:00', '10:44:59'),('10:45:00', '10:59:59'),
	('11:00:00', '11:14:59'),('11:15:00', '11:29:59'),('11:30:00', '11:44:59'),('11:45:00', '11:59:59'),
	('12:00:00', '12:14:59'),('12:15:00', '12:29:59'),('12:30:00', '12:44:59'),('12:45:00', '12:59:59'),
	('13:00:00', '13:14:59'),('13:15:00', '13:29:59'),('13:30:00', '13:44:59'),('13:45:00', '13:59:59'),
	('14:00:00', '14:14:59'),('14:15:00', '14:29:59'),('14:30:00', '14:44:59'),('14:45:00', '14:59:59'),
	('15:00:00', '15:14:59'),('15:15:00', '15:29:59'),('15:30:00', '15:44:59'),('15:45:00', '15:59:59'),
	('16:00:00', '16:14:59'),('16:15:00', '16:29:59'),('16:30:00', '16:44:59'),('16:45:00', '16:59:59'),
	('17:00:00', '17:14:59'),('17:15:00', '17:29:59'),('17:30:00', '17:44:59'),('17:45:00', '17:59:59'),
	('18:00:00', '18:14:59'),('18:15:00', '18:29:59'),('18:30:00', '18:44:59'),('18:45:00', '18:59:59'),
	('19:00:00', '19:14:59'),('19:15:00', '19:29:59'),('19:30:00', '19:44:59'),('19:45:00', '19:59:59'),
	('20:00:00', '20:14:59'),('20:15:00', '20:29:59'),('20:30:00', '20:44:59'),('20:45:00', '20:59:59'),
	('21:00:00', '21:14:59'),('21:15:00', '21:29:59'),('21:30:00', '21:44:59'),('21:45:00', '21:59:59'),
	('22:00:00', '22:14:59'),('22:15:00', '22:29:59'),('22:30:00', '22:44:59'),('22:45:00', '22:59:59'),
	('23:00:00', '23:14:59'),('23:15:00', '23:29:59'),('23:30:00', '23:44:59'),('23:45:00', '23:59:59')


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

CREATE TABLE [dbo].[BT_Despachos](
	[Linea_SK] [int] NOT NULL,
	[Causa_SK] [int] NOT NULL,
	[FranjaHoraria_SK] [int] NOT NULL,
	[Dia_SK] [int] NOT NULL,
	[CantFormaciones] [int] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[BT_Despachos]  WITH CHECK ADD  CONSTRAINT [FK_BT_Despachos_LK_Causa] FOREIGN KEY([Causa_SK])
REFERENCES [dbo].[LK_Causa] ([Causa_Sk])
GO

ALTER TABLE [dbo].[BT_Despachos] CHECK CONSTRAINT [FK_BT_Despachos_LK_Causa]
GO

ALTER TABLE [dbo].[BT_Despachos]  WITH CHECK ADD  CONSTRAINT [FK_BT_Despachos_LK_Dia] FOREIGN KEY([Dia_SK])
REFERENCES [dbo].[LK_Dia] ([Dia_SK])
GO

ALTER TABLE [dbo].[BT_Despachos] CHECK CONSTRAINT [FK_BT_Despachos_LK_Dia]
GO

ALTER TABLE [dbo].[BT_Despachos]  WITH CHECK ADD  CONSTRAINT [FK_BT_Despachos_LK_FranjaHoraria] FOREIGN KEY([FranjaHoraria_SK])
REFERENCES [dbo].[LK_FranjaHoraria] ([FranjaHoraria_SK])
GO

ALTER TABLE [dbo].[BT_Despachos] CHECK CONSTRAINT [FK_BT_Despachos_LK_FranjaHoraria]
GO

ALTER TABLE [dbo].[BT_Despachos]  WITH CHECK ADD  CONSTRAINT [FK_BT_Despachos_LK_Linea] FOREIGN KEY([Linea_SK])
REFERENCES [dbo].[LK_Linea] ([Linea_SK])
GO

ALTER TABLE [dbo].[BT_Despachos] CHECK CONSTRAINT [FK_BT_Despachos_LK_Linea]
GO

Create NonClustered Index Index_BT_Despachos On dbo.BT_Despachos (Linea_SK Asc, FranjaHoraria_SK Asc, Dia_SK Asc, Causa_Sk)
GO
