IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TCAB_COBRO')
	DROP TRIGGER tr_CC_TCAB_COBRO
GO

CREATE TRIGGER tr_CC_TCAB_COBRO  
ON CC_TCAB_COBRO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,COB_NUMERO,CAJ_ID_CAJA,CLI_ID_CLIENTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=CAJ_ID_CAJA,@codigo4=CLI_ID_CLIENTE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=CAJ_ID_CAJA,@codigo4=CLI_ID_CLIENTE
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TCAB_COBRO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CC_TCAB_COBRO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CC_TCAB_COBRO_UP')
	DROP TRIGGER TR_CC_TCAB_COBRO_UP
GO

CREATE TRIGGER TR_CC_TCAB_COBRO_UP
ON CC_TCAB_COBRO
AFTER UPDATE
AS

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,COB_NUMERO,CAJ_ID_CAJA,CLI_ID_CLIENTE'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=CAJ_ID_CAJA,@codigo4=CLI_ID_CLIENTE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TCAB_COBRO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CC_TCAB_COBRO',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO