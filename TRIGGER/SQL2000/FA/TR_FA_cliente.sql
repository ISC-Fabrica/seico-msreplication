IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_cliente')
	DROP TRIGGER TR_FA_cliente
GO
CREATE TRIGGER TR_FA_cliente  
ON FA_cliente 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)
		
select  @codigo ='',
		@codigo2 ='',
		@codigo3 ='',
		@observacion =''

		SET @observacion ='EMP_ID_EMPRESA,cli_codigo,cli_cedula'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cli_codigo,@codigo3=cli_cedula FROM inserted
	order by cli_codigo asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cli_codigo,@codigo3=cli_cedula FROM deleted
	order by cli_codigo asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!='' AND
   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_cliente'
               AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_cliente',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO



IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_cliente_UP')
	DROP TRIGGER TR_FA_cliente_UP
GO
CREATE TRIGGER TR_FA_cliente_UP
ON FA_cliente
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@codigo2 varchar(30),
			@codigo3 varchar(30),
			@observacion varchar(500),
			@tipo char(1)
			
select  @codigo ='',
		@codigo2 ='',
		@codigo3 ='',
		@observacion =''

			SET @observacion ='EMP_ID_EMPRESA,cli_codigo,cli_cedula'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cli_codigo,@codigo3=cli_cedula FROM inserted

	SET @tipo ='U'

	IF @codigo !='' AND
		NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_cliente'
					AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_cliente',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO