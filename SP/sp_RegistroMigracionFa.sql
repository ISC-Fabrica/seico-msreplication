IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RegistroMigracionFa]') AND type in (N'P', N'PC'))
	EXEC('CREATE PROCEDURE sp_RegistroMigracionFa AS')
GO

ALTER PROCEDURE sp_RegistroMigracionFa
@accion CHAR(3),
@json varchar(max),
@nombreTable varchar(200)		= NULL
AS
BEGIN
	DECLARE @mensaje varchar(max) =''
	IF @accion ='I'
	BEGIN		
		DECLARE @nombreTabla NVARCHAR(128)= N''
		DECLARE @sqlInsert NVARCHAR(MAX);
		DECLARE @columns NVARCHAR(MAX);
		DECLARE @values NVARCHAR(MAX);

		SET @nombreTabla = @nombreTable 


		SET @columns = '';
		SET @values = '';


		SELECT *
		INTO #VALOR
		FROM OPENJSON(@json)


		SELECT @columns = STRING_AGG(QUOTENAME([key]), ', '),
				@values = STRING_AGG(''''+ [value] + '''', ', ')  
		FROM #VALOR

		DROP TABLE #VALOR
    
		-- Crear la sentencia de INSERT dinámica
		SET @sqlInsert = 'INSERT INTO ' + QUOTENAME(@nombreTabla) + ' (' + @columns + ') VALUES (' + @values + ')';

		---- Ejecutar el SQL dinámico
		EXEC sp_executesql @sqlInsert;

	END

	IF @accion ='U'
	BEGIN
		
		CREATE TABLE #VALORUP
		(
			id int identity primary key,
			valor varchar (max),
			columna varchar(max)
		)

		DECLARE @sqlUpdate NVARCHAR(MAX), @textUp varchar(max),@textUp2 varchar(max);
	
		INSERT INTO #VALORUP(columna,valor)
		SELECT [key] as columna, [value] as valor	
		FROM OPENJSON(@json)

		declare @conUp int=0, @secUp int =1

		set @conUp = (select count(*) from #VALORUP)
		DECLARE @columnsUP NVARCHAR(MAX);
		DECLARE @valuesUP NVARCHAR(MAX);
		SET @columnsUP = '';
		SET @valuesUP = '';
		SET @textUp = ''
		WHILE @conUp >= @secUp
		BEGIN			
				SELECT @columnsUP = STRING_AGG(QUOTENAME(columna), ', '),
					@valuesUP = STRING_AGG(''''+ valor + '''', ', ')  
				FROM #VALORUP
				WHERE id=@secUp

				IF @@ROWCOUNT =0
				BREAK;
				SET @textUp +=  @columnsUP + '=' + @valuesUP + ','			
				SET @secUp += 1


		END
		SELECT subString(@textUp,1, len(@textUp) - 1)
		DROP TABLE #VALORUP    	
		
	END
	
END