IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_cuentas_x_cobrar')
	DROP TRIGGER tr_FA_cuentas_x_cobrar
GO
CREATE TRIGGER tr_FA_cuentas_x_cobrar  
ON FA_cuentas_x_cobrar 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=num_factura,@codigo3=cli_codigo,@codigo4=cod_banco 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=num_factura,@codigo3=cli_codigo,@codigo4=cod_banco 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_cuentas_x_cobrar',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_cuentas_x_cobrar_UP')
	DROP TRIGGER TR_FA_cuentas_x_cobrar_UP
GO

CREATE TRIGGER TR_FA_cuentas_x_cobrar_UP
ON FA_cuentas_x_cobrar
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@codigo4 varchar(30)='',
			@observacion varchar(max)='',
			@tipo char(1)

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=num_factura,@codigo3=cli_codigo,@codigo4=cod_banco 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,[status],observacion)
					VALUES('FA_cuentas_x_cobrar',@tipo,@codigo,@codigo2,@codigo3,@codigo4,1,@observacion)
	END
END

	
GO