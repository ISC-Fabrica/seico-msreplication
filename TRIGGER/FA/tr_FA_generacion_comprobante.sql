IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_generacion_comprobante')
	DROP TRIGGER tr_FA_generacion_comprobante
GO

CREATE TRIGGER tr_FA_generacion_comprobante  
ON FA_generacion_comprobante 
AFTER INSERT,DELETE   
AS 
BEGIN
	BEGIN TRY

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		set @observacion='EMP_ID_EMPRESA,gco_numero,gco_tipo'

		IF EXISTS (SELECT * FROM inserted)
		BEGIN
	
			SELECT @codigo= EMP_ID_EMPRESA,@codigo2=gco_numero,@codigo3=gco_tipo 
			FROM inserted
			order by EMP_ID_EMPRESA asc

			SET @tipo ='I'

		END

		IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=gco_numero,@codigo3=gco_tipo 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN

	IF (SELECT COUNT(1) FROM temp_registroMigracion WHERE codigo=@codigo and codigo2=@codigo2 and codigo3=@codigo3) = 0
	BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_generacion_comprobante',99999999999999999999,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

END TRY
BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(MAX)
		DECLARE @ErrorStatus VARCHAR(MAX)
		SET @ErrorMessage=ERROR_MESSAGE()
		SET @ErrorStatus = ERROR_STATE()

        INSERT INTO LOG_TRIGGERS (observacion,nombreTrigger,codStatus)
        VALUES (@ErrorMessage,'tr_FA_generacion_comprobante',@ErrorStatus)
END CATCH
END
GO




IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_generacion_comprobante_UP')
	DROP TRIGGER TR_FA_generacion_comprobante_UP
GO

CREATE TRIGGER TR_FA_generacion_comprobante_UP
ON FA_generacion_comprobante
AFTER UPDATE
AS
BEGIN
BEGIN TRY
	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		set @observacion='EMP_ID_EMPRESA,gco_numero,gco_tipo'


	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=gco_numero,@codigo3=gco_tipo 
	from inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_generacion_comprobante',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
	END TRY
	BEGIN CATCH
			DECLARE @ErrorMessage VARCHAR(MAX)
			DECLARE @ErrorStatus VARCHAR(MAX)
			SET @ErrorMessage=ERROR_MESSAGE()
			SET @ErrorStatus = ERROR_STATE()

			INSERT INTO LOG_TRIGGERS (observacion,nombreTrigger,codStatus)
			VALUES (@ErrorMessage,'tr_FA_generacion_comprobante',@ErrorStatus)
	END CATCH
END	
GO