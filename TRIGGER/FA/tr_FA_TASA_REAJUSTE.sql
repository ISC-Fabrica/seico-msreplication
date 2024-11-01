IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_FA_TASA_REAJUSTE')
	DROP TRIGGER tr_FA_TASA_REAJUSTE
GO

CREATE TRIGGER tr_FA_TASA_REAJUSTE  
ON FA_TASA_REAJUSTE 
AFTER INSERT,DELETE   
AS 

declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='SECUENCIA,EMPRESA,FCHA_INGRESA'

IF EXISTS (SELECT * FROM inserted)
BEGIN
	
	SELECT @codigo= SECUENCIA,@codigo2=EMPRESA,@codigo3=FCHA_INGRESA 
	FROM inserted
	order by SECUENCIA asc

	SET @tipo ='I'

END

IF  EXISTS (SELECT * FROM deleted)
BEGIN
	SELECT @codigo= SECUENCIA,@codigo2=EMPRESA,@codigo3=FCHA_INGRESA 
	FROM deleted
	order by SECUENCIA asc

	SET @tipo ='D'
END

IF @tipo IS NOT NULL AND @codigo !=''
BEGIN
	INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TASA_REAJUSTE',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_FA_TASA_REAJUSTE_UP')
	DROP TRIGGER TR_FA_TASA_REAJUSTE_UP
GO
CREATE TRIGGER TR_FA_TASA_REAJUSTE_UP
ON FA_TASA_REAJUSTE
AFTER UPDATE
AS

	declare @codigo varchar(30)='',
		@codigo2 varchar(30)='',
		@codigo3 varchar(30)='',
		@observacion varchar(max)='',
		@tipo char(1)

		SET @observacion='SECUENCIA,EMPRESA,FCHA_INGRESA'

BEGIN
	SELECT @codigo= SECUENCIA,@codigo2=EMPRESA ,@codigo3=FCHA_INGRESA
	FROM inserted
	order by SECUENCIA asc

	SET @tipo ='U'

	IF @codigo !=''
	BEGIN
				INSERT INTO temp_registroMigracion (nombre_table,tipo,codigo,codigo2,codigo3,[status],observacion)
					VALUES('FA_TASA_REAJUSTE',@tipo,@codigo,@codigo2,@codigo3,1,@observacion)
	END
END

	
GO