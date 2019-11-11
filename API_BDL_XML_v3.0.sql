
/*
Test Api_BDL dla korzystania z dynamicznego api po przez api z strony internetowej.

--BANK DANYCH LOKALNYCH - baz¹ danych o gospodarce, spo³eczeñstwie i œrodowisku. Zawiera w sobie cechy statystyczne.
--Dane opisuj¹ miejscowoœci statystyczne, gminy, powiaty, województwa i Polskê
*/
--!!! Prosze przeczytaæ!
-- Dla poprawnego dzia³ania trzeba najpierw uruchomiæ  poni¿szy skrypt
-- Rozszerzona procedura sk³adowana Ole Automation Procedures umo¿liwia wykonywanie plików wykonywalnych hosta poza kontrol¹ uprawnieñ dostêpu do bazy danych. 
-- umo¿liwiaj¹ u¿ytkownikom SQL Server wykonywanie funkcji zewnêtrznych wzglêdem SQL Server 
-- Dostêp ten mo¿e zostaæ wykorzystany przez z³oœliwych u¿ytkowników, 
-- którzy naruszyli integralnoœæ procesu bazy danych SQL Server w celu kontrolowania systemu operacyjnego hosta w celu przeprowadzenia dodatkowej z³oœliwej aktywnoœci.
EXEC SP_CONFIGURE 'show advanced options', '1'; 
RECONFIGURE WITH OVERRIDE; 
EXEC SP_CONFIGURE 'Ole Automation Procedures', '1'; 
GO
RECONFIGURE;
GO
CREATE OR ALTER PROCEDURE [dbo].data_bdl_by_variable
(
			@varID NVARCHAR(4000),
			@year NVARCHAR(100),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/data/by-variable/' + @varID + '?' + 'format=json&year=' + @year + '&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords],[variableId],[measureUnitId],[aggregateId],[lastUpdate] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords',
				   [variableId] nvarchar(max) N'$.variableId',
				   [measureUnitId] nvarchar(max) N'$.measureUnitId',
				   [aggregateId] nvarchar(max) N'$.aggregateId',
				   [lastUpdate] nvarchar(max) N'$.lastUpdate'
				 )
		    */
			SELECT [id],[name],[year],[val],[attrId] FROM OPENJSON(( SELECT * FROM @json), N'$.results')  
			WITH
				( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[values] nvarchar(max) N'$.values' as json
				 )
					OUTER APPLY OPENJSON([values]) with ( [year] nvarchar(max) N'$.year' )
					OUTER APPLY OPENJSON([values]) with ( [val] nvarchar(max) N'$.val' )
					OUTER APPLY OPENJSON([values]) with ( [attrId] nvarchar(max) N'$.attrId' ) 
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].data_bdl_by_variable '3643','2016','100'
GO
CREATE OR ALTER PROCEDURE [dbo].data_bdl_by_unit
(
			@unitID NVARCHAR(4000),
			@varID NVARCHAR(4000),
			@year NVARCHAR(100),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN
--https://bdl.stat.gov.pl/api/v1/data/by-unit/012400000000?format=json&var-id=3643&year=2004&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/data/by-unit/' + @unitID + '?' + 'format=json&year=' + @year + '&page-size=' + @page_size +'&var-id=' + @varID

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords],[unitId],[unitName],[aggregateId] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords',
				   [unitId] nvarchar(max) N'$.unitId',
				   [unitName] nvarchar(max) N'$.unitName',
				   [aggregateId] nvarchar(max) N'$.aggregateId'
				 )
			*/
			SELECT [id],[measureUnitId],[lastUpdate],[year],[val],[attrId] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[measureUnitId] nvarchar(Max) N'$.measureUnitId',
					[lastUpdate] nvarchar(max) N'$.lastUpdate',
					[values] nvarchar(max) N'$.values' as json
				 )
					OUTER APPLY OPENJSON([values]) with ( [year] nvarchar(max) N'$.year' )
					OUTER APPLY OPENJSON([values]) with ( [val] nvarchar(max) N'$.val' )
					OUTER APPLY OPENJSON([values]) with ( [attrId] nvarchar(max) N'$.attrId' )
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].data_bdl_by_unit '012400000000', '3643', '2017', '100'
GO
CREATE OR ALTER PROCEDURE [dbo].data_bdl_localities
(
			@varID NVARCHAR(4000),
			@unit_parent_id NVARCHAR(4000),
			@year NVARCHAR(100),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/data/localities/by-variable/420?format=json&unit-parent-id=011200000000&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/data/localities/by-variable/' + @varID + '?' + 'format=json&year=' + @year + '&page-size=' + @page_size +'&unit-parent-id=' + @unit_parent_id

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords],[variableId],[measureUnitId],[aggregateId] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords',
				   [variableId] nvarchar(max) N'$.variableId',
				   [measureUnitId] nvarchar(max) N'$.measureUnitId',
				   [aggregateId] nvarchar(max) N'$.aggregateId',
				   [lastUpdate] nvarchar(max) N'$.lastUpdate'
				 )
		    */
			SELECT [id],[name],[year],[val],[attrId] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[values] nvarchar(max) N'$.values' as json
				 )
					OUTER APPLY OPENJSON([values]) with ( [year] nvarchar(max) N'$.year' )
					OUTER APPLY OPENJSON([values]) with ( [val] nvarchar(max) N'$.val' )
					OUTER APPLY OPENJSON([values]) with ( [attrId] nvarchar(max) N'$.attrId' )
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].data_bdl_localities '420','011200000000','2017','100'
GO
CREATE OR ALTER PROCEDURE [dbo].aggregates
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/aggregates/1?format=json&page-size=100&id=1
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/aggregates/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
		    */
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[name],[level],[description] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[level] nvarchar(max) N'$.level',
					[description] nvarchar(max) N'$.description'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[name],[level],[description] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[level] nvarchar(max) N'$.level',
					[description] nvarchar(max) N'$.description'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].aggregates '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].attributes
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/aggregates/1?format=json&page-size=100&id=1
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/attributes/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[name],[symbol],[description] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[symbol] nvarchar(max) N'$.symbol',
					[description] nvarchar(max) N'$.description'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[name],[symbol],[description] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[symbol] nvarchar(max) N'$.symbol',
					[description] nvarchar(max) N'$.description'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].attributes '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].measures
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/measures/1?format=json&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/measures/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[name],[description] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[description] nvarchar(max) N'$.description'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[name],[description] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[description] nvarchar(max) N'$.description'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].measures '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].levels
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/measures/1?format=json&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/levels/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[name] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[name] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].levels '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].units_terrytorialne
(
			@ID NVARCHAR(3900),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/measures/1?format=json&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/units/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[name],[parentId],[level],[kind],[hasDescription],[years] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[parentId] nvarchar(max) N'$.parentId',
					[level] nvarchar(max) N'$.level',
					[kind] nvarchar(max) N'$.kind',
					[hasDescription] nvarchar(max) N'$.hasDescription',
					[years] nvarchar(max) N'$.years'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[name],[parentId],[level],[kind],[hasDescription],[years] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[parentId] nvarchar(max) N'$.parentId',
					[level] nvarchar(max) N'$.level',
					[kind] nvarchar(max) N'$.kind',
					[hasDescription] nvarchar(max) N'$.hasDescription',
					[years] nvarchar(max) N'$.years'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].units_terrytorialne '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].years
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/measures/1?format=json&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/years/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[hasLocalities],[quarterly] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[hasLocalities] nvarchar(Max) N'$.hasLocalities',
					[quarterly] nvarchar(max) N'$.quarterly'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[hasLocalities],[quarterly] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[hasLocalities] nvarchar(Max) N'$.hasLocalities',
					[quarterly] nvarchar(max) N'$.quarterly'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].years '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].tematy
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/measures/1?format=json&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/subjects/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[name],[hasVariables],[children],[levels] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[hasVariables] nvarchar(max) N'$.hasVariables',
					[children] nvarchar(max) N'$.children',
					[levels] nvarchar(max) N'$.levels'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[name],[hasVariables],[children],[levels] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[name] nvarchar(Max) N'$.name',
					[hasVariables] nvarchar(max) N'$.hasVariables',
					[children] nvarchar(max) N'$.children',
					[levels] nvarchar(max) N'$.levels'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].tematy '','100'
GO
CREATE OR ALTER PROCEDURE [dbo].zmienne
(
			@ID NVARCHAR(4000),
			@page_size NVARCHAR(MAX)
)
AS
BEGIN

		--https://bdl.stat.gov.pl/api/v1/measures/1?format=json&page-size=100
			DECLARE @url NVARCHAR(256);
			SET @url = 'https://bdl.stat.gov.pl/api/v1/variables/' + @ID + '?' + 'format=json&page-size=' + @page_size

			Declare @Object as Int;
			Declare @hr int;
			Declare @json as table(json_table nvarchar(max));

			Exec @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'open', NULL, 'get',
				@url,'false'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec sp_OAMethod @Object, 'send'
				IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
			Exec @hr = sp_OAMethod @Object, 'responseText', @json OUTPUT
				IF @hr <> 0 

			INSERT INTO @json (json_table) EXEC sp_OAGetProperty @Object, 'responseText'
			--JSON OPEN
			/* wyswietla wszystki recordy 
			Select [totalRecords] FROM OPENJSON (( SELECT * FROM @json)) 
			WITH (
				   [totalRecords] nvarchar(max) N'$.totalRecords'
				 )
			*/
				 IF @ID = 0 
				 BEGIN
			SELECT [id],[subjectId],[n1],[n2],[level],[measureUnitId],[measureUnitName] FROM OPENJSON(( SELECT * FROM @json), N'$.results')
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[subjectId] nvarchar(Max) N'$.subjectId',
					[n1] nvarchar(max) N'$.n1',
					[n2] nvarchar(max) N'$.n2',
					[level] nvarchar(max) N'$.level',
					[measureUnitId] nvarchar(max) N'$.measureUnitId',
					[measureUnitName] nvarchar(max) N'$.measureUnitName'
				 )
				 END
				 ELSE
				 BEGIN
			SELECT [id],[subjectId],[n1],[n2],[level],[measureUnitId],[measureUnitName] FROM OPENJSON(( SELECT * FROM @json))
			WITH ( 
					[id] nvarchar(Max) N'$.id',
					[subjectId] nvarchar(Max) N'$.subjectId',
					[n1] nvarchar(max) N'$.n1',
					[n2] nvarchar(max) N'$.n2',
					[level] nvarchar(max) N'$.level',
					[measureUnitId] nvarchar(max) N'$.measureUnitId',
					[measureUnitName] nvarchar(max) N'$.measureUnitName'
				 )
				 END
			Exec sp_OADestroy @Object
END
		--EXECUTE [dbo].zmienne '','100'
GO
--WYWOLANIE API BDL GUS 
--____________________________________________________________________________________________---

/*
Dane - dane liczbowe w postaci trójki [liczba rzeczywista, identyfikator atrybutu, identyfikator roku], w postaci zbioru danych dla konkretnej zmiennej lub zbioru danych dla jednej jednostki
*/

--1 arg - id zmiennej, 2 arg - rok , 3 arg - rozmiar listy 
--DANE dla jedenj zmiennej 
EXECUTE [dbo].data_bdl_by_variable '3643','2018','100'

--wyszukuje z bazy konkretn¹ wartosc dla jednej jednostki terytorialnej 
--1 arg - unitID 2 arg - id zmienned -3 arg rok 4 arg - rozmiar listy 
EXECUTE [dbo].data_bdl_by_unit '012400000000', '3643', '2017', '100'

--wyszukuje z bazy GUsu dane dla miejsocowosci statystycznych dla jedenj zmiennej 
-- 1 arg - id zmennej 2 arg - id jednostki terytorialnje 3 arg rok 4 agrg rozmiar listy 

EXECUTE [dbo].data_bdl_localities '420','011200000000','2017','100'

/*
Agregaty - poziomy agregowania danych, dla których znajduj¹ siê dane, np. gminy miejskie lub gminy miejsko-wiejskie.
*/

--poziom agregacji o zadanym Id
-- 1 arg id agregacji 2 arg rozmiar listy
EXECUTE [dbo].aggregates '','100'


/*
Jednostki miary - jednostki miary wystêpuj¹ce w danych, zwi¹zane z konkretnymi zmiennymi
*/

--1 arg id 2 arg rozmiar
		EXECUTE [dbo].measures '','100'
/*
Atrybuty - opisy specyficznych sytuacji w danych, które powi¹zane s¹ z ka¿d¹ wartoœci¹ liczbow¹.
*/
--atrybut o zadanym id
-- 1 arg id atrybuta 2 arg rozmiar listy
EXECUTE [dbo].attributes '','100'

/*
Poziom obowi¹zywania 
*/

--Poziom dostêpnosci danych o zadanym id
-- 1 arg id 2 arg rozmiar listy
EXECUTE [dbo].levels '','100'

/*
Jednostki terotyrialne - hierarchicznie powi¹zana lista jednostek terytorialnych (od Polski do gmin w³¹cznie) i miejscowoœci statystycznych
*/
-- 1 arg id 2 arg rozmiar 
EXECUTE [dbo].units_terrytorialne '','100'

/*
Lata - lata obowi¹zywania, dla których mog¹ wystêpowaæ dane
*/
--1 arg rok 2 arg rozmiar listy 
EXECUTE [dbo].years '','100'

/*
Tematy - hierarchicznie powi¹zane grupy zmiennych wg zakresu merytorycznego.
*/
EXECUTE [dbo].tematy '','100'

/*
Zmienne - to wielowymiarowe cechy reprezentuj¹ce okreœlone zjawisko, z okreœlonym obowi¹zywaniem w latach i na konkretnym poziomie jednostek.
*/

EXECUTE [dbo].zmienne '','100'

/*
Wy³oczenie Ole Automation Procedures
*/
/*
!!!!!!!PO SPRAWDZENIU URUCHOMIC TO!!!!!!!

EXEC SP_CONFIGURE 'show advanced options', '0'; 
RECONFIGURE WITH OVERRIDE; 
EXEC SP_CONFIGURE 'Ole Automation Procedures', '0'; 
GO
RECONFIGURE;
GO

DROP PROCEDURE data_bdl_by_unit
DROP PROCEDURE data_bdl_by_variable
DROP PROCEDURE data_bdl_localities
DROP PROCEDURE zmienne
DROP PROCEDURE tematy
DROP PROCEDURE years
DROP PROCEDURE units_terrytorialne
DROP PROCEDURE levels
DROP PROCEDURE aggregates 
DROP PROCEDURE attributes
DROP PROCEDURE measures

*/