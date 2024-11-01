IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_CXCOBRAR')
	DROP TRIGGER tr_FA_CXCOBRAR
GO
CREATE TRIGGER tr_FA_CXCOBRAR  
ON FA_CXCOBRAR 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo varchar(10)

		SET @observacion='EMP_ID_EMPRESA, tipo, Num_factura, cod_cliente, cod_banco'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura,@codigo4=cod_cliente,@codigo5=cod_banco 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura,@codigo4=cod_cliente,@codigo5=cod_banco 
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('FA_CXCOBRAR',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_CXCOBRAR_UP')
	DROP TRIGGER TR_FA_CXCOBRAR_UP
GO
CREATE TRIGGER TR_FA_CXCOBRAR_UP
ON FA_CXCOBRAR
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@codigo4 varchar(30)='',
		@codigo5 varchar(30)='',
		@observacion varchar(max)='',
		@tipo varchar(10)

		SET @observacion='EMP_ID_EMPRESA, tipo, Num_factura, cod_cliente, cod_banco'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura,@codigo4=cod_cliente,@codigo5=cod_banco 
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,codigo4,codigo5,[status],observacion)
					VALUES('FA_CXCOBRAR',@tipo,@codigo,@codigo2,@codigo3,@codigo4,@codigo5,1,@observacion)
	END
END

	
GO