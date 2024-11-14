CREATE TRIGGER tr_CB_MTIPOS_TRANSACCIONES  
ON CB_MTIPOS_TRANSACCIONES 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2=TIP_ID_TRANSACCION 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA, @codigo2=TIP_ID_TRANSACCION
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status])
					VALUES('CB_MTIPOS_TRANSACCIONES',@tipo,@codigo,@codigo2,1)
END
GO

CREATE TRIGGER TR_CB_MTIPOS_TRANSACCIONES_UP
ON CB_MTIPOS_TRANSACCIONES
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA, @codigo2=TIP_ID_TRANSACCION
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status])
					VALUES('CB_MTIPOS_TRANSACCIONES',@tipo,@codigo,@codigo2,1)
	END
END

	
GO