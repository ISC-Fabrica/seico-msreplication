IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TIPO_TRANSACCION_UAF')
	DROP TRIGGER tr_FA_TIPO_TRANSACCION_UAF
GO

CREATE TRIGGER tr_FA_TIPO_TRANSACCION_UAF  
ON FA_TIPO_TRANSACCION_UAF 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
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

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TIPO_TRANSACCION_UAF',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TIPO_TRANSACCION_UAF_UP')
	DROP TRIGGER TR_FA_TIPO_TRANSACCION_UAF_UP
GO
CREATE TRIGGER TR_FA_TIPO_TRANSACCION_UAF_UP
ON FA_TIPO_TRANSACCION_UAF
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='codigo,tipo'

BEGIN
	SELECT @codigo= codigo,@codigo2=tipo 
	FROM inserted
	order by codigo asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TIPO_TRANSACCION_UAF',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO