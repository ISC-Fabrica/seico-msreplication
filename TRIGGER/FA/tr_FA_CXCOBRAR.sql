CREATE TRIGGER tr_FA_CXCOBRAR  
ON FA_CXCOBRAR 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= factura_id FROM inserted
	order by factura_id asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= factura_id FROM deleted
	order by factura_id asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('FA_CXCOBRAR',@tipo,@codigo,1)
END
GO

CREATE TRIGGER TR_FA_CXCOBRAR_UP
ON FA_CXCOBRAR
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= factura_id FROM inserted
	order by factura_id asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('FA_CXCOBRAR',@tipo,@codigo,1)
	END
END

	
GO