IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TIPO_DOCUMENTO')
	DROP TRIGGER tr_FA_TIPO_DOCUMENTO
GO

CREATE TRIGGER tr_FA_TIPO_DOCUMENTO  
ON FA_TIPO_DOCUMENTO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='cod,tipo'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= cod,@codigo2=tipo 
	FROM inserted
	order by cod asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= cod,@codigo2=tipo 
	FROM deleted
	order by cod asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!=''
BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_TIPO_DOCUMENTO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TIPO_DOCUMENTO',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TIPO_DOCUMENTO_UP')
	DROP TRIGGER TR_FA_TIPO_DOCUMENTO_UP
GO
CREATE TRIGGER TR_FA_TIPO_DOCUMENTO_UP
ON FA_TIPO_DOCUMENTO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='cod,tipo'

BEGIN
	SELECT @codigo= cod,@codigo2=tipo 
	FROM inserted
	order by cod asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_TIPO_DOCUMENTO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TIPO_DOCUMENTO',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO