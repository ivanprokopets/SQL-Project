# SQL_Project
Parsing and connect API_GUS https://api.stat.gov.pl/Home/Index

----------------------

## API_REGON_XML
Connect to API_REGON https://api.stat.gov.pl/Home/RegonApi  
` SET @FileNameDaneSzukajPodmioty = N'E:\SQL_PROJEKT\DaneSzukajPodmioty.xml'`  
`	SET @FileNameDanePobierzPelnyRaport = N'E:\SQL_PROJEKT\DanePobierzPelnyRaport.xml'`    
` SET @FileNameDanePobierzRaportZbiorczy = N'E:\SQL_PROJEKT\DanePobierzRaportZbiorczy.xml'`    
Replace path, where you have file date.

----------------------

## API_BDL_XML 
Connect to API_BDL https://api.stat.gov.pl/Home/BdlApi     
Please read the comments of the code [Code](./API_BDL_XML_v3.0.sql)  
Opis:  
• Na początku tworzę sobie pustą bazę danych o nazwie `api_bdl`.  
• Następnie tworzę puste tabeli do przechowywania danych.  
• Po stworzeniu tabel uzupelniam danymi z API za pomoce takich komend jak `OPENROWSET` sluzacy do otwierania pliku z danych w formaci
XML.  
• Dalej sprawdzam, czy wszystki dane sa uzupelnione. Ponizej jest przykladowy kod napisany w jezyku SQL.  
```SQL
DECLARE @FileNameLevel NVARCHAR (255)  
      SET @FileNameLevel = N' sciezka do pliku XML'  
DECLARE @xml XML  
DECLARE @xmlload NVARCHAR(300)  
CREATE TABLE [LEVELS_TABLE](  
    [ id ] [ varchar ](50) NOT NULL,  
    [name] [ varchar ](200) NOT NULL  
CONSTRAINT [LEVELS_PK] PRIMARY KEY ([ Id ])  
)  
SET @xmlload = N'  
SELECT @xml = CAST(MY_XML AS XML)  
              FROM OPENROWSET(BULK ' ' '+ @FileNameLevel+ ' ' ' ,SINGLE_BLOB) T(MY_XML) '  
EXEC sp_executesql @xmlload , N'@xml xml output ' , @xml=@xml output  
    INSERT INTO LEVELS_TABLE ( id , [ name])
    SELECT t . level . value ( ' ( id/text () ) [1] ' , 'VARCHAR(50) ' ) ,
           t . level . value ( ' (name/text () ) [1] ' , 'VARCHAR(200) ' )
    FROM @xml. nodes( ' levelList / results / level ' ) t ( level )
```  
Importuje dane do utowrzonej tabeli `LEVELS_TABLE`  

W Bazie danych sa utworzone 9 tabel, które przychowywaja przykladowe informacje.   
Glownym aspektem jest to, ze mozna modyfikowac, usuwac, dodawac nowe rekordy oraz zatwierdzac dane po przez server na bazie BDL.

----------------------

## API_TERYT_XML
Connect to API_TERYT https://api.stat.gov.pl/Home/TerytApi  
Replace path, where you have file date.

Instrukcja uruchomienia Teryt
Kroki postępowania: 
1.	Wejdź na stronę internetową [teryt]( http://eteryt.stat.gov.pl/eTeryt/rejestr_teryt/udostepnianie_danych/baza_teryt/uzytkownicy_indywidualni/pobieranie/pliki_pelne.aspx?contrast=default) . Ściągnij 5 archiwum, które znajdują się na tej stronie. 
2.	Następnie rozpakuj archiwum, dla uruchomienia potrzebne pliki .XML. 
3.	Następnie otwórz skrypt w załączniku API_TERYT_XML.sql . 
4.	Naciśnij  ctrl+f i wpisz SET @FileName powinno znaleźć 5 linijek( to jest ścieżka do pliku XML) 
5.	Wprowadź odpowiednie ścieżki do plików z archiwum do skryptu i uruchom.
6.	Po tych krokach powinny być insertowane z parsowane dane do pięciu tabel.

----------------------

