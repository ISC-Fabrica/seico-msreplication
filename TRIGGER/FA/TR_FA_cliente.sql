IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_cliente')
	DROP TRIGGER tr_FA_cliente
GO
CREATE TRIGGER tr_FA_cliente  
ON FA_cliente 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion ='EMP_ID_EMPRESA,cli_codigo,cli_cedula'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cli_codigo,@codigo3=cli_cedula 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cli_codigo,@codigo=cli_cedula 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_cliente',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO



IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_cliente_UP')
	DROP TRIGGER TR_FA_cliente_UP
GO
CREATE TRIGGER TR_FA_cliente_UP
ON FA_cliente
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@observacion varchar(max)='',
			@tipo char(1)

			SET @observacion ='EMP_ID_EMPRESA,cli_codigo,cli_cedula'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=cli_codigo,@codigo3=cli_cedula 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @tipo IS NOT NULL AND @codigo !='' AND @codigo2!='' AND @codigo3!=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_cliente',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO