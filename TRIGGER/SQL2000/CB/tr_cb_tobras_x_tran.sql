USE SEICOII
GO

CREATE TRIGGER tr_cb_tobras_x_tran  
ON cb_tobras_x_tran 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,PRO_ID_PROYECTO,OBR_ID_OBRA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =PRO_ID_PROYECTO,@codigo4=OBR_ID_OBRA
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =PRO_ID_PROYECTO,@codigo4=OBR_ID_OBRA
	FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'cb_tobras_x_tran'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('cb_tobras_x_tran',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
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
		@codigo5 varchar(30)='',
		@observacion varchar(500),	
		@tipo char(1)

SET @observacion='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,PRO_ID_PROYECTO,OBR_ID_OBRA'


SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =PRO_ID_PROYECTO,@codigo4=OBR_ID_OBRA
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'cb_tobras_x_tran'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('cb_tobras_x_tran',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END

	
GO