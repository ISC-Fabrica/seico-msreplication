USE SEICOII
GO

CREATE TRIGGER tr_CB_TCAB_TRANSACCION  
ON CB_TCAB_TRANSACCION 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',	
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,CCP_SEC_COMPROBANTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA ,@codigo2 =CTR_NRO_TRANSACCION,@codigo3=CCP_SEC_COMPROBANTE
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA ,@codigo2 =CTR_NRO_TRANSACCION,@codigo3=CTR_FECHA_INGRESO
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CB_TCAB_TRANSACCION'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_TCAB_TRANSACCION',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

CREATE TRIGGER TR_CB_TCAB_TRANSACCION_UP
ON CB_TCAB_TRANSACCION
AFTER UPDATE
AS

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',	
		@observacion varchar(500),	
		@tipo char(1)

SET @observacion='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,CCP_SEC_COMPROBANTE'

SELECT  @codigo= EMP_ID_EMPRESA ,@codigo2 =CTR_NRO_TRANSACCION,@codigo3=CCP_SEC_COMPROBANTE
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CB_TCAB_TRANSACCION'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CB_TCAB_TRANSACCION',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END

	
GO