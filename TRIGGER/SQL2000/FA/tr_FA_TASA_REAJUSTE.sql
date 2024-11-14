IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'tr_FA_TASA_REAJUSTE')
	DROP TRIGGER TR_FA_TASA_REAJUSTE
GO

CREATE TRIGGER TR_FA_TASA_REAJUSTE  
ON FA_TASA_REAJUSTE 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='SECUENCIA,EMPRESA,FCHA_INGRESA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= SECUENCIA,@codigo2=EMPRESA,@codigo3=convert(varchar, FCHA_INGRESA, 121) 
	FROM inserted
	order by SECUENCIA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= SECUENCIA,@codigo2=EMPRESA,@codigo3=convert(varchar, FCHA_INGRESA, 121) 
	FROM deleted
	order by SECUENCIA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_TASA_REAJUSTE'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TASA_REAJUSTE',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' and name = 'TR_FA_TASA_REAJUSTE_UP')
	DROP TRIGGER TR_FA_TASA_REAJUSTE_UP
GO
CREATE TRIGGER TR_FA_TASA_REAJUSTE_UP
ON FA_TASA_REAJUSTE
AFTER UPDATE
AS

	declare @codigo varchar(30),
		@codigo2 varchar(30),
		@codigo3 varchar(30),
		@observacion varchar(500),
		@tipo char(1)

		SET @observacion='SECUENCIA,EMPRESA,FCHA_INGRESA'

BEGIN
	SELECT @codigo= SECUENCIA,@codigo2=EMPRESA ,@codigo3=convert(varchar, FCHA_INGRESA, 121)
	FROM inserted
	order by SECUENCIA asc

	SET @tipo ='U'

	IF @codigo !='' AND
		   NOT EXISTS (SELECT 1 FROM temp_registroMigrado WHERE nombre_table = 'FA_TASA_REAJUSTE'
					   AND tipo = @tipo AND codigo = @codigo AND codigo2 = @codigo2 AND codigo3 = @codigo3)
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TASA_REAJUSTE',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO