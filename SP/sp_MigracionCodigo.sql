IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MigracionCodigo]') AND type in (N'P', N'PC'))
	EXEC('CREATE PROCEDURE sp_MigracionCodigo AS')
GO

ALTER PROCEDURE sp_MigracionCodigo
@accion				char(3),
@codigoU			varchar(50)		= NULL,
@tipoU				varchar(5)		= NULL,
@nombreTableU		varchar(max)	= NULL,
@codigoTipo			char(5)			= NULL				
AS
BEGIN
SET NOCOUNT ON;
IF OBJECT_ID('tempdb..##RESULTADO') IS NOT NULL
		DROP TABLE ##RESULTADO
IF OBJECT_ID('tempdb..##RESULTADO2') IS NOT NULL
		DROP TABLE ##RESULTADO2
IF OBJECT_ID('tempdb..##RESULTADO3') IS NOT NULL
		DROP TABLE ##RESULTADO3

CREATE TABLE #migracionCodigo(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	observacion varchar(max)
)

CREATE TABLE #migracionCodigo2(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	codigo2 varchar(200),
	observacion varchar(max)
)

CREATE TABLE #migracionCodigo3(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	codigo2 varchar(200),
	codigo3 varchar(200),
	observacion varchar(max)
)


CREATE TABLE #migracionCodigo4(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	codigo2 varchar(200),
	codigo3 varchar(200),
	codigo4 varchar(200),
	observacion varchar(max)
)

CREATE TABLE #migracionCodigo5(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	codigo2 varchar(200),
	codigo3 varchar(200),
	codigo4 varchar(200),
	codigo5 varchar(200),
	observacion varchar(max)
)


CREATE TABLE #migracionCodigoU1(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	observacion varchar(max)
)

CREATE TABLE #camposWhere(
id int primary key identity(1,1),
codigo1 varchar(100),
codigo2 varchar(100),
codigo3 varchar(100),
codigo4 varchar(100),
codigo5 varchar(100),
NombreCampo1 varchar(200),
NombreCampo2 varchar(200),
NombreCampo3 varchar(200),
NombreCampo4 varchar(200),
NombreCampo5 varchar(200),
)



IF @accion='1'
BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,observacion 
	INTO #tablas
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND TIPO = @tipoU
	GROUP BY nombre_table,tipo,observacion

	DECLARE @cont2 int =0, @sec2 int =1
	
	SET @cont2 = (SELECT COUNT (*) FROM #tablas)

	WHILE @cont2 >= @sec2
	BEGIN


		DECLARE @nomPrincipal varchar(max)
		
		SELECT @nomPrincipal=nombre_table 
		FROM #tablas 
		WHERE id = @sec2

		SELECT COLUMN_NAME
				INTO #columnas
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nomPrincipal
				ORDER BY ORDINAL_POSITION
		
		
		IF (
			SELECT count(observacion)
			FROM #tablas 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipal
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 1
		BEGIN
			DECLARE @cont1 int =0, @sec1 int =1		
			
			
			INSERT INTO #migracionCodigo(nombre_tabla,tipo,codigo,observacion,codigoMigracion)
			SELECT  nombre_table, tipo,codigo,observacion,id 
			FROM temp_registroMigracion 
			WHERE [status]=1 AND codigo IS NOT NULL AND TIPO = @tipoU AND nombre_table= @nomPrincipal


			SELECT @cont1=COUNT(*) FROM #migracionCodigo WHERE nombre_tabla=@nomPrincipal

			WHILE @cont1 >=@sec1
			BEGIN				

				DECLARE @tipo varchar(5)='',
						@nombreTable varchar(200)='',
						@observacion varchar(200)='',
						@codigo varchar(50)='',
						@CreateTABLE NVARCHAR(max) = N'',
						@idCodMigracion1 varchar(10)

				SELECT @nombreTable=nombre_tabla, @tipo=tipo,@codigo=codigo,@observacion=observacion,@idCodMigracion1=codigoMigracion
				FROM #migracionCodigo 
				WHERE nombre_tabla = @nomPrincipal and id= @sec1
							
		
				IF @@ROWCOUNT = 0
				BREAK;
					

				DECLARE @text varchar(max)
				SET @text =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnas
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))
	
				IF OBJECT_ID('tempdb..##RESULTADO') IS NOT NULL
				BEGIN
					IF (SELECT COUNT (1) FROM ##RESULTADO)> 0
					SET @CreateTABLE =N'SELECT ' + @text + 
					' FROM ' + @nombreTable + ' WHERE ' + @observacion+'=''' + @codigo + ''''	
										
					INSERT INTO ##RESULTADO
					EXECUTE sp_executeSQL @CreateTABLE
				END	

				IF OBJECT_ID('tempdb..##RESULTADO') IS NULL
				BEGIN		
					SET @CreateTABLE =N'SELECT ' + @text +
					' INTO ##RESULTADO FROM ' + @nombreTable + ' WHERE ' + @observacion+'=''' + @codigo + ''''			
					EXECUTE sp_executeSQL @CreateTABLE
					
				END
								
				SET @sec1 +=1
			END

		IF OBJECT_ID('tempdb..##RESULTADO') IS NOT NULL
		BEGIN
			IF(SELECT COUNT(*) FROM ##RESULTADO)>0
				BEGIN
					DECLARE @Columns1 NVARCHAR(MAX);
					DECLARE @Sql1 NVARCHAR(MAX);								

					-- Obtener los nombres de las columnas de la tabla especificada
					SET @Columns1 = (SELECT STRING_AGG(CAST(QUOTENAME(NAME) AS varchar(MAX)), ', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO')) 

					SET @Sql1 = (SELECT STRING_AGG(				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(NAME) AS varchar(MAX)) + '), ''0'') AS ' + CAST(QUOTENAME(NAME) AS varchar(MAX)), 
						', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO')) 

					-- Ejecutar la consulta dinámica y obtener el resultado en formato JSON
					SET @Sql1 ='SELECT '''+ @nomPrincipal + ''' AS tabla, '+				
					'((SELECT  ' + @Sql1 + ' FROM ##RESULTADO FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql1;
				END
				
			DROP TABLE ##RESULTADO
		END

		END
		DROP TABLE #columnas
		SET @sec2 += 1
		TRUNCATE TABLE #migracionCodigo
		
	END
	DROP TABLE #migracionCodigo
	
END

IF @accion='2'
BEGIN	

	SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
	INTO #tablasC2
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND TIPO = @tipoU
	GROUP BY nombre_table,tipo,observacion

	DECLARE @contC2 int =0, @secC2 int =1
	
	SET @contC2 = (SELECT COUNT (*) FROM #tablasC2)	

	WHILE @contC2 >= @secC2
	BEGIN
		DECLARE @nomPrincipalC2 varchar(max)
		
		SELECT @nomPrincipalC2=nombre_table 
		FROM #tablasC2 WHERE id = @secC2	

		SELECT COLUMN_NAME
				INTO #columnas2
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nomPrincipalC2
				ORDER BY ORDINAL_POSITION
			
		IF (
			SELECT count(observacion)
			FROM #tablasC2 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalC2
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 2
		BEGIN
			
			DECLARE @contC1 int =0, @secC1 int =1

			INSERT INTO #migracionCodigo2(nombre_tabla,tipo,codigo,codigo2,observacion,codigoMigracion)
			SELECT  nombre_table, tipo,codigo,codigo2,REPLACE(observacion, ' ', '') AS observacion,id 
			FROM temp_registroMigracion 
			WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND TIPO = @tipoU AND nombre_table= @nomPrincipalC2
			
			
			SELECT @contC1=COUNT(*) FROM #migracionCodigo2

			WHILE @contC1 >=@secC1
			BEGIN
				DECLARE @tipoC2 varchar(5)='',
						@nombreTableC2 varchar(200)='',
						@observacionC2 varchar(200)='',
						@codigoC2 varchar(50)='',
						@codigo2C2 varchar(50)='',
						@CreateTABLEC2 NVARCHAR(max) = N'',
						@nombreColumna1 varchar(max) = '',
						@nombreColumna2 varchar(max) = '',
						@idCodMigracion varchar(10)=''
		
				SELECT @nombreTableC2=nombre_tabla, @tipoC2=tipo,@codigoC2=codigo,@codigo2C2=codigo2,@observacionC2=observacion,@idCodMigracion=codigoMigracion
				FROM #migracionCodigo2 
				WHERE id = @secC1 AND nombre_tabla = @nomPrincipalC2
				

				IF @@ROWCOUNT = 0
				BREAK;					

				DECLARE @text2 varchar(max)
				SET @text2 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnas2
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))


				SELECT *
				INTO #NomColumna
				FROM STRING_SPLIT(@observacionC2, ',',1)
	
				SET @nombreColumna1 = (select value from #NomColumna where ordinal=1)
				SET @nombreColumna2 = (select value from #NomColumna where ordinal=2)
	
				IF OBJECT_ID('tempdb..##RESULTADO2') IS NOT NULL
				BEGIN	
					IF (SELECT COUNT (1) FROM ##RESULTADO2)> 0
					SET @CreateTABLEC2 =N'SELECT ' + @text2 +
					' FROM ' + @nombreTableC2 + 
					' WHERE '+ @nombreColumna1 +'= ''' + @codigoC2 + ''' AND ' + @nombreColumna2 + ' = ''' + @codigo2C2 + ''''	
								
					INSERT INTO ##RESULTADO2
					EXECUTE sp_executeSQL @CreateTABLEC2
				END	

				IF OBJECT_ID('tempdb..##RESULTADO2') IS NULL
				BEGIN		
					SET @CreateTABLEC2 =N'SELECT ' + @text2 + 
					' INTO ##RESULTADO2 ' +
					' FROM ' + @nombreTableC2 + 
					' WHERE '+ @nombreColumna1 +'= ''' + @codigoC2 + ''' AND ' + @nombreColumna2 + ' = ''' + @codigo2C2 + ''''	
					PRINT @CreateTABLEC2
					EXECUTE sp_executeSQL @CreateTABLEC2			
				END
								
				DROP TABLE #NomColumna
				SET @secC1 +=1
			END

			IF OBJECT_ID('tempdb..##RESULTADO2') IS NOT NULL
			BEGIN
				IF(SELECT COUNT(*) FROM ##RESULTADO2)>0
				BEGIN
					DECLARE @Columns2 NVARCHAR(MAX);
					DECLARE @Sql2 NVARCHAR(MAX);								

					-- Obtener los nombres de las columnas de la tabla especificada
					SET @Columns2 = (SELECT STRING_AGG(CAST(QUOTENAME(NAME) AS varchar(MAX)), ', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO2')) 

					SET @Sql2 = (SELECT 
					STRING_AGG(				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(NAME) AS VARCHAR(MAX)) + '), ''0'') AS ' + CAST(QUOTENAME(NAME) AS varchar(MAX)), 
						', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO2')) 

					PRINT @Sql2

					-- Ejecutar la consulta dinámica y obtener el resultado en formato JSON
					SET @Sql2 ='SELECT '''+ @nomPrincipalC2 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql2 + ' FROM ##RESULTADO2 FOR JSON PATH)) AS datos FOR JSON PATH';
					
					EXEC sp_executesql @Sql2;
				END
				DROP TABLE ##RESULTADO2
			END
			TRUNCATE TABLE #migracionCodigo2
		END
		DROP TABLE #columnas2
		SET @secC2 += 1
	END

	DROP TABLE #migracionCodigo2
	
END

IF @accion='3'
BEGIN	

	SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
	INTO #tablasC3
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND TIPO = @tipoU
	GROUP BY nombre_table,tipo,observacion

	DECLARE @contC3 int =0, @secC3 int =1
	
	SET @contC3 = (SELECT COUNT (*) FROM #tablasC3)	

	

	WHILE @contC3 >= @secC3
	BEGIN
		DECLARE @nomPrincipalC3 varchar(max)
		
		SELECT @nomPrincipalC3=nombre_table 
		FROM #tablasC3 WHERE id = @secC3


		
		SELECT COLUMN_NAME
		INTO #columnas3
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_SCHEMA = 'dbo'
			and TABLE_NAME = @nomPrincipalC3
		ORDER BY ORDINAL_POSITION


		IF (
			SELECT count(observacion)
			FROM #tablasC3 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalC3
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 3
		BEGIN
			
			DECLARE @contCod3 int =0, @secCod3 int =1

			INSERT INTO #migracionCodigo3(nombre_tabla,tipo,codigo,codigo2,codigo3,observacion,codigoMigracion)
			SELECT  nombre_table, tipo,codigo,codigo2,codigo3,REPLACE(observacion, ' ', '') AS observacion,id 
			FROM temp_registroMigracion 
			WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL 
			AND TIPO = @tipoU AND nombre_table= @nomPrincipalC3


			SELECT @contCod3=COUNT(*) FROM #migracionCodigo3

			
			WHILE @contCod3 >=@secCod3
			BEGIN
				DECLARE @tipoC3 varchar(5)='',
						@nombreTableC3 varchar(200)='',
						@observacionC3 varchar(200)='',
						@codigoC3 varchar(200)='',
						@codigo2C3 varchar(200)='',
						@codigo3C3 varchar(200)='',
						@CreateTABLEC3 NVARCHAR(max) = N'',
						@nombreCol1Cod3 varchar(max) = '',
						@nombreCol2Cod3 varchar(max) = '',
						@nombreCol3Cod3 varchar(max) = '',
						@idCodMigracion3 varchar(10) = ''
		
				SELECT 
				@nombreTableC3=nombre_tabla, 
				@tipoC3=tipo,
				@codigoC3=codigo,
				@codigo2C3=codigo2,
				@codigo3C3=codigo3,
				@observacionC3=observacion,
				@idCodMigracion3=codigoMigracion
				FROM #migracionCodigo3 
				WHERE id = @secCod3 AND nombre_tabla = @nomPrincipalC3


								
				IF @@ROWCOUNT = 0
				BREAK;

				DECLARE @text3 varchar(max)
				SET @text3 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnas3
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))

				

				SELECT *
				INTO #NomColumna3
				FROM STRING_SPLIT(@observacionC3, ',',1)
	
				SET @nombreCol1Cod3 = (select value from #NomColumna3 where ordinal=1)
				SET @nombreCol2Cod3 = (select value from #NomColumna3 where ordinal=2)
				SET @nombreCol3Cod3 = (select value from #NomColumna3 where ordinal=3)

				IF OBJECT_ID('tempdb..##RESULTADO3') IS NOT NULL
				BEGIN	
					IF (SELECT COUNT (1) FROM ##RESULTADO3)> 0
					SET @CreateTABLEC3 =N'SELECT ' + @text3 + 
					' FROM ' + @nombreTableC3 + 
					' WHERE '+ @nombreCol1Cod3 +'= ''' + @codigoC3 + ''' AND ' + @nombreCol2Cod3 + ' = ''' + @codigo2C3 + ''''+
					' AND ' + @nombreCol3Cod3 + ' = ''' + @codigo3C3 + ''''
					
				
					INSERT INTO ##RESULTADO3
					EXECUTE sp_executeSQL @CreateTABLEC3

					
				END	
				
				IF OBJECT_ID('tempdb..##RESULTADO3') IS NULL
				BEGIN		
					SET @CreateTABLEC3 =N'SELECT ' + @text3 +
					' INTO ##RESULTADO3 ' +  
					' FROM ' + @nombreTableC3 + 
					' WHERE '+ @nombreCol1Cod3 +'= ''' + @codigoC3 + ''' AND ' + @nombreCol2Cod3 + ' = ''' + @codigo2C3 + ''''+
					' AND ' + @nombreCol3Cod3 + ' = ''' + @codigo3C3 + ''''										

					EXECUTE sp_executeSQL @CreateTABLEC3
				
				END
								
				DROP TABLE #NomColumna3
				SET @secCod3 +=1
			END

			IF OBJECT_ID('tempdb..##RESULTADO3') IS NOT NULL
			BEGIN

				IF (SELECT COUNT(1) FROM ##RESULTADO3)>0
				BEGIN
				DECLARE @Columns3 NVARCHAR(MAX);
				DECLARE @Sql3 NVARCHAR(MAX);						

				-- Obtener los nombres de las columnas de la tabla especificada
				SET @Columns3 = (SELECT STRING_AGG(CAST(QUOTENAME(NAME) AS varchar(MAX)), ', ') 
				FROM TempDB.SYS.COLUMNS 
				WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO3')) 

				SET @Sql3 = (SELECT STRING_AGG(
				
					'ISNULL( CONVERT(VARCHAR(MAX), ' + QUOTENAME(NAME) + '), ''0'') AS ' + CAST(QUOTENAME(NAME) AS varchar(MAX)), 
					', ') 
				FROM TempDB.SYS.COLUMNS 
				WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO3')) 

				-- Ejecutar la consulta dinámica y obtener el resultado en formato JSON
				SET @Sql3 ='SELECT '''+ @nomPrincipalC3 + ''' AS tabla, '+				
				'((SELECT  ' + @Sql3 + ' FROM ##RESULTADO3 FOR JSON PATH)) AS datos FOR JSON PATH';

				EXEC sp_executesql @Sql3;
				END				
				DROP TABLE ##RESULTADO3
			END
			TRUNCATE TABLE #migracionCodigo3
		END
		DROP TABLE #columnas3
		SET @secC3 += 1
	END

	DROP TABLE #migracionCodigo3
	
END

IF @accion='4'
BEGIN	

	SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
	INTO #tablasC4
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND TIPO = @tipoU
	GROUP BY nombre_table,tipo,observacion

	DECLARE @contC4 int =0, @secC4 int =1
	
	SET @contC4 = (SELECT COUNT (*) FROM #tablasC4)	

	WHILE @contC4 >= @secC4
	BEGIN
		DECLARE @nomPrincipalC4 varchar(max)
		
		SELECT @nomPrincipalC4=nombre_table 
		FROM #tablasC4 WHERE id = @secC4

		SELECT COLUMN_NAME
			INTO #columnas4
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_SCHEMA = 'dbo'
				and TABLE_NAME = @nomPrincipalC4
			ORDER BY ORDINAL_POSITION

		IF (
			SELECT count(observacion)
			FROM #tablasC4 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalC4
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 4
		BEGIN
			
			DECLARE @contCod4 int =0, @secCod4 int =1

			

			INSERT INTO #migracionCodigo4(nombre_tabla,tipo,codigo,codigo2,codigo3,codigo4,observacion,codigoMigracion)
			SELECT  nombre_table, tipo,codigo,codigo2,codigo3,codigo4,REPLACE(observacion, ' ', '') AS observacion,id 
			FROM temp_registroMigracion 
			WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL 
			AND TIPO = @tipoU AND nombre_table= @nomPrincipalC4


			SELECT @contCod4=COUNT(*) FROM #migracionCodigo4

			
			WHILE @contCod4 >=@secCod4
			BEGIN
				DECLARE @tipoC4 varchar(5)='',
						@nombreTableC4 varchar(200)='',
						@observacionC4 varchar(200)='',
						@codigoC4 varchar(200)='',
						@codigo4C2 varchar(200)='',
						@codigo4C3 varchar(200)='',
						@codigo4C4 varchar(200)='',
						@CreateTABLEC4 NVARCHAR(max) = N'',
						@nombreCol1Cod4 varchar(max) = '',
						@nombreCol2Cod4 varchar(max) = '',
						@nombreCol3Cod4 varchar(max) = '',
						@nombreCol4Cod4 varchar(max) = '',
						@idCodMigracion4 varchar(10) = ''

		
				SELECT 
				@nombreTableC4=nombre_tabla, 
				@tipoC4=tipo,
				@codigoC4=codigo,
				@codigo4C2=codigo2,
				@codigo4C3=codigo3,
				@codigo4C4=codigo4,
				@observacionC4=observacion,
				@idCodMigracion4=codigoMigracion
				FROM #migracionCodigo4 
				WHERE id = @secCod4 AND nombre_tabla = @nomPrincipalC4

								
				IF @@ROWCOUNT = 0
				BREAK;

				
				DECLARE @text4 varchar(max)
				SET @text4 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnas4
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))

				

				SELECT *
				INTO #NomColumna4
				FROM STRING_SPLIT(@observacionC4, ',',1)
	
				SET @nombreCol1Cod4 = (select value from #NomColumna4 where ordinal=1)
				SET @nombreCol2Cod4 = (select value from #NomColumna4 where ordinal=2)
				SET @nombreCol3Cod4 = (select value from #NomColumna4 where ordinal=3)
				SET @nombreCol4Cod4 = (select value from #NomColumna4 where ordinal=4)
				

				IF OBJECT_ID('tempdb..##RESULTADO4') IS NOT NULL
				BEGIN
					IF (SELECT COUNT (1) FROM ##RESULTADO4)> 0
					SET @CreateTABLEC4 =N'SELECT ' + @text4 + 
					' FROM ' + @nombreTableC4 + 
					' WHERE '+ @nombreCol1Cod4 +'= ''' + @codigoC4 + ''' AND ' + @nombreCol2Cod4 + ' = ''' + @codigo4C2 + ''''+
					' AND ' + @nombreCol3Cod4 + ' = ''' + @codigo4C3 + '''' + ' AND ' +@nombreCol3Cod4 + ' = '''+ @codigo4C3 + '''' 					


					INSERT INTO ##RESULTADO4
					EXECUTE sp_executeSQL @CreateTABLEC4

					
				END	

				IF OBJECT_ID('tempdb..##RESULTADO4') IS NULL
				BEGIN		

					SET @CreateTABLEC4 =N'SELECT ' + @text4 +
					' INTO ##RESULTADO4 ' +  
					' FROM ' + @nombreTableC4  +
					' WHERE '+ @nombreCol1Cod4 +'= ''' + @codigoC4 + ''' AND ' + @nombreCol2Cod4 + ' = ''' + @codigo4C2 + '''' +
					' AND ' + @nombreCol3Cod4 + ' = ''' + @codigo4C3 + '''' + ' AND ' +@nombreCol3Cod4 + ' = '''+ @codigo4C3 + '''' 			
						
					EXECUTE sp_executeSQL @CreateTABLEC4
				
				END
				DROP TABLE #NomColumna4				
				SET @secCod4 +=1
			END

			IF OBJECT_ID('tempdb..##RESULTADO4') IS NOT NULL
			BEGIN

				IF (SELECT COUNT(*) FROM ##RESULTADO4)> 0
				BEGIN
					DECLARE @Columns4 NVARCHAR(MAX);
					DECLARE @Sql4 NVARCHAR(MAX);					

					-- Obtener los nombres de las columnas de la tabla especificada
					SET @Columns4 = (SELECT STRING_AGG(CAST(QUOTENAME(NAME) AS varchar(MAX)), ', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO4')) 

					SET @Sql4 = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(NAME) AS varchar(MAX)) + '), ''0'') AS ' +CAST(QUOTENAME(NAME) AS varchar(MAX)), 
						', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO4')) 

					-- Ejecutar la consulta dinámica y obtener el resultado en formato JSON
					SET @Sql4 ='SELECT '''+ @nomPrincipalC4 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql4 + ' FROM ##RESULTADO4 FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql4;
				END		
				DROP TABLE ##RESULTADO4
			END
			TRUNCATE TABLE #migracionCodigo4
		END
		DROP TABLE #columnas4	
		SET @secC4 += 1
	END

	DROP TABLE #migracionCodigo4
	
END

IF @accion='5'
BEGIN	

	SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
	INTO #tablasC5
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS NOT NULL AND TIPO = @tipoU
	GROUP BY nombre_table,tipo,observacion

	DECLARE @contC5 int =0, @secC5 int =1
	
	SET @contC5 = (SELECT COUNT (*) FROM #tablasC5)	


	WHILE @contC5 >= @secC5
	BEGIN
		DECLARE @nomPrincipalC5 varchar(max)
		
		SELECT @nomPrincipalC5=nombre_table 
		FROM #tablasC5 WHERE id = @secC5

		SELECT COLUMN_NAME
				INTO #columnas5
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nomPrincipalC5
				ORDER BY ORDINAL_POSITION		
			
		IF (
			SELECT count(observacion)
			FROM #tablasC5 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalC5
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 5
		BEGIN
			
			DECLARE @contCod5 int =0, @secCod5 int =1

			

			INSERT INTO #migracionCodigo5(nombre_tabla,tipo,codigo,codigo2,codigo3,codigo4,codigo5,observacion,codigoMigracion)
			SELECT  nombre_table, tipo,codigo,codigo2,codigo3,codigo4,codigo5,REPLACE(observacion, ' ', '') AS observacion,id 
			FROM temp_registroMigracion 
			WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS NOT NULL 
			AND TIPO = @tipoU AND nombre_table= @nomPrincipalC5


			SELECT @contCod5=COUNT(*) FROM #migracionCodigo5

			
			WHILE @contCod5 >=@secCod5
			BEGIN
				DECLARE @tipoC5 varchar(5)='',
						@nombreTableC5 varchar(200)='',
						@observacionC5 varchar(200)='',
						@codigoC5 varchar(200)='',
						@codigo5C2 varchar(200)='',
						@codigo5C3 varchar(200)='',
						@codigo5C4 varchar(200)='',
						@codigo5C5 varchar(200)='',
						@CreateTABLEC5 NVARCHAR(max) = N'',
						@nombreCol1Cod5 varchar(max) = '',
						@nombreCol2Cod5 varchar(max) = '',
						@nombreCol3Cod5 varchar(max) = '',
						@nombreCol4Cod5 varchar(max) = '',
						@nombreCol5Cod5 varchar(max) = '',
						@idCodMigracion5 varchar(10) = ''

		
				SELECT 
				@nombreTableC5=nombre_tabla, 
				@tipoC5=tipo,
				@codigoC5=codigo,
				@codigo5C2=codigo2,
				@codigo5C3=codigo3,
				@codigo5C4=codigo4,
				@codigo5C5=codigo5,
				@observacionC5=observacion,
				@idCodMigracion5=codigoMigracion
				FROM #migracionCodigo5 
				WHERE id = @secCod5 AND nombre_tabla = @nomPrincipalC5

								
				IF @@ROWCOUNT = 0
				BREAK;


				DECLARE @text5 varchar(max)
				SET @text5 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnas5
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))
				
				SELECT *
				INTO #NomColumna5
				FROM STRING_SPLIT(@observacionC5, ',',1)
	
				SET @nombreCol1Cod5 = (select value from #NomColumna5 where ordinal=1)
				SET @nombreCol2Cod5 = (select value from #NomColumna5 where ordinal=2)
				SET @nombreCol3Cod5 = (select value from #NomColumna5 where ordinal=3)
				SET @nombreCol4Cod5 = (select value from #NomColumna5 where ordinal=4)
				SET @nombreCol5Cod5 = (select value from #NomColumna5 where ordinal=5)
				

				IF OBJECT_ID('tempdb..##RESULTADO5') IS NOT NULL
				BEGIN		
				IF (SELECT COUNT (*) FROM ##RESULTADO5)> 0
					SET @CreateTABLEC5 =N'SELECT ' + @text5 + 
					' FROM ' + @nombreTableC5 + 
					' WHERE '+ @nombreCol1Cod5 +'= ''' + @codigoC5 + ''' AND ' + @nombreCol2Cod5 + ' = ''' + @codigo5C2 + ''''+
					' AND ' + @nombreCol3Cod5 + ' = ''' + @codigo5C3 + '''' + ' AND ' +@nombreCol4Cod5 + ' = '''+ @codigo5C4 + '''' +
					' AND ' +@nombreCol5Cod5 + ' = '''+ @codigo5C5 + ''''
					
					INSERT INTO ##RESULTADO5
					EXECUTE sp_executeSQL @CreateTABLEC5
				END	

				IF OBJECT_ID('tempdb..##RESULTADO5') IS NULL
				BEGIN		

					SET @CreateTABLEC5 =N'SELECT ' + @text5 + 
					' INTO ##RESULTADO5 ' +  
					' FROM ' + @nombreTableC5 + 
					' WHERE '+ @nombreCol1Cod5 +'= ''' + @codigoC5 + ''' AND ' + @nombreCol2Cod5 + ' = ''' + @codigo5C2 + ''''+
					' AND ' + @nombreCol3Cod5 + ' = ''' + @codigo5C3 + '''' + ' AND ' +@nombreCol4Cod5 + ' = '''+ @codigo5C4 + '''' +
					' AND ' +@nombreCol5Cod5 + ' = '''+ @codigo5C5 + ''''
					
					EXECUTE sp_executeSQL @CreateTABLEC5											
				END
				
				
				DROP TABLE #NomColumna5
				SET @secCod5 +=1
			END

			IF OBJECT_ID('tempdb..##RESULTADO5') IS NOT NULL
			BEGIN
							
				IF(SELECT COUNT(*) FROM ##RESULTADO5)>0
				BEGIN
					DECLARE @Columns NVARCHAR(MAX);
					DECLARE @Sql NVARCHAR(MAX);								


					-- Obtener los nombres de las columnas de la tabla especificada
					SET @Columns = (SELECT STRING_AGG(CAST(QUOTENAME(NAME) AS varchar(MAX)), ', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO5')) 

					SET @Sql = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(NAME) AS varchar(MAX)) + '), ''0'') AS ' + CAST(QUOTENAME(NAME) AS varchar(MAX)), 
						', ') 
					FROM TempDB.SYS.COLUMNS 
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO5')) 

					-- Ejecutar la consulta dinámica y obtener el resultado en formato JSON
					SET @Sql ='SELECT '''+ @nomPrincipalC5 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql + ' FROM ##RESULTADO5 FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql;
				END
								
				DROP TABLE ##RESULTADO5

			END
			TRUNCATE TABLE #migracionCodigo5
		END
		DROP TABLE #columnas5
		SET @secC5 += 1
	END

	DROP TABLE #migracionCodigo5
	
END

IF @accion = 'U'
BEGIN
	

		UPDATE temp_registroMigracion SET FechaModificacion = GETDATE(), status = 2
		WHERE tipo = @tipoU AND nombre_table=@nombreTableU AND status=1


END

IF @accion ='UC'
BEGIN
	IF @codigoTipo = '1'
	BEGIN
		

		SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
		INTO #tablasCU1
		FROM temp_registroMigracion 
		WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NULL AND codigo3 IS  NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
		GROUP BY nombre_table,tipo,observacion

		DECLARE @contCU1 int =0, @secCU1 int =1
	
		SET @contCU1 = (SELECT COUNT (*) FROM #tablasCU1)
		
		WHILE @contCU1 >= @secCU1
		BEGIN

		DECLARE @nomPrincipalCU1 varchar(max)

		SELECT @nomPrincipalCU1=nombre_table 
		FROM #tablasCU1 WHERE id = @secCU1			

		SELECT COLUMN_NAME
				INTO #columnasU1
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nomPrincipalCU1
				ORDER BY ORDINAL_POSITION


		IF (
			SELECT count(observacion)
			FROM #tablasCU1 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalCU1
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 1
		BEGIN

		DECLARE @contU1 int =0, @secU1 int =1


		INSERT INTO #migracionCodigoU1(nombre_tabla,tipo,codigo,observacion,codigoMigracion)
		SELECT  nombre_table, tipo,codigo,REPLACE(observacion, ' ', '') AS observacion,id
		FROM temp_registroMigracion 
		WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NULL AND codigo3 IS  NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
		AND TIPO = @tipoU AND nombre_table= @nomPrincipalCU1
	
		
		SELECT @contU1=COUNT(*) FROM #migracionCodigoU1

		DECLARE @tipoCU1 varchar(5)='',
		@nombreTableCU1 varchar(200)='',
		@observacionCU1 varchar(200)='',
		@codigoCU1 varchar(200)='',						
		@CreateTABLECU1 NVARCHAR(max) = N'',
		@nombreCol1CodU1 varchar(max) = '',						
		@idCodMigracionU1 varchar(10) = ''

		

		WHILE @contU1 >=@secU1
			BEGIN	
				
				SELECT 
				@nombreTableCU1=nombre_tabla, 
				@tipoCU1=tipo,
				@codigoCU1=codigo,
				@observacionCU1=observacion,
				@idCodMigracionU1=codigoMigracion
				FROM #migracionCodigoU1 
				WHERE id = @secU1 AND nombre_tabla = @nomPrincipalCU1
				

				IF @@ROWCOUNT = 0
				BREAK;

				

				DECLARE @textU1 varchar(max)
				SET @textU1 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnasU1
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))


				SELECT *
				INTO #NomColumnaU1
				FROM STRING_SPLIT(@observacionCU1, ',',1)

				SET @nombreCol1CodU1 = (select value from #NomColumnaU1 where ordinal=1)

				SET @textU1 = REPLACE(@textU1,@nombreCol1CodU1 +',','')

				INSERT INTO #camposWhere(NombreCampo1,codigo1)
							VALUES(@nombreCol1CodU1,@codigoCU1)
				


				IF OBJECT_ID('tempdb..##RESULTADOU1') IS NOT NULL
				BEGIN		

					SET @CreateTABLECU1 =N'SELECT ' + @textU1 + 
					' FROM ' + @nombreTableCU1 + 
					' WHERE '+ @nombreCol1CodU1 +'= ''' + @codigoCU1 + ''''

					INSERT INTO ##RESULTADOU1
					EXECUTE sp_executeSQL @CreateTABLECU1
				END	

				IF OBJECT_ID('tempdb..##RESULTADOU1') IS NULL
				BEGIN		

					SET @CreateTABLECU1 =N'SELECT ' + @textU1 + 
					' INTO ##RESULTADOU1 ' +  
					' FROM ' + @nombreTableCU1 + 
					' WHERE '+ @nombreCol1CodU1 +'= ''' + @codigoCU1 + ''''		

					EXECUTE sp_executeSQL @CreateTABLECU1								
					
					
				END
						
				
				DROP TABLE #NomColumnaU1
				SET @secU1 = @secU1 +1
		END

				DECLARE @SqlU NVARCHAR(MAX);	
				SET @SqlU = 'SELECT '''+ @nomPrincipalCU1 + ''' AS tabla, ' 
				+ '(SELECT codigo1 AS ' + @nombreCol1CodU1 + ' FROM #camposWhere FOR JSON PATH) AS filtros,'
				+	'((SELECT * FROM ##RESULTADOU1 FOR JSON PATH)) AS datos FOR JSON PATH';

				EXEC sp_executesql @SqlU;
	
				DROP TABLE ##RESULTADOU1

			TRUNCATE TABLE #camposWhere
			TRUNCATE TABLE #migracionCodigoU1
		END		
		DROP TABLE #columnasU1
		
		SET @secCU1 += 1
		END
		
		
	END
	
	
	--IF @codigoTipo = '2'
	--BEGIN
	--	SELECT  codigo,nombre_table,codigo2,codigo3,codigo4,codigo5,codigo6,observacion,[status] 
	--	FROM temp_registroMigracion 
	--	WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS  NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
	--END
	
	--IF @codigoTipo = '3'
	--BEGIN
	--	SELECT  codigo,nombre_table,codigo2,codigo3,codigo4,codigo5,codigo6,observacion,[status] 
	--	FROM temp_registroMigracion 
	--	WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
	--END
	
	--IF @codigoTipo = '4'
	--BEGIN
	--	SELECT  codigo,nombre_table,codigo2,codigo3,codigo4,codigo5,codigo6,observacion,[status] 
	--	FROM temp_registroMigracion 
	--	WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS  NULL
	--END
	
	--IF @codigoTipo = '5'
	--BEGIN
	--	SELECT  codigo,nombre_table,codigo2,codigo3,codigo4,codigo5,codigo6,observacion,[status] 
	--	FROM temp_registroMigracion 
	--	WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS NOT NULL
	--END
END

END