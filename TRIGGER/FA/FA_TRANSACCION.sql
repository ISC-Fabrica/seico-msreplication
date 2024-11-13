IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TRANSACCION')
	DROP TRIGGER tr_FA_TRANSACCION
GO

CREATE TRIGGER tr_FA_TRANSACCION  
ON FA_TRANSACCION 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,num_factu'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=num_factu 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=num_factu 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_TRANSACCION' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TRANSACCION',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TRANSACCION_UP')
	DROP TRIGGER TR_FA_TRANSACCION_UP
GO
CREATE TRIGGER TR_FA_TRANSACCION_UP
ON FA_TRANSACCION
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA,num_factu'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=num_factu 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND @codigo2!=''
	BEGIN
				IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_TRANSACCION' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_TRANSACCION',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO