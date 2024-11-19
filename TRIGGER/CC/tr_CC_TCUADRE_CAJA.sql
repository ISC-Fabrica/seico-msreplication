IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TCUADRE_CAJA')
	DROP TRIGGER tr_CC_TCUADRE_CAJA
GO

CREATE TRIGGER tr_CC_TCUADRE_CAJA  
ON CC_TCUADRE_CAJA 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CUA_NUMERO,CAJ_ID_CAJA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CUA_NUMERO,@codigo3=CAJ_ID_CAJA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CUA_NUMERO,@codigo3=CAJ_ID_CAJA
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TCUADRE_CAJA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TCUADRE_CAJA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_TCUADRE_CAJA_UP')
	DROP TRIGGER tr_CC_TCUADRE_CAJA_UP
GO

CREATE TRIGGER tr_CC_TCUADRE_CAJA_UP
ON CC_TCUADRE_CAJA
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',		
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CUA_NUMERO,CAJ_ID_CAJA'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CUA_NUMERO,@codigo3=CAJ_ID_CAJA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' 
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_TCUADRE_CAJA' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('CC_TCUADRE_CAJA',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO