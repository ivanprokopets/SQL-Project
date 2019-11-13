CREATE DATABASE api_teryt
GO
USE api_teryt
GO
DECLARE @FileNameJPT nvarchar(255)
	SET @FileNameJPT = N'E:\SQL_PROJEKT\TERC_Urzedowy_2019-10-25\TERC_Urzedowy_2019-10-25.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 

CREATE TABLE [Jednostki_podzialu_terytorialnego_TABLE](
	[Numer] INT NOT NULL,
    [WOJ] [varchar](50) NULL,
    [POW] [varchar](50) NULL,
    [GMI] [varchar](50) NULL,
    [RODZ] [varchar](50) NULL,
	[NAZWA] [varchar] (500) NULL,
	[NAZWA_DOD] [varchar] (50) NULL,
	[STAN_NA] [varchar] (50) NULL

 CONSTRAINT [JPT_PK] PRIMARY KEY ([Numer])
)
	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK N'''+ @FileNameJPT + ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO Jednostki_podzialu_terytorialnego_TABLE (Numer, WOJ,POW, GMI,RODZ,NAZWA,NAZWA_DOD,STAN_NA) 
SELECT 
   ROW_NUMBER() OVER(ORDER BY 1/0) as Numer,
   t.jdt.value('(WOJ/text())[1]', 'VARCHAR(50)'),
   t.jdt.value('(POW/text())[1]', 'VARCHAR(50)'),
   t.jdt.value('(GMI/text())[1]', 'VARCHAR(50)'),
   t.jdt.value('(RODZ/text())[1]', 'VARCHAR(50)'),
   t.jdt.value('(NAZWA/text())[1]', 'VARCHAR(500)'),
   t.jdt.value('(NAZWA_DOD/text())[1]', 'VARCHAR(500)'),
   t.jdt.value('(STAN_NA/text())[1]', 'VARCHAR(50)')
   FROM @xml.nodes('teryt/catalog/row') t(jdt)
/*----------------------------------------------------------------------------------------------------------*/
SELECT * FROM Jednostki_podzialu_terytorialnego_TABLE
/*----------------------------------------------------------------------------------------------------------*/
GO
DECLARE @FileNameMSC nvarchar(255)
	SET @FileNameMSC = N'E:\SQL_PROJEKT\SIMC_Urzedowy_2019-10-25\SIMC_Urzedowy_2019-10-25.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 
CREATE TABLE [Mejscowosci_TABLE] (
	[Numer] INT NOT NULL,
    [WOJ] [varchar](50) NULL,
    [POW] [varchar](50) NULL,
    [GMI] [varchar](50) NULL,
    [RODZ_GMI] [varchar](50) NULL,
	[RM] [varchar] (50) NULL,
	[MZ] [varchar] (50) NULL,
	[NAZWA] [varchar] (500) NULL,
	[SYM] [varchar] (50) NULL,
	[SYMPOD] [varchar] (50) NULL,
	[STAN_NA] [varchar] (50) NULL

  CONSTRAINT [MSC_PK] PRIMARY KEY ([Numer])
)
	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK N''' + @FileNameMSC + ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO Mejscowosci_TABLE (Numer,WOJ,POW, GMI,RODZ_GMI,RM,MZ,NAZWA,SYM,SYMPOD,STAN_NA) 
SELECT
   ROW_NUMBER() OVER(ORDER BY 1/0) as Numer,
   t.msc.value('(WOJ/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(POW/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(GMI/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(RODZ_GMI/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(RM/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(MZ/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(NAZWA/text())[1]', 'VARCHAR(500)'),
   t.msc.value('(SYM/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(SYMPOD/text())[1]', 'VARCHAR(50)'),
   t.msc.value('(STAN_NA/text())[1]', 'VARCHAR(50)')
   FROM @xml.nodes('SIMC/catalog/row') t(msc)
/*----------------------------------------------------------------------------------------------------------*/
SELECT * FROM Mejscowosci_TABLE
/*----------------------------------------------------------------------------------------------------------*/
GO
DECLARE @FileNameULC nvarchar(255)
	SET @FileNameULC = N'E:\SQL_PROJEKT\ULIC_Urzedowy_2019-10-25\ULIC_Urzedowy_2019-10-25.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 
