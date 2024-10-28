CREATE TRIGGER tr_cb_tobras_x_tran  
ON cb_tobras_x_tran 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =CTR_FECHA_INGRESO,@codigo4=OXT_INDICE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =CTR_FECHA_INGRESO,@codigo4=OXT_INDICE
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status])
					VALUES('cb_tobras_x_tran',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1)
END
GO

CREATE TRIGGER TR_cb_tobras_x_tran_UP
ON cb_tobras_x_tran
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@codigo4 varchar(30)='',		
			@tipo char(1)

BEGIN
	SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =CTR_FECHA_INGRESO,@codigo4=OXT_INDICE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status])
					VALUES('cb_tobras_x_tran',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1)
	END
END

	
GO