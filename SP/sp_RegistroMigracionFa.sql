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

		SELECT @columns
		SELECT @values

		DROP TABLE #VALOR
    
		-- Crear la sentencia de INSERT dinámica
		SET @sqlInsert = 'INSERT INTO ' + QUOTENAME(@nombreTabla) + ' (' + @columns + ') VALUES (' + @values + ')';

		---- Ejecutar el SQL dinámico
		EXEC sp_executesql @sqlInsert;

		select  @nombreTabla
		select @columns
		select @values
	END

	IF @accion ='U'
	BEGIN
		PRINT'HOLA'
		--IF @nombreTable='FA_ACTIVIDAD_ECO'
		--BEGIN
		--BEGIN TRY
		--BEGIN TRANSACTION insertFA_ACTIVIDAD_ECO

		--	DECLARE @updateCodigo varchar(20), @updateNombre varchar(max),@updateNivel numeric				

		--	SELECT @insetCodigo=codigo,@insertNombre=nombre,@insertNivel=nivel FROM 
		--	OPENJSON(@json)
		--		WITH( 
		--		codigo VARCHAR(50) '$.codigo',
		--		nombre VARCHAR(max) '$.nombre',
		--		nivel numeric '$.nivel' 
		--	)
				
		--	UPDATE FA_ACTIVIDAD_ECO_PRUEBA SET nombre = @updateNombre, nivel = @updateNivel
		--	WHERE codigo = @updateCodigo

		--COMMIT TRANSACTION insertFA_ACTIVIDAD_ECO
		--END TRY
		--BEGIN CATCH
		--IF (@@TRANCOUNT > 0)
		--BEGIN
		--	ROLLBACK TRANSACTION insertFA_ACTIVIDAD_ECO	
		--	SET @mensaje = ERROR_MESSAGE()
		--	RAISERROR (15600, -1, -1, @mensaje);
		--END 
		--END CATCH		
				
		--END
		
		--IF @nombreTable ='FA_mese'
		--BEGIN
		--BEGIN TRY
		--BEGIN TRANSACTION insertFA_mese
							
		--		DECLARE @UpdateMes numeric =0, @UpdateNombreMes varchar(100)							
		--		SELECT @UpdateMes = mes, @UpdateNombreMes = nombre FROM 
		--		OPENJSON(@json)
		--			WITH( 
		--			mes VARCHAR(50) '$.mes',
		--			nombre VARCHAR(max) '$.nombre'					
		--		)

			
		--		UPDATE  FA_mese_Prueba SET nombre=@UpdateNombreMes
		--		WHERE mes = @UpdateMes
					
		--COMMIT TRANSACTION insertFA_mese
		--END TRY
		--BEGIN CATCH
		--IF (@@TRANCOUNT > 0)
		--BEGIN
		--	ROLLBACK TRANSACTION insertFA_mese	
		--	SET @mensaje = ERROR_MESSAGE()
		--	RAISERROR (15600, -1, -1, @mensaje);
		--END 
		--END CATCH
				
		--END
		
	END
	
END