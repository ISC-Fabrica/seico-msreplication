CREATE TRIGGER tr_CB_TCAB_TRANSACCION  
ON CB_TCAB_TRANSACCION 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',		
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA ,@codigo2 =CTR_NRO_TRANSACCION,@codigo3=CTR_FECHA_INGRESO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA ,@codigo2 =CTR_NRO_TRANSACCION,@codigo3=CTR_FECHA_INGRESO
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status])
					VALUES('CB_TCAB_TRANSACCION',@tipo,@codigo,@codigo2,@codigo3,1)
END
GO

CREATE TRIGGER TR_CB_TCAB_TRANSACCION_UP
ON CB_TCAB_TRANSACCION
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			
			@tipo char(1)

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA ,@codigo2 =CTR_NRO_TRANSACCION,@codigo3=CTR_FECHA_INGRESO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status])
					VALUES('CB_TCAB_TRANSACCION',@tipo,@codigo,@codigo2,@codigo3,1)
	END
END

	
GO