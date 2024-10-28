CREATE TRIGGER tr_CB_MCONCEPTOS  
ON CB_MCONCEPTOS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2 =TIP_ID_TRANSACCION,@codigo3=CON_ID_CONCEPTO  
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2 =TIP_ID_TRANSACCION,@codigo3=CON_ID_CONCEPTO 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status])
					VALUES('CB_MCONCEPTOS',@tipo,@codigo,@codigo2,@codigo3,1)
END
GO

CREATE TRIGGER TR_CB_MCONCEPTOS_UP
ON CB_MCONCEPTOS
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@tipo char(1)

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2 =TIP_ID_TRANSACCION,@codigo3=CON_ID_CONCEPTO 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status])
					VALUES('CB_MCONCEPTOS',@tipo,@codigo,@codigo2,@codigo3,1)
	END
END

	
GO