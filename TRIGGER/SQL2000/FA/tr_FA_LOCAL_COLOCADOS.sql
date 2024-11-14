
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_LOCAL_COLOCADOS')
	DROP TRIGGER TR_FA_LOCAL_COLOCADOS
GO

CREATE TRIGGER TR_FA_LOCAL_COLOCADOS  
ON FA_LOCAL_COLOCADOS 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion ='EMP_ID_EMPRESA,COD_LOCAL,COD_INTER_LOCAL'
IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_LOCAL,@codigo3=COD_INTER_LOCAL
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_LOCAL,@codigo3=COD_INTER_LOCAL
	FROM deleted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_LOCAL_COLOCADOS'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
			INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
				VALUES('FA_LOCAL_COLOCADOS',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_LOCAL_COLOCADOS_UP')
	DROP TRIGGER TR_FA_LOCAL_COLOCADOS_UP
GO

CREATE TRIGGER TR_FA_LOCAL_COLOCADOS_UP
ON FA_LOCAL_COLOCADOS
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		set @observacion ='EMP_ID_EMPRESA,COD_LOCAL,COD_INTER_LOCAL'

BEGIN
	SELECT @codigo= EMP_ID_EMPRESA,@codigo2=COD_LOCAL,@codigo3=COD_INTER_LOCAL
	FROM inserted
	order by EMP_ID_EMPRESA asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_LOCAL_COLOCADOS'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_LOCAL_COLOCADOS',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO