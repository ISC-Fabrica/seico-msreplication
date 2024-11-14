IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_CXCOBRAR_HIST')
	DROP TRIGGER TR_FA_CXCOBRAR_HIST
GO

CREATE TRIGGER TR_FA_CXCOBRAR_HIST  
ON FA_CXCOBRAR_HIST 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
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

IF @tipo IS NOT NULL AND @codigo !='' AND
   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_CXCOBRAR_HIST'
               AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_CXCOBRAR_HIST',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_CXCOBRAR_HIST_UP')
	DROP TRIGGER TR_FA_CXCOBRAR_HIST_UP
GO

CREATE TRIGGER TR_FA_CXCOBRAR_HIST_UP
ON FA_CXCOBRAR_HIST
AFTER UPDATE
AS

	declare @codigo varchar(30),
			@codigo2 varchar(30),
			@codigo3 varchar(30),
			@tipo char(1),
			@observacion varchar(500)
			SET @observacion='EMP_ID_EMPRESA, tipo, Num_factura'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=tipo,@codigo3=Num_factura FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_CXCOBRAR_HIST'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
	BEGIN
		INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_CXCOBRAR_HIST',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO