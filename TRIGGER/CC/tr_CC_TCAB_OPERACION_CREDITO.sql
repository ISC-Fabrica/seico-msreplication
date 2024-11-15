IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TCAB_OPERACION_CREDITO')
	DROP TRIGGER tr_CC_TCAB_OPERACION_CREDITO
GO

CREATE TRIGGER tr_CC_TCAB_OPERACION_CREDITO  
ON CC_TCAB_OPERACION_CREDITO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,OPE_NUMERO,CLI_ID_CLIENTE,FIN_ID_FINANCIAMIENTO'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=CLI_ID_CLIENTE,@codigo4=FIN_ID_FINANCIAMIENTO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=CLI_ID_CLIENTE,@codigo4=FIN_ID_FINANCIAMIENTO
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TCAB_OPERACION_CREDITO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CC_TCAB_OPERACION_CREDITO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CC_TCAB_OPERACION_CREDITO_UP')
	DROP TRIGGER TR_CC_TCAB_OPERACION_CREDITO_UP
GO

CREATE TRIGGER TR_CC_TCAB_OPERACION_CREDITO_UP
ON CC_TCAB_OPERACION_CREDITO
AFTER UPDATE
AS

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,OPE_NUMERO,CLI_ID_CLIENTE,FIN_ID_FINANCIAMIENTO'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=CLI_ID_CLIENTE,@codigo4=FIN_ID_FINANCIAMIENTO
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TCAB_OPERACION_CREDITO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CC_TCAB_OPERACION_CREDITO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO