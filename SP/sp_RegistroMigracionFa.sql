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
	
		IF @nombreTable='FA_ACTIVIDAD_ECO'
		BEGIN
		BEGIN TRY
		BEGIN TRANSACTION insertFA_ACTIVIDAD_ECO

			DECLARE @insetCodigo varchar(20), @insertNombre varchar(max),@insertNivel numeric				

			SELECT @insetCodigo=codigo,@insertNombre=nombre,@insertNivel=nivel FROM 
			OPENJSON(@json)
				WITH( 
				codigo VARCHAR(50) '$.codigo',
				nombre VARCHAR(max) '$.nombre',
				nivel numeric '$.nivel' 
			)
			IF(SELECT COUNT(1) FROM FA_ACTIVIDAD_ECO_PRUEBA WHERE codigo=@insetCodigo) = 0
			BEGIN	
					INSERT INTO FA_ACTIVIDAD_ECO_PRUEBA (codigo,nombre,nivel)
								VALUES(@insetCodigo,@insertNombre,@insertNivel)
			END

		COMMIT TRANSACTION insertFA_ACTIVIDAD_ECO
		END TRY
		BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION insertFA_ACTIVIDAD_ECO	
			SET @mensaje = ERROR_MESSAGE()
			RAISERROR (15600, -1, -1, @mensaje);
		END 
		END CATCH		
				
		END

		IF @nombreTable ='FA_mese'
		BEGIN
		BEGIN TRY
		BEGIN TRANSACTION insertFA_mese
							
				DECLARE @mes numeric =0, @nombre varchar(100)							
				SELECT @mes = mes, @nombre = nombre FROM 
				OPENJSON(@json)
					WITH( 
					mes VARCHAR(50) '$.mes',
					nombre VARCHAR(max) '$.nombre'					
				)

				IF(SELECT COUNT(1) FROM FA_mese_Prueba WHERE mes=@mes) = 0
				BEGIN
					INSERT INTO FA_mese_Prueba (mes,nombre)
							VALUES(@mes,@nombre)
				END
		COMMIT TRANSACTION insertFA_mese
		END TRY
		BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION insertFA_mese	
			SET @mensaje = ERROR_MESSAGE()
			RAISERROR (15600, -1, -1, @mensaje);
		END 
		END CATCH
				
		END
		
		IF @nombreTable = 'FA_AGENTE'
		BEGIN
			BEGIN TRY
			BEGIN TRANSACTION insertFA_AGENTE

			DECLARE @emp_id_empresa numeric, @nom_tipo_egte varchar(200),@RTF numeric, @RTI NUMERIC

				SELECT
				@emp_id_empresa=emp_id_empresa,
				@nom_tipo_egte=nom_tipo_egte,
				@RTF=RTF,
				@RTI=RTI
				FROM 
				OPENJSON(@json)
					WITH( 
					emp_id_empresa numeric '$.emp_id_empresa',
					nom_tipo_egte VARCHAR(max) '$.nom_tipo_egte',
					RTF numeric '$.RTF',
					RTI numeric '$.RTI' 
				)
				IF(SELECT COUNT(1) FROM FA_AGENTE_PRUEBA WHERE emp_id_empresa=@emp_id_empresa AND nom_tipo_egte=@nom_tipo_egte ) = 0
				BEGIN	
						INSERT INTO FA_AGENTE_PRUEBA (emp_id_empresa,nom_tipo_egte,RTF,RTI)
									VALUES(@emp_id_empresa,@nom_tipo_egte,@RTF,@RTI)
				END

			COMMIT TRANSACTION insertFA_AGENTE
			END TRY
			BEGIN CATCH
			IF (@@TRANCOUNT > 0)
			BEGIN
				ROLLBACK TRANSACTION insertFA_AGENTE
				SET @mensaje = ERROR_MESSAGE()
				RAISERROR (15600, -1, -1, @mensaje);
			END 
			END CATCH	
		END


	END

	IF @accion ='U'
	BEGIN
		IF @nombreTable='FA_ACTIVIDAD_ECO'
		BEGIN
		BEGIN TRY
		BEGIN TRANSACTION insertFA_ACTIVIDAD_ECO

			DECLARE @updateCodigo varchar(20), @updateNombre varchar(max),@updateNivel numeric				

			SELECT @insetCodigo=codigo,@insertNombre=nombre,@insertNivel=nivel FROM 
			OPENJSON(@json)
				WITH( 
				codigo VARCHAR(50) '$.codigo',
				nombre VARCHAR(max) '$.nombre',
				nivel numeric '$.nivel' 
			)
				
			UPDATE FA_ACTIVIDAD_ECO_PRUEBA SET nombre = @updateNombre, nivel = @updateNivel
			WHERE codigo = @updateCodigo

		COMMIT TRANSACTION insertFA_ACTIVIDAD_ECO
		END TRY
		BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION insertFA_ACTIVIDAD_ECO	
			SET @mensaje = ERROR_MESSAGE()
			RAISERROR (15600, -1, -1, @mensaje);
		END 
		END CATCH		
				
		END
		
		IF @nombreTable ='FA_mese'
		BEGIN
		BEGIN TRY
		BEGIN TRANSACTION insertFA_mese
							
				DECLARE @UpdateMes numeric =0, @UpdateNombreMes varchar(100)							
				SELECT @UpdateMes = mes, @UpdateNombreMes = nombre FROM 
				OPENJSON(@json)
					WITH( 
					mes VARCHAR(50) '$.mes',
					nombre VARCHAR(max) '$.nombre'					
				)

			
				UPDATE  FA_mese_Prueba SET nombre=@UpdateNombreMes
				WHERE mes = @UpdateMes
					
		COMMIT TRANSACTION insertFA_mese
		END TRY
		BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION insertFA_mese	
			SET @mensaje = ERROR_MESSAGE()
			RAISERROR (15600, -1, -1, @mensaje);
		END 
		END CATCH
				
		END
		
	END
	
END