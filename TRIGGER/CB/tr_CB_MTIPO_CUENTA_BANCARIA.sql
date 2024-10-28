CREATE TRIGGER tr_CB_MTIPO_CUENTA_BANCARIA  
ON CB_MTIPO_CUENTA_BANCARIA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= TCB_ID_TIPO FROM inserted
	order by TCB_ID_TIPO asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= TCB_ID_TIPO FROM deleted
	order by TCB_ID_TIPO asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('CB_MTIPO_CUENTA_BANCARIA',@tipo,@codigo,1)
END
GO

CREATE TRIGGER TR_CB_MTIPO_CUENTA_BANCARIA_UP
ON CB_MTIPO_CUENTA_BANCARIA
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= TCB_ID_TIPO FROM inserted
	order by TCB_ID_TIPO asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,[status])
					VALUES('CB_MTIPO_CUENTA_BANCARIA',@tipo,@codigo,1)
	END
END

	
GO