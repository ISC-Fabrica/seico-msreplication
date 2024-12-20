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
IF OBJECT_ID('tempdb..##RESULTADO4') IS NOT NULL
		DROP TABLE ##RESULTADO4
IF OBJECT_ID('tempdb..##RESULTADO5') IS NOT NULL
		DROP TABLE ##RESULTADO5
IF OBJECT_ID('tempdb..##RESULTADOU') IS NOT NULL
		DROP TABLE ##RESULTADOU
IF OBJECT_ID('tempdb..##RESULTADOU2') IS NOT NULL
		DROP TABLE ##RESULTADOU2

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

CREATE TABLE #migracionCodigoU2(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	codigo2 varchar(200),
	observacion varchar(max)
)

CREATE TABLE #migracionCodigoU3(
	id int identity(1,1),
	codigoMigracion int,
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(200),
	codigo2 varchar(200),
	codigo3 varchar(200),
	observacion varchar(max)
)
CREATE TABLE #migracionCodigoU4(
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
CREATE TABLE #migracionCodigoU5(
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

ALTER TABLE #camposWhere
ALTER COLUMN codigo1 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS;

ALTER TABLE #camposWhere
ALTER COLUMN codigo2 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS;

ALTER TABLE #camposWhere
ALTER COLUMN codigo3 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS;

ALTER TABLE #camposWhere
ALTER COLUMN codigo4 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS;

ALTER TABLE #camposWhere
ALTER COLUMN codigo5 VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS;

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

				IF (LEN(@codigo)>19)
						SET @codigo = 'CONVERT(datetime,'''+@codigo+''',121)'
				ELSE
					SET @codigo = '''' + @codigo + ''''
	
				IF OBJECT_ID('tempdb..##RESULTADO') IS NOT NULL
				BEGIN
					IF (SELECT COUNT (1) FROM ##RESULTADO)> 0
					SET @CreateTABLE =N'SELECT ' + @text + 
					' FROM ' + @nombreTable + ' WHERE ' + @observacion+'=' + @codigo
										
					INSERT INTO ##RESULTADO
					EXECUTE sp_executeSQL @CreateTABLE
				END	

				IF OBJECT_ID('tempdb..##RESULTADO') IS NULL
				BEGIN		
					SET @CreateTABLE =N'SELECT ' + @text +
					' INTO ##RESULTADO FROM ' + @nombreTable + ' WHERE ' + @observacion+'=' + @codigo			
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

					CREATE TABLE #DatosRegistros1(
					id int identity(1,1),
					columna varchar(max),
					valorDefault varchar(max)
					)
					
					SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
					INTO #TIPODATO1
					FROM TempDB.SYS.COLUMNS a
					INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO') AND is_identity = 0

					DECLARE @contTipo1 int = 0, @secTipo1 int = 1

					SET @contTipo1 = (SELECT COUNT(*) FROM #TIPODATO1)
					WHILE @contTipo1 >= @secTipo1
					BEGIN
						DECLARE @nombre1 varchar(max)='', @tipoDato1 varchar(max)='', @ValorDefault1 VARCHAR(MAX)=''
						
						SELECT 
						@nombre1=columna,
						@tipoDato1=tipo 
						FROM #TIPODATO1 WHERE id = @secTipo1
						
						IF @@ROWCOUNT = 0
						BREAK;

						IF @TipoDato1 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
							SET @ValorDefault1 = '0';  -- Valor por defecto numérico
						ELSE IF @TipoDato1 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
							SET @ValorDefault1 = '''''' ;  -- Valor por defecto texto
						ELSE IF @TipoDato1 IN ('datetime', 'date', 'time')  -- Tipos de fecha
							SET @ValorDefault1 = '''1900-01-01''' ;  -- Valor por defecto fecha
						ELSE
							SET @ValorDefault1 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
						insert into #DatosRegistros1 (columna,valorDefault)
												VALUES(@nombre1,@ValorDefault1)

						SET @secTipo1 +=1
					END

					 SET @Sql1 = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
						', ') 
					FROM #DatosRegistros1)

				
					SET @Sql1 ='SELECT '''+ @nomPrincipal + ''' AS tabla, '+				
					'((SELECT  ' + @Sql1 + ' FROM ##RESULTADO FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql1;

					DROP TABLE #DatosRegistros1
					DROP TABLE  #TIPODATO1
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
			
				IF (LEN(@codigoC2)>19)
						SET @codigoC2 = 'CONVERT(datetime,'''+@codigoC2+''',121)'
				ELSE
					SET @codigoC2 = '''' + @codigoC2 + ''''

				IF (LEN(@codigo2C2)>19)
						SET @codigo2C2 = 'CONVERT(datetime,'''+@codigo2C2+''',121)'
				ELSE
					SET @codigo2C2 = '''' + @codigo2C2 + ''''
								
	
				IF OBJECT_ID('tempdb..##RESULTADO2') IS NOT NULL
				BEGIN	
					IF (SELECT COUNT (1) FROM ##RESULTADO2)> 0
					BEGIN
						SET @CreateTABLEC2 =N'SELECT ' + @text2 +
						' FROM ' + @nombreTableC2 + 
						' WHERE '+ @nombreColumna1 +'= ' + @codigoC2 + ' AND ' + @nombreColumna2 + ' = ' + @codigo2C2 
					END
					ELSE
					BEGIN
						SET @CreateTABLEC2 =N'SELECT ' + @text2 + 
						' FROM ' + @nombreTableC2 + 
						' WHERE '+ @nombreColumna1 +'= ' + @codigoC2 + ' AND ' + @nombreColumna2 + ' = ' + @codigo2C2					
					END

					INSERT INTO ##RESULTADO2
					EXECUTE sp_executeSQL @CreateTABLEC2
				END	

				IF OBJECT_ID('tempdb..##RESULTADO2') IS NULL
				BEGIN		
					SET @CreateTABLEC2 =N'SELECT ' + @text2 + 
					' INTO ##RESULTADO2 ' +
					' FROM ' + @nombreTableC2 + 
					' WHERE '+ @nombreColumna1 +'= ' + @codigoC2 + ' AND ' + @nombreColumna2 + ' = ' + @codigo2C2 	
				
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

					CREATE TABLE #DatosRegistros2(
					id int identity(1,1),
					columna varchar(max),
					valorDefault varchar(max)
					)
					
					SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
					INTO #TIPODATO2
					FROM TempDB.SYS.COLUMNS a
					INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO2') AND is_identity = 0

					DECLARE @contTipo2 int = 0, @secTipo2 int = 1					
		

					SET @contTipo2 = (SELECT COUNT(*) FROM #TIPODATO2)
					WHILE @contTipo2 >= @secTipo2
					BEGIN
						DECLARE @nombre2 varchar(max)='', @tipoDato2 varchar(max)='', @ValorDefault2 VARCHAR(MAX)=''
						
						SELECT 
						@nombre2=columna,
						@tipoDato2=tipo 
						FROM #TIPODATO2 WHERE id = @secTipo2
						
						IF @@ROWCOUNT = 0
						BREAK;

						IF @TipoDato2 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
							SET @ValorDefault2 = '0';  -- Valor por defecto numérico
						ELSE IF @TipoDato2 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
							SET @ValorDefault2 = '''''' ;  -- Valor por defecto texto
						ELSE IF @TipoDato2 IN ('datetime', 'date', 'time')  -- Tipos de fecha
							SET @ValorDefault2 = '''1900-01-01''' ;  -- Valor por defecto fecha
						ELSE
							SET @ValorDefault2 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
						insert into #DatosRegistros2 (columna,valorDefault)
												VALUES(@nombre2,@ValorDefault2)

						SET @secTipo2 +=1
					END


					 SET @Sql2 = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
						', ') 
					FROM #DatosRegistros2)

				
					SET @Sql2 ='SELECT '''+ @nomPrincipalC2 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql2 + ' FROM ##RESULTADO2 FOR JSON PATH)) AS datos FOR JSON PATH';
				

					EXEC sp_executesql @Sql2;

					DROP TABLE #DatosRegistros2
					DROP TABLE  #TIPODATO2
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

				IF (LEN(@codigoC3)>19)
						SET @codigoC3 = 'CONVERT(datetime,'''+@codigoC3+''',121)'
				ELSE
					SET @codigoC3 = '''' + @codigoC3 + ''''

				IF (LEN(@codigo2C3)>19)
						SET @codigo2C3 = 'CONVERT(datetime,'''+@codigo2C3+''',121)'
				ELSE
					SET @codigo2C3 = '''' + @codigo2C3 + ''''


				IF (LEN(@codigo3C3)>19)
						SET @codigo3C3 = 'CONVERT(datetime,'''+@codigo3C3+''',121)'
				ELSE
					SET @codigo3C3 = '''' + @codigo3C3 + ''''



				IF OBJECT_ID('tempdb..##RESULTADO3') IS NOT NULL
				BEGIN									
					
					IF (SELECT COUNT (1) FROM ##RESULTADO3)> 0
					SET @CreateTABLEC3 =N'SELECT ' + @text3 + 
					' FROM ' + @nombreTableC3 + 
					' WHERE '+ @nombreCol1Cod3 +'= ' + @codigoC3 + ' AND ' + @nombreCol2Cod3 + ' = ' + @codigo2C3 + 
					' AND ' + @nombreCol3Cod3 + ' = ' + @codigo3C3
					
				
					INSERT INTO ##RESULTADO3
					EXECUTE sp_executeSQL @CreateTABLEC3

					
				END	
				
				IF OBJECT_ID('tempdb..##RESULTADO3') IS NULL
				BEGIN		
					SET @CreateTABLEC3 =N'SELECT ' + @text3 +
					' INTO ##RESULTADO3 ' +  
					' FROM ' + @nombreTableC3 + 
					' WHERE '+ @nombreCol1Cod3 +'= ' + @codigoC3 + ' AND ' + @nombreCol2Cod3 + ' = ' + @codigo2C3 +
					' AND ' + @nombreCol3Cod3 + ' = ' + @codigo3C3									

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

				CREATE TABLE #DatosRegistros3(
					id int identity(1,1),
					columna varchar(max),
					valorDefault varchar(max)
					)
					
					SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
					INTO #TIPODATO3
					FROM TempDB.SYS.COLUMNS a
					INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO3') AND is_identity = 0

					DECLARE @contTipo3 int = 0, @secTipo3 int = 1

					SET @contTipo3 = (SELECT COUNT(*) FROM #TIPODATO3)
					WHILE @contTipo3 >= @secTipo3
					BEGIN
						DECLARE @nombre3 varchar(max)='', @tipoDato3 varchar(max)='', @ValorDefault3 VARCHAR(MAX)=''
						
						SELECT 
						@nombre3=columna,
						@tipoDato3=tipo 
						FROM #TIPODATO3 WHERE id = @secTipo3
						
						IF @@ROWCOUNT = 0
						BREAK;

						IF @TipoDato3 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
							SET @ValorDefault3 = '0';  -- Valor por defecto numérico
						ELSE IF @TipoDato3 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
							SET @ValorDefault3 = '''''' ;  -- Valor por defecto texto
						ELSE IF @TipoDato3 IN ('datetime', 'date', 'time')  -- Tipos de fecha
							SET @ValorDefault3 = '''1900-01-01''' ;  -- Valor por defecto fecha
						ELSE
							SET @ValorDefault3 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
						insert into #DatosRegistros3 (columna,valorDefault)
												VALUES(@nombre3,@ValorDefault3)

						SET @secTipo3 +=1
					END


					 SET @Sql3 = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
						', ') 
					FROM #DatosRegistros3)

				
					SET @Sql3 ='SELECT '''+ @nomPrincipalC3 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql3 + ' FROM ##RESULTADO3 FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql3;

					DROP TABLE #DatosRegistros3
					DROP TABLE  #TIPODATO3
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
				
				IF (LEN(@codigoC4)>19)
						SET @codigoC4 = 'CONVERT(datetime,'''+@codigoC4+''',121)'
				ELSE
					SET @codigoC4 = '''' + @codigoC4 + ''''

				IF (LEN(@codigo4C2)>19)
						SET @codigo4C2 = 'CONVERT(datetime,'''+@codigo4C2+''',121)'
				ELSE
					SET @codigo4C2 = '''' + @codigo4C2 + ''''


				IF (LEN(@codigo4C3)>19)
						SET @codigo4C3 = 'CONVERT(datetime,'''+@codigo4C3+''',121)'
				ELSE
					SET @codigo4C3 = '''' + @codigo4C3 + ''''

				IF (LEN(@codigo4C4)>19)
					SET @codigo4C4 = 'CONVERT(datetime,'''+@codigo4C4+''',121)'
				ELSE
					SET @codigo4C4 = '''' + @codigo4C4 + ''''

				IF OBJECT_ID('tempdb..##RESULTADO4') IS NOT NULL
				BEGIN
					IF (SELECT COUNT (1) FROM ##RESULTADO4)> 0
					SET @CreateTABLEC4 =N'SELECT ' + @text4 + 
					' FROM ' + @nombreTableC4 + 
					' WHERE '+ @nombreCol1Cod4 +'= ' + @codigoC4 + ' AND ' + @nombreCol2Cod4 + ' = ' + @codigo4C2 + 					
					' AND ' + @nombreCol3Cod4 + ' = ' + @codigo4C3 + ' AND ' +@nombreCol3Cod4 + ' = '+ @codigo4C4 					


					INSERT INTO ##RESULTADO4
					EXECUTE sp_executeSQL @CreateTABLEC4

					
				END	

				IF OBJECT_ID('tempdb..##RESULTADO4') IS NULL
				BEGIN		

					SET @CreateTABLEC4 =N'SELECT ' + @text4 +
					' INTO ##RESULTADO4 ' +  
					' FROM ' + @nombreTableC4  +
					' WHERE '+ @nombreCol1Cod4 +'= ' + @codigoC4 + ' AND ' + @nombreCol2Cod4 + ' = ' + @codigo4C2 +
					' AND ' + @nombreCol3Cod4 + ' = ' + @codigo4C3 + ' AND ' +@nombreCol3Cod4 + ' = '+ @codigo4C3 			
						
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

					CREATE TABLE #DatosRegistros4(
					id int identity(1,1),
					columna varchar(max),
					valorDefault varchar(max)
					)
					
					SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
					INTO #TIPODATO4
					FROM TempDB.SYS.COLUMNS a
					INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO4') AND is_identity = 0

					DECLARE @contTipo4 int = 0, @secTipo4 int = 1

					SET @contTipo4 = (SELECT COUNT(*) FROM #TIPODATO4)
					WHILE @contTipo4 >= @secTipo4 
					BEGIN
						DECLARE @nombre4 varchar(max)='', @tipoDato4 varchar(max)='', @ValorDefault4 VARCHAR(MAX)=''
						
						SELECT 
						@nombre4=columna,
						@tipoDato4=tipo 
						FROM #TIPODATO4 WHERE id = @secTipo4
						
						IF @@ROWCOUNT = 0
						BREAK;

						IF @TipoDato4 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
							SET @ValorDefault4 = '0';  -- Valor por defecto numérico
						ELSE IF @TipoDato4 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
							SET @ValorDefault4 = '''''' ;  -- Valor por defecto texto
						ELSE IF @TipoDato4 IN ('datetime', 'date', 'time')  -- Tipos de fecha
							SET @ValorDefault4 = '''1900-01-01''' ;  -- Valor por defecto fecha
						ELSE
							SET @ValorDefault4 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
						insert into #DatosRegistros4 (columna,valorDefault)
												VALUES(@nombre4,@ValorDefault4)

						SET @secTipo4 +=1
					END


					 SET @Sql4 = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
						', ') 
					FROM #DatosRegistros4)

				
					SET @Sql4 ='SELECT '''+ @nomPrincipalC4 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql4 + ' FROM ##RESULTADO4 FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql4;
					DROP TABLE #DatosRegistros4
					DROP TABLE  #TIPODATO4
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


				IF (LEN(@codigoC5)>19)
						SET @codigoC5 = 'CONVERT(datetime,'''+@codigoC5+''',121)'
				ELSE
					SET @codigoC5 = '''' + @codigoC5 + ''''

				IF (LEN(@codigo5C2)>19)
						SET @codigo5C2 = 'CONVERT(datetime,'''+@codigo5C2+''',121)'
				ELSE
					SET @codigo5C2 = '''' + @codigo5C2 + ''''


				IF (LEN(@codigo5C3)>19)
						SET @codigo5C3 = 'CONVERT(datetime,'''+@codigo5C3+''',121)'
				ELSE
					SET @codigo5C3 = '''' + @codigo5C3 + ''''

				IF (LEN(@codigo5C4)>19)
					SET @codigo5C4 = 'CONVERT(datetime,'''+@codigo5C4+''',121)'
				ELSE
					SET @codigo5C4 = '''' + @codigo5C4 + ''''

				IF (LEN(@codigo5C5)>19)
					SET @codigo5C5 = 'CONVERT(datetime,'''+@codigo5C5+''',121)'
				ELSE
					SET @codigo5C5 = '''' + @codigo5C5 + ''''

				IF OBJECT_ID('tempdb..##RESULTADO5') IS NOT NULL
				BEGIN		
				IF (SELECT COUNT (*) FROM ##RESULTADO5)> 0
					SET @CreateTABLEC5 =N'SELECT ' + @text5 + 
					' FROM ' + @nombreTableC5 + 
					' WHERE '+ @nombreCol1Cod5 +'= ' + @codigoC5 + ' AND ' + @nombreCol2Cod5 + ' = ' + @codigo5C2 +
					' AND ' + @nombreCol3Cod5 + ' = ' + @codigo5C3 + ' AND ' +@nombreCol4Cod5 + ' = '+ @codigo5C4 +
					' AND ' +@nombreCol5Cod5 + ' = '+ @codigo5C5
					
					INSERT INTO ##RESULTADO5
					EXECUTE sp_executeSQL @CreateTABLEC5

				END	

				IF OBJECT_ID('tempdb..##RESULTADO5') IS NULL
				BEGIN		

					SET @CreateTABLEC5 =N'SELECT ' + @text5 + 
					' INTO ##RESULTADO5 ' +  
					' FROM ' + @nombreTableC5 + 
					' WHERE '+ @nombreCol1Cod5 +'= ' + @codigoC5 + ' AND ' + @nombreCol2Cod5 + ' = ' + @codigo5C2 + 
					' AND ' + @nombreCol3Cod5 + ' = ' + @codigo5C3  + ' AND ' +@nombreCol4Cod5 + ' = '+ @codigo5C4 +
					' AND ' +@nombreCol5Cod5 + ' = '+ @codigo5C5

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

					CREATE TABLE #DatosRegistros(
					id int identity(1,1),
					columna varchar(max),
					valorDefault varchar(max)
					)
					
					SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
					INTO #TIPODATO
					FROM TempDB.SYS.COLUMNS a
					INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADO5') AND is_identity = 0

					DECLARE @contTipo int = 0, @secTipo int = 1

					SET @contTipo = (SELECT COUNT(*) FROM #TIPODATO)
					WHILE @contTipo >= @secTipo 
					BEGIN
						DECLARE @nombre varchar(max)='', @tipoDato varchar(max)='', @ValorDefault VARCHAR(MAX)=''
						
						SELECT 
						@nombre=columna,
						@tipoDato=tipo 
						FROM #TIPODATO WHERE id = @secTipo
						
						IF @@ROWCOUNT = 0
						BREAK;

						IF @TipoDato IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
							SET @ValorDefault = '0';  -- Valor por defecto numérico
						ELSE IF @TipoDato IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
							SET @ValorDefault = '''''' ;  -- Valor por defecto texto
						ELSE IF @TipoDato IN ('datetime', 'date', 'time')  -- Tipos de fecha
							SET @ValorDefault = '''1900-01-01''' ;  -- Valor por defecto fecha
						ELSE
							SET @ValorDefault = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
						insert into #DatosRegistros (columna,valorDefault)
												VALUES(@nombre,@ValorDefault)

						SET @secTipo +=1
					END


					 SET @Sql = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
						', ') 
					FROM #DatosRegistros)

				
					SET @Sql ='SELECT '''+ @nomPrincipalC5 + ''' AS tabla, '+				
					'((SELECT  ' + @Sql + ' FROM ##RESULTADO5 FOR JSON PATH)) AS datos FOR JSON PATH';

					EXEC sp_executesql @Sql;
					DROP TABLE #DatosRegistros
					DROP TABLE  #TIPODATO
					
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


		SELECT c.name AS COLUMN_NAME
		INTO #columnasU1
		FROM sys.columns c
		INNER JOIN sys.tables t ON c.object_id = t.object_id
		WHERE t.name = @nomPrincipalCU1 
		AND c.is_identity = 0
		order by column_id asc;


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

				--SET @textU1 = REPLACE(@textU1,@nombreCol1CodU1 +',','')

				INSERT INTO #camposWhere(NombreCampo1,codigo1)
							VALUES(@nombreCol1CodU1,@codigoCU1)
				
				IF (LEN(@codigoCU1)>19)
						SET @codigoCU1 = 'CONVERT(datetime,'''+@codigoCU1+''',121)'
				ELSE
					SET @codigoCU1 = '''' + @codigoCU1 + ''''


				IF OBJECT_ID('tempdb..##RESULTADOU1') IS NOT NULL
				BEGIN		

					SET @CreateTABLECU1 =N'SELECT ' + @textU1 + 
					' FROM ' + @nombreTableCU1 + 
					' WHERE '+ @nombreCol1CodU1 +'= ' + @codigoCU1

					INSERT INTO ##RESULTADOU1
					EXECUTE sp_executeSQL @CreateTABLECU1
				END	

				IF OBJECT_ID('tempdb..##RESULTADOU1') IS NULL
				BEGIN		

					SET @CreateTABLECU1 =N'SELECT ' + @textU1 + 
					' INTO ##RESULTADOU1 ' +  
					' FROM ' + @nombreTableCU1 + 
					' WHERE '+ @nombreCol1CodU1 +'= ' + @codigoCU1		

					EXECUTE sp_executeSQL @CreateTABLECU1																		
				END
						
				
				DROP TABLE #NomColumnaU1
				SET @secU1 = @secU1 +1
		END					

		IF OBJECT_ID('tempdb..##RESULTADOU1') IS NOT NULL
		BEGIN
			IF(SELECT COUNT(*) FROM ##RESULTADOU1)>0
				BEGIN
					DECLARE @ColumnsU NVARCHAR(MAX);
					DECLARE @SqlU NVARCHAR(MAX);								

					CREATE TABLE #DatosRegistrosU(
					id int identity(1,1),
					columna varchar(max),
					valorDefault varchar(max)
					)
					
					SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
					INTO #TIPODATOU
					FROM TempDB.SYS.COLUMNS a
					INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
					WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADOU1') AND is_identity = 0

					DECLARE @contTipoU1 int = 0, @secTipoU1 int = 1

					SET @contTipoU1 = (SELECT COUNT(*) FROM #TIPODATOU)
					WHILE @contTipoU1 >= @secTipoU1
					BEGIN
						DECLARE @nombreU1 varchar(max)='', @tipoDatoU1 varchar(max)='', @ValorDefaultU1 VARCHAR(MAX)=''
						
						SELECT 
						@nombreU1=columna,
						@tipoDatoU1=tipo 
						FROM #TIPODATOU WHERE id = @secTipoU1
						
						IF @@ROWCOUNT = 0
						BREAK;

						IF @TipoDatoU1 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
							SET @ValorDefaultU1 = '0';  -- Valor por defecto numérico
						ELSE IF @TipoDatoU1 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
							SET @ValorDefaultU1 = '''''' ;  -- Valor por defecto texto
						ELSE IF @TipoDatoU1 IN ('datetime', 'date', 'time')  -- Tipos de fecha
							SET @ValorDefaultU1 = '''1900-01-01''' ;  -- Valor por defecto fecha
						ELSE
							SET @ValorDefaultU1 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
						insert into #DatosRegistrosU (columna,valorDefault)
												VALUES(@nombreU1,@ValorDefaultU1)

						SET @secTipoU1 +=1
					END

					 SET @SqlU = (SELECT STRING_AGG(
				
						'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
						', ') 
					FROM #DatosRegistrosU)
			

				
					DECLARE @COLUMNAS1 varchar(max)=''

					SET @COLUMNAS1 = (SELECT STRING_AGG(CAST(columna AS varchar(MAX)),', ') 
					FROM #DatosRegistrosU)
												
					SET @SqlU = 'SELECT '''+ @nomPrincipalCU1 + ''' AS tabla, ' 
					+ '(SELECT codigo1 AS ' + @nombreCol1CodU1 
					+' from ##RESULTADOU1 a'
					+' inner join #camposWhere b on a.'+@nombreCol1CodU1+' = b.codigo1 '
					+' group by codigo1 FOR JSON PATH) AS filtros,'				
					+	'((SELECT '+ @textU1
					+ ' from ##RESULTADOU1 a'
					+' inner join #camposWhere b on a.'+@nombreCol1CodU1+' = b.codigo1 '
					+' GROUP BY ' + @COLUMNAS1 + ' FOR JSON PATH)) AS datos FOR JSON PATH';			

					EXEC sp_executesql @SqlU;


					DROP TABLE #DatosRegistrosU
					DROP TABLE  #TIPODATOU
				END
				
			DROP TABLE ##RESULTADOU1
		END

			TRUNCATE TABLE #camposWhere
			TRUNCATE TABLE #migracionCodigoU1
		END		
		DROP TABLE #columnasU1
		
		SET @secCU1 += 1
		END
		
		
	END
		
	IF @codigoTipo = '2'
	BEGIN
		

		SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
		INTO #tablasCU2
		FROM temp_registroMigracion 
		WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS  NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
		GROUP BY nombre_table,tipo,observacion

		DECLARE @contCU2 int =0, @secCU2 int =1
	
		SET @contCU2 = (SELECT COUNT (*) FROM #tablasCU2)
	
		WHILE @contCU2 >= @secCU2
		BEGIN

		DECLARE @nomPrincipalCU2 varchar(max)

		SELECT @nomPrincipalCU2=nombre_table 
		FROM #tablasCU2 WHERE id = @secCU2			

		SELECT c.name AS COLUMN_NAME
		INTO #columnasU2
		FROM sys.columns c
		INNER JOIN sys.tables t ON c.object_id = t.object_id
		WHERE t.name = @nomPrincipalCU2 
		AND c.is_identity = 0
		order by column_id asc;


		IF (
			SELECT count(observacion)
			FROM #tablasCU2 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalCU2
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 2
		BEGIN

		DECLARE @contU2 int =0, @secU2 int =1


		INSERT INTO #migracionCodigoU2(nombre_tabla,tipo,codigo,codigo2,observacion,codigoMigracion)
		SELECT  nombre_table, tipo,codigo,codigo2,REPLACE(observacion, ' ', '') AS observacion,id
		FROM temp_registroMigracion 
		WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS  NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
		AND TIPO = @tipoU AND nombre_table= @nomPrincipalCU2
	
		
		SELECT @contU2=COUNT(*) FROM #migracionCodigoU2

		DECLARE @tipoCU2 varchar(5)='',
		@nombreTableCU2 varchar(200)='',
		@observacionCU2 varchar(200)='',
		@codigoCU2 varchar(200)='',	
		@codigoCU22 varchar(200)='',	
		@CreateTABLECU2 NVARCHAR(max) = N'',
		@nombreCol1CodU2 varchar(max) = '',	
		@nombreCol2CodU2 varchar(max) = '',	
		@idCodMigracionU2 varchar(10) = ''

		

		WHILE @contU2 >=@secU2
			BEGIN	
				
				SELECT 
				@nombreTableCU2=nombre_tabla, 
				@tipoCU2=tipo,
				@codigoCU2=codigo,
				@codigoCU22=codigo2,
				@observacionCU2=observacion,
				@idCodMigracionU2=codigoMigracion
				FROM #migracionCodigoU2
				WHERE id = @secU2 AND nombre_tabla = @nomPrincipalCU2
				

				IF @@ROWCOUNT = 0
				BREAK;

				

				DECLARE @textU2 varchar(max)
				SET @textU2 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnasU2
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))


				SELECT *
				INTO #NomColumnaU2
				FROM STRING_SPLIT(@observacionCU2, ',',1)

				SET @nombreCol1CodU2 = (select value from #NomColumnaU2 where ordinal=1)
				SET @nombreCol2CodU2 = (select value from #NomColumnaU2 where ordinal=2)						
				

				INSERT INTO #camposWhere(NombreCampo1,codigo1,NombreCampo2,codigo2)
							VALUES(@nombreCol1CodU2,@codigoCU2,@nombreCol2CodU2,@codigoCU22)				


				
				IF (LEN(@codigoCU2)>19)
						SET @codigoCU2 = 'CONVERT(datetime,'''+@codigoCU2+''',121)'
				ELSE
					SET @codigoCU2 = '''' + @codigoCU2 + ''''
				
				IF (LEN(@codigoCU22)>19)
						SET @codigoCU22 = 'CONVERT(datetime,'''+@codigoCU22+''',121)'
				ELSE
					SET @codigoCU22 = '''' + RTRIM(LTRIM(@codigoCU22)) + ''''

			

				IF OBJECT_ID('tempdb..##RESULTADOU2') IS NOT NULL
				BEGIN		
					SET @CreateTABLECU2 =N'SELECT ' + @textU2 + 					
						' FROM ' + @nombreTableCU2 + 
						' WHERE '+ @nombreCol1CodU2 +'= ' + @codigoCU2 + ' AND ' + 	@nombreCol2CodU2 + ' = '+ @codigoCU22

					INSERT INTO ##RESULTADOU2
					EXECUTE sp_executeSQL @CreateTABLECU2
				END	

				IF OBJECT_ID('tempdb..##RESULTADOU2') IS NULL
				BEGIN		

					SET @CreateTABLECU2 =N'SELECT ' + @textU2 + 
					' INTO ##RESULTADOU2 ' +  
					' FROM ' + @nombreTableCU2 + 
					' WHERE '+ @nombreCol1CodU2 +'= ' + @codigoCU2 + ' AND ' + 	@nombreCol2CodU2 + ' = '+ @codigoCU22	
					
					EXECUTE sp_executeSQL @CreateTABLECU2				
				END
										
				DROP TABLE #NomColumnaU2
				SET @secU2 = @secU2 +1
		END		
		
			IF OBJECT_ID('tempdb..##RESULTADOU2') IS NOT NULL
			BEGIN
				IF(SELECT COUNT(*) FROM ##RESULTADOU2)>0
					BEGIN
						DECLARE @ColumnsU2 NVARCHAR(MAX);
						DECLARE @SqlU2 NVARCHAR(MAX);								

						CREATE TABLE #DatosRegistrosU2(
						id int identity(1,1),
						columna varchar(max),
						valorDefault varchar(max)
						)
					
						SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
						INTO #TIPODATOU2
						FROM TempDB.SYS.COLUMNS a
						INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
						WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADOU2') AND is_identity = 0
				

						DECLARE @contTipoU2 int = 0, @secTipoU2 int = 1

						SET @contTipoU2 = (SELECT COUNT(*) FROM #TIPODATOU2)
						WHILE @contTipoU2 >= @secTipoU2
						BEGIN
							DECLARE @nombreU2 varchar(max)='', @tipoDatoU2 varchar(max)='', @ValorDefaultU2 VARCHAR(MAX)=''
						
							SELECT 
							@nombreU2=columna,
							@tipoDatoU2=tipo 
							FROM #TIPODATOU2 
							WHERE id = @secTipoU2
						
							IF @@ROWCOUNT = 0
							BREAK;

							IF @TipoDatoU2 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
								SET @ValorDefaultU2 = '0';  -- Valor por defecto numérico
							ELSE IF @TipoDatoU2 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
								SET @ValorDefaultU2 = '''''' ;  -- Valor por defecto texto
							ELSE IF @TipoDatoU2 IN ('datetime', 'date', 'time')  -- Tipos de fecha
								SET @ValorDefaultU2 = '''1900-01-01''' ;  -- Valor por defecto fecha
							ELSE
								SET @ValorDefaultU2 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
							insert into #DatosRegistrosU2 (columna,valorDefault)
													VALUES(@nombreU2,@ValorDefaultU2)

							SET @secTipoU2 +=1
						END

						SET @SqlU2 = (SELECT STRING_AGG(
				
							'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
							', ') 
						FROM #DatosRegistrosU2)

						DECLARE @COLUMNAS varchar(max)=''

						SET @COLUMNAS = (SELECT STRING_AGG(CAST(columna AS varchar(MAX)),', ') 
						FROM #DatosRegistrosU2)
												
					
				
						SET @SqlU2 = 'SELECT '''+ @nomPrincipalCU2 + ''' AS tabla, ' 
						+ '(SELECT codigo1 AS ' + @nombreCol1CodU2 + ', codigo2 AS ' + @nombreCol2CodU2 
						+' from ##RESULTADOU2 a'
						+' inner join #camposWhere b on a.'+@nombreCol1CodU2+' = b.codigo1  AND  a.' + @nombreCol2CodU2 +' = b.codigo2'
						+' group by codigo1,codigo2 FOR JSON PATH) AS filtros,'				
						+	'((SELECT '+ @textU2 
						+ ' from ##RESULTADOU2 a'
						+' inner join #camposWhere b on a.'+@nombreCol1CodU2+' = b.codigo1  AND  a.' + @nombreCol2CodU2 +' = b.codigo2'
						+' GROUP BY ' + @COLUMNAS + ' FOR JSON PATH)) AS datos FOR JSON PATH';						


						EXEC sp_executesql @SqlU2;
						
						DROP TABLE #DatosRegistrosU2
						DROP TABLE  #TIPODATOU2
					END				
			END

			DROP TABLE ##RESULTADOU2
			TRUNCATE TABLE #camposWhere
			TRUNCATE TABLE #migracionCodigoU2
		END		
		DROP TABLE #columnasU2
		SET @secCU2 += 1
		END
		
		
	END
	
	IF @codigoTipo = '3'
	BEGIN
		

		SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
		INTO #tablasCU3
		FROM temp_registroMigracion 
		WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
		GROUP BY nombre_table,tipo,observacion

		DECLARE @contCU3 int =0, @secCU3 int =1
	
		SET @contCU3 = (SELECT COUNT (*) FROM #tablasCU3)
		
		WHILE @contCU3 >= @secCU3
		BEGIN

		DECLARE @nomPrincipalCU3 varchar(max)

		SELECT @nomPrincipalCU3=nombre_table 
		FROM #tablasCU3 WHERE id = @secCU3			

		SELECT c.name AS COLUMN_NAME
		INTO #columnasU3
		FROM sys.columns c
		INNER JOIN sys.tables t ON c.object_id = t.object_id
		WHERE t.name = @nomPrincipalCU3 
		AND c.is_identity = 0
		order by column_id asc;


		IF (
			SELECT count(observacion)
			FROM #tablasCU3 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalCU3
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 3
		BEGIN

		DECLARE @contU3 int =0, @secU3 int =1


		INSERT INTO #migracionCodigoU3(nombre_tabla,tipo,codigo,codigo2,codigo3,observacion,codigoMigracion)
		SELECT  nombre_table, tipo,codigo,codigo2,codigo3,REPLACE(observacion, ' ', '') AS observacion,id
		FROM temp_registroMigracion 
		WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS  NULL AND codigo5 IS  NULL
		AND TIPO = @tipoU AND nombre_table= @nomPrincipalCU3
	
		
		SELECT @contU3=COUNT(*) FROM #migracionCodigoU3

		DECLARE @tipoCU3 varchar(5)='',
		@nombreTableCU3 varchar(200)='',
		@observacionCU3 varchar(200)='',
		@codigoCU31 varchar(200)='',
		@codigoCU32 varchar(200)='',
		@codigoCU33 varchar(200)='',	
		@CreateTABLECU3 NVARCHAR(max) = N'',
		@nombreCol1CodU3 varchar(max) = '',	
		@nombreCol2CodU3 varchar(max) = '',	
		@nombreCol3CodU3 varchar(max) = '',	
		@idCodMigracionU3 varchar(10) = ''

		

		WHILE @contU3 >=@secU3
			BEGIN	
				
				SELECT 
				@nombreTableCU3=nombre_tabla, 
				@tipoCU3=tipo,
				@codigoCU31=codigo,
				@codigoCU32=codigo2,
				@codigoCU33=codigo3,
				@observacionCU3=observacion,
				@idCodMigracionU3=codigoMigracion
				FROM #migracionCodigoU3
				WHERE id = @secU3 AND nombre_tabla = @nomPrincipalCU3			

				IF @@ROWCOUNT = 0
				BREAK;

				

				DECLARE @textU3 varchar(max)
				SET @textU3 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnasU3
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))


				SELECT *
				INTO #NomColumnaU3
				FROM STRING_SPLIT(@observacionCU3, ',',1)

				SET @nombreCol1CodU3 = (select value from #NomColumnaU3 where ordinal=1)
				SET @nombreCol2CodU3 = (select value from #NomColumnaU3 where ordinal=2)						
				SET @nombreCol3CodU3 = (select value from #NomColumnaU3 where ordinal=3)

				INSERT INTO #camposWhere(NombreCampo1,codigo1,NombreCampo2,codigo2,NombreCampo3,codigo3)
							VALUES(@nombreCol1CodU3,@codigoCU31,@nombreCol2CodU3,@codigoCU32,@nombreCol3CodU3,@codigoCU33)				

				
				IF (LEN(@codigoCU31)>19)
						SET @codigoCU31 = 'CONVERT(datetime,'''+@codigoCU31+''',121)'
				ELSE
					SET @codigoCU31 = '''' + @codigoCU31 + ''''
				
				IF (LEN(@codigoCU32)>19)
						SET @codigoCU32 = 'CONVERT(datetime,'''+@codigoCU32+''',121)'
				ELSE
					SET @codigoCU32 = '''' + RTRIM(LTRIM(@codigoCU32)) + ''''

				IF (LEN(@codigoCU33)>19)
						SET @codigoCU33 = 'CONVERT(datetime,'''+@codigoCU33+''',121)'
				ELSE
					SET @codigoCU33 = '''' + RTRIM(LTRIM(@codigoCU33)) + ''''

		
				IF OBJECT_ID('tempdb..##RESULTADOU3') IS NOT NULL
				BEGIN		
					SET @CreateTABLECU3 =N'SELECT ' + @textU3 + 
					' FROM ' + @nombreTableCU3 + 
					' WHERE '+ @nombreCol1CodU3 +'= ' + @codigoCU31 + ' AND ' + 	@nombreCol2CodU3 + ' = '+ @codigoCU32 + ' AND ' + @nombreCol3Cod3 + ' = ' + @codigoCU33	

					INSERT INTO ##RESULTADOU3
					EXECUTE sp_executeSQL @CreateTABLECU3
				END	

				IF OBJECT_ID('tempdb..##RESULTADOU3') IS NULL
				BEGIN		

					SET @CreateTABLECU3 =N'SELECT ' + @textU3 
					+' INTO ##RESULTADOU3 '   
					+' FROM ' + @nombreTableCU3 
					+' WHERE '+ @nombreCol1CodU3 +'= ' + @codigoCU31 + ' AND ' + 	@nombreCol2CodU3 + ' = '+ @codigoCU32 + ' AND ' + @nombreCol3CodU3 + ' = ' + @codigoCU33		
										
					EXECUTE sp_executeSQL @CreateTABLECU3				
				END
										
				DROP TABLE #NomColumnaU3
				SET @secU3 = @secU3 +1
		END		
		
			IF OBJECT_ID('tempdb..##RESULTADOU3') IS NOT NULL
			BEGIN
				IF(SELECT COUNT(*) FROM ##RESULTADOU3)>0
					BEGIN
						DECLARE @ColumnsU3 NVARCHAR(MAX);
						DECLARE @SqlU3 NVARCHAR(MAX);								

						CREATE TABLE #DatosRegistrosU3(
						id int identity(1,1),
						columna varchar(max),
						valorDefault varchar(max)
						)
					
						SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
						INTO #TIPODATOU3
						FROM TempDB.SYS.COLUMNS a
						INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
						WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADOU3') AND is_identity = 0
				

						DECLARE @contTipoU3 int = 0, @secTipoU3 int = 1

						SET @contTipoU3 = (SELECT COUNT(*) FROM #TIPODATOU3)
						WHILE @contTipoU3 >= @secTipoU3
						BEGIN
							DECLARE @nombreU3 varchar(max)='', @tipoDatoU3 varchar(max)='', @ValorDefaultU3 VARCHAR(MAX)=''
						
							SELECT 
							@nombreU3=columna,
							@tipoDatoU3=tipo 
							FROM #TIPODATOU3
							WHERE id = @secTipoU3
						
							IF @@ROWCOUNT = 0
							BREAK;

							IF @TipoDatoU3 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
								SET @ValorDefaultU3 = '0';  -- Valor por defecto numérico
							ELSE IF @TipoDatoU3 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
								SET @ValorDefaultU3 = '''''' ;  -- Valor por defecto texto
							ELSE IF @TipoDatoU3 IN ('datetime', 'date', 'time')  -- Tipos de fecha
								SET @ValorDefaultU3 = '''1900-01-01''' ;  -- Valor por defecto fecha
							ELSE
								SET @ValorDefaultU3 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
							insert into #DatosRegistrosU3 (columna,valorDefault)
													VALUES(@nombreU3,@ValorDefaultU3)

							SET @secTipoU3 +=1
						END

						SET @SqlU3 = (SELECT STRING_AGG(
				
							'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
							', ') 
						FROM #DatosRegistrosU3)

						DECLARE @COLUMNAS3 varchar(max)=''

						SET @COLUMNAS3 = (SELECT STRING_AGG(CAST(columna AS varchar(MAX)),', ') 
						FROM #DatosRegistrosU3)
																
						
						SET @SqlU3 = 'SELECT '''+ @nomPrincipalCU3 + ''' AS tabla, '
						+ '(SELECT codigo1 AS ' + @nombreCol1CodU3 + ', codigo2 AS ' + @nombreCol2CodU3 + ' , codigo3 AS ' + @nombreCol3CodU3
						+' from ##RESULTADOU3 a'
						+' inner join #camposWhere b on a.'+ @nombreCol1CodU3 +' = b.codigo1  AND  a.' + @nombreCol2CodU3 +' = b.codigo2 AND a.' + @nombreCol3CodU3 + ' = b.codigo3'
						+' group by codigo1 , codigo2 , codigo3 FOR JSON PATH) AS filtros,'
						+ '((SELECT '+ @textU3
						+ ' from ##RESULTADOU3 a'
						+ ' inner join #camposWhere b on a.'+@nombreCol1CodU3+' = b.codigo1  AND  a.' + @nombreCol2CodU3 +' = b.codigo2 AND a.' + @nombreCol3CodU3 + ' = b.codigo3'
						+ ' GROUP BY ' + @COLUMNAS3 + ' FOR JSON PATH)) AS datos FOR JSON PATH';	

						EXEC sp_executesql @SqlU3;
						
						DROP TABLE #DatosRegistrosU3
						DROP TABLE  #TIPODATOU3
					END				
			END

			DROP TABLE ##RESULTADOU3
			TRUNCATE TABLE #camposWhere
			TRUNCATE TABLE #migracionCodigoU3
		END		
		DROP TABLE #columnasU3
		SET @secCU3 += 1
		END			
	END
	
	IF @codigoTipo = '4'
	BEGIN
		

		SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
		INTO #tablasCU4
		FROM temp_registroMigracion 
		WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS  NULL
		GROUP BY nombre_table,tipo,observacion

		DECLARE @contCU4 int =0, @secCU4 int =1
	
		SET @contCU4 = (SELECT COUNT (*) FROM #tablasCU4)
		
		WHILE @contCU4 >= @secCU4
		BEGIN

		DECLARE @nomPrincipalCU4 varchar(max)

		SELECT @nomPrincipalCU4=nombre_table 
		FROM #tablasCU4 WHERE id = @secCU4			

		SELECT c.name AS COLUMN_NAME
		INTO #columnasU4
		FROM sys.columns c
		INNER JOIN sys.tables t ON c.object_id = t.object_id
		WHERE t.name = @nomPrincipalCU4 
		AND c.is_identity = 0
		order by column_id asc;


		IF (
			SELECT count(observacion)
			FROM #tablasCU4 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalCU4
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 4
		BEGIN

		DECLARE @contU4 int =0, @secU4 int =1


		INSERT INTO #migracionCodigoU4(nombre_tabla,tipo,codigo,codigo2,codigo3,codigo4,observacion,codigoMigracion)
		SELECT  nombre_table, tipo,codigo,codigo2,codigo3,codigo4,REPLACE(observacion, ' ', '') AS observacion,id
		FROM temp_registroMigracion 
		WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS  NULL
		AND TIPO = @tipoU AND nombre_table= @nomPrincipalCU4
	
		
		SELECT @contU4=COUNT(*) FROM #migracionCodigoU4

		DECLARE @tipoCU4 varchar(5)='',
		@nombreTableCU4 varchar(200)='',
		@observacionCU4 varchar(200)='',
		@codigoCU41 varchar(200)='',
		@codigoCU42 varchar(200)='',
		@codigoCU43 varchar(200)='',
		@codigoCU44 varchar(200)='',		
		@CreateTABLECU4 NVARCHAR(max) = N'',
		@nombreCol1CodU4 varchar(max) = '',	
		@nombreCol2CodU4 varchar(max) = '',	
		@nombreCol3CodU4 varchar(max) = '',	
		@nombreCol4CodU4 varchar(max) = '',	
		@idCodMigracionU4 varchar(10) = ''

		

		WHILE @contU4 >=@secU4
			BEGIN	
				
				SELECT 
				@nombreTableCU4=nombre_tabla, 
				@tipoCU4=tipo,
				@codigoCU41=codigo,
				@codigoCU42=codigo2,
				@codigoCU43=codigo3,
				@codigoCU44=codigo4,
				@observacionCU4=observacion,
				@idCodMigracionU4=codigoMigracion
				FROM #migracionCodigoU4
				WHERE id = @secU4 AND nombre_tabla = @nomPrincipalCU4			

				IF @@ROWCOUNT = 0
				BREAK;

				

				DECLARE @textU4 varchar(max)
				SET @textU4 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnasU4
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))


				SELECT *
				INTO #NomColumnaU4
				FROM STRING_SPLIT(@observacionCU4, ',',1)

				SET @nombreCol1CodU4 = (select value from #NomColumnaU4 where ordinal=1)
				SET @nombreCol2CodU4 = (select value from #NomColumnaU4 where ordinal=2)						
				SET @nombreCol3CodU4 = (select value from #NomColumnaU4 where ordinal=3)
				SET @nombreCol4CodU4 = (select value from #NomColumnaU4 where ordinal=4)

				INSERT INTO #camposWhere(NombreCampo1,codigo1,NombreCampo2,codigo2,NombreCampo3,codigo3,NombreCampo4,codigo4)
							VALUES(@nombreCol1CodU4,@codigoCU41,@nombreCol2CodU4,@codigoCU42,@nombreCol3CodU4,@codigoCU43,@nombreCol4CodU4,@codigoCU44)				

				
				IF (LEN(@codigoCU41)>19)
						SET @codigoCU41 = 'CONVERT(datetime,'''+@codigoCU41+''',121)'
				ELSE
					SET @codigoCU41 = '''' + @codigoCU41 + ''''
				
				IF (LEN(@codigoCU42)>19)
						SET @codigoCU42 = 'CONVERT(datetime,'''+@codigoCU42+''',121)'
				ELSE
					SET @codigoCU42 = '''' + RTRIM(LTRIM(@codigoCU42)) + ''''
				
				IF (LEN(@codigoCU43)>19)
						SET @codigoCU43 = 'CONVERT(datetime,'''+@codigoCU43+''',121)'
				ELSE
					SET @codigoCU43 = '''' + RTRIM(LTRIM(@codigoCU43)) + ''''
							
				IF (LEN(@codigoCU44)>19)
						SET @codigoCU44 = 'CONVERT(datetime,'''+@codigoCU44+''',121)'
				ELSE
					SET @codigoCU44 = '''' + RTRIM(LTRIM(@codigoCU44)) + ''''

		
				IF OBJECT_ID('tempdb..##RESULTADOU4') IS NOT NULL
				BEGIN		
					SET @CreateTABLECU4 =N'SELECT ' + @textU4 + 
					' FROM ' + @nombreTableCU4 + 
					' WHERE '+ @nombreCol1CodU4 +'= ' + @codigoCU41 + ' AND ' + 	@nombreCol2CodU4 + ' = '+ @codigoCU42 + ' AND ' + @nombreCol3CodU4 + ' = ' + @codigoCU43	+ ' AND '+ @nombreCol4CodU4 + ' = ' + @codigoCU44

					INSERT INTO ##RESULTADOU4
					EXECUTE sp_executeSQL @CreateTABLECU4
				END	

				IF OBJECT_ID('tempdb..##RESULTADOU4') IS NULL
				BEGIN		

					SET @CreateTABLECU4 =N'SELECT ' + @textU4 
					+' INTO ##RESULTADOU4 '   
					+' FROM ' + @nombreTableCU4 
					+ ' WHERE '+ @nombreCol1CodU4 +'= ' + @codigoCU41 + ' AND ' + 	@nombreCol2CodU4 + ' = '+ @codigoCU42 + ' AND ' + @nombreCol3CodU4 + ' = ' + @codigoCU43	+ ' AND '+ @nombreCol4CodU4 + ' = ' + @codigoCU44
					
					
					EXECUTE sp_executeSQL @CreateTABLECU4				
				END
										
				DROP TABLE #NomColumnaU4
				SET @secU4 = @secU4 +1
		END		
		
			IF OBJECT_ID('tempdb..##RESULTADOU4') IS NOT NULL
			BEGIN
				IF(SELECT COUNT(*) FROM ##RESULTADOU4)>0
					BEGIN
						DECLARE @ColumnsU4 NVARCHAR(MAX);
						DECLARE @SqlU4 NVARCHAR(MAX);								

						CREATE TABLE #DatosRegistrosU4(
						id int identity(1,1),
						columna varchar(max),
						valorDefault varchar(max)
						)
					
						SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
						INTO #TIPODATOU4
						FROM TempDB.SYS.COLUMNS a
						INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
						WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADOU4') AND is_identity = 0
				

						DECLARE @contTipoU4 int = 0, @secTipoU4 int = 1

						SET @contTipoU4 = (SELECT COUNT(*) FROM #TIPODATOU4)
						WHILE @contTipoU4 >= @secTipoU4
						BEGIN
							DECLARE @nombreU4 varchar(max)='', @tipoDatoU4 varchar(max)='', @ValorDefaultU4 VARCHAR(MAX)=''
						
							SELECT 
							@nombreU4=columna,
							@tipoDatoU4=tipo 
							FROM #TIPODATOU4
							WHERE id = @secTipoU4
						
							IF @@ROWCOUNT = 0
							BREAK;

							IF @TipoDatoU4 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
								SET @ValorDefaultU4 = '0';  -- Valor por defecto numérico
							ELSE IF @TipoDatoU4 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
								SET @ValorDefaultU4 = '''''' ;  -- Valor por defecto texto
							ELSE IF @TipoDatoU4 IN ('datetime', 'date', 'time')  -- Tipos de fecha
								SET @ValorDefaultU4 = '''1900-01-01''' ;  -- Valor por defecto fecha
							ELSE
								SET @ValorDefaultU4 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
							insert into #DatosRegistrosU4 (columna,valorDefault)
													VALUES(@nombreU4,@ValorDefaultU4)

							SET @secTipoU4 +=1
						END

						SET @SqlU4 = (SELECT STRING_AGG(
				
							'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
							', ') 
						FROM #DatosRegistrosU4)

						DECLARE @COLUMNAS4 varchar(max)=''

						SET @COLUMNAS4 = (SELECT STRING_AGG(CAST(columna AS varchar(MAX)),', ') 
						FROM #DatosRegistrosU4)
																			
						SET @SqlU4 = 'SELECT '''+ @nomPrincipalCU4 + ''' AS tabla, '
						+ '(SELECT codigo1 AS ' + @nombreCol1CodU4 + ', codigo2 AS ' + @nombreCol2CodU4 + ' , codigo3 AS ' + @nombreCol3CodU4 + ' , codigo4 AS ' + @nombreCol4CodU4
						+' from ##RESULTADOU4 a'
						+' inner join #camposWhere b on a.'+ @nombreCol1CodU4 +' = b.codigo1  AND  a.' + @nombreCol2CodU4 +' = b.codigo2 AND a.' + @nombreCol3CodU4 + ' = b.codigo3 AND a.' + @nombreCol4CodU4 + ' = b.codigo4'
						+' group by codigo1 , codigo2 , codigo3, codigo4 FOR JSON PATH) AS filtros,'
						+ '((SELECT '+ @textU4
						+ ' from ##RESULTADOU4 a'
						+ ' inner join #camposWhere b on a.'+@nombreCol1CodU4+' = b.codigo1  AND  a.' + @nombreCol2CodU4 +' = b.codigo2 AND a.' + @nombreCol3CodU4 + ' = b.codigo3 AND a.' + @nombreCol4CodU4 + ' = b.codigo4'
						+ ' GROUP BY ' + @COLUMNAS4 + ' FOR JSON PATH)) AS datos FOR JSON PATH';	

						EXEC sp_executesql @SqlU4;
						
						DROP TABLE #DatosRegistrosU4
						DROP TABLE  #TIPODATOU4
					END				
			END

			DROP TABLE ##RESULTADOU4
			TRUNCATE TABLE #camposWhere
			TRUNCATE TABLE #migracionCodigoU4
		END		
		DROP TABLE #columnasU4
		SET @secCU4 += 1
		END			
	END
	
	IF @codigoTipo = '5'
	BEGIN
		

		SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,REPLACE(observacion, ' ', '') AS observacion 
		INTO #tablasCU5
		FROM temp_registroMigracion 
		WHERE tipo = 'U' and [status] = 1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS NOT NULL
		GROUP BY nombre_table,tipo,observacion

		DECLARE @contCU5 int =0, @secCU5 int =1
	
		SET @contCU5 = (SELECT COUNT (*) FROM #tablasCU5)
		
		WHILE @contCU5 >= @secCU5
		BEGIN

		DECLARE @nomPrincipalCU5 varchar(max)

		SELECT @nomPrincipalCU5=nombre_table 
		FROM #tablasCU5 WHERE id = @secCU5			


		SELECT c.name AS COLUMN_NAME
		INTO #columnasU5
		FROM sys.columns c
		INNER JOIN sys.tables t ON c.object_id = t.object_id
		WHERE t.name = @nomPrincipalCU5 
		AND c.is_identity = 0
		order by column_id asc;


		IF (
			SELECT count(observacion)
			FROM #tablasCU5 
			CROSS APPLY STRING_SPLIT(observacion, ',') 
			where nombre_table = @nomPrincipalCU5
			GROUP BY CONCAT_WS('',observacion,''),nombre_table
		) = 5
		BEGIN

		DECLARE @contU5 int =0, @secU5 int =1


		INSERT INTO #migracionCodigoU5(nombre_tabla,tipo,codigo,codigo2,codigo3,codigo4,codigo5,observacion,codigoMigracion)
		SELECT  nombre_table, tipo,codigo,codigo2,codigo3,codigo4,codigo5,REPLACE(observacion, ' ', '') AS observacion,id
		FROM temp_registroMigracion 
		WHERE [status]=1 AND codigo IS NOT NULL AND codigo2 IS NOT NULL AND codigo3 IS NOT NULL AND codigo4 IS NOT NULL AND codigo5 IS NOT NULL
		AND TIPO = @tipoU AND nombre_table= @nomPrincipalCU5
	
		
		SELECT @contU5=COUNT(*) FROM #migracionCodigoU5

		DECLARE @tipoCU5 varchar(5)='',
		@nombreTableCU5 varchar(200)='',
		@observacionCU5 varchar(200)='',
		@codigoCU51 varchar(200)='',
		@codigoCU52 varchar(200)='',
		@codigoCU53 varchar(200)='',
		@codigoCU54 varchar(200)='',
		@codigoCU55 varchar(200)='',
		@CreateTABLECU5 NVARCHAR(max) = N'',
		@nombreCol1CodU5 varchar(max) = '',	
		@nombreCol2CodU5 varchar(max) = '',	
		@nombreCol3CodU5 varchar(max) = '',	
		@nombreCol4CodU5 varchar(max) = '',	
		@nombreCol5CodU5 varchar(max) = '',	
		@idCodMigracionU5 varchar(10) = ''

		

		WHILE @contU5 >=@secU5
			BEGIN	
				
				SELECT 
				@nombreTableCU5=nombre_tabla, 
				@tipoCU5=tipo,
				@codigoCU51=codigo,
				@codigoCU52=codigo2,
				@codigoCU53=codigo3,
				@codigoCU54=codigo4,
				@codigoCU55=codigo5,
				@observacionCU5=observacion,
				@idCodMigracionU5=codigoMigracion
				FROM #migracionCodigoU5
				WHERE id = @secU5 AND nombre_tabla = @nomPrincipalCU5			

				IF @@ROWCOUNT = 0
				BREAK;

				

				DECLARE @textU5 varchar(max)
				SET @textU5 =(
				SELECT
				STUFF(
				(
					SELECT ',' + CAST(COLUMN_NAME AS VARCHAR(50))
					FROM #columnasU5
					WHERE COLUMN_NAME!='pk_Id'
					FOR XML PATH('')
				),
				1,
				1,
				''
				))

				SELECT *
				INTO #NomColumnaU5
				FROM STRING_SPLIT(@observacionCU5, ',',1)

				SET @nombreCol1CodU5 = (select value from #NomColumnaU5 where ordinal=1)
				SET @nombreCol2CodU5 = (select value from #NomColumnaU5 where ordinal=2)						
				SET @nombreCol3CodU5 = (select value from #NomColumnaU5 where ordinal=3)
				SET @nombreCol4CodU5 = (select value from #NomColumnaU5 where ordinal=4)
				SET @nombreCol5CodU5 = (select value from #NomColumnaU5 where ordinal=5)

				INSERT INTO #camposWhere(NombreCampo1,codigo1,NombreCampo2,codigo2,NombreCampo3,codigo3,NombreCampo4,codigo4,NombreCampo5,codigo5)
							VALUES(@nombreCol1CodU5,@codigoCU51,@nombreCol2CodU5,@codigoCU52,@nombreCol3CodU5,@codigoCU53,@nombreCol4CodU5,@codigoCU54,@nombreCol5CodU5,@codigoCU55)				

				
				IF (LEN(@codigoCU51)>19)
						SET @codigoCU51 = 'CONVERT(datetime,'''+@codigoCU51+''',121)'
				ELSE
					SET @codigoCU51 = '''' + @codigoCU51 + ''''
				
				IF (LEN(@codigoCU52)>19)
						SET @codigoCU52 = 'CONVERT(datetime,'''+@codigoCU52+''',121)'
				ELSE
					SET @codigoCU52 = '''' + RTRIM(LTRIM(@codigoCU52)) + ''''
				
				IF (LEN(@codigoCU53)>19)
						SET @codigoCU53 = 'CONVERT(datetime,'''+@codigoCU53+''',121)'
				ELSE
					SET @codigoCU53 = '''' + RTRIM(LTRIM(@codigoCU53)) + ''''
							
				IF (LEN(@codigoCU54)>19)
						SET @codigoCU54 = 'CONVERT(datetime,'''+@codigoCU54+''',121)'
				ELSE
					SET @codigoCU54 = '''' + RTRIM(LTRIM(@codigoCU54)) + ''''
				
				IF (LEN(@codigoCU55)>19)
						SET @codigoCU55 = 'CONVERT(datetime,'''+@codigoCU55+''',121)'
				ELSE
					SET @codigoCU55 = '''' + RTRIM(LTRIM(@codigoCU55)) + ''''

		
				IF OBJECT_ID('tempdb..##RESULTADOU5') IS NOT NULL
				BEGIN		
					SET @CreateTABLECU5 =N'SELECT ' + @textU5 + 
					' FROM ' + @nombreTableCU5 + 
					' WHERE '+ @nombreCol1CodU5 +'= ' + @codigoCU51 + ' AND ' + 	@nombreCol2CodU5 + ' = '+ @codigoCU52 + ' AND ' + @nombreCol3CodU5 + ' = ' + @codigoCU53	+ ' AND '+ @nombreCol5CodU5 + ' = ' + @codigoCU54 + ' AND '+ @nombreCol5CodU5 + ' = ' + @codigoCU55

					INSERT INTO ##RESULTADOU5
					EXECUTE sp_executeSQL @CreateTABLECU5
				END	

				IF OBJECT_ID('tempdb..##RESULTADOU5') IS NULL
				BEGIN		

					SET @CreateTABLECU5 =N'SELECT ' + @textU5 
					+' INTO ##RESULTADOU5 '   
					+' FROM ' + @nombreTableCU5 
					+ ' WHERE '+ @nombreCol1CodU5 +'= ' + @codigoCU51 + ' AND ' + 	@nombreCol2CodU5 + ' = '+ @codigoCU52 + ' AND ' + @nombreCol3CodU5 + ' = ' + @codigoCU53	+ ' AND '+ @nombreCol4CodU5 + ' = ' + @codigoCU54 + ' AND '+ @nombreCol5CodU5 + ' = ' + @codigoCU55
					
					
					EXECUTE sp_executeSQL @CreateTABLECU5				
				END
										
				DROP TABLE #NomColumnaU5
				SET @secU5 = @secU5 +1
		END		
		
			IF OBJECT_ID('tempdb..##RESULTADOU5') IS NOT NULL
			BEGIN
				IF(SELECT COUNT(*) FROM ##RESULTADOU5)>0
					BEGIN
						DECLARE @ColumnsU5 NVARCHAR(MAX);
						DECLARE @SqlU5 NVARCHAR(MAX);								

						CREATE TABLE #DatosRegistrosU5(
						id int identity(1,1),
						columna varchar(max),
						valorDefault varchar(max)
						)
					
						SELECT ROW_NUMBER() OVER(ORDER BY a.name) as id,B.name AS tipo, a.name AS columna
						INTO #TIPODATOU5
						FROM TempDB.SYS.COLUMNS a
						INNER JOIN  TempDB.sys.types B ON a.user_type_id=B.user_type_id
						WHERE OBJECT_ID=OBJECT_ID('TempDB.dbo.##RESULTADOU5') AND is_identity = 0
				

						DECLARE @contTipoU5 int = 0, @secTipoU5 int = 1

						SET @contTipoU5 = (SELECT COUNT(*) FROM #TIPODATOU5)
						WHILE @contTipoU5 >= @secTipoU5
						BEGIN
							DECLARE @nombreU5 varchar(max)='', @tipoDatoU5 varchar(max)='', @ValorDefaultU5 VARCHAR(MAX)=''
						
							SELECT 
							@nombreU5=columna,
							@tipoDatoU5=tipo 
							FROM #TIPODATOU5
							WHERE id = @secTipoU5
						
							IF @@ROWCOUNT = 0
							BREAK;

							IF @TipoDatoU5 IN ('int', 'decimal', 'numeric', 'float', 'real','money','tinyint')  -- Tipos numéricos
								SET @ValorDefaultU5 = '0';  -- Valor por defecto numérico
							ELSE IF @TipoDatoU5 IN ('varchar', 'char', 'text', 'nvarchar', 'nchar')  -- Tipos de texto
								SET @ValorDefaultU5 = '''''' ;  -- Valor por defecto texto
							ELSE IF @TipoDatoU5 IN ('datetime', 'date', 'time')  -- Tipos de fecha
								SET @ValorDefaultU5 = '''1900-01-01''' ;  -- Valor por defecto fecha
							ELSE
								SET @ValorDefaultU5 = '''Desconocido''' ;  -- Valor por defecto genérico
				
						
							insert into #DatosRegistrosU5 (columna,valorDefault)
													VALUES(@nombreU5,@ValorDefaultU5)

							SET @secTipoU5 +=1
						END

						SET @SqlU5 = (SELECT STRING_AGG(
				
							'ISNULL( CONVERT(VARCHAR(MAX), ' + CAST(QUOTENAME(columna) AS varchar(MAX)) + '), '+ valorDefault +') AS ' +CAST(QUOTENAME(columna) AS varchar(MAX)), 
							', ') 
						FROM #DatosRegistrosU5)

						DECLARE @COLUMNAS5 varchar(max)=''

						SET @COLUMNAS5 = (SELECT STRING_AGG(CAST(columna AS varchar(MAX)),', ') 
						FROM #DatosRegistrosU5)
																			
						SET @SqlU5 = 'SELECT '''+ @nomPrincipalCU5 + ''' AS tabla, '
						+ '(SELECT codigo1 AS ' + @nombreCol1CodU5 + ', codigo2 AS ' + @nombreCol2CodU5 + ' , codigo3 AS ' + @nombreCol3CodU5 + ' , codigo4 AS ' + @nombreCol4CodU5 + ' , codigo5 AS ' + @nombreCol5CodU5 
						+' from ##RESULTADOU5 a'
						+' inner join #camposWhere b on a.'+ @nombreCol1CodU5 +' = b.codigo1  AND  a.' + @nombreCol2CodU5 +' = b.codigo2 AND a.' + @nombreCol3CodU5 + ' = b.codigo3 AND a.' + @nombreCol4CodU5 + ' = b.codigo4 AND a.'+@nombreCol5CodU5 + '= b.codigo5'
						+' group by codigo1 , codigo2 , codigo3, codigo4,codigo5 FOR JSON PATH) AS filtros,'
						+ '((SELECT a.*'
						+ ' from ##RESULTADOU5 a'
						+ ' inner join #camposWhere b on a.'+@nombreCol1CodU5+' = b.codigo1  AND  a.' + @nombreCol2CodU5 +' = b.codigo2 AND a.' + @nombreCol3CodU5 + ' = b.codigo3 AND a.' + @nombreCol4CodU5 + ' = b.codigo4 AND a.'+@nombreCol5CodU5 + '= b.codigo5'
						+ ' GROUP BY ' + @COLUMNAS5 + ' FOR JSON PATH)) AS datos FOR JSON PATH';	

						EXEC sp_executesql @SqlU5;
						PRINT @SqlU5
						DROP TABLE #DatosRegistrosU5
						DROP TABLE  #TIPODATOU5
					END				
			END

			DROP TABLE ##RESULTADOU5
			TRUNCATE TABLE #camposWhere
			TRUNCATE TABLE #migracionCodigoU5
		END		
		DROP TABLE #columnasU5
		SET @secCU5 += 1
		END			
	END
	
END

END