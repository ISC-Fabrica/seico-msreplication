IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_CXCOBRAR_HIST')
	DROP TRIGGER tr_FA_CXCOBRAR_HIST
GO

CREATE TRIGGER tr_FA_CXCOBRAR_HIST  
ON FA_CXCOBRAR_HIST 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='EMP_ID_EMPRESA, tipo, Num_factura'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_CXCOBRAR_HIST',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_CXCOBRAR_HIST_UP')
	DROP TRIGGER TR_FA_CXCOBRAR_HIST_UP
GO

CREATE TRIGGER TR_FA_CXCOBRAR_HIST_UP
ON FA_CXCOBRAR_HIST
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
			@codigo2 varchar(30)='',
			@codigo3 varchar(30)='',
			@tipo char(1),
			@observacion varchar(max)
			SET @observacion='EMP_ID_EMPRESA, tipo, Num_factura'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_CXCOBRAR_HIST',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO