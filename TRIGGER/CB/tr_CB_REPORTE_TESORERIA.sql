CREATE TRIGGER tr_CB_REPORTE_TESORERIA  
ON CB_REPORTE_TESORERIA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= pk_Id FROM inserted
	order by pk_Id asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= pk_Id FROM deleted
	order by pk_Id asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('CB_REPORTE_TESORERIA',@tipo,@codigo,1)
END
GO

CREATE TRIGGER TR_CB_REPORTE_TESORERIA_UP
ON CB_REPORTE_TESORERIA
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= pk_Id FROM inserted
	order by pk_Id asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('CB_REPORTE_TESORERIA',@tipo,@codigo,1)
	END
END

	
GO