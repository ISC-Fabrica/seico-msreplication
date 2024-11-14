IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_MCAJA')
	DROP TRIGGER tr_CC_MCAJA
GO

CREATE TRIGGER tr_CC_MCAJA  
ON CC_MCAJA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CAJ_ID_CAJA,CRE_ID_CTRO_RESPONSABILIDAD'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CAJ_ID_CAJA,@codigo3=CRE_ID_CTRO_RESPONSABILIDAD
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CAJ_ID_CAJA,@codigo3=CRE_ID_CTRO_RESPONSABILIDAD
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' 
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_MCAJA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_MCAJA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CC_MCAJA_UP')
	DROP TRIGGER TR_CC_MCAJA_UP
GO

CREATE TRIGGER TR_CC_MCAJA_UP
ON CC_MCAJA
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CAJ_ID_CAJA,CRE_ID_CTRO_RESPONSABILIDAD'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CAJ_ID_CAJA,@codigo3=CRE_ID_CTRO_RESPONSABILIDAD
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_MCAJA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_MCAJA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO