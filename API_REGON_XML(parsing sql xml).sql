CREATE DATABASE api_regon
GO
USE api_regon
GO
DECLARE @FileNameDaneSzukajPodmioty nvarchar(255)
	SET @FileNameDaneSzukajPodmioty = N'E:\SQL_PROJEKT\DaneSzukajPodmioty.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 

CREATE TABLE DaneSzukajPodmioty_TABLE(
	Numer INT NOT NULL IDENTITY(1,1),
	Regon [varchar](14),
	Nip [varchar](10),
	StatusNip [varchar](50),
	Nazwa [varchar](2000), 
	Wojewodztwo [varchar](200),
	Powiat [varchar](200),
	Gmina [varchar](200),
	Miejscowosc [varchar](200),
	KodPocztowy [varchar](12),
	Ulica [varchar] (200) ,
	NrNieruchomosci [varchar](20) ,
	NrLokalu [varchar] (10) ,
	Typ [varchar] (2) ,
	SilosID [varchar] (20) ,
	DataZakonczeniaDzialalnosci [varchar] (10) 

 CONSTRAINT [DSP_PK] PRIMARY KEY ([Numer])

)

	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK N'''+ @FileNameDaneSzukajPodmioty + ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO DaneSzukajPodmioty_TABLE (Numer, Regon, Nip, StatusNip, Nazwa,Wojewodztwo,Powiat,Gmina,Miejscowosc,KodPocztowy,Ulica,NrNieruchomosci,NrLokalu,Typ,SilosID,DataZakonczeniaDzialalnosci) 
SELECT 
   ROW_NUMBER() OVER(ORDER BY 1/0) as Numer,
	t.dsp.value('(Regon/text())[1]', 'VARCHAR(14)'),
	t.dsp.value('(Nip/text())[1]', 'VARCHAR(10)'),
	t.dsp.value('(StatusNip/text())[1]', 'VARCHAR(50)'),
	t.dsp.value('(Nazwa/text())[1]', 'VARCHAR(2000)'),
	t.dsp.value('(Wojewodztwo/text())[1]', 'VARCHAR(200)'),
	t.dsp.value('(Powiat/text())[1]', 'VARCHAR(200)'),
	t.dsp.value('(Gmina/text())[1]', 'VARCHAR(200)'),
	t.dsp.value('(Miejscowosc/text())[1]', 'VARCHAR(200)'),
	t.dsp.value('(KodPocztowy/text())[1]', 'VARCHAR(12)'),
	t.dsp.value('(Ulica/text())[1]', 'VARCHAR(200)'),
	t.dsp.value('(NrNieruchomosci/text())[1]', 'VARCHAR(20)'),
	t.dsp.value('(NrLokalu/text())[1]', 'VARCHAR(10)'),
	t.dsp.value('(Typ/text())[1]', 'VARCHAR(2)'),
	t.dsp.value('(SilosID/text())[1]', 'VARCHAR(20)'),
	t.dsp.value('(DataZakonczeniaDzialalnosci/text())[1]', 'VARCHAR(10)')
   FROM @xml.nodes('root/dane') t(dsp)
/*----------------------------------------------------------------------------------------------------------*/
SELECT * FROM DaneSzukajPodmioty_TABLE
/*----------------------------------------------------------------------------------------------------------*/
GO
DECLARE @FileNameDanePobierzPelnyRaport nvarchar(255)
	SET @FileNameDanePobierzPelnyRaport = N'E:\SQL_PROJEKT\DanePobierzPelnyRaport.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 

CREATE TABLE DanePobierzPelnyRaport_TABLE(
	Numer INT NOT NULL,
	praw_regon9 [varchar] (14) ,
	praw_nip [varchar] (20) ,
	praw_statusNip [varchar] (20) ,
	praw_nazwa [varchar] (2000) ,
	praw_nazwaSkrocona [varchar] (50) ,
	praw_numerWRejestrzeEwidencji [varchar] (50) ,
	praw_dataWpisuDoRejestruEwidencji [varchar] (50) ,
	praw_dataPowstania [varchar] (50) ,
	praw_dataRozpoczeciaDzialalnosci [varchar] (50) ,

	praw_dataWpisuDoRegon [varchar] (50) ,
	praw_dataZawieszeniaDzialalnosci [varchar] (50) ,
	praw_dataWznowieniaDzialalnosci [varchar] (50) ,
	praw_dataZaistnieniaZmiany [varchar] (50) ,
	praw_dataZakonczeniaDzialalnosci [varchar] (50) ,
	praw_dataSkresleniaZRegon [varchar] (50) ,
	praw_dataOrzeczeniaOUpadlosci [varchar] (50) ,
	praw_dataZakonczeniaPostepowaniaUpadlosciowego [varchar] (50) ,
	praw_adSiedzKraj_Symbol [varchar] (50) ,
	praw_adSiedzWojewodztwo_Symbol [varchar] (50) ,

	praw_adSiedzPowiat_Symbol [varchar] (50) ,
	praw_adSiedzGmina_Symbol [varchar] (50) ,
	praw_adSiedzKodPocztowy [varchar] (50) ,
	praw_adSiedzMiejscowoscPoczty_Symbol [varchar] (50) ,
	praw_adSiedzMiejscowosc_Symbol [varchar] (50) ,
	praw_adSiedzUlica_Symbol [varchar] (50) ,
	praw_adSiedzNumerNieruchomosci [varchar] (50) ,
	praw_adSiedzNumerLokalu [varchar] (50) ,
	praw_adSiedzNietypoweMiejsceLokalizacji [varchar] (50) ,
	praw_numerTelefonu [varchar] (50) ,

	praw_numerWewnetrznyTelefonu [varchar] (50) ,
	praw_numerFaksu [varchar] (50) ,
	praw_adresEmail [varchar] (50) ,
	praw_adresStronyinternetowej [varchar] (50) ,
	praw_adSiedzKraj_Nazwa [varchar] (50) ,
	praw_adSiedzWojewodztwo_Nazwa [varchar] (50) ,
	praw_adSiedzPowiat_Nazwa [varchar] (50) ,
	praw_adSiedzGmina_Nazwa [varchar] (50) ,
	praw_adSiedzMiejscowosc_Nazwa [varchar] (50) ,
	praw_adSiedzMiejscowoscPoczty_Nazwa [varchar] (50) ,

	praw_adSiedzUlica_Nazwa [varchar] (50) ,
	praw_podstawowaFormaPrawna_Symbol [varchar] (50) ,
	praw_szczegolnaFormaPrawna_Symbol [varchar] (50) ,
	praw_formaFinansowania_Symbol [varchar] (50) ,
	praw_formaWlasnosci_Symbol [varchar] (50) ,
	praw_organZalozycielski_Symbol [varchar] (50) ,
	praw_organRejestrowy_Symbol [varchar] (50) ,
	praw_rodzajRejestruEwidencji_Symbol [varchar] (50) ,
	praw_podstawowaFormaPrawna_Nazwa [varchar] (50) ,
	praw_szczegolnaFormaPrawna_Nazwa [varchar] (50) ,

	praw_formaFinansowania_Nazwa [varchar] (50) ,
	praw_formaWlasnosci_Nazwa [varchar] (50) ,
	praw_organZalozycielski_Nazwa [varchar] (50) ,
	praw_organRejestrowy_Nazwa [varchar] (50) ,
	praw_rodzajRejestruEwidencji_Nazwa [varchar] (50) ,
	praw_liczbaJednLokalnych [varchar] (50) 

 CONSTRAINT [DPPR_PK] PRIMARY KEY ([Numer])
)

	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK N'''+ @FileNameDanePobierzPelnyRaport + ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO DanePobierzPelnyRaport_TABLE (
Numer,
praw_regon9,
praw_nip,
praw_statusNip,
praw_nazwa,
praw_nazwaSkrocona,
praw_numerWRejestrzeEwidencji,
praw_dataWpisuDoRejestruEwidencji,
praw_dataPowstania,
praw_dataRozpoczeciaDzialalnosci,

praw_dataWpisuDoRegon,
praw_dataZawieszeniaDzialalnosci,
praw_dataWznowieniaDzialalnosci,
praw_dataZaistnieniaZmiany,
praw_dataZakonczeniaDzialalnosci,
praw_dataSkresleniaZRegon,
praw_dataOrzeczeniaOUpadlosci,
praw_dataZakonczeniaPostepowaniaUpadlosciowego,
praw_adSiedzKraj_Symbol,
praw_adSiedzWojewodztwo_Symbol,

praw_adSiedzPowiat_Symbol,
praw_adSiedzGmina_Symbol,
praw_adSiedzKodPocztowy,
praw_adSiedzMiejscowoscPoczty_Symbol,
praw_adSiedzMiejscowosc_Symbol,
praw_adSiedzUlica_Symbol,
praw_adSiedzNumerNieruchomosci,
praw_adSiedzNumerLokalu,
praw_adSiedzNietypoweMiejsceLokalizacji,
praw_numerTelefonu,

praw_numerWewnetrznyTelefonu,
praw_numerFaksu,
praw_adresEmail,
praw_adresStronyinternetowej,
praw_adSiedzKraj_Nazwa,
praw_adSiedzWojewodztwo_Nazwa,
praw_adSiedzPowiat_Nazwa,
praw_adSiedzGmina_Nazwa,
praw_adSiedzMiejscowosc_Nazwa,
praw_adSiedzMiejscowoscPoczty_Nazwa,

praw_adSiedzUlica_Nazwa,
praw_podstawowaFormaPrawna_Symbol,
praw_szczegolnaFormaPrawna_Symbol,
praw_formaFinansowania_Symbol,
praw_formaWlasnosci_Symbol,
praw_organZalozycielski_Symbol,
praw_organRejestrowy_Symbol,
praw_rodzajRejestruEwidencji_Symbol,
praw_podstawowaFormaPrawna_Nazwa,
praw_szczegolnaFormaPrawna_Nazwa,

praw_formaFinansowania_Nazwa,
praw_formaWlasnosci_Nazwa,
praw_organZalozycielski_Nazwa,
praw_organRejestrowy_Nazwa,
praw_rodzajRejestruEwidencji_Nazwa,
praw_liczbaJednLokalnych
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY 1/0) as Numer,
	t.dppr.value('(praw_regon9/text())[1]', 'VARCHAR(14)'),
	t.dppr.value('(praw_nip/text())[1]', 'VARCHAR(20)'),
	t.dppr.value('(praw_statusNip/text())[1]', 'VARCHAR(20)'),
	t.dppr.value('(praw_nazwa/text())[1]', 'VARCHAR(2000)'),
	t.dppr.value('(praw_nazwaSkrocona/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_numerWRejestrzeEwidencji/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataWpisuDoRejestruEwidencji/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataPowstania/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataRozpoczeciaDzialalnosci/text())[1]', 'VARCHAR(50)'),

	t.dppr.value('(praw_dataWpisuDoRegon/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataZawieszeniaDzialalnosci/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataWznowieniaDzialalnosci/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataZaistnieniaZmiany/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataZakonczeniaDzialalnosci/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataSkresleniaZRegon/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataOrzeczeniaOUpadlosci/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_dataZakonczeniaPostepowaniaUpadlosciowego/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzKraj_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzWojewodztwo_Symbol/text())[1]', 'VARCHAR(50)'),

	t.dppr.value('(praw_adSiedzPowiat_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzGmina_Symbol/text())[1]', 'VARCHAR(500)'),
	t.dppr.value('(praw_adSiedzKodPocztowy/text())[1]', 'VARCHAR(500)'),
	t.dppr.value('(praw_adSiedzMiejscowoscPoczty_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzMiejscowosc_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzUlica_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzNumerNieruchomosci/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzNumerLokalu/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzNietypoweMiejsceLokalizacji/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_numerTelefonu/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_numerWewnetrznyTelefonu/text())[1]', 'VARCHAR(50)'),

	t.dppr.value('(praw_numerFaksu/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adresEmail/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adresStronyinternetowej/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzKraj_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzWojewodztwo_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzPowiat_Nazwa/text())[1]', 'VARCHAR(500)'),
	t.dppr.value('(praw_adSiedzGmina_Nazwa/text())[1]', 'VARCHAR(500)'),
	t.dppr.value('(praw_adSiedzMiejscowosc_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzMiejscowoscPoczty_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_adSiedzUlica_Nazwa/text())[1]', 'VARCHAR(50)'),

	t.dppr.value('(praw_podstawowaFormaPrawna_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_szczegolnaFormaPrawna_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_formaFinansowania_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_formaWlasnosci_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_organZalozycielski_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_organRejestrowy_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_rodzajRejestruEwidencji_Symbol/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_podstawowaFormaPrawna_Nazwa/text())[1]', 'VARCHAR(50)'),	 
	t.dppr.value('(praw_szczegolnaFormaPrawna_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_formaFinansowania_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_formaWlasnosci_Nazwa/text())[1]', 'VARCHAR(50)'),

	t.dppr.value('(praw_organZalozycielski_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_organRejestrowy_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_rodzajRejestruEwidencji_Nazwa/text())[1]', 'VARCHAR(50)'),
	t.dppr.value('(praw_liczbaJednLokalnych/text())[1]', 'VARCHAR(50)')

   FROM @xml.nodes('root/dane') t(dppr)

-------------------------------------------------------------------------------------------
SELECT * FROM DanePobierzPelnyRaport_TABLE
-------------------------------------------------------------------------------------------
GO
DECLARE @FileNameDanePobierzRaportZbiorczy nvarchar(255)
	SET @FileNameDanePobierzRaportZbiorczy = N'E:\SQL_PROJEKT\DanePobierzRaportZbiorczy.xml'
DECLARE @xml XML
DECLARE @xmlload nvarchar (300) 

CREATE TABLE DanePobierzRaportZbiorczy_TABLE(
	Numer INT NOT NULL,
	regon VARCHAR (14)

 CONSTRAINT [DPRZ_PK] PRIMARY KEY ([Numer])
)
	SET @xmlload = N'
SELECT @xml = CAST(MY_XML AS XML)
	FROM OPENROWSET(BULK N'''+ @FileNameDanePobierzRaportZbiorczy + ''', SINGLE_BLOB) T(MY_XML)'
	EXEC sp_executesql @xmlload, N'@xml xml output', @xml=@xml output
INSERT INTO DanePobierzRaportZbiorczy_TABLE (Numer, regon) 
SELECT 
   ROW_NUMBER() OVER(ORDER BY 1/0) as Numer,
	t.dsp.value('(regon/text())[1]', 'VARCHAR(14)')

   FROM @xml.nodes('root/dane') t(dsp)
--------------------------------------------------------
SELECT * FROM DanePobierzRaportZbiorczy_TABLE
-------------------------------------------------------------------------------------------
/*
SELECT * FROM DanePobierzPelnyRaport_TABLE
SELECT * FROM DanePobierzRaportZbiorczy_TABLE
SELECT * FROM DaneSzukajPodmioty_TABLE
*/