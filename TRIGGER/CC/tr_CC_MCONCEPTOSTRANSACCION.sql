IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_MCONCEPTOSTRANSACCION')
	DROP TRIGGER tr_CC_MCONCEPTOSTRANSACCION
GO

CREATE TRIGGER tr_CC_MCONCEPTOSTRANSACCION  
ON CC_MCONCEPTOSTRANSACCION 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CON_ID_CONCEPTOSTRANSACCION'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CON_ID_CONCEPTOSTRANSACCION
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CON_ID_CONCEPTOSTRANSACCION
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_MCONCEPTOSTRANSACCION' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('CC_MCONCEPTOSTRANSACCION',@tipo,@codigo,@codigo2,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CC_MCONCEPTOSTRANSACCION_UP')
	DROP TRIGGER TR_CC_MCONCEPTOSTRANSACCION_UP
GO

CREATE TRIGGER TR_CC_MCONCEPTOSTRANSACCION_UP
ON CC_MCONCEPTOSTRANSACCION
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,CON_ID_CONCEPTOSTRANSACCION'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=CON_ID_CONCEPTOSTRANSACCION
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_MCONCEPTOSTRANSACCION' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('CC_MCONCEPTOSTRANSACCION',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO