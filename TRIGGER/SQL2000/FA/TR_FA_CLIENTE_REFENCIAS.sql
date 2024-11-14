IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_CLIENTE_REFENCIAS')
	DROP TRIGGER TR_FA_CLIENTE_REFENCIAS
GO

CREATE TRIGGER TR_FA_CLIENTE_REFENCIAS  
ON FA_CLIENTE_REFENCIAS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

		set @observacion ='EMP_ID_EMPRESA, COD_CLIENTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_CLIENTE FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_CLIENTE FROM deleted

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_CLIENTE_REFENCIAS'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_CLIENTE_REFENCIAS',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_CLIENTE_REFENCIAS_UP')
	DROP TRIGGER TR_FA_CLIENTE_REFENCIAS_UP
GO

CREATE TRIGGER TR_FA_CLIENTE_REFENCIAS_UP
ON FA_CLIENTE_REFENCIAS
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@codigo2 varchar(30),
			@observacion varchar(500),
			@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_CLIENTE FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_CLIENTE_REFENCIAS'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2)
	BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('FA_CLIENTE_REFENCIAS',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO