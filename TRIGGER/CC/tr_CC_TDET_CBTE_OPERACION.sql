IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_CBTE_OPERACION')
	DROP TRIGGER tr_CC_TDET_CBTE_OPERACION
GO

CREATE TRIGGER tr_CC_TDET_CBTE_OPERACION  
ON CC_TDET_CBTE_OPERACION 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,OPE_NUMERO,ODC_SEC'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=ODC_SEC
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=ODC_SEC
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_CBTE_OPERACION' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TDET_CBTE_OPERACION',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_CBTE_OPERACION_UP')
	DROP TRIGGER tr_CC_TDET_CBTE_OPERACION_UP
GO

CREATE TRIGGER tr_CC_TDET_CBTE_OPERACION_UP
ON CC_TDET_CBTE_OPERACION
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',		
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,OPE_NUMERO,ODC_SEC'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=OPE_NUMERO,@codigo3=ODC_SEC
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_CBTE_OPERACION' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TDET_CBTE_OPERACION',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO