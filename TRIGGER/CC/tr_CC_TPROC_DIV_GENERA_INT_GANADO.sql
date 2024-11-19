IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TPROC_DIV_GENERA_INT_GANADO')
	DROP TRIGGER tr_CC_TPROC_DIV_GENERA_INT_GANADO
GO

CREATE TRIGGER tr_CC_TPROC_DIV_GENERA_INT_GANADO  
ON CC_TPROC_DIV_GENERA_INT_GANADO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,NUM_PROC_INTGAN,CCP_SEC_COMPROBANTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=NUM_PROC_INTGAN,@codigo3=CCP_SEC_COMPROBANTE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
		SELECT @codigo= EMP_ID_EMPRESA,@codigo2=NUM_PROC_INTGAN,@codigo3=CCP_SEC_COMPROBANTE
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TPROC_DIV_GENERA_INT_GANADO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TPROC_DIV_GENERA_INT_GANADO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TPROC_DIV_GENERA_INT_GANADO_UP')
	DROP TRIGGER tr_CC_TPROC_DIV_GENERA_INT_GANADO_UP
GO

CREATE TRIGGER tr_CC_TPROC_DIV_GENERA_INT_GANADO_UP
ON CC_TPROC_DIV_GENERA_INT_GANADO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',		
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,NUM_PROC_INTGAN,CCP_SEC_COMPROBANTE'

BEGIN
		SELECT @codigo= EMP_ID_EMPRESA,@codigo2=NUM_PROC_INTGAN,@codigo3=CCP_SEC_COMPROBANTE
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TPROC_DIV_GENERA_INT_GANADO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TPROC_DIV_GENERA_INT_GANADO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO