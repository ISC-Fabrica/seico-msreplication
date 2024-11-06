IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MigracionCodigo]') AND type in (N'P', N'PC'))
	EXEC('CREATE PROCEDURE sp_MigracionCodigo AS')
GO

ALTER PROCEDURE sp_MigracionCodigo
@accion				char(3),
@codigoU			varchar(50)		=	NULL,
@tipoU				varchar(5)		= NULL,
@nombreTableU		varchar(max)	= NULL
AS
BEGIN
SET NOCOUNT ON;
IF OBJECT_ID('tempdb..##RESULTADO') IS NOT NULL
		DROP TABLE ##RESULTADO

CREATE TABLE #migracionCodigo(
	id int identity(1,1),
	nombre_tabla varchar(200),
	tipo varchar(3),
	codigo varchar(50),
	observacion varchar(max)
)


IF @accion='1'
BEGIN

	DECLARE @cont1 int =0, @sec1 int =1
	DECLARE @cont2 int =0, @sec2 int =1
	

	INSERT INTO #migracionCodigo(nombre_tabla,tipo,codigo,observacion)
	SELECT  nombre_table, tipo,codigo,observacion 
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND TIPO = 'I'
	GROUP BY nombre_table,tipo,codigo,observacion

	SELECT ROW_NUMBER() OVER(ORDER BY nombre_table) as id, nombre_table, tipo,observacion 
	INTO #tablas
	FROM temp_registroMigracion 
	WHERE [status]=1 AND codigo IS NOT NULL AND TIPO = 'I'
	GROUP BY nombre_table,tipo,observacion

	SET @cont2 = (SELECT COUNT (*) FROM #tablas)
	SELECT @cont1=COUNT(*) FROM #migracionCodigo

	WHILE @cont2 >= @sec2
	BEGIN
		DECLARE @nomPrincipal varchar(max)
		
		select @nomPrincipal=nombre_table 
		from #tablas where id = @sec2
			
	WHILE @cont1 >=@sec1
	BEGIN
		DECLARE @tipo varchar(5)='',
				@nombreTable varchar(200)='',
				@observacion varchar(200)='',
				@codigo varchar(50)='',
				@CreateTABLE NVARCHAR(max) = N''
		
	
		SELECT @nombreTable=nombre_tabla, @tipo=tipo,@codigo=codigo,@observacion=observacion
		FROM #migracionCodigo 
		WHERE id = @sec1 AND nombre_tabla = @nomPrincipal
		
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

			SET @CreateTABLE =N'SELECT ' + @text + ', nombreTable=''' + @nombreTable +''' FROM ' + @nombreTable + ' WHERE ' + @observacion+'=''' + @codigo + ''''	
			INSERT INTO ##RESULTADO
			EXECUTE sp_executeSQL @CreateTABLE
		END	

		IF OBJECT_ID('tempdb..##RESULTADO') IS NULL
		BEGIN
			
			SET @CreateTABLE =N'SELECT ' + @text + ', nombreTable='''+ @nombreTable + ''' INTO ##RESULTADO FROM ' + @nombreTable + ' WHERE ' + @observacion+'=''' + @codigo + ''''			
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

		
		SET @sec2 += 1
	END

	DROP TABLE #migracionCodigo
	
END

IF @accion = 'U'
BEGIN
	UPDATE temp_registroMigracion SET FechaModificacion = GETDATE(), status = 2
	WHERE codigo = @codigoU AND tipo = @tipoU AND nombre_table=@nombreTableU AND status=1

END


END