CREATE TABLE [Ulice_TABLE] (
	[Numer] INT NOT NULL,
    [WOJ] [varchar](50) NULL,
    [POW] [varchar](50) NULL,
    [GMI] [varchar](50) NULL,
    [RODZ_GMI] [varchar](50) NULL,
	[SYM] [varchar] (50) NULL,
	[SYM_UL] [varchar] (50) NULL,
	[CECHA] [varchar] (50) NULL,
	[NAZWA_1] [varchar] (500) NULL,
	[NAZWA_2] [varchar] (500)  NULL,
	[STAN_NA] [varchar] (50) NUll
	
  CONSTRAINT [ULC_PK] PRIMARY KEY ([Numer])
)
	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK ''' + @FileNameULC+ ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO Ulice_TABLE (Numer,WOJ,POW, GMI,RODZ_GMI,SYM,SYM_UL,CECHA,NAZWA_1,NAZWA_2,STAN_NA) 
SELECT
   ROW_NUMBER() OVER (ORDER BY 1/0) as Numer,
   t.ulc.value('(WOJ/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(POW/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(GMI/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(RODZ_GMI/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(SYM/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(SYM_UL/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(CECHA/text())[1]', 'VARCHAR(50)'),
   t.ulc.value('(NAZWA_1/text())[1]', 'VARCHAR(500)'),
   t.ulc.value('(NAZWA_2/text())[1]', 'VARCHAR(500)'),
   t.ulc.value('(STAN_NA/text())[1]', 'VARCHAR(50)')
   FROM @xml.nodes('ULIC/catalog/row') t(ulc)
/*----------------------------------------------------------------------------------------------------------*/
SELECT * FROM Ulice_TABLE
/*----------------------------------------------------------------------------------------------------------*/
GO
DECLARE @FileNameNJTDCS nvarchar(255)
	SET @FileNameNJTDCS = N'E:\SQL_PROJEKT\NTS_2019-10-25\NTS_2019-10-25.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 
CREATE TABLE [Nomenklatura_Jednostek_Terytorialnych_do_Celow_Statystycznych_TABLE] (
	[Numer] INT NOT NULL,
	[POZIOM] [varchar] (50) NULL,
	[REGION] [varchar] (50) NULL,
    [WOJ] [varchar](50) NULL,
	[PODREG] [varchar] (50) NULL,
    [POW] [varchar](50) NULL,
    [GMI] [varchar](50) NULL,
    [RODZ] [varchar](50) NULL,
	[NAZWA] [varchar] (500) NULL,
	[NAZWA_DOD] [varchar] (500) NULL,
	[STAN_NA] [varchar] (50) NUll

  CONSTRAINT [NJTDCS_PK] PRIMARY KEY ([Numer])
)
	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK '''+ @FileNameNJTDCS+ ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO Nomenklatura_Jednostek_Terytorialnych_do_Celow_Statystycznych_TABLE (Numer,POZIOM,REGION,WOJ,PODREG,POW, GMI,RODZ,NAZWA,NAZWA_DOD,STAN_NA) 
SELECT
   ROW_NUMBER() OVER (ORDER BY 1/0) as Numer,
   t.njtdcs.value('(POZIOM/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(REGION/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(WOJ/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(PODREG/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(POW/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(GMI/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(RODZ/text())[1]', 'VARCHAR(50)'),
   t.njtdcs.value('(NAZWA/text())[1]', 'VARCHAR(500)'),
   t.njtdcs.value('(NAZWA_DOD/text())[1]', 'VARCHAR(500)'),
   t.njtdcs.value('(STAN_NA/text())[1]', 'VARCHAR(50)')
   FROM @xml.nodes('NTS/catalog/row') t(njtdcs)
/*----------------------------------------------------------------------------------------------------------*/
SELECT * FROM Nomenklatura_Jednostek_Terytorialnych_do_Celow_Statystycznych_TABLE
/*----------------------------------------------------------------------------------------------------------*/
GO
DECLARE @FileNameRMSC nvarchar(255)
	SET @FileNameRMSC = N'E:\SQL_PROJEKT\WMRODZ_2019-10-25\WMRODZ_2019-10-25.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 
CREATE TABLE [Rodzaje_miejscowosci_TABLE] (
	[Numer] INT NOT NULL,
    [RM] [varchar](50) NULL,
    [NAZWA_RM] [varchar](50) NULL,
	[STAN_NA] [varchar] (50) NUll

	CONSTRAINT [RMSC_PK] PRIMARY KEY ([Numer])
)
SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML) 
	FROM OPENROWSET(BULK '''+ @FileNameRMSC+ ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO Rodzaje_miejscowosci_TABLE (Numer,RM, NAZWA_RM, STAN_NA) 
SELECT
   ROW_NUMBER() OVER (ORDER BY 1/0) as Numer,
   t.rmsc.value('(RM/text())[1]', 'VARCHAR(50)'),
   t.rmsc.value('(NAZWA_RM/text())[1]', 'VARCHAR(50)'),
   t.rmsc.value('(STAN_NA/text())[1]', 'VARCHAR(50)')
   FROM @xml.nodes('SIMC/catalog/row') t(rmsc)
/*----------------------------------------------------------------------------------------------------------*/
SELECT * FROM Rodzaje_miejscowosci_TABLE
/*----------------------------------------------------------------------------------------------------------*/
GO
/*
SELECT * FROM Jednostki_podzialu_terytorialnego_TABLE
SELECT * FROM Mejscowosci_TABLE
SELECT * FROM Ulice_TABLE
SELECT * FROM Nomenklatura_Jednostek_Terytorialnych_do_Celow_Statystycznych_TABLE
SELECT * FROM Rodzaje_miejscowosci_TABLE
*/