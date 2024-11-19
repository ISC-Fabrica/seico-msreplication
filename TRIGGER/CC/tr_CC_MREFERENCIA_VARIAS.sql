IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_CC_MREFERENCIA_VARIAS')
	DROP TRIGGER tr_CC_MREFERENCIA_VARIAS
GO

CREATE TRIGGER tr_CC_MREFERENCIA_VARIAS  
ON CC_MREFERENCIA_VARIAS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,TRC_ID_REFERENCIA_VARIAS,TRC_CLIENTE,TRC_TIPO_REFERENCIA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=TRC_ID_REFERENCIA_VARIAS,@codigo3=TRC_CLIENTE,@codigo4=TRC_TIPO_REFERENCIA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=TRC_ID_REFERENCIA_VARIAS,@codigo3=TRC_CLIENTE,@codigo4=TRC_TIPO_REFERENCIA
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!=''
BEGIN
		IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_MREFERENCIA_VARIAS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CC_MREFERENCIA_VARIAS',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_CC_MREFERENCIA_VARIAS_UP')
	DROP TRIGGER TR_CC_MREFERENCIA_VARIAS_UP
GO

CREATE TRIGGER TR_CC_MREFERENCIA_VARIAS_UP
ON CC_MREFERENCIA_VARIAS
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,TRC_ID_REFERENCIA_VARIAS,TRC_CLIENTE,TRC_TIPO_REFERENCIA'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=TRC_ID_REFERENCIA_VARIAS,@codigo3=TRC_CLIENTE,@codigo4=TRC_TIPO_REFERENCIA
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!='' AND @codigo3!='' AND @codigo4!=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'CC_MREFERENCIA_VARIAS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2 AND codigo3=@codigo3 AND codigo4=@codigo4) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('CC_MREFERENCIA_VARIAS',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO