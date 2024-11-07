IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MigracionCodigo]') AND type in (N'P', N'PC'))
	EXEC('CREATE PROCEDURE sp_MigracionCodigo AS')
GO

ALTER PROCEDURE sp_MigracionCodigo
@accion				char(3),
@codigoU			varchar(50)		= NULL,
@tipoU				varchar(5)		= NULL,
@nombreTableU		varchar(max)	= NULL
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
		
				SELECT COLUMN_NAME
				INTO #columnas
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nombreTable
				ORDER BY ORDINAL_POSITION

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
					SET @CreateTABLE =N'SELECT ' + @text + ', nombreTable=''' + @nombreTable  + ''', '+ @idCodMigracion1 +' AS idCodMigracion' + 
					' FROM ' + @nombreTable + ' WHERE ' + @observacion+'=''' + @codigo + ''''	
										
					INSERT INTO ##RESULTADO
					EXECUTE sp_executeSQL @CreateTABLE
				END	

				IF OBJECT_ID('tempdb..##RESULTADO') IS NULL
				BEGIN		
					SET @CreateTABLE =N'SELECT ' + @text + ', nombreTable='''+ @nombreTable  + ''', '+ @idCodMigracion1 +' AS idCodMigracion' + 
					' INTO ##RESULTADO FROM ' + @nombreTable + ' WHERE ' + @observacion+'=''' + @codigo + ''''			
					EXECUTE sp_executeSQL @CreateTABLE
					
				END
				
				DROP TABLE #columnas
				SET @sec1 +=1
			END

		IF OBJECT_ID('tempdb..##RESULTADO') IS NOT NULL
		BEGIN
			select * from ##RESULTADO
			DROP TABLE ##RESULTADO
		END

		END

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
		
				SELECT COLUMN_NAME
				INTO #columnas2
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nombreTableC2
				ORDER BY ORDINAL_POSITION


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
					SET @CreateTABLEC2 =N'SELECT ' + @text2 + ', nombreTable='''+ @nombreTableC2 +	''' , '+ @idCodMigracion + ' AS idCodMigracion '+	
					'FROM ' + @nombreTableC2 + 
					' WHERE '+ @nombreColumna1 +'= ''' + @codigoC2 + ''' AND ' + @nombreColumna2 + ' = ''' + @codigo2C2 + ''''	
										
					INSERT INTO ##RESULTADO2
					EXECUTE sp_executeSQL @CreateTABLEC2
				END	

				IF OBJECT_ID('tempdb..##RESULTADO2') IS NULL
				BEGIN		
					SET @CreateTABLEC2 =N'SELECT ' + @text2 + ', nombreTable='''+ @nombreTableC2 + ''', ' + @idCodMigracion +' AS idCodMigracion '+ 
					' INTO ##RESULTADO2 ' +
					' FROM ' + @nombreTableC2 + 
					' WHERE '+ @nombreColumna1 +'= ''' + @codigoC2 + ''' AND ' + @nombreColumna2 + ' = ''' + @codigo2C2 + ''''	
					
					EXECUTE sp_executeSQL @CreateTABLEC2			
				END
				
				DROP TABLE #columnas2
				DROP TABLE #NomColumna
				SET @secC1 +=1
			END

			IF OBJECT_ID('tempdb..##RESULTADO2') IS NOT NULL
			BEGIN
				select * from ##RESULTADO2
				DROP TABLE ##RESULTADO2
			END
			TRUNCATE TABLE #migracionCodigo2
		END
		
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

				
		
				SELECT COLUMN_NAME
				INTO #columnas3
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = 'dbo'
					and TABLE_NAME = @nombreTableC3
				ORDER BY ORDINAL_POSITION


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
					SET @CreateTABLEC3 =N'SELECT ' + @text3 + ', nombreTable='''+ @nombreTableC3 + '''' + ', '+ @idCodMigracion3 +' AS idCodMigracion' + 
					' FROM ' + @nombreTableC3 + 
					' WHERE '+ @nombreCol1Cod3 +'= ''' + @codigoC3 + ''' AND ' + @nombreCol2Cod3 + ' = ''' + @codigo2C3 + ''''+
					' AND ' + @nombreCol3Cod3 + ' = ''' + @codigo3C3 + ''''
					

			
					PRINT @CreateTABLEC3

					INSERT INTO ##RESULTADO3
					EXECUTE sp_executeSQL @CreateTABLEC3

					
				END	

				IF OBJECT_ID('tempdb..##RESULTADO3') IS NULL
				BEGIN		
					SET @CreateTABLEC3 =N'SELECT ' + @text3 + ', nombreTable='''+ @nombreTableC3 + ''''+ ', '+ @idCodMigracion3 +' AS idCodMigracion' + 
					' INTO ##RESULTADO3 ' +  
					' FROM ' + @nombreTableC3 + 
					' WHERE '+ @nombreCol1Cod3 +'= ''' + @codigoC3 + ''' AND ' + @nombreCol2Cod3 + ' = ''' + @codigo2C3 + ''''+
					' AND ' + @nombreCol3Cod3 + ' = ''' + @codigo3C3 + ''''
					
					

					EXECUTE sp_executeSQL @CreateTABLEC3
				
				END
				
				DROP TABLE #columnas3
				DROP TABLE #NomColumna3
				SET @secCod3 +=1
			END

			IF OBJECT_ID('tempdb..##RESULTADO3') IS NOT NULL
			BEGIN
				select * from ##RESULTADO3
				DROP TABLE ##RESULTADO3
				PRINT 'AKI'
			END
			TRUNCATE TABLE #migracionCodigo3
		END
		
		SET @secC3 += 1
	END

	DROP TABLE #migracionCodigo3
	
END


IF @accion = 'U'
BEGIN

		UPDATE temp_registroMigracion SET FechaModificacion = GETDATE(), status = 2
		WHERE id = @codigoU AND tipo = @tipoU AND nombre_table=@nombreTableU AND status=1

END


END