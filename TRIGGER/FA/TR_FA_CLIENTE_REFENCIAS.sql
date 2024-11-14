IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_CLIENTE_REFENCIAS')
	DROP TRIGGER tr_FA_CLIENTE_REFENCIAS
GO

CREATE TRIGGER tr_FA_CLIENTE_REFENCIAS  
ON FA_CLIENTE_REFENCIAS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		set @observacion ='EMP_ID_EMPRESA,COD_CLIENTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_CLIENTE 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_CLIENTE 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !=''
BEGIN
	IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_CLIENTE_REFENCIAS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_CLIENTE_REFENCIAS',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_CLIENTE_REFENCIAS_UP')
	DROP TRIGGER TR_FA_CLIENTE_REFENCIAS_UP
GO

CREATE TRIGGER TR_FA_CLIENTE_REFENCIAS_UP
ON FA_CLIENTE_REFENCIAS
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@observacion varchar(max)='',
			@tipo char(1)

			set @observacion ='EMP_ID_EMPRESA,COD_CLIENTE'

BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_CLIENTE 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2 !=''
	BEGIN
			IF(SELECT COUNT(1) FROM temp_registroMigracion where nombre_table = 'FA_CLIENTE_REFENCIAS' AND tipo=@tipo AND codigo=@codigo AND codigo2=@codigo2) = 0
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_CLIENTE_REFENCIAS',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO