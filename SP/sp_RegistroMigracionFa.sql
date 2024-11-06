IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RegistroMigracionFa]') AND type in (N'P', N'PC'))
	EXEC('CREATE PROCEDURE sp_RegistroMigracionFa AS')
GO

ALTER PROCEDURE sp_RegistroMigracionFa
@accion CHAR(3),
@json varchar(max),
@nombreTable varchar(200)		= NULL
AS
BEGIN
	
	IF @accion ='I'
	BEGIN

		BEGIN TRY
		BEGIN TRANSACTION insertFA_ACTIVIDAD_ECO

		IF @nombreTable='FA_ACTIVIDAD_ECO'
		BEGIN
				DECLARE @insetCodigo varchar(20), @insertNombre varchar(max),@insertNivel numeric				

				SELECT @insetCodigo=codigo,@insertNombre=nombre,@insertNivel=nivel FROM 
				OPENJSON(@json)
					WITH( 
					codigo VARCHAR(50) '$.codigo',
					nombre VARCHAR(max) '$.nombre',
					nivel numeric '$.nivel' 
				)	
				
				INSERT INTO FA_ACTIVIDAD_ECO_PRUEBA (codigo,nombre,nivel)
											VALUES(@insetCodigo,@insertNombre,@insertNivel)
		END

		IF @nombreTable ='FA_mese'
		BEGIN
							
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

				
		END
		COMMIT TRANSACTION insertFA_ACTIVIDAD_ECO
		END TRY
		BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRANSACTION insertFA_ACTIVIDAD_ECO	
			DECLARE @mensaje varchar(max) = ERROR_MESSAGE()
			RAISERROR (15600, -1, -1, @mensaje);
		END 
		END CATCH
	END

	
END