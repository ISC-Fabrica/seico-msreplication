USE SEICOII
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_TDET_TRANSACCION')
	DROP TRIGGER TR_CG_TDET_TRANSACCION
GO

CREATE TRIGGER TR_CG_TDET_TRANSACCION  
ON  CG_TDET_TRANSACCION
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,DTR_SECUENCIA,CRE_ID_CTRO_RESPONSABILIDAD,CTA_CODIGO_CUENTA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =DTR_SECUENCIA,@codigo4=CRE_ID_CTRO_RESPONSABILIDAD,@codigo5=CTA_CODIGO_CUENTA
	FROM inserted

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =DTR_SECUENCIA,@codigo4=CRE_ID_CTRO_RESPONSABILIDAD,@codigo5=CTA_CODIGO_CUENTA
	FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4 !='' AND @codigo5 !='' AND 
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_TDET_TRANSACCION'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4 AND codigo5 = @codigo5)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
				VALUES('CG_TDET_TRANSACCION',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_CG_TDET_TRANSACCION_UP')
	DROP TRIGGER TR_CG_TDET_TRANSACCION_UP
GO

CREATE TRIGGER TR_CG_TDET_TRANSACCION_UP
ON CG_TDET_TRANSACCION
AFTER UPDATE
AS

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@codigo4 varchar(30),
		@codigo5 varchar(30),
		@observacion varchar(500),	
		@tipo char(1)
		
SET @observacion='EMP_ID_EMPRESA,CTR_NRO_TRANSACCION,DTR_SECUENCIA,CRE_ID_CTRO_RESPONSABILIDAD,CTA_CODIGO_CUENTA'


SELECT  @codigo= EMP_ID_EMPRESA,@codigo2=CTR_NRO_TRANSACCION,@codigo3 =DTR_SECUENCIA,@codigo4=CRE_ID_CTRO_RESPONSABILIDAD,@codigo5=CTA_CODIGO_CUENTA
FROM inserted

SET @tipo ='U'

IF @codigo !='' and @codigo2 !='' and @codigo3 !='' AND @codigo4!='' AND @codigo5!='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'CG_TDET_TRANSACCION'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3 AND codigo4 = @codigo4 AND codigo5 = @codigo5)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
				VALUES('CG_TDET_TRANSACCION',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END


	
GO