IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_AUD_FA_CLIENTE')
	DROP TRIGGER tr_AUD_FA_CLIENTE
GO

CREATE TRIGGER tr_AUD_FA_CLIENTE  
ON AUD_FA_CLIENTE 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),		
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

		SET @observacion='emp_id_empresa,COD_CLIENTE'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= emp_id_empresa,@codigo2=COD_CLIENTE
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=COD_CLIENTE 
	FROM deleted
	order by emp_id_empresa asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('AUD_FA_CLIENTE',@tipo,@codigo,@codigo2,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_AUD_FA_CLIENTE_UP')
	DROP TRIGGER TR_AUD_FA_CLIENTE_UP
GO
CREATE TRIGGER TR_AUD_FA_CLIENTE_UP
ON AUD_FA_CLIENTE
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@codigo2 varchar(30),		
			@observacion varchar(500),
			@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@observacion =''

		SET @observacion='emp_id_empresa,COD_CLIENTE'

BEGIN
	SELECT @codigo= emp_id_empresa,@codigo2=COD_CLIENTE
	FROM inserted
	order by emp_id_empresa asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,[status],observacion)
					VALUES('AUD_FA_CLIENTE',@tipo,@codigo,@codigo2,1,@observacion)
	END
END

	
GO