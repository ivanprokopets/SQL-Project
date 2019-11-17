# SQL_Project
Parsing and connect API_GUS https://api.stat.gov.pl/Home/Index

## API_REGON_XML
Connect to API_REGON https://api.stat.gov.pl/Home/RegonApi  
` SET @FileNameDaneSzukajPodmioty = N'E:\SQL_PROJEKT\DaneSzukajPodmioty.xml'`  
`	SET @FileNameDanePobierzPelnyRaport = N'E:\SQL_PROJEKT\DanePobierzPelnyRaport.xml'`    
` SET @FileNameDanePobierzRaportZbiorczy = N'E:\SQL_PROJEKT\DanePobierzRaportZbiorczy.xml'`    
Replace path, where you have file date.

## API_BDL_XML 
Connect to API_BDL https://api.stat.gov.pl/Home/BdlApi     
Please read the comments of the code [Code](./API_BDL_XML_v3.0.sql)


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
