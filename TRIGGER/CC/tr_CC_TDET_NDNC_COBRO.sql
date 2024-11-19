IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_NDNC_COBRO')
	DROP TRIGGER tr_CC_TDET_NDNC_COBRO
GO

CREATE TRIGGER tr_CC_TDET_NDNC_COBRO  
ON CC_TDET_NDNC_COBRO 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,COB_NUMERO,DCB_SECUENCIA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=DCB_SECUENCIA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=DCB_SECUENCIA
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_NDNC_COBRO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TDET_NDNC_COBRO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TDET_NDNC_COBRO_UP')
	DROP TRIGGER tr_CC_TDET_NDNC_COBRO_UP
GO

CREATE TRIGGER tr_CC_TDET_NDNC_COBRO_UP
ON CC_TDET_NDNC_COBRO
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',		
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,COB_NUMERO,DCB_SECUENCIA'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COB_NUMERO,@codigo3=DCB_SECUENCIA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TDET_NDNC_COBRO' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TDET_NDNC_COBRO',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO