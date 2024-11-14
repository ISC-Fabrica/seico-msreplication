IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_tipo_transaccion')
	DROP TRIGGER TR_FA_tipo_transaccion
GO

CREATE TRIGGER TR_FA_tipo_transaccion  
ON FA_tipo_transaccion 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='codigo,tipo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= codigo,@codigo2=tipo 
	FROM inserted
	order by codigo asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= codigo,@codigo2=tipo 
	FROM deleted
	order by codigo asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_tipo_transaccion'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_tipo_transaccion',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_tipo_transaccion_UP')
	DROP TRIGGER TR_FA_tipo_transaccion_UP
GO
CREATE TRIGGER TR_FA_tipo_transaccion_UP
ON FA_tipo_transaccion
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='codigo,tipo'

BEGIN
	SELECT @codigo= codigo,@codigo2=tipo 
	FROM inserted
	order by codigo asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_tipo_transaccion'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_tipo_transaccion',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